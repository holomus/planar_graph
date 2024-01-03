PL/SQL Developer Test script 3.0
31
-- Created on 7/6/2022 by ADHAM 
declare
  -- Local variables here
  i            integer;
  v_Company_Id number := 620;
begin
  -- Test statements here
  for r in (select w.Column_Name, q.Table_Name
              from User_Constraints q
              join User_Cons_Columns w
                on q.Constraint_Name = w.Constraint_Name
             where q.r_Constraint_Name like 'BIRUNI_FILES_PK'
               and exists (select *
                      from User_Tab_Columns k
                     where k.Table_Name = q.Table_Name
                       and k.Column_Name = 'COMPANY_ID'))
  loop
    execute immediate 'insert into Md_Company_Files
  (Company_Id, Sha, Created_By, Created_On)
  select :company_id, q.' || r.Column_Name || ', :created_by, :created_on
    from ' || r.Table_Name || ' q
   where q.Company_Id = :company_id
     and q.' || r.Column_Name || ' is not null
     and not exists (select 1
            from Md_Company_Files w
           where w.Company_Id = :company_id
             and w.Sha = q.' || r.Column_Name || ')
   group by q.' || r.Column_Name
      using v_Company_Id, Md_Pref.User_System(v_Company_Id), Current_Timestamp, v_Company_Id, v_Company_Id;
  end loop;
end;
0
0
