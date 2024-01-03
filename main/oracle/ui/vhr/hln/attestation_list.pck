create or replace package Ui_Vhr246 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr246;
/
create or replace package body Ui_Vhr246 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
    v_Params Hashmap;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'ts_new',
                             Hln_Pref.c_Testing_Status_New,
                             'ts_executed',
                             Hln_Pref.c_Testing_Status_Executed,
                             'ts_paused',
                             Hln_Pref.c_Testing_Status_Paused,
                             'ts_checking',
                             Hln_Pref.c_Testing_Status_Checking);
  
    v_Params.Put('ts_finished', Hln_Pref.c_Testing_Status_Finished);
  
    q := Fazo_Query('select a.*,
                            at.new_testing_count,
                            at.executed_testing_count,
                            at.paused_testing_count,
                            at.checking_testing_count,
                            at.finished_testing_count
                       from hln_attestations a
                       join (select at.attestation_id,
                                    sum(decode(t.status, :ts_new, 1, 0)) new_testing_count,
                                    sum(decode(t.status, :ts_executed, 1, 0)) executed_testing_count,
                                    sum(decode(t.status, :ts_paused, 1, 0)) paused_testing_count,
                                    sum(decode(t.status, :ts_checking, 1, 0)) checking_testing_count,
                                    sum(decode(t.status, :ts_finished, 1, 0)) finished_testing_count
                               from hln_attestation_testings at
                               join hln_testings t
                                 on t.company_id = at.company_id
                                and t.filial_id = at.filial_id
                                and t.testing_id = at.testing_id
                              where at.company_id = :company_id
                                and at.filial_id = :filial_id
                              group by at.attestation_id) at
                         on at.attestation_id = a.attestation_id
                      where a.company_id = :company_id
                        and a.filial_id = :filial_id',
                    v_Params);
  
    q.Number_Field('attestation_id',
                   'examiner_id',
                   'created_by',
                   'modified_by',
                   'new_testing_count',
                   'executed_testing_count',
                   'paused_testing_count',
                   'checking_testing_count',
                   'finished_testing_count');
    q.Date_Field('attestation_date',
                 'begin_time_period_begin',
                 'begin_time_period_end',
                 'created_on',
                 'modified_on');
    q.Varchar2_Field('name', 'attestation_number', 'note', 'status');
  
    q.Refer_Field('examiner_name',
                  'examiner_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *  
                     from mr_natural_persons k
                    where k.company_id = :company_id
                      and exists (select 1 
                            from mrf_persons f
                           where f.company_id = k.company_id
                             and f.filial_id = :filial_id
                             and f.person_id = k.person_id)');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k
                    where k.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k 
                    where k.company_id = :company_id');
  
    v_Matrix := Hln_Util.Attestation_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Attestation_Ids Array_Number := Fazo.Sort(p.r_Array_Number('attestation_id'));
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
  begin
    for i in 1 .. v_Attestation_Ids.Count
    loop
      Hln_Api.Attestation_Delete(i_Company_Id     => v_Company_Id,
                                 i_Filial_Id      => v_Filial_Id,
                                 i_Attestation_Id => v_Attestation_Ids(i),
                                 i_User_Id        => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Attestations
       set Company_Id              = null,
           Filial_Id               = null,
           Attestation_Id          = null,
           Attestation_Number      = null,
           name                    = null,
           Attestation_Date        = null,
           Begin_Time_Period_Begin = null,
           Begin_Time_Period_End   = null,
           Examiner_Id             = null,
           Note                    = null,
           Status                  = null,
           Created_By              = null,
           Created_On              = null,
           Modified_By             = null,
           Modified_On             = null;
    update Hln_Attestation_Testings
       set Company_Id     = null,
           Filial_Id      = null,
           Attestation_Id = null,
           Testing_Id     = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
  end;

end Ui_Vhr246;
/
