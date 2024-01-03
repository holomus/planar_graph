prompt adding oauth2 providers
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Add_Oauth2_Provider
  (
    i_Provider_Id   number,
    i_Provider_Name varchar2,
    i_Auth_Url      varchar2,
    i_Token_Url     varchar2,
    i_Redirect_Uri  varchar2,
    i_Content_Type  varchar2,
    i_Scope         varchar2
  ) is
  begin
    z_Hes_Oauth2_Providers.Save_One(i_Provider_Id   => i_Provider_Id,
                                    i_Provider_Name => i_Provider_Name,
                                    i_Auth_Url      => i_Auth_Url,
                                    i_Token_Url     => i_Token_Url,
                                    i_Redirect_Uri  => i_Redirect_Uri,
                                    i_Content_Type  => i_Content_Type,
                                    i_Scope         => i_Scope);
  end;
begin
  Add_Oauth2_Provider(Hes_Pref.c_Provider_Hh_Id,
                      'hh.uz',
                      'https://hh.ru/oauth/authorize',
                      'https://hh.ru/oauth/token',
                      '/receive/oauth2/hh',
                      'application/x-www-form-urlencoded',
                      '');
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt Head Hunter Default Stages
----------------------------------------------------------------------------------------------------  
declare
  Procedure Save_Stage
  (
    i_Code varchar2,
    i_Name varchar2
  ) is
  begin
    z_Hrec_Head_Hunter_Stages.Save_One(i_Code => i_Code, i_Name => i_Name);
  end;
begin
  Dbms_Output.Put_Line('==== Head Hunter Stages ====');
  Save_Stage('response', 'Отклик');
  Save_Stage('consider', 'Подумать');
  Save_Stage('phone_interview', 'Тел. интервью');
  Save_Stage('assessment', 'Оценка');
  Save_Stage('interview', 'Интервью');
  Save_Stage('offer', 'Предложение о работе');
  Save_Stage('hired', 'Выход на работу');
  Save_Stage('discard_by_employer', 'Отказано');
  Save_Stage('response', 'Все неразобранные');

  commit;
end;
/

---------------------------------------------------------------------------------------------------- 
prompt Head Hunter Integration Stages
----------------------------------------------------------------------------------------------------  
declare
begin
  for Cmp in (select *
                from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(Cmp.Company_Id),
                         i_User_Id      => Md_Pref.User_System(Cmp.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    z_Hrec_Hh_Integration_Stages.Save_One(i_Company_Id => Cmp.Company_Id,
                                          i_Stage_Id   => Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Cmp.Company_Id,
                                                                                      i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo),
                                          i_Stage_Code => Hrec_Pref.c_Hh_Todo_Stage_Code);
  
    commit;
  end loop;
end;
/
