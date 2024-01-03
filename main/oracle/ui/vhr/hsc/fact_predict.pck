create or replace package Ui_Vhr551 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Predict_Facts_Response(i_Data Array_Varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Predict_Facts(p Hashmap) return Runtime_Service;
end Ui_Vhr551;
/
create or replace package body Ui_Vhr551 is
  ----------------------------------------------------------------------------------------------------
  g_Object_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Object_Id number := null) is
  begin
    g_Object_Id := i_Object_Id;
  end;

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
    return b.Translate('UI-VHR551:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    v_Object_Ids Array_Number;
  
    result Hashmap;
  begin
    select q.Object_Id
      bulk collect
      into v_Object_Ids
      from Hsc_Objects q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and exists (select 1
              from Mhr_Divisions w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Division_Id = q.Object_Id
               and w.State = 'A');
  
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
  
    Result.Put('object_ids', v_Object_Ids);
    Result.Put('fact_types', Fazo.Zip_Matrix_Transposed(Hsc_Util.Driver_Fact_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Min_Date date;
    v_Max_Date date;
    result     Hashmap;
  begin
    select min(Df.Fact_Date), max(Df.Fact_Date)
      into v_Min_Date, v_Max_Date
      from Hsc_Driver_Facts Df
     where Df.Company_Id = Ui.Company_Id
       and Df.Filial_Id = Ui.Filial_Id
       and Df.Fact_Type = Hsc_Pref.c_Fact_Type_Actual;
  
    result := Fazo.Zip_Map('fact_type',
                           Nvl(p.o_Varchar2('fact_type'), Hsc_Pref.c_Fact_Type_Weekly_Predict),
                           'train_begin',
                           v_Min_Date,
                           'train_end',
                           v_Max_Date,
                           'predict_begin',
                           v_Max_Date + 1,
                           'predict_end',
                           Trunc(sysdate));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Predict_Facts_Locally
  (
    i_Predict_Type  varchar2,
    i_Predict_Begin date,
    i_Predict_End   date,
    i_Area_Ids      Array_Number,
    i_Driver_Ids    Array_Number
  ) is
  begin
    if i_Predict_Type = Htt_Pref.c_Pattern_Kind_Weekly then
      return;
    end if;
  
    for r in (select Df.Area_Id, Df.Driver_Id
                from Hsc_Driver_Facts Df
               where Df.Company_Id = Ui.Company_Id
                 and Df.Filial_Id = Ui.Filial_Id
                 and Df.Object_Id = g_Object_Id
                 and Df.Area_Id member of i_Area_Ids
                 and Df.Driver_Id member of i_Driver_Ids
                 and Df.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
               group by Df.Area_Id, Df.Driver_Id)
    loop
      Hsc_Core.Calc_Local_Predict(i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Object_Id    => g_Object_Id,
                                  i_Area_Id      => r.Area_Id,
                                  i_Driver_Id    => r.Driver_Id,
                                  i_Begin_Date   => i_Predict_Begin,
                                  i_End_Date     => i_Predict_End,
                                  i_Predict_Type => i_Predict_Type);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Predict_Facts_Response(i_Data Array_Varchar2) return Hashmap is
  begin
    return Hsc_Facts.Predict_Facts_Response(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Object_Id  => g_Object_Id,
                                            i_Data       => i_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Predict_Facts(p Hashmap) return Runtime_Service is
    v_Train_Begin date := p.r_Date('train_begin');
    v_Train_End   date := p.r_Date('train_end');
    v_Object_Id   number := p.r_Number('object_id');
    v_Area_Ids    Array_Number := Nvl(p.o_Array_Number('area_ids'), Array_Number());
    v_Driver_Ids  Array_Number := Nvl(p.o_Array_Number('driver_ids'), Array_Number());
  
    v_Predict_Type  varchar2(1) := p.r_Varchar2('fact_type');
    v_Predict_Begin date := p.r_Date('predict_begin');
    v_Predict_End   date := p.r_Date('predict_end');
  
    v_Category   Gmap;
    v_Categories Glist := Glist();
  
    r_Settings Hsc_Server_Settings%rowtype;
  
    v_Data Gmap := Gmap();
  begin
    Init_Globals(i_Object_Id => v_Object_Id);
  
    if v_Area_Ids.Count = 0 then
      select q.Area_Id
        bulk collect
        into v_Area_Ids
        from Hsc_Areas q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.State = 'A'
         and exists (select 1
                from Hsc_Driver_Facts Df
               where Df.Company_Id = q.Company_Id
                 and Df.Filial_Id = q.Filial_Id
                 and Df.Object_Id = g_Object_Id
                 and Df.Area_Id = q.Area_Id);
    end if;
  
    if v_Driver_Ids.Count = 0 then
      select q.Driver_Id
        bulk collect
        into v_Driver_Ids
        from Hsc_Drivers q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.State = 'A'
         and exists (select 1
                from Hsc_Driver_Facts Df
               where Df.Company_Id = q.Company_Id
                 and Df.Filial_Id = q.Filial_Id
                 and Df.Object_Id = g_Object_Id
                 and Df.Driver_Id = q.Driver_Id);
    end if;
  
    /*if v_Predict_Type <> Hsc_Pref.c_Fact_Type_Weekly_Predict then
      Predict_Facts_Locally(i_Predict_Type  => v_Predict_Type,
                            i_Predict_Begin => v_Predict_Begin,
                            i_Predict_End   => v_Predict_End,
                            i_Area_Ids      => v_Area_Ids,
                            i_Driver_Ids    => v_Driver_Ids);
    
      return null;
    end if;*/
  
    for r in (select Df.Area_Id,
                     Df.Driver_Id,
                     Json_Arrayagg(Json_Object('fact_date' value to_char(Df.Fact_Date, 'yyyy-mm-dd'),
                                               'fact_value' value Df.Fact_Value) returning clob) Facts
                from Hsc_Driver_Facts Df
               where Df.Company_Id = Ui.Company_Id
                 and Df.Filial_Id = Ui.Filial_Id
                 and Df.Object_Id = g_Object_Id
                 and Df.Area_Id member of v_Area_Ids
                 and Df.Driver_Id member of
               v_Driver_Ids
                 and Df.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and Df.Fact_Date between v_Train_Begin and v_Train_End
               group by Df.Area_Id, Df.Driver_Id)
    loop
      v_Category := Gmap();
    
      v_Category.Put('area_id', r.Area_Id);
      v_Category.Put('driver_id', r.Driver_Id);
      v_Category.Val.Put('facts', r.Facts);
    
      v_Categories.Push(v_Category.Val);
    end loop;
  
    if v_Categories.Count = 0 then
      return null;
    end if;
  
    r_Settings := z_Hsc_Server_Settings.Take(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
  
    v_Data.Put('categories', v_Categories);
    v_Data.Put('predict_begin', to_char(v_Predict_Begin, 'yyyy-mm-dd'));
    v_Data.Put('predict_end', to_char(v_Predict_End, 'yyyy-mm-dd'));
    v_Data.Put('predict_type', v_Predict_Type);
  
    return Hsc_Core.Predict_Runtime_Service(i_Responce_Procedure => 'ui_vhr551.predict_facts_response',
                                            i_Host_Url           => r_Settings.Predict_Server_Url,
                                            i_Data               => v_Data,
                                            i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2);
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

end Ui_Vhr551;
/
