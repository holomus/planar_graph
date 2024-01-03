select Qr.Subcompany_Id,
       (select Dv.Name
          from Old_Vx_Hr_Divisions Dv
         where Dv.Company_Id = 480
           and Dv.Division_Id = Qr.Subcompany_Id) Subname,
       count(*)
  from (select q.Employee_Id,
               q.Name,
               p.Division_Id,
               q.Subcompany_Id,
               (select Dv.Division_Id
                  from Old_Vx_Hr_Divisions Dv
                 where Dv.Company_Id = p.Company_Id
                   and Connect_By_Isleaf = 1
                 start with Dv.Division_Id = p.Division_Id
                connect by Dv.Division_Id = prior Dv.Parent_Id) Parent_Div
          from Old_Vx_Hr_Employees q
          join Old_Vx_Hr_Emp_Jobs p
            on p.Company_Id = q.Company_Id
           and p.Employee_Id = q.Employee_Id
           and p.Begin_Date = (select max(w.Begin_Date)
                                 from Old_Vx_Hr_Emp_Jobs w
                                where w.Company_Id = q.Company_Id
                                  and w.Employee_Id = q.Employee_Id)
         where q.Company_Id = 480) Qr
 where Qr.Parent_Div <> Qr.Subcompany_Id
 group by Qr.Subcompany_Id
 order by 3 desc
