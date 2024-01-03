prompt generating hpd_agreements_cache
----------------------------------------------------------------------------------------------------
insert into Hpd_Agreements_Cache
  (Company_Id, Filial_Id, Staff_Id, Begin_Date, End_Date, Robot_Id, Schedule_Id)
  select Qr.Company_Id,
         Qr.Filial_Id,
         Qr.Staff_Id,
         Qr.Period Begin_Date,
         Lead(Qr.Period - 1, 1, to_date('31.12.9999', 'dd.mm.yyyy')) Over(partition by Qr.Company_Id, Qr.Filial_Id, Qr.Staff_Id order by Qr.Period) End_Date,
         Last_Value(Qr.Robot_Id Ignore nulls) Over(partition by Qr.Company_Id, Qr.Filial_Id, Qr.Staff_Id order by Qr.Period) Robot_Id,
         Last_Value(Qr.Schedule_Id Ignore nulls) Over(partition by Qr.Company_Id, Qr.Filial_Id, Qr.Staff_Id order by Qr.Period) Schedule_Id
    from (select p.Company_Id,
                 p.Filial_Id,
                 p.Staff_Id,
                 p.Period,
                 max(Ts.Schedule_Id) Schedule_Id,
                 max(Tr.Robot_Id) Robot_Id
            from Hpd_Agreements p
            left join Hpd_Trans_Schedules Ts
              on Ts.Company_Id = p.Company_Id
             and Ts.Filial_Id = p.Filial_Id
             and Ts.Trans_Id = p.Trans_Id
            left join Hpd_Trans_Robots Tr
              on Tr.Company_Id = p.Company_Id
             and Tr.Filial_Id = p.Filial_Id
             and Tr.Trans_Id = p.Trans_Id
           where p.Trans_Type in ('B', 'S')
             and p.Action = 'C'
           group by p.Company_Id, p.Filial_Id, p.Staff_Id, p.Period) Qr;

update Hpd_Agreements_Cache p
   set p.End_Date =
       (select q.Dismissal_Date
          from Href_Staffs q
         where q.Company_Id = p.Company_Id
           and q.Filial_Id = p.Filial_Id
           and q.Staff_Id = p.Staff_Id)
 where exists (select 1
          from Href_Staffs q
         where q.Company_Id = p.Company_Id
           and q.Filial_Id = p.Filial_Id
           and q.Staff_Id = p.Staff_Id
           and q.Dismissal_Date between p.Begin_Date and p.End_Date);
commit;
