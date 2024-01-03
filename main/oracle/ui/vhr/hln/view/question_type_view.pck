create or replace package Ui_Vhr443 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Question_Type_Audit(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr443;
/
create or replace package body Ui_Vhr443 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Question_Type_Audit(p Hashmap) return Fazo_Query is
    v_Events Matrix_Varchar2 := Md_Util.Events;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from x_hln_question_types q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.question_type_id = :question_type_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'question_type_id',
                                 p.r_Number('question_type_id')));
  
    q.Number_Field('t_audit_id',
                   't_user_id',
                   't_context_id',
                   'question_type_id',
                   'question_group_id',
                   'order_no');
    q.Varchar2_Field('t_event', 't_source_project_code', 'name', 'code', 'state');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = q.company_id
                              and w.user_id = q.user_id
                              and w.filial_id = :filial_id)');
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
                             from md_company_filial_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code
                              and k.filial_id = :filial_id)');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Data Hln_Question_Types%rowtype;
    result Hashmap;
  begin
    r_Data := z_Hln_Question_Types.Load(i_Company_Id       => Ui.Company_Id,
                                        i_Filial_Id        => Ui.Filial_Id,
                                        i_Question_Type_Id => p.r_Number('question_type_id'));
  
    result := z_Hln_Question_Types.To_Map(r_Data,
                                          z.Question_Type_Id,
                                          z.Name,
                                          z.Code,
                                          z.Order_No,
                                          z.State,
                                          z.Created_On,
                                          z.Modified_On);
  
    Result.Put('question_group_name',
               z_Hln_Question_Groups.Take(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Question_Group_Id => r_Data.Question_Group_Id).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hln_Question_Types
       set t_Company_Id      = null,
           t_Filial_Id       = null,
           t_Audit_Id        = null,
           t_Event           = null,
           t_Timestamp       = null,
           t_Date            = null,
           t_User_Id         = null,
           Question_Type_Id  = null,
           Question_Group_Id = null,
           name              = null,
           Code              = null,
           Order_No          = null,
           State             = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Md_Company_Filial_Projects
       set Company_Id   = null,
           Project_Code = null,
           Filial_Id    = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr443;
/
