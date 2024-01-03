PL/SQL Developer Test script 3.0
29
-- Created on 3/9/2022 by ADHAM 
declare
  -- Local variables here
  i     integer;
  v_Cnt number;
  v_Sum number;
  v_Val Matrix_Varchar2 := Matrix_Varchar2();
begin
  -- Test statements here
  for r in (select *
              from All_Users q
             where q.Username like 'SMARTUP%')
  loop
    execute immediate 'select count(1), sum(file_size) from ' || r.Username || '.biruni_files'
      into v_Cnt, v_Sum;
  
    Fazo.Push(v_Val, Array_Varchar2(r.Username, v_Cnt, Nvl(v_Sum, 0)));
  end loop;

  for r in (select Fazo.Column_Varchar2(Column_Value, 1) Username,
                   Fazo.Column_Varchar2(Column_Value, 2) Cnt,
                   Fazo.Column_Varchar2(Column_Value, 3) v_Size
              from table(cast(v_Val as Matrix_Varchar2))
             order by to_number(Fazo.Column_Varchar2(Column_Value, 3)) desc)
  loop
    Dbms_Output.Put_Line(Rpad(r.Username, 30) || Rpad(r.Cnt, 15) ||
                         Round(to_number(r.v_Size) / 1024 / 1024 / 1024, 2));
  end loop;
end;
0
0
