create or replace package Ui_Vhr269 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Limit_Days(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Limit_Day(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr269;
/
create or replace package body Ui_Vhr269 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select * 
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.state = ''A''';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))
                              and s.employee_id <> :user_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id', 'division_id');
    q.Varchar2_Field('staff_number', 'staff_kind', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Limit_Days(p Hashmap) return Arraylist is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Staff_Ids  Array_Number := p.r_Array_Number('staff_ids');
    v_Period     date := p.r_Date('period') - 1;
    v_Limit_Days Arraylist := Arraylist();
    v_Data       Hashmap;
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Data := Hashmap();
      v_Data.Put('staff_id', v_Staff_Ids(i));
      v_Data.Put('name',
                 Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Staff_Id   => v_Staff_Ids(i)));
      v_Data.Put('limit_days',
                 Hpd_Util.Get_Current_Limit_Days(i_Company_Id => v_Company_Id,
                                                 i_Filial_Id  => v_Filial_Id,
                                                 i_Staff_Id   => v_Staff_Ids(i),
                                                 i_Period     => v_Period));
    
      v_Limit_Days.Push(v_Data);
    end loop;
  
    return v_Limit_Days;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Limit_Day(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('limit_days',
                        Hpd_Util.Get_Current_Limit_Days(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Staff_Id   => p.r_Number('staff_id'),
                                                        i_Period     => p.r_Date('period') - 1));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Limit_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Period     date
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Page_Id,
                          q.Staff_Id,
                          (select k.Name
                             from Mr_Natural_Persons k
                            where k.Company_Id = q.Company_Id
                              and k.Person_Id = q.Employee_Id),
                          Hpd_Util.Get_Current_Limit_Days(i_Company_Id => q.Company_Id,
                                                          i_Filial_Id  => q.Filial_Id,
                                                          i_Staff_Id   => q.Staff_Id,
                                                          i_Period     => i_Period - 1))
      bulk collect
      into v_Matrix
      from Hpd_Journal_Pages q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    Result.Put('limit_changes', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap;
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
    Result.Put('user_id', Ui.User_Id);
    Result.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Limit_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                            i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_date', Trunc(sysdate), 'change_date', Trunc(sysdate));
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    r_Limit_Change         Hpd_Vacation_Limit_Changes%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Limit_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                            i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null then
      Uit_Hpd.Check_Access_To_Edit_Journal(i_Document_Status => v_Sign_Document_Status,
                                           i_Posted          => r_Journal.Posted,
                                           i_Journal_Number  => r_Journal.Journal_Number);
      v_Has_Sign_Document := 'Y';
    end if;
  
    for r in (select s.Staff_Id
                from Hpd_Journal_Staffs s
               where s.Company_Id = r_Journal.Company_Id
                 and s.Filial_Id = r_Journal.Filial_Id
                 and s.Journal_Id = r_Journal.Journal_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
    end loop;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Posted);
  
    r_Limit_Change := z_Hpd_Vacation_Limit_Changes.Load(i_Company_Id => r_Journal.Company_Id,
                                                        i_Filial_Id  => r_Journal.Filial_Id,
                                                        i_Journal_Id => r_Journal.Journal_Id);
  
    Result.Put_All(z_Hpd_Vacation_Limit_Changes.To_Map(r_Limit_Change,
                                                       z.Division_Id,
                                                       z.Change_Date,
                                                       z.Days_Limit));
    Result.Put_All(Get_Limit_Changes(i_Company_Id => r_Journal.Company_Id,
                                     i_Filial_Id  => r_Journal.Filial_Id,
                                     i_Journal_Id => r_Journal.Journal_Id,
                                     i_Period     => r_Limit_Change.Change_Date));
  
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References(r_Limit_Change.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p            Hashmap,
    i_Journal_Id number
  ) return Hashmap is
    v_Journal       Hpd_Pref.Limit_Change_Journal_Rt;
    v_Limit_Changes Arraylist := p.r_Arraylist('limit_changes');
    v_Limit_Change  Hashmap;
    v_Page_Id       number;
    v_Staff_Id      number;
  begin
    Hpd_Util.Limit_Change_Journal_New(o_Journal        => v_Journal,
                                      i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Journal_Id     => i_Journal_Id,
                                      i_Journal_Number => p.o_Varchar2('journal_number'),
                                      i_Journal_Date   => p.r_Date('journal_date'),
                                      i_Journal_Name   => p.o_Varchar2('journal_name'),
                                      i_Division_Id    => p.o_Number('division_id'),
                                      i_Days_Limit     => p.r_Number('days_limit'),
                                      i_Change_Date    => p.r_Date('change_date'),
                                      i_Lang_Code      => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Limit_Changes.Count
    loop
      v_Limit_Change := Treat(v_Limit_Changes.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Limit_Change.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Page_Id := v_Limit_Change.o_Number('page_id');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      Hpd_Util.Limit_Change_Add_Page(p_Journal  => v_Journal,
                                     i_Page_Id  => v_Page_Id,
                                     i_Staff_Id => v_Staff_Id);
    end loop;
  
    Hpd_Api.Vacation_Limit_Change_Journal_Save(i_Journal => v_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    return Fazo.Zip_Map('journal_id', i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hpd_Next.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Repost  boolean;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    v_Repost := r_Journal.Posted = 'Y' and p.r_Varchar2('posted') = 'Y';
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => v_Repost);
    end if;
  
    return save(p, p.r_Number('journal_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Employee_Id     = null,
           Org_Unit_Id     = null,
           Hiring_Date     = null,
           Dismissal_Date  = null,
           Employment_Type = null,
           Division_Id     = null,
           Staff_Kind      = null,
           State           = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr269;
/
