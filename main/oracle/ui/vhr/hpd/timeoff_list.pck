create or replace package Ui_Vhr617 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr617;
/
create or replace package body Ui_Vhr617 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select j.journal_id,
                       j.journal_type_id origin_journal_type_id,
                       j.journal_type_id || (select ''#'' || v.time_kind_id
                                               from hpd_vacations v
                                              where v.company_id = jt.company_id
                                                and v.filial_id = jt.filial_id
                                                and v.timeoff_id = jt.timeoff_id) journal_type_id,
                       j.journal_number,
                       j.journal_date,
                       j.journal_name,
                       j.posted,
                       j.source_table,
                       j.created_by,
                       j.created_on,
                       j.modified_by,
                       j.modified_on,
                       jt.employee_id,
                       jt.begin_date,
                       jt.end_date
                  from hpd_journals j
                  join hpd_journal_staffs js
                    on js.company_id = j.company_id
                   and js.filial_id = j.filial_id
                   and js.journal_id = j.journal_id
                  join hpd_journal_timeoffs jt
                    on jt.company_id = js.company_id
                   and jt.filial_id = js.filial_id
                   and jt.journal_id = js.journal_id
                   and jt.staff_id = js.staff_id
                  join href_staffs s
                    on s.company_id = js.company_id
                   and s.filial_id = js.filial_id
                   and s.staff_id = js.staff_id
                 where j.company_id = :company_id
                   and j.filial_id = :filial_id
                   and j.journal_type_id in (:jt_sick_leave, :jt_sick_leave_multiple, :jt_vacation, :jt_vacation_multiple)';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Params.Put('jt_sick_leave',
                 Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave));
    v_Params.Put('jt_sick_leave_multiple',
                 Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple));
    v_Params.Put('jt_vacation',
                 Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation));
    v_Params.Put('jt_vacation_multiple',
                 Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple));
    v_Params.Put('tk_vacation',
                 Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation));
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and s.employee_id != :user_id
                              and s.org_unit_id member of :division_ids';
    
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('journal_id',
                   'origin_journal_type_id',
                   'employee_id',
                   'created_by',
                   'modified_by',
                   'posted_order_no');
  
    q.Varchar2_Field('journal_type_id', 'journal_number', 'journal_name', 'posted', 'source_table');
    q.Date_Field('journal_date', 'begin_date', 'end_date', 'created_on', 'modified_on');
  
    q.Refer_Field('journal_type_name',
                  'journal_type_id',
                  'select w.journal_type_id || nvl2(tk.time_kind_id, ''#'', null) || tk.time_kind_id journal_type_id,
                          nvl(tk.name, w.name) name
                     from hpd_journal_types w
                     left join htt_time_kinds tk
                       on tk.company_id = w.company_id
                      and nvl(tk.parent_id, tk.time_kind_id) = :tk_vacation
                      and w.journal_type_id = :jt_vacation
                    where w.company_id = :company_id
                      and w.journal_type_id in (:jt_sick_leave, :jt_sick_leave_multiple, :jt_vacation, :jt_vacation_multiple)',
                  'journal_type_id',
                  'name');
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
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
    q.Refer_Field('pcode',
                  'origin_journal_type_id',
                  'hpd_journal_types',
                  'journal_type_id',
                  'pcode',
                  'select *
                     from hpd_journal_types w
                    where w.company_id = :company_id
                      and w.journal_type_id member of :journal_type_ids');
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
  Function Easy_Report_Forms return Matrix_Varchar2 is
    v_Forms     Matrix_Varchar2 := Matrix_Varchar2();
    v_Templates Matrix_Varchar2;
    result      Matrix_Varchar2 := Matrix_Varchar2();
  begin
    for i in 1 .. v_Forms.Count
    loop
      continue when not Md_Util.Grant_Has_Form(i_Company_Id   => Ui.Company_Id,
                                               i_Project_Code => Ui.Project_Code,
                                               i_Filial_Id    => Ui.Filial_Id,
                                               i_User_Id      => Ui.User_Id,
                                               i_Form         => v_Forms(i) (1));
    
      v_Templates := Uit_Ker.Templates(i_Form => v_Forms(i) (1));
    
      for j in 1 .. v_Templates.Count
      loop
        v_Templates(j).Extend();
        v_Templates(j)(v_Templates(j).Count) := v_Forms(i) (2);
      
        Result.Extend();
        result(Result.Count) := v_Templates(j);
      end loop;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Journal_Type_Id, q.Name, q.Pcode)
      bulk collect
      into v_Matrix
      from Hpd_Journal_Types q
     where q.Company_Id = Ui.Company_Id
     order by q.Order_No;
  
    Result.Put('journal_types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('pcode_sick_leave', Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
    Result.Put('pcode_sick_leave_multiple', Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple);
    Result.Put('pcode_vacation', Hpd_Pref.c_Pcode_Journal_Type_Vacation);
    Result.Put('pcode_vacation_multiple', Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple);
    Result.Put('reports', Fazo.Zip_Matrix(Easy_Report_Forms));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
    result            Hashmap := Hashmap();
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
  
    return result;
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
    update Hpd_Journal_Timeoffs
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Staff_Id   = null,
           Begin_Date = null,
           End_Date   = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Division_Id = null,
           Org_Unit_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
  end;

end Ui_Vhr617;
/
