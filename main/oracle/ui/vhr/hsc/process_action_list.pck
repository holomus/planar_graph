create or replace package Ui_Vhr491 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr491;
/
create or replace package body Ui_Vhr491 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_process_actions',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'process_id',
                                 p.r_Number('process_id')),
                    true);
  
    q.Number_Field('action_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'state');
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
                  'select *
                     from md_users tВ
                    where t.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Action_Ids Array_Number := Fazo.Sort(p.r_Array_Number('action_id'));
  begin
    for i in 1 .. v_Action_Ids.Count
    loop
      Hsc_Api.Process_Action_Delete(i_Company_Id => Ui.Company_Id,
                                    i_Filial_Id  => Ui.Filial_Id,
                                    i_Action_Id  => v_Action_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Process_Actions
       set Company_Id  = null,
           Filial_Id   = null,
           Action_Id   = null,
           Process_Id  = null,
           name        = null,
           State       = null,
           Created_By  = null,
           Created_On  = null,
           Modified_By = null,
           Modified_On = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr491;
/
