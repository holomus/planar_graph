create or replace package Hr5_Migr_Md is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Biruni_Files(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Initial_Persons(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Filials(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Md;
/
create or replace package body Hr5_Migr_Md is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Biruni_Files(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Dbms_Application_Info.Set_Module('Migr_Biruni_Files', 'migrating file sha''s');
  
    Hr5_Migr_Util.Init(i_Company_Id => i_Company_Id, i_With_Filial => false);
  
    insert into Biruni_Files
      (Sha, Created_On, File_Size, File_Name, Content_Type, Store_Kind)
      (select Sha, Created_On, File_Size, File_Name, Content_Type, 'D'
         from Hr5_Biruni_Files Old_Bf
        where not exists (select 1
                 from Biruni_Files New_Bf
                where New_Bf.Sha = Old_Bf.Sha));
  
    insert into Md_Company_Files
      (Company_Id, Sha, Created_By, Created_On)
      select i_Company_Id as Company_Id, Sha, Hr5_Migr_Pref.g_User_System as Created_By, Created_On
        from Hr5_Biruni_Files Old_Bf
       where not exists (select 1
                from Md_Company_Files Cmp_Bf
               where Cmp_Bf.Company_Id = i_Company_Id
                 and Cmp_Bf.Sha = Old_Bf.Sha);
  
    commit;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Migr_Biruni_Files', 'finished Migr_Biruni_Files');
  end;

  ----------------------------------------------------------------------------------------------------
  -- migrating md persons
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Initial_Persons(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Initial_Persons', 'started Migr_Initial_Persons');
  
    Hr5_Migr_Util.Init(i_Company_Id => i_Company_Id, i_With_Filial => false);
  
    -- md_persons
    -- total count
    select count(*)
      into v_Total
      from Hr5_Md_Persons q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Uk.Old_Id = q.Person_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Md_Persons q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Uk.Old_Id = q.Person_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Initial_Persons',
                                       'inserted ' || (r.Rownum - 1) || ' Md Person(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Md_Next.Person_Id;
      
        z_Md_Persons.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                i_Person_Id   => v_Id,
                                i_Name        => r.Name,
                                i_Person_Kind => r.Person_Kind,
                                i_Email       => null,
                                i_Photo_Sha   => null,
                                i_State       => 'A',
                                i_Code        => null);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                i_Old_Id     => r.Person_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Md_Persons',
                                 i_Key_Id        => r.Person_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- md_users
    -- total count
    select count(*)
      into v_Total
      from Hr5_Md_Users q
     where exists (select 1
              from Hr5_Migr_Keys_Store_One Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Ks.Old_Id = q.User_Id
               and not exists (select 1
                      from Md_Users u
                     where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and u.User_Id = Ks.New_Id))
       and q.Login <> 'admin';
  
    for r in (select q.*, Rownum
                from Hr5_Md_Users q
               where exists (select 1
                        from Hr5_Migr_Keys_Store_One Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Ks.Old_Id = q.User_Id
                         and not exists (select 1
                                from Md_Users u
                               where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and u.User_Id = Ks.New_Id))
                 and q.Login <> 'admin')
    loop
      Dbms_Application_Info.Set_Module('Migr_Initial_Persons',
                                       'inserted ' || (r.Rownum - 1) || ' Md User(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        z_Md_Users.Insert_One(i_Company_Id               => Hr5_Migr_Pref.g_Company_Id,
                              i_User_Id                  => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                     i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                     i_Old_Id     => r.User_Id),
                              i_Name                     => r.Name,
                              i_Login                    => r.Login,
                              i_Password                 => r.Password,
                              i_State                    => r.State,
                              i_User_Kind                => 'N',
                              i_Gender                   => null,
                              i_Manager_Id               => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                     i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                     i_Old_Id     => r.Manager_Id),
                              i_Timezone_Code            => r.Timezone_Code,
                              i_Password_Changed_On      => r.Password_Changed_On,
                              i_Password_Change_Required => r.Forced_To_Change_Password,
                              i_Two_Factor_Verification  => Md_Pref.c_Two_Step_Verification_Disabled,
                              i_Order_No                 => null);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Md_Users',
                                 i_Key_Id        => r.User_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- mr_natural_persons
    -- total count
    select count(*)
      into v_Total
      from Hr5_Mr_Natural_Persons q
     where exists (select 1
              from Hr5_Migr_Keys_Store_One Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Ks.Old_Id = q.Person_Id
               and not exists (select 1
                      from Mr_Natural_Persons u
                     where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and u.Person_Id = Ks.New_Id));
  
    for r in (select q.*, Rownum
                from Hr5_Mr_Natural_Persons q
               where exists (select 1
                        from Hr5_Migr_Keys_Store_One Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Ks.Old_Id = q.Person_Id
                         and not exists (select 1
                                from Mr_Natural_Persons u
                               where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and u.Person_Id = Ks.New_Id))
               start with q.Responsible_Person_Id is null
              connect by prior q.Person_Id = q.Responsible_Person_Id)
    loop
      Dbms_Application_Info.Set_Module('Migr_Initial_Persons',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Mr Natural Person(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        z_Mr_Natural_Persons.Insert_One(i_Company_Id            => Hr5_Migr_Pref.g_Company_Id,
                                        i_Person_Id             => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                            i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                            i_Old_Id     => r.Person_Id),
                                        i_Name                  => r.Name,
                                        i_First_Name            => r.First_Name,
                                        i_Last_Name             => r.Last_Name,
                                        i_Middle_Name           => r.Middle_Name,
                                        i_Gender                => r.Gender,
                                        i_Birthday              => r.Birthday,
                                        i_Legal_Person_Id       => null,
                                        i_Responsible_Person_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                            i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                            i_Old_Id     => r.Responsible_Person_Id),
                                        i_State                 => r.State,
                                        i_Code                  => r.Code);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Mr_Natural_Persons',
                                 i_Key_Id        => r.Person_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- mr_natural_person_details
    -- total count
    select count(*)
      into v_Total
      from Hr5_Mr_Natural_Persons q
     where exists (select 1
              from Hr5_Migr_Keys_Store_One Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Ks.Old_Id = q.Person_Id
               and exists (select 1
                      from Mr_Natural_Persons u
                     where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and u.Person_Id = Ks.New_Id)
               and not exists (select 1
                      from Mr_Person_Details u
                     where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and u.Person_Id = Ks.New_Id));
  
    for r in (select q.Person_Id,
                     Pd.Main_Phone,
                     Pd.Main_Email,
                     Pd.Facebook,
                     Pd.Twitter,
                     Pd.Skype,
                     Pd.Web,
                     Pd.Post_Address,
                     Pd.Address_Guide,
                     Pd.Region_Id,
                     Pd.Barcode,
                     Pd.License_Begin_Date,
                     Pd.License_End_Date,
                     Pd.License_Code,
                     Pd.Note,
                     Pd.Zip_Code,
                     Rownum
                from Hr5_Mr_Natural_Persons q
                left join Hr5_Mr_Person_Details Pd
                  on Pd.Person_Id = q.Person_Id
               where exists (select 1
                        from Hr5_Migr_Keys_Store_One Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Ks.Old_Id = q.Person_Id
                         and exists (select 1
                                from Mr_Natural_Persons u
                               where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and u.Person_Id = Ks.New_Id)
                         and not exists (select 1
                                from Mr_Person_Details u
                               where u.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and u.Person_Id = Ks.New_Id)))
    loop
      Dbms_Application_Info.Set_Module('Migr_Initial_Persons',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Mr Natural Person Detail(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                         i_Old_Id     => r.Person_Id);
      
        if r.Main_Phone is not null then
          r.Main_Phone := Regexp_Replace(r.Main_Phone, '\D', '');
        
          if Length(r.Main_Phone) = 9 then
            r.Main_Phone := '998' || r.Main_Phone;
          end if;
        end if;
      
        z_Mr_Person_Details.Insert_One(i_Company_Id             => Hr5_Migr_Pref.g_Company_Id,
                                       i_Person_Id              => v_Id,
                                       i_Tin                    => null,
                                       i_Cea                    => null,
                                       i_Main_Phone             => r.Main_Phone,
                                       i_Web                    => r.Web,
                                       i_Fax                    => null,
                                       i_Telegram               => null,
                                       i_Post_Address           => r.Post_Address,
                                       i_Address                => r.Post_Address,
                                       i_Address_Guide          => r.Address_Guide,
                                       i_Legal_Address          => null,
                                       i_Director_Name          => null,
                                       i_Parent_Person_Id       => null,
                                       i_Owner_Person_Id        => null,
                                       i_Region_Id              => null,
                                       i_Legal_Form_Id          => null,
                                       i_Barcode                => r.Barcode,
                                       i_Note                   => r.Note,
                                       i_Zip_Code               => r.Zip_Code,
                                       i_Vat_Code               => null,
                                       i_Is_Budgetarian         => 'N',
                                       i_Recommended_Visit_Time => null);
      
        z_Md_Persons.Update_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Person_Id  => v_Id,
                                i_Email      => Option_Varchar2(r.Main_Email),
                                i_Phone      => Option_Varchar2(r.Main_Phone));
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Mr_Person_Details',
                                 i_Key_Id        => r.Person_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Hr5_Migr_Util.Clear;
  
    Dbms_Application_Info.Set_Module('Migr_Initial_Persons', 'finished Migr_Initial_Persons');
  end;

  ----------------------------------------------------------------------------------------------------
  -- migrating filial data
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Filials(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    r_Filial Md_Filials%rowtype;
    r_Person Mr_Legal_Persons%rowtype;
  
    v_Currency_Id number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Filials', 'started Migr_Filials');
  
    Hr5_Migr_Util.Init(i_Company_Id => i_Company_Id, i_With_Filial => false);
    Biruni_Route.Clear_Globals;
    Biruni_Route.Context_Begin;
  
    for r in (select q.*, Rownum
                from Hr5_Md_Filials q
               where q.Filial_Id <> Hr5_Md_Pref.c_Filial_Head
                 and not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Md_Filial
                         and Uk.Old_Id = q.Filial_Id))
    loop
      z_Md_Filials.Init(p_Row           => r_Filial,
                        i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                        i_Filial_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                    i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                    i_Old_Id     => r.Filial_Id),
                        i_Name          => r.Name,
                        i_State         => r.State,
                        i_Timezone_Code => r.Timezone_Code,
                        i_Order_No      => r.Order_No);
    
      r_Person.Company_Id := r_Filial.Company_Id;
      r_Person.Person_Id  := r_Filial.Filial_Id;
      r_Person.Name       := r_Filial.Name;
      r_Person.Short_Name := r_Filial.Name;
      r_Person.State      := r_Filial.State;
    
      Mr_Api.Legal_Person_Save(r_Person);
    
      Md_Api.Filial_Save(r_Filial);
    
      select Currency_Id
        into v_Currency_Id
        from Mk_Currencies
       where Company_Id = r_Filial.Company_Id
         and Pcode = 'ANOR:1';
    
      Mk_Api.Base_Currency_Save(i_Company_Id  => r_Filial.Company_Id,
                                i_Filial_Id   => r_Filial.Filial_Id,
                                i_Currency_Id => v_Currency_Id);
    
      Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                              i_Key_Name   => Hr5_Migr_Pref.c_Md_Filial,
                              i_Old_Id     => r.Filial_Id,
                              i_New_Id     => r_Filial.Filial_Id);
    
      insert into Md_User_Filials
        (Company_Id, User_Id, Filial_Id)
        select u.Company_Id, u.User_Id, r_Filial.Filial_Id as Filial_Id
          from Md_Users u
         where u.Company_Id = r_Filial.Company_Id
           and not exists (select *
                  from Md_User_Filials f
                 where f.Company_Id = r_Filial.Company_Id
                   and f.User_Id = u.User_Id
                   and f.Filial_Id = r_Filial.Filial_Id);
    end loop;
  
    Biruni_Route.Context_End;
    Hr5_Migr_Util.Clear;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Filials', 'finished Migr_Filials');
  end;

end Hr5_Migr_Md;
/
