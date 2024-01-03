create or replace package Ui_Vhr556 is
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
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr556;
/
create or replace package body Ui_Vhr556 is
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
    return b.Translate('UI-VHR556:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', --
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'state',
                             'A');
  
    v_Params.Put('allowed_divisions', Uit_Href.Get_All_Subordinate_Divisions);
    v_Params.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
  
    q := Fazo_Query('select q.*,
                            w.name
                       from hsc_objects q
                       join mhr_divisions w
                         on w.company_id = q.company_id
                        and w.filial_id = q.filial_id
                        and w.division_id = q.object_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and (:access_all_employee = ''Y'' or q.object_id member of :allowed_divisions)',
                    v_Params);
  
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
  
    v_Params := Fazo.Zip_Map('company_id', --
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'state',
                             'A');
  
    if z_Hsc_Areas.Load(i_Company_Id => Ui.Company_Id, --
     i_Filial_Id => Ui.Filial_Id, i_Area_Id => v_Area_Id).c_Drivers_Exist = 'Y' then
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
    result := Fazo.Zip_Map('plan_type',
                           Hsc_Pref.c_Fact_Type_Weekly_Predict,
                           'begin_date',
                           Trunc(sysdate),
                           'end_date',
                           Trunc(sysdate) + 6);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Facts(p Hashmap) return Json_Array_t is
    v_Object_Id number := p.r_Number('object_id');
    v_Area_Id   number := p.r_Number('area_id');
    v_Driver_Id number := p.r_Number('driver_id');
  
    v_Begin_Date date := p.r_Date('begin_date');
    v_End_Date   date := p.r_Date('end_date');
  
    v_Allowed_Divisions   Array_Number := Uit_Href.Get_All_Subordinate_Divisions;
    v_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
  
    v_Facts Gmap := Gmap();
  
    result Glist := Glist();
  begin
    if v_Access_All_Employee != 'Y' and v_Object_Id not member of v_Allowed_Divisions then
      b.Raise_Unauthorized;
    end if;
  
    for r in (select Df.Fact_Date, Json_Objectagg(Df.Fact_Type value Round(Df.Fact_Value, 2)) Facts
                from Hsc_Driver_Facts Df
               where Df.Company_Id = Ui.Company_Id
                 and Df.Filial_Id = Ui.Filial_Id
                 and Df.Object_Id = v_Object_Id
                 and Df.Area_Id = v_Area_Id
                 and Df.Driver_Id = v_Driver_Id
                 and Df.Fact_Date between v_Begin_Date and v_End_Date
               group by Df.Fact_Date)
    loop
      v_Facts.Val := Json_Object_t.Parse(r.Facts);
    
      v_Facts.Put('fact_date', r.Fact_Date);
    
      Result.Push(v_Facts.Val);
    end loop;
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Analysis
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number
  ) is
    a        b_Table := b_Report.New_Table();
    v_Column number := 1;
  
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    v_Allowed_Divisions   Array_Number := Uit_Href.Get_All_Subordinate_Divisions;
    v_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      Print_Header(t('type'), 1, 2, 200);
    
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        Print_Header(to_char(i_Begin_Date + i, 'DD'), 2, 1, 75);
      end loop;
    
      Print_Header(t('median error'), 1, 2, 75);
    
      a.New_Row;
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        Print_Header(to_char(i_Begin_Date + i, 'Dy', v_Nls_Language), 2, 1, null);
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Body is
      v_Fact_Type    varchar2(1);
      v_Fact_Value   number;
      v_Actual_Value number;
      v_Median_Error number;
    
      v_Errors     Array_Number;
      v_Fact_Types Array_Varchar2 := Array_Varchar2();
      v_Facts      Fazo.Number_Code_Aat;
    
      --------------------------------------------------
      Procedure Put_Fact
      (
        i_Fact_Type  varchar2,
        i_Fact_Date  date,
        i_Fact_Value number
      ) is
        v_Date_Key varchar2(10) := to_char(i_Fact_Date, 'yyyymmdd');
      begin
        v_Facts(v_Date_Key || ':' || i_Fact_Type) := i_Fact_Value;
      end;
    
      --------------------------------------------------
      Function Get_Fact
      (
        i_Fact_Type varchar2,
        i_Fact_Date date
      ) return number is
        v_Date_Key varchar2(10) := to_char(i_Fact_Date, 'yyyymmdd');
      begin
        return v_Facts(v_Date_Key || ':' || i_Fact_Type);
      exception
        when No_Data_Found then
          return null;
      end;
    
      --------------------------------------------------
      Function Sort_Types return Array_Varchar2 is
        result Array_Varchar2;
      begin
        select q.Column_Value
          bulk collect
          into result
          from table(v_Fact_Types) q
         order by Decode(q.Column_Value,
                         Hsc_Pref.c_Fact_Type_Actual,
                         0,
                         Hsc_Pref.c_Fact_Type_Weekly_Predict,
                         1,
                         Hsc_Pref.c_Fact_Type_Montly_Predict,
                         2,
                         Hsc_Pref.c_Fact_Type_Quarterly_Predict,
                         3,
                         4);
      
        return result;
      end;
    begin
      if v_Access_All_Employee != 'Y' and i_Object_Id not member of v_Allowed_Divisions then
        b.Raise_Unauthorized;
      end if;
    
      a.Current_Style('body_centralized');
    
      for r in (select Df.Fact_Type, Df.Fact_Date, Df.Fact_Value
                  from Hsc_Driver_Facts Df
                 where Df.Company_Id = i_Company_Id
                   and Df.Filial_Id = i_Filial_Id
                   and Df.Object_Id = i_Object_Id
                   and Df.Area_Id = i_Area_Id
                   and Df.Driver_Id = i_Driver_Id
                   and Df.Fact_Date between i_Begin_Date and i_End_Date)
      loop
        Put_Fact(i_Fact_Type  => r.Fact_Type,
                 i_Fact_Date  => r.Fact_Date,
                 i_Fact_Value => r.Fact_Value);
      
        if not Fazo.Contains(v_Fact_Types, r.Fact_Type) then
          Fazo.Push(v_Fact_Types, r.Fact_Type);
        end if;
      end loop;
    
      v_Fact_Types := Sort_Types;
    
      for t in 1 .. v_Fact_Types.Count
      loop
        v_Errors    := Array_Number();
        v_Fact_Type := v_Fact_Types(t);
      
        a.New_Row;
      
        a.Data(Hsc_Util.t_Driver_Fact_Type(v_Fact_Type));
      
        for i in 0 .. i_End_Date - i_Begin_Date
        loop
          v_Fact_Value   := Get_Fact(i_Fact_Type => v_Fact_Type, i_Fact_Date => i_Begin_Date + i);
          v_Actual_Value := Get_Fact(i_Fact_Type => Hsc_Pref.c_Fact_Type_Actual,
                                     i_Fact_Date => i_Begin_Date + i);
        
          if v_Fact_Type = Hsc_Pref.c_Fact_Type_Actual or v_Actual_Value is null or
             v_Actual_Value = 0 then
            a.Data(Round(v_Fact_Value, 2), i_Colspan => 2);
          elsif v_Fact_Value is null then
            a.Data('', i_Colspan => 2);
          else
            a.Data(Round(v_Fact_Value, 2));
          
            v_Fact_Value := (v_Fact_Value - v_Actual_Value) / v_Actual_Value * 100;
          
            Fazo.Push(v_Errors, v_Fact_Value);
          
            a.Data(Round(v_Fact_Value, 2));
          end if;
        end loop;
      
        if v_Errors.Count > 0 then
          select Median(Abs(q.Column_Value))
            into v_Median_Error
            from table(v_Errors) q;
        
          a.Data(Round(v_Median_Error, 2));
        else
          a.Add_Data(1);
        end if;
      end loop;
    end;
  
  begin
    Print_Header;
  
    Print_Body;
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    Run_Analysis(i_Company_Id => v_Company_Id,
                 i_Filial_Id  => v_Filial_Id,
                 i_Begin_Date => p.r_Date('begin_date'),
                 i_End_Date   => p.r_Date('end_date'),
                 i_Object_Id  => p.r_Number('object_id'),
                 i_Area_Id    => p.r_Number('area_id'),
                 i_Driver_Id  => p.r_Number('driver_id'));
  
    b_Report.Close_Book();
  end;

end Ui_Vhr556;
/
