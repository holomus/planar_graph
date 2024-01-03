create or replace package Ui_Vhr9 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr9;
/
create or replace package body Ui_Vhr9 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Parent_Id number := p.o_Number('parent_id');
    v_Query     varchar2(4000);
    v_Params    Hashmap := Hashmap();
    q           Fazo_Query;
    v_Kinds     Matrix_Varchar2 := Href_Util.Specialty_Kinds;
  begin
    v_Query := 'select * 
                  from href_specialties t 
                 where t.company_id = :company_id';
  
    v_Params.Put('company_id', Ui.Company_Id);
  
    if v_Parent_Id is not null then
      v_Query := v_Query || ' and t.parent_id = :parent_id';
      v_Params.Put('parent_id', v_Parent_Id);
    else
      v_Query := v_Query || ' and t.parent_id is null';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('specialty_id');
    q.Varchar2_Field('name', 'kind', 'state', 'code');
  
    q.Option_Field('kind_name', 'kind', v_Kinds(1), v_Kinds(2));
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Specialty_Ids Array_Number := Fazo.Sort(p.r_Array_Number('specialty_id'));
  begin
    for i in 1 .. v_Specialty_Ids.Count
    loop
      Href_Api.Specialty_Delete(i_Company_Id   => Ui.Company_Id,
                                i_Specialty_Id => v_Specialty_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Specialties
       set Company_Id   = null,
           Specialty_Id = null,
           name         = null,
           Kind         = null,
           Parent_Id    = null,
           State        = null,
           Code         = null;
  end;

end Ui_Vhr9;
/
