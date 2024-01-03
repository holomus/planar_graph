PL/SQL Developer Test script 3.0
31
-- Created on 3/22/2022 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  for r in (select Owner,
                   Object_Name,
                   Object_Type,
                   Decode(Object_Type, 'PACKAGE', 1, 'PACKAGE BODY', 2, 'VIEW', 3, 4) as Recompile_Order
              from All_Objects
             where Object_Type in ('PACKAGE', 'PACKAGE BODY', 'VIEW', 'TRIGGER')
               and Status != 'VALID'
             order by 3)
  loop
    begin
      if r.Object_Type = 'PACKAGE' then
        execute immediate 'ALTER PACKAGE ' || r.Owner || '."' || r.Object_Name || '" COMPILE';
      elsif r.Object_Type = 'VIEW' then
        execute immediate 'ALTER VIEW ' || r.Owner || '."' || r.Object_Name || '" COMPILE';
      elsif r.Object_Type = 'PACKAGE BODY' then
        execute immediate 'ALTER PACKAGE ' || r.Owner || '."' || r.Object_Name || '" COMPILE BODY';
      else
        execute immediate 'ALTER TRIGGER ' || r.Owner || '."' || r.Object_Name || '" COMPILE';
      end if;
    exception
      when others then
        Dbms_Output.Put_Line(r.Object_Type || ' : ' || r.Object_Name);
    end;
  end loop;
end;
0
0
