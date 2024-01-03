prompt migr from 26.07.2022
----------------------------------------------------------------------------------------------------
prompt nulling all manager_ids for robots where exist robot in verifix
----------------------------------------------------------------------------------------------------
update Mrf_Robots p
   set p.Manager_Id = null
 where exists (select 1
          from Hrm_Robots q
         where q.Company_Id = p.Company_Id
           and q.Filial_Id = p.Filial_Id
           and q.Robot_Id = p.Robot_Id);
commit;
