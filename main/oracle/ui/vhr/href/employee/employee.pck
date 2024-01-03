create or replace package Ui_Vhr321 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Contact_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Npin_Is_Valid(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Email_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Personal(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Contacts(p Hashmap);
end Ui_Vhr321;
/
create or replace package body Ui_Vhr321 is
  ----------------------------------------------------------------------------------------------------
  c_Period_Kind_This_Year      constant varchar2(1) := 'T';
  c_Period_Kind_Last_Year      constant varchar2(1) := 'L';
  c_Period_Kind_Last_12_Months constant varchar2(1) := 'M';

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
    return b.Translate('UI-VHR321:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from uit_href.employee_personal_audit(:company_id, 
                                                             :employee_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'employee_id',
                                 p.r_Number('employee_id')));
  
    q.Number_Field('context_id', 'user_id');
    q.Varchar2_Field('column_key', 'event', 'value');
    q.Date_Field('timestamp');
  
    q.Refer_Field('user_name',
                  'user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('event_name', 'event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.Employee_Personal_Audit_Column_Names;
  
    q.Option_Field('column_name', 'column_key', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Contact_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from uit_href.employee_contact_audit(:company_id, 
                                                            :employee_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'employee_id',
                                 p.r_Number('employee_id')));
  
    q.Number_Field('context_id', 'user_id');
    q.Varchar2_Field('column_key', 'event', 'value');
    q.Date_Field('timestamp');
  
    q.Refer_Field('user_name',
                  'user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('event_name', 'event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.Employee_Contact_Audit_Column_Names;
  
    q.Option_Field('column_name', 'column_key', v_Matrix(1), v_Matrix(2));
    return q;
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
    v_Phone varchar2(25) := p.r_Varchar2('main_phone');
  begin
    return Href_Util.Check_Unique_Phone(i_Company_Id => Ui.Company_Id,
                                        i_Person_Id  => p.r_Number('person_id'),
                                        i_Phone      => v_Phone);
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
  Function Npin_Is_Valid(p Hashmap) return varchar2 is
  begin
    return Uit_Href.Npin_Is_Valid(i_Npin => p.r_Varchar2('npin'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats
  (
    i_Employee_Id number,
    i_Period_Kind varchar2
  ) return Hashmap is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Curr_Date    date;
    v_Period_Begin date;
    v_Period_End   date;
  
    v_Staff_Id number;
    v_Years    Array_Number;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Init_Period is
    begin
      case i_Period_Kind
        when c_Period_Kind_This_Year then
          v_Period_Begin := Trunc(v_Curr_Date, 'YYYY');
          v_Period_End   := Add_Months(v_Period_Begin, 11);
        when c_Period_Kind_Last_Year then
          v_Period_Begin := Trunc(Add_Months(v_Curr_Date, -12), 'YYYY');
          v_Period_End   := Add_Months(v_Period_Begin, 11);
        when c_Period_Kind_Last_12_Months then
          v_Period_End   := Trunc(v_Curr_Date, 'MON');
          v_Period_Begin := Add_Months(v_Period_End, -11);
        else
          b.Raise_Not_Implemented;
      end case;
    
      v_Period_End := Least(v_Period_End, v_Curr_Date);
    end;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                 i_Filial_Id   => v_Filial_Id,
                                                 i_Employee_Id => i_Employee_Id);
    Result.Put('staff_id', v_Staff_Id);
  
    if v_Staff_Id is null then
      return result;
    end if;
  
    v_Curr_Date := Htt_Util.Get_Current_Date(i_Company_Id => v_Company_Id,
                                             i_Filial_Id  => v_Filial_Id);
    Init_Period;
  
    select Array_Varchar2(k.Month, k.Late_Cnt, k.Early_Cnt, k.Intime_Cnt, k.Absence_Cnt),
           Extract(year from k.Month)
      bulk collect
      into v_Matrix, v_Years
      from Htt_Employee_Monthly_Attendances_Mv k
     where k.Company_Id = v_Company_Id
       and k.Filial_Id = v_Filial_Id
       and k.Staff_Id = v_Staff_Id
       and k.Month between v_Period_Begin and v_Period_End
     order by k.Month;
  
    v_Years := set(v_Years);
  
    Result.Put('months', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('is_one_year', case when v_Years.Count > 1 then 'N' else 'Y' end);
  
    return result;
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
    Result.Put('period_kinds',
               Fazo.Zip_Matrix_Transposed(Matrix_Varchar2(Array_Varchar2(c_Period_Kind_This_Year,
                                                                         c_Period_Kind_Last_Year,
                                                                         c_Period_Kind_Last_12_Months),
                                                          Array_Varchar2(t('period_kind: this year'), --
                                                                         t('period_kind: last year'), --
                                                                         t('period_kind: last 12 months')))));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    r_Person_Detail    Href_Person_Details%rowtype;
    r_Person           Md_Persons%rowtype;
    v_Blocked_Tracking varchar2(1) := 'N';
    v_Employee_Id      number := p.r_Number('employee_id');
    result             Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
  
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                  i_Person_Id  => v_Employee_Id);
  
    Result.Put('employee_id', r_Person.Person_Id);
    Result.Put('email', r_Person.Email);
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Natural_Persons.To_Map(r_Natural_Person,
                                               z.First_Name,
                                               z.Last_Name,
                                               z.Middle_Name,
                                               z.Gender,
                                               z.Birthday,
                                               z.Created_On,
                                               z.Modified_On));
  
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Natural_Person.Company_Id, i_User_Id => r_Natural_Person.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Natural_Person.Company_Id, i_User_Id => r_Natural_Person.Modified_By).Name);
  
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
  
    if z_Htt_Blocked_Person_Tracking.Exist(i_Company_Id  => r_Person.Company_Id,
                                           i_Filial_Id   => Ui.Filial_Id,
                                           i_Employee_Id => r_Person.Person_Id) then
      v_Blocked_Tracking := 'Y';
    end if;
  
    Result.Put('blocked_tracking', v_Blocked_Tracking);
  
    Result.Put_All(z_Href_Person_Details.To_Map(r_Person_Detail,
                                                z.Iapa,
                                                z.Npin,
                                                z.Nationality_Id,
                                                z.Extra_Phone,
                                                z.Corporate_Email));
  
    Result.Put('nationality_name',
               z_Href_Nationalities.Take(i_Company_Id => r_Person_Detail.Company_Id, i_Nationality_Id => r_Person_Detail.Nationality_Id).Name);
    Result.Put('period_kind', c_Period_Kind_Last_12_Months);
    Result.Put_All(Load_Xy_Chart_Stats(i_Employee_Id => r_Person.Person_Id,
                                       i_Period_Kind => c_Period_Kind_Last_12_Months));
    Result.Put('references', References(r_Mr_Person_Detail.Region_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats(p Hashmap) return Hashmap is
  begin
    return Load_Xy_Chart_Stats(i_Employee_Id => p.r_Number('employee_id'),
                               i_Period_Kind => p.r_Varchar2('period_kind'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee_Id number) is
  begin
    Mhr_Api.Employee_Save(z_Mhr_Employees.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                                    i_Filial_Id   => Ui.Filial_Id,
                                                    i_Employee_Id => i_Employee_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Personal(p Hashmap) is
    r_Person                Mr_Natural_Persons%rowtype;
    r_Person_Detail         Mr_Person_Details%rowtype;
    r_Detail                Href_Person_Details%rowtype;
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    v_Employee_Id           number := p.r_Number('employee_id');
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(Ui.Company_Id);
  
    Employee_Save(v_Employee_Id);
  
    -- mr natural person
    r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Person_Id  => v_Employee_Id);
  
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
    r_Person                Md_Persons%rowtype;
    r_Mr_Person_Detail      Mr_Person_Details%rowtype;
    r_Person_Detail         Href_Person_Details%rowtype;
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    v_Phone_Number          varchar2(100) := Regexp_Replace(p.o_Varchar2('main_phone'), '\D', '');
    v_Email                 varchar2(300) := p.o_Varchar2('email');
    v_Employee_Id           number := p.r_Number('employee_id');
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(Ui.Company_Id);
  
    Employee_Save(v_Employee_Id);
  
    -- md person
    if v_Col_Required_Settings.Phone_Number = 'Y' and trim(v_Phone_Number) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Phone_Number);
    end if;
  
    if v_Col_Required_Settings.Email = 'Y' and trim(v_Email) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Email);
    end if;
  
    r_Person := z_Md_Persons.Lock_Load(i_Company_Id => Ui.Company_Id, i_Person_Id => v_Employee_Id);
  
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
  
    r_Person_Detail.Extra_Phone     := p.o_Varchar2('extra_phone');
    r_Person_Detail.Corporate_Email := p.o_Varchar2('corporate_email');
  
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

end Ui_Vhr321;
/
