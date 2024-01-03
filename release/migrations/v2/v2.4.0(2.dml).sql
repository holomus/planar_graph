prompt migr from 05.08.2022 1.dml
----------------------------------------------------------------------------------------------------
prompt generating rank agreements
----------------------------------------------------------------------------------------------------
declare
  v_Filial_Head number;
  v_User_System number;

  v_Staff_Ids Array_Number;

  -------------------------------------------------- 
  Procedure Insert_Hiring_Rank_Trans
  (
    p_Staff_Ids  in out nocopy Array_Number,
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Journal_Type_Id  number;
    v_Multiple_Type_Id number;
  begin
    v_Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
  
    v_Multiple_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
  
    for r in (select p.Company_Id,
                     p.Filial_Id,
                     p.Journal_Id,
                     Jp.Page_Id,
                     Jp.Staff_Id,
                     h.Hiring_Date,
                     p.Posted_Order_No,
                     Pr.Rank_Id
                from Hpd_Journals p
                join Hpd_Journal_Pages Jp
                  on Jp.Company_Id = p.Company_Id
                 and Jp.Filial_Id = p.Filial_Id
                 and Jp.Journal_Id = p.Journal_Id
                join Hpd_Hirings h
                  on h.Company_Id = Jp.Company_Id
                 and h.Filial_Id = Jp.Filial_Id
                 and h.Page_Id = Jp.Page_Id
                join Hpd_Page_Robots Pr
                  on Pr.Company_Id = Jp.Company_Id
                 and Pr.Filial_Id = Jp.Filial_Id
                 and Pr.Page_Id = Jp.Page_Id
                 and Pr.Rank_Id is not null
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Journal_Type_Id in (v_Journal_Type_Id, v_Multiple_Type_Id)
                 and p.Posted = 'Y'
                 and not exists
               (select 1
                        from Hpd_Transactions Tr
                       where Tr.Company_Id = Jp.Company_Id
                         and Tr.Filial_Id = Jp.Filial_Id
                         and Tr.Page_Id = Jp.Page_Id
                         and Tr.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank))
    loop
      Hpd_Core.Rank_Trans_Insert(i_Company_Id   => r.Company_Id,
                                 i_Filial_Id    => r.Filial_Id,
                                 i_Journal_Id   => r.Journal_Id,
                                 i_Page_Id      => r.Page_Id,
                                 i_Staff_Id     => r.Staff_Id,
                                 i_Begin_Date   => r.Hiring_Date,
                                 i_End_Date     => null,
                                 i_Order_No     => r.Posted_Order_No,
                                 i_Rank_Id      => r.Rank_Id,
                                 i_Source_Table => Zt.Hpd_Hirings);
    
      Fazo.Push(p_Staff_Ids, r.Staff_Id);
    end loop;
  end;

  -------------------------------------------------- 
  Procedure Insert_Transfer_Rank_Trans
  (
    p_Staff_Ids  in out nocopy Array_Number,
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Journal_Type_Id  number;
    v_Multiple_Type_Id number;
  begin
    v_Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
  
    v_Multiple_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
  
    for r in (select p.Company_Id,
                     p.Filial_Id,
                     p.Journal_Id,
                     Jp.Page_Id,
                     Jp.Staff_Id,
                     Tf.Transfer_Begin,
                     Tf.Transfer_End,
                     p.Posted_Order_No,
                     Pr.Rank_Id
                from Hpd_Journals p
                join Hpd_Journal_Pages Jp
                  on Jp.Company_Id = p.Company_Id
                 and Jp.Filial_Id = p.Filial_Id
                 and Jp.Journal_Id = p.Journal_Id
                join Hpd_Transfers Tf
                  on Tf.Company_Id = Jp.Company_Id
                 and Tf.Filial_Id = Jp.Filial_Id
                 and Tf.Page_Id = Jp.Page_Id
                join Hpd_Page_Robots Pr
                  on Pr.Company_Id = Jp.Company_Id
                 and Pr.Filial_Id = Jp.Filial_Id
                 and Pr.Page_Id = Jp.Page_Id
                 and Pr.Rank_Id is not null
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Journal_Type_Id in (v_Journal_Type_Id, v_Multiple_Type_Id)
                 and p.Posted = 'Y'
                 and not exists
               (select 1
                        from Hpd_Transactions Tr
                       where Tr.Company_Id = Jp.Company_Id
                         and Tr.Filial_Id = Jp.Filial_Id
                         and Tr.Page_Id = Jp.Page_Id
                         and Tr.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank))
    loop
      Hpd_Core.Rank_Trans_Insert(i_Company_Id   => r.Company_Id,
                                 i_Filial_Id    => r.Filial_Id,
                                 i_Journal_Id   => r.Journal_Id,
                                 i_Page_Id      => r.Page_Id,
                                 i_Staff_Id     => r.Staff_Id,
                                 i_Begin_Date   => r.Transfer_Begin,
                                 i_End_Date     => r.Transfer_End,
                                 i_Order_No     => r.Posted_Order_No,
                                 i_Rank_Id      => r.Rank_Id,
                                 i_Source_Table => Zt.Hpd_Transfers);
    
      Fazo.Push(p_Staff_Ids, r.Staff_Id);
    end loop;
  end;
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
    
      v_Staff_Ids := Array_Number();
    
      Insert_Hiring_Rank_Trans(p_Staff_Ids => v_Staff_Ids,
                               i_Company_Id => Cmp.Company_Id,
                               i_Filial_Id  => Fil.Filial_Id);
    
      Insert_Transfer_Rank_Trans(p_Staff_Ids => v_Staff_Ids,
                                 i_Company_Id => Cmp.Company_Id,
                                 i_Filial_Id  => Fil.Filial_Id);
    
      Hpd_Core.Agreements_Evaluate(Cmp.Company_Id);
    
      for i in 1 .. v_Staff_Ids.Count
      loop
        Hpd_Core.Staff_Refresh_Cache(i_Company_Id => Cmp.Company_Id,
                                     i_Filial_Id  => Fil.Filial_Id,
                                     i_Staff_Id   => v_Staff_Ids(i));
      end loop;
    end loop;
  end loop;

  Hpd_Pref.g_Migration_Active := false;

  commit;
end;
/
