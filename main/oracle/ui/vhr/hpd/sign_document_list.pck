create or replace package Ui_Vhr652 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure To_Progress(p Hashmap);
end Ui_Vhr652;
/
create or replace package body Ui_Vhr652 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix   Matrix_Varchar2;
    v_Is_Admin varchar2(1) := 'N';
    q          Fazo_Query;
  begin
    if Ui.Is_User_Admin then
      v_Is_Admin := 'Y';
    end if;
  
    q := Fazo_Query('select q.*
                       from mdf_sign_documents q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and exists (select 1
                               from mdf_sign_processes k
                              where k.company_id = q.company_id
                                and k.process_id = q.process_id
                                and k.project_code = :project_code)
                        and exists (select 1
                               from mdf_sign_document_persons dp
                              where dp.company_id = q.company_id
                                and dp.document_id = q.document_id
                                and (:is_admin = ''Y'' or dp.person_id = :user_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'project_code',
                                 Ui.Project_Code,
                                 'user_id',
                                 Ui.User_Id,
                                 'is_admin',
                                 v_Is_Admin));
  
    q.Number_Field('document_id', 'process_id', 'created_by', 'modified_by');
    q.Date_Field('created_on', 'modified_on');
    q.Varchar2_Field('sign_kind', 'status', 'title', 'note');
    q.Date_Field('created_on');
  
    q.Refer_Field('process_name',
                  'process_id',
                  'mdf_sign_processes',
                  'process_id',
                  'name',
                  'select * 
                     from mdf_sign_processes k 
                    where k.company_id = :company_id 
                    order by k.order_no, k.name');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id
                      and exists (select 1
                             from md_user_filials w
                            where w.company_id = t.company_id
                              and w.user_id = t.user_id
                              and w.filial_id = :filial_id)');
  
    v_Matrix := Mdf_Pref.Sign_Kinds;
    q.Option_Field('sign_kind_name', 'sign_kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Mdf_Pref.Document_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure To_Progress(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Mdf_Api.Document_Process(i_Company_Id => v_Company_Id, i_Document_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mdf_Sign_Documents
       set Company_Id  = null,
           Document_Id = null,
           Filial_Id   = null,
           Sign_Kind   = null,
           Status      = null,
           Process_Id  = null,
           Title       = null,
           Note        = null,
           Created_By  = null,
           Created_On  = null;
    update Mdf_Sign_Processes
       set Company_Id    = null,
           Process_Id    = null,
           Project_Code  = null,
           Source_Table  = null,
           Source_Action = null,
           name          = null,
           Order_No      = null;
    update Md_Persons
       set Company_Id  = null,
           Person_Id   = null,
           name        = null,
           Person_Kind = null;
  end;

end Ui_Vhr652;
/
