create or replace package Ui_Vhr353 is
  ---------------------------------------------------------------------------------------------------- 
  Function Logon_With_Qr_Code(p Arraylist) return Arraylist;
end Ui_Vhr353;
/
create or replace package body Ui_Vhr353 is
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
    return b.Translate('UI-VHR353:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Qr_Code
  (
    i_Unique_Key  varchar2,
    o_Company_Id  out nocopy number,
    o_Location_Id out nocopy number
  ) is
    v_Limit_Time number;
    v_Difference number;
    r_Qr_Code    Htt_Location_Qr_Codes%rowtype;
  begin
    begin
      select *
        into r_Qr_Code
        from Htt_Location_Qr_Codes q
       where q.Unique_Key = i_Unique_Key
         and q.State = 'A';
    
      v_Limit_Time := Hes_Util.Get_Qr_Code_Limit_Time(r_Qr_Code.Company_Id);
      v_Difference := (cast(Current_Timestamp as date) - cast(r_Qr_Code.Created_On as date)) *
                      86400;
    
      if v_Limit_Time * 60 < v_Difference then
        b.Raise_Error(t('this qr code expired, please new generate qr code'));
      end if;
    exception
      when No_Data_Found then
        b.Raise_Error(t('qr code not found, please new generate or scan correctly qr code'));
    end;
  
    o_Company_Id  := r_Qr_Code.Company_Id;
    o_Location_Id := r_Qr_Code.Location_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Device
  (
    i_Company_Id    number,
    i_Serial_Number varchar2,
    i_Location_Id   number,
    i_Device_Name   varchar2
  ) is
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad);
    r_Device         Htt_Devices%rowtype;
  begin
    Ui_Auth.Logon_As_System(i_Company_Id);
  
    select *
      into r_Device
      from Htt_Devices q
     where q.Company_Id = i_Company_Id
       and q.Device_Type_Id = v_Device_Type_Id
       and q.Serial_Number = i_Serial_Number;
  
    if r_Device.Location_Id <> i_Location_Id then
      Htt_Api.Device_Update(i_Company_Id  => r_Device.Company_Id,
                            i_Device_Id   => r_Device.Device_Id,
                            i_Location_Id => Option_Number(i_Location_Id));
    end if;
  exception
    when No_Data_Found then
      r_Device.Company_Id     := i_Company_Id;
      r_Device.Device_Id      := Htt_Next.Device_Id;
      r_Device.Name           := i_Device_Name;
      r_Device.Device_Type_Id := v_Device_Type_Id;
      r_Device.Serial_Number  := i_Serial_Number;
      r_Device.Location_Id    := i_Location_Id;
      r_Device.Use_Settings   := 'Y';
      r_Device.State          := 'A';
    
      Htt_Api.Device_Add(r_Device);
    
      Htt_Api.Unknown_Device_Add(i_Company_Id => r_Device.Company_Id,
                                 i_Device_Id  => r_Device.Device_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Logon_With_Qr_Code(p Arraylist) return Arraylist is
    v_Host_Id        number;
    v_Company_Id     number;
    v_Location_Id    number;
    v_Token          Kauth_Tokens.Token%type;
    v_Unique_Key     varchar2(100 char) := p.r_Varchar2(1);
    v_Device_Name    varchar2(50) := p.r_Varchar2(2);
    v_Device_Code    varchar2(50) := p.r_Varchar2(3);
    v_Device_Version varchar2(20) := p.r_Varchar2(4);
    v_Device_Sdk     varchar2(20) := p.r_Varchar2(5);
    v_Version_Code   number(5) := p.r_Number(6);
    v_Version_Name   varchar2(20) := p.r_Varchar2(7);
    v_Device_Kind    varchar2(1) := p.r_Varchar2(8);
  
    r_User Md_Users%rowtype;
    result Arraylist := Arraylist();
  begin
    Check_Qr_Code(i_Unique_Key  => v_Unique_Key,
                  o_Company_Id  => v_Company_Id,
                  o_Location_Id => v_Location_Id);
  
    Check_Device(i_Company_Id    => v_Company_Id,
                 i_Serial_Number => v_Device_Code,
                 i_Location_Id   => v_Location_Id,
                 i_Device_Name   => v_Device_Name);
  
    r_User := z_Md_Users.Load(i_Company_Id => v_Company_Id,
                              i_User_Id    => Hes_Util.Get_Timepad_User_Id(v_Company_Id));
  
    Mt_Api.Prepared_Device_Host(i_Company_Id     => r_User.Company_Id,
                                i_User_Id        => r_User.User_Id,
                                i_Device_Name    => v_Device_Name,
                                i_Device_Code    => v_Device_Code,
                                i_Device_Version => v_Device_Version,
                                i_Device_Sdk     => v_Device_Sdk,
                                i_Version_Code   => v_Version_Code,
                                i_Version_Name   => v_Version_Name,
                                i_Device_Kind    => v_Device_Kind,
                                i_Account_Code   => null,
                                i_Token          => v_Token,
                                o_Host_Id        => v_Host_Id);
  
    Result.Push(r_User.User_Id);
    Result.Push(r_User.Name);
    Result.Push(v_Token);
  
    return result;
  end;

end Ui_Vhr353;
/
