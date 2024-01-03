create or replace package Ui_Vhr487 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr487;
/
create or replace package body Ui_Vhr487 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_processes',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id),
                    true);
  
    q.Number_Field('process_id', 'created_by', 'modified_by');
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
                     from md_users t
                    where t.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
  
    q.Map_Field('action_names',
                'select listagg(s.name, '', '') within group(order by s.name)
                   from hsc_process_actions s
                  where s.process_id = $process_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Process_Ids Array_Number := Fazo.Sort(p.r_Array_Number('process_id'));
  begin
    for i in 1 .. v_Process_Ids.Count
    loop
      Hsc_Api.Process_Delete(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Process_Id => v_Process_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Processes
       set Company_Id  = null,
           Filial_Id   = null,
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

end Ui_Vhr487;
/
