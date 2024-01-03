PL/SQL Developer Test script 3.0
55
-- Created on 1/6/2023 by ADHAM 
declare
  v_Company_Id number := 580;

  v_Journal           Hpd_Pref.Dismissal_Journal_Rt;
  v_Dismissal_Type_Id number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                         i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select *
              from (select (select max(w.Track_Date)
                              from Htt_Tracks w
                             where w.Person_Id = p.Employee_Id) Max_Track_Date,
                           p.*
                      from Href_Staffs p
                     where p.Company_Id = 580
                       and p.Dismissal_Date is null
                       and exists (select *
                              from Mhr_Employees q
                             where q.Company_Id = 580
                               and q.Filial_Id = p.Filial_Id
                               and q.Employee_Id = p.Employee_Id
                               and q.State = 'P')) Qr
             where Qr.Max_Track_Date is null
               and Rownum = 1)
  loop
    Hpd_Util.Dismissal_Journal_New(o_Journal         => v_Journal,
                                   i_Company_Id      => r.Company_Id,
                                   i_Filial_Id       => r.Filial_Id,
                                   i_Journal_Id      => Hpd_Next.Journal_Id,
                                   i_Journal_Type_Id => v_Dismissal_Type_Id,
                                   i_Journal_Number  => null,
                                   i_Journal_Date    => Trunc(sysdate),
                                   i_Journal_Name    => null);
  
    Hpd_Util.Journal_Add_Dismissal(p_Journal              => v_Journal,
                                   i_Page_Id              => Hpd_Next.Page_Id,
                                   i_Staff_Id             => r.Staff_Id,
                                   i_Dismissal_Date       => Trunc(sysdate),
                                   i_Dismissal_Reason_Id  => null,
                                   i_Employment_Source_Id => null,
                                   i_Based_On_Doc         => null,
                                   i_Note                 => null);
  
    Hpd_Api.Dismissal_Journal_Save(v_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                         i_Filial_Id  => v_Journal.Filial_Id,
                         i_Journal_Id => v_Journal.Journal_Id);
  end loop;

  Biruni_Route.Context_End;
end;
0
0
