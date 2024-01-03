create or replace package Ui_Vhr129 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr129;
/
create or replace package body Ui_Vhr129 is
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
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Schedule_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
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
                          Ps.Schedule_Id,
                          (select s.Name
                             from Htt_Schedules s
                            where s.Company_Id = i_Company_Id
                              and s.Filial_Id = i_Filial_Id
                              and s.Schedule_Id = Ps.Schedule_Id))
      bulk collect
      into v_Matrix
      from Hpd_Journal_Pages q
      join Hpd_Page_Schedules Ps
        on Ps.Company_Id = i_Company_Id
       and Ps.Filial_Id = i_Filial_Id
       and Ps.Page_Id = q.Page_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    Result.Put('schedule_changes', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap;
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
    Result.Put('sk_flexible', Htt_Pref.c_Schedule_Kind_Flexible);
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
    if not Hpd_Util.Is_Schedule_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_date', Trunc(sysdate), 'begin_date', Trunc(sysdate));
  
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
    r_Schedule_Change      Hpd_Schedule_Changes%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Schedule_Change_Journal(i_Company_Id      => Ui.Company_Id,
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
  
    r_Schedule_Change := z_Hpd_Schedule_Changes.Load(i_Company_Id => r_Journal.Company_Id,
                                                     i_Filial_Id  => r_Journal.Filial_Id,
                                                     i_Journal_Id => r_Journal.Journal_Id);
  
    Result.Put_All(z_Hpd_Schedule_Changes.To_Map(r_Schedule_Change,
                                                 z.Division_Id,
                                                 z.Begin_Date,
                                                 z.End_Date));
    Result.Put_All(Get_Schedule_Changes(i_Company_Id => r_Journal.Company_Id,
                                        i_Filial_Id  => r_Journal.Filial_Id,
                                        i_Journal_Id => r_Journal.Journal_Id));
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References(r_Schedule_Change.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Journal_Id number,
    p            Hashmap
  ) return Hashmap is
    v_Journal          Hpd_Pref.Schedule_Change_Journal_Rt;
    v_Schedule_Changes Arraylist := p.r_Arraylist('schedule_changes');
    v_Schedule_Change  Hashmap;
    v_Page_Id          number;
    v_Staff_Id         number;
  begin
    Hpd_Util.Schedule_Change_Journal_New(o_Journal        => v_Journal,
                                         i_Company_Id     => Ui.Company_Id,
                                         i_Filial_Id      => Ui.Filial_Id,
                                         i_Journal_Id     => i_Journal_Id,
                                         i_Journal_Number => p.o_Varchar2('journal_number'),
                                         i_Journal_Date   => p.r_Date('journal_date'),
                                         i_Journal_Name   => p.o_Varchar2('journal_name'),
                                         i_Division_Id    => p.o_Number('division_id'),
                                         i_Begin_Date     => p.r_Date('begin_date'),
                                         i_End_Date       => p.o_Date('end_date'),
                                         i_Lang_Code      => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Schedule_Changes.Count
    loop
      v_Schedule_Change := Treat(v_Schedule_Changes.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Schedule_Change.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Page_Id := v_Schedule_Change.o_Number('page_id');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => v_Journal,
                                           i_Page_Id     => v_Page_Id,
                                           i_Staff_Id    => v_Staff_Id,
                                           i_Schedule_Id => v_Schedule_Change.r_Number('schedule_id'));
    end loop;
  
    Hpd_Api.Schedule_Change_Journal_Save(v_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    return Fazo.Zip_Map('journal_id', i_Journal_Id, 'journal_name', v_Journal.Journal_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpd_Next.Journal_Id, p);
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
  
    return save(r_Journal.Journal_Id, p);
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
           Employment_Type = null,
           Hiring_Date     = null,
           Dismissal_Date  = null,
           Division_Id     = null,
           Staff_Kind      = null,
           State           = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
  end;

end Ui_Vhr129;
/
