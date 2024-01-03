create or replace package Hisl_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Save(i_Setting Hisl_Settings%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Add
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Division_Code varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Remove
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure User_Add
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number,
    i_User_Code  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure User_Remove
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Log_Create(i_Log Hisl_Logs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Log_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Log_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Response
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Status        varchar2,
    i_Url           varchar2,
    i_Request_Body  varchar2,
    i_Response_Body varchar2,
    i_User_Id       number := null
  );
end Hisl_Api;
/
create or replace package body Hisl_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Save(i_Setting Hisl_Settings%rowtype) is
    r_Setting Hisl_Settings%rowtype;
  begin
    if not z_Hisl_Settings.Exist_Lock(i_Company_Id => i_Setting.Company_Id,
                                      i_Filial_Id  => i_Setting.Filial_Id,
                                      o_Row        => r_Setting) then
      r_Setting.Company_Id := i_Setting.Company_Id;
      r_Setting.Filial_Id  := i_Setting.Filial_Id;
    end if;
  
    r_Setting.Integration_Enabled := i_Setting.Integration_Enabled;
  
    if r_Setting.Integration_Enabled = 'Y' then
      r_Setting.Api_Host      := i_Setting.Api_Host;
      r_Setting.Auth_Url      := i_Setting.Auth_Url;
      r_Setting.Auth_Email    := i_Setting.Auth_Email;
      r_Setting.Auth_Password := i_Setting.Auth_Password;
    else
      r_Setting.Api_Host      := null;
      r_Setting.Auth_Url      := null;
      r_Setting.Auth_Email    := null;
      r_Setting.Auth_Password := null;
    end if;
  
    z_Hisl_Settings.Save_Row(r_Setting);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    z_Hisl_Settings.Delete_One(i_Company_Id => i_Company_Id, --
                               i_Filial_Id  => i_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Add
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Division_Code varchar2
  ) is
  begin
    z_Hisl_Divisions.Insert_One(i_Company_Id    => i_Company_Id,
                                i_Filial_Id     => i_Filial_Id,
                                i_Division_Id   => i_Division_Id,
                                i_Division_Code => i_Division_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Remove
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) is
  begin
    z_Hisl_Divisions.Delete_One(i_Company_Id  => i_Company_Id,
                                i_Filial_Id   => i_Filial_Id,
                                i_Division_Id => i_Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure User_Add
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number,
    i_User_Code  varchar2
  ) is
  begin
    z_Hisl_Users.Insert_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_User_Id    => i_User_Id,
                            i_User_Code  => i_User_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure User_Remove
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number
  ) is
  begin
    z_Hisl_Users.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_User_Id    => i_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Log_Create(i_Log Hisl_Logs%rowtype) is
  begin
    z_Hisl_Logs.Insert_Row(i_Log);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Log_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Log_Id     number
  ) is
  begin
    z_Hisl_Logs.Delete_One(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Log_Id     => i_Log_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Response
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Status        varchar2,
    i_Url           varchar2,
    i_Request_Body  varchar2,
    i_Response_Body varchar2,
    i_User_Id       number := null
  ) is
    r_Log Hisl_Logs%rowtype;
  begin
    z_Hisl_Logs.Init(p_Row           => r_Log,
                     i_Company_Id    => i_Company_Id,
                     i_Filial_Id     => i_Filial_Id,
                     i_Log_Id        => Hisl_Next.Log_Id,
                     i_Status        => i_Status,
                     i_Url           => i_Url,
                     i_Request_Body  => i_Request_Body,
                     i_Response_Body => i_Response_Body);
  
    Log_Create(r_Log);
  
    if i_Status = Hisl_Pref.c_Request_Status_Success and i_User_Id is not null then
      User_Add(i_Company_Id => i_Company_Id,
               i_Filial_Id  => i_Filial_Id,
               i_User_Id    => i_User_Id,
               i_User_Code  => Regexp_Substr(i_Response_Body,
                                             '.*<response>(.*)</response>.*',
                                             1,
                                             1,
                                             null,
                                             1));
    end if;
  end;

end Hisl_Api;
/
