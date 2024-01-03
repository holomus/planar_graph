prompt migr from 25.04.2023 v2.23.0 (2.dml)
----------------------------------------------------------------------------------------------------
insert into Htm_Experience_Job_Ranks
  (Company_Id, Filial_Id, Job_Id, From_Rank_Id, To_Rank_Id, Period, Nearest, Experience_Id)
  select q.Company_Id,
         q.Filial_Id,
         q.Job_Id,
         p.From_Rank_Id,
         p.To_Rank_Id,
         p.Period,
         p.Nearest,
         q.Experience_Id
    from Htm_Experience_Jobs q
    join Htm_Experience_Periods p
      on p.Company_Id = q.Company_Id
     and p.Filial_Id = q.Filial_Id
     and p.Experience_Id = q.Experience_Id;
commit;
