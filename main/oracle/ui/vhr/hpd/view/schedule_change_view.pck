create or replace package Ui_Vhr606 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
end Ui_Vhr606;
/
create or replace package body Ui_Vhr606 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_schedule_changes q
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
                   'division_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp', 'begin_date', 'end_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
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
  Function Get_Schedule_Changes(i_Journal_Id number) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Staff_Id,
                          (select k.Name
                             from Mr_Natural_Persons k
                            where k.Company_Id = q.Company_Id
                              and k.Person_Id = q.Employee_Id),
                          Ps.Schedule_Id,
                          (select s.Name
                             from Htt_Schedules s
                            where s.Company_Id = Ui.Company_Id
                              and s.Filial_Id = Ui.Filial_Id
                              and s.Schedule_Id = Ps.Schedule_Id))
      bulk collect
      into v_Matrix
      from Hpd_Journal_Pages q
      join Hpd_Page_Schedules Ps
        on Ps.Company_Id = Ui.Company_Id
       and Ps.Filial_Id = Ui.Filial_Id
       and Ps.Page_Id = q.Page_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    Result.Put('schedule_changes', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Journal         Hpd_Journals%rowtype;
    r_Schedule_Change Hpd_Schedule_Changes%rowtype;
    result            Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Uit_Hpd.Access_To_Journal_Sign_Document(r_Journal.Journal_Id) then
      for r in (select s.Staff_Id
                  from Hpd_Journal_Staffs s
                 where s.Company_Id = r_Journal.Company_Id
                   and s.Filial_Id = r_Journal.Filial_Id
                   and s.Journal_Id = r_Journal.Journal_Id)
      loop
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
      end loop;
    end if;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Sign_Document_Id,
                                    z.Posted,
                                    z.Created_By,
                                    z.Created_On,
                                    z.Modified_By,
                                    z.Modified_On);
  
    Result.Put('sign_document_status',
               Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                  i_Document_Id => r_Journal.Sign_Document_Id));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => r_Journal.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => r_Journal.Modified_By).Name);
  
    r_Schedule_Change := z_Hpd_Schedule_Changes.Load(i_Company_Id => r_Journal.Company_Id,
                                                     i_Filial_Id  => r_Journal.Filial_Id,
                                                     i_Journal_Id => r_Journal.Journal_Id);
  
    Result.Put_All(z_Hpd_Schedule_Changes.To_Map(r_Schedule_Change,
                                                 z.Division_Id,
                                                 z.Begin_Date,
                                                 z.End_Date));
  
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Schedule_Change.Division_Id).Name);
  
    Result.Put_All(Get_Schedule_Changes(r_Journal.Journal_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number;
  begin
    Hpd_Api.Journal_Post(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Journal_Id => v_Journal_Id).Journal_Type_Id;
  
    Href_Core.Send_Notification(i_Company_Id    => Ui.Company_Id,
                                i_Filial_Id     => Ui.Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => Ui.Company_Id,
                                                                                              i_User_Id         => Ui.User_Id,
                                                                                              i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => Ui.Company_Id,
                                                                             i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number;
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Journal_Id => v_Journal_Id).Journal_Type_Id;
  
    Href_Core.Send_Notification(i_Company_Id    => Ui.Company_Id,
                                i_Filial_Id     => Ui.Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => Ui.Company_Id,
                                                                                                i_User_Id         => Ui.User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => Ui.Company_Id,
                                                                             i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Schedule_Changes
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
           Division_Id           = null,
           Begin_Date            = null,
           End_Date              = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
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

end Ui_Vhr606;
/
