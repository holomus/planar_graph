create or replace package Ui_Vhr400 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Source_Audit(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr400;
/
create or replace package body Ui_Vhr400 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Source_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Href_Util.Employment_Source_Kinds;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from x_href_employment_sources q
                      where q.t_company_id = :company_id
                        and q.source_id = :source_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'source_id', p.r_Number('source_id')));
  
    q.Number_Field('t_audit_id', 't_user_id', 't_context_id', 'source_id', 'order_no');
    q.Varchar2_Field('t_event', 't_source_project_code', 'name', 'kind', 'state');
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
    q.Option_Field('kind_name', 'kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Data Href_Employment_Sources%rowtype;
    result Hashmap;
  begin
    r_Data := z_Href_Employment_Sources.Load(i_Company_Id => Ui.Company_Id,
                                             i_Source_Id  => p.r_Number('source_id'));
  
    result := z_Href_Employment_Sources.To_Map(r_Data,
                                               z.Source_Id,
                                               z.Name,
                                               z.Order_No,
                                               z.State,
                                               z.Created_On,
                                               z.Modified_On);
  
    Result.Put('kind_name', Href_Util.t_Employment_Source(r_Data.Kind));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Href_Employment_Sources
       set t_Company_Id = null,
           t_Audit_Id   = null,
           t_Event      = null,
           t_Timestamp  = null,
           t_Date       = null,
           t_User_Id    = null,
           Source_Id    = null,
           name         = null,
           Kind         = null,
           Order_No     = null,
           State        = null;
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

end Ui_Vhr400;
/
