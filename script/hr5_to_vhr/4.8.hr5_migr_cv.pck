create or replace package Hr5_Migr_Cv is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Cv_Contracts(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Cv_Facts(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Cv_Cached_Contract_Item_Names(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Cv;
/
create or replace package body Hr5_Migr_Cv is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Cv_Contracts(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total   number;
    v_Id      number;
    v_Item_Id number;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
    Dbms_Application_Info.Set_Module('Migr_CV_Contracts', 'started Migr_CV_Contracts');

    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Cv_Contracts q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Cv_Contract
               and Uk.Old_Id = q.Contract_Id);

    for r in (select q.*, Rownum
                from Hr5_Hr_Cv_Contracts q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Cv_Contract
                         and Uk.Old_Id = q.Contract_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_CV_Contracts',
                                       'inserted ' || (r.Rownum - 1) || ' CV Contract(s) out of ' ||
                                       v_Total);

      begin
        savepoint Try_Catch;

        v_Id := Hpd_Next.Cv_Contract_Id;

        z_Hpd_Cv_Contracts.Insert_One(i_Company_Id         => Hr5_Migr_Pref.g_Company_Id,
                                      i_Filial_Id          => Hr5_Migr_Pref.g_Filial_Id,
                                      i_Contract_Id        => v_Id,
                                      i_Contract_Number    => r.Contract_Number,
                                      i_Division_Id        => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                       i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department,
                                                                                       i_Old_Id     => r.Department_Id,
                                                                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                      i_Person_Id          => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                       i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                       i_Old_Id     => r.Person_Id),
                                      i_Begin_Date         => r.Begin_Date,
                                      i_End_Date           => r.End_Date,
                                      i_Contract_Kind      => r.Contract_Kind,
                                      i_Access_To_Add_Item => r.Access_To_Add_Item,
                                      i_Posted             => r.Posted,
                                      i_Early_Closed_Date  => r.Early_Closed_Date,
                                      i_Early_Closed_Note  => r.Early_Closed_Note,
                                      i_Note               => r.Note);

        -- insert items
        for Item in (select *
                       from Hr5_Hr_Cv_Contract_Items q
                      where q.Contract_Id = r.Contract_Id)
        loop
          v_Item_Id := Hpd_Next.Cv_Contract_Item_Id;

          z_Hpd_Cv_Contract_Items.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                             i_Filial_Id        => Hr5_Migr_Pref.g_Filial_Id,
                                             i_Contract_Item_Id => v_Item_Id,
                                             i_Contract_Id      => v_Id,
                                             i_Name             => Item.Name,
                                             i_Quantity         => Item.Quantity,
                                             i_Amount           => Item.Amount);

          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Cv_Contract_Item,
                                  i_Old_Id     => Item.Contract_Item_Id,
                                  i_New_Id     => v_Item_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        end loop;

        -- insert files
        insert into Hpd_Cv_Contract_Files
          (Company_Id, Filial_Id, Contract_Id, File_Sha, Note)
          select Hr5_Migr_Pref.g_Company_Id,
                 Hr5_Migr_Pref.g_Filial_Id,
                 r.Contract_Id,
                 q.File_Sha,
                 q.Note
            from Hr5_Hr_Cv_Contract_Files q
           where q.Contract_Id = r.Contract_Id;

        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Cv_Contract,
                                i_Old_Id     => r.Contract_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;

          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Cv_Contracts',
                                 i_Key_Id        => r.Contract_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;

      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;

    commit;

    Dbms_Application_Info.Set_Module('Migr_Cv_Contracts', 'finished Migr_Cv_Contracts');

    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Cv_Facts(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    r_Contract    Hpd_Cv_Contracts%rowtype;
    v_Total       number;
    v_Id          number;
    v_Item_Id     number;
    v_Contract_Id number;
    v_Account     Mk_Account;
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
    Dbms_Application_Info.Set_Module('Migr_Cv_Facts', 'started Migr_Cv_Facts');

    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Cv_Facts q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Cv_Fact
               and Uk.Old_Id = q.Fact_Id);

    for r in (select q.*, Rownum
                from Hr5_Hr_Cv_Facts q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Cv_Fact
                         and Uk.Old_Id = q.Fact_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Cv_Facts',
                                       'inserted ' || (r.Rownum - 1) || ' CV Fact(s) out of ' ||
                                       v_Total);

      begin
        savepoint Try_Catch;

        v_Id          := Hpr_Next.Cv_Contract_Fact_Id;
        v_Contract_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Cv_Contract,
                                                  i_Old_Id     => r.Contract_Id,
                                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);

        z_Hpr_Cv_Contract_Facts.Insert_One(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id    => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Fact_Id      => v_Id,
                                           i_Contract_Id  => v_Contract_Id,
                                           i_Month        => r.Fact_Date,
                                           i_Total_Amount => r.Total_Amount,
                                           i_Status       => r.Status);

        -- insert items
        for Item in (select *
                       from Hr5_Hr_Cv_Fact_Items q
                      where q.Fact_Id = r.Fact_Id)
        loop
          v_Item_Id := Hpr_Next.Cv_Contract_Fact_Item_Id;

          z_Hpr_Cv_Contract_Fact_Items.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Filial_Id        => Hr5_Migr_Pref.g_Filial_Id,
                                                  i_Fact_Item_Id     => v_Item_Id,
                                                  i_Fact_Id          => v_Id,
                                                  i_Contract_Item_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                                 i_Key_Name   => Hr5_Migr_Pref.c_Cv_Contract_Item,
                                                                                                 i_Old_Id     => Item.Contract_Item_Id,
                                                                                                 i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                                  i_Plan_Quantity    => Item.Plan_Quantity,
                                                  i_Plan_Amount      => Item.Plan_Amount,
                                                  i_Fact_Quantity    => Item.Fact_Quantity,
                                                  i_Fact_Amount      => Item.Fact_Amount,
                                                  i_Name             => Item.Name);

          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Cv_Fact_Item,
                                  i_Old_Id     => Item.Fact_Item_Id,
                                  i_New_Id     => v_Item_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        end loop;

        if r.Status = Hpr_Pref.c_Cv_Contract_Fact_Status_Accept then
          Mk_Journal.Pick(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                          i_Filial_Id    => Hr5_Migr_Pref.g_Filial_Id,
                          i_Journal_Code => Hpr_Util.Jcode_Cv_Contract_Fact(v_Id),
                          i_Trans_Date   => r.Fact_Date);

          Mk_Journal.Clear;

          r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                                     i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                                     i_Contract_Id => v_Contract_Id);
          v_Account  := Mkr_Account.Payroll_Accrual(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                                    i_Currency_Id => z_Mk_Base_Currencies.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                                                                     i_Filial_Id => Hr5_Migr_Pref.g_Filial_Id).Currency_Id,
                                                    i_Ref_Codes   => Mkr_Account.Ref_Codes(i_Person_Id => r_Contract.Person_Id));

          Mk_Journal.Add_Trans(i_Debit  => Mkr_Account.Expense_Others(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                      i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                               i_Credit => v_Account,
                               i_Amount => r.Total_Amount);
        end if;

        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Cv_Fact,
                                i_Old_Id     => r.Fact_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;

          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Cv_Facts',
                                 i_Key_Id        => r.Fact_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;

      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;

    commit;

    Dbms_Application_Info.Set_Module('Migr_Cv_Facts', 'finished Migr_Cv_Facts');

    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Cv_Cached_Contract_Item_Names(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Dbms_Application_Info.Set_Module('Migr_Cv_Cached_Contract_Item_Names',
                                     'started Migr_Cv_Cached_Contract_Item_Names');

    insert into Href_Cached_Contract_Item_Names
      (Company_Id, name)
      select i_Company_Id as Company_Id, Lower(q.Name)
        from Hr5_Hr_Cv_Cached_Item_Names q
       where not exists (select *
                from Href_Cached_Contract_Item_Names w
               where w.Company_Id = i_Company_Id
                 and w.Name = Lower(q.Name));

    commit;

    Dbms_Application_Info.Set_Module('Migr_Cv_Cached_Contract_Item_Names',
                                     'finished Migr_Cv_Cached_Contract_Item_Names');
  end;

end Hr5_Migr_Cv;
/
