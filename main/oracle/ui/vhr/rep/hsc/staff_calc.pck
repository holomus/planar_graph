create or replace package Ui_Vhr555 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr555;
/
create or replace package body Ui_Vhr555 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr555:settings';

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
    return b.Translate('UI-VHR555:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    v_Param Hashmap := Fazo.Zip_Map('company_id', --
                                    Ui.Company_Id,
                                    'filial_id',
                                    Ui.Filial_Id,
                                    'state',
                                    'A');
    q       Fazo_Query;
  begin
    v_Param.Put('allowed_divisions', Uit_Href.Get_All_Subordinate_Divisions);
    v_Param.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
  
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
                    v_Param);
  
    q.Number_Field('object_id');
    q.Varchar2_Field('name', 'state');
  
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
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap) is
    v_Preferences Hashmap := p;
  begin
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => v_Preferences.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('round_model_types', Fazo.Zip_Matrix(Mkr_Util.Round_Model_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data', Fazo.Zip_Map('month', to_char(sysdate, Href_Pref.c_Date_Format_Month)));
    Result.Put('settings', Load_Preferences);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Driver_Fact
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date       date,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number
  ) return Hsc_Driver_Facts%rowtype is
    result Hsc_Driver_Facts%rowtype;
  begin
    select Df.*
      into result
      from Hsc_Driver_Facts Df
     where Df.Company_Id = i_Company_Id
       and Df.Filial_Id = i_Filial_Id
       and Df.Object_Id = i_Object_Id
       and Df.Fact_Date = i_Date
       and Df.Area_Id = i_Area_Id
       and Df.Driver_Id = i_Driver_Id
       and Df.Priority = 1;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Norm_Actions
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Norm_Id       number,
    i_Date          date,
    i_Action_Period varchar2
  ) return Hsc_Object_Norm_Actions%rowtype is
    v_Truncate_Kind varchar2(10) := case i_Action_Period
                                      when Hsc_Pref.c_Action_Period_Week then
                                       'iw'
                                      else
                                       'mon'
                                    end;
  
    v_Day_No number := i_Date - Trunc(i_Date, v_Truncate_Kind) + 1;
  
    result Hsc_Object_Norm_Actions%rowtype;
  begin
    select Ac.*
      into result
      from Hsc_Object_Norm_Actions Ac
     where Ac.Company_Id = i_Company_Id
       and Ac.Filial_Id = i_Filial_Id
       and Ac.Norm_Id = i_Norm_Id
       and Ac.Day_No = v_Day_No;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Details
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date       date,
    i_Object_Id  number,
    i_Job_Id     number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Only_Minute   boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('only_minute'), 'N') = 'Y';
    v_Use_Round_Model    boolean := Nvl(v_Settings.o_Varchar2('use_round_model'), 'N') = 'Y';
  
    a        b_Table := b_Report.New_Table();
    v_Column number := 1;
  
    v_Daily_Hours       number;
    v_Predicted_Seconds number := 0;
  
    r_Norm  Hsc_Job_Norms%rowtype;
    r_Round Hsc_Job_Rounds%rowtype;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      i_Seconds number,
      i_Rowspan number := 1,
      i_Param   Hashmap := null
    ) is
      v_Param varchar2(4000) := case
                                  when i_Param is not null then
                                   i_Param.Json
                                  else
                                   null
                                end;
    begin
      if v_Show_Only_Minute then
        a.Data(Nullif(Round(i_Seconds / 60, 2), 0), i_Rowspan => i_Rowspan, i_Param => v_Param);
      elsif v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds,
                                             v_Show_Minutes,
                                             v_Show_Minutes_Words,
                                             i_Show_Seconds => true),
               i_Rowspan => i_Rowspan,
               i_Param => v_Param);
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0), i_Rowspan => i_Rowspan, i_Param => v_Param);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Put_Fte_Amount
    (
      i_Amount           number,
      i_Round_Model_Type varchar2,
      i_Rowspan          number := 1,
      i_Param            Hashmap := null
    ) is
      v_Round_Model Round_Model := Round_Model('-0.0' || Nvl(i_Round_Model_Type, 'F'));
      v_Param varchar2(4000) := case
                                  when i_Param is not null then
                                   i_Param.Json
                                  else
                                   null
                                end;
    begin
      if v_Use_Round_Model then
        a.Data(v_Round_Model.Eval(i_Amount), i_Rowspan => i_Rowspan, i_Param => v_Param);
      else
        a.Data(Round(i_Amount, 2), i_Rowspan => i_Rowspan, i_Param => v_Param);
      end if;
    end;
  
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
    Procedure Print_Info is
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
      a.Data(t('object: $1',
               z_Mhr_Divisions.Load(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Division_Id => i_Object_Id).Name),
             i_Colspan => 5);
    
      a.New_Row;
      a.Data(t('job: $1',
               z_Mhr_Jobs.Load(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Job_Id => i_Job_Id).Name),
             i_Colspan => 5);
    
      a.New_Row;
      a.Data(t('date: $1', i_Date), i_Colspan => 5);
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      Print_Header(t('process'), 1, 2, 200);
      Print_Header(t('action'), 1, 2, 200);
      Print_Header(t('area'), 1, 2, 200);
      Print_Header(t('driver'), 1, 2, 200);
    
      Print_Header(t('predicted amount/frequency'), 1, 2, 150);
    
      Print_Header(t('norm time value'), 1, 2, 75);
      Print_Header(t('predicted time'), 1, 2, 75);
      Print_Header(t('predicted margin time'), 1, 2, 75);
      Print_Header(t('fte amount'), 1, 2, 75);
    end;
  
    --------------------------------------------------
    Procedure Print_Body is
      r_Action     Hsc_Object_Norm_Actions%rowtype;
      r_Prediction Hsc_Driver_Facts%rowtype;
    
      v_Prev_Area_Id   number;
      v_Predicted_Time number;
      v_Margin_Time    number;
      v_Fte_Amount     number;
    
      v_Area_Name    varchar2(200 char);
      v_Area_Predict number := 0;
    
      --------------------------------------------------
      Procedure Print_Intermediate_Results is
        v_Area_Margin number;
      begin
        a.Current_Style('body_darker');
        a.New_Row;
      
        a.Data(v_Area_Name, i_Style_Name => 'body_darker right bold', i_Colspan => 6);
      
        v_Area_Margin := v_Area_Predict * (1 + (r_Norm.Idle_Margin + r_Norm.Absense_Margin) / 100);
      
        Put_Time(v_Area_Predict);
        Put_Time(v_Area_Margin);
        a.Data(Round(v_Area_Margin / 3600 / v_Daily_Hours, 2));
      
        v_Area_Predict := 0;
      
        a.Current_Style('body_centralized');
      end;
    begin
      a.Current_Style('body_centralized');
    
      for r in (select (select Pr.Name
                          from Hsc_Processes Pr
                         where Pr.Company_Id = i_Company_Id
                           and Pr.Filial_Id = i_Filial_Id
                           and Pr.Process_Id = Nm.Process_Id) Process_Name,
                       (select Pa.Name
                          from Hsc_Process_Actions Pa
                         where Pa.Company_Id = i_Company_Id
                           and Pa.Filial_Id = i_Filial_Id
                           and Pa.Action_Id = Nm.Action_Id) Action_Name,
                       (select Dr.Name
                          from Hsc_Drivers Dr
                         where Dr.Company_Id = i_Company_Id
                           and Dr.Filial_Id = i_Filial_Id
                           and Dr.Driver_Id = Nm.Driver_Id) Driver_Name,
                       (select Ar.Name
                          from Hsc_Areas Ar
                         where Ar.Company_Id = i_Company_Id
                           and Ar.Filial_Id = i_Filial_Id
                           and Ar.Area_Id = Nm.Area_Id) Area_Name,
                       Nm.Time_Value,
                       Nm.Area_Id,
                       Nm.Driver_Id,
                       Nm.Norm_Id,
                       Nm.Action_Period
                  from Hsc_Object_Norms Nm
                 where Nm.Company_Id = i_Company_Id
                   and Nm.Filial_Id = i_Filial_Id
                   and Nm.Object_Id = i_Object_Id
                   and Nm.Job_Id = i_Job_Id
                 order by Nm.Area_Id)
      loop
        r_Action     := Take_Norm_Actions(i_Company_Id    => i_Company_Id,
                                          i_Filial_Id     => i_Filial_Id,
                                          i_Norm_Id       => r.Norm_Id,
                                          i_Date          => i_Date,
                                          i_Action_Period => r.Action_Period);
        r_Prediction := Take_Driver_Fact(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Date       => i_Date,
                                         i_Object_Id  => i_Object_Id,
                                         i_Area_Id    => r.Area_Id,
                                         i_Driver_Id  => r.Driver_Id);
      
        if v_Prev_Area_Id <> r.Area_Id then
          Print_Intermediate_Results;
        end if;
      
        r_Prediction.Fact_Value := Round(r_Prediction.Fact_Value, 2);
        v_Predicted_Time        := r.Time_Value * Nvl(r_Action.Frequency, r_Prediction.Fact_Value);
        v_Margin_Time           := v_Predicted_Time *
                                   (1 + (r_Norm.Idle_Margin + r_Norm.Absense_Margin) / 100);
        v_Fte_Amount            := v_Margin_Time / 3600 / v_Daily_Hours;
      
        v_Predicted_Seconds := v_Predicted_Seconds + Nvl(v_Predicted_Time, 0);
        v_Area_Predict      := v_Area_Predict + Nvl(v_Predicted_Time, 0);
      
        a.New_Row;
      
        a.Data(r.Process_Name);
        a.Data(r.Action_Name);
        a.Data(r.Area_Name);
        a.Data(r.Driver_Name);
      
        a.Data(Nvl(r_Action.Frequency, r_Prediction.Fact_Value));
      
        Put_Time(r.Time_Value);
        Put_Time(v_Predicted_Time);
        Put_Time(v_Margin_Time);
      
        Put_Fte_Amount(v_Fte_Amount, r_Round.Round_Model_Type);
      
        v_Prev_Area_Id := r.Area_Id;
        v_Area_Name    := r.Area_Name;
      end loop;
    
      if v_Prev_Area_Id is not null then
        Print_Intermediate_Results;
      end if;
    end;
  
    --------------------------------------------------
    Procedure Print_Footer is
      v_Margin_Seconds number;
    begin
      a.Current_Style('footer');
    
      a.New_Row;
      a.Data(t('total:'), i_Style_Name => 'footer right', i_Colspan => 6);
    
      v_Margin_Seconds := v_Predicted_Seconds *
                          (1 + (r_Norm.Idle_Margin + r_Norm.Absense_Margin) / 100);
    
      Put_Time(v_Predicted_Seconds);
      Put_Time(v_Margin_Seconds);
      Put_Fte_Amount(v_Margin_Seconds / 3600 / v_Daily_Hours, r_Round.Round_Model_Type);
    end;
  begin
    r_Norm := Hsc_Util.Take_Job_Norm(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Object_Id   => i_Object_Id,
                                     i_Division_Id => null,
                                     i_Job_Id      => i_Job_Id,
                                     i_Date        => i_Date);
  
    r_Round := Hsc_Util.Take_Job_Round(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Object_Id   => i_Object_Id,
                                       i_Division_Id => null,
                                       i_Job_Id      => i_Job_Id);
  
    v_Daily_Hours := r_Norm.Monthly_Hours / r_Norm.Monthly_Days;
  
    Print_Info;
  
    Print_Header;
  
    Print_Body;
  
    Print_Footer;
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Month
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Month      date,
    i_Object_Ids Array_Number,
    i_Area_Ids   Array_Number,
    i_Job_Ids    Array_Number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Only_Minute   boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('only_minute'), 'N') = 'Y';
    v_Use_Round_Model    boolean := Nvl(v_Settings.o_Varchar2('use_round_model'), 'N') = 'Y';
  
    v_Use_Total_Round_Model boolean := Nvl(v_Settings.o_Varchar2('use_total_round_model'), 'N') = 'Y';
    v_Total_Round_Model     varchar2(1) := Nvl(v_Settings.o_Varchar2('total_round_model'), 'R');
  
    a                b_Table := b_Report.New_Table();
    v_Split_Vertical number := 5;
    v_Column         number := 1;
  
    v_Begin_Date date := Trunc(i_Month, 'mon');
    v_End_Date   date := Last_Day(v_Begin_Date);
  
    v_Time_Total     number := 0;
    v_Fte_Total      number := 0;
    v_First_Colspan  number := 0;
    v_Second_Colspan number := 0;
  
    v_Dt_Key      varchar2(10) := 'yyyymmdd';
    v_Totals_Calc Calc := Calc();
  
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      i_Seconds number,
      i_Rowspan number := 1,
      i_Param   Hashmap := null
    ) is
      v_Param varchar2(4000) := case
                                  when i_Param is not null then
                                   i_Param.Json
                                  else
                                   null
                                end;
    begin
      if v_Show_Only_Minute then
        a.Data(Nullif(Round(i_Seconds / 60, 2), 0), i_Rowspan => i_Rowspan, i_Param => v_Param);
      elsif v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words),
               i_Rowspan => i_Rowspan,
               i_Param => v_Param);
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0), i_Rowspan => i_Rowspan, i_Param => v_Param);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Put_Fte_Amount
    (
      i_Amount           number,
      i_Round_Model_Type varchar2,
      i_Use_Round_Model  boolean := v_Use_Round_Model,
      i_Rowspan          number := 1,
      i_Param            Hashmap := null
    ) is
      v_Round_Model Round_Model := Round_Model('-0.0' || Nvl(i_Round_Model_Type, 'F'));
      v_Param varchar2(4000) := case
                                  when i_Param is not null then
                                   i_Param.Json
                                  else
                                   null
                                end;
    begin
      if i_Use_Round_Model then
        a.Data(v_Round_Model.Eval(i_Amount), i_Rowspan => i_Rowspan, i_Param => v_Param);
      else
        a.Data(Round(i_Amount, 2), i_Rowspan => i_Rowspan, i_Param => v_Param);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name              varchar2,
      i_Colspan           number,
      i_Rowspan           number,
      i_Column_Width      number,
      i_To_First_Colspan  boolean := false,
      i_To_Second_Colspan boolean := false
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    
      if i_To_First_Colspan then
        v_First_Colspan := v_First_Colspan + i_Colspan;
      end if;
    
      if i_To_Second_Colspan then
        v_Second_Colspan := v_Second_Colspan + i_Colspan;
      end if;
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
      v_Object_Names Array_Varchar2;
      v_Area_Names   Array_Varchar2;
      v_Job_Names    Array_Varchar2;
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
    
      if i_Object_Ids.Count > 0 then
        a.New_Row;
      
        select (select q.Name
                  from Mhr_Divisions q
                 where q.Company_Id = d.Company_Id
                   and q.Filial_Id = d.Filial_Id
                   and q.Division_Id = d.Object_Id)
          bulk collect
          into v_Object_Names
          from Hsc_Objects d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Object_Id member of i_Object_Ids;
      
        a.Data(t('objects: $1', Fazo.Gather(v_Object_Names, ', ')), i_Colspan => 5);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      if i_Area_Ids.Count > 0 then
        a.New_Row;
      
        select q.Name
          bulk collect
          into v_Area_Names
          from Hsc_Areas q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Area_Id member of i_Area_Ids;
      
        a.Data(t('areas: $1', Fazo.Gather(v_Area_Names, ', ')), i_Colspan => 5);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      if i_Job_Ids.Count > 0 then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Job_Names
          from Mhr_Jobs d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Job_Id member of i_Job_Ids;
      
        a.Data(t('jobs: $1', Fazo.Gather(v_Job_Names, ', ')), i_Colspan => 5);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      a.New_Row;
      a.Data(t('month: $1', to_char(i_Month, 'Month yyyy', v_Nls_Language)), i_Colspan => 5);
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
      v_Date_Colspan number := 1;
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      Print_Header(t('#'), 1, 2, 50, true);
      Print_Header(t('object'), 1, 2, 200, true);
      Print_Header(t('job'), 1, 2, 100, true);
    
      for i in 0 .. v_End_Date - v_Begin_Date
      loop
        Print_Header(to_char(v_Begin_Date + i, 'DD'), v_Date_Colspan, 1, 75);
      end loop;
    
      Print_Header(t('predicted time'), 1, 2, 75, false, true);
    
      Print_Header(t('idle margin'), 1, 2, 75, false, true);
      Print_Header(t('absense margin'), 1, 2, 75, false, true);
    
      Print_Header(t('predicted margin time'), 1, 2, 75);
    
      Print_Header(t('plan time'), 1, 2, 75);
    
      Print_Header(t('fte amount'), 1, 2, 75);
    
      a.New_Row;
      for i in 0 .. v_End_Date - v_Begin_Date
      loop
        Print_Header(to_char(v_Begin_Date + i, 'Dy', v_Nls_Language), v_Date_Colspan, 1, null);
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Body is
      v_Objects_Count number := i_Object_Ids.Count;
      v_Areas_Count   number := i_Area_Ids.Count;
      v_Jobs_Count    number := i_Job_Ids.Count;
    
      v_Margin_Seconds    number;
      v_Fte_Amount        number;
      v_Fte_Amounts       Array_Number;
      v_Predicted_Seconds number;
    
      v_User_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
      v_Allowed_Division_Ids     Array_Number := Uit_Href.Get_All_Subordinate_Divisions;
    
      v_Param Hashmap;
    begin
      a.Current_Style('body_centralized');
    
      for r in (select Rownum Rn,
                       (select Dv.Name
                          from Mhr_Divisions Dv
                         where Dv.Company_Id = i_Company_Id
                           and Dv.Filial_Id = i_Filial_Id
                           and Dv.Division_Id = q.Object_Id) Object_Name,
                       (select Dv.Name
                          from Mhr_Divisions Dv
                         where Dv.Company_Id = i_Company_Id
                           and Dv.Filial_Id = i_Filial_Id
                           and Dv.Division_Id = q.Division_Id) Division_Name,
                       (select Jb.Name
                          from Mhr_Jobs Jb
                         where Jb.Company_Id = i_Company_Id
                           and Jb.Filial_Id = i_Filial_Id
                           and Jb.Job_Id = q.Job_Id) Job_Name,
                       q.Object_Id,
                       q.Division_Id,
                       q.Job_Id,
                       q.Monthly_Hours,
                       q.Monthly_Days,
                       (q.Monthly_Hours / q.Monthly_Days) Daily_Hours,
                       q.Idle_Margin,
                       q.Absense_Margin,
                       (select s.Round_Model_Type
                          from Hsc_Job_Rounds s
                         where s.Company_Id = q.Company_Id
                           and s.Filial_Id = q.Filial_Id
                           and s.Object_Id = q.Object_Id
                           and Decode(s.Division_Id, q.Division_Id, 1, 0) = 1
                           and s.Job_Id = q.Job_Id) Round_Model_Type
                  from Hsc_Job_Norms q
                  join (select Ss.Company_Id, Ss.Filial_Id, Ss.Object_Id, Ss.Job_Id
                         from Hsc_Object_Norms Ss
                        where Ss.Company_Id = i_Company_Id
                          and Ss.Filial_Id = i_Filial_Id
                          and (v_Areas_Count = 0 or Ss.Area_Id member of i_Area_Ids)
                        group by Ss.Company_Id, Ss.Filial_Id, Ss.Object_Id, Ss.Job_Id) w
                    on w.Company_Id = q.Company_Id
                   and w.Filial_Id = q.Filial_Id
                   and w.Object_Id = q.Object_Id
                   and w.Job_Id = q.Job_Id
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Month = (select max(Jn.Month)
                                    from Hsc_Job_Norms Jn
                                   where Jn.Company_Id = i_Company_Id
                                     and Jn.Filial_Id = i_Filial_Id
                                     and Jn.Month <= i_Month
                                     and Jn.Object_Id = q.Object_Id
                                     and Decode(Jn.Division_Id, q.Division_Id, 1, 0) = 1
                                     and Jn.Job_Id = q.Job_Id)
                   and (v_User_Access_All_Employee = 'Y' or q.Object_Id member of
                        v_Allowed_Division_Ids)
                   and (v_Objects_Count = 0 or q.Object_Id member of i_Object_Ids)
                   and (v_Jobs_Count = 0 or q.Job_Id member of i_Job_Ids))
      loop
        v_Predicted_Seconds := 0;
        v_Fte_Amounts       := Array_Number();
      
        v_Param := Fazo.Zip_Map('object_id', --
                                r.Object_Id,
                                'job_id',
                                r.Job_Id);
      
        a.New_Row;
      
        a.Data(r.Rn, i_Rowspan => 2);
        a.Data(r.Object_Name, i_Rowspan => 2);
        a.Data(r.Job_Name, i_Rowspan => 2);
      
        for Dt in (with Dates as
                      ((select v_Begin_Date + (level - 1) Date_Value
                         from Dual
                       connect by level <= (v_End_Date - v_Begin_Date + 1)))
                     select Dt.Date_Value,
                            Nvl(sum(Nm.Time_Value * Df.Fact_Value), 0) +
                            Nvl(sum(Nm.Time_Value * Ac.Frequency), 0) Predicted_Seconds
                       from Hsc_Object_Norms Nm
                      cross join Dates Dt
                       left join Hsc_Driver_Facts Df
                         on Df.Company_Id = i_Company_Id
                        and Df.Filial_Id = i_Filial_Id
                        and Df.Object_Id = r.Object_Id
                        and Df.Fact_Date = Dt.Date_Value
                        and Df.Area_Id = Nm.Area_Id
                        and Df.Driver_Id = Nm.Driver_Id
                        and Df.Priority = 1
                       left join Hsc_Object_Norm_Actions Ac
                         on Ac.Company_Id = i_Company_Id
                        and Ac.Filial_Id = i_Filial_Id
                        and Ac.Norm_Id = Nm.Norm_Id
                        and Ac.Day_No =
                            (Dt.Date_Value - Trunc(Dt.Date_Value,
                                                   Decode(Nm.Action_Period,
                                                          Hsc_Pref.c_Action_Period_Week,
                                                          'iw',
                                                          'mon')) + 1)
                      where Nm.Company_Id = i_Company_Id
                        and Nm.Filial_Id = i_Filial_Id
                        and Nm.Object_Id = r.Object_Id
                        and Decode(Nm.Division_Id, r.Division_Id, 1, 0) = 1
                        and Nm.Job_Id = r.Job_Id
                      group by Dt.Date_Value
                      order by Dt.Date_Value)
        loop
          v_Margin_Seconds := Dt.Predicted_Seconds * (1 + (r.Idle_Margin + r.Absense_Margin) / 100);
        
          v_Param.Put('fact_date', Dt.Date_Value);
          Put_Time(v_Margin_Seconds, i_Param => v_Param);
        
          v_Fte_Amount := v_Margin_Seconds / 3600 / r.Daily_Hours;
        
          Fazo.Push(v_Fte_Amounts, v_Fte_Amount);
        
          v_Predicted_Seconds := v_Predicted_Seconds + Dt.Predicted_Seconds;
        
          v_Totals_Calc.Plus(to_char(Dt.Date_Value, v_Dt_Key), 'margin_seconds', v_Margin_Seconds);
          v_Totals_Calc.Plus(to_char(Dt.Date_Value, v_Dt_Key), 'fte_amounts', v_Fte_Amount);
        end loop;
      
        Put_Time(v_Predicted_Seconds, i_Rowspan => 2);
      
        a.Data(r.Idle_Margin || '%', i_Rowspan => 2);
        a.Data(r.Absense_Margin || '%', i_Rowspan => 2);
      
        v_Margin_Seconds := v_Predicted_Seconds * (1 + (r.Idle_Margin + r.Absense_Margin) / 100);
      
        Put_Time(v_Margin_Seconds, i_Rowspan => 2);
      
        a.Data(r.Monthly_Hours, i_Rowspan => 2);
      
        v_Fte_Amount := v_Margin_Seconds / 3600 / r.Monthly_Hours;
      
        Put_Fte_Amount(v_Fte_Amount, r.Round_Model_Type, i_Rowspan => 2);
      
        v_Time_Total := v_Time_Total + v_Margin_Seconds;
        v_Fte_Total  := v_Fte_Total + v_Fte_Amount;
      
        a.New_Row;
        for i in 1 .. v_Fte_Amounts.Count
        loop
          v_Param.Put('fact_date', v_Begin_Date + i - 1);
        
          Put_Fte_Amount(v_Fte_Amounts(i), r.Round_Model_Type, i_Param => v_Param);
        end loop;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Footer is
      v_Margin_Seconds number;
      v_Fte_Amount     number;
      v_Start_Date     date := v_Begin_Date;
    begin
      a.Current_Style('footer');
    
      a.New_Row;
      a.Data(t('total:'),
             i_Style_Name => 'footer right',
             i_Rowspan => 2,
             i_Colspan => v_First_Colspan);
    
      while v_Start_Date <= v_End_Date
      loop
        v_Margin_Seconds := v_Totals_Calc.Get_Value(to_char(v_Start_Date, v_Dt_Key),
                                                    'margin_seconds');
      
        Put_Time(v_Margin_Seconds);
      
        v_Start_Date := v_Start_Date + 1;
      end loop;
    
      a.Data('', i_Rowspan => 2, i_Colspan => v_Second_Colspan);
    
      Put_Time(v_Time_Total, i_Rowspan => 2);
    
      a.Data('', i_Rowspan => 2);
    
      Put_Fte_Amount(v_Fte_Total, v_Total_Round_Model, v_Use_Total_Round_Model, i_Rowspan => 2);
    
      a.New_Row;
      v_Start_Date := v_Begin_Date;
    
      while v_Start_Date <= v_End_Date
      loop
        v_Fte_Amount := v_Totals_Calc.Get_Value(to_char(v_Start_Date, v_Dt_Key), 'fte_amounts');
      
        Put_Fte_Amount(v_Fte_Amount, v_Total_Round_Model, v_Use_Total_Round_Model);
      
        v_Start_Date := v_Start_Date + 1;
      end loop;
    end;
  
  begin
    Print_Info;
  
    Print_Header;
  
    Print_Body;
  
    Print_Footer;
  
    b_Report.Add_Sheet(i_Name           => Ui.Current_Form_Name,
                       p_Table          => a,
                       i_Split_Vertical => v_Split_Vertical);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Param Hashmap;
  begin
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
    
      v_Param.Put_All(Fazo.Parse_Map(p.r_Varchar2('table_param')));
      b_Report.Redirect_To_Report('/vhr/rep/hsc/staff_calc:run', v_Param);
    else
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => Ui.Current_Form_Name);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_darker',
                         i_Parent_Style_Name => 'body',
                         i_Background_Color  => '#DCDCDC',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
    
      if p.Has('month') then
        Run_Month(i_Company_Id => v_Company_Id,
                  i_Filial_Id  => v_Filial_Id,
                  i_Month      => p.r_Date('month', Href_Pref.c_Date_Format_Month),
                  i_Object_Ids => Nvl(p.o_Array_Number('object_ids'), Array_Number()),
                  i_Area_Ids   => Nvl(p.o_Array_Number('area_ids'), Array_Number()),
                  i_Job_Ids    => Nvl(p.o_Array_Number('job_ids'), Array_Number()));
      else
        Run_Details(i_Company_Id => v_Company_Id,
                    i_Filial_Id  => v_Filial_Id,
                    i_Date       => p.r_Date('fact_date'),
                    i_Object_Id  => p.r_Number('object_id'),
                    i_Job_Id     => p.r_Number('job_id'));
      end if;
    
      b_Report.Close_Book();
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           Parent_Id   = null,
           State       = null;
    update Hsc_Objects
       set Company_Id = null,
           Filial_Id  = null,
           Object_Id  = null;
  
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null,
           State      = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr555;
/
