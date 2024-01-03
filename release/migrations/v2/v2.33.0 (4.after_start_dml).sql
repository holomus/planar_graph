prompt adding multiple application transfers
---------------------------------------------------------------------------------------------------- 
declare
  v_Company_Head     number := Md_Pref.c_Company_Head;
  v_Query            varchar2(4000);
  r_Application_Type Hpd_Application_Types%rowtype;
  --------------------------------------------------
  Procedure Application_Type
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Application_Type_Id number;
  begin
    begin
      select Application_Type_Id
        into v_Application_Type_Id
        from Hpd_Application_Types
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Application_Type_Id := Hpd_Next.Application_Type_Id;
    end;
  
    z_Hpd_Application_Types.Save_One(i_Company_Id          => v_Company_Head,
                                     i_Application_Type_Id => v_Application_Type_Id,
                                     i_Name                => i_Name,
                                     i_Order_No            => i_Order_No,
                                     i_Pcode               => i_Pcode);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);

  --------------------------------------------------
  Dbms_Output.Put_Line('==== Application Types ====');
  Application_Type('Кадровый перевод списком',
                   4,
                   Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple);

  --------------------------------------------------
  for c in (select *
              from Md_Companies t
             where t.Company_Id <> v_Company_Head
               and t.State = 'A')
  loop
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Application_Types,
                                                i_Lang_Code => z_Md_Companies.Load(c.Company_Id).Lang_Code);
  
    for r in (select *
                from Hpd_Application_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode = Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple
               order by t.Order_No)
    loop
      r_Application_Type                     := r;
      r_Application_Type.Company_Id          := c.Company_Id;
      r_Application_Type.Application_Type_Id := Hpd_Next.Application_Type_Id;
    
      execute immediate v_Query
        using in r_Application_Type, out r_Application_Type;
    
      z_Hpd_Application_Types.Save_Row(r_Application_Type);
    end loop;
  end loop;

  --------------------------------------------------
  update Hpd_Application_Types t
     set t.Order_No = 4
   where t.Pcode = Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple;

  update Hpd_Application_Types t
     set t.Order_No = 5
   where t.Pcode = Hpd_Pref.c_Pcode_Application_Type_Dismissal;

  commit;
end;
/

---------------------------------------------------------------------------------------------------- 
prompt add new audit for HPD
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    Hpd_Audit.Journal_Stop(i_Company_Id => r.Company_Id);
    Hpd_Audit.Journal_Start(i_Company_Id => r.Company_Id);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run('x_h');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('x_h');
