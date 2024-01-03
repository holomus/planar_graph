create or replace package Ui_Vhr502 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Email_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Personal(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Contacts(p Hashmap);
end Ui_Vhr502;
/
create or replace package body Ui_Vhr502 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR502:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_nationalities',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);

    q.Number_Field('nationality_id');
    q.Varchar2_Field('name');

    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Phone(i_Company_Id => Ui.Company_Id,
                                        i_Person_Id  => p.r_Number('person_id'),
                                        i_Phone      => p.r_Varchar2('main_phone'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Email_Is_Unique(p Hashmap) return varchar2 is
    v_Email Md_Persons.Email%type := p.r_Varchar2('email');
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Md_Persons,
                                  i_Column       => z.Email,
                                  i_Column_Value => v_Email);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Person_Statuses(i_Employee_Id number) return Arraylist is
    v_Curr_Date date := Trunc(sysdate);
    v_Statuses  Matrix_Varchar2;
  begin
    with Filial_Statuses as
     (select f.Company_Id,
             f.Filial_Id,
             f.Name Filial_Name,
             m.Employee_Id,
             (select s.Staff_Id
                from Href_Staffs s
               where s.Company_Id = m.Company_Id
                 and s.Filial_Id = m.Filial_Id
                 and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and s.Employee_Id = m.Employee_Id
                 and s.State = 'A'
               order by s.Hiring_Date desc
               fetch first 1 row only) Staff_Id
        from Md_Filials f
        join Mhr_Employees m
          on m.Company_Id = f.Company_Id
         and m.Filial_Id = f.Filial_Id
       where f.Company_Id = Ui.Company_Id
         and f.State = 'A'
         and m.Employee_Id = i_Employee_Id
         and m.State = 'A')

    --------------------------------------------------
    -- filial_name, status, status_name, division_name, job_title,
    -- dismissal_date, dismissal_reason_type, dismissal_reason_name
    --------------------------------------------------
    select Array_Varchar2(t.Filial_Name,
                          Uit_Href.Get_Staff_Status(i_Hiring_Date    => s.Hiring_Date,
                                                    i_Dismissal_Date => s.Dismissal_Date,
                                                    i_Date           => v_Curr_Date),
                          Href_Util.t_Staff_Status(Uit_Href.Get_Staff_Status(i_Hiring_Date    => s.Hiring_Date,
                                                                             i_Dismissal_Date => s.Dismissal_Date,
                                                                             i_Date           => v_Curr_Date)),
                          (select q.Name
                             from Mhr_Divisions q
                            where q.Company_Id = s.Company_Id
                              and q.Filial_Id = s.Filial_Id
                              and q.Division_Id = s.Division_Id),
                          (select q.Name
                             from Mhr_Jobs q
                            where q.Company_Id = s.Company_Id
                              and q.Filial_Id = s.Filial_Id
                              and q.Job_Id = s.Job_Id),
                          s.Dismissal_Date,
                          (select q.Reason_Type
                             from Href_Dismissal_Reasons q
                            where q.Company_Id = s.Company_Id
                              and q.Dismissal_Reason_Id = s.Dismissal_Reason_Id),
                          (select q.Name
                             from Href_Dismissal_Reasons q
                            where q.Company_Id = s.Company_Id
                              and q.Dismissal_Reason_Id = s.Dismissal_Reason_Id))
      bulk collect
      into v_Statuses
      from Filial_Statuses t
      left join Href_Staffs s
        on s.Company_Id = t.Company_Id
       and s.Filial_Id = t.Filial_Id
       and s.Staff_Id = t.Staff_Id
     order by s.Hiring_Date desc nulls last;

    return Fazo.Zip_Matrix(v_Statuses);
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Region_Id number := null) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Region_Id, t.Name, t.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and (t.State = 'A' or t.Region_Id = i_Region_Id)
     order by t.Name;

    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('genders', Fazo.Zip_Matrix_Transposed(Md_Util.Person_Genders));
    Result.Put('crs', Uit_Href.Col_Required_Settings);
    Result.Put('ss_working', Href_Pref.c_Staff_Status_Working);
    Result.Put('ss_dismissed', Href_Pref.c_Staff_Status_Dismissed);
    Result.Put('ss_unknown', Href_Pref.c_Staff_Status_Unknown);
    Result.Put('drt_positive', Href_Pref.c_Dismissal_Reasons_Type_Positive);
    Result.Put('drt_negative', Href_Pref.c_Dismissal_Reasons_Type_Negative);

    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    r_Person_Detail    Href_Person_Details%rowtype;
    r_Person           Md_Persons%rowtype;
    result             Hashmap := Hashmap();
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => p.r_Number('person_id'));

    Result.Put('person_id', r_Person.Person_Id);
    Result.Put('email', r_Person.Email);

    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);

    Result.Put_All(z_Mr_Natural_Persons.To_Map(r_Natural_Person,
                                               z.First_Name,
                                               z.Last_Name,
                                               z.Middle_Name,
                                               z.Gender,
                                               z.Birthday));

    r_Mr_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => r_Person.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);

    Result.Put_All(z_Mr_Person_Details.To_Map(r_Mr_Person_Detail,
                                              z.Tin,
                                              z.Main_Phone,
                                              z.Address,
                                              z.Legal_Address,
                                              z.Region_Id,
                                              z.Note));

    r_Person_Detail := z_Href_Person_Details.Take(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);

    Result.Put_All(z_Href_Person_Details.To_Map(r_Person_Detail,
                                                z.Iapa,
                                                z.Npin,
                                                z.Nationality_Id,
                                                z.Extra_Phone));
    Result.Put('nationality_name',
               z_Href_Nationalities.Take(i_Company_Id => r_Person_Detail.Company_Id, i_Nationality_Id => r_Person_Detail.Nationality_Id).Name);
    Result.Put('person_statuses', Load_Person_Statuses(r_Person.Person_Id));
    Result.Put('references', References(r_Mr_Person_Detail.Region_Id));

    return result;
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Personal(p Hashmap) is
    r_Person                Mr_Natural_Persons%rowtype;
    r_Person_Detail         Mr_Person_Details%rowtype;
    r_Detail                Href_Person_Details%rowtype;
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(Ui.Company_Id);

    -- mr natural person
    r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Person_Id  => p.r_Number('person_id'));

    z_Mr_Natural_Persons.To_Row(r_Person,
                                p,
                                z.First_Name,
                                z.Last_Name,
                                z.Middle_Name,
                                z.Gender,
                                z.Birthday);

    if v_Col_Required_Settings.Last_Name = 'Y' and trim(r_Person.Last_Name) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Last_Name);
    end if;

    if v_Col_Required_Settings.Middle_Name = 'Y' and trim(r_Person.Middle_Name) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Middle_Name);
    end if;

    if v_Col_Required_Settings.Birthday = 'Y' and r_Person.Birthday is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Birthday);
    end if;

    Mr_Api.Natural_Person_Save(r_Person);

    -- mr person detail
    if not z_Mr_Person_Details.Exist_Lock(i_Company_Id => r_Person.Company_Id,
                                          i_Person_Id  => r_Person.Person_Id,
                                          o_Row        => r_Person_Detail) then
      r_Person_Detail.Company_Id     := r_Person.Company_Id;
      r_Person_Detail.Person_Id      := r_Person.Person_Id;
      r_Person_Detail.Is_Budgetarian := 'N';
    end if;

    r_Person_Detail.Tin  := p.o_Varchar2('tin');
    r_Person_Detail.Note := p.o_Varchar2('note');

    Mr_Api.Person_Detail_Save(r_Person_Detail);

    -- href person detail
    if not z_Href_Person_Details.Exist_Lock(i_Company_Id => r_Person.Company_Id,
                                            i_Person_Id  => r_Person.Person_Id,
                                            o_Row        => r_Detail) then
      z_Href_Person_Details.Init(p_Row                  => r_Detail,
                                 i_Company_Id           => r_Person.Company_Id,
                                 i_Person_Id            => r_Person.Person_Id,
                                 i_Key_Person           => 'N',
                                 i_Access_All_Employees => 'N',
                                 i_Access_Hidden_Salary => 'N');
    end if;

    r_Detail.Iapa           := p.o_Varchar2('iapa');
    r_Detail.Npin           := p.o_Varchar2('npin');
    r_Detail.Nationality_Id := p.o_Number('nationality_id');

    Href_Api.Person_Detail_Save(r_Detail);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Contacts(p Hashmap) is
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    v_Phone_Number          varchar2(100) := Regexp_Replace(p.o_Varchar2('main_phone'), '\D', '');
    v_Email                 varchar2(300) := p.o_Varchar2('email');
    r_Person                Md_Persons%rowtype;
    r_Mr_Person_Detail      Mr_Person_Details%rowtype;
    r_Person_Detail         Href_Person_Details%rowtype;
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(Ui.Company_Id);

    -- md person
    if v_Col_Required_Settings.Phone_Number = 'Y' and trim(v_Phone_Number) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Phone_Number);
    end if;

    if v_Col_Required_Settings.Email = 'Y' and trim(v_Email) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Email);
    end if;

    r_Person := z_Md_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                       i_Person_Id  => p.r_Number('person_id'));

    Md_Api.Person_Update(i_Company_Id => r_Person.Company_Id,
                         i_Person_Id  => r_Person.Person_Id,
                         i_Phone      => Option_Varchar2(v_Phone_Number),
                         i_Email      => Option_Varchar2(v_Email));

    -- mr person detail
    if not z_Mr_Person_Details.Exist_Lock(i_Company_Id => r_Person.Company_Id,
                                          i_Person_Id  => r_Person.Person_Id,
                                          o_Row        => r_Mr_Person_Detail) then
      r_Mr_Person_Detail.Company_Id     := r_Person.Company_Id;
      r_Mr_Person_Detail.Person_Id      := r_Person.Person_Id;
      r_Mr_Person_Detail.Is_Budgetarian := 'N';
    end if;

    z_Mr_Person_Details.To_Row(r_Mr_Person_Detail,
                               p,
                               z.Main_Phone,
                               z.Address,
                               z.Legal_Address,
                               z.Region_Id);

    if not z_Href_Person_Details.Exist_Lock(i_Company_Id => r_Person.Company_Id,
                                            i_Person_Id  => r_Person.Person_Id,
                                            o_Row        => r_Person_Detail) then
      r_Person_Detail.Company_Id := r_Person.Company_Id;
      r_Person_Detail.Person_Id  := r_Person.Person_Id;
    end if;

    r_Person_Detail.Extra_Phone := p.o_Varchar2('extra_phone');

    Href_Api.Person_Detail_Save(r_Person_Detail, false);

    if v_Col_Required_Settings.Region = 'Y' and r_Mr_Person_Detail.Region_Id is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Region);
    end if;

    if v_Col_Required_Settings.Address = 'Y' and trim(r_Mr_Person_Detail.Address) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Address);
    end if;

    if v_Col_Required_Settings.Legal_Address = 'Y' and
       trim(r_Mr_Person_Detail.Legal_Address) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Legal_Address);
    end if;

    Mr_Api.Person_Detail_Save(r_Mr_Person_Detail);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Nationalities
       set Company_Id     = null,
           Nationality_Id = null,
           name           = null,
           State          = null;
  end;

end Ui_Vhr502;
/
