prompt add System entities
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Lang_Code    varchar2(5);
  v_Pcode_Like   varchar2(10) := Upper(Href_Pref.c_Pc_Verifix_Hr) || '%';
  v_Query        varchar2(4000);
  r_Stage        Hrec_Stages%rowtype;
  r_Funnel       Hrec_Funnels%rowtype;

  --------------------------------------------------
  Procedure Stage
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Stage_Id number;
  begin
    begin
      select Stage_Id
        into v_Stage_Id
        from Hrec_Stages
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Stage_Id := Hrec_Next.Stage_Id;
    end;
  
    z_Hrec_Stages.Save_One(i_Company_Id => v_Company_Head,
                           i_Stage_Id   => v_Stage_Id,
                           i_Name       => i_Name,
                           i_State      => 'A',
                           i_Order_No   => i_Order_No,
                           i_Code       => '',
                           i_Pcode      => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Funnel
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Funnel_Id number;
  begin
    begin
      select Funnel_Id
        into v_Funnel_Id
        from Hrec_Funnels
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Funnel_Id := Hrec_Next.Funnel_Id;
    end;
  
    z_Hrec_Funnels.Save_One(i_Company_Id => v_Company_Head,
                            i_Funnel_Id  => v_Funnel_Id,
                            i_Name       => i_Name,
                            i_State      => 'A',
                            i_Code       => '',
                            i_Pcode      => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => i_Table_Name,
                                                    i_Column_Set  => i_Column_Set,
                                                    i_Extra_Where => i_Extra_Where);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);

  ----------------------------------------------------------------------------------------------------
  -- Fill Stages
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Stages ====');
  Stage('К выполнению', 1, Hrec_Pref.c_Pcode_Stage_Todo);
  Stage('Предложение принято', 98, Hrec_Pref.c_Pcode_Stage_Accepted);
  Stage('Отклонена', 99, Hrec_Pref.c_Pcode_Stage_Rejected);
  --------------------------------------------------
  Dbms_Output.Put_Line('==== Funnels ====');
  Funnel('Все этапы', Hrec_Pref.c_Pcode_Funnel_All);

  --------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HREC_STAGES', 'NAME');
  Table_Record_Setting('HREC_FUNNELS', 'NAME');

  ----------------------------------------------------------------------------------------------------
  -- Translates
  ----------------------------------------------------------------------------------------------------
  -- RU
  Uis.Table_Record_Translate('HREC_STAGES', 'VHR:HREC:1', 'NAME', 'ru', 'К выполнению');
  Uis.Table_Record_Translate('HREC_STAGES', 'VHR:HREC:2', 'NAME', 'ru', 'Предложение принято');
  Uis.Table_Record_Translate('HREC_STAGES', 'VHR:HREC:3', 'NAME', 'ru', 'Отклонена');
  Uis.Table_Record_Translate('HREC_FUNNELS', 'VHR:HREC:1', 'NAME', 'ru', 'Все этапы');
  -- EN
  Uis.Table_Record_Translate('HREC_STAGES', 'VHR:HREC:1', 'NAME', 'en', 'Todo');
  Uis.Table_Record_Translate('HREC_STAGES', 'VHR:HREC:2', 'NAME', 'en', 'Offer accepted');
  Uis.Table_Record_Translate('HREC_STAGES', 'VHR:HREC:3', 'NAME', 'en', 'Rejected');
  Uis.Table_Record_Translate('HREC_FUNNELS', 'VHR:HREC:1', 'NAME', 'en', 'All stages');

  ----------------------------------------------------------------------------------------------------
  for c in (select *
              from Md_Companies t
             where t.Company_Id <> v_Company_Head)
  loop
    v_Lang_Code := z_Md_Companies.Load(c.Company_Id).Lang_Code;
  
    Ui_Context.Init_Migr(i_Company_Id   => c.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(c.Company_Id),
                         i_User_Id      => Md_Pref.User_System(c.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- add default stages
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hrec_Stages,
                                                i_Lang_Code => v_Lang_Code);
    for r in (select *
                from Hrec_Stages t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Order_No)
    loop
      r_Stage            := r;
      r_Stage.Company_Id := c.Company_Id;
      r_Stage.Stage_Id   := Hrec_Next.Stage_Id;
    
      execute immediate v_Query
        using in r_Stage, out r_Stage;
    
      z_Hrec_Stages.Save_Row(r_Stage);
    end loop;
  
    -- add default funnels
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hrec_Funnels,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hrec_Funnels t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Funnel            := r;
      r_Funnel.Company_Id := c.Company_Id;
      r_Funnel.Funnel_Id  := Hrec_Next.Funnel_Id;
    
      execute immediate v_Query
        using in r_Funnel, out r_Funnel;
    
      z_Hrec_Funnels.Save_Row(r_Funnel);
    end loop;
  end loop;

  commit;
end;
/
