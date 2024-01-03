prompt adding robot individual schedule
----------------------------------------------------------------------------------------------------
declare
begin
  for Cmp in (select c.Company_Id,
                     (select C1.User_System
                        from Md_Company_Infos C1
                       where C1.Company_Id = c.Company_Id) as User_System
                from Md_Companies c)
  loop
    for Fil in (select f.Company_Id, f.Filial_Id
                  from Md_Filials f
                 where f.Company_Id = Cmp.Company_Id)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => Cmp.User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      z_Htt_Schedules.Save_One(i_Company_Id        => Fil.Company_Id,
                               i_Filial_Id         => Fil.Filial_Id,
                               i_Schedule_Id       => Htt_Next.Schedule_Id,
                               i_Name              => 'Индивидуальный график для позиций',
                               i_Shift             => 0,
                               i_Input_Acceptance  => 0,
                               i_Output_Acceptance => 0,
                               i_Track_Duration    => 0,
                               i_Count_Late        => 'N',
                               i_Count_Early       => 'N',
                               i_Count_Lack        => 'N',
                               i_Take_Holidays     => 'N',
                               i_Take_Nonworking   => 'N',
                               i_State             => 'A',
                               i_Barcode           => 2,
                               i_Pcode             => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
    end loop;
  end loop;

  z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => 'HTT_SCHEDULES',
                                                  i_Column_Set  => 'NAME',
                                                  i_Extra_Where => 'FILIAL_ID = MD_PREF.FILIAL_HEAD(MD_PREF.COMPANY_HEAD) AND PCODE IS NOT NULL');
                                                    
  commit;
end;
/
