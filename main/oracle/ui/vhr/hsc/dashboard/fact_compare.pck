create or replace package Ui_Vhr616 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Facts(p Hashmap) return Json_Array_t;
end Ui_Vhr616;
/
create or replace package body Ui_Vhr616 is
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
    return b.Translate('UI-VHR616:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

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
                    Fazo.Zip_Map('company_id',
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
                    Fazo.Zip_Map('company_id',
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
  Function Query_Drivers(p Hashmap) return Fazo_Query is
    v_Area_Id number := p.r_Number('area_id');
    v_Query   varchar2(4000);
    v_Params  Hashmap;
    q         Fazo_Query;
  begin
    v_Query := 'select q.*
                  from hsc_drivers q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.pcode is null
                   and q.state = :state';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id, 'state', 'A');
  
    if z_Hsc_Areas.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Area_Id => v_Area_Id).c_Drivers_Exist = 'Y' then
      v_Query := v_Query || ' and exists (select 1
                                     from hsc_area_drivers s
                                    where s.company_id = q.company_id
                                      and s.filial_id = q.filial_id
                                      and s.area_id = :area_id
                                      and s.driver_id = q.driver_id)';
    
      v_Params.Put('area_id', v_Area_Id);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('driver_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
  
    result := Fazo.Zip_Map('actual_type',
                           Hsc_Pref.c_Fact_Type_Actual,
                           'weekly_type',
                           Hsc_Pref.c_Fact_Type_Weekly_Predict,
                           'monthly_type',
                           Hsc_Pref.c_Fact_Type_Montly_Predict,
                           'quarterly_type',
                           Hsc_Pref.c_Fact_Type_Quarterly_Predict,
                           'yearly_type',
                           Hsc_Pref.c_Fact_Type_Yearly_Predict);
  
    Result.Put('plan_types', Fazo.Zip_Matrix_Transposed(Hsc_Util.Driver_Fact_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('begin_year',
                           to_number(to_char(Add_Months(sysdate, -24), 'YYYY')),
                           'end_year',
                           to_number(to_char(sysdate, 'YYYY')),
                           'begin_month',
                           to_number(to_char(Trunc(sysdate, 'YYYY'), 'MM')),
                           'end_month',
                           to_number(to_char(sysdate, 'MM')));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Facts(p Hashmap) return Json_Array_t is
    v_Object_Id   number := p.r_Number('object_id');
    v_Area_Id     number := p.r_Number('area_id');
    v_Driver_Id   number := p.r_Number('driver_id');
    v_Begin_Year  number := p.r_Number('begin_year');
    v_End_Year    number := p.r_Number('end_year');
    v_Begin_Month number := p.r_Number('begin_month');
    v_End_Month   number := p.r_Number('end_month');
    v_Facts       Gmap := Gmap();
    result        Glist := Glist();
  begin
    for r in (select Df.Fact_Date, Json_Objectagg(Df.Fact_Type value Round(Df.Fact_Value, 2)) Facts
                from Hsc_Driver_Facts Df
               where Df.Company_Id = Ui.Company_Id
                 and Df.Filial_Id = Ui.Filial_Id
                 and Df.Object_Id = v_Object_Id
                 and Df.Area_Id = v_Area_Id
                 and Df.Driver_Id = v_Driver_Id
                 and to_number(to_char(Df.Fact_Date, 'MM')) between v_Begin_Month and v_End_Month
                 and to_number(to_char(Df.Fact_Date, 'YYYY')) between v_Begin_Year and v_End_Year
                 and (Df.Fact_Type = Hsc_Pref.c_Fact_Type_Actual or
                     to_number(to_char(Df.Fact_Date, 'YYYY')) = v_End_Year)
               group by Df.Fact_Date)
    loop
      v_Facts.Val := Json_Object_t.Parse(r.Facts);
    
      v_Facts.Put('fact_date', r.Fact_Date);
    
      Result.Push(v_Facts.Val);
    end loop;
  
    return Result.Val;
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
           State      = null,
           Pcode      = null;
  
    update Hsc_Area_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           Driver_Id  = null;
  end;

end Ui_Vhr616;
/
