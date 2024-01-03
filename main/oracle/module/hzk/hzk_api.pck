create or replace package Hzk_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Add(i_Zktime Hzk_Pref.Zktime_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Update
  (
    i_Company_Id         number,
    i_Device_Id          number,
    i_Name               Option_Varchar2 := null,
    i_Model_Id           Option_Number := null,
    i_Location_Id        Option_Number := null,
    i_State              Option_Varchar2 := null,
    i_Last_Seen_On       Option_Date := null,
    i_Check_Sent_On      Option_Date := null,
    i_Check_Received_On  Option_Date := null,
    i_User_Number        Option_Number := null,
    i_Fingerprint_Number Option_Number := null,
    i_Attendance_Number  Option_Number := null,
    i_Ip_Address         Option_Varchar2 := null,
    i_Stamp              Option_Number := null,
    i_Opstamp            Option_Number := null,
    i_Photostamp         Option_Number := null,
    i_Error_Delay        Option_Number := null,
    i_Delay              Option_Number := null,
    i_Transtimes         Option_Varchar2 := null,
    i_Transinterval      Option_Number := null,
    i_Realtime           Option_Number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Sync
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Check
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Fprint_Save(i_Person_Frints Hzk_Pref.Person_Fprints_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Sync
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Sync(i_Person Htt_Global.Person_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Sync
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Person_Save
  (
    i_Company_Id     number,
    i_Migr_Person_Id number,
    i_Person_Id      number,
    i_Pin            varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Person_Delete
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Pin        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Track_Save
  (
    i_Company_Id    number,
    i_Migr_Track_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Track_Delete
  (
    i_Company_Id    number,
    i_Migr_Track_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Attlog_Error
  (
    i_Company_Id number,
    i_Error_Id   number
  );
end Hzk_Api;
/
create or replace package body Hzk_Api is
  ------------------------------------------------------------------------------------------------  
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
    return b.Translate('HZK:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Device_Add(i_Zktime Hzk_Pref.Zktime_Rt) is
    r_Device Htt_Devices%rowtype;
  begin
    r_Device.Company_Id      := i_Zktime.Company_Id;
    r_Device.Device_Id       := i_Zktime.Device_Id;
    r_Device.Name            := i_Zktime.Name;
    r_Device.Device_Type_Id  := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal);
    r_Device.Serial_Number   := i_Zktime.Serial_Number;
    r_Device.Model_Id        := i_Zktime.Model_Id;
    r_Device.Location_Id     := i_Zktime.Location_Id;
    r_Device.Autogen_Inputs  := i_Zktime.Autogen_Inputs;
    r_Device.Autogen_Outputs := i_Zktime.Autogen_Outputs;
    r_Device.Ignore_Tracks   := i_Zktime.Ignore_Tracks;
    r_Device.Ignore_Images   := i_Zktime.Ignore_Images;
    r_Device.Restricted_Type := i_Zktime.Restricted_Type;
    r_Device.State           := i_Zktime.State;
    r_Device.Use_Settings    := 'Y';
  
    if r_Device.Model_Id is null then
      Hzk_Error.Raise_001(i_Device_Id => r_Device.Device_Id, i_Device_Name => r_Device.Name);
    end if;
  
    if r_Device.Location_Id is null then
      Hzk_Error.Raise_002(i_Device_Id => r_Device.Device_Id, i_Device_Name => r_Device.Name);
    end if;
  
    Htt_Api.Device_Add(r_Device);
  
    z_Hzk_Devices.Insert_One(i_Company_Id => i_Zktime.Company_Id,
                             i_Device_Id  => i_Zktime.Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Device_Update
  (
    i_Company_Id         number,
    i_Device_Id          number,
    i_Name               Option_Varchar2 := null,
    i_Model_Id           Option_Number := null,
    i_Location_Id        Option_Number := null,
    i_State              Option_Varchar2 := null,
    i_Last_Seen_On       Option_Date := null,
    i_Check_Sent_On      Option_Date := null,
    i_Check_Received_On  Option_Date := null,
    i_User_Number        Option_Number := null,
    i_Fingerprint_Number Option_Number := null,
    i_Attendance_Number  Option_Number := null,
    i_Ip_Address         Option_Varchar2 := null,
    i_Stamp              Option_Number := null,
    i_Opstamp            Option_Number := null,
    i_Photostamp         Option_Number := null,
    i_Error_Delay        Option_Number := null,
    i_Delay              Option_Number := null,
    i_Transtimes         Option_Varchar2 := null,
    i_Transinterval      Option_Number := null,
    i_Realtime           Option_Number := null
  ) is
  begin
    Htt_Api.Device_Update(i_Company_Id   => i_Company_Id,
                          i_Device_Id    => i_Device_Id,
                          i_Name         => i_Name,
                          i_Model_Id     => i_Model_Id,
                          i_Location_Id  => i_Location_Id,
                          i_Last_Seen_On => i_Last_Seen_On,
                          i_State        => i_State);
  
    z_Hzk_Devices.Update_One(i_Company_Id         => i_Company_Id,
                             i_Device_Id          => i_Device_Id,
                             i_Check_Sent_On      => i_Check_Sent_On,
                             i_Check_Received_On  => i_Check_Received_On,
                             i_User_Number        => i_User_Number,
                             i_Fingerprint_Number => i_Fingerprint_Number,
                             i_Attendance_Number  => i_Attendance_Number,
                             i_Ip_Address         => i_Ip_Address,
                             i_Stamp              => i_Stamp,
                             i_Opstamp            => i_Opstamp,
                             i_Photostamp         => i_Photostamp,
                             i_Error_Delay        => i_Error_Delay,
                             i_Delay              => i_Delay,
                             i_Transtimes         => i_Transtimes,
                             i_Transinterval      => i_Transinterval,
                             i_Realtime           => i_Realtime);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Device_Sync
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    Hzk_External.Sync_Device(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Device_Check
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    Hzk_External.Send_Check(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Fprint_Save(i_Person_Frints Hzk_Pref.Person_Fprints_Rt) is
    r_Fprint    Hzk_Person_Fprints%rowtype;
    v_Fprint    Hzk_Pref.Fprint_Rt;
    v_Finger_No Array_Number := Array_Number();
    v_Array     Array_Number;
    v_Sync      boolean := false;
  begin
    for i in 1 .. i_Person_Frints.Fprints.Count
    loop
      v_Fprint := i_Person_Frints.Fprints(i);
    
      if v_Fprint.Tmp is not null then
        if v_Fprint.Finger_No not between 0 and 9 then
          Hzk_Error.Raise_003(i_Person_Id   => i_Person_Frints.Person_Id,
                              i_Person_Name => z_Mr_Natural_Persons.Load(i_Company_Id => i_Person_Frints.Company_Id, --
                                               i_Person_Id => i_Person_Frints.Person_Id).Name,
                              i_Finger_No   => v_Fprint.Finger_No);
        end if;
      
        r_Fprint := z_Hzk_Person_Fprints.Take(i_Company_Id => i_Person_Frints.Company_Id,
                                              i_Person_Id  => i_Person_Frints.Person_Id,
                                              i_Finger_No  => v_Fprint.Finger_No);
      
        z_Hzk_Person_Fprints.Save_One(i_Company_Id => i_Person_Frints.Company_Id,
                                      i_Person_Id  => i_Person_Frints.Person_Id,
                                      i_Finger_No  => v_Fprint.Finger_No,
                                      i_Tmp        => v_Fprint.Tmp);
      
        if not Fazo.Equal(r_Fprint.Tmp, v_Fprint.Tmp) then
          v_Sync := true;
        end if;
      
        Fazo.Push(v_Finger_No, v_Fprint.Finger_No);
      end if;
    end loop;
  
    delete Hzk_Device_Fprints q
     where q.Company_Id = i_Person_Frints.Company_Id
       and q.Person_Id = i_Person_Frints.Person_Id
       and q.Finger_No not member of v_Finger_No;
  
    delete Hzk_Person_Fprints q
     where q.Company_Id = i_Person_Frints.Company_Id
       and q.Person_Id = i_Person_Frints.Person_Id
       and q.Finger_No not member of v_Finger_No
    returning q.Finger_No bulk collect into v_Array;
  
    if v_Sync or v_Array.Count > 0 then
      Hzk_External.Sync_Fingerprints(i_Company_Id => i_Person_Frints.Company_Id,
                                     i_Person_Id  => i_Person_Frints.Person_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Sync
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
  begin
    Hzk_External.Sync_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Sync(i_Person Htt_Global.Person_Rt) is
  begin
    for r in (select *
                from Mrf_Persons q
               where q.Company_Id = i_Person.Company_Id
                 and q.Person_Id = i_Person.Person_Id
                 and q.State = 'A')
    loop
      Hzk_External.Sync_Person(i_Company_Id => r.Company_Id, i_Person_Id => r.Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Sync
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Person_Id  number
  ) is
  begin
    Hzk_External.Sync_Person(i_Company_Id => i_Company_Id,
                             i_Device_Id  => i_Device_Id,
                             i_Person_Id  => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Person_Clear
  (
    i_Company_Id number,
    i_Pin        varchar2
  ) is
  begin
    delete Hzk_Migr_Persons t
     where t.Company_Id = i_Company_Id
       and t.Pin = i_Pin;
  
    delete Hzk_Migr_Fprints t
     where t.Company_Id = i_Company_Id
       and t.Pin = i_Pin;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Person_Save
  (
    i_Company_Id     number,
    i_Migr_Person_Id number,
    i_Person_Id      number,
    i_Pin            varchar2
  ) is
    r_Migr   Hzk_Migr_Persons%rowtype;
    r_Person Htt_Persons%rowtype;
    v_Person Htt_Pref.Person_Rt;
  begin
    r_Migr := z_Hzk_Migr_Persons.Load(i_Company_Id     => i_Company_Id,
                                      i_Migr_Person_Id => i_Migr_Person_Id);
  
    r_Person := z_Htt_Persons.Take(i_Company_Id => i_Company_Id, --
                                   i_Person_Id  => i_Person_Id);
  
    Htt_Util.Person_New(o_Person     => v_Person,
                        i_Company_Id => i_Company_Id,
                        i_Person_Id  => i_Person_Id,
                        i_Pin        => trim(i_Pin),
                        i_Pin_Code   => trim(r_Migr.Password),
                        i_Rfid_Code  => trim(r_Migr.Rfid_Code),
                        i_Qr_Code    => r_Person.Qr_Code);
  
    for r in (select q.Photo_Sha, q.Is_Main
                from Htt_Person_Photos q
               where q.Company_Id = i_Company_Id
                 and q.Person_Id = i_Person_Id)
    loop
      Htt_Util.Person_Add_Photo(p_Person    => v_Person,
                                i_Photo_Sha => r.Photo_Sha,
                                i_Is_Main   => r.Is_Main);
    end loop;
  
    Htt_Api.Person_Save(v_Person);
  
    for r in (select *
                from Hzk_Migr_Fprints t
               where t.Company_Id = i_Company_Id
                 and t.Pin = i_Pin)
    loop
      z_Hzk_Person_Fprints.Save_One(i_Company_Id => i_Company_Id,
                                    i_Person_Id  => i_Person_Id,
                                    i_Finger_No  => r.Finger_No,
                                    i_Tmp        => r.Tmp);
    end loop;
  
    Migr_Person_Clear(i_Company_Id => i_Company_Id, i_Pin => i_Pin);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Person_Delete
  (
    i_Company_Id number,
    i_Device_Id  number,
    i_Pin        varchar2
  ) is
  begin
    Hzk_External.Cmd_Delete_Person(i_Company_Id => i_Company_Id,
                                   i_Device_Id  => i_Device_Id,
                                   i_Pin        => i_Pin);
  
    Migr_Person_Clear(i_Company_Id => i_Company_Id, i_Pin => i_Pin);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Track_Delete
  (
    i_Company_Id    number,
    i_Migr_Track_Id number
  ) is
  begin
    z_Hzk_Migr_Tracks.Delete_One(i_Company_Id => i_Company_Id, i_Migr_Track_Id => i_Migr_Track_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Track_Save
  (
    i_Company_Id    number,
    i_Migr_Track_Id number
  ) is
    r_Migr       Hzk_Migr_Tracks%rowtype;
    r_Track      Htt_Tracks%rowtype;
    v_Filial_Ids Array_Number;
  begin
    r_Migr := z_Hzk_Migr_Tracks.Load(i_Company_Id    => i_Company_Id,
                                     i_Migr_Track_Id => i_Migr_Track_Id);
  
    z_Htt_Tracks.Init(p_Row         => r_Track,
                      i_Company_Id  => r_Migr.Company_Id,
                      i_Track_Id    => Htt_Next.Track_Id,
                      i_Track_Date  => r_Migr.Track_Date,
                      i_Track_Time  => r_Migr.Track_Time,
                      i_Track_Type  => r_Migr.Track_Type,
                      i_Mark_Type   => r_Migr.Mark_Type,
                      i_Device_Id   => r_Migr.Device_Id,
                      i_Location_Id => r_Migr.Location_Id);
  
    r_Track.Person_Id := Htt_Util.Person_Id(i_Company_Id => i_Company_Id, i_Pin => r_Migr.Pin);
  
    v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                            i_Location_Id => z_Htt_Devices.Load(i_Company_Id => r_Track.Company_Id, i_Device_Id => r_Track.Device_Id).Location_Id,
                                            i_Person_Id   => r_Track.Person_Id);
  
    if r_Track.Person_Id is null or v_Filial_Ids.Count = 0 then
      return;
    end if;
  
    for i in 1 .. v_Filial_Ids.Count
    loop
      r_Track.Filial_Id := v_Filial_Ids(i);
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  
    Migr_Track_Delete(i_Company_Id => i_Company_Id, i_Migr_Track_Id => i_Migr_Track_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval_Attlog_Error
  (
    i_Company_Id number,
    i_Error_Id   number
  ) is
    v_Row           Array_Varchar2;
    v_Filial_Ids    Array_Number;
    r_Error         Hzk_Attlog_Errors%rowtype;
    r_Track         Htt_Tracks%rowtype;
    r_Device        Htt_Devices%rowtype;
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
  begin
    r_Error := z_Hzk_Attlog_Errors.Lock_Load(i_Company_Id => i_Company_Id, i_Error_Id => i_Error_Id);
  
    if r_Error.Status = Hzk_Pref.c_Attlog_Error_Status_Done then
      Hzk_Error.Raise_004(i_Error_Id => i_Error_Id);
    end if;
  
    r_Error.Status := Hzk_Pref.c_Attlog_Error_Status_Done;
  
    r_Device := z_Htt_Devices.Load(i_Company_Id => r_Error.Company_Id,
                                   i_Device_Id  => r_Error.Device_Id);
  
    r_Track.Company_Id  := r_Error.Company_Id;
    r_Track.Device_Id   := r_Error.Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
    v_Timezone_Code     := Htt_Util.Load_Timezone(i_Company_Id  => r_Track.Company_Id,
                                                  i_Location_Id => r_Track.Location_Id);
  
    v_Row := Fazo.Split(r_Error.Command, Chr(9));
  
    r_Track.Person_Id := Htt_Util.Person_Id(i_Company_Id => r_Error.Company_Id, i_Pin => v_Row(1));
  
    if v_Row(3) = '0' then
      r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
    elsif v_Row(3) = '1' then
      r_Track.Track_Type := Htt_Pref.c_Track_Type_Output;
    else
      z_Hzk_Attlog_Errors.Update_Row(r_Error);
    
      return;
    end if;
  
    r_Track.Track_Time     := Htt_Util.Convert_Timestamp(i_Date     => to_date(v_Row(2),
                                                                               Href_Pref.c_Date_Format_Second),
                                                         i_Timezone => v_Timezone_Code);
    r_Track.Track_Datetime := Htt_Util.Timestamp_To_Date(i_Timestamp => r_Track.Track_Time,
                                                         i_Timezone  => Htt_Util.Load_Timezone(r_Track.Company_Id));
    r_Track.Track_Date     := Trunc(r_Track.Track_Datetime);
  
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
        Hzk_Error.Raise_005(i_Error_Id   => i_Error_Id,
                            i_Mark_Type  => v_Row(4),
                            i_Mark_Types => Array_Varchar2('0', '1', '2', '15'));
    end case;
  
    if r_Track.Person_Id is not null then
      v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                              i_Location_Id => r_Track.Location_Id,
                                              i_Person_Id   => r_Track.Person_Id);
      if v_Filial_Ids.Count = 0 then
        Hzk_Error.Raise_006(i_Error_Id      => i_Error_Id,
                            i_Person_Id     => r_Track.Person_Id,
                            i_Person_Name   => z_Mr_Natural_Persons.Load(i_Company_Id => r_Track.Company_Id, --
                                               i_Person_Id => r_Track.Person_Id).Name,
                            i_Location_Id   => r_Track.Location_Id,
                            i_Location_Name => z_Htt_Locations.Load(i_Company_Id => r_Track.Company_Id, --
                                               i_Location_Id => r_Track.Location_Id).Name);
      end if;
    
      for i in 1 .. v_Filial_Ids.Count
      loop
        r_Track.Filial_Id := v_Filial_Ids(i);
      
        if not Htt_Util.Exist_Track(i_Company_Id     => r_Track.Company_Id,
                                    i_Filial_Id      => v_Filial_Ids(i),
                                    i_Person_Id      => r_Track.Person_Id,
                                    i_Track_Type     => r_Track.Track_Type,
                                    i_Track_Datetime => r_Track.Track_Datetime,
                                    i_Device_Id      => r_Track.Device_Id) then
        
          r_Track.Track_Id := Htt_Next.Track_Id;
        
          Htt_Api.Track_Add(r_Track);
        end if;
      end loop;
    else
      z_Hzk_Migr_Tracks.Save_One(i_Company_Id    => r_Error.Company_Id,
                                 i_Migr_Track_Id => Hzk_Next.Migr_Track_Id,
                                 i_Pin           => v_Row(1),
                                 i_Device_Id     => r_Track.Device_Id,
                                 i_Location_Id   => r_Track.Location_Id,
                                 i_Track_Type    => r_Track.Track_Type,
                                 i_Track_Time    => r_Track.Track_Time,
                                 i_Track_Date    => r_Track.Track_Date,
                                 i_Mark_Type     => r_Track.Mark_Type);
    end if;
  
    z_Hzk_Attlog_Errors.Update_Row(r_Error);
  end;

end Hzk_Api;
/
