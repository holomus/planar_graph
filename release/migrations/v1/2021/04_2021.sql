prompt Migr from 04.2021 fix setting in companies
set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  --------------------------------------------------
  Procedure Time_Type
  (
    a varchar2,
    b varchar2,
    c varchar2,
    d varchar2
  ) is
    v_Time_Type_Id number;
  begin
    begin
      select Time_Type_Id
        into v_Time_Type_Id
        from Htt_Time_Types
       where Company_Id = v_Company_Head
         and Pcode = d;
    exception
      when No_Data_Found then
        v_Time_Type_Id := Htt_Next.Time_Type_Id;
    end;
  
    z_Htt_Time_Types.Save_One(i_Company_Id   => v_Company_Head,
                              i_Time_Type_Id => v_Time_Type_Id,
                              i_Name         => a,
                              i_Letter_Code  => b,
                              i_Digital_Code => c,
                              i_State        => 'A',
                              i_Pcode        => d);
  end;

  --------------------------------------------------
  Procedure Device_Type
  (
    a varchar2,
    b varchar2
  ) is
    v_Device_Type_Id number;
  begin
    begin
      select Device_Type_Id
        into v_Device_Type_Id
        from Htt_Device_Types
       where Pcode = b;
    exception
      when No_Data_Found then
        v_Device_Type_Id := Htt_Next.Device_Type_Id;
    end;
  
    z_Htt_Device_Types.Save_One(i_Device_Type_Id => v_Device_Type_Id,
                                i_Name           => a,
                                i_State          => 'A',
                                i_Pcode          => b);
  end;

  --------------------------------------------------
  Procedure Request_Type
  (
    a varchar2,
    b varchar2,
    c number
  ) is
    v_Request_Type_Id number;
  begin
    begin
      select Request_Type_Id
        into v_Request_Type_Id
        from Htt_Request_Types
       where Pcode = b;
    exception
      when No_Data_Found then
        v_Request_Type_Id := Htt_Next.Request_Type_Id;
    end;
  
    z_Htt_Request_Types.Save_One(i_Company_Id      => v_Company_Head,
                                 i_Request_Type_Id => v_Request_Type_Id,
                                 i_Name            => a,
                                 i_Order_No        => c,
                                 i_State           => 'A',
                                 i_Pcode           => b);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    a varchar2,
    b varchar2,
    c varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name  => a,
                                                  i_Column_Set  => b,
                                                  i_Extra_Where => c);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Time Types ====');
  Time_Type('Явка', 'Я', null, Htt_Pref.c_Pcode_Time_Type_Turnout);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Device Types ====');
  Device_Type('Терминал', Htt_Pref.c_Pcode_Device_Type_Terminal);
  Device_Type('TimePad', Htt_Pref.c_Pcode_Device_Type_Timepad);
  Device_Type('Staff', Htt_Pref.c_Pcode_Device_Type_Staff);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Request Types ====');
  Request_Type('Запрос на отсутствие', Htt_Pref.c_Pcode_Request_Type_Leave, 1);
  Request_Type('Запрос на изменение графика', Htt_Pref.c_Pcode_Request_Type_Change, 2);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== table record translate ====');
  Table_Record_Setting('HTT_TIME_TYPES', 'NAME');
  Table_Record_Setting('HTT_DEVICE_TYPES', 'NAME');
  Table_Record_Setting('HTT_REQUEST_TYPES', 'NAME');
  commit;
end;
/

declare
  v_Company_Head number := Md_Pref.Company_Head;
begin
  -- looping in companies (not company head)
  for r in (select *
              from Md_Companies q
             where q.State = 'A'
               and q.Company_Id <> v_Company_Head)
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;

    Ui_Auth.Logon_As_System(r.Company_Id);

    -- adding href settings this company data
    begin
      Href_Watcher.On_Company_Add(r.Company_Id);
    exception
      when others then
        null;
    end;

    -- adding htt settings this company data
    begin
      Htt_Watcher.On_Company_Add(r.Company_Id);
    exception
      when others then
        null;
    end;

    -- adding hpr settings this company data
    begin
      Hpr_Watcher.On_Company_Add(r.Company_Id);
    exception
      when others then
        null;
    end;

    -- adding hpd settings this company data
    begin
      Hpd_Watcher.On_Company_Add(r.Company_Id);
    exception
      when others then
        null;
    end;
  end loop;

  commit;
end;
/
