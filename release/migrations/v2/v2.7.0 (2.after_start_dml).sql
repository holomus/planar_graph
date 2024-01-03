prompt migr from 23.09.2022 (2.after_start_dml)
----------------------------------------------------------------------------------------------------
prompt inserting phone numbers to md_persons
----------------------------------------------------------------------------------------------------
declare
begin
  biruni_route.Clear_Globals;
  Ui_Auth.Logon_As_System(Md_Pref.Company_Head);

  update Md_Persons p
     set p.Phone =
         (select substr(Regexp_Replace(Pd.Main_Phone, '\D', ''), 1, 12)
            from Mr_Person_Details Pd
           where Pd.Company_Id = p.Company_Id
             and Pd.Person_Id = p.Person_Id)
   where exists (select 1
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Employee_Id = p.Person_Id)
     and exists (select 1
            from Mr_Person_Details w
           where w.Company_Id = p.Company_Id
             and w.Person_Id = p.Person_Id
             and w.Main_Phone is not null);
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt creating intervals
----------------------------------------------------------------------------------------------------
insert into Hlic_Required_Intervals
  (Company_Id, Filial_Id, Interval_Id, Staff_Id, Employee_Id, Start_Date, Finish_Date, Status)
  select p.Company_Id,
         p.Filial_Id,
         Hlic_Required_Intervals_Sq.Nextval,
         p.Staff_Id,
         p.Employee_Id,
         p.Hiring_Date,
         p.Dismissal_Date,
         case
           when p.Dismissal_Date is null then
            'C'
           else
            'S'
         end
    from Href_Staffs p
   where p.Staff_Kind = 'P'
     and p.State = 'A';
commit;


---------------------------------------------------------------------------------------------------- 
prompt generating licenses
---------------------------------------------------------------------------------------------------- 
declare
begin
  Hlic_Core.Generate;
end;
/

----------------------------------------------------------------------------------------------------
prompt add Timepad role for all companies
---------------------------------------------------------------------------------------------------- 
declare
  v_Role_Id        number;
  v_Person_Id      number;
  v_Filial_Head_Id number;
begin
  for r in (select *
              from Md_Companies)
  loop
    v_Filial_Head_Id := Md_Pref.Filial_Head(r.Company_Id);
  
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => v_Filial_Head_Id,
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    v_Role_Id   := Md_Next.Role_Id;
    v_Person_Id := Md_Next.Person_Id;
  
    z_Md_Persons.Insert_One(i_Company_Id  => r.Company_Id,
                            i_Person_Id   => v_Person_Id,
                            i_Name        => 'Timepad',
                            i_Person_Kind => Md_Pref.c_Pk_Virtual,
                            i_Email       => null,
                            i_Photo_Sha   => null,
                            i_State       => 'A',
                            i_Code        => null,
                            i_Phone       => null);
  
    z_Md_Users.Insert_One(i_Company_Id               => r.Company_Id,
                          i_User_Id                  => v_Person_Id,
                          i_Name                     => 'Timepad',
                          i_Login                    => null,
                          i_Password                 => null,
                          i_State                    => 'A',
                          i_User_Kind                => Md_Pref.c_Uk_Virtual,
                          i_Gender                   => null,
                          i_Manager_Id               => null,
                          i_Timezone_Code            => null,
                          i_Password_Changed_On      => null,
                          i_Password_Change_Required => null,
                          i_Order_No                 => null);
  
    z_Href_Timepad_Users.Insert_One(i_Company_Id => r.Company_Id, i_User_Id => v_Person_Id);
  
    z_Md_Roles.Insert_One(i_Company_Id => r.Company_Id,
                          i_Role_Id    => v_Role_Id,
                          i_Name       => 'Timepad',
                          i_State      => 'A',
                          i_Order_No   => 5,
                          i_Pcode      => Href_Pref.c_Pcode_Role_Timepad);
  
    -- attach role for filial head
    Biruni_Route.Context_Begin;
  
    Md_Api.Role_Grant(i_Company_Id => r.Company_Id,
                      i_User_Id    => v_Person_Id,
                      i_Filial_Id  => v_Filial_Head_Id,
                      i_Role_Id    => v_Role_Id);
  
    Biruni_Route.Context_End;
  end loop;

  commit;
end;
/

