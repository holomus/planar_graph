create or replace package Ui_Vhr581 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Users return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Logs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Remove(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure User_Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure User_Remove(p Hashmap);
end Ui_Vhr581;
/
create or replace package body Ui_Vhr581 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from md_persons q
                      where q.company_id = :company_id
                        and q.person_kind = :person_kind
                        and exists (select 1
                               from mrf_persons s
                              where s.company_id = q.company_id
                                and s.filial_id = :filial_id
                                and s.person_id = q.person_id
                                and s.state = :state)',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'person_kind',
                                 Md_Pref.c_Pk_Natural,
                                 'state',
                                 'A'));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hisl_divisions',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id),
                    true);
  
    q.Number_Field('division_id', 'created_by');
    q.Varchar2_Field('division_code');
    q.Date_Field('created_on');
  
    q.Refer_Field('created_by_name', --
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    q.Map_Field('division_name', 'select name from mhr_divisions where division_id = $division_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Users return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hisl_users',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id),
                    true);
  
    q.Number_Field('user_id', 'created_by');
    q.Varchar2_Field('user_code');
    q.Date_Field('created_on');
  
    q.Refer_Field('created_by_name', --
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    q.Map_Field('user_name', 'select name from md_users where user_id = $user_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Logs return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hisl_logs',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id),
                    true);
  
    q.Number_Field('log_id', 'created_by');
    q.Varchar2_Field('status', 'url', 'request_body', 'response_body');
    q.Date_Field('created_on');
  
    v_Matrix := Hisl_Util.Request_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('created_by_name', --
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    q.Map_Field('user_name', 'select name from md_users where user_id = $user_id');
  
    return q;
  end;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Setting Hisl_Settings%rowtype;
    result    Hashmap;
  begin
    r_Setting := z_Hisl_Settings.Take(i_Company_Id => Ui.Company_Id, --
                                      i_Filial_Id  => Ui.Filial_Id);
  
    result := z_Hisl_Settings.To_Map(r_Setting,
                                     z.Integration_Enabled,
                                     z.Api_Host,
                                     z.Auth_Url,
                                     z.Auth_Email,
                                     z.Auth_Password);
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Save(p Hashmap) is
    r_Setting Hisl_Settings%rowtype;
  begin
    r_Setting := z_Hisl_Settings.To_Row(p,
                                        z.Integration_Enabled,
                                        z.Api_Host,
                                        z.Auth_Url,
                                        z.Auth_Email,
                                        z.Auth_Password);
  
    r_Setting.Company_Id := Ui.Company_Id;
    r_Setting.Filial_Id  := Ui.Filial_Id;
  
    Hisl_Api.Setting_Save(r_Setting);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Add(p Hashmap) is
  begin
    Hisl_Api.Division_Add(i_Company_Id    => Ui.Company_Id,
                          i_Filial_Id     => Ui.Filial_Id,
                          i_Division_Id   => p.r_Number('division_id'),
                          i_Division_Code => p.r_Varchar2('division_code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Remove(p Hashmap) is
  begin
    Hisl_Api.Division_Remove(i_Company_Id  => Ui.Company_Id,
                             i_Filial_Id   => Ui.Filial_Id,
                             i_Division_Id => p.r_Number('division_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure User_Add(p Hashmap) is
  begin
    Hisl_Api.User_Add(i_Company_Id => Ui.Company_Id,
                      i_Filial_Id  => Ui.Filial_Id,
                      i_User_Id    => p.r_Number('user_id'),
                      i_User_Code  => p.r_Varchar2('user_code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure User_Remove(p Hashmap) is
  begin
    Hisl_Api.User_Remove(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_User_Id    => p.r_Number('user_id'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Md_Persons
       set Company_Id  = null,
           Person_Id   = null,
           Person_Kind = null,
           name        = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null,
           State      = null;
    update Hisl_Divisions
       set Company_Id    = null,
           Filial_Id     = null,
           Division_Id   = null,
           Division_Code = null,
           Created_By    = null,
           Created_On    = null;
    update Mhr_Divisions
       set Division_Id = null,
           name        = null;
    update Hisl_Users
       set Company_Id = null,
           Filial_Id  = null,
           User_Id    = null,
           User_Code  = null,
           Created_By = null,
           Created_On = null;
    update Hisl_Logs
       set Company_Id    = null,
           Filial_Id     = null,
           Log_Id        = null,
           Status        = null,
           Url           = null,
           Request_Body  = null,
           Response_Body = null,
           Created_By    = null,
           Created_On    = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr581;
/
