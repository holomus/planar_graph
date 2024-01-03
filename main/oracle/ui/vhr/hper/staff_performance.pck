create or replace package Ui_Vhr609 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats(p Hashmap) return Hashmap;
end Ui_Vhr609;
/
create or replace package body Ui_Vhr609 is
  ----------------------------------------------------------------------------------------------------
  c_Period_Kind_This_Year      constant varchar2(1) := 'T';
  c_Period_Kind_Last_Year      constant varchar2(1) := 'L';
  c_Period_Kind_Last_12_Months constant varchar2(1) := 'M';

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
    return b.Translate('UI-VHR609:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats
  (
    i_Employee_Id number,
    i_Period_Kind varchar2
  ) return Hashmap is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Curr_Date    date;
    v_Period_Begin date;
    v_Period_End   date;
  
    v_Staff_Id number;
    v_Years    Array_Number;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Init_Period is
    begin
      case i_Period_Kind
        when c_Period_Kind_This_Year then
          v_Period_Begin := Trunc(v_Curr_Date, 'YYYY');
          v_Period_End   := Add_Months(v_Period_Begin, 11);
        when c_Period_Kind_Last_Year then
          v_Period_Begin := Trunc(Add_Months(v_Curr_Date, -12), 'YYYY');
          v_Period_End   := Add_Months(v_Period_Begin, 11);
        when c_Period_Kind_Last_12_Months then
          v_Period_End   := Trunc(v_Curr_Date, 'MON');
          v_Period_Begin := Add_Months(v_Period_End, -11);
        else
          b.Raise_Not_Implemented;
      end case;
    
      v_Period_End := Least(v_Period_End, v_Curr_Date);
    end;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                 i_Filial_Id   => v_Filial_Id,
                                                 i_Employee_Id => i_Employee_Id);
    Result.Put('staff_id', v_Staff_Id);
  
    if v_Staff_Id is null then
      return result;
    end if;
  
    v_Curr_Date := Htt_Util.Get_Current_Date(i_Company_Id => v_Company_Id,
                                             i_Filial_Id  => v_Filial_Id);
    Init_Period;
  
    select Array_Varchar2(t.Plan_Date,
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = t.Company_Id
                              and j.Filial_Id = t.Filial_Id
                              and j.Job_Id = t.Job_Id),
                          (select d.Name
                             from Mhr_Divisions d
                            where d.Company_Id = t.Company_Id
                              and d.Filial_Id = t.Filial_Id
                              and d.Division_Id = t.Division_Id),
                          t.Main_Fact_Amount,
                          t.c_Main_Fact_Percent,
                          t.Extra_Fact_Amount,
                          t.c_Extra_Fact_Percent),
           Extract(year from t.Plan_Date)
      bulk collect
      into v_Matrix, v_Years
      from Hper_Staff_Plans t
     where t.Company_Id = v_Company_Id
       and t.Filial_Id = v_Filial_Id
       and t.Staff_Id = v_Staff_Id
       and t.Status = Hper_Pref.c_Staff_Plan_Status_Completed
       and t.Plan_Date between v_Period_Begin and v_Period_End
     order by t.Plan_Date;
  
    v_Years := set(v_Years);
  
    Result.Put('months', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('is_one_year', case when v_Years.Count > 1 then 'N' else 'Y' end);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    v_Employee_Id number := p.r_Number('employee_id');
    result        Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
  
    Result.Put('employee_id', v_Employee_Id);
  
    Result.Put_All(Load_Xy_Chart_Stats(i_Employee_Id => v_Employee_Id,
                                       i_Period_Kind => c_Period_Kind_Last_12_Months));
    Result.Put('period_kind', c_Period_Kind_Last_12_Months);
    Result.Put('period_kinds',
               Fazo.Zip_Matrix_Transposed(Matrix_Varchar2(Array_Varchar2(c_Period_Kind_This_Year,
                                                                         c_Period_Kind_Last_Year,
                                                                         c_Period_Kind_Last_12_Months),
                                                          Array_Varchar2(t('period_kind: this year'), --
                                                                         t('period_kind: last year'), --
                                                                         t('period_kind: last 12 months')))));
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats(p Hashmap) return Hashmap is
  begin
    return Load_Xy_Chart_Stats(i_Employee_Id => p.r_Number('employee_id'),
                               i_Period_Kind => p.r_Varchar2('period_kind'));
  end;

end Ui_Vhr609;
/
