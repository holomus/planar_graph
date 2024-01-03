create or replace package Ui_Vhr87 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Migr(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr87;
/
create or replace package body Ui_Vhr87 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR87:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
    v_Query  := 'select w.person_id,
                        w.pin, 
                        d.name 
                   from htt_persons w 
                   join mr_natural_persons d 
                     on d.company_id = w.company_id 
                    and d.person_id = w.person_id
                    and d.state = ''A''
                  where w.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || --
                 ' and exists (select 1 
                          from mhr_employees k
                         where k.company_id = :company_id
                           and k.filial_id = :filial_id
                           and k.employee_id = w.person_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('person_id', 'pin');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hzk_migr_persons',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'device_id', p.r_Number('device_id')),
                    true);
  
    q.Number_Field('migr_person_id', 'pin');
    q.Varchar2_Field('person_name', 'person_role');
  
    v_Matrix := Htt_Util.Person_Roles;
  
    q.Option_Field('person_role_name', 'person_role', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr(p Hashmap) is
  begin
    Hzk_Api.Migr_Person_Save(i_Company_Id     => Ui.Company_Id,
                             i_Migr_Person_Id => p.r_Number('migr_person_id'),
                             i_Person_Id      => p.r_Number('person_id'),
                             i_Pin            => p.r_Number('pin'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Device_Id number := p.r_Number('device_id');
    v_Pins      Array_Number := Fazo.Sort(p.r_Array_Number('pin'));
  begin
    for i in 1 .. v_Pins.Count
    loop
      Hzk_Api.Migr_Person_Delete(i_Company_Id => Ui.Company_Id,
                                 i_Device_Id  => v_Device_Id,
                                 i_Pin        => v_Pins(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Persons
       set Company_Id = null,
           Person_Id  = null,
           Pin        = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Hzk_Migr_Persons
       set Company_Id     = null,
           Migr_Person_Id = null,
           Device_Id      = null,
           Pin            = null,
           Person_Name    = null,
           Person_Role    = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr87;
/
