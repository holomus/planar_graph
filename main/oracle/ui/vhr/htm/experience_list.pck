create or replace package Ui_Vhr527 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr527;
/
create or replace package body Ui_Vhr527 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*, 
                            (select count(*)
                               from htm_experience_jobs w
                              where w.company_id = q.company_id
                                and w.filial_id = q.filial_id
                                and w.experience_id = q.experience_id) job_count
                       from htm_experiences q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('experience_id', 'order_no', 'job_count', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'state', 'code');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
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
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Ids Array_Number := Fazo.Sort(p.r_Array_Number('experience_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Htm_Api.Experience_Delete(i_Company_Id    => Ui.Company_Id,
                                i_Filial_Id     => Ui.Filial_Id,
                                i_Experience_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htm_Experiences
       set Company_Id    = null,
           Filial_Id     = null,
           Experience_Id = null,
           name          = null,
           Order_No      = null,
           State         = null,
           Code          = null,
           Created_By    = null,
           Created_On    = null,
           Modified_By   = null,
           Modified_On   = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
  end;

end Ui_Vhr527;
/
