create or replace package Ui_Vhr539 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr539;
/
create or replace package body Ui_Vhr539 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.name
                       from hsc_objects q
                       join mhr_divisions w
                         on w.company_id = q.company_id
                        and w.filial_id = q.filial_id
                        and w.division_id = q.object_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('object_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_areas',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('area_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hsc_drivers q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.pcode is null
                        and q.state = :state',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('driver_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
  
    result := Fazo.Zip_Map('actual_type', Hsc_Pref.c_Fact_Type_Actual);
  
    Result.Put('fact_types', Fazo.Zip_Matrix_Transposed(Hsc_Util.Driver_Fact_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('fact_type',
                           Nvl(p.o_Varchar2('fact_type'), Hsc_Pref.c_Fact_Type_Weekly_Predict),
                           'fact_date',
                           Trunc(sysdate));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Fact Hsc_Driver_Facts%rowtype;
    result Hashmap;
  begin
    r_Fact := z_Hsc_Driver_Facts.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Fact_Id    => p.r_Number('fact_id'));
  
    result := z_Hsc_Driver_Facts.To_Map(r_Fact,
                                        z.Fact_Id,
                                        z.Object_Id,
                                        z.Area_Id,
                                        z.Driver_Id,
                                        z.Fact_Date,
                                        z.Fact_Type,
                                        z.Fact_Value);
  
    Result.Put('object_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Fact.Company_Id, --
               i_Filial_Id => r_Fact.Filial_Id, --
               i_Division_Id => r_Fact.Object_Id).Name);
    Result.Put('area_name',
               z_Hsc_Areas.Load(i_Company_Id => r_Fact.Company_Id, --
               i_Filial_Id => r_Fact.Filial_Id, --
               i_Area_Id => r_Fact.Area_Id).Name);
    Result.Put('driver_name',
               z_Hsc_Drivers.Load(i_Company_Id => r_Fact.Company_Id, --
               i_Filial_Id => r_Fact.Filial_Id, --
               i_Driver_Id => r_Fact.Driver_Id).Name);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p         Hashmap,
    i_Fact_Id number
  ) return Hashmap is
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                            i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Fact_Id    => i_Fact_Id,
                            i_Object_Id  => p.r_Number('object_id'),
                            i_Area_Id    => p.r_Number('area_id'),
                            i_Driver_Id  => p.r_Number('driver_id'),
                            i_Fact_Date  => p.r_Date('fact_date'),
                            i_Fact_Type  => p.r_Varchar2('fact_type'),
                            i_Fact_Value => p.r_Number('fact_value'));
  
    Hsc_Api.Driver_Fact_Save(r_Fact);
  
    return Fazo.Zip_Map('fact_id', i_Fact_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hsc_Next.Driver_Fact_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
  begin
    return save(p, p.r_Number('fact_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Objects
       set Company_Id = null,
           Filial_Id  = null,
           Object_Id  = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           State       = null;
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null,
           State      = null;
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr539;
/
