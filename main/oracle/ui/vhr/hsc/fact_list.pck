create or replace package Ui_Vhr538 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Predicted return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Actual return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr538;
/
create or replace package body Ui_Vhr538 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Facts(i_Is_Actural boolean := true) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*
                  from hsc_driver_facts q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and (:access_all_employee = ''Y'' or q.object_id member of :allowed_divisions)';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Params.Put('allowed_divisions', Uit_Href.Get_All_Subordinate_Divisions);
    v_Params.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
  
    if i_Is_Actural then
      v_Query := v_Query || ' and q.fact_type = :actual_type ';
    
      v_Params.Put('actual_type', Hsc_Pref.c_Fact_Type_Actual);
    else
      v_Query := v_Query || ' and q.fact_type in (:weekly, :montly, :quarterly, :yearly) ';
    
      v_Params.Put('weekly', Hsc_Pref.c_Fact_Type_Weekly_Predict);
      v_Params.Put('montly', Hsc_Pref.c_Fact_Type_Montly_Predict);
      v_Params.Put('quarterly', Hsc_Pref.c_Fact_Type_Quarterly_Predict);
      v_Params.Put('yearly', Hsc_Pref.c_Fact_Type_Yearly_Predict);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('fact_id', 'object_id', 'area_id', 'driver_id', 'fact_value');
    q.Varchar2_Field('fact_type');
    q.Date_Field('fact_date');
  
    v_Matrix := Hsc_Util.Driver_Fact_Types;
  
    q.Option_Field('fact_type_name', 'fact_type', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field(i_Name             => 'object_name',
                  i_For              => 'object_id',
                  i_Table_Name       => 'select k.*
                                           from mhr_divisions k
                                          where k.company_id = :company_id
                                            and k.filial_id = :filial_id
                                            and exists (select 1
                                                          from hsc_objects ob
                                                         where ob.company_id = k.company_id
                                                           and ob.filial_id = k.filial_id
                                                           and ob.object_id = k.division_id)',
                  i_Code_Field       => 'division_id',
                  i_Name_Field       => 'name',
                  i_Table_For_Select => 'select k.*
                                           from mhr_divisions k
                                          where k.company_id = :company_id
                                            and k.filial_id = :filial_id
                                            and exists (select 1
                                                          from hsc_objects ob
                                                         where ob.company_id = k.company_id
                                                           and ob.filial_id = k.filial_id
                                                           and ob.object_id = k.division_id)');
  
    q.Refer_Field(i_Name             => 'area_name',
                  i_For              => 'area_id',
                  i_Table_Name       => 'select k.*
                                          from hsc_areas k
                                         where k.company_id = :company_id
                                           and k.filial_id = :filial_id',
                  i_Code_Field       => 'area_id',
                  i_Name_Field       => 'name',
                  i_Table_For_Select => 'select k.*
                                           from hsc_areas k
                                          where k.company_id = :company_id
                                            and k.filial_id = :filial_id');
  
    q.Refer_Field(i_Name             => 'driver_name',
                  i_For              => 'driver_id',
                  i_Table_Name       => 'select k.*
                                          from hsc_drivers k
                                         where k.company_id = :company_id
                                           and k.filial_id = :filial_id',
                  i_Code_Field       => 'driver_id',
                  i_Name_Field       => 'name',
                  i_Table_For_Select => 'select k.*
                                           from hsc_drivers k
                                          where k.company_id = :company_id
                                            and k.filial_id = :filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Predicted return Fazo_Query is
  begin
    return Query_Facts(false);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Actual return Fazo_Query is
  begin
    return Query_Facts;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('actual_type', Hsc_Pref.c_Fact_Type_Actual);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Fact_Ids Array_Number := Fazo.Sort(p.r_Array_Number('fact_id'));
  begin
    for i in 1 .. v_Fact_Ids.Count
    loop
      Hsc_Api.Driver_Fact_Delete(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Fact_Id    => v_Fact_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Driver_Facts
       set Company_Id = null,
           Filial_Id  = null,
           Fact_Id    = null,
           Object_Id  = null,
           Area_Id    = null,
           Driver_Id  = null,
           Fact_Date  = null,
           Fact_Type  = null,
           Fact_Value = null;
  
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null;
  
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null;
  
    update Hsc_Objects
       set Company_Id = null,
           Filial_Id  = null,
           Object_Id  = null;
  
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
  end;

end Ui_Vhr538;
/
