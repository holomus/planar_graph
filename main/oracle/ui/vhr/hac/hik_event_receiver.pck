create or replace package Ui_Vhr535 is
  ---------------------------------------------------------------------------------------------------- 
  Procedure Receive_Event(i_Val Array_Varchar2);
end Ui_Vhr535;
/
create or replace package body Ui_Vhr535 is
  ---------------------------------------------------------------------------------------------------- 
  Procedure Receive_Event(i_Val Array_Varchar2) is
    v_Data        Gmap;
    v_Events      Glist;
    v_Params      Gmap;
    v_Event_Data  Gmap;
    v_Person_Data Gmap;
    ---------- 
    v_Door_Code       varchar2(1000 char);
    v_Happen_Time     varchar2(100 char);
    v_Person_Code     varchar2(1000 char);
    v_Event_Type_Code number;
    v_Hik_Track_Type  number;
    ---------- 
    v_Token      varchar2(1024 char);
    v_Server_Id  number;
    p_Error_Data Hashmap;
  
    -------------------------------------------------- 
    Function Get_Server_Id(i_Token varchar2) return number is
      result number;
    begin
      select k.Server_Id
        into result
        from Hac_Hik_Servers k
       where k.Token = i_Token;
    
      return result;
    exception
      when No_Data_Found then
        b.Raise_Error('Unknown token $1', i_Token);
    end;
  begin
    v_Token     := b_Session.Request_Header('token');
    v_Server_Id := Get_Server_Id(v_Token);
  
    if v_Server_Id is not null then
      v_Data        := Gmap(Json_Object_t(Fazo.Make_Clob(i_Val)));
      v_Params      := v_Data.r_Gmap('params');
      v_Events      := v_Params.r_Glist('events');
      v_Event_Data  := Gmap(Json_Object_t(v_Events.Val.Get(0)));
      v_Person_Data := v_Event_Data.r_Gmap('data');
      ---------- 
      v_Person_Code     := v_Person_Data.r_Varchar2('personId');
      v_Happen_Time     := v_Event_Data.r_Varchar2('happenTime');
      v_Door_Code       := v_Event_Data.r_Varchar2('srcIndex');
      v_Event_Type_Code := v_Event_Data.r_Number('eventType');
    
      v_Hik_Track_Type := v_Person_Data.r_Number('checkInAndOutType');
    
      Hac_Core.Save_Hik_Ex_Event(i_Server_Id             => v_Server_Id,
                                 i_Door_Code             => v_Door_Code,
                                 i_Person_Code           => v_Person_Code,
                                 i_Event_Time            => v_Happen_Time,
                                 i_Event_Type            => Hac_Pref.c_Hik_Event_Type_From_Notifications,
                                 i_Event_Code            => v_Event_Data.r_Varchar2('eventId'),
                                 i_Check_In_And_Out_Type => v_Hik_Track_Type,
                                 i_Event_Type_Code       => v_Event_Type_Code,
                                 i_Door_Name             => v_Event_Data.o_Varchar2('srcName'),
                                 i_Src_Type              => v_Event_Data.o_Varchar2('srcType'),
                                 i_Status                => v_Event_Data.o_Number('status'),
                                 i_Card_No               => v_Person_Data.o_Varchar2('cardNo'),
                                 i_Pic_Uri               => v_Person_Data.o_Varchar2('picUri'),
                                 i_Pic_Sha               => null,
                                 i_Reader_Code           => v_Person_Data.o_Varchar2('readerIndexCode'),
                                 i_Reader_Name           => v_Person_Data.o_Varchar2('readerName'),
                                 i_Extra_Info            => v_Event_Data.Json);
    
      if not Hac_Util.Is_Good_Event_Type(i_Device_Type_Id  => Hac_Util.Device_Type_Id(Hac_Pref.c_Pcode_Device_Type_Hikvision),
                                         i_Event_Type_Code => v_Event_Type_Code) then
        return;
      end if;
    
      Hac_Core.Save_Hik_Track(i_Server_Id   => v_Server_Id,
                              i_Person_Code => v_Person_Code,
                              i_Photo_Sha   => null,
                              i_Track_Time  => v_Happen_Time,
                              i_Door_Code   => v_Door_Code,
                              i_Track_Type  => v_Hik_Track_Type);
    end if;
  exception
    when others then
      p_Error_Data := Fazo.Zip_Map('source',
                                   'hikvision',
                                   'person_code',
                                   v_Person_Code,
                                   'door_code',
                                   v_Door_Code,
                                   'track_time',
                                   v_Happen_Time);
    
      Hac_Core.Save_Error_Log(i_Request_Params => p_Error_Data.Json,
                              i_Error_Message  => Dbms_Utility.Format_Error_Stack() || Chr(13) ||
                                                  Chr(10) || Dbms_Utility.Format_Error_Backtrace);
  end;

end Ui_Vhr535;
/
