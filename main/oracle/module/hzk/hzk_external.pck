create or replace package Hzk_External is
  ----------------------------------------------------------------------------------------------------
  Procedure Send_Command
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Command    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Send_Check
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Fingerprints
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Sync_Fingerprints
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Persons
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Device
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Info       varchar2,
    i_Stamp      number,
    i_Opstamp    number
  );
  ----------------------------------------------------------------------------------------------------
  Function Options
  (
    i_Company_Id number,
    i_Device_Id  number
  ) return Array_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Cmd_Update_Person
  (
    i_Company_Id  number,
    i_Device_Id   number,
    i_Person_Id   number,
    i_Name        varchar2,
    i_Pin         varchar2,
    i_Password    varchar2,
    i_Person_Role varchar2,
    i_Rfid_Code   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cmd_Delete_Person
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number := null,
    i_Pin        varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Update_Biophoto
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Pin        varchar2,
    i_Sha        varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Update_Userpic
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Pin        varchar2,
    i_Sha        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cmd_Update_Fingerprint
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number,
    i_Finger_No  number,
    i_Tmp        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cmd_Delete_Fingerprint
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number,
    i_Pin        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Load_User_Info
  (
    i_Columns     Array_Varchar2,
    i_Company_Id  number,
    o_Person_Id   out number,
    o_Pin         out varchar2,
    o_Person_Name out varchar2,
    o_Person_Role out varchar2,
    o_Password    out varchar2,
    o_Rfid_Code   out varchar2,
    o_Finger_Id   out number,
    o_Tmp         out varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Device_Person
  (
    i_Company_Id     number,
    i_Migr_Person_Id number,
    i_Device_Id      number,
    i_Person_Id      number,
    i_Pin            varchar2,
    i_Person_Name    varchar2,
    i_Person_Role    varchar2,
    i_Password       varchar2,
    i_Rfid_Code      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Device_Finger
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number,
    i_Pin        varchar2,
    i_Finger_No  number,
    i_Tmp        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Operlog
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Lines      Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Attlog
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Lines      Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Load_Commands
  (
    i_Company_Id number,
    i_Device_Id  number
  ) return Array_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Commands
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Lines      Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Process
  (
    i_Path   varchar2,
    i_Query  varchar2,
    i_Input  Array_Varchar2,
    o_Output out Array_Varchar2
  );
end Hzk_External;
/
create or replace package body Hzk_External is
  ----------------------------------------------------------------------------------------------------  
  c_Ok constant Array_Varchar2 := Array_Varchar2('OK' || Chr(13) || Chr(10));

  ----------------------------------------------------------------------------------------------------
  Function Two_Step_Reverse(i_Str varchar2) return varchar2 is
    result varchar2(10);
  begin
    for i in reverse 1 .. 5
    loop
      for j in reverse 0 .. 1
      loop
        result := result || Substr(i_Str, 2 * i - j, 1);
      end loop;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Rfid_Encode(i_Rfid varchar2) return varchar2 is
  begin
    return Lower(Two_Step_Reverse(to_char(Nvl(to_number(i_Rfid), 0), 'FM000000000X')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Rfid_Decode(i_Rfid varchar2) return varchar2 is
  begin
    return to_char(to_number(Two_Step_Reverse(i_Rfid), 'FM000000000X'), 'FM0000000000');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Send_Command
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Command    varchar2
  ) is
    v_Command_Id number := Hzk_Commands_Sq.Nextval;
  begin
    z_Hzk_Commands.Insert_One(i_Company_Id       => i_Company_Id,
                              i_Command_Id       => v_Command_Id,
                              i_Device_Id        => i_Device_Id,
                              i_Command          => 'C:' || v_Command_Id || ':' || i_Command ||
                                                    Chr(13) || Chr(10),
                              i_State            => 'N',
                              i_State_Changed_On => sysdate);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Send_Check
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    z_Hzk_Devices.Update_One(i_Company_Id        => i_Company_Id,
                             i_Device_Id         => i_Device_Id,
                             i_Check_Sent_On     => Option_Date(sysdate),
                             i_Check_Received_On => Option_Date(null),
                             i_Opstamp           => Option_Number(0));
  
    Send_Command(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id, i_Command => 'CHECK');
    -- todo: INFO command; Owner: Sherzod; Date: 03.02.2022
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Fingerprints
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  ) is
  begin
    for r in (select t.Finger_No, t.Tmp
                from Hzk_Person_Fprints t
               where t.Company_Id = i_Company_Id
                 and t.Person_Id = i_Person_Id
                 and not exists (select 1
                        from Hzk_Device_Fprints w
                       where w.Company_Id = t.Company_Id
                         and w.Device_Id = i_Device_Id
                         and w.Person_Id = t.Person_Id
                         and w.Finger_No = t.Finger_No))
    loop
      Cmd_Update_Fingerprint(i_Company_Id => i_Company_Id,
                             i_Device_Id  => i_Device_Id,
                             i_Person_Id  => i_Person_Id,
                             i_Finger_No  => r.Finger_No,
                             i_Tmp        => r.Tmp);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Sync_Fingerprints
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
  begin
    for r in (select *
                from Hzk_Device_Persons t
               where t.Company_Id = i_Company_Id
                 and t.Person_Id = i_Person_Id)
    loop
      Cmd_Delete_Fingerprint(i_Company_Id => i_Company_Id,
                             i_Device_Id  => r.Device_Id,
                             i_Person_Id  => i_Person_Id,
                             i_Pin        => null);
    end loop;
  
    for r in (select t.*, w.Finger_No, w.Tmp
                from Hzk_Device_Persons t
                join Hzk_Person_Fprints w
                  on w.Company_Id = t.Company_Id
                 and w.Person_Id = t.Person_Id
               where t.Company_Id = i_Company_Id
                 and t.Person_Id = i_Person_Id
                 and exists (select 1
                        from Htt_Devices q
                       where q.Company_Id = t.Company_Id
                         and q.Device_Id = t.Device_Id
                         and exists (select 1
                                from Htt_Terminal_Models Tm
                               where Tm.Model_Id = q.Model_Id
                                 and Tm.Support_Fprint = 'Y')))
    loop
      Cmd_Update_Fingerprint(i_Company_Id => i_Company_Id,
                             i_Device_Id  => r.Device_Id,
                             i_Person_Id  => i_Person_Id,
                             i_Finger_No  => r.Finger_No,
                             i_Tmp        => r.Tmp);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Sync_Person
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  ) is
    r_Person      Htt_Persons%rowtype;
    r_Device      Htt_Devices%rowtype;
    r_Model       Htt_Terminal_Models%rowtype;
    v_Photo_Sha   Htt_Person_Photos.Photo_Sha%type;
    v_Person_Role varchar2(1);
  begin
    r_Person := z_Htt_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  
    if r_Person.Pin is null then
      return;
    end if;
  
    if z_Htt_Device_Admins.Exist(i_Company_Id => i_Company_Id,
                                 i_Device_Id  => i_Device_Id,
                                 i_Person_Id  => i_Person_Id) then
      v_Person_Role := Htt_Pref.c_Person_Role_Admin;
    else
      v_Person_Role := Htt_Pref.c_Person_Role_Normal;
    end if;
  
    -- update person
    Cmd_Update_Person(i_Company_Id  => i_Company_Id,
                      i_Device_Id   => i_Device_Id,
                      i_Person_Id   => i_Person_Id,
                      i_Name        => z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id).Name,
                      i_Pin         => r_Person.Pin,
                      i_Password    => r_Person.Pin_Code,
                      i_Person_Role => v_Person_Role,
                      i_Rfid_Code   => r_Person.Rfid_Code);
  
    r_Device := z_Htt_Devices.Load(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  
    r_Model := z_Htt_Terminal_Models.Load(r_Device.Model_Id);
  
    if r_Model.Support_Face_Recognation = 'Y' then
      begin
        -- update biophoto
        select q.Photo_Sha
          into v_Photo_Sha
          from Htt_Person_Photos q
         where q.Company_Id = i_Company_Id
           and q.Person_Id = r_Person.Person_Id
         order by Nullif(q.Is_Main, 'Y') nulls first
         fetch first row only;
      
        Cmd_Update_Biophoto(i_Company_Id => i_Company_Id,
                            i_Device_Id  => i_Device_Id,
                            i_Pin        => r_Person.Pin,
                            i_Sha        => v_Photo_Sha);
      
        -- update userpic
        /*        Cmd_Update_Userpic(i_Company_Id => i_Company_Id,
        i_Device_Id  => i_Device_Id,
        i_Pin        => r_Person.Pin,
        i_Sha        => v_Photo_Sha);*/
      exception
        when No_Data_Found then
          null;
      end;
    end if;
  
    -- sync Fingerprints
    if r_Model.Support_Fprint = 'Y' then
      Update_Fingerprints(i_Company_Id => i_Company_Id,
                          i_Device_Id  => i_Device_Id,
                          i_Person_Id  => i_Person_Id);
    end if;
  
    -- todo DATA UPDATE USERINFO; DATA UPDATE USERPIC (size, content); Owner:Sherzod; Date: 03.02.2022
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Sync_Person
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal);
  begin
    for r in (select t.Device_Id
                from Hzk_Device_Persons t
                join Htt_Devices d
                  on d.Company_Id = t.Company_Id
                 and d.Device_Id = t.Device_Id
               where t.Company_Id = i_Company_Id
                 and t.Person_Id = i_Person_Id
                 and not exists
               (select 1
                        from Htt_Location_Persons c
                       where c.Company_Id = t.Company_Id
                         and c.Location_Id = d.Location_Id
                         and c.Person_Id = t.Person_Id
                         and not exists (select 1
                                from Htt_Blocked_Person_Tracking Bp
                               where Bp.Company_Id = c.Company_Id
                                 and Bp.Filial_Id = c.Filial_Id
                                 and Bp.Employee_Id = c.Person_Id))
                 and not exists (select 1
                        from Htt_Device_Admins w
                       where w.Company_Id = t.Company_Id
                         and w.Device_Id = t.Device_Id
                         and w.Person_Id = t.Person_Id))
    loop
      Cmd_Delete_Person(i_Company_Id => i_Company_Id,
                        i_Device_Id  => r.Device_Id,
                        i_Person_Id  => i_Person_Id);
    end loop;
  
    for r in (select t.Device_Id
                from Htt_Devices t
               where t.Company_Id = i_Company_Id
                 and t.Device_Type_Id = v_Device_Type_Id
                 and (exists (select 1
                                from Htt_Location_Persons c
                               where c.Company_Id = i_Company_Id
                                 and c.Location_Id = t.Location_Id
                                 and c.Person_Id = i_Person_Id
                                 and not exists (select 1
                                        from Htt_Blocked_Person_Tracking Bp
                                       where Bp.Company_Id = c.Company_Id
                                         and Bp.Filial_Id = c.Filial_Id
                                         and Bp.Employee_Id = c.Person_Id)) or --
                      exists (select 1
                                from Htt_Device_Admins w
                               where w.Company_Id = t.Company_Id
                                 and w.Device_Id = t.Device_Id
                                 and w.Person_Id = i_Person_Id)))
    loop
      Sync_Person(i_Company_Id => i_Company_Id,
                  i_Device_Id  => r.Device_Id,
                  i_Person_Id  => i_Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Sync_Persons
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
    v_Location_Id number := z_Htt_Devices.Load(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id).Location_Id;
  begin
    for r in (select t.Person_Id
                from Hzk_Device_Persons t
               where t.Company_Id = i_Company_Id
                 and t.Device_Id = i_Device_Id
                 and not exists
               (select 1
                        from Htt_Location_Persons c
                       where c.Company_Id = i_Company_Id
                         and c.Location_Id = v_Location_Id
                         and c.Person_Id = t.Person_Id
                         and not exists (select 1
                                from Htt_Blocked_Person_Tracking Bp
                               where Bp.Company_Id = c.Company_Id
                                 and Bp.Filial_Id = c.Filial_Id
                                 and Bp.Employee_Id = c.Person_Id))
                 and not exists (select 1
                        from Htt_Device_Admins w
                       where w.Company_Id = t.Company_Id
                         and w.Device_Id = t.Device_Id
                         and w.Person_Id = t.Person_Id))
    loop
      Cmd_Delete_Person(i_Company_Id => i_Company_Id,
                        i_Device_Id  => i_Device_Id,
                        i_Person_Id  => r.Person_Id);
    end loop;
  
    for r in (select t.Person_Id
                from (select w.Person_Id
                        from Htt_Location_Persons w
                       where w.Company_Id = i_Company_Id
                         and w.Location_Id = v_Location_Id
                         and not exists (select 1
                                from Htt_Blocked_Person_Tracking Bp
                               where Bp.Company_Id = w.Company_Id
                                 and Bp.Filial_Id = w.Filial_Id
                                 and Bp.Employee_Id = w.Person_Id)
                      union
                      select q.Person_Id
                        from Htt_Device_Admins q
                       where q.Company_Id = i_Company_Id
                         and q.Device_Id = i_Device_Id) t
               where not exists (select 1
                        from Hzk_Device_Persons c
                       where c.Company_Id = i_Company_Id
                         and c.Device_Id = i_Device_Id
                         and c.Person_Id = t.Person_Id))
    loop
      Sync_Person(i_Company_Id => i_Company_Id,
                  i_Device_Id  => i_Device_Id,
                  i_Person_Id  => r.Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    z_Hzk_Devices.Lock_Only(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  
    Sync_Persons(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Update_Device
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Info       varchar2,
    i_Stamp      number,
    i_Opstamp    number
  ) is
    v_Info               Array_Varchar2;
    v_User_Number        Option_Number;
    v_Fingerprint_Number Option_Number;
    v_Attendance_Number  Option_Number;
    v_Ip_Address         Option_Varchar2;
    v_Stamp              Option_Number;
    v_Opstamp            Option_Number;
  begin
    z_Hzk_Devices.Lock_Only(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  
    if i_Info is not null then
      v_Info := Fazo.Split(i_Info, ',');
    
      if v_Info(2) is not null then
        v_User_Number := Option_Number(v_Info(2));
      end if;
    
      if v_Info(3) is not null then
        v_Fingerprint_Number := Option_Number(v_Info(3));
      end if;
    
      if v_Info(4) is not null then
        v_Attendance_Number := Option_Number(v_Info(4));
      end if;
    
      if v_Info(5) is not null then
        v_Ip_Address := Option_Varchar2(v_Info(5));
      end if;
    end if;
  
    if i_Stamp is not null then
      v_Stamp := Option_Number(i_Stamp);
    end if;
  
    if i_Opstamp is not null then
      v_Opstamp := Option_Number(i_Opstamp);
    end if;
  
    z_Hzk_Devices.Update_One(i_Company_Id         => i_Company_Id,
                             i_Device_Id          => i_Device_Id,
                             i_User_Number        => v_User_Number,
                             i_Fingerprint_Number => v_Fingerprint_Number,
                             i_Attendance_Number  => v_Attendance_Number,
                             i_Ip_Address         => v_Ip_Address,
                             i_Stamp              => v_Stamp,
                             i_Opstamp            => v_Opstamp);
  
    Htt_Api.Device_Update(i_Company_Id   => i_Company_Id,
                          i_Device_Id    => i_Device_Id,
                          i_Last_Seen_On => Option_Date(sysdate));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Options
  (
    i_Company_Id number,
    i_Device_Id  number
  ) return Array_Varchar2 is
    r_Device        Hzk_Devices%rowtype;
    v_Serial_Number varchar2(100 char);
    Writer          Stream := Stream();
    v_Trans_Flags   Array_Varchar2 := Array_Varchar2('AttLog',
                                                     'OpLog',
                                                     'AttPhoto',
                                                     'EnrollFP',
                                                     'EnrollUser',
                                                     'FPImag',
                                                     'ChgUser',
                                                     'ChgFP',
                                                     'FACE',
                                                     'UserPic',
                                                     'FVEIN',
                                                     'BioPhoto');
  begin
    r_Device := z_Hzk_Devices.Load(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  
    v_Serial_Number := z_Htt_Devices.Load(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id).Serial_Number;
  
    -- todo: uncommit; Owner: Sherzod; Date: 03.02.2022
    Writer.Println('GET OPTION FROM: ' || v_Serial_Number);
    Writer.Println('Stamp=' || Nvl(r_Device.Stamp, 0));
    Writer.Println('OpStamp=' || Nvl(r_Device.Opstamp, 0));
    Writer.Println('PhotoStamp=' || Nvl(r_Device.Photostamp, 0));
    Writer.Println('ErrorDelay=' || Nvl(r_Device.Error_Delay, 30));
    Writer.Println('Delay=' || Nvl(r_Device.Delay, 30));
    Writer.Println('TransTimes=' || Nvl(r_Device.Transtimes, '00:00;'));
    Writer.Println('TransInterval=' || Nvl(r_Device.Transinterval, 1));
    -- Writer.Println('ServerVer=2.4.1');
    -- Writer.Println('PushProtVer=2.4.1');
    -- Writer.Println('EncryptFlag=1000000000');
    -- Writer.Println('PushOptionsFlag=1');
    -- Writer.Println('supportPing=1');
    -- Writer.Println('PushOptions=UserCount,TransactionCount,FingerFunOn,FPVersion,FPCount,FaceFunOn,FaceVersion,FaceCount,FvFunOn,FvVersion,FvCount,PvFunOn,PvVersion,PvCount,BioPhotoFun,BioDataFun,PhotoFunOn,~LockFunOn');
    -- Writer.Println('TransFlag=1111101011');
    Writer.Println('TransFlag=TransData ' || Fazo.Gather(v_Trans_Flags, Chr(9)));
    Writer.Println('TimeZone=5');
    Writer.Println('Realtime=' || Nvl(r_Device.Realtime, 1));
    Writer.Println('Encrypt=None');
  
    return Writer.Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Update_Person
  (
    i_Company_Id  number,
    i_Device_Id   number,
    i_Person_Id   number,
    i_Name        varchar2,
    i_Pin         varchar2,
    i_Password    varchar2,
    i_Person_Role varchar2,
    i_Rfid_Code   varchar2
  ) is
    v_Name Mr_Natural_Persons.Name%type := trim(Substr(i_Name, 0, 24));
  begin
    z_Hzk_Device_Persons.Insert_Try(i_Company_Id => i_Company_Id,
                                    i_Device_Id  => i_Device_Id,
                                    i_Person_Id  => i_Person_Id);
  
    Send_Command(i_Company_Id => i_Company_Id,
                 i_Device_Id  => i_Device_Id,
                 i_Command    => 'DATA USER PIN=' || i_Pin || Chr(9) || --
                                 'Name=' || Md_Lang.Encode_Ascii(Nullif(v_Name, ' ')) || Chr(9) || --
                                 'Pri=' || case i_Person_Role
                                   when Htt_Pref.c_Person_Role_Admin then
                                    14
                                   when Htt_Pref.c_Person_Role_Normal then
                                    0
                                 end || Chr(9) || --
                                 'Passwd=' || i_Password || Chr(9) || --
                                 'Card=[' || Rfid_Encode(i_Rfid_Code) || ']');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Delete_Person
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number := null,
    i_Pin        varchar2 := null
  ) is
  begin
    if i_Person_Id is not null then
      z_Hzk_Device_Persons.Delete_One(i_Company_Id => i_Company_Id,
                                      i_Device_Id  => i_Device_Id,
                                      i_Person_Id  => i_Person_Id);
    
      Send_Command(i_Company_Id => i_Company_Id,
                   i_Device_Id  => i_Device_Id,
                   i_Command    => 'DATA DEL_USER PIN=' || --
                                   Htt_Util.Pin(i_Company_Id => i_Company_Id,
                                                i_Person_Id  => i_Person_Id));
    elsif i_Pin is not null then
      z_Hzk_Device_Persons.Delete_One(i_Company_Id => i_Company_Id,
                                      i_Device_Id  => i_Device_Id,
                                      i_Person_Id  => Htt_Util.Person_Id(i_Company_Id => i_Company_Id,
                                                                         i_Pin        => i_Pin));
    
      Send_Command(i_Company_Id => i_Company_Id,
                   i_Device_Id  => i_Device_Id,
                   i_Command    => 'DATA DEL_USER PIN=' || i_Pin);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Update_Biophoto
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Pin        varchar2,
    i_Sha        varchar2
  ) is
  begin
    if i_Sha is not null then
      Send_Command(i_Company_Id => i_Company_Id,
                   i_Device_Id  => i_Device_Id,
                   i_Command    => 'DATA UPDATE BIOPHOTO PIN=' || i_Pin || Chr(9) || --
                                   'Type=9' || Chr(9) || --
                                   'Format=1' || Chr(9) || --
                                   'Url=b/core/m$load_image?sha=' || i_Sha ||
                                   '&width=300&height=300&quality=0.8&format=JPEG');
    else
      Send_Command(i_Company_Id => i_Company_Id,
                   i_Device_Id  => i_Device_Id,
                   i_Command    => 'DATA DELETE BIOPHOTO PIN=' || i_Pin);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Update_Userpic
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Pin        varchar2,
    i_Sha        varchar2
  ) is
    r_File       Biruni_Filespace%rowtype;
    v_Command_Id number := Hzk_Commands_Sq.Nextval;
    v_Command    clob;
    v_Clob       clob;
  
    -------------------------------------------------- 
    Procedure Writeappend(i_Text varchar2) is
    begin
      Dbms_Lob.Writeappend(v_Command, Length(i_Text), i_Text);
    end;
  
    --------------------------------------------------
    Procedure Base64encode is
      v_Temp clob;
      v_Step pls_integer := 12000; -- make sure you set a multiple of 3 not higher than 24573
    begin
      for i in 0 .. Trunc((Dbms_Lob.Getlength(r_File.File_Content) - 1) / v_Step)
      loop
        v_Temp := Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Encode(Dbms_Lob.Substr(r_File.File_Content,
                                                                                    v_Step,
                                                                                    i * v_Step + 1)));
        v_Clob := v_Clob || v_Temp;
      end loop;
    end;
  begin
    Dbms_Lob.Createtemporary(v_Command, false);
    Dbms_Lob.Open(v_Command, Dbms_Lob.Lob_Readwrite);
  
    Writeappend('C:' || v_Command_Id || ':');
  
    if i_Sha is not null then
      select *
        into r_File
        from Biruni_Filespace q
       where q.Sha = i_Sha;
    
      Base64encode;
    
      Writeappend('DATA UPDATE USERPIC PIN=' || i_Pin || Chr(9));
      Writeappend('Size=' || Length(v_Clob) || Chr(9));
      Writeappend('Content=');
      Dbms_Lob.Append(v_Command, v_Clob);
    else
      Writeappend('DATA DELETE USERPIC PIN=' || i_Pin);
    end if;
  
    Writeappend(Chr(13) || Chr(10));
  
    Dbms_Lob.Close(v_Command);
  
    insert into Hzk_Commands
      (Company_Id, Command_Id, Device_Id, Command, Command_Clob, State, State_Changed_On)
    values
      (i_Company_Id, v_Command_Id, i_Device_Id, null, v_Command, 'N', sysdate);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Update_Fingerprint
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number,
    i_Finger_No  number,
    i_Tmp        varchar2
  ) is
  begin
    z_Hzk_Device_Fprints.Insert_Try(i_Company_Id => i_Company_Id,
                                    i_Device_Id  => i_Device_Id,
                                    i_Person_Id  => i_Person_Id,
                                    i_Finger_No  => i_Finger_No);
  
    Send_Command(i_Company_Id => i_Company_Id,
                 i_Device_Id  => i_Device_Id,
                 i_Command    => 'DATA FP PIN=' ||
                                 Htt_Util.Pin(i_Company_Id => i_Company_Id,
                                              i_Person_Id  => i_Person_Id) || Chr(9) || 'FID=' ||
                                 i_Finger_No || Chr(9) || 'TMP=' || i_Tmp);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Cmd_Delete_Fingerprint
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number,
    i_Pin        varchar2
  ) is
    v_Person_Id number;
  begin
    if i_Person_Id is not null then
      v_Person_Id := i_Person_Id;
    
      Send_Command(i_Company_Id => i_Company_Id,
                   i_Device_Id  => i_Device_Id,
                   i_Command    => 'DATA DEL_FP PIN=' ||
                                   Htt_Util.Pin(i_Company_Id => i_Company_Id,
                                                i_Person_Id  => i_Person_Id));
    elsif i_Pin is not null then
      v_Person_Id := Htt_Util.Person_Id(i_Company_Id => i_Company_Id, i_Pin => i_Pin);
    
      Send_Command(i_Company_Id => i_Company_Id,
                   i_Device_Id  => i_Device_Id,
                   i_Command    => 'DATA DEL_FP PIN=' || i_Pin);
    end if;
  
    delete Hzk_Device_Fprints q
     where q.Company_Id = i_Company_Id
       and q.Device_Id = i_Device_Id
       and q.Person_Id = v_Person_Id;
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure Load_User_Info
  (
    i_Columns     Array_Varchar2,
    i_Company_Id  number,
    o_Person_Id   out number,
    o_Pin         out varchar2,
    o_Person_Name out varchar2,
    o_Person_Role out varchar2,
    o_Password    out varchar2,
    o_Rfid_Code   out varchar2,
    o_Finger_Id   out number,
    o_Tmp         out varchar2
  ) is
    v_Key  varchar2(32767);
    v_Val  varchar2(32767);
    v_Keys Array_Varchar2 := Array_Varchar2('pin', 'name', 'pri', 'passwd', 'card', 'fid', 'tmp');
  
    ---------------------------
    Procedure Load_Key
    (
      i_Column varchar2,
      o_Key    out varchar2,
      o_Val    out varchar2
    ) is
      v_Column varchar2(32767) := Lower(i_Column);
    begin
      for i in 1 .. v_Keys.Count
      loop
        if Regexp_Like(v_Column, '^' || v_Keys(i) || '=.*') then
          o_Key := v_Keys(i);
          o_Val := Substr(i_Column, Length(o_Key) + 2);
        end if;
      end loop;
    end;
  begin
    for i in 1 .. i_Columns.Count
    loop
      Load_Key(i_Columns(i), v_Key, v_Val);
    
      case v_Key
        when 'pin' then
          o_Person_Id := Htt_Util.Person_Id(i_Company_Id => i_Company_Id, i_Pin => v_Val);
          o_Pin       := v_Val;
        when 'name' then
          o_Person_Name := v_Val;
        when 'pri' then
          if v_Val = 0 then
            o_Person_Role := Htt_Pref.c_Person_Role_Normal;
          elsif v_Val = 14 then
            o_Person_Role := Htt_Pref.c_Person_Role_Admin;
          end if;
        when 'Passwd' then
          o_Password := v_Val;
        when 'Card' then
          o_Rfid_Code := Rfid_Decode(Regexp_Substr(v_Val, '^\[(.+)\]$', 1, 1, 'i', 1));
        when 'fid' then
          o_Finger_Id := v_Val;
        when 'tmp' then
          o_Tmp := v_Val;
        else
          null;
      end case;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Device_Person
  (
    i_Company_Id     number,
    i_Migr_Person_Id number,
    i_Device_Id      number,
    i_Person_Id      number,
    i_Pin            varchar2,
    i_Person_Name    varchar2,
    i_Person_Role    varchar2,
    i_Password       varchar2,
    i_Rfid_Code      varchar2
  ) is
  begin
    if not z_Hzk_Device_Persons.Exist(i_Company_Id => i_Company_Id,
                                      i_Device_Id  => i_Device_Id,
                                      i_Person_Id  => i_Person_Id) then
      z_Hzk_Migr_Persons.Save_One(i_Company_Id     => i_Company_Id,
                                  i_Migr_Person_Id => i_Migr_Person_Id,
                                  i_Device_Id      => i_Device_Id,
                                  i_Pin            => i_Pin,
                                  i_Person_Name    => i_Person_Name,
                                  i_Person_Role    => i_Person_Role,
                                  i_Password       => i_Password,
                                  i_Rfid_Code      => i_Rfid_Code);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Save_Device_Finger
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number,
    i_Pin        varchar2,
    i_Finger_No  number,
    i_Tmp        varchar2
  ) is
  begin
    if z_Hzk_Device_Persons.Exist(i_Company_Id => i_Company_Id,
                                  i_Device_Id  => i_Device_Id,
                                  i_Person_Id  => i_Person_Id) then
      z_Hzk_Person_Fprints.Save_One(i_Company_Id => i_Company_Id,
                                    i_Person_Id  => i_Person_Id,
                                    i_Finger_No  => i_Finger_No,
                                    i_Tmp        => i_Tmp);
    
      z_Hzk_Device_Fprints.Insert_Try(i_Company_Id => i_Company_Id,
                                      i_Device_Id  => i_Device_Id,
                                      i_Person_Id  => i_Person_Id,
                                      i_Finger_No  => i_Finger_No);
    
      for r in (select distinct t.Device_Id
                  from Hzk_Device_Persons t
                 where t.Company_Id = i_Company_Id
                   and t.Device_Id <> i_Device_Id
                   and t.Person_Id = i_Person_Id)
      loop
        Cmd_Update_Fingerprint(i_Company_Id => i_Company_Id,
                               i_Device_Id  => i_Device_Id,
                               i_Person_Id  => i_Person_Id,
                               i_Finger_No  => i_Finger_No,
                               i_Tmp        => i_Tmp);
      end loop;
    else
      z_Hzk_Migr_Fprints.Save_One(i_Company_Id => i_Company_Id,
                                  i_Device_Id  => i_Device_Id,
                                  i_Pin        => i_Pin,
                                  i_Finger_No  => i_Finger_No,
                                  i_Tmp        => i_Tmp);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Error(i_Error varchar2) is
    pragma autonomous_transaction;
  begin
    insert into Hzk_Errors
      (Error, Created_On)
    values
      (i_Error, sysdate);
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Operlog
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Lines      Array_Varchar2
  ) is
    v_Row         Array_Varchar2;
    v_Type        varchar2(10);
    v_Pos         pls_integer;
    v_Person_Id   number;
    v_Pin         varchar2(20);
    v_Person_Name Mr_Natural_Persons.Name%type;
    v_Finger_No   number;
    v_Person_Role varchar2(1);
    v_Password    Htt_Persons.Pin_Code%type;
    v_Rfid_Code   Htt_Persons.Rfid_Code%type;
    v_Tmp         Hzk_Person_Fprints.Tmp%type;
  begin
    for i in 1 .. i_Lines.Count
    loop
      v_Row := Fazo.Split(i_Lines(i), Chr(9));
      v_Pos := Instr(v_Row(1), ' ');
      v_Type := Substr(v_Row(1), 1, v_Pos - 1);
      v_Row(1) := Substr(v_Row(1), v_Pos + 1);
    
      case v_Type
        when 'USER' then
          Load_User_Info(i_Columns     => v_Row,
                         i_Company_Id  => i_Company_Id,
                         o_Person_Id   => v_Person_Id,
                         o_Pin         => v_Pin,
                         o_Person_Name => v_Person_Name,
                         o_Person_Role => v_Person_Role,
                         o_Password    => v_Password,
                         o_Rfid_Code   => v_Rfid_Code,
                         o_Finger_Id   => v_Finger_No,
                         o_Tmp         => v_Tmp);
        
          Save_Device_Person(i_Company_Id     => i_Company_Id,
                             i_Migr_Person_Id => Hzk_Next.Migr_Person_Id,
                             i_Device_Id      => i_Device_Id,
                             i_Person_Id      => v_Person_Id,
                             i_Pin            => v_Pin,
                             i_Person_Name    => v_Person_Name,
                             i_Person_Role    => v_Person_Role,
                             i_Password       => v_Password,
                             i_Rfid_Code      => v_Rfid_Code);
        when 'FP' then
          Load_User_Info(i_Columns     => v_Row,
                         i_Company_Id  => i_Company_Id,
                         o_Person_Id   => v_Person_Id,
                         o_Pin         => v_Pin,
                         o_Person_Name => v_Person_Name,
                         o_Person_Role => v_Person_Role,
                         o_Password    => v_Password,
                         o_Rfid_Code   => v_Rfid_Code,
                         o_Finger_Id   => v_Finger_No,
                         o_Tmp         => v_Tmp);
        
          Save_Device_Finger(i_Company_Id => i_Company_Id,
                             i_Device_Id  => i_Device_Id,
                             i_Person_Id  => v_Person_Id,
                             i_Pin        => v_Pin,
                             i_Finger_No  => v_Finger_No,
                             i_Tmp        => v_Tmp);
        when 'BIOPHOTO' then
          null;
        when 'OPLOG' then
          null;
        else
          Hzk_Error.Raise_007(i_Operlog_Type  => v_Type,
                              i_Operlog_Types => Array_Varchar2('USER', 'FP', 'BIOPHOTO', 'OPLOG'));
      end case;
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Attlog_Error
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Command    varchar2,
    i_Error      varchar2
  ) is
    pragma autonomous_transaction;
  begin
    insert into Hzk_Attlog_Errors
      (Company_Id,
       Error_Id, --
       Device_Id,
       Command,
       Error)
    values
      (i_Company_Id,
       Hzk_Next.Attlog_Error_Id, --
       i_Device_Id,
       i_Command,
       i_Error);
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Attlog
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Lines      Array_Varchar2
  ) is
    r_Location   Htt_Locations%rowtype;
    v_Row        Array_Varchar2;
    v_Filial_Ids Array_Number;
    r_Track      Htt_Tracks%rowtype;
    r_Device     Htt_Devices%rowtype;
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  
    r_Location := z_Htt_Locations.Load(i_Company_Id  => i_Company_Id,
                                       i_Location_Id => r_Device.Location_Id);
  
    r_Track.Company_Id  := i_Company_Id;
    r_Track.Device_Id   := i_Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
  
    for i in 1 .. i_Lines.Count
    loop
      begin
        v_Row := Fazo.Split(i_Lines(i), Chr(9));
      
        r_Track.Person_Id := Htt_Util.Person_Id(i_Company_Id => i_Company_Id, i_Pin => v_Row(1));
      
        if v_Row(3) = '0' then
          r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
        elsif v_Row(3) = '1' then
          r_Track.Track_Type := Htt_Pref.c_Track_Type_Output;
        else
          r_Track.Track_Type := Htt_Pref.c_Track_Type_Check;
        end if;
      
        if r_Location.Timezone_Code is not null then
          r_Track.Track_Time := Htt_Util.Convert_Timestamp(to_date(v_Row(2),
                                                                   'yyyy-mm-dd hh24:mi:ss'),
                                                           r_Location.Timezone_Code);
        else
          r_Track.Track_Time := to_date(v_Row(2), 'yyyy-mm-dd hh24:mi:ss');
        end if;
      
        r_Track.Track_Date := Trunc(r_Track.Track_Time);
      
        case v_Row(4)
          when 0 then
            r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Password;
          when 1 then
            r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Touch;
          when 2 then
            r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Rfid_Card;
          when 15 then
            r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Face;
          else
            r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Manual;
        end case;
      
        if r_Track.Person_Id is not null then
          v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                                  i_Location_Id => r_Track.Location_Id,
                                                  i_Person_Id   => r_Track.Person_Id);
        
          for i in 1 .. v_Filial_Ids.Count
          loop
            r_Track.Track_Datetime := Htt_Util.Timestamp_To_Date(i_Timestamp => r_Track.Track_Time,
                                                                 i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => r_Track.Company_Id,
                                                                                                       i_Filial_Id  => v_Filial_Ids(i)));
          
            r_Track.Filial_Id := v_Filial_Ids(i);
          
            if not Htt_Util.Exist_Track(i_Company_Id     => r_Track.Company_Id,
                                        i_Filial_Id      => v_Filial_Ids(i),
                                        i_Person_Id      => r_Track.Person_Id,
                                        i_Track_Type     => r_Track.Track_Type,
                                        i_Track_Datetime => r_Track.Track_Datetime,
                                        i_Device_Id      => r_Track.Device_Id) then
            
              r_Track.Track_Id  := Htt_Next.Track_Id;
              r_Track.Filial_Id := v_Filial_Ids(i);
            
              Htt_Api.Track_Add(r_Track);
            end if;
          end loop;
        else
          z_Hzk_Migr_Tracks.Save_One(i_Company_Id    => i_Company_Id,
                                     i_Migr_Track_Id => Hzk_Next.Migr_Track_Id,
                                     i_Pin           => v_Row(1),
                                     i_Device_Id     => r_Track.Device_Id,
                                     i_Location_Id   => r_Track.Location_Id,
                                     i_Track_Type    => r_Track.Track_Type,
                                     i_Track_Time    => r_Track.Track_Time,
                                     i_Track_Date    => r_Track.Track_Date,
                                     i_Mark_Type     => r_Track.Mark_Type);
        end if;
      exception
        when others then
          Insert_Attlog_Error(i_Company_Id => i_Company_Id,
                              i_Device_Id  => i_Device_Id,
                              i_Command    => i_Lines(i),
                              i_Error      => sqlerrm || Chr(13) || Chr(10) ||
                                              Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Commands
  (
    i_Company_Id number,
    i_Device_Id  number
  ) return Array_Varchar2 is
    v_Command      Hzk_Commands.Command%type;
    v_Command_Clob Hzk_Commands.Command_Clob%type;
    v_Len          number := 0;
    v_Sysdate      date := sysdate;
    v_Commands     Array_Varchar2;
    result         Array_Varchar2 := Array_Varchar2();
  begin
    for r in (select *
                from (select t.Command_Id
                        from Hzk_Commands t
                       where t.Company_Id = i_Company_Id
                         and t.Device_Id = i_Device_Id
                         and t.State = Hzk_Pref.c_Cs_New
                       order by t.Command_Id) t
               where Rownum < 50)
    loop
      exit when v_Len > 15000;
    
      update Hzk_Commands t
         set t.State            = Hzk_Pref.c_Cs_Sent,
             t.State_Changed_On = v_Sysdate
       where t.Command_Id = r.Command_Id
         and t.State = Hzk_Pref.c_Cs_New
      returning t.Command, t.Command_Clob into v_Command, v_Command_Clob;
    
      if v_Command is not null then
        Fazo.Push(result, v_Command);
        v_Len := v_Len + Length(v_Command);
      elsif v_Command_Clob is not null then
        v_Commands := Fazo.Read_Clob(v_Command_Clob);
      
        for i in 1 .. v_Commands.Count
        loop
          Fazo.Push(result, v_Commands(i));
          v_Len := v_Len + Length(v_Commands(i));
        end loop;
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Commands
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Lines      Array_Varchar2
  ) is
    v_Command_Id number;
    v_Row        Array_Varchar2;
    v_Type       varchar2(500);
  begin
    for i in 1 .. i_Lines.Count
    loop
      begin
        v_Row        := Fazo.Split(i_Lines(i), '&');
        v_Command_Id := Substr(v_Row(1), 4);
      
        if v_Row.Count >= 3 then
          v_Type := Substr(v_Row(3), 5);
        
          if v_Type = 'CHECK' then
            z_Hzk_Devices.Update_One(i_Company_Id        => i_Company_Id,
                                     i_Device_Id         => i_Device_Id,
                                     i_Check_Received_On => Option_Date(sysdate));
          end if;
        
          -- todo: INFO, DATA command; Owner: Sherzod; Date: 03.02.2022
        end if;
      
        z_Hzk_Commands.Update_One(i_Company_Id => i_Company_Id,
                                  i_Command_Id => v_Command_Id,
                                  i_State      => Option_Varchar2(Hzk_Pref.c_Cs_Complete));
      exception
        when others then
          continue;
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Info
  (
    i_Device_Type_Id varchar2,
    i_Serial_Number  varchar2,
    o_Company_Id     out number,
    o_Device_Id      out number
  ) is
  begin
    select q.Company_Id, q.Device_Id
      into o_Company_Id, o_Device_Id
      from Htt_Devices q
     where q.Device_Type_Id = i_Device_Type_Id
       and q.Serial_Number = i_Serial_Number;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process
  (
    i_Path   varchar2,
    i_Query  varchar2,
    i_Input  Array_Varchar2,
    o_Output out Array_Varchar2
  ) is
    v_Query          Hashmap := Fazo.Parse_Map(i_Query);
    v_Commands       Array_Varchar2;
    v_Company_Id     number;
    v_Device_Id      number;
    v_Serial_Number  Htt_Devices.Serial_Number%type;
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal);
  begin
    Biruni_Route.Context_Begin;
  
    v_Serial_Number := v_Query.o_Varchar2('SN');
  
    if v_Serial_Number is null then
      Hzk_Error.Raise_009;
    end if;
  
    Device_Info(i_Device_Type_Id => v_Device_Type_Id,
                i_Serial_Number  => v_Serial_Number,
                o_Company_Id     => v_Company_Id,
                o_Device_Id      => v_Device_Id);
  
    Ui_Auth.Logon_As_System(v_Company_Id);
  
    -- TODO: resive OpStamp by BIO 8.0 application  
    Update_Device(i_Company_Id => v_Company_Id,
                  i_Device_Id  => v_Device_Id,
                  i_Info       => v_Query.o_Varchar2('INFO'),
                  i_Stamp      => v_Query.o_Number('stamp'),
                  i_Opstamp    => v_Query.o_Number('opstamp'));
  
    case i_Path
      when '/iclock/cdata' then
        if v_Query.Has('options') then
          o_Output := Options(i_Company_Id => v_Company_Id, i_Device_Id => v_Device_Id);
        elsif v_Query.Has('table') then
          case v_Query.r_Varchar2('table')
            when 'OPERLOG' then
              Eval_Operlog(i_Company_Id => v_Company_Id,
                           i_Device_Id  => v_Device_Id,
                           i_Lines      => i_Input);
            when 'ATTLOG' then
              Eval_Attlog(i_Company_Id => v_Company_Id,
                          i_Device_Id  => v_Device_Id,
                          i_Lines      => i_Input);
            when 'BIODATA' then
              null; --b.Raise_Not_Implemented;
            when 'options' then
              null; --b.Raise_Not_Implemented;
            else
              null;
          end case;
        
          o_Output := c_Ok;
        end if;
      when '/iclock/getrequest' then
        v_Commands := Load_Commands(i_Company_Id => v_Company_Id, i_Device_Id => v_Device_Id);
        if v_Commands.Count = 0 then
          o_Output := c_Ok;
        else
          o_Output := v_Commands;
        end if;
      when '/iclock/devicecmd' then
        Eval_Commands(i_Company_Id => v_Company_Id, --
                      i_Device_Id  => v_Device_Id,
                      i_Lines      => i_Input);
      
        o_Output := c_Ok;
      else
        o_Output := c_Ok;
    end case;
  
    Biruni_Route.Context_End;
  exception
    when others then
      o_Output := c_Ok;
    
      rollback;
    
      Save_Error(sqlerrm || Chr(13) || Chr(10) || Dbms_Utility.Format_Error_Backtrace);
  end;

end Hzk_External;
/
