create or replace package Ui_Vhr385 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Experience_Type_Audit(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr385;
/
create or replace package body Ui_Vhr385 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Experience_Type_Audit(p Hashmap) return Fazo_Query is
    v_Events Matrix_Varchar2 := Md_Util.Events;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from x_href_experience_types q
                      where q.t_company_id = :company_id
                        and q.experience_type_id = :experience_type_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'experience_type_id',
                                 p.r_Number('experience_type_id')));
  
    q.Number_Field('t_audit_id', 't_user_id', 't_context_id', 'experience_type_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'name', 'state', 'code');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id');
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
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Data       Href_Experience_Types%rowtype;
    v_Company_Id number := Ui.Company_Id;
    result       Hashmap;
  begin
    r_Data := z_Href_Experience_Types.Load(i_Company_Id         => v_Company_Id,
                                           i_Experience_Type_Id => p.r_Number('experience_type_id'));
  
    result := z_Href_Experience_Types.To_Map(r_Data,
                                             z.Experience_Type_Id,
                                             z.Name,
                                             z.State,
                                             z.Code,
                                             z.Created_On,
                                             z.Modified_On);
  
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Href_Experience_Types
       set t_Company_Id       = null,
           t_Audit_Id         = null,
           t_Event            = null,
           t_Timestamp        = null,
           t_Date             = null,
           t_User_Id          = null,
           Experience_Type_Id = null,
           name               = null,
           State              = null,
           Code               = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr385;
/
