create or replace package Hac_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_Person_Id     number,
    i_Person_Code   varchar2,
    i_External_Code varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Attach
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Detach
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Save(i_Server Hac_Pref.Dss_Server_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Delete(i_Server_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Attach
  (
    i_Company_Id number,
    i_Server_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Detach(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Company_Server_Update
  (
    i_Company_Id        number,
    i_Department_Code   Option_Varchar2 := null,
    i_Person_Group_Code Option_Varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Device_Save(i_Device Hac_Pref.Dss_Device_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Device_Delete
  (
    i_Server_Id number,
    i_Device_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Device_Update
  (
    i_Server_Id         number,
    i_Device_Id         number,
    i_Device_Ip         Option_Varchar2 := null,
    i_Ready             Option_Varchar2 := null,
    i_Status            Option_Varchar2 := null,
    i_Serial_Number     Option_Varchar2 := null,
    i_Device_Code       Option_Varchar2 := null,
    i_Access_Group_Code Option_Varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Save(i_Server Hac_Pref.Hik_Server_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Delete(i_Server_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Attach
  (
    i_Company_Id number,
    i_Server_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Detach(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Company_Server_Update
  (
    i_Company_Id        number,
    i_Organization_Code Option_Varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Device_Save(i_Device Hac_Pref.Hik_Device_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Device_Delete
  (
    i_Server_Id number,
    i_Device_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Device_Update
  (
    i_Server_Id         number,
    i_Device_Id         number,
    i_Serial_Number     Option_Varchar2 := null,
    i_Device_Code       Option_Varchar2 := null,
    i_Door_Code         Option_Varchar2 := null,
    i_Access_Level_Code Option_Varchar2 := null
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Hik_Device_Sync
  (
    i_Server_Id number,
    i_Device_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Listening_Device_Save(i_Device Hac_Hik_Listening_Devices%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Listening_Device_Delete(i_Device_Token varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Force_Sync_Person
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Ex_Access_Level_Save
  (
    i_Server_Id         number,
    i_Access_Level_Code varchar2,
    i_Access_Level_Name varchar2,
    i_Description       varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Ex_Door_List_Save
  (
    i_Server_Id   number,
    i_Door_Code   varchar2,
    i_Door_Name   varchar2,
    i_Door_No     varchar2,
    i_Device_Code varchar2,
    i_Region_Code varchar2,
    i_Door_State  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Ex_Device_List_Save
  (
    i_Server_Id     number,
    i_Device_Code   varchar2,
    i_Device_Name   varchar2,
    i_Device_Ip     varchar2,
    i_Device_Port   varchar2,
    i_Treaty_Type   varchar2,
    i_Serial_Number varchar2,
    i_Status        varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Ex_Devices_Save
  (
    i_Server_Id       number,
    i_Device_Code     varchar2,
    i_Department_Code varchar2,
    i_Device_Name     varchar2,
    i_Device_Ip       varchar2,
    i_Status          varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Ex_Access_Groups_Save
  (
    i_Server_Id         number,
    i_Access_Group_Code varchar2,
    i_Access_Group_Name varchar2,
    i_Person_Count      varchar2,
    i_Extra_Info        varchar2
  );
end Hac_Api;
/
create or replace package body Hac_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Server_Id     number,
    i_Company_Id    number,
    i_Person_Id     number,
    i_Person_Code   varchar2,
    i_External_Code varchar2 := null
  ) is
    r_Person     Mr_Natural_Persons%rowtype := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id,
                                                                         i_Person_Id  => i_Person_Id);
    r_Htt_Person Htt_Persons%rowtype := z_Htt_Persons.Take(i_Company_Id => i_Company_Id,
                                                           i_Person_Id  => i_Person_Id);
  begin
    z_Hac_Server_Persons.Save_One(i_Server_Id     => i_Server_Id,
                                  i_Company_Id    => i_Company_Id,
                                  i_Person_Id     => i_Person_Id,
                                  i_Person_Code   => i_Person_Code,
                                  i_First_Name    => r_Person.First_Name,
                                  i_Last_Name     => r_Person.Last_Name,
                                  i_Photo_Sha     => Hac_Util.Take_Main_Photo(i_Company_Id => i_Company_Id,
                                                                              i_Person_Id  => i_Person_Id),
                                  i_Rfid_Code     => r_Htt_Person.Rfid_Code,
                                  i_External_Code => i_External_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Attach
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
  begin
    Hac_Core.Device_Attach(i_Company_Id  => i_Company_Id,
                           i_Device_Id   => i_Device_Id,
                           i_Attach_Kind => Hac_Pref.c_Device_Attach_Secondary);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Detach
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
    r_Device Hac_Company_Devices%rowtype;
  begin
    r_Device := z_Hac_Company_Devices.Lock_Load(i_Company_Id => i_Company_Id,
                                                i_Device_Id  => i_Device_Id);
  
    if r_Device.Attach_Kind = Hac_Pref.c_Device_Attach_Primary then
      Hac_Error.Raise_003;
    end if;
  
    Hac_Core.Device_Detach(i_Company_Id => i_Company_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Save(i_Server Hac_Pref.Dss_Server_Rt) is
  begin
    Hac_Core.Acms_Server_Save(i_Server.Acms);
  
    z_Hac_Dss_Servers.Save_One(i_Server_Id => i_Server.Acms.Server_Id,
                               i_Username  => i_Server.Username,
                               i_Password  => i_Server.Password);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Delete(i_Server_Id number) is
  begin
    Hac_Core.Acms_Server_Delete(i_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Attach
  (
    i_Company_Id number,
    i_Server_Id  number
  ) is
  begin
    z_Hac_Dss_Company_Servers.Insert_One(i_Company_Id => i_Company_Id, i_Server_Id => i_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Server_Detach(i_Company_Id number) is
  begin
    z_Hac_Dss_Company_Servers.Delete_One(i_Company_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Company_Server_Update
  (
    i_Company_Id        number,
    i_Department_Code   Option_Varchar2 := null,
    i_Person_Group_Code Option_Varchar2 := null
  ) is
    v_Department_Code   Option_Varchar2 := i_Department_Code;
    v_Person_Group_Code Option_Varchar2 := i_Person_Group_Code;
    r_Company           Hac_Dss_Company_Servers%rowtype;
  begin
    if z_Hac_Dss_Company_Servers.Exist_Lock(i_Company_Id => i_Company_Id, o_Row => r_Company) then
      if r_Company.Department_Code is not null then
        v_Department_Code := null;
      end if;
      if r_Company.Person_Group_Code is not null then
        v_Person_Group_Code := null;
      end if;
    end if;
  
    z_Hac_Dss_Company_Servers.Update_One(i_Company_Id        => i_Company_Id,
                                         i_Department_Code   => v_Department_Code,
                                         i_Person_Group_Code => v_Person_Group_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Device_Save(i_Device Hac_Pref.Dss_Device_Rt) is
    r_Device Hac_Devices%rowtype := i_Device.Acms;
  begin
    r_Device.Device_Type_Id := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Dahua);
    r_Device.Device_Name    := z_Md_Companies.Load(i_Device.Company_Id).Code || r_Device.Location;
  
    Hac_Core.Acms_Device_Save(i_Company_Id => i_Device.Company_Id, i_Device => r_Device);
  
    if not z_Hac_Dss_Devices.Exist_Lock(i_Server_Id => r_Device.Server_Id,
                                        i_Device_Id => r_Device.Device_Id) then
      z_Hac_Dss_Devices.Insert_One(i_Server_Id => r_Device.Server_Id,
                                   i_Device_Id => r_Device.Device_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Device_Delete
  (
    i_Server_Id number,
    i_Device_Id number
  ) is
  begin
    Hac_Core.Acms_Device_Delete(i_Server_Id => i_Server_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Device_Update
  (
    i_Server_Id         number,
    i_Device_Id         number,
    i_Device_Ip         Option_Varchar2 := null,
    i_Ready             Option_Varchar2 := null,
    i_Status            Option_Varchar2 := null,
    i_Serial_Number     Option_Varchar2 := null,
    i_Device_Code       Option_Varchar2 := null,
    i_Access_Group_Code Option_Varchar2 := null
  ) is
  begin
    z_Hac_Dss_Devices.Update_One(i_Server_Id         => i_Server_Id,
                                 i_Device_Id         => i_Device_Id,
                                 i_Serial_Number     => i_Serial_Number,
                                 i_Device_Code       => i_Device_Code,
                                 i_Access_Group_Code => i_Access_Group_Code);
  
    Hac_Core.Acms_Device_Update(i_Server_Id => i_Server_Id,
                                i_Device_Id => i_Device_Id,
                                i_Device_Ip => i_Device_Ip,
                                i_Ready     => i_Ready,
                                i_Status    => i_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Save(i_Server Hac_Pref.Hik_Server_Rt) is
  begin
    Hac_Core.Acms_Server_Save(i_Server.Acms);
  
    z_Hac_Hik_Servers.Save_One(i_Server_Id      => i_Server.Acms.Server_Id,
                               i_Partner_Key    => i_Server.Partner_Key,
                               i_Partner_Secret => i_Server.Partner_Secret,
                               i_Token          => i_Server.Token);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Delete(i_Server_Id number) is
  begin
    Hac_Core.Acms_Server_Delete(i_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Attach
  (
    i_Company_Id number,
    i_Server_Id  number
  ) is
  begin
    z_Hac_Hik_Company_Servers.Insert_One(i_Company_Id => i_Company_Id, i_Server_Id => i_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Server_Detach(i_Company_Id number) is
  begin
    z_Hac_Hik_Company_Servers.Delete_One(i_Company_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Company_Server_Update
  (
    i_Company_Id        number,
    i_Organization_Code Option_Varchar2 := null
  ) is
    v_Organization_Code Option_Varchar2 := i_Organization_Code;
    r_Company           Hac_Hik_Company_Servers%rowtype;
  begin
    if z_Hac_Hik_Company_Servers.Exist_Lock(i_Company_Id => i_Company_Id, o_Row => r_Company) then
      if r_Company.Organization_Code is not null then
        v_Organization_Code := null;
      end if;
    end if;
  
    z_Hac_Hik_Company_Servers.Update_One(i_Company_Id        => i_Company_Id,
                                         i_Organization_Code => v_Organization_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Device_Save(i_Device Hac_Pref.Hik_Device_Rt) is
    r_Device Hac_Devices%rowtype := i_Device.Acms;
  begin
    r_Device.Device_Type_Id := Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision);
    r_Device.Device_Name    := z_Md_Companies.Load(i_Device.Company_Id).Code || r_Device.Location;
  
    Hac_Core.Acms_Device_Save(i_Company_Id  => i_Device.Company_Id,
                              i_Device      => r_Device,
                              i_Event_Types => i_Device.Event_Types);
  
    if z_Hac_Hik_Devices.Exist_Lock(i_Server_Id => r_Device.Server_Id,
                                    i_Device_Id => r_Device.Device_Id) then
      z_Hac_Hik_Devices.Update_One(i_Server_Id     => r_Device.Server_Id,
                                   i_Device_Id     => r_Device.Device_Id,
                                   i_Isup_Password => Option_Varchar2(i_Device.Isup_Password),
                                   i_Ignore_Tracks => Option_Varchar2(i_Device.Ignore_Tracks));
    else
      z_Hac_Hik_Devices.Insert_One(i_Server_Id     => r_Device.Server_Id,
                                   i_Device_Id     => r_Device.Device_Id,
                                   i_Isup_Password => i_Device.Isup_Password,
                                   i_Ignore_Tracks => i_Device.Ignore_Tracks);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Device_Delete
  (
    i_Server_Id number,
    i_Device_Id number
  ) is
  begin
    Hac_Core.Acms_Device_Delete(i_Server_Id => i_Server_Id, i_Device_Id => i_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Device_Update
  (
    i_Server_Id         number,
    i_Device_Id         number,
    i_Serial_Number     Option_Varchar2 := null,
    i_Device_Code       Option_Varchar2 := null,
    i_Door_Code         Option_Varchar2 := null,
    i_Access_Level_Code Option_Varchar2 := null
  ) is
  begin
    z_Hac_Hik_Devices.Update_One(i_Server_Id         => i_Server_Id,
                                 i_Device_Id         => i_Device_Id,
                                 i_Serial_Number     => i_Serial_Number,
                                 i_Device_Code       => i_Device_Code,
                                 i_Door_Code         => i_Door_Code,
                                 i_Access_Level_Code => i_Access_Level_Code);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Hik_Device_Sync
  (
    i_Server_Id number,
    i_Device_Id number
  ) is
    r_Hac_Device Hac_Devices%rowtype;
    r_Hik_Device Hac_Hik_Devices%rowtype;
    r_Ex_Device  Hac_Hik_Ex_Devices%rowtype;
  begin
    r_Hac_Device := z_Hac_Devices.Load(i_Server_Id => i_Server_Id, i_Device_Id => i_Device_Id);
    r_Hik_Device := z_Hac_Hik_Devices.Load(i_Server_Id => i_Server_Id, i_Device_Id => i_Device_Id);
    r_Ex_Device  := Hac_Util.Get_Hik_Device_By_Name(i_Server_Id   => i_Server_Id,
                                                    i_Device_Name => r_Hac_Device.Device_Name);
  
    r_Hac_Device.Status            := Hac_Util.Map_Hik_Device_Status(Nvl(r_Ex_Device.Status,
                                                                         Hac_Pref.c_Hik_Device_Status_Unknown));
    r_Hik_Device.Device_Code       := r_Ex_Device.Device_Code;
    r_Hik_Device.Door_Code         := Hac_Util.Get_Hik_Door_Code_By_Device_Code(i_Server_Id   => i_Server_Id,
                                                                                i_Device_Code => r_Ex_Device.Device_Code);
    r_Hik_Device.Access_Level_Code := Hac_Util.Get_Hik_Access_Level_Code_By_Name(i_Server_Id         => i_Server_Id,
                                                                                 i_Access_Level_Name => r_Hac_Device.Device_Name);
    r_Hik_Device.Serial_Number     := r_Ex_Device.Serial_Number;
  
    if r_Hik_Device.Device_Code is not null and r_Hik_Device.Door_Code is not null and
       r_Hik_Device.Access_Level_Code is not null and r_Hik_Device.Serial_Number is not null then
      r_Hac_Device.Ready := 'Y';
    else
      r_Hac_Device.Ready := 'N';
    end if;
  
    z_Hac_Devices.Save_Row(r_Hac_Device);
    z_Hac_Hik_Devices.Save_Row(r_Hik_Device);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Listening_Device_Save(i_Device Hac_Hik_Listening_Devices%rowtype) is
    r_Device Hac_Hik_Listening_Devices%rowtype := i_Device;
    r_Old    Hac_Hik_Listening_Devices%rowtype;
  begin
    if z_Hac_Hik_Listening_Devices.Exist_Lock(i_Device.Device_Token, o_Row => r_Old) then
      r_Device.Person_Auth_Type := r_Old.Person_Auth_Type;
      r_Device.Serial_Number    := r_Old.Serial_Number;
    end if;
  
    z_Hac_Hik_Listening_Devices.Save_Row(r_Device);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Listening_Device_Delete(i_Device_Token varchar2) is
  begin
    z_Hac_Hik_Listening_Devices.Delete_One(i_Device_Token);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Force_Sync_Person
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
    r_Dss_Company Hac_Dss_Company_Servers%rowtype := z_Hac_Dss_Company_Servers.Take(i_Company_Id);
    r_Hik_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Take(i_Company_Id);
  begin
    -- update to null allows force update of persons
    -- without it person is updated only when hac_server_persons differs from actual values
    if r_Dss_Company.Server_Id is not null and
       z_Hac_Server_Persons.Exist(i_Server_Id  => r_Dss_Company.Server_Id,
                                  i_Company_Id => i_Company_Id,
                                  i_Person_Id  => i_Person_Id) then
      z_Hac_Server_Persons.Update_One(i_Server_Id  => r_Dss_Company.Server_Id,
                                      i_Company_Id => i_Company_Id,
                                      i_Person_Id  => i_Person_Id,
                                      i_First_Name => Option_Varchar2(null),
                                      i_Last_Name  => Option_Varchar2(null),
                                      i_Photo_Sha  => Option_Varchar2(null),
                                      i_Rfid_Code  => Option_Varchar2(null));
    
      delete Hac_Device_Persons q
       where q.Company_Id = i_Company_Id
         and q.Person_Id = i_Person_Id
         and q.Server_Id = r_Dss_Company.Server_Id;
    end if;
  
    if r_Hik_Company.Server_Id is not null and
       z_Hac_Server_Persons.Exist(i_Server_Id  => r_Hik_Company.Server_Id,
                                  i_Company_Id => i_Company_Id,
                                  i_Person_Id  => i_Person_Id) then
      z_Hac_Server_Persons.Update_One(i_Server_Id  => r_Hik_Company.Server_Id,
                                      i_Company_Id => i_Company_Id,
                                      i_Person_Id  => i_Person_Id,
                                      i_First_Name => Option_Varchar2(null),
                                      i_Last_Name  => Option_Varchar2(null),
                                      i_Photo_Sha  => Option_Varchar2(null),
                                      i_Rfid_Code  => Option_Varchar2(null));
    
      delete Hac_Device_Persons q
       where q.Company_Id = i_Company_Id
         and q.Person_Id = i_Person_Id
         and q.Server_Id = r_Hik_Company.Server_Id;
    end if;
  
    if r_Dss_Company.Server_Id is not null or r_Hik_Company.Server_Id is not null then
      Hac_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device
  (
    i_Company_Id number,
    i_Device_Id  number
  ) is
    r_Device      Htt_Devices%rowtype := z_Htt_Devices.Load(i_Company_Id => i_Company_Id,
                                                            i_Device_Id  => i_Device_Id);
    r_Dss_Device  Hac_Dss_Devices%rowtype := Hac_Util.Take_Dss_Device_By_Serial_Number(r_Device.Serial_Number);
    r_Hik_Device  Hac_Hik_Devices%rowtype := Hac_Util.Take_Hik_Device_By_Serial_Number(r_Device.Serial_Number);
    r_Dss_Company Hac_Dss_Company_Servers%rowtype := z_Hac_Dss_Company_Servers.Take(i_Company_Id);
    r_Hik_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Take(i_Company_Id);
  begin
    -- implicitly syncronised person across all bound devices
    for r in (select Lp.Person_Id
                from Htt_Location_Persons Lp
               where Lp.Company_Id = i_Company_Id
                 and Lp.Location_Id = r_Device.Location_Id
                 and not exists (select *
                        from Htt_Blocked_Person_Tracking w
                       where w.Company_Id = Lp.Company_Id
                         and w.Filial_Id = Lp.Filial_Id
                         and w.Employee_Id = Lp.Person_Id)
              union
              select Dp.Person_Id
                from Hac_Device_Persons Dp
               where Dp.Server_Id = r_Dss_Company.Server_Id
                 and Dp.Company_Id = i_Company_Id
                 and Dp.Device_Id = r_Dss_Device.Device_Id
              union
              select Hp.Person_Id
                from Hac_Device_Persons Hp
               where Hp.Server_Id = r_Hik_Company.Server_Id
                 and Hp.Company_Id = i_Company_Id
                 and Hp.Device_Id = r_Hik_Device.Device_Id)
    loop
      Hac_Core.Make_Dirty_Person(i_Company_Id => i_Company_Id, i_Person_Id => r.Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Ex_Access_Level_Save
  (
    i_Server_Id         number,
    i_Access_Level_Code varchar2,
    i_Access_Level_Name varchar2,
    i_Description       varchar2
  ) is
  begin
    delete Hac_Hik_Ex_Access_Levels q
     where q.Server_Id = i_Server_Id
       and q.Access_Level_Name = i_Access_Level_Name;
  
    z_Hac_Hik_Ex_Access_Levels.Save_One(i_Server_Id         => i_Server_Id,
                                        i_Access_Level_Code => i_Access_Level_Code,
                                        i_Access_Level_Name => i_Access_Level_Name,
                                        i_Description       => i_Description);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Ex_Door_List_Save
  (
    i_Server_Id   number,
    i_Door_Code   varchar2,
    i_Door_Name   varchar2,
    i_Door_No     varchar2,
    i_Device_Code varchar2,
    i_Region_Code varchar2,
    i_Door_State  varchar2
  ) is
  begin
    delete Hac_Hik_Ex_Doors q
     where q.Server_Id = i_Server_Id
       and q.Device_Code = i_Device_Code;
  
    z_Hac_Hik_Ex_Doors.Save_One(i_Server_Id   => i_Server_Id,
                                i_Door_Code   => i_Door_Code,
                                i_Door_Name   => i_Door_Name,
                                i_Door_No     => i_Door_No,
                                i_Device_Code => i_Device_Code,
                                i_Region_Code => i_Region_Code,
                                i_Door_State  => i_Door_State);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hik_Ex_Device_List_Save
  (
    i_Server_Id     number,
    i_Device_Code   varchar2,
    i_Device_Name   varchar2,
    i_Device_Ip     varchar2,
    i_Device_Port   varchar2,
    i_Treaty_Type   varchar2,
    i_Serial_Number varchar2,
    i_Status        varchar2
  ) is
  begin
    delete Hac_Hik_Ex_Devices q
     where q.Server_Id = i_Server_Id
       and q.Device_Name = i_Device_Name;
  
    z_Hac_Hik_Ex_Devices.Save_One(i_Server_Id     => i_Server_Id,
                                  i_Device_Code   => i_Device_Code,
                                  i_Device_Name   => i_Device_Name,
                                  i_Device_Ip     => i_Device_Ip,
                                  i_Device_Port   => i_Device_Port,
                                  i_Treaty_Type   => i_Treaty_Type,
                                  i_Serial_Number => i_Serial_Number,
                                  i_Status        => i_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Ex_Devices_Save
  (
    i_Server_Id       number,
    i_Device_Code     varchar2,
    i_Department_Code varchar2,
    i_Device_Name     varchar2,
    i_Device_Ip       varchar2,
    i_Status          varchar2
  ) is
  begin
    if z_Hac_Dss_Ex_Devices.Exist_Lock(i_Server_Id => i_Server_Id, i_Device_Code => i_Device_Code) then
      z_Hac_Dss_Ex_Devices.Update_One(i_Server_Id       => i_Server_Id,
                                      i_Device_Code     => i_Device_Code,
                                      i_Department_Code => Option_Varchar2(i_Department_Code),
                                      i_Device_Name     => Option_Varchar2(i_Device_Name),
                                      i_Device_Ip       => Option_Varchar2(i_Device_Ip),
                                      i_Status          => Option_Varchar2(i_Status));
    else
      z_Hac_Dss_Ex_Devices.Insert_One(i_Server_Id       => i_Server_Id,
                                      i_Device_Code     => i_Device_Code,
                                      i_Department_Code => i_Department_Code,
                                      i_Device_Name     => i_Device_Name,
                                      i_Device_Ip       => i_Device_Ip,
                                      i_Status          => i_Status);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dss_Ex_Access_Groups_Save
  (
    i_Server_Id         number,
    i_Access_Group_Code varchar2,
    i_Access_Group_Name varchar2,
    i_Person_Count      varchar2,
    i_Extra_Info        varchar2
  ) is
  begin
    delete Hac_Dss_Ex_Access_Groups q
     where q.Server_Id = i_Server_Id
       and q.Access_Group_Name = i_Access_Group_Name;
  
    z_Hac_Dss_Ex_Access_Groups.Save_One(i_Server_Id         => i_Server_Id,
                                        i_Access_Group_Code => i_Access_Group_Code,
                                        i_Access_Group_Name => i_Access_Group_Name,
                                        i_Person_Count      => i_Person_Count,
                                        i_Extra_Info        => i_Extra_Info);
  end;

end Hac_Api;
/
