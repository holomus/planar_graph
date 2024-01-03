prompt adding new time kind: Additional Rest Day
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  -------------------------------------------------- 
  Procedure Time_Kind
  (
    i_Company_Id   number,
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
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Time_Kind_Id := Htt_Next.Time_Kind_Id;
    end;
  
    begin
      select Time_Kind_Id
        into v_Parent_Id
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and Pcode = i_Parent_Pcode;
    exception
      when No_Data_Found then
        v_Parent_Id := null;
    end;
  
    z_Htt_Time_Kinds.Save_One(i_Company_Id     => i_Company_Id,
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
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Time_Kind(r.Company_Id,
              'Доп. выходной день',
              'ДВД',
              null,
              Htt_Pref.c_Pcode_Time_Kind_Rest,
              'F',
              'N',
              null,
              null,
              Htt_Pref.c_Pcode_Time_Kind_Additional_Rest);
  end loop;
  
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding event types
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Hik_Event_Type
  (
    i_Event_Type_Code varchar2,
    i_Event_Type_Name varchar2,
    i_Access_Granted  varchar2,
    i_Currently_Shown varchar2
  ) is
    v_Device_Type_Id number;
  begin
    select Device_Type_Id
      into v_Device_Type_Id
      from Hac_Device_Types
     where Pcode = Hac_Pref.c_Pcode_Device_Type_Hikvision;
  
    z_Hac_Event_Types.Save_One(i_Device_Type_Id  => v_Device_Type_Id,
                               i_Event_Type_Code => i_Event_Type_Code,
                               i_Event_Type_Name => i_Event_Type_Name,
                               i_Access_Granted  => i_Access_Granted,
                               i_Currently_Shown => i_Currently_Shown);
  end;

  --------------------------------------------------
  Procedure Dss_Event_Type
  (
    i_Event_Type_Code varchar2,
    i_Event_Type_Name varchar2,
    i_Access_Granted  varchar2,
    i_Currently_Shown varchar2
  ) is
    v_Device_Type_Id number;
  begin
    select Device_Type_Id
      into v_Device_Type_Id
      from Hac_Device_Types
     where Pcode = Hac_Pref.c_Pcode_Device_Type_Dahua;
  
    z_Hac_Event_Types.Save_One(i_Device_Type_Id  => v_Device_Type_Id,
                               i_Event_Type_Code => i_Event_Type_Code,
                               i_Event_Type_Name => i_Event_Type_Name,
                               i_Access_Granted  => i_Access_Granted,
                               i_Currently_Shown => i_Currently_Shown);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Record_Key  varchar2 := null,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name  => i_Table_Name,
                                                  i_Column_Set  => i_Column_Set,
                                                  i_Record_Key  => i_Record_Key,
                                                  i_Extra_Where => i_Extra_Where);
  end;
begin
  ----------------------------------------------------------------------------------------------------
  Hik_Event_Type(196883, 'Multi-Factor Authentication: Access Granted', 'Y', 'N');
  Hik_Event_Type(196884, 'Multi-Factor Authentication: Super Password Access Granted', 'Y', 'N');
  Hik_Event_Type(196885, 'Access Granted by Card and Fingerprint', 'Y', 'N');
  Hik_Event_Type(196886, 'Access Granted by Card, Fingerprint, and PIN', 'Y', 'N');
  Hik_Event_Type(196887, 'Access Granted by Fingerprint and PIN', 'Y', 'N');
  Hik_Event_Type(196888, 'Access Granted by Face and Fingerprint', 'Y', 'N');
  Hik_Event_Type(196889, 'Access Granted by Face and PIN', 'Y', 'N');
  Hik_Event_Type(196890, 'Access Granted by Face and Card', 'Y', 'Y');
  Hik_Event_Type(196891, 'Access Granted by Face, PIN, and Fingerprint', 'Y', 'N');
  Hik_Event_Type(196892, 'Access Granted by Face, Card, and Fingerprint', 'Y', 'N');
  Hik_Event_Type(196893, 'Access Granted by Face', 'Y', 'Y');
  Hik_Event_Type(196894, 'Access Granted by Employee ID and Fingerprint', 'Y', 'N');
  Hik_Event_Type(196895, 'Access Granted by Employee ID, Fingerprint, and PIN', 'Y', 'N');
  Hik_Event_Type(196896, 'Access Granted by Employee ID and Face', 'Y', 'N');
  Hik_Event_Type(196897, 'Access Granted by Employee ID and PIN', 'Y', 'N');
  Hik_Event_Type(196898, 'Access Denied by Invalid MIFARE Card', 'N', 'N');
  Hik_Event_Type(196899, 'Verifying CPU Card Encryption Failed', 'N', 'N');
  Hik_Event_Type(196900, 'Access Denied (NFC Card Reading Disabled)', 'N', 'N');
  Hik_Event_Type(196901, 'EM Card Reading Not Enabled', 'N', 'N');
  Hik_Event_Type(196902, 'M1 Card Reading Not Enabled', 'N', 'N');
  Hik_Event_Type(196903, 'CPU Card Reading Disabled', 'N', 'N');
  Hik_Event_Type(197107, 'Skin-Surface Temperature Measured', 'N', 'N');
  Hik_Event_Type(197127, 'Access Granted by Fingerprint', 'Y', 'N');
  Hik_Event_Type(197128, 'Access Denied by Fingerprint', 'N', 'N');
  Hik_Event_Type(197132, 'Access Timed Out by Card and PIN', 'N', 'N');
  Hik_Event_Type(197133, 'Max. Card and Password Authentication Times', 'N', 'N');
  Hik_Event_Type(197134, 'Access Denied by Card and Fingerprint', 'N', 'N');
  Hik_Event_Type(197135, 'Access Timed Out by Card and Fingerprint', 'N', 'N');
  Hik_Event_Type(197136, 'Access Denied by Card, Fingerprint, and PIN', 'N', 'N');
  Hik_Event_Type(197137, 'Access Timed Out by Card, Fingerprint, and PIN', 'N', 'N');
  Hik_Event_Type(197138, 'Access Denied by Fingerprint and PIN', 'N', 'N');
  Hik_Event_Type(197139, 'Access Timed Out by Fingerprint and PIN', 'N', 'N');
  Hik_Event_Type(197140, 'Fingerprint Does Not Exist', 'N', 'N');
  Hik_Event_Type(197141, 'Access Denied by Face and Fingerprint', 'N', 'N');
  Hik_Event_Type(197142, 'Access Timed Out by Face and Fingerprint', 'N', 'N');
  Hik_Event_Type(197143, 'Access Denied by Face and PIN', 'N', 'N');
  Hik_Event_Type(197144, 'Access Timed Out by Face and PIN', 'N', 'N');
  Hik_Event_Type(197145, 'Access Denied by Face and Card', 'N', 'N');
  Hik_Event_Type(197146, 'Access Timed Out by Face and Card', 'N', 'N');
  Hik_Event_Type(197147, 'Access Denied by Face, PIN, and Fingerprint', 'N', 'N');
  Hik_Event_Type(197148, 'Access Timed Out by Face, PIN, and Fingerprint', 'N', 'N');
  Hik_Event_Type(197149, 'Access Denied by Face, Card, and Fingerprint', 'N', 'N');
  Hik_Event_Type(197150, 'Access Timed Out by Face, Card, and Fingerprint', 'N', 'N');
  Hik_Event_Type(197151, 'Access Denied by Face', 'N', 'N');
  Hik_Event_Type(197152, 'Access Denied by Employee ID and Fingerprint', 'N', 'N');
  Hik_Event_Type(197153, 'Access Timed Out by Employee ID and Fingerprint', 'N', 'N');
  Hik_Event_Type(197154, 'Access Denied by Employee ID, Fingerprint, and PIN', 'N', 'N');
  Hik_Event_Type(197155, 'Access Timed Out by Employee ID, Fingerprint, and PIN', 'N', 'N');
  Hik_Event_Type(197156, 'Access Denied by Employee ID and Face', 'N', 'N');
  Hik_Event_Type(197157, 'Access Timed Out by Employee ID and Face', 'N', 'N');
  Hik_Event_Type(197158, 'Access Denied by Employee ID and PIN', 'N', 'N');
  Hik_Event_Type(197159, 'Access Timed Out by Employee ID and PIN', 'N', 'N');
  Hik_Event_Type(197160, 'Facial Recognition Failed', 'N', 'N');
  Hik_Event_Type(197161, 'Live Facial Detection Failed', 'N', 'N');
  Hik_Event_Type(197382, 'Access Denied by Card and PIN', 'N', 'N');
  Hik_Event_Type(197383, 'Anti-Passback Violation', 'N', 'N');
  Hik_Event_Type(197384, 'Invalid Time Period', 'N', 'N');
  Hik_Event_Type(197391, 'Card Not in Multi-Factor Authentication Group', 'N', 'N');
  Hik_Event_Type(197392, 'Card Not in Multi-Factor Authentication Duration', 'N', 'N');
  Hik_Event_Type(197633, 'Card No. Expired', 'N', 'N');
  Hik_Event_Type(197634, 'Card No. Does Not Exist', 'N', 'N');
  Hik_Event_Type(197635, 'No Access Level Assigned', 'N', 'N');
  Hik_Event_Type(198146, 'Multi-Door Interlocking', 'N', 'N');
  Hik_Event_Type(198914, 'Access Granted by Card ', 'Y', 'Y');
  Hik_Event_Type(198915, 'Access Granted by Card and PIN', 'Y', 'N');
  Hik_Event_Type(199429, 'Max. Card Access Failed Attempts', 'N', 'N');
  Hik_Event_Type(200477, 'Access Denied: First Person Not Authorized', 'N', 'N');
  Hik_Event_Type(200513, 'Access Denied (Door Remained Locked or Inactive)', 'N', 'N');
  Hik_Event_Type(200514, 'Access Denied: Scheduled Sleep Mode', 'N', 'N');
  Hik_Event_Type(200515, 'Employee ID Does Not Exist', 'N', 'N');
  Hik_Event_Type(200516, 'Access Granted via Combined Authentication Modes', 'Y', 'Y');
  Hik_Event_Type(200517, 'Combined Authentication Timed Out', 'N', 'N');
  Hik_Event_Type(200518, 'Authentication Mode Mismatch', 'N', 'N');
  Hik_Event_Type(200519, 'Password Mismatches', 'N', 'N');
  Hik_Event_Type(261952, 'Verifying Card Encryption Information Failed', 'N', 'N');
  Hik_Event_Type(263433, 'Password Authenticated', 'Y', 'N');
  Hik_Event_Type(721678, 'Duress Alarm', 'N', 'N');
  Hik_Event_Type(983304, 'Failed Password Attempts Alarm', 'N', 'N');
  ----------------------------------------------------------------------------------------------------

  Dss_Event_Type(42, 'Unlocking by legal password', 'Y', 'N');
  Dss_Event_Type(45, 'Unlocking by legal fingerprint', 'Y', 'N');
  Dss_Event_Type(48, 'Remote unlock (indoor monitor/platform)', 'Y', 'N');
  Dss_Event_Type(49, 'Normal unlocking by button', 'Y', 'N');
  Dss_Event_Type(51, 'Legal swiping card', 'Y', 'N');
  Dss_Event_Type(56, 'Normal door closing', 'Y', 'N');
  Dss_Event_Type(57, 'Normal door opening', 'Y', 'N');
  Dss_Event_Type(13109, 'Patrol user', 'Y', 'N');
  Dss_Event_Type(13123, 'Unlocking by card + password', 'Y', 'N');
  Dss_Event_Type(13124, 'Unlocking by card + fingerprint', 'Y', 'N');
  Dss_Event_Type(13125, 'Remote verification', 'Y', 'N');
  Dss_Event_Type(600005, 'Legal unlocking by face', 'Y', 'N');
  Dss_Event_Type(600013, 'Unlocking by card + face', 'Y', 'N');
  Dss_Event_Type(700000, 'Unlocking by fingerprint + password', 'Y', 'N');
  Dss_Event_Type(700001, 'Unlocking by fingerprint + face', 'Y', 'N');
  Dss_Event_Type(700002, 'Unlocking by face + password', 'Y', 'N');
  Dss_Event_Type(700003, 'Unlocking by card + fingerprint + password', 'Y', 'N');
  Dss_Event_Type(700004, 'Unlocking by card + fingerprint + face', 'Y', 'N');
  Dss_Event_Type(700005, 'Unlocking by fingerprint + face + password', 'Y', 'N');
  Dss_Event_Type(700006, 'Unlocking by card + face + password', 'Y', 'N');
  Dss_Event_Type(700007, 'Unlocking by card + fingerprint + face + password', 'Y', 'N');
  Dss_Event_Type(43, 'Unlocking by illegal password', 'N', 'N');
  Dss_Event_Type(46, 'Unlocking by illegal fingerprint', 'N', 'N');
  Dss_Event_Type(52, 'Illegal card swiping', 'N', 'N');
  Dss_Event_Type(54, 'Abnormal door opening', 'N', 'N');
  Dss_Event_Type(55, 'Abnormal door closing', 'N', 'N');
  Dss_Event_Type(13100, 'No permission (card/password/fingerprint/face)', 'N', 'N');
  Dss_Event_Type(13101, 'Card frozen or reported for loss', 'N', 'N');
  Dss_Event_Type(13103,
                 'Wrong unlocking mode (user has permission but use incorrect mode)',
                 'N',
                 'N');
  Dss_Event_Type(13104, 'Validity period error', 'N', 'N');
  Dss_Event_Type(13106, 'Duress alarm not enable', 'N', 'N');
  Dss_Event_Type(13107, 'Normally closed door unlock', 'N', 'N');
  Dss_Event_Type(13108, 'Multi-door interlocking (at most one door can be opened)', 'N', 'N');
  Dss_Event_Type(13111, 'Period erro', 'N', 'N');
  Dss_Event_Type(13112, 'Error of unlocking periods during holiday', 'N', 'N');
  Dss_Event_Type(13113, 'Not first card (first card everyday', 'N', 'N');
  Dss_Event_Type(13114, 'Corrent card and incorrect password', 'N', 'N');
  Dss_Event_Type(13115, 'Corrent card and password timeot', 'N', 'N');
  Dss_Event_Type(13116, 'Corrent card and incorrect fingerprint', 'N', 'N');
  Dss_Event_Type(13117, 'Corrent card and fingerprint timeot', 'N', 'N');
  Dss_Event_Type(13118, 'Corrent fingerprint and incorrect password', 'N', 'N');
  Dss_Event_Type(13119, 'Corrent fingerprint and password timeot', 'N', 'N');
  Dss_Event_Type(13120, 'Combination unlocking order error', 'N', 'N');
  Dss_Event_Type(13121, 'Combination unlocking should continue to be verified', 'N', 'N');
  Dss_Event_Type(13122, 'Verification passed but unauthorized by the console', 'N', 'N');
  Dss_Event_Type(600011, 'Correct card and face timeout', 'N', 'N');
  Dss_Event_Type(600012, 'Correct card and incorrect face', 'N', 'N');
  Dss_Event_Type(41, 'Duress alarm', 'N', 'N');
  Dss_Event_Type(72, 'Timeout alarm', 'N', 'N');
  Dss_Event_Type(1433, 'Blocklist alarm', 'N', 'N');
  Dss_Event_Type(1446, 'Alarm of excessive use of illegal card', 'N', 'N');
  Dss_Event_Type(13110, 'Anti-passback alarm', 'N', 'N');
  Dss_Event_Type(13110, 'Intrusion alarm', 'N', 'N');
  Dss_Event_Type(600003, 'Card reader tamper alarm', 'N', 'N');
  Dss_Event_Type(600004, 'Device tamper alarm', 'N', 'N');
  Dss_Event_Type(62, 'Stranger (Face)', 'N', 'N');
  ----------------------------------------------------------------------------------------------------

  Table_Record_Setting('HAC_EVENT_TYPES', 'EVENT_TYPE_NAME', 'EVENT_TYPE_NAME');
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt attaching face event type to hikvision devices
----------------------------------------------------------------------------------------------------  
declare
  v_Device_Type_Id number := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
begin
  insert into Hac_Device_Event_Types
    (Server_Id, Device_Id, Device_Type_Id, Event_Type_Code)
    select q.Server_Id, q.Device_Id, v_Device_Type_Id, 196893
      from Hac_Devices q
     where q.Device_Type_Id = v_Device_Type_Id;
  commit;     
end;
/

