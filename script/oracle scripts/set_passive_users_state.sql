update Md_Users k
   set k.State = 'P'
 where k.Company_Id = 480
   and k.User_Id in
       (select q.Employee_Id
          from Vx_Hr_Employees q
         where q.Company_Id = 480
           and q.c_Division_Id in (select w.Division_Id
                                     from Vx_Hr_Divisions w
                                    where w.Company_Id = 480
                                      and w.State = 'A'
                                    start with w.Division_Id = 1309
                                   connect by prior w.Division_Id = w.Parent_Id)
           and exists (select *
                  from Vx_Org_Persons w
                 where w.Person_Id = q.Employee_Id
                   and w.State = 'A'));
