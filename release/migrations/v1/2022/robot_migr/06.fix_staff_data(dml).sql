prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt staff data update
----------------------------------------------------------------------------------------------------  
begin
  Dbms_Output.Put_Line('==== Staffs columns update ====');
  -------------------------------------------------- 
  for Fil in (select *
                from Md_Filials)
  loop
    delete Href_Staffs s
     where s.Company_Id = Fil.Company_Id
       and s.Filial_Id = Fil.Filial_Id
       and not exists (select 1
              from Hpd_Journal_Pages Jp
             where Jp.Company_Id = s.Company_Id
               and Jp.Filial_Id = s.Filial_Id
               and Jp.Staff_Id = s.Staff_Id);
  
    update Href_Staffs s
       set s.State      = 'A',
           s.Staff_Kind =
           (select q.Line_Kind
              from Hpd_Staff_Lines q
             where s.Company_Id = q.Company_Id
               and s.Filial_Id = q.Filial_Id
               and s.Staff_Id = q.Staff_Id
               and Rownum = 1),
           s.Robot_Id   = null
     where s.Company_Id = Fil.Company_Id
       and s.Filial_Id = Fil.Filial_Id
       and s.Status <> 'U';
  
    update Href_Staffs s
       set s.State = 'P',
           (s.Staff_Kind,
            s.Hiring_Date,
            s.Robot_Id,
            s.Division_Id,
            s.Job_Id,
            s.Fte,
            s.Rank_Id,
            s.Schedule_Id) =
           ((select Decode(Pr.Employment_Type, 'I', 'S', 'P'),
                    (select Hh.Hiring_Date
                       from Hpd_Hirings Hh
                      where Hh.Company_Id = Jp.Company_Id
                        and Hh.Filial_Id = Jp.Filial_Id
                        and Hh.Page_Id = Jp.Page_Id),
                    Mr.Robot_Id,
                    Mr.Division_Id,
                    Mr.Job_Id,
                    Pr.Fte,
                    Pr.Rank_Id,
                    (select Ps.Schedule_Id
                       from Hpd_Page_Schedules Ps
                      where Ps.Company_Id = Jp.Company_Id
                        and Ps.Filial_Id = Jp.Filial_Id
                        and Ps.Page_Id = Jp.Page_Id)
               from Hpd_Journal_Pages Jp
               join Hpd_Page_Robots Pr
                 on Pr.Company_Id = s.Company_Id
                and Pr.Filial_Id = s.Filial_Id
                and Pr.Page_Id = Jp.Page_Id
               join Mrf_Robots Mr
                 on Mr.Company_Id = s.Company_Id
                and Mr.Filial_Id = s.Filial_Id
                and Mr.Robot_Id = Pr.Robot_Id
              where Jp.Company_Id = s.Company_Id
                and Jp.Filial_Id = s.Filial_Id
                and Jp.Staff_Id = s.Staff_Id
                and Rownum = 1))
     where s.Company_Id = Fil.Company_Id
       and s.Filial_Id = Fil.Filial_Id
       and s.Status = 'U';
  
    update Href_Staffs s
       set s.Parent_Id =
           (select p.Staff_Id
              from Href_Staffs p
             where p.Company_Id = s.Company_Id
               and p.Filial_Id = s.Filial_Id
               and p.Employee_Id = s.Employee_Id
               and p.State = 'A'
               and p.Staff_Kind = 'P'
               and p.Hiring_Date = (select max(P1.Hiring_Date)
                                      from Href_Staffs P1
                                     where P1.Company_Id = s.Company_Id
                                       and P1.Filial_Id = s.Filial_Id
                                       and P1.Employee_Id = s.Employee_Id
                                       and P1.State = 'A'
                                       and P1.Staff_Kind = 'P'
                                       and P1.Hiring_Date <= s.Hiring_Date))
     where s.Company_Id = Fil.Company_Id
       and s.Filial_Id = Fil.Filial_Id
       and s.Staff_Kind = 'S';
  
    commit;
  end loop;
end;
/
