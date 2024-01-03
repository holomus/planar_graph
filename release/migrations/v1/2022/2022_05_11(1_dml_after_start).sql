prompt migr from 11.05.2022
----------------------------------------------------------------------------------------------------
declare
  r_Journal_Types Hpd_Journal_Types%rowtype;
  v_Pcode_Like    varchar2(10) := Upper(Href_Pref.c_Pc_Verifix_Hr) || '%';
  v_Query         varchar2(4000);
begin
  -- add default journal types
  for Cmp in (select c.Company_Id, c.Lang_Code
                from Md_Companies c)
  loop
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Journal_Types,
                                                i_Lang_Code => Cmp.Lang_Code);
  
    for r in (select *
                from Hpd_Journal_Types t
               where t.Company_Id = Cmp.Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Journal_Types := r;
    
      execute immediate v_Query
        using in r_Journal_Types, out r_Journal_Types;
    
      z_Hpd_Journal_Types.Update_One(i_Company_Id      => r_Journal_Types.Company_Id,
                                     i_Journal_Type_Id => r_Journal_Types.Journal_Type_Id,
                                     i_Name            => Option_Varchar2(r_Journal_Types.Name));
    end loop;
  end loop;
  
  -- table record fix
  z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name  => 'HTT_CALENDARS',
                                                i_Column_Set  => 'NAME',
                                                i_Extra_Where => 'FILIAL_ID = MD_PREF.FILIAL_HEAD(MD_PREF.COMPANY_HEAD)');
  
  commit;
end;
/
