create or replace package Ui_Vhr306 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Standart_Penalty return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Common_Penalty return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr306;
/
create or replace package body Ui_Vhr306 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Standart_Penalty return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.* 
                       from hpr_penalties q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.division_id is not null',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('penalty_id', 'division_id');
    q.Varchar2_Field('name', 'state');
    q.Date_Field('month');
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Common_Penalty return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.* 
                       from hpr_penalties q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.division_id is null',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('penalty_id');
    q.Varchar2_Field('name', 'state');
    q.Date_Field('month');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Penalty_Ids Array_Number := Fazo.Sort(p.r_Array_Number('penalty_id'));
  begin
    for i in 1 .. v_Penalty_Ids.Count
    loop
      Hpr_Api.Penalty_Delete(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Penalty_Id => v_Penalty_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hpr_Penalties
       set Company_Id  = null,
           Filial_Id   = null,
           Penalty_Id  = null,
           month       = null,
           Division_Id = null,
           State       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
  end;

end Ui_Vhr306;
/
