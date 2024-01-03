prompt adding vacancy names
----------------------------------------------------------------------------------------------------  
update Hrec_Vacancies w
   set w.Name =
       (select q.Name
          from Mhr_Jobs q
         where q.Company_Id = w.Company_Id
           and q.Filial_Id = w.Filial_Id
           and q.Job_Id = w.Job_Id);
commit;          
