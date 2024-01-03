create or replace package Ui_Vhr589 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr589;
/
create or replace package body Ui_Vhr589 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select t.*,
                       q.division_id adjustment_division_id,
                       q.adjustment_date
                  from hpd_journals t
                  join hpd_journal_timebook_adjustments q
                    on q.company_id = t.company_id
                   and q.filial_id = t.filial_id
                   and q.journal_id = t.journal_id
                 where t.company_id = :company_id
                   and t.filial_id = :filial_id
                   and t.journal_type_id = :tb_adjustment';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'tb_adjustment',
                             Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                      i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment));
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and not exists (select 1
                                         from hpd_journal_staffs je
                                         join href_staffs q
                                           on q.company_id = je.company_id
                                          and q.filial_id = je.filial_id
                                          and q.staff_id = je.staff_id
                                          and q.employee_id <> :user_id
                                          and q.org_unit_id not member of :division_ids
                                        where je.company_id = t.company_id
                                          and je.filial_id = t.filial_id
                                          and je.journal_id = t.journal_id)
                              and exists (select 1
                                     from hpd_journal_staffs js
                                    where js.company_id = t.company_id
                                      and js.filial_id = t.filial_id
                                      and js.journal_id = t.journal_id)';
    
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('journal_id',
                   'created_by',
                   'modified_by',
                   'posted_order_no',
                   'adjustment_division_id');
  
    q.Varchar2_Field('journal_number', 'journal_name', 'posted', 'source_table');
    q.Date_Field('journal_date', 'created_on', 'modified_on', 'adjustment_date');
  
    q.Refer_Field('adjustment_division_name',
                  'adjustment_division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false));
  
    q.Multi_Number_Field('employee_ids',
                         'select * from hpd_journal_employees je where je.company_id = :company_id and je.filial_id = :filial_id',
                         '@journal_id=$journal_id',
                         'employee_id');
  
    q.Refer_Field('employee_names',
                  'employee_ids',
                  'select * from mr_natural_persons mrp where mrp.company_id = :company_id',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1
                             from href_staffs s
                            where s.company_id = w.company_id
                              and s.filial_id = :filial_id
                              and s.employee_id = w.person_id)');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('journal_type_id',
                        Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => v_Journal_Ids(i));
    
      v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Journal_Id => v_Journal_Ids(i)).Journal_Type_Id;
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                                i_User_Id         => v_User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => v_Company_Id,
                                                                               i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                  v_Journal_Ids(i),
                                                                  'journal_type_id',
                                                                  v_Journal_Type_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort_Desc(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Journal_Id => v_Journal_Ids(i));
    
      v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Journal_Id => v_Journal_Ids(i)).Journal_Type_Id;
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                  i_User_Id         => v_User_Id,
                                                                                                  i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => v_Company_Id,
                                                                               i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                  v_Journal_Ids(i),
                                                                  'journal_type_id',
                                                                  v_Journal_Type_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Journal_Id => v_Journal_Ids(i)).Journal_Type_Id;
    
      Hpd_Api.Journal_Delete(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Journal_Id => v_Journal_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpd_Util.t_Notification_Title_Journal_Delete(i_Company_Id      => v_Company_Id,
                                                                                                  i_User_Id         => v_User_Id,
                                                                                                  i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Journals
       set Company_Id      = null,
           Filial_Id       = null,
           Journal_Id      = null,
           Journal_Type_Id = null,
           Journal_Number  = null,
           Journal_Date    = null,
           Journal_Name    = null,
           Posted          = null,
           Source_Table    = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Hpd_Journal_Staffs
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Staff_Id   = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Org_Unit_Id = null,
           Division_Id = null;
    update Hpd_Journal_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Journal_Id  = null,
           Employee_Id = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr589;
/
