prompt fix to org struct correction
----------------------------------------------------------------------------------------------------
update Hrm_Robots q
   set q.Org_Unit_Id =
       (select Rb.Division_Id
          from Mrf_Robots Rb
         where Rb.Company_Id = q.Company_Id
           and Rb.Filial_Id = q.Filial_Id
           and Rb.Robot_Id = q.Robot_Id)
 where exists (select 1
          from Mrf_Robots Rb
          join Hrm_Divisions p
            on p.Company_Id = q.Company_Id
           and p.Filial_Id = q.Filial_Id
           and p.Division_Id = q.Org_Unit_Id
         where Rb.Company_Id = q.Company_Id
           and Rb.Filial_Id = q.Filial_Id
           and Rb.Robot_Id = q.Robot_Id
           and (p.Is_Department = 'Y' and Rb.Division_Id <> q.Org_Unit_Id or
               p.Is_Department = 'N' and Rb.Division_Id <> p.Parent_Department_Id));
commit;               
