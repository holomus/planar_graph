select Qr.Object_Name, Qr.Area_Name, Qr.Driver_Name, Qr.Fact_Type, Qr.Error_Median
  from (select (select Dv.Name
                  from Mhr_Divisions Dv
                 where Dv.Company_Id = &Company_Id
                   and Dv.Filial_Id = &Filial_Id
                   and Dv.Division_Id = q.Object_Id) Object_Name,
               (select Ar.Name
                  from Hsc_Areas Ar
                 where Ar.Company_Id = &Company_Id
                   and Ar.Filial_Id = &Filial_Id
                   and Ar.Area_Id = q.Area_Id) Area_Name,
               (select Dr.Name
                  from Hsc_Drivers Dr
                 where Dr.Company_Id = &Company_Id
                   and Dr.Filial_Id = &Filial_Id
                   and Dr.Driver_Id = q.Driver_Id) Driver_Name,
               q.Fact_Type,
               Median(Abs(q.Fact_Value - p.Fact_Value) / case
                         when Abs(p.Fact_Value) < 0.5 then
                          null
                         else
                          Abs(p.Fact_Value)
                       end * 100) Error_Median
          from Hsc_Driver_Facts q
          join Hsc_Driver_Facts p
            on p.Company_Id = &Company_Id
           and p.Filial_Id = &Filial_Id
           and p.Object_Id = q.Object_Id
           and p.Area_Id = q.Area_Id
           and p.Driver_Id = q.Driver_Id
           and p.Fact_Type = 'A'
           and p.Fact_Date = q.Fact_Date
         where q.Company_Id = &Company_Id
           and q.Filial_Id = &Filial_Id
           and q.Fact_Date between to_date('01.01.2023', 'dd.mm.yyyy') and Trunc(sysdate)
           and q.Fact_Type in ('W', 'M', 'Q', 'Y')
         group by q.Object_Id, q.Area_Id, q.Driver_Id, q.Fact_Type) Qr
 where Qr.Error_Median > 20
