prompt new "Rank Change" journal type adding
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    r_Journal_Type Hpd_Journal_Types%rowtype;
  begin
    begin
      select *
        into r_Journal_Type
        from Hpd_Journal_Types
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Journal_Type.Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => i_Company_Id,
                                 i_Journal_Type_Id => r_Journal_Type.Journal_Type_Id,
                                 i_Name            => Nvl(r_Journal_Type.Name, i_Name),
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  for Cmp in (select *
                from Md_Companies q)
  loop
    Journal_Type(Cmp.Company_Id, 'Изменения квалификации', 8, Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
    Journal_Type(Cmp.Company_Id,
                 'Изменения графика работы списком',
                 9,
                 Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
    Journal_Type(Cmp.Company_Id,
                 'Больничный лист',
                 10,
                 Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
    Journal_Type(Cmp.Company_Id,
                 'Командировка',
                 11,
                 Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
    Journal_Type(Cmp.Company_Id, 'Отпуск', 12, Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  end loop;

   commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt migrating transactions
----------------------------------------------------------------------------------------------------
declare
  v_Filial_Head number;
  v_User_System number;
begin
  Hpd_Pref.g_Migration_Active := true;

  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
    v_User_System := Md_Pref.User_System(Cmp.Company_Id);
  
    for Fil in (select p.Filial_Id
                  from Md_Filials p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id <> v_Filial_Head
                   and p.State = 'A')
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => v_User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for r in (select *
                  from Hpd_Journals p
                  join Hpd_Journal_Types Jt
                    on Jt.Company_Id = p.Company_Id
                   and Jt.Journal_Type_Id = p.Journal_Type_Id
                   and Jt.Pcode in (Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                                    Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple,
                                    Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                                    Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple,
                                    Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                                    Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple,
                                    Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                                    Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change)
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id = Fil.Filial_Id
                   and p.Posted = 'Y')
      loop
        Hpd_Api.Journal_Post(i_Company_Id => Cmp.Company_Id,
                             i_Filial_Id  => Fil.Filial_Id,
                             i_Journal_Id => r.Journal_Id);
      end loop;
    
      Hpd_Core.Agreements_Evaluate;
      Hpd_Core.Dirty_Staffs_Evaluate;
      Hrm_Core.Dirty_Robots_Revise;
    
      for r in (select *
                  from Migr_New_Staffs p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id = Fil.Filial_Id
                   and p.Posted = 'Y'
                 order by p.Hiring_Date)
      loop
        Hpd_Core.Staff_Refresh_Cache(i_Company_Id => r.Company_Id,
                                     i_Filial_Id  => r.Filial_Id,
                                     i_Staff_Id   => r.New_Staff_Id);
      end loop;
    
      commit;
    end loop;
  end loop;

  Hpd_Pref.g_Migration_Active := false;
end;
/


prompt closing unused robots
----------------------------------------------------------------------------------------------------
declare
  v_Filial_Head number;
  v_User_System number;
begin
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
    v_User_System := Md_Pref.User_System(Cmp.Company_Id);
  
    for Fil in (select p.Filial_Id
                  from Md_Filials p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id <> v_Filial_Head
                   and p.State = 'A')
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => v_User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for r in (select p.Company_Id, p.Filial_Id, p.Robot_Id, q.Trans_Date
                  from Hrm_Robots p
                  join Hrm_Robot_Transactions q
                    on q.Company_Id = p.Company_Id
                   and q.Filial_Id = p.Filial_Id
                   and q.Robot_Id = p.Robot_Id
                   and q.Trans_Date = (select max(k.Trans_Date)
                                         from Hrm_Robot_Transactions k
                                        where k.Company_Id = p.Company_Id
                                          and k.Filial_Id = p.Filial_Id
                                          and k.Robot_Id = p.Robot_Id)
                   and q.Fte_Kind = Hrm_Pref.c_Fte_Kind_Occupied
                   and q.Fte < 0
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id = Fil.Filial_Id
                   and p.Closed_Date is null)
      loop
        z_Hrm_Robots.Update_One(i_Company_Id  => r.Company_Id,
                                i_Filial_Id   => r.Filial_Id,
                                i_Robot_Id    => r.Robot_Id,
                                i_Closed_Date => Option_Date(r.Trans_Date));
      
        Hrm_Core.Robot_Close(i_Company_Id => r.Company_Id,
                             i_Filial_Id  => r.Filial_Id,
                             i_Robot_Id   => r.Robot_Id,
                             i_Close_Date => r.Trans_Date);
      end loop;
    
      Hrm_Core.Dirty_Robots_Revise;
    
      commit;
    end loop;
  end loop;
end;
/
