select *
  from (select Qr.Object_Name,
               Qr.Area_Name,
               Qr.Driver_Name,
               Least(Nvl(Qr.Weekly_Error_Median, 10000000000),
                     Nvl(Qr.Monthly_Error_Median, 10000000000),
                     Nvl(Qr.Quarterly_Error_Median, 10000000000),
                     Nvl(Qr.Yearly_Error_Median, 10000000000)) Minimal_Median,
               Qr.Weekly_Error_Median,
               Qr.Monthly_Error_Median,
               Qr.Quarterly_Error_Median,
               Qr.Yearly_Error_Median
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
                       /*avg(Abs(w.Fact_Value - q.Fact_Value) / case
                         when ((Abs(q.Fact_Value) + Abs(w.Fact_Value))) < 0.5 then
                          null
                         else
                          (Abs(q.Fact_Value) + Abs(w.Fact_Value))
                       end * 100)*/
                       null Weekly_Error_Median,
                       /*avg(Abs(m.Fact_Value - q.Fact_Value) / case
                         when (Abs(q.Fact_Value) + Abs(m.Fact_Value)) < 0.5 then
                          null
                         else
                          (Abs(q.Fact_Value) + Abs(m.Fact_Value))
                       end * 100)*/
                       null Monthly_Error_Median,
                       /*avg(Abs(r.Fact_Value - q.Fact_Value) / case
                         when (Abs(q.Fact_Value) + Abs(r.Fact_Value))  < 0.5 then
                          null
                         else
                          (Abs(q.Fact_Value) + Abs(r.Fact_Value)) 
                       end * 100) */
                       null Quarterly_Error_Median,
                       Median(Abs(y.Fact_Value - q.Fact_Value) / case
                                 when (Abs(q.Fact_Value) + Abs(y.Fact_Value)) < 0.5 then
                                  null
                                 else
                                  (Abs(q.Fact_Value) + Abs(y.Fact_Value))
                               end * 100) Yearly_Error_Median
                  from Hsc_Driver_Facts q
                  left join Hsc_Driver_Facts w
                    on w.Company_Id = &Company_Id
                   and w.Filial_Id = &Filial_Id
                   and w.Object_Id = q.Object_Id
                   and w.Area_Id = q.Area_Id
                   and w.Driver_Id = q.Driver_Id
                   and w.Fact_Type = 'W'
                   and w.Fact_Date = q.Fact_Date
                  left join Hsc_Driver_Facts m
                    on m.Company_Id = &Company_Id
                   and m.Filial_Id = &Filial_Id
                   and m.Object_Id = q.Object_Id
                   and m.Area_Id = q.Area_Id
                   and m.Driver_Id = q.Driver_Id
                   and m.Fact_Type = 'M'
                   and m.Fact_Date = q.Fact_Date
                  left join Hsc_Driver_Facts r
                    on r.Company_Id = &Company_Id
                   and r.Filial_Id = &Filial_Id
                   and r.Object_Id = q.Object_Id
                   and r.Area_Id = q.Area_Id
                   and r.Driver_Id = q.Driver_Id
                   and r.Fact_Type = 'Q'
                   and r.Fact_Date = q.Fact_Date
                  left join Hsc_Driver_Facts y
                    on y.Company_Id = &Company_Id
                   and y.Filial_Id = &Filial_Id
                   and y.Object_Id = q.Object_Id
                   and y.Area_Id = q.Area_Id
                   and y.Driver_Id = q.Driver_Id
                   and y.Fact_Type = 'Y'
                   and y.Fact_Date = q.Fact_Date
                 where q.Company_Id = &Company_Id
                   and q.Filial_Id = &Filial_Id
                   and q.Fact_Date between to_date('01.01.2023', 'dd.mm.yyyy') and Trunc(sysdate)
                   and q.Fact_Type = 'A'
                 group by q.Object_Id, q.Area_Id, q.Driver_Id) Qr) Bq
 where Bq.Minimal_Median > 20
 order by 4 desc
