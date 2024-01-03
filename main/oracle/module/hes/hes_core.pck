create or replace package Hes_Core is
  ---------------------------------------------------------------------------------------------------- 
  Procedure Sale_Dates_Lock
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date_Begin date,
    i_Date_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Provider_Info
  (
    i_Session_Val  varchar2,
    i_Redirect_Uri varchar2,
    i_State        varchar2,
    o_Data         out varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Access_Token
  (
    i_Company_Id    number,
    i_User_Id       number,
    i_Provider_Id   number,
    i_Access_Token  varchar2,
    i_Refresh_Token varchar2,
    i_Expires_In    number
  );
end Hes_Core;
/
create or replace package body Hes_Core is
  ---------------------------------------------------------------------------------------------------- 
  -- insert is made autonomously so that the row is visible globally
  ---------------------------------------------------------------------------------------------------- 
  Procedure Sale_Date_Insert
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sale_Date  date
  ) is
    pragma autonomous_transaction;
  begin
    insert into Hes_Billz_Sale_Dates
      (Company_Id, Filial_Id, Sale_Date)
    values
      (i_Company_Id, i_Filial_Id, i_Sale_Date);
  
    commit;
  exception
    when Dup_Val_On_Index then
      null;
    when others then
      b.Raise_Fatal('HES: error inserting sale date $1', i_Sale_Date);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Sale_Date_Lock
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Sale_Date  date
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hes_Billz_Sale_Dates t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Sale_Date = i_Sale_Date
       for update;
  exception
    when No_Data_Found then
      Sale_Date_Insert(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Sale_Date  => i_Sale_Date);
    
      if not z_Hes_Billz_Sale_Dates.Exist_Lock(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Sale_Date  => i_Sale_Date) then
        b.Raise_Fatal('HES: cannot lock sale date, sale_date=$1', i_Sale_Date);
      end if;
  end;

  ----------------------------------------------------------------------------------------------------
  -- locks sale dates included in the request to Billz
  ---------------------------------------------------------------------------------------------------- 
  Procedure Sale_Dates_Lock
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date_Begin date,
    i_Date_End   date
  ) is
    v_Iterator_Date date := i_Date_Begin;
  begin
    while v_Iterator_Date <= i_Date_End
    loop
      Sale_Date_Lock(i_Company_Id => i_Company_Id,
                     i_Filial_Id  => i_Filial_Id,
                     i_Sale_Date  => v_Iterator_Date);
    
      v_Iterator_Date := v_Iterator_Date + 1;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Provider_Info
  (
    i_Session_Val  varchar2,
    i_Redirect_Uri varchar2,
    i_State        varchar2,
    o_Data         out varchar2
  ) is
    r_Session     Hes_Oauth2_Session_States%rowtype;
    r_Provider    Hes_Oauth2_Providers%rowtype;
    r_Credentials Hes_Oauth2_Credentials%rowtype;
    v_Data        Hashmap;
    v_Company_Id  number;
    v_User_Id     number;
    v_Session_Id  number;
  
    v_Credentials_Company_Id number;
  
    --------------------------------------------------
    Function Get_Session(i_State_Token varchar2) return Hes_Oauth2_Session_States%rowtype is
      result Hes_Oauth2_Session_States%rowtype;
    begin
      select q.*
        into result
        from Hes_Oauth2_Session_States q
       where q.State_Token = i_State_Token;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  
    --------------------------------------------------
    Function Get_Provider(i_Redirect_Uri varchar2) return Hes_Oauth2_Providers%rowtype is
      result Hes_Oauth2_Providers%rowtype;
    begin
      select q.*
        into result
        from Hes_Oauth2_Providers q
       where q.Redirect_Uri = i_Redirect_Uri;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  
  begin
    Kauth_Util.Split_Session_Val(i_Session_Val => i_Session_Val,
                                 o_Company_Id  => v_Company_Id,
                                 o_Session_Id  => v_Session_Id,
                                 o_User_Id     => v_User_Id);
  
    r_Session  := Get_Session(i_State);
    r_Provider := Get_Provider(i_Redirect_Uri);
  
    if not Fazo.Equal(r_Session.Company_Id, v_Company_Id) or
       not Fazo.Equal(r_Session.Session_Id, v_Session_Id) or
       not Fazo.Equal(r_Session.Provider_Id, r_Provider.Provider_Id) then
      b.Raise_Fatal('state doesnt match cookie info');
    end if;
  
    v_Credentials_Company_Id := v_Company_Id;
  
    if Hes_Pref.c_Provider_Olx_Id = r_Provider.Provider_Id then
      v_Credentials_Company_Id := Md_Pref.Company_Head;
    end if;
  
    r_Credentials := z_Hes_Oauth2_Credentials.Load(i_Company_Id  => v_Credentials_Company_Id,
                                                   i_Provider_Id => r_Provider.Provider_Id);
  
    v_Data := z_Hes_Oauth2_Providers.To_Map(r_Provider,
                                            z.Provider_Id,
                                            z.Token_Url,
                                            z.Content_Type,
                                            z.Scope);
  
    v_Data.Put('company_id', v_Company_Id);
    v_Data.Put('user_id', v_User_Id);
  
    v_Data.Put('client_id', r_Credentials.Client_Id);
    v_Data.Put('client_secret', r_Credentials.Client_Secret);
  
    o_Data := v_Data.Json;
  
    z_Hes_Oauth2_Session_States.Delete_One(i_Company_Id  => r_Session.Company_Id,
                                           i_Session_Id  => r_Session.Session_Id,
                                           i_Provider_Id => r_Session.Provider_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Access_Token
  (
    i_Company_Id    number,
    i_User_Id       number,
    i_Provider_Id   number,
    i_Access_Token  varchar2,
    i_Refresh_Token varchar2,
    i_Expires_In    number
  ) is
    v_Expires_In number := case
                             when i_Expires_In > 0 then
                              i_Expires_In
                             else
                              null
                           end;
  begin
    z_Hes_Oauth2_Tokens.Save_One(i_Company_Id    => i_Company_Id,
                                 i_User_Id       => i_User_Id,
                                 i_Provider_Id   => i_Provider_Id,
                                 i_Access_Token  => i_Access_Token,
                                 i_Refresh_Token => i_Refresh_Token,
                                 i_Expires_On    => Systimestamp +
                                                    Numtodsinterval(v_Expires_In, 'second'));
  end;

end Hes_Core;
/
