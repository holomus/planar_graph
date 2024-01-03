PL/SQL Developer Test script 3.0
32
declare
  v_Company_Id number := 184;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select distinct t.Table_Name, t.Column_Name
              from Md_Table_Record_Translates t
             where t.Table_Name like 'H%'
                or t.Table_Name like 'MPR%')
  loop
    begin
      execute immediate 'update ' || r.Table_Name || ' t
                            set t.' || r.Column_Name || ' =
                                (select s.val
                                   from md_table_record_translates s
                                  where s.table_name = ''' || r.Table_Name || '''
                                    and s.column_name = ''' || r.Column_Name || '''
                                    and s.lang_code = ''en''
                                    and s.pcode = t.pcode)
                          where t.company_id = ' || v_Company_Id || '
                            and exists (select s.val
                                   from md_table_record_translates s
                                  where s.table_name = ''' || r.Table_Name || '''
                                    and s.column_name = ''' || r.Column_Name || '''
                                    and s.lang_code = ''en''
                                    and s.pcode = t.pcode)';
    exception
      when others then
        Dbms_Output.Put_Line(sqlerrm);
    end;
  end loop;
end;
0
0
