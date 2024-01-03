prompt migr from 14.11.2022 (2.after_start_dml)
----------------------------------------------------------------------------------------------------
prompt add set order no and add new book type for all companies
----------------------------------------------------------------------------------------------------
declare
  v_Order number;
begin
  for Cmp in (select c.Company_Id,
                     (select C1.User_System
                        from Md_Company_Infos C1
                       where C1.Company_Id = c.Company_Id) as User_System,
                     (select C1.Filial_Head
                        from Md_Company_Infos C1
                       where C1.Company_Id = c.Company_Id) as Filial_Head
                from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Cmp.Filial_Head,
                         i_User_Id      => Cmp.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    v_Order := 1;
    for Typ in (select *
                  from Hpr_Book_Types q
                 where q.Company_Id = Cmp.Company_Id
                 order by q.Pcode)
    loop
      z_Hpr_Book_Types.Update_One(i_Company_Id   => Typ.Company_Id,
                                  i_Book_Type_Id => Typ.Book_Type_Id,
                                  i_Order_No     => Option_Number(v_Order));
    
      v_Order := v_Order + 1;
    end loop;
  
    z_Hpr_Book_Types.Save_One(i_Company_Id   => Cmp.Company_Id,
                              i_Book_Type_Id => Hpr_Next.Book_Type_Id,
                              i_Name         => 'Начисление всех видов',
                              i_Order_No     => v_Order,
                              i_Pcode        => Hpr_Pref.c_Pcode_Book_Type_All);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt migr schedule multiple data
----------------------------------------------------------------------------------------------------
declare
begin
  for Cmp in (select c.Company_Id,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System,
                     (select Ci.Filial_Head
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as Filial_Head
                from Md_Companies c)
  loop
    for Fil in (select f.Filial_Id
                  from Md_Filials f
                 where f.Company_Id = Cmp.Company_Id
                   and f.Filial_Id <> Cmp.Filial_Head)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => Cmp.User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      insert into Hpd_Page_Schedules
        (Company_Id, Filial_Id, Page_Id, Schedule_Id)
        select q.Company_Id, q.Filial_Id, p.Page_Id, q.Schedule_Id
          from Hpd_Schedule_Changes q
          join Hpd_Journal_Pages p
            on p.Company_Id = Cmp.Company_Id
           and p.Filial_Id = Fil.Filial_Id
           and p.Journal_Id = q.Journal_Id
         where q.Company_Id = Cmp.Company_Id
           and q.Filial_Id = Fil.Filial_Id;
    
      insert into Hpd_Schedule_Changes
        (Company_Id,
         Filial_Id,
         Journal_Id,
         Division_Id,
         Schedule_Id,
         Begin_Date,
         End_Date)
        select q.Company_Id,
               q.Filial_Id,
               q.Journal_Id,
               q.Division_Id,
               null Schedule_Id,
               q.Begin_Date,
               q.End_Date
          from Hpd_Schedule_Multiples q
         where q.Company_Id = Cmp.Company_Id
           and q.Filial_Id = Fil.Filial_Id;
    
      -- Schedule Multiple changed to Schedule Change
      update Hpd_Journals j
         set j.Journal_Type_Id =
             (select Jt.Journal_Type_Id
                from Hpd_Journal_Types Jt
               where Jt.Company_Id = Cmp.Company_Id
                 and Jt.Pcode = Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change)
       where j.Company_Id = Cmp.Company_Id
         and j.Filial_Id = Fil.Filial_Id
         and j.Journal_Type_Id = (select Jt.Journal_Type_Id
                                    from Hpd_Journal_Types Jt
                                   where Jt.Company_Id = Cmp.Company_Id
                                     and Jt.Pcode = 'VHR:HPD:15'); -- schedule multiple
    
      update Hpd_Transactions t
         set t.Tag = Zt.Hpd_Schedule_Changes.Name
       where t.Company_Id = Cmp.Company_Id
         and t.Filial_Id = Fil.Filial_Id
         and t.Tag = Zt.Hpd_Schedule_Multiples.Name;
    end loop;
  end loop;

  -- Schedule Multiple journal type deleted
  delete from Hpd_Journal_Types Jt
   where Jt.Pcode = 'VHR:HPD:15'; -- schedule multiple

  -- Wage Change Multiple journal type pcode changed
  update Hpd_Journal_Types Jt
     set Jt.Pcode = 'VHR:HPD:15'
   where Jt.Pcode = 'VHR:HPD:16';

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt change order of journal types
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Journal_Type_Update
  (
    i_Pcode    varchar2,
    i_Order_No number
  ) is
  begin
    update Hpd_Journal_Types j
       set j.Order_No = i_Order_No
     where j.Pcode = i_Pcode;
  end;
begin
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Limit_Change, 11);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave, 12);
  Journal_Type_Update(Hpd_pref.c_Pcode_Journal_Type_Business_Trip, 13);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Vacation, 14);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Overtime, 15);

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt insert badge template 
----------------------------------------------------------------------------------------------------
declare
  begin
    insert into Href_Badge_Templates
      (Badge_Template_Id, name, Html_Value, State)
    values
      (Href_Badge_Templates_Sq.Nextval,
       'Бейдж сотрудника(по умолчанию)',
       '<div style="display: flex; align-items: stretch; padding: 10px; border: 1px solid #ccc;">
           <div style="width: 50%; text-align: center;">
             <h2 style="font-weight: 600;">{{ company_name }}</h2>
             <img src="{{ filial_logo }}" style="margin: 5px auto; width: 200px;"/>
             <h5 style="font-weight: 600;">{{ employee_name }}</h5>
             <h6>{{ employee_job }}</h6>
             <h6>{{ employee_number }}</h6>
           </div>
           <div style="width: 50%; display: flex; justify-content: center; align-items: center;">
             <img src="{{ qrcode }}" style="width: 200px;"/>
           </div>
         </div>',
       'A');

  commit;    
  exception
    when Dup_Val_On_Index then
      null; 
  end;
/

----------------------------------------------------------------------------------------------------
prompt add individual schedule
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
                               i_Name              => 'Индивидуальный график',
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
                               i_Barcode           => 1,
                               i_Pcode             => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    end loop;
  end loop;

  z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => 'HTT_SCHEDULES',
                                                  i_Column_Set  => 'NAME',
                                                  i_Extra_Where => 'FILIAL_ID = MD_PREF.FILIAL_HEAD(MD_PREF.COMPANY_HEAD) AND PCODE IS NOT NULL');
                                                    
  commit;
end;
/
