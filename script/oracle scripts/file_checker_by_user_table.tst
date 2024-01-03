PL/SQL Developer Test script 3.0
38
-- Created on 3/5/2022 by ADHAM 
declare
  -- Local variables here
  i       integer;
  v_Cnt   number;
  v_Size  number;
  v_Val   Matrix_Varchar2 := Matrix_Varchar2();
  v_Owner varchar2(1000) := 'SMARTUP5_FCBARTGROUP';
begin
  -- Test statements here
  for r in (select (select w.Column_Name
                      from All_Cons_Columns w
                     where w.Owner = v_Owner
                       and w.Constraint_Name = q.Constraint_Name
                       and w.Position = 1) Col_Name,
                   q.*
              from All_Constraints q
             where q.Owner = v_Owner
               and q.Constraint_Type = 'R'
               and q.r_Constraint_Name = 'BIRUNI_FILES_PK')
  loop
    execute immediate 'select count(1), sum(file_size) from ' || r.Owner || '.biruni_files q join ' ||
                      r.Owner || '.' || r.Table_Name || ' w on q.sha = w.' || r.Col_Name
      into v_Cnt, v_Size;
  
    Fazo.Push(v_Val, Array_Varchar2(r.Table_Name, v_Cnt, Nvl(v_Size, 0)));
  end loop;

  for r in (select Fazo.Column_Varchar2(Column_Value, 1) Table_Name,
                   Fazo.Column_Varchar2(Column_Value, 2) Cnt,
                   Fazo.Column_Varchar2(Column_Value, 3) v_Size
              from table(cast(v_Val as Matrix_Varchar2))
             order by to_number(Fazo.Column_Varchar2(Column_Value, 3)) desc)
  loop
    Dbms_Output.Put_Line(Rpad(r.Table_Name, 30) || Rpad(r.Cnt, 15) ||
                         Round(to_number(r.v_Size) / 1024 / 1024 / 1024, 2));
  end loop;
end;
0
0
