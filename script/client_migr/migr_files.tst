PL/SQL Developer Test script 3.0
32
declare
  v Array_Varchar2;
begin
  while true
  loop
    select q.Sha
      bulk collect
      into v
      from Verifix.Migr_Biruni_Filespace q
     where not exists (select 1
              from Biruni_Filespace_Controller w
             where w.Sha = q.Sha)
       and Rownum < 1000;
  
    exit when v.Count = 0;
  
    forall i in 1 .. v.Count
      insert into Biruni_Filespace_Controller
        (Sha)
      values
        (v(i));
  
    forall i in 1 .. v.Count
      insert into Biruni_Filespace
        (Sha, File_Content)
        select q.Sha, q.File_Content
          from Verifix.Migr_Biruni_Filespace q
         where q.Sha = v(i);
    commit;
    Dbms_Lock.Sleep(Seconds => 2);
  end loop;
end;
0
0
