create or replace package Ui_Vhr597 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Arraylist);
end Ui_Vhr597;
/
create or replace package body Ui_Vhr597 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select t.company_id,
                            t.filial_id,
                            t.division_id,
                            t.job_id,
                            count(t.doc_type_id) excluded_document_types_count
                       from href_excluded_document_types t
                      where t.company_id = :company_id
                        and t.filial_id = :filial_id
                        and exists (select 1
                               from href_document_types q
                              where q.company_id = t.company_id
                                and q.doc_type_id = t.doc_type_id
                                and q.is_required = ''Y''
                                and q.state = ''A'')
                      group by t.company_id, t.filial_id, t.division_id, t.job_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('division_id', 'job_id', 'excluded_document_types_count');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'select *
                     from mhr_jobs t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Arraylist) is
    v_Data Hashmap;
  begin
    for i in 1 .. p.Count
    loop
      v_Data := Treat(p.r_Hashmap(i) as Hashmap);
    
      Href_Api.Excluded_Document_Type_Delete(i_Company_Id  => Ui.Company_Id,
                                             i_Filial_Id   => Ui.Filial_Id,
                                             i_Division_Id => v_Data.r_Number('division_id'),
                                             i_Job_Id      => v_Data.r_Number('job_id'));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Excluded_Document_Types
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Job_Id      = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null;
  end;

end Ui_Vhr597;
/
