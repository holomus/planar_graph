prompt adding overtime bind to books
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Book_Type_Bind
  (
    i_Company_Id       number,
    i_Book_Type_Pcode  varchar2,
    i_Oper_Group_Pcode varchar2
  ) is
    v_Book_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    select Book_Type_Id
      into v_Book_Type_Id
      from Hpr_Book_Types
     where Company_Id = i_Company_Id
       and Pcode = i_Book_Type_Pcode;

    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = i_Company_Id
       and Pcode = i_Oper_Group_Pcode;

    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => i_Company_Id,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
  end;

begin
  for r in (select *
              from Md_Companies q)
  loop
    Book_Type_Bind(i_Company_Id       => r.Company_Id,
                   i_Book_Type_Pcode  => Hpr_Pref.c_Pcode_Book_Type_Wage,
                   i_Oper_Group_Pcode => Hpr_Pref.c_Pcode_Operation_Group_Overtime);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt add Robot Audit
----------------------------------------------------------------------------------------------------  
declare
  v_Project_Code varchar2(10) := Href_Pref.c_Pc_Verifix_Hr;
begin
  for Com in (select *
                from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Com.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(Com.Company_Id),
                         i_User_Id      => Md_Pref.User_System(Com.Company_Id),
                         i_Project_Code => v_Project_Code);
  
    Hrm_Audit.Robot_Audit_Start(i_Company_Id => Com.Company_Id);
  end loop;

  commit;
end;
/ 

----------------------------------------------------------------------------------------------------
prompt adding hik listening event types
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
begin
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
  Hik_Event_Type(117,
                 'Authentication Failed: Door Remain Closed or Door in Sleeping Mode',
                 'N',
                 'N');
  Hik_Event_Type(118, 'Authentication Failed: Authentication Schedule in Sleeping Mode', 'N', 'N');
  Hik_Event_Type(119, 'Card Encryption Verification Failed', 'N', 'N');
  Hik_Event_Type(120, 'Anti-passing Back Server Response Failed', 'N', 'N');
  Hik_Event_Type(130,
                 'Open Door via Exit Button Failed When Door Remain Closed or in Sleeping Mode',
                 'N',
                 'N');
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

  commit;
end;
/
