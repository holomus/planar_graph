create or replace package Hsc_Core is
  ----------------------------------------------------------------------------------------------------
  Function Predict_Runtime_Service
  (
    i_Responce_Procedure varchar2,
    i_Data               Gmap := Gmap(),
    i_Host_Url           varchar2 := Hsc_Pref.c_Predict_Server_Url,
    i_Api_Uri            varchar2 := Hsc_Pref.c_Predict_Api_Uri,
    i_Api_Method         varchar2 := Hsc_Pref.c_Default_Http_Method,
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Ftp_File_Load_Service
  (
    i_Responce_Procedure varchar2,
    i_Server_Url         varchar2,
    i_Username           varchar2,
    i_Password           varchar2,
    i_Action             varchar2 := Hsc_Pref.c_Ftp_Action_Load_Files,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Priority
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Fact_Date  date,
    i_Fact_Type  varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Priority
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Fact_Date    date,
    i_Fact_Type    varchar2,
    i_Is_Increment boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Dirty_Areas;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Area
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Fact_Save(i_Fact Hsc_Driver_Facts%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Average_Mean_Predict
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Trend_Predict
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Local_Predict
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  );
end Hsc_Core;
/
create or replace package body Hsc_Core is
  ----------------------------------------------------------------------------------------------------
  c_Predict_Service_Name       constant varchar2(100) := 'com.verifix.vhr.predicts.PredictRuntimeService';
  c_Ftp_File_Load_Service_Name constant varchar2(100) := 'com.verifix.vhr.predicts.FtpFileLoadService';

  ----------------------------------------------------------------------------------------------------
  Function Predict_Runtime_Service
  (
    i_Responce_Procedure varchar2,
    i_Data               Gmap := Gmap(),
    i_Host_Url           varchar2 := Hsc_Pref.c_Predict_Server_Url,
    i_Api_Uri            varchar2 := Hsc_Pref.c_Predict_Api_Uri,
    i_Api_Method         varchar2 := Hsc_Pref.c_Default_Http_Method,
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    v_Service Runtime_Service;
    v_Details Hashmap := Hashmap();
  begin
    v_Details.Put('host_url', Nvl(i_Host_Url, Hsc_Pref.c_Predict_Server_Url));
    v_Details.Put('method', i_Api_Method);
    v_Details.Put('api_uri', i_Api_Uri);
  
    v_Service := Runtime_Service(c_Predict_Service_Name);
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(i_Data.Val.To_Clob()));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Responce_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Ftp_File_Load_Service
  (
    i_Responce_Procedure varchar2,
    i_Server_Url         varchar2,
    i_Username           varchar2,
    i_Password           varchar2,
    i_Action             varchar2 := Hsc_Pref.c_Ftp_Action_Load_Files,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    v_Service Runtime_Service;
    v_Details Hashmap := Hashmap();
  begin
    v_Details.Put('server_url', i_Server_Url);
    v_Details.Put('username', i_Username);
    v_Details.Put('password', i_Password);
    v_Details.Put('action', i_Action);
  
    v_Service := Runtime_Service(c_Ftp_File_Load_Service_Name);
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(i_Data.Val.To_Clob()));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Responce_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Priority
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Fact_Date  date,
    i_Fact_Type  varchar2
  ) return number is
    v_Fact_Types Array_Varchar2;
  
    result number;
  begin
    if i_Fact_Type = Hsc_Pref.c_Fact_Type_Actual then
      return 0;
    end if;
  
    v_Fact_Types := case i_Fact_Type
                      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
                       Array_Varchar2()
                      when Hsc_Pref.c_Fact_Type_Montly_Predict then
                       Array_Varchar2(Hsc_Pref.c_Fact_Type_Weekly_Predict)
                      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
                       Array_Varchar2(Hsc_Pref.c_Fact_Type_Weekly_Predict,
                                      Hsc_Pref.c_Fact_Type_Montly_Predict)
                      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
                       Array_Varchar2(Hsc_Pref.c_Fact_Type_Weekly_Predict,
                                      Hsc_Pref.c_Fact_Type_Montly_Predict,
                                      Hsc_Pref.c_Fact_Type_Quarterly_Predict)
                    end;
  
    select count(1) + 1
      into result
      from Hsc_Driver_Facts Df
     where Df.Company_Id = i_Company_Id
       and Df.Filial_Id = i_Filial_Id
       and Df.Object_Id = i_Object_Id
       and Df.Area_Id = i_Area_Id
       and Df.Driver_Id = i_Driver_Id
       and Df.Fact_Date = i_Fact_Date
       and Df.Fact_Type member of v_Fact_Types;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Priority
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Fact_Date    date,
    i_Fact_Type    varchar2,
    i_Is_Increment boolean := true
  ) is
    v_Fact_Types Array_Varchar2;
  
    v_Increment_Value number := 1;
  begin
    if i_Fact_Type = Hsc_Pref.c_Fact_Type_Actual then
      return;
    end if;
  
    v_Fact_Types := case i_Fact_Type
                      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
                       Array_Varchar2(Hsc_Pref.c_Fact_Type_Montly_Predict,
                                      Hsc_Pref.c_Fact_Type_Quarterly_Predict,
                                      Hsc_Pref.c_Fact_Type_Yearly_Predict)
                      when Hsc_Pref.c_Fact_Type_Montly_Predict then
                       Array_Varchar2(Hsc_Pref.c_Fact_Type_Quarterly_Predict,
                                      Hsc_Pref.c_Fact_Type_Yearly_Predict)
                      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
                       Array_Varchar2(Hsc_Pref.c_Fact_Type_Yearly_Predict)
                      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
                       Array_Varchar2()
                    end;
  
    if not i_Is_Increment then
      v_Increment_Value := -1;
    end if;
  
    update Hsc_Driver_Facts Df
       set Df.Priority = Greatest(Df.Priority + v_Increment_Value, 1)
     where Df.Company_Id = i_Company_Id
       and Df.Filial_Id = i_Filial_Id
       and Df.Object_Id = i_Object_Id
       and Df.Area_Id = i_Area_Id
       and Df.Driver_Id = i_Driver_Id
       and Df.Fact_Date = i_Fact_Date
       and Df.Fact_Type member of v_Fact_Types;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Dirty_Areas is
  begin
    for r in (select q.*,
                     Nvl((select 'Y'
                           from Hsc_Area_Drivers w
                          where w.Company_Id = q.Company_Id
                            and w.Filial_Id = q.Filial_Id
                            and w.Area_Id = q.Area_Id
                            and Rownum = 1),
                         'N') c_Drivers_Exist
                from Hsc_Dirty_Areas q)
    loop
      z_Hsc_Areas.Update_One(i_Company_Id      => r.Company_Id,
                             i_Filial_Id       => r.Filial_Id,
                             i_Area_Id         => r.Area_Id,
                             i_c_Drivers_Exist => Option_Varchar2(r.c_Drivers_Exist));
    end loop;
  
    delete Hsc_Dirty_Areas;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Area
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hsc_Dirty_Areas q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Area_Id = i_Area_Id;
  exception
    when No_Data_Found then
      insert into Hsc_Dirty_Areas
        (Company_Id, Filial_Id, Area_Id)
      values
        (i_Company_Id, i_Filial_Id, i_Area_Id);
    
      b.Add_Post_Callback('begin hsc_core.fix_dirty_areas; end;');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Fact_Save(i_Fact Hsc_Driver_Facts%rowtype) is
    v_Fact Hsc_Driver_Facts%rowtype := i_Fact;
    v_Old  Hsc_Driver_Facts%rowtype;
  begin
    if z_Hsc_Driver_Facts.Exist_Lock(i_Company_Id => i_Fact.Company_Id,
                                     i_Filial_Id  => i_Fact.Filial_Id,
                                     i_Fact_Id    => i_Fact.Fact_Id,
                                     o_Row        => v_Old) then
      v_Fact.Fact_Type := v_Old.Fact_Type;
      v_Fact.Priority  := v_Old.Priority;
    else
      v_Fact.Priority := Hsc_Core.Calc_Priority(i_Company_Id => i_Fact.Company_Id,
                                                i_Filial_Id  => i_Fact.Filial_Id,
                                                i_Object_Id  => i_Fact.Object_Id,
                                                i_Area_Id    => i_Fact.Area_Id,
                                                i_Driver_Id  => i_Fact.Driver_Id,
                                                i_Fact_Date  => i_Fact.Fact_Date,
                                                i_Fact_Type  => i_Fact.Fact_Type);
    
      Hsc_Core.Update_Priority(i_Company_Id => i_Fact.Company_Id,
                               i_Filial_Id  => i_Fact.Filial_Id,
                               i_Object_Id  => i_Fact.Object_Id,
                               i_Area_Id    => i_Fact.Area_Id,
                               i_Driver_Id  => i_Fact.Driver_Id,
                               i_Fact_Date  => i_Fact.Fact_Date,
                               i_Fact_Type  => i_Fact.Fact_Type);
    end if;
  
    z_Hsc_Driver_Facts.Save_Row(v_Fact);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Average_Mean_Predict_By_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Prev_Begin date;
    v_Prev_End   date;
  
    v_Prev_Sum number;
    v_Avg_Sum  number;
  
    v_Period_Trunc varchar2(4);
  
    v_Trend number;
  
    v_Fact_Date date;
  
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    case i_Predict_Type
      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
        v_Prev_End   := Trunc(i_Begin_Date, 'iw') - 1;
        v_Prev_Begin := Trunc(v_Prev_End, 'iw');
      
        v_Period_Trunc := 'dd';
      when Hsc_Pref.c_Fact_Type_Montly_Predict then
        v_Prev_End   := Trunc(i_Begin_Date, 'mon') - 1;
        v_Prev_Begin := Trunc(v_Prev_End, 'mon');
      
        v_Period_Trunc := 'mon';
      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
        v_Prev_End   := Trunc(i_Begin_Date, 'q') - 1;
        v_Prev_Begin := Trunc(v_Prev_End, 'q');
      
        v_Period_Trunc := 'q';
      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
        v_Prev_End   := Trunc(i_Begin_Date, 'yyyy') - 1;
        v_Prev_Begin := Trunc(v_Prev_End, 'yyyy');
      
        v_Period_Trunc := 'yyyy';
      else
        b.Raise_Not_Implemented;
    end case;
  
    select sum(q.Fact_Value)
      into v_Prev_Sum
      from Hsc_Driver_Facts q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and q.Area_Id = i_Area_Id
       and q.Driver_Id = i_Driver_Id
       and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
       and q.Fact_Date between v_Prev_Begin and v_Prev_End;
  
    select avg(Qr.Period_Sum)
      into v_Avg_Sum
      from (select sum(q.Fact_Value) Period_Sum
              from Hsc_Driver_Facts q
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Object_Id = i_Object_Id
               and q.Area_Id = i_Area_Id
               and q.Driver_Id = i_Driver_Id
               and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
             group by Trunc(q.Fact_Date, v_Period_Trunc)) Qr;
  
    v_Trend := v_Prev_Sum / v_Avg_Sum;
  
    for r in (select avg(q.Fact_Value) Fact_Value, to_char(q.Fact_Date, 'mmdd') Fact_Date_Str
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and to_number(to_char(q.Fact_Date, 'mmdd')) between
                     to_number(to_char(i_Begin_Date, 'mmdd')) and
                     to_number(to_char(i_End_Date, 'mmdd'))
                 and q.Fact_Date < i_Begin_Date
               group by to_char(q.Fact_Date, 'mmdd'))
    loop
      continue when r.Fact_Date_Str = '0229' and mod(Extract(year from i_Begin_Date), 4) <> 0;
      continue when r.Fact_Value is null;
    
      v_Trend := Nvl(v_Trend, 1);
    
      if Extract(year from i_Begin_Date) = Extract(year from i_End_Date) then
        v_Fact_Date := to_date(Extract(year from i_Begin_Date) || r.Fact_Date_Str, 'yyyymmdd');
      else
        -- if month is DECEMBER then take begin_date year
        -- else take end_date year
        if to_number(r.Fact_Date_Str) > 1200 then
          v_Fact_Date := to_date(Extract(year from i_Begin_Date) || r.Fact_Date_Str, 'yyyymmdd');
        else
          v_Fact_Date := to_date(Extract(year from i_End_Date) || r.Fact_Date_Str, 'yyyymmdd');
        end if;
      end if;
    
      z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                              i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Fact_Id    => Hsc_Util.Next_Fact_Id(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Object_Id  => i_Object_Id,
                                                                    i_Area_Id    => i_Area_Id,
                                                                    i_Driver_Id  => i_Driver_Id,
                                                                    i_Fact_Type  => i_Predict_Type,
                                                                    i_Fact_Date  => v_Fact_Date),
                              i_Object_Id  => i_Object_Id,
                              i_Area_Id    => i_Area_Id,
                              i_Driver_Id  => i_Driver_Id,
                              i_Fact_Type  => i_Predict_Type,
                              i_Fact_Date  => v_Fact_Date,
                              i_Fact_Value => r.Fact_Value * v_Trend);
    
      Driver_Fact_Save(r_Fact);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Average_Mean_Predict
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Start_Date date := i_Begin_Date;
    v_End_Date   date;
  begin
    case i_Predict_Type
      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'iw');
      when Hsc_Pref.c_Fact_Type_Montly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'mon');
      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'q');
      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'yyyy');
      else
        b.Raise_Not_Implemented;
    end case;
  
    while v_Start_Date <= i_End_Date
    loop
      case i_Predict_Type
        when Hsc_Pref.c_Fact_Type_Weekly_Predict then
          v_End_Date := v_Start_Date + 6;
        when Hsc_Pref.c_Fact_Type_Montly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
          v_End_Date := Htt_Util.Quarter_Last_Day(v_Start_Date);
        when Hsc_Pref.c_Fact_Type_Yearly_Predict then
          v_End_Date := Htt_Util.Year_Last_Day(v_Start_Date);
        else
          b.Raise_Not_Implemented;
      end case;
    
      Calc_Average_Mean_Predict_By_Period(i_Company_Id   => i_Company_Id,
                                          i_Filial_Id    => i_Filial_Id,
                                          i_Object_Id    => i_Object_Id,
                                          i_Area_Id      => i_Area_Id,
                                          i_Driver_Id    => i_Driver_Id,
                                          i_Begin_Date   => v_Start_Date,
                                          i_End_Date     => v_End_Date,
                                          i_Predict_Type => i_Predict_Type);
    
      v_Start_Date := v_End_Date + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Trend_Predict_By_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Double_Year_Prev_Begin date;
    v_Double_Year_Prev_End   date;
    v_Year_Prev_Begin        date;
    v_Year_Prev_End          date;
  
    v_Double_Prev_Begin date;
    v_Double_Prev_End   date;
    v_Prev_Begin        date;
    v_Prev_End          date;
  
    v_Prev_Sum        number;
    v_Double_Prev_Sum number;
  
    v_Recent_Trend number;
    v_Year_Trend   number;
  
    v_Fact_Date  date;
    v_Fact_Value number;
  
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    if i_Predict_Type <> Hsc_Pref.c_Fact_Type_Weekly_Predict and
       Trunc(i_Begin_Date, 'mon') <> Trunc(i_End_Date, 'mon') then
      b.Raise_Fatal('function: Calc_Trend_Predict_By_Period is only allowed for the same month');
    end if;
  
    v_Year_Prev_Begin        := Add_Months(i_Begin_Date, -12);
    v_Year_Prev_End          := Add_Months(i_End_Date, -12);
    v_Double_Year_Prev_Begin := Add_Months(v_Year_Prev_Begin, -12);
    v_Double_Year_Prev_End   := Add_Months(v_Year_Prev_End, -12);
  
    case i_Predict_Type
      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
        v_Prev_Begin := i_Begin_Date - 7;
        v_Prev_End   := i_End_Date - 7;
      
        v_Double_Prev_Begin := v_Prev_Begin - 7;
        v_Double_Prev_End   := v_Prev_End - 7;
      when Hsc_Pref.c_Fact_Type_Montly_Predict then
        v_Prev_Begin := i_Begin_Date - 31;
        v_Prev_End   := i_End_Date - 31;
      
        v_Double_Prev_Begin := v_Prev_Begin - 31;
        v_Double_Prev_End   := v_Prev_End - 31;
      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
        v_Prev_Begin := i_Begin_Date - 93;
        v_Prev_End   := i_End_Date - 93;
      
        v_Double_Prev_Begin := v_Prev_Begin - 93;
        v_Double_Prev_End   := v_Prev_End - 93;
      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
        v_Prev_Begin := i_Begin_Date - 366;
        v_Prev_End   := i_End_Date - 366;
      
        v_Double_Prev_Begin := v_Prev_Begin - 366;
        v_Double_Prev_End   := v_Prev_End - 366;
      else
        b.Raise_Not_Implemented;
    end case;
  
    select avg(q.Fact_Value)
      into v_Prev_Sum
      from Hsc_Driver_Facts q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and q.Area_Id = i_Area_Id
       and q.Driver_Id = i_Driver_Id
       and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
       and q.Fact_Date between v_Prev_Begin and v_Prev_End;
  
    select avg(q.Fact_Value)
      into v_Double_Prev_Sum
      from Hsc_Driver_Facts q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and q.Area_Id = i_Area_Id
       and q.Driver_Id = i_Driver_Id
       and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
       and q.Fact_Date between v_Double_Prev_Begin and v_Double_Prev_End;
  
    if v_Double_Prev_Sum = 0 then
      v_Double_Prev_Sum := null;
    end if;
  
    v_Recent_Trend := v_Prev_Sum / v_Double_Prev_Sum - 1;
  
    select avg(q.Fact_Value)
      into v_Prev_Sum
      from Hsc_Driver_Facts q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and q.Area_Id = i_Area_Id
       and q.Driver_Id = i_Driver_Id
       and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
       and q.Fact_Date between v_Year_Prev_Begin and v_Year_Prev_End;
  
    select avg(q.Fact_Value)
      into v_Double_Prev_Sum
      from Hsc_Driver_Facts q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and q.Area_Id = i_Area_Id
       and q.Driver_Id = i_Driver_Id
       and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
       and q.Fact_Date between v_Double_Year_Prev_Begin and v_Double_Year_Prev_End;
  
    if v_Double_Prev_Sum = 0 then
      v_Double_Prev_Sum := null;
    end if;
  
    v_Year_Trend := v_Prev_Sum / v_Double_Prev_Sum - 1;
  
    v_Recent_Trend := Nvl(v_Recent_Trend, 0);
    v_Year_Trend   := Nvl(v_Year_Trend, 0);
  
    for r in (select max(q.Fact_Value) Keep(Dense_Rank last order by q.Fact_Date) Fact_Value,
                     to_char(q.Fact_Date, 'mmdd') Fact_Date_Str
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and to_number(to_char(q.Fact_Date, 'mmdd')) between
                     to_number(to_char(i_Begin_Date, 'mmdd')) and
                     to_number(to_char(i_End_Date, 'mmdd'))
               group by to_char(q.Fact_Date, 'mmdd'))
    loop
      continue when r.Fact_Date_Str = '0229' and mod(Extract(year from i_Begin_Date), 4) <> 0;
      continue when r.Fact_Value is null;
    
      if Extract(year from i_Begin_Date) = Extract(year from i_End_Date) then
        v_Fact_Date := to_date(Extract(year from i_Begin_Date) || r.Fact_Date_Str, 'yyyymmdd');
      else
        -- if month is DECEMBER then take begin_date year
        -- else take end_date year
        if to_number(r.Fact_Date_Str) > 1200 then
          v_Fact_Date := to_date(Extract(year from i_Begin_Date) || r.Fact_Date_Str, 'yyyymmdd');
        else
          v_Fact_Date := to_date(Extract(year from i_End_Date) || r.Fact_Date_Str, 'yyyymmdd');
        end if;
      end if;
    
      v_Fact_Value := r.Fact_Value + r.Fact_Value * v_Recent_Trend + r.Fact_Value * v_Year_Trend;
    
      z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                              i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Fact_Id    => Hsc_Util.Next_Fact_Id(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Object_Id  => i_Object_Id,
                                                                    i_Area_Id    => i_Area_Id,
                                                                    i_Driver_Id  => i_Driver_Id,
                                                                    i_Fact_Type  => i_Predict_Type,
                                                                    i_Fact_Date  => v_Fact_Date),
                              i_Object_Id  => i_Object_Id,
                              i_Area_Id    => i_Area_Id,
                              i_Driver_Id  => i_Driver_Id,
                              i_Fact_Type  => i_Predict_Type,
                              i_Fact_Date  => v_Fact_Date,
                              i_Fact_Value => v_Fact_Value);
    
      Driver_Fact_Save(r_Fact);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Trend_Predict
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Start_Date date := i_Begin_Date;
    v_End_Date   date;
  begin
    case i_Predict_Type
      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'iw');
      when Hsc_Pref.c_Fact_Type_Montly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'mon');
      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'q');
      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'yyyy');
      else
        b.Raise_Not_Implemented;
    end case;
  
    while v_Start_Date <= i_End_Date
    loop
      case i_Predict_Type
        when Hsc_Pref.c_Fact_Type_Weekly_Predict then
          v_End_Date := v_Start_Date + 6;
        when Hsc_Pref.c_Fact_Type_Montly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        when Hsc_Pref.c_Fact_Type_Yearly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        else
          b.Raise_Not_Implemented;
      end case;
    
      Calc_Trend_Predict_By_Period(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Object_Id    => i_Object_Id,
                                   i_Area_Id      => i_Area_Id,
                                   i_Driver_Id    => i_Driver_Id,
                                   i_Begin_Date   => v_Start_Date,
                                   i_End_Date     => v_End_Date,
                                   i_Predict_Type => i_Predict_Type);
    
      v_Start_Date := v_End_Date + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Weekday_Means
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Array_Number is
    result Array_Number := Array_Number();
  begin
    Result.Extend(7);
  
    for r in (select q.Fact_Date - Trunc(q.Fact_Date, 'iw') + 1 Weekday_No,
                     avg(q.Fact_Value) Fact_Value
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and q.Fact_Date between i_Begin_Date and i_End_Date
               group by q.Fact_Date - Trunc(q.Fact_Date, 'iw') + 1)
    loop
      result(r.Weekday_No) := r.Fact_Value;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Monthly_Predict_By_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Year_Prev_Begin date;
    v_Year_Prev_End   date;
  
    v_Double_Prev_Begin date;
    v_Double_Prev_End   date;
    v_Prev_Begin        date;
    v_Prev_End          date;
  
    v_Trend_Prev_Begin   date;
    v_Trend_Prev_End     date;
    v_Trend_Double_Begin date;
    v_Trend_Double_End   date;
  
    v_Prev_Coef    number;
    v_Year_Coef    number;
    v_History_Coef number;
    v_Trend_Coef   number;
  
    v_Iter_Begin date;
    v_Iter_End   date;
  
    v_Fact_Date  date;
    v_Fact_Value number;
  
    v_Weekday_No number;
  
    r_Fact Hsc_Driver_Facts%rowtype;
  
    v_Prev_Means        Array_Number;
    v_Double_Prev_Means Array_Number;
    v_Year_Prev_Means   Array_Number;
  
    v_Trend_Prev_Means   Array_Number;
    v_Trend_Double_Means Array_Number;
  begin
    if i_Predict_Type <> Hsc_Pref.c_Fact_Type_Montly_Predict then
      b.Raise_Error('only monthly allowed');
    end if;
  
    if i_Predict_Type <> Hsc_Pref.c_Fact_Type_Weekly_Predict and
       Trunc(i_Begin_Date, 'mon') <> Trunc(i_End_Date, 'mon') then
      b.Raise_Fatal('function: Calc_Trend_Predict_By_Period is only allowed for the same month');
    end if;
  
    v_Prev_Begin := Add_Months(i_Begin_Date, -1);
    v_Prev_End   := Add_Months(i_End_Date, -1);
  
    v_Double_Prev_Begin := Add_Months(v_Prev_Begin, -1);
    v_Double_Prev_End   := Add_Months(v_Prev_End, -1);
  
    v_Year_Prev_Begin := Add_Months(v_Prev_Begin, -12);
    v_Year_Prev_End   := Add_Months(v_Prev_End, -12);
  
    v_Trend_Prev_End   := Trunc(i_Begin_Date, 'iw') - 1;
    v_Trend_Prev_Begin := Trunc(v_Trend_Prev_End, 'iw');
  
    v_Trend_Double_End   := v_Trend_Prev_Begin - 1;
    v_Trend_Double_Begin := Trunc(v_Trend_Double_End, 'iw');
  
    v_Iter_Begin := Add_Months(i_Begin_Date, -12) + 1;
    v_Iter_End   := Add_Months(i_End_Date, -12) + 1;
  
    if mod(Extract(year from i_Begin_Date), 4) = 0 then
      v_Iter_Begin := v_Iter_Begin + 1;
      v_Iter_End   := v_Iter_End + 1;
    end if;
  
    v_Prev_Means := Calc_Weekday_Means(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Object_Id  => i_Object_Id,
                                       i_Area_Id    => i_Area_Id,
                                       i_Driver_Id  => i_Driver_Id,
                                       i_Begin_Date => v_Prev_Begin,
                                       i_End_Date   => v_Prev_End);
  
    v_Double_Prev_Means := Calc_Weekday_Means(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Object_Id  => i_Object_Id,
                                              i_Area_Id    => i_Area_Id,
                                              i_Driver_Id  => i_Driver_Id,
                                              i_Begin_Date => v_Double_Prev_Begin,
                                              i_End_Date   => v_Double_Prev_End);
  
    v_Year_Prev_Means := Calc_Weekday_Means(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Object_Id  => i_Object_Id,
                                            i_Area_Id    => i_Area_Id,
                                            i_Driver_Id  => i_Driver_Id,
                                            i_Begin_Date => v_Year_Prev_Begin,
                                            i_End_Date   => v_Year_Prev_End);
  
    v_Trend_Prev_Means := Calc_Weekday_Means(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Object_Id  => i_Object_Id,
                                             i_Area_Id    => i_Area_Id,
                                             i_Driver_Id  => i_Driver_Id,
                                             i_Begin_Date => v_Trend_Prev_Begin,
                                             i_End_Date   => v_Trend_Prev_End);
  
    v_Trend_Double_Means := Calc_Weekday_Means(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Object_Id  => i_Object_Id,
                                               i_Area_Id    => i_Area_Id,
                                               i_Driver_Id  => i_Driver_Id,
                                               i_Begin_Date => v_Trend_Double_Begin,
                                               i_End_Date   => v_Trend_Double_End);
  
    for r in (select q.*
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and q.Fact_Date between v_Iter_Begin and v_Iter_End)
    loop
      v_Fact_Date := r.Fact_Date;
    
      if mod(Extract(year from v_Fact_Date), 4) = 0 then
        v_Fact_Date := v_Fact_Date - 1;
      end if;
    
      v_Fact_Date := Add_Months(v_Fact_Date - 1, 12);
    
      v_Weekday_No := Htt_Util.Iso_Week_Day_No(v_Fact_Date);
    
      v_Prev_Coef  := Nvl(v_Prev_Means(v_Weekday_No) / Nullif(v_Double_Prev_Means(v_Weekday_No), 0),
                          1);
      v_Year_Coef  := Nvl(v_Prev_Means(v_Weekday_No) / Nullif(v_Year_Prev_Means(v_Weekday_No), 0),
                          1);
      v_Trend_Coef := Nvl(v_Trend_Prev_Means(v_Weekday_No) /
                          Nullif(v_Trend_Double_Means(v_Weekday_No), 0),
                          1);
    
      v_History_Coef := (v_Prev_Coef + v_Year_Coef) / 2;
    
      v_Fact_Value := r.Fact_Value * v_History_Coef * v_Trend_Coef;
    
      z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                              i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Fact_Id    => Hsc_Util.Next_Fact_Id(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Object_Id  => i_Object_Id,
                                                                    i_Area_Id    => i_Area_Id,
                                                                    i_Driver_Id  => i_Driver_Id,
                                                                    i_Fact_Type  => i_Predict_Type,
                                                                    i_Fact_Date  => v_Fact_Date),
                              i_Object_Id  => i_Object_Id,
                              i_Area_Id    => i_Area_Id,
                              i_Driver_Id  => i_Driver_Id,
                              i_Fact_Type  => i_Predict_Type,
                              i_Fact_Date  => v_Fact_Date,
                              i_Fact_Value => v_Fact_Value);
    
      Driver_Fact_Save(r_Fact);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Yearly_Predict_By_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Constant_Coef number := 0.85;
  
    v_Prev_Begin date;
    v_Prev_End   date;
  
    v_Week_Day_No     number;
    v_Average         number;
    v_Average_Coef    number := 0.65;
    v_Weekly_Averages Array_Number := Array_Number();
  
    v_Iter_Begin date;
    v_Iter_End   date;
  
    v_Fact_Date  date;
    v_Fact_Value number;
  
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    if i_Predict_Type <> Hsc_Pref.c_Fact_Type_Yearly_Predict then
      b.Raise_Error('only yearly allowed');
    end if;
  
    if i_Predict_Type <> Hsc_Pref.c_Fact_Type_Weekly_Predict and
       Trunc(i_Begin_Date, 'mon') <> Trunc(i_End_Date, 'mon') then
      b.Raise_Fatal('function: Calc_Trend_Predict_By_Period is only allowed for the same month');
    end if;
  
    v_Iter_Begin := Add_Months(i_Begin_Date, -12) + 1;
    v_Iter_End   := Add_Months(i_End_Date, -12) + 1;
  
    if mod(Extract(year from i_Begin_Date), 4) = 0 then
      v_Iter_Begin := v_Iter_Begin + 1;
      v_Iter_End   := v_Iter_End + 1;
    end if;
  
    v_Prev_End   := Trunc(i_Begin_Date, 'yyyy') - 1;
    v_Prev_Begin := Trunc(v_Prev_End, 'yyyy');
  
    v_Weekly_Averages.Extend(7);
  
    for r in (select avg(Abs(q.Fact_Value)) Avgs,
                     Trunc(q.Fact_Date) - Trunc(q.Fact_Date, 'iw') + 1 Day_Week_No
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and q.Fact_Date between v_Prev_Begin and v_Prev_End
               group by Trunc(q.Fact_Date) - Trunc(q.Fact_Date, 'iw') + 1)
    loop
      v_Weekly_Averages(r.Day_Week_No) := r.Avgs;
    end loop;
  
    for r in (select q.*
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and q.Fact_Date between v_Iter_Begin and v_Iter_End)
    loop
      v_Fact_Date := r.Fact_Date;
    
      if mod(Extract(year from v_Fact_Date), 4) = 0 then
        v_Fact_Date := v_Fact_Date - 1;
      end if;
    
      v_Fact_Date := Add_Months(v_Fact_Date - 1, 12);
    
      v_Fact_Value := r.Fact_Value * v_Constant_Coef;
    
      v_Week_Day_No := Htt_Util.Iso_Week_Day_No(v_Fact_Date);
    
      v_Average := v_Weekly_Averages(v_Week_Day_No);
    
      if Abs(v_Fact_Value) < Abs(v_Average) * v_Average_Coef then
        v_Fact_Value := v_Average * v_Average_Coef;
      end if;
    
      z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                              i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Fact_Id    => Hsc_Util.Next_Fact_Id(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Object_Id  => i_Object_Id,
                                                                    i_Area_Id    => i_Area_Id,
                                                                    i_Driver_Id  => i_Driver_Id,
                                                                    i_Fact_Type  => i_Predict_Type,
                                                                    i_Fact_Date  => v_Fact_Date),
                              i_Object_Id  => i_Object_Id,
                              i_Area_Id    => i_Area_Id,
                              i_Driver_Id  => i_Driver_Id,
                              i_Fact_Type  => i_Predict_Type,
                              i_Fact_Date  => v_Fact_Date,
                              i_Fact_Value => v_Fact_Value);
    
      Driver_Fact_Save(r_Fact);
    end loop;
  
    v_Iter_Begin := Add_Months(i_Begin_Date, -24) + 1;
    v_Iter_End   := Add_Months(i_End_Date, -24) + 1;
  
    if mod(Extract(year from i_Begin_Date), 4) = 0 then
      v_Iter_Begin := v_Iter_Begin + 1;
      v_Iter_End   := v_Iter_End + 1;
    end if;
  
    for r in (select q.*
                from Hsc_Driver_Facts q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Object_Id = i_Object_Id
                 and q.Area_Id = i_Area_Id
                 and q.Driver_Id = i_Driver_Id
                 and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and q.Fact_Date between v_Iter_Begin and v_Iter_End
                 and not exists (select *
                        from Hsc_Driver_Facts p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Object_Id = i_Object_Id
                         and p.Area_Id = i_Area_Id
                         and p.Driver_Id = i_Driver_Id
                         and p.Fact_Type = Hsc_Pref.c_Fact_Type_Yearly_Predict
                         and p.Fact_Date between i_Begin_Date and i_End_Date
                         and p.Fact_Date = Add_Months(q.Fact_Date - 1, 24)))
    loop
      v_Fact_Date := r.Fact_Date;
    
      if mod(Extract(year from v_Fact_Date), 4) = 0 then
        v_Fact_Date := v_Fact_Date - 1;
      end if;
    
      v_Fact_Date := Add_Months(v_Fact_Date - 1, 24);
    
      v_Fact_Value := r.Fact_Value * v_Constant_Coef;
    
      v_Week_Day_No := Htt_Util.Iso_Week_Day_No(v_Fact_Date);
    
      v_Average := v_Weekly_Averages(v_Week_Day_No);
    
      if Abs(v_Fact_Value) < Abs(v_Average) * v_Average_Coef then
        v_Fact_Value := v_Average * v_Average_Coef;
      end if;
    
      z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                              i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Fact_Id    => Hsc_Util.Next_Fact_Id(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Object_Id  => i_Object_Id,
                                                                    i_Area_Id    => i_Area_Id,
                                                                    i_Driver_Id  => i_Driver_Id,
                                                                    i_Fact_Type  => i_Predict_Type,
                                                                    i_Fact_Date  => v_Fact_Date),
                              i_Object_Id  => i_Object_Id,
                              i_Area_Id    => i_Area_Id,
                              i_Driver_Id  => i_Driver_Id,
                              i_Fact_Type  => i_Predict_Type,
                              i_Fact_Date  => v_Fact_Date,
                              i_Fact_Value => v_Fact_Value);
    
      Driver_Fact_Save(r_Fact);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calc_Local_Predict
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Area_Id      number,
    i_Driver_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Predict_Type varchar2
  ) is
    v_Start_Date date := i_Begin_Date;
    v_End_Date   date;
  begin
    case i_Predict_Type
      when Hsc_Pref.c_Fact_Type_Weekly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'iw');
      when Hsc_Pref.c_Fact_Type_Montly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'mon');
      when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'q');
      when Hsc_Pref.c_Fact_Type_Yearly_Predict then
        v_Start_Date := Trunc(v_Start_Date, 'yyyy');
      else
        b.Raise_Not_Implemented;
    end case;
  
    while v_Start_Date <= i_End_Date
    loop
      case i_Predict_Type
        when Hsc_Pref.c_Fact_Type_Weekly_Predict then
          v_End_Date := v_Start_Date + 6;
        when Hsc_Pref.c_Fact_Type_Montly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        when Hsc_Pref.c_Fact_Type_Yearly_Predict then
          v_End_Date := Last_Day(v_Start_Date);
        else
          b.Raise_Not_Implemented;
      end case;
    
      if i_Predict_Type = Hsc_Pref.c_Fact_Type_Montly_Predict then
        Calc_Monthly_Predict_By_Period(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Object_Id    => i_Object_Id,
                                       i_Area_Id      => i_Area_Id,
                                       i_Driver_Id    => i_Driver_Id,
                                       i_Begin_Date   => v_Start_Date,
                                       i_End_Date     => v_End_Date,
                                       i_Predict_Type => i_Predict_Type);
      elsif i_Predict_Type = Hsc_Pref.c_Fact_Type_Yearly_Predict then
        Calc_Yearly_Predict_By_Period(i_Company_Id   => i_Company_Id,
                                      i_Filial_Id    => i_Filial_Id,
                                      i_Object_Id    => i_Object_Id,
                                      i_Area_Id      => i_Area_Id,
                                      i_Driver_Id    => i_Driver_Id,
                                      i_Begin_Date   => v_Start_Date,
                                      i_End_Date     => v_End_Date,
                                      i_Predict_Type => i_Predict_Type);
      else
        Calc_Average_Mean_Predict_By_Period(i_Company_Id   => i_Company_Id,
                                            i_Filial_Id    => i_Filial_Id,
                                            i_Object_Id    => i_Object_Id,
                                            i_Area_Id      => i_Area_Id,
                                            i_Driver_Id    => i_Driver_Id,
                                            i_Begin_Date   => v_Start_Date,
                                            i_End_Date     => v_End_Date,
                                            i_Predict_Type => i_Predict_Type);
      end if;
    
      v_Start_Date := v_End_Date + 1;
    end loop;
  end;

end Hsc_Core;
/
