declare
  v_Company_Head number := Md_Pref.c_Company_Head;

  --------------------------------------------------
  Procedure Default_Role
  (
    i_Company_Id varchar2,
    i_Name       varchar2,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    v_Role_Id number;
  begin
    begin
      select Role_Id
        into v_Role_Id
        from Md_Roles
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Role_Id := Md_Next.Role_Id;
    end;
  
    z_Md_Roles.Save_One(i_Company_Id => i_Company_Id,
                        i_Role_Id    => v_Role_Id,
                        i_Name       => i_Name,
                        i_State      => 'A',
                        i_Order_No   => i_Order_No,
                        i_Pcode      => i_Pcode);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);

  --------------------------------------------------
  Dbms_Output.Put_Line('==== Default Roles ====');
  Default_Role(v_Company_Head, 'Рекрутер', 6, Href_Pref.c_Pcode_Role_Recruiter);

  ----------------------------------------------------------------------------------------------------
  for c in (select *
              from Md_Companies t
             where t.Company_Id <> v_Company_Head)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => c.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(c.Company_Id),
                         i_User_Id      => Md_Pref.User_System(c.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    -- role
    Default_Role(c.Company_Id, 'Рекрутер', 6, Href_Pref.c_Pcode_Role_Recruiter);
  end loop;
  commit;
end;
/
