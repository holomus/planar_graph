PL/SQL Developer Test script 3.0
36
-- Created on 3/5/2022 by ADHAM 
declare
  -- Local variables here
  i      integer;
  v_Cnt  number;
  v_Size number;
  v_Val  Matrix_Varchar2 := Matrix_Varchar2();
begin
  -- Test statements here
  for r in (select (select w.Column_Name
                      from User_Cons_Columns w
                     where w.Constraint_Name = q.Constraint_Name
                       and w.Position = 1) Col_Name,
                   q.*
              from User_Constraints q
             where q.Constraint_Type = 'R'
               and q.r_Constraint_Name = 'BIRUNI_FILES_PK')
  loop
    execute immediate 'select count(1), sum(file_size) from biruni_files q join ' || r.Table_Name ||
                      ' w on q.sha = w.' || r.Col_Name ||
                      ' where exists(select 1 from biruni_filespace k where k.sha = q.sha)'
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
