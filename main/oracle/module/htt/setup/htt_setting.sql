set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  --------------------------------------------------
  Procedure Calendar
  (
    i_Name  varchar2,
    i_Code  varchar2,
    i_Pcode varchar2
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(v_Company_Head);
    v_Calendar_Id number;
  begin
    begin
      select Calendar_Id
        into v_Calendar_Id
        from Htt_Calendars c
       where c.Company_Id = v_Company_Head
         and c.Filial_Id = v_Filial_Head
         and c.Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Calendar_Id := Htt_Next.Calendar_Id;
    end;
  
    z_Htt_Calendars.Save_One(i_Company_Id    => v_Company_Head,
                             i_Filial_Id     => v_Filial_Head,
                             i_Calendar_Id   => v_Calendar_Id,
                             i_Monthly_Limit => 'N',
                             i_Daily_Limit   => 'N',
                             i_Name          => i_Name,
                             i_Code          => i_Code,
                             i_Pcode         => i_Pcode);
  end;
    
  -------------------------------------------------- 
  Procedure Time_Kind
  (
    i_Name         varchar2,
    i_Letter_Code  varchar2,
    i_Digital_Code varchar2 := null,
    i_Parent_Pcode varchar2 := null,
    i_Plan_Load    varchar2,
    i_Requestable  varchar2,
    i_Bg_Color     varchar2 := null,
    i_Color        varchar2 := null,
    i_Pcode        varchar2
  ) is
    v_Time_Kind_Id number;
    v_Parent_Id    number;
  begin
    begin
      select Time_Kind_Id
        into v_Time_Kind_Id
        from Htt_Time_Kinds
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Time_Kind_Id := Htt_Next.Time_Kind_Id;
    end;
    
    begin
      select Time_Kind_Id
        into v_Parent_Id
        from Htt_Time_Kinds
       where Company_Id = v_Company_Head
         and Pcode = i_Parent_Pcode;
    exception
      when No_data_found then
        v_Parent_Id := null;
    end;
  
    z_Htt_Time_Kinds.Save_One(i_Company_Id     => v_Company_Head,
                              i_Time_Kind_Id   => v_Time_Kind_Id,
                              i_Name           => i_Name,
                              i_Letter_Code    => i_Letter_Code,
                              i_Digital_Code   => i_Digital_Code,
                              i_Parent_Id      => v_Parent_Id,
                              i_Plan_Load      => i_Plan_Load,
                              i_Requestable    => i_Requestable,
                              i_Bg_Color       => i_Bg_Color,
                              i_Color          => i_Color,
                              i_Timesheet_Coef => null,
                              i_State          => 'A',
                              i_Pcode          => i_Pcode);
  end;

  -------------------------------------------------- 
  Procedure Request_Kind
  (
    i_Name                     varchar2,
    i_Time_Kind_Pcode          varchar2,
    i_Annually_Limited         varchar2,
    i_Day_Count_Type           varchar2,
    i_Annual_Day_Limit         number := null,
    i_User_Permitted           varchar2,
    i_Allow_Unused_Time        varchar2,
    i_Request_Restriction_Days number := null,
    i_Pcode                    varchar2
  ) is
    v_Request_Kind_Id number;
    v_Time_Kind_Id    number;
  begin
    begin
      select q.Request_Kind_Id
        into v_Request_Kind_Id
        from Htt_Request_Kinds q
       where q.Company_Id = v_Company_Head
         and q.Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Request_Kind_Id := Htt_Next.Request_Kind_Id;
    end;
  
    select q.Time_Kind_Id
      into v_Time_Kind_Id
      from Htt_Time_Kinds q
     where q.Company_Id = v_Company_Head
       and q.Pcode = i_Time_Kind_Pcode;
  
    z_Htt_Request_Kinds.Save_One(i_Company_Id               => v_Company_Head,
                                 i_Request_Kind_Id          => v_Request_Kind_Id,
                                 i_Name                     => i_Name,
                                 i_Time_Kind_Id             => v_Time_Kind_Id,
                                 i_Annually_Limited         => i_Annually_Limited,
                                 i_Day_Count_Type           => i_Day_Count_Type,
                                 i_Annual_Day_Limit         => i_Annual_Day_Limit,
                                 i_User_Permitted           => i_User_Permitted,
                                 i_Allow_Unused_Time        => i_Allow_Unused_Time,
                                 i_Request_Restriction_Days => i_Request_Restriction_Days,
                                 i_State                    => 'A',
                                 i_Pcode                    => i_Pcode);
  end;
  
  --------------------------------------------------
  Procedure Device_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Device_Type_Id number;
  begin
    begin
      select Device_Type_Id
        into v_Device_Type_Id
        from Htt_Device_Types
       where Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Device_Type_Id := Htt_Next.Device_Type_Id;
    end;
  
    z_Htt_Device_Types.Save_One(i_Device_Type_Id => v_Device_Type_Id,
                                i_Name           => i_Name,
                                i_State          => 'A',
                                i_Pcode          => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Terminal_Model
  (
    i_Name                     varchar2,
    i_Support_Face_Recognation varchar2,
    i_Support_Fprint           varchar2,
    i_Support_Rfid_Card        varchar2,
    i_Pcode                    varchar2
  ) is
    r_Model Htt_Terminal_Models%rowtype;
  begin
    begin
      select *
        into r_Model
        from Htt_Terminal_Models
       where Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Model.Model_Id := Htt_Next.Terminal_Model_Id;
        r_Model.State    := 'A';
        r_Model.Pcode    := i_Pcode;
    end;
    
    r_Model.Name                     := i_Name;
    r_Model.Support_Face_Recognation := i_Support_Face_Recognation;
    r_Model.Support_Fprint           := i_Support_Fprint;
    r_Model.Support_Rfid_Card        := i_Support_Rfid_Card;
  
    z_Htt_Terminal_Models.Save_Row(r_Model);
  end;

  --------------------------------------------------
  Procedure Induvidual_Schedule
  (
    i_Name    varchar2,
    i_Pcode   varchar2
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(v_Company_Head);
    v_Schedule_Id number;
    v_Barcode     varchar2(25);
  begin
    begin
      select c.Schedule_Id, c.barcode
        into v_Schedule_Id, v_Barcode
        from Htt_Schedules c
       where c.Company_Id = v_Company_Head
         and c.Filial_Id = v_Filial_Head
         and c.Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Schedule_Id := Htt_Next.Schedule_Id;
        v_Barcode     := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Schedules,
                                             i_Id    => v_Schedule_Id);
    end; 
  
    z_Htt_Schedules.Save_One(i_Company_Id                => v_Company_Head,
                             i_Filial_Id                 => v_Filial_Head,
                             i_Schedule_Id               => v_Schedule_Id,
                             i_Name                      => i_Name,
                             i_Shift                     => 0,
                             i_Input_Acceptance          => 0,
                             i_Output_Acceptance         => 0,
                             i_Track_Duration            => 0,
                             i_Count_Late                => 'N',
                             i_Count_Early               => 'N',
                             i_Count_Lack                => 'N',
                             i_Count_Free                => 'N',
                             i_Take_Holidays             => 'N',
                             i_Take_Nonworking           => 'N',
                             i_Take_Additional_Rest_Days => 'N',
                             i_Gps_Turnout_Enabled       => 'N',
                             i_Gps_Use_Location          => 'N',
                             i_Use_Weights               => 'N',
                             i_schedule_kind             =>  Htt_Pref.c_Schedule_Kind_Custom,
                             i_State                     => 'A',
                             i_Barcode                   => v_Barcode,
                             i_Allowed_Late_Time         => 0,
                             i_Allowed_Early_Time        => 0,
                             i_Begin_Late_Time           => 0,
                             i_End_Early_Time            => 0,
                             i_Pcode                     => i_Pcode);
  end;
  
  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name  => i_Table_Name,
                                                  i_Column_Set  => i_Column_Set,
                                                  i_Extra_Where => i_Extra_Where);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ---------------------------------------------------------------------------------------------------- 
  Dbms_Output.Put_Line('==== Calendars ====');
  Calendar('Производственный календарь', null, Htt_Pref.c_Pcode_Default_Calendar);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Time Kinds ====');
  Time_Kind('Явка', 'Я', null, null, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Turnout);
  Time_Kind('Опоздание', 'ОП', null, null, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Late);
  Time_Kind('Ранний Уход', 'РУ', null, null, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Early);
  Time_Kind('Отсутствие', 'ОТС', null, null, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Lack);
  Time_Kind('Свободное Время', 'СВ', null, null, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Free);
  Time_Kind('Почасовой Отгул', 'ПО', null, null, 'P', 'Y', null, null, Htt_Pref.c_Pcode_Time_Kind_Leave);
  Time_Kind('Выходной', 'В', null, null, 'F', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Rest);
  Time_Kind('Больничный', 'Б', null, null, 'P', 'Y', '#26C281', '#fff', Htt_Pref.c_Pcode_Time_Kind_Sick);
  Time_Kind('Отгул', 'О', null, null, 'F', 'Y', null, null, Htt_Pref.c_Pcode_Time_Kind_Leave_Full);
  Time_Kind('Командировка', 'К', null, null, 'P', 'Y', '#BCAAA4', '#000', Htt_Pref.c_Pcode_Time_Kind_Trip);
  Time_Kind('Отпуск', 'ОТ', null, null, 'P', 'Y', '#FF9800', '#fff', Htt_Pref.c_Pcode_Time_Kind_Vacation);
  Time_Kind('Сверхурочныe', 'СУ', null, null, 'E', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Overtime);
  Time_Kind('Рабочая Встреча', 'РВ', null, Htt_Pref.c_Pcode_Time_Kind_Turnout, 'P', 'Y', null, null, Htt_Pref.c_Pcode_Time_Kind_Meeting);
  Time_Kind('Праздник', 'П', null, Htt_Pref.c_Pcode_Time_Kind_Rest, 'F', 'N', '#50C878', '#fff', Htt_Pref.c_Pcode_Time_Kind_Holiday);
  Time_Kind('Доп. выходной день', 'ДВД', null, Htt_Pref.c_Pcode_Time_Kind_Rest, 'F', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Additional_Rest);
  Time_Kind('Нерабочий день', 'НД', null, Htt_Pref.c_Pcode_Time_Kind_Rest, 'F', 'N', '#FFD300', '#000', Htt_Pref.c_Pcode_Time_Kind_Nonworking);
  Time_Kind('Дорабочее время', 'ДВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Before_Work);
  Time_Kind('Послерабочее время', 'ПВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_After_Work);
  Time_Kind('Обеденное время', 'ОВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
  Time_Kind('Плановое свободное время', 'ПСВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Free_Inside);
  Time_Kind('Явка из корректировки', 'ЯК', null, Htt_Pref.c_Pcode_Time_Kind_Turnout, 'E', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Turnout_Adjustment);
  Time_Kind('Сверхурочныe из корректировки', 'СК', null, Htt_Pref.c_Pcode_Time_Kind_Overtime, 'E', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Overtime_Adjustment);  
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Request Kinds ====');
  Request_Kind('Больничный', Htt_Pref.c_Pcode_Time_Kind_Sick, 'N', Htt_Pref.c_Day_Count_Type_Work_Days, null, 'Y', 'N', null, Htt_Pref.c_Pcode_Request_Kind_Sick_Leave);
  Request_Kind('Отпуск', Htt_Pref.c_Pcode_Time_Kind_Vacation, 'N', Htt_Pref.c_Day_Count_Type_Production_Days, null, 'Y', 'N', null, Htt_Pref.c_Pcode_Request_Kind_Vacation);
  Request_Kind('Командировка', Htt_Pref.c_Pcode_Time_Kind_Trip, 'N', Htt_Pref.c_Day_Count_Type_Calendar_Days, null, 'Y', 'N', null, Htt_Pref.c_Pcode_Request_Kind_Trip);
  Request_Kind('Отгул', Htt_Pref.c_Pcode_Time_Kind_Leave, 'N', Htt_Pref.c_Day_Count_Type_Work_Days, null, 'Y', 'N', null, Htt_Pref.c_Pcode_Request_Kind_Leave);
  Request_Kind('Рабочая Встреча', Htt_Pref.c_Pcode_Time_Kind_Meeting, 'N', Htt_Pref.c_Day_Count_Type_Work_Days, null, 'Y', 'N', null, Htt_Pref.c_Pcode_Request_Kind_Meeting);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Device Types ====');
  Device_Type('Терминал', Htt_Pref.c_Pcode_Device_Type_Terminal);
  Device_Type('Verifix Timepad', Htt_Pref.c_Pcode_Device_Type_Timepad);
  Device_Type('Verifix Staff', Htt_Pref.c_Pcode_Device_Type_Staff);
  Device_Type('Verifix Hikvision', Htt_Pref.c_Pcode_Device_Type_Hikvision);
  Device_Type('Verifix Dahua', Htt_Pref.c_Pcode_Device_Type_Dahua);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Terminal Models ====');
  Terminal_Model('ZKTeco F18', 'N', 'Y', 'N', Htt_Pref.c_Pcode_Zkteco_F18);
  Terminal_Model('ZKTeco EFace10', 'Y', 'N', 'Y', Htt_Pref.c_Pcode_Zkteco_Eface10);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Pin Lock for Company Head ====');
  z_Htt_Pin_Locks.Insert_Try(v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Individual Schedule ====');
  Induvidual_Schedule('Индивидуальный график', Htt_pref.c_Pcode_Individual_Staff_Schedule);
  Induvidual_Schedule('Индивидуальный график для позиции', Htt_pref.c_Pcode_Individual_Robot_Schedule);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HTT_CALENDARS', 'NAME', 'FILIAL_ID = MD_PREF.FILIAL_HEAD(MD_PREF.COMPANY_HEAD)');
  Table_Record_Setting('HTT_TIME_KINDS', 'NAME,LETTER_CODE', 'PCODE IS NOT NULL');
  Table_Record_Setting('HTT_REQUEST_KINDS', 'NAME', 'PCODE IS NOT NULL');
  Table_Record_Setting('HTT_SCHEDULES', 'NAME', 'FILIAL_ID = MD_PREF.FILIAL_HEAD(MD_PREF.COMPANY_HEAD) AND PCODE IS NOT NULL');
  
  commit;
end;
/
