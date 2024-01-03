create or replace package Ui_Vhr605 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Overtime_Day_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr605;
/
create or replace package body Ui_Vhr605 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*                         
                       from x_hpd_journal_overtimes q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.journal_id = :journal_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'journal_id',
                   'employee_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp', 'begin_date', 'end_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('staff_name',
                  'employee_id',
                  'md_persons',
                  'person_id',
                  'name',
                  'select *
                     from md_persons s 
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees f
                            where f.company_id = s.company_id
                              and f.filial_id = :filial_id
                              and f.employee_id = s.person_id)');
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Overtime_Day_Audits(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.employee_id
                       from x_hpd_overtime_days q
                       join x_hpd_journal_overtimes w
                         on w.t_company_id = q.t_company_id
                        and w.t_filial_id = q.t_filial_id 
                        and w.journal_id = :journal_id
                        and w.overtime_id = q.overtime_id
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'journal_id',
                   'employee_id',
                   'overtime_seconds');
    q.Varchar2_Field('t_event', 't_source_project_code', 'note');
    q.Date_Field('t_date', 't_timestamp', 'overtime_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('staff_name',
                  'employee_id',
                  'md_persons',
                  'person_id',
                  'name',
                  'select *
                     from md_persons s 
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees f
                            where f.company_id = s.company_id
                              and f.filial_id = :filial_id
                              and f.employee_id = s.person_id)');
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Overtimes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Matrix       Matrix_Varchar2;
    v_Free_Id      number;
    v_Overtime_Ids Array_Number;
    v_Division_Id  number;
    result         Hashmap := Hashmap();
  begin
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    select Array_Varchar2(q.Overtime_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where q.Company_Id = w.Company_Id
                              and q.Employee_Id = w.Person_Id),
                          (select Round(sum(w.Overtime_Seconds) / 60, 2)
                             from Hpd_Overtime_Days w
                            where q.Company_Id = w.Company_Id
                              and q.Filial_Id = w.Filial_Id
                              and q.Overtime_Id = w.Overtime_Id),
                          (select Listagg(w.Overtime_Date, ', ')
                             from Hpd_Overtime_Days w
                            where q.Company_Id = w.Company_Id
                              and q.Filial_Id = w.Filial_Id
                              and q.Overtime_Id = w.Overtime_Id)),
           q.Overtime_Id
      bulk collect
      into v_Matrix, v_Overtime_Ids
      from Hpd_Journal_Overtimes q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    Result.Put('overtimes', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(max(q.Overtime_Id), --
                          q.Overtime_Date,
                          Round(max(q.Overtime_Seconds) / 60, 2))
      bulk collect
      into v_Matrix
      from Hpd_Overtime_Days q
      join Htt_Timesheets t
        on t.Company_Id = q.Company_Id
       and t.Filial_Id = q.Filial_Id
       and t.Staff_Id = q.Staff_Id
       and t.Timesheet_Date = q.Overtime_Date
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = t.Company_Id
       and Tf.Filial_Id = t.Filial_Id
       and Tf.Timesheet_Id = t.Timesheet_Id
       and Tf.Time_Kind_Id in
           (select Tk.Time_Kind_Id
              from Htt_Time_Kinds Tk
             where Tk.Company_Id = Ui.Company_Id
               and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Free_Id)
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Overtime_Id member of v_Overtime_Ids
     group by q.Staff_Id, q.Overtime_Date
     order by q.Staff_Id, q.Overtime_Date;
  
    Result.Put('overtime_days', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('month', to_char(sysdate, Href_Pref.c_Date_Format_Month));
  
    v_Division_Id := z_Hpd_Overtime_Journal_Divisions.Take(i_Company_Id => i_Company_Id, --
                     i_Filial_Id => i_Filial_Id, --
                     i_Journal_Id => i_Journal_Id).Division_Id;
  
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Division_Id => v_Division_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
  begin
    Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                              i_User_Id         => v_User_Id,
                                                                                              i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Overtime_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                i_User_Id         => v_User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Overtime_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    result    Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Uit_Hpd.Access_To_Journal_Sign_Document(r_Journal.Journal_Id) then
      for r in (select q.Staff_Id
                  from Hpd_Journal_Pages q
                 where q.Company_Id = r_Journal.Company_Id
                   and q.Filial_Id = r_Journal.Filial_Id
                   and q.Journal_Id = r_Journal.Journal_Id)
      loop
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
      end loop;
    end if;
  
    if not Hpd_Util.Is_Overtime_Journal(i_Company_Id      => Ui.Company_Id,
                                        i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Type_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Sign_Document_Id,
                                    z.Posted,
                                    z.Created_On,
                                    z.Modified_On);
  
    Result.Put('sign_document_status',
               Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                  i_Document_Id => r_Journal.Sign_Document_Id));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Journal.Company_Id, i_User_Id => r_Journal.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Journal.Company_Id, i_User_Id => r_Journal.Modified_By).Name);
    Result.Put_All(Get_Overtimes(i_Company_Id => r_Journal.Company_Id,
                                 i_Filial_Id  => r_Journal.Filial_Id,
                                 i_Journal_Id => r_Journal.Journal_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Journal_Overtimes
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Journal_Id            = null,
           Employee_Id           = null,
           Begin_Date            = null,
           End_Date              = null;
    update x_Hpd_Overtime_Days
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Overtime_Date         = null,
           Overtime_Seconds      = null,
           Overtime_Id           = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr605;
/
