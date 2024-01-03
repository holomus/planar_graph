create or replace package Ui_Vhr650 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr650;
/
create or replace package body Ui_Vhr650 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
    v_Param  Hashmap;
  begin
    v_Param := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    q := Fazo_Query('select q.*,
                            (select pr.name 
                               from mdf_sign_processes pr
                              where pr.company_id = q.company_id
                                and pr.process_id = q.process_id) as process_name,            
                            s.journal_type_id,
                            w.source_table,
                            w.source_action
                       from mdf_sign_templates q
                       join mdf_sign_processes w
                         on w.company_id = q.company_id
                        and w.process_id = q.process_id
                       join hpd_sign_templates s
                         on s.company_id = q.company_id
                        and s.filial_id = q.filial_id
                        and s.template_id = q.template_id
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    v_Param);
  
    q.Number_Field('template_id', 'journal_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('sign_kind', 'state', 'note', 'process_name');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('journal_type_name',
                  'journal_type_id',
                  'hpd_journal_types',
                  'journal_type_id',
                  'name',
                  'select *
                     from hpd_journal_types q
                    where q.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
  
    v_Matrix := Mdf_Pref.Sign_Kinds;
  
    q.Option_Field('sign_kind_name', 'sign_kind', v_Matrix(1), v_Matrix(2));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Ids Array_Number := Fazo.Sort(p.r_Array_Number('template_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Mdf_Api.Template_Delete(i_Company_Id => Ui.Company_Id, i_Template_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mdf_Sign_Templates
       set Company_Id  = null,
           Template_Id = null,
           Filial_Id   = null,
           Sign_Kind   = null,
           Process_Id  = null,
           State       = null,
           Note        = null,
           Created_By  = null,
           Created_On  = null,
           Modified_By = null,
           Modified_On = null;
    update Mdf_Sign_Processes
       set Company_Id    = null,
           Process_Id    = null,
           Project_Code  = null,
           Source_Table  = null,
           Source_Action = null,
           name          = null,
           Order_No      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           Filial_Id  = null,
           User_Id    = null;
  end;

end Ui_Vhr650;
/
