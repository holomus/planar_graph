set define off
set serveroutput on
declare
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
        from Hac_Device_Types
       where Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Device_Type_Id := Hac_Next.Device_Type_Id;
    end;
  
    z_Hac_Device_Types.Save_One(i_Device_Type_Id => v_Device_Type_Id,
                                i_Name           => i_Name,
                                i_Pcode          => i_Pcode);
  end;
  
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
  Dbms_Output.Put_Line('==== Device Types ====');
  Device_Type('Verifix Hikvision', Hac_Pref.c_Pcode_Device_Type_Hikvision);
  Device_Type('Verifix Dahua', Hac_Pref.c_Pcode_Device_Type_Dahua);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Hik Event Types ====');
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
  Hik_Event_Type(1, 'Valid Card Authentication Completed', 'Y', 'N');  
  Hik_Event_Type(2, 'Card and Password Authentication Completed', 'Y', 'N');  
  Hik_Event_Type(3, 'Card and Password Authentication Failed', 'N', 'N');  
  Hik_Event_Type(4, 'Card and Password Authentication Timed Out', 'N', 'N');  
  Hik_Event_Type(5, 'Card and Password Authentication Timed Out', 'N', 'N');  
  Hik_Event_Type(6, 'No Permission', 'N', 'N');  
  Hik_Event_Type(7, 'Invalid Card Swiping Time Period', 'N', 'N');  
  Hik_Event_Type(8, 'Expired Card', 'N', 'N');  
  Hik_Event_Type(9, 'Card No. Not Exist', 'N', 'N');  
  Hik_Event_Type(10, 'Anti-passing Back Authentication Failed', 'N', 'N');   
  Hik_Event_Type(11, 'Interlocking Door Not Closed', 'N', 'N');   
  Hik_Event_Type(12, 'Card Not in Multiple Authentication Group', 'N', 'N');   
  Hik_Event_Type(13, 'Card Not in Multiple Authentication Duration', 'N', 'N');   
  Hik_Event_Type(14, 'Multiple Authentications: Super Password Authentication Failed', 'N', 'N');   
  Hik_Event_Type(15, 'Multiple Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(16, 'Multiple Authenticated', 'N', 'N');   
  Hik_Event_Type(17, 'Open Door with First Card Started', 'N', 'N');   
  Hik_Event_Type(18, 'Open Door with First Card Stopped', 'N', 'N');   
  Hik_Event_Type(19, 'Remain Open Started', 'N', 'N');   
  Hik_Event_Type(20, 'Remain Open Stopped', 'N', 'N');   
  Hik_Event_Type(21, 'Door Unlocked', 'N', 'N');   
  Hik_Event_Type(22, 'Door Locked', 'N', 'N');   
  Hik_Event_Type(23, 'Exit Button Pressed', 'N', 'N');   
  Hik_Event_Type(24, 'Exit Button Released', 'N', 'N');   
  Hik_Event_Type(25, 'Door Open (Contact)', 'N', 'N');   
  Hik_Event_Type(26, 'Door Closed (Contact)', 'N', 'N');   
  Hik_Event_Type(27, 'Door Abnormally Open (Contact)', 'N', 'N');   
  Hik_Event_Type(28, 'Door Open Timed Out (Contact)', 'N', 'N');   
  Hik_Event_Type(29, 'Alarm Output Enabled', 'N', 'N');   
  Hik_Event_Type(30, 'Alarm Output Disabled', 'N', 'N');   
  Hik_Event_Type(31, 'Remain Closed Started', 'N', 'N');   
  Hik_Event_Type(32, 'Remain Closed Stopped', 'N', 'N');   
  Hik_Event_Type(33, 'Multiple Authentications: Remotely Open Door', 'N', 'N');   
  Hik_Event_Type(34, 'Multiple Authentications: Super Password Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(35, 'Multiple Authentications: Repeated Authentication', 'N', 'N');   
  Hik_Event_Type(36, 'Multiple Authentications Timed Out', 'N', 'N');   
  Hik_Event_Type(37, 'Doorbell Ring', 'N', 'N');   
  Hik_Event_Type(38, 'Fingerprint Matched', 'Y', 'N');   
  Hik_Event_Type(39, 'Fingerprint Mismatched', 'N', 'N');   
  Hik_Event_Type(40, 'Card and Fingerprint Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(41, 'Card and Fingerprint Authentication Failed', 'N', 'N');   
  Hik_Event_Type(42, 'Card and Fingerprint Authentication Timed Out', 'N', 'N');   
  Hik_Event_Type(43, 'Card and Fingerprint and Password Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(44, 'Card and Fingerprint and Password Authentication Failed', 'N', 'N');   
  Hik_Event_Type(45, 'Card and Fingerprint and Password Authentication Timed Out', 'N', 'N');   
  Hik_Event_Type(46, 'Fingerprint and Password Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(47, 'Fingerprint and Password Authentication Failed', 'N', 'N');   
  Hik_Event_Type(48, 'Fingerprint and Password Authentication Timed Out', 'N', 'N');   
  Hik_Event_Type(49, 'Fingerprint Not Exists', 'N', 'N');   
  Hik_Event_Type(50, 'Card Platform Authentication', 'N', 'N');   
  Hik_Event_Type(51, 'Call Center', 'N', 'N');   
  Hik_Event_Type(52, 'Fire Relay Closed: Door Remains Open', 'N', 'N');   
  Hik_Event_Type(53, 'Fire Relay Opened: Door Remains Closed', 'N', 'N');   
  Hik_Event_Type(69, 'Employee ID and Fingerprint Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(70, 'Employee ID and Fingerprint Authentication Failed', 'N', 'N');   
  Hik_Event_Type(71, 'Employee ID and Fingerprint Authentication Timed Out', 'N', 'N');   
  Hik_Event_Type(72, 'Employee ID and Fingerprint and Password Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(73, 'Employee ID and Fingerprint and Password Authentication Failed', 'N', 'N');   
  Hik_Event_Type(74, 'Employee ID and Fingerprint and Password Authentication Timed Out', 'N', 'N');   
  Hik_Event_Type(75, 'Face Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(76, 'Face Authentication Failed', 'N', 'N');   
  Hik_Event_Type(77, 'Employee ID and Face Authentication Completed', 'Y', 'N');   
  Hik_Event_Type(78, 'Employee ID and Face Authentication Failed', 'N', 'N');   
  Hik_Event_Type(79, 'Employee ID and Face Authentication Timed Out', 'N', 'N');   
  Hik_Event_Type(80, 'Face Recognition Failed', 'N', 'N');   
  Hik_Event_Type(81, 'First Card Authorization Started', 'N', 'N');   
  Hik_Event_Type(82, 'First Card Authorization Ended', 'N', 'N');   
  Hik_Event_Type(83, 'Lock Input Short Circuit Attempts Alarm', 'N', 'N');   
  Hik_Event_Type(84, 'Lock Input Open Circuit Attempts Alarm', 'N', 'N');   
  Hik_Event_Type(85, 'Lock Input Exception Alarm', 'N', 'N');   
  Hik_Event_Type(86, 'Contact Input Short Circuit Attempts Alarm', 'N', 'N');   
  Hik_Event_Type(87, 'Contact Input Open Circuit Attempts Alarm', 'N', 'N');   
  Hik_Event_Type(88, 'Contact Input Exception Alarm', 'N', 'N');   
  Hik_Event_Type(89, 'Exit Button Input Short Circuit Attempts Alarm', 'N', 'N');   
  Hik_Event_Type(90, 'Exit Button Input Open Circuit Attempts Alarm', 'N', 'N');   
  Hik_Event_Type(91, 'Exit Button Input Exception Alarm', 'N', 'N');   
  Hik_Event_Type(92, 'Unlocking Exception', 'N', 'N');   
  Hik_Event_Type(93, 'Unlocking Timed Out', 'N', 'N');   
  Hik_Event_Type(94, 'Unauthorized First Card Opening Failed', 'N', 'N');   
  Hik_Event_Type(95, 'Call Elevator Relay Open', 'N', 'N');   
  Hik_Event_Type(96, 'Call Elevator Relay Closed', 'N', 'N');   
  Hik_Event_Type(97, 'Auto Button Relay Open', 'N', 'N');   
  Hik_Event_Type(98, 'Auto Button Relay Closed', 'N', 'N');   
  Hik_Event_Type(99, 'Button Relay Open', 'N', 'N');   
  Hik_Event_Type(100, 'Button Relay Closed', 'N', 'N');    
  Hik_Event_Type(101, 'Employee ID and Password Authentication Completed', 'Y', 'N');    
  Hik_Event_Type(102, 'Employee ID and Password Authentication Failed', 'N', 'N');    
  Hik_Event_Type(103, 'Employee ID and Password Authentication Timed Out', 'N', 'N');    
  Hik_Event_Type(113, 'Blacklist Event', 'N', 'N');    
  Hik_Event_Type(114, 'Valid Message', 'N', 'N');    
  Hik_Event_Type(115, 'Invalid Message', 'N', 'N');    
  Hik_Event_Type(117, 'Authentication Failed: Door Remain Closed or Door in Sleeping Mode', 'N', 'N');    
  Hik_Event_Type(118, 'Authentication Failed: Authentication Schedule in Sleeping Mode', 'N', 'N');    
  Hik_Event_Type(119, 'Card Encryption Verification Failed', 'N', 'N');    
  Hik_Event_Type(120, 'Anti-passing Back Server Response Failed', 'N', 'N');    
  Hik_Event_Type(130, 'Open Door via Exit Button Failed When Door Remain Closed or in Sleeping Mode', 'N', 'N');    
  Hik_Event_Type(132, 'Door Linkage Open Failed During Door Remain Close or Sleeping', 'N', 'N');    
  Hik_Event_Type(133, 'Tailgating', 'N', 'N');    
  Hik_Event_Type(134, 'Reverse Passing', 'N', 'N');    
  Hik_Event_Type(135, 'Force Accessing', 'N', 'N');    
  Hik_Event_Type(136, 'Climb Over', 'N', 'N');    
  Hik_Event_Type(137, 'Passing Timed Out', 'N', 'N');    
  Hik_Event_Type(138, 'Intrusion Alarm', 'N', 'N');    
  Hik_Event_Type(139, 'Authentication Failed When Free Passing', 'N', 'N');    
  Hik_Event_Type(140, 'Barrier Obstructed', 'N', 'N');    
  Hik_Event_Type(141, 'Barrier Restored', 'N', 'N');    
  Hik_Event_Type(151, 'Passwords Mismatched', 'N', 'N');    
  Hik_Event_Type(152, 'Employee ID Not Exists', 'N', 'N');    
  Hik_Event_Type(153, 'Combined Authentication Completed', 'Y', 'N');    
  Hik_Event_Type(154, 'Combined Authentication Timed Out', 'N', 'N');    
  Hik_Event_Type(155, 'Authentication Type Mismatched', 'N', 'N');    
  Hik_Event_Type(162, 'Authentication Failed: Invalid Mifare Card', 'N', 'N');    
  Hik_Event_Type(163, 'Verifying CPU Card Encryption Failed', 'N', 'N');    
  Hik_Event_Type(164, 'Disabling NFC Verification Failed', 'N', 'N');    
  Hik_Event_Type(168, 'EM Card Recognition Disabled', 'N', 'N');    
  Hik_Event_Type(169, 'M1 Card Recognition Disabled', 'N', 'N');    
  Hik_Event_Type(170, 'CPU Card Recognition Disabled', 'N', 'N');    
  Hik_Event_Type(171, 'ID Card Recognition Disabled', 'N', 'N');    
  Hik_Event_Type(172, 'Importing Key to Card Failed', 'N', 'N');    
  Hik_Event_Type(173, 'Local Upgrade Failed', 'N', 'N');    
  Hik_Event_Type(174, 'Remote Upgrade Failed', 'N', 'N');    
  Hik_Event_Type(175, 'Extension Module is Remotely Upgraded', 'N', 'N');    
  Hik_Event_Type(176, 'Upgrading Extension Module Remotely Failed', 'N', 'N');    
  Hik_Event_Type(177, 'Fingerprint Module is Remotely Upgraded', 'N', 'N');    
  Hik_Event_Type(178, 'Upgrading Fingerprint Module Remotely Failed', 'N', 'N');    
  Hik_Event_Type(179, 'Dynamic Verification Code Authenticated', 'Y', 'N');    
  Hik_Event_Type(180, 'Authentication with Verification Code Failed', 'N', 'N');    
  Hik_Event_Type(181, 'Password Authenticated', 'Y', 'N');     
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== DSS Event Types ====');
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
  Dss_Event_Type(13103, 'Wrong unlocking mode (user has permission but use incorrect mode)', 'N', 'N');
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
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HAC_EVENT_TYPES', 'EVENT_TYPE_NAME', 'EVENT_TYPE_NAME');
  commit;
end;
/
