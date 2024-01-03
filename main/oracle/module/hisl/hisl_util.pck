create or replace package Hisl_Util is
  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Request_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Journal_Requests
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Arraylist;
end Hisl_Util;
/
create or replace package body Hisl_Util is
  ----------------------------------------------------------------------------------------------------
  g_Setting  Hisl_Settings%rowtype;
  g_Headers  Hashmap;
  g_User_Ids Array_Number;

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
    return b.Translate('HISL:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status_Success return varchar2 is
  begin
    return t('request_status:success');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status_Error return varchar2 is
  begin
    return t('request_status:error');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Request_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hisl_Pref.c_Request_Status_Success then t_Request_Status_Success --
    when Hisl_Pref.c_Request_Status_Error then t_Request_Status_Error --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hisl_Pref.c_Request_Status_Success, --
                                          Hisl_Pref.c_Request_Status_Error),
                           Array_Varchar2(t_Request_Status_Success, --
                                          t_Request_Status_Error));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Integration_Enabled(i_User_Id number) return boolean is
    r_Employee Mhr_Employees%rowtype;
    v_Dummy    varchar2(1);
  begin
    if g_Setting.Integration_Enabled = 'Y' then
      r_Employee := z_Mhr_Employees.Load(i_Company_Id  => g_Setting.Company_Id,
                                         i_Filial_Id   => g_Setting.Filial_Id,
                                         i_Employee_Id => i_User_Id);
    
      begin
        select 'x'
          into v_Dummy
          from Hisl_Divisions t
         where t.Company_Id = r_Employee.Company_Id
           and t.Filial_Id = r_Employee.Filial_Id
           and t.Division_Id = r_Employee.Division_Id;
      
        return true;
      exception
        when No_Data_Found then
          return false;
      end;
    end if;
  
    return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Create_Url return varchar2 is
  begin
    return g_Setting.Api_Host || Hisl_Pref.c_User_Create_Uri;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Update_Url(i_User_Id number) return varchar2 is
    r_User Hisl_Users%rowtype;
  begin
    r_User := z_Hisl_Users.Load(i_Company_Id => g_Setting.Company_Id,
                                i_Filial_Id  => g_Setting.Filial_Id,
                                i_User_Id    => i_User_Id);
  
    return g_Setting.Api_Host || Regexp_Replace(Hisl_Pref.c_User_Update_Uri,
                                                '{user_code}',
                                                r_User.User_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Update_Status_Url(i_User_Id number) return varchar2 is
    r_User Hisl_Users%rowtype;
  begin
    r_User := z_Hisl_Users.Load(i_Company_Id => g_Setting.Company_Id,
                                i_Filial_Id  => g_Setting.Filial_Id,
                                i_User_Id    => i_User_Id);
  
    return g_Setting.Api_Host || Regexp_Replace(Hisl_Pref.c_User_Update_Status_Uri,
                                                '{user_code}',
                                                r_User.User_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Space_Tag(i_Level number) return varchar2 is
  begin
    if i_Level > 20 then
      b.Raise_Fatal('Max value level is 20!');
    end if;
    return Lpad(' ', i_Level * 2, ' ');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Open_Tag
  (
    i_Level    number,
    i_Tag_Name varchar2
  ) return varchar2 is
  begin
    return Space_Tag(i_Level) || '<' || i_Tag_Name || '>';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Close_Tag
  (
    i_Level    number,
    i_Tag_Name varchar2
  ) return varchar2 is
  begin
    return Space_Tag(i_Level) || '</' || i_Tag_Name || '>';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tag
  (
    i_Level    number,
    i_Tag_Name varchar2,
    i_Value    varchar2
  ) return varchar2 is
  begin
    return Open_Tag(i_Level, i_Tag_Name) || i_Value || Close_Tag(0, i_Tag_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Create_Xml(i_User_Id number) return varchar2 is
    r_Employee   Mhr_Employees%rowtype;
    r_Person     Md_Persons%rowtype;
    r_Nat_Person Mr_Natural_Persons%rowtype;
    v_Password   varchar2(50 char);
    v            Stream := Stream();
  begin
    r_Employee := z_Mhr_Employees.Load(i_Company_Id  => g_Setting.Company_Id,
                                       i_Filial_Id   => g_Setting.Filial_Id,
                                       i_Employee_Id => i_User_Id);
  
    r_Person := z_Md_Persons.Load(i_Company_Id => r_Employee.Company_Id,
                                  i_Person_Id  => r_Employee.Employee_Id);
  
    r_Nat_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Employee.Company_Id,
                                              i_Person_Id  => r_Employee.Employee_Id);
  
    v_Password := Initcap(z_Md_Companies.Load(g_Setting.Company_Id).Code) || '12345678';
  
    v.Println('<?xml version="1.0" encoding="UTF-8"?>');
    v.Println(Open_Tag(0, 'request'));
    v.Println(Tag(1,
                  'departmentId',
                  z_Hisl_Divisions.Load(i_Company_Id => r_Employee.Company_Id, --
                  i_Filial_Id => r_Employee.Filial_Id, i_Division_Id => r_Employee.Division_Id).Division_Code));
    v.Println(Tag(1, 'password', v_Password));
    v.Println(Open_Tag(1, 'fields'));
    v.Println(Tag(2, 'login', r_Person.Email));
    v.Println(Tag(2, 'email', r_Person.Email));
  
    if r_Person.Phone is not null then
      v.Println(Tag(2, 'phone', '+' || r_Person.Phone));
    end if;
  
    v.Println(Tag(2, 'first_name', r_Nat_Person.First_Name));
    v.Println(Tag(2, 'last_name', r_Nat_Person.Last_Name));
    v.Println(Tag(2,
                  'job_title',
                  z_Mhr_Jobs.Load(i_Company_Id => r_Employee.Company_Id, --
                  i_Filial_Id => r_Employee.Filial_Id, i_Job_Id => r_Employee.Job_Id).Name));
    v.Println(Close_Tag(1, 'fields'));
    v.Println(Tag(1, 'role', Hisl_Pref.c_User_Role_Learner));
    v.Println(Tag(1, 'sendLoginEmail', 'true'));
    v.Println(Tag(1,
                  'invitationMessage',
                  t('use the following details to sign in to ispring academy - email: $1{email}, password: $2{password}',
                    r_Person.Email,
                    v_Password)));
    v.Println(Close_Tag(0, 'request'));
  
    return Fazo.Gather(v.Val, '');
  end;
  ----------------------------------------------------------------------------------------------------
  Function User_Update_Xml(i_User_Id number) return varchar2 is
    r_Employee Mhr_Employees%rowtype;
    v          Stream := Stream();
  begin
    r_Employee := z_Mhr_Employees.Load(i_Company_Id  => g_Setting.Company_Id,
                                       i_Filial_Id   => g_Setting.Filial_Id,
                                       i_Employee_Id => i_User_Id);
  
    v.Println('<?xml version="1.0" encoding="UTF-8"?>');
    v.Println(Open_Tag(0, 'request'));
    v.Println(Tag(1,
                  'departmentId',
                  z_Hisl_Divisions.Load(i_Company_Id => r_Employee.Company_Id, --
                  i_Filial_Id => r_Employee.Filial_Id, i_Division_Id => r_Employee.Division_Id).Division_Code));
    v.Println(Open_Tag(1, 'fields'));
    v.Println(Tag(2,
                  'job_title',
                  z_Mhr_Jobs.Load(i_Company_Id => r_Employee.Company_Id, --
                  i_Filial_Id => r_Employee.Filial_Id, i_Job_Id => r_Employee.Job_Id).Name));
    v.Println(Close_Tag(1, 'fields'));
    v.Println(Close_Tag(0, 'request'));
  
    return Fazo.Gather(v.Val, '');
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Update_Status_Xml(i_Status varchar2) return varchar2 is
    v Stream := Stream();
  begin
    v.Println('<?xml version="1.0" encoding="UTF-8"?>');
    v.Println(Open_Tag(0, 'request'));
    v.Println(Tag(1, 'status', i_Status));
    v.Println(Close_Tag(0, 'request'));
  
    return Fazo.Gather(v.Val, '');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hiring_Requests return Arraylist is
    v_User_Id number;
    v_Data    Hashmap;
    result    Arraylist := Arraylist();
  begin
    for i in 1 .. g_User_Ids.Count
    loop
      v_User_Id := g_User_Ids(i);
    
      if Integration_Enabled(v_User_Id) then
        if z_Hisl_Users.Exist(i_Company_Id => g_Setting.Company_Id,
                              i_Filial_Id  => g_Setting.Filial_Id,
                              i_User_Id    => v_User_Id) then
          -- update user
          v_Data := Hashmap();
          v_Data.Put('url', User_Update_Url(v_User_Id));
          v_Data.Put('headers', g_Headers);
          v_Data.Put('body', User_Update_Xml(v_User_Id));
          v_Data.Put('message', t('ispring learn user update'));
        
          Result.Push(v_Data);
        
          -- activate user
          v_Data.Put('url', User_Update_Status_Url(v_User_Id));
          v_Data.Put('headers', g_Headers);
          v_Data.Put('body', User_Update_Status_Xml(Hisl_Pref.c_User_Status_Active));
          v_Data.Put('message', t('ispring learn user activate'));
        
          Result.Push(v_Data);
        else
          -- create user
          v_Data := Hashmap();
          v_Data.Put('url', User_Create_Url);
          v_Data.Put('headers', g_Headers);
          v_Data.Put('body', User_Create_Xml(v_User_Id));
          v_Data.Put('user_id', v_User_Id);
          v_Data.Put('message', t('ispring learn user create'));
        
          Result.Push(v_Data);
        end if;
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Transfer_Requests return Arraylist is
    v_User_Id number;
    v_Data    Hashmap;
    result    Arraylist := Arraylist();
  begin
    for i in 1 .. g_User_Ids.Count
    loop
      v_User_Id := g_User_Ids(i);
    
      if Integration_Enabled(v_User_Id) then
        -- update user
        v_Data := Hashmap();
        v_Data.Put('url', User_Update_Url(v_User_Id));
        v_Data.Put('headers', g_Headers);
        v_Data.Put('body', User_Update_Xml(v_User_Id));
        v_Data.Put('message', t('ispring learn user update'));
      
        Result.Push(v_Data);
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Requests return Arraylist is
    v_User_Id number;
    v_Data    Hashmap;
    result    Arraylist := Arraylist();
  begin
    for i in 1 .. g_User_Ids.Count
    loop
      v_User_Id := g_User_Ids(i);
    
      if Integration_Enabled(v_User_Id) then
        -- update user
        v_Data := Hashmap();
        v_Data.Put('url', User_Update_Status_Url(v_User_Id));
        v_Data.Put('headers', g_Headers);
        v_Data.Put('body', User_Update_Status_Xml(Hisl_Pref.c_User_Status_Passive));
        v_Data.Put('message', t('ispring learn user dismiss'));
      
        Result.Push(v_Data);
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journal_Requests
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Arraylist is
    r_Journal Hpd_Journals%rowtype;
  begin
    g_Setting := z_Hisl_Settings.Take(i_Company_Id => i_Company_Id, --
                                      i_Filial_Id  => i_Filial_Id);
    if g_Setting.Company_Id is null then
      return Arraylist();
    end if;
  
    g_Headers := Fazo.Zip_Map('x-auth-account-url',
                              g_Setting.Auth_Url,
                              'x-auth-email',
                              g_Setting.Auth_Email,
                              'x-auth-password',
                              g_Setting.Auth_Password,
                              'content-type',
                              'application/xml');
  
    select t.Employee_Id
      bulk collect
      into g_User_Ids
      from Hpd_Journal_Pages t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Journal_Id = i_Journal_Id;
  
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Journal_Id => i_Journal_Id);
  
    if r_Journal.Journal_Type_Id in
       (Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
        Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple)) then
      return Hiring_Requests;
    elsif r_Journal.Journal_Type_Id in
          (Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
           Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple)) then
      return Transfer_Requests;
    elsif r_Journal.Journal_Type_Id in
          (Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
           Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple)) then
      return Dismissal_Requests;
    end if;
  
    return Arraylist();
  end;

end Hisl_Util;
/
