PL/SQL Developer Test script 3.0
76
-- Created on 7/19/2022 by ADHAM 
declare
  v_Company_Id number := 680;
  v_Filial_Id  number := 36879;

  v_Unnecessary_Divs Array_Number := Array_Number(5631, 5582, 5654);
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  v_Unnecessary_Divs := v_Unnecessary_Divs multiset union
                        Href_Util.Get_Child_Divisions(i_Company_Id => v_Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_Parents    => v_Unnecessary_Divs);

  for i in 1 .. v_Unnecessary_Divs.Count
  loop
    Hrm_Api.Division_Manager_Delete(i_Company_Id  => v_Company_Id,
                                    i_Filial_Id   => v_Filial_Id,
                                    i_Division_Id => v_Unnecessary_Divs(i));
  end loop;

  update Mrf_Robots p
     set p.Manager_Id = null
   where p.Company_Id = v_Company_Id
     and p.Filial_Id = v_Filial_Id
     and p.Division_Id member of v_Unnecessary_Divs;

  for r in (select *
              from Href_Staffs p
             where p.Company_Id = v_Company_Id
               and p.Filial_Id = v_Filial_Id
               and p.Division_Id member of v_Unnecessary_Divs)
  loop
    Biruni_Route.Context_Begin;
    for Jp in (select Jr.*
                 from Hpd_Journal_Pages q
                 join Hpd_Journals Jr
                   on Jr.Company_Id = q.Company_Id
                  and Jr.Filial_Id = q.Filial_Id
                  and Jr.Journal_Id = q.Journal_Id
                  and Jr.Posted = 'Y'
                where q.Company_Id = r.Company_Id
                  and q.Filial_Id = r.Filial_Id
                  and q.Staff_Id = r.Staff_Id
                order by Jr.Journal_Date desc, Jr.Posted_Order_No desc)
    loop
      Hpd_Api.Journal_Unpost(i_Company_Id => Jp.Company_Id,
                             i_Filial_Id  => Jp.Filial_Id,
                             i_Journal_Id => Jp.Journal_Id);
    
      Hpd_Api.Journal_Delete(i_Company_Id => Jp.Company_Id,
                             i_Filial_Id  => Jp.Filial_Id,
                             i_Journal_Id => Jp.Journal_Id);
    end loop;
    Biruni_Route.Context_End;
  end loop;

  delete Mhr_Employees p
   where p.Company_Id = v_Company_Id
     and p.Filial_Id = v_Filial_Id
     and not exists (select *
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Filial_Id = p.Filial_Id
             and q.Employee_Id = p.Employee_Id);

  update Mrf_Persons p
     set p.State = 'P'
   where p.Company_Id = v_Company_Id
     and p.State = 'A'
     and not exists (select *
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Filial_Id = p.Filial_Id
             and q.Employee_Id = p.Person_Id);
end;
0
0
