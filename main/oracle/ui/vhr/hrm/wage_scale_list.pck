create or replace package Ui_Vhr254 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr254;
/
create or replace package body Ui_Vhr254 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hrm_wage_scales q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'current_date',
                                 Trunc(sysdate)));
  
    q.Number_Field('wage_scale_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'full_name', 'state');
    q.Date_Field('last_changed_date', 'created_on', 'modified_on');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Map_Field('register_id',
                'select q.register_id
                   from hrm_wage_scale_registers q
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.wage_scale_id = $wage_scale_id
                    and q.posted = ''Y''
                    and q.register_date = (select max(d.register_date)
                                             from hrm_wage_scale_registers d
                                            where d.company_id = :company_id
                                              and d.filial_id = :filial_id
                                              and d.wage_scale_id = $wage_scale_id
                                              and d.valid_from  <= :current_date
                                              and d.posted = ''Y'')
                    and rownum = 1');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Id      number := Ui.Filial_Id;
    v_Wage_Scale_Ids Array_Number := Fazo.Sort(p.r_Array_Number('wage_scale_id'));
  begin
    for i in 1 .. v_Wage_Scale_Ids.Count
    loop
      Hrm_Api.Wage_Scale_Delete(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Wage_Scale_Id => v_Wage_Scale_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hrm_Wage_Scales
       set Company_Id        = null,
           Filial_Id         = null,
           Wage_Scale_Id     = null,
           name              = null,
           Full_Name         = null,
           State             = null,
           Last_Changed_Date = null,
           Created_By        = null,
           Created_On        = null,
           Modified_By       = null,
           Modified_On       = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  
    update Hrm_Wage_Scale_Registers
       set Company_Id    = null,
           Filial_Id     = null,
           Valid_From    = null,
           Wage_Scale_Id = null,
           Posted        = null;
  end;

end Ui_Vhr254;
/
