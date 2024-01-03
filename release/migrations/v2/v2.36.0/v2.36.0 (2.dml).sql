prompt change staffs employment type 
----------------------------------------------------------------------------------------------------  
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------  
begin
  update Href_Staffs St
     set St.Employment_Type =
         (select Tr.Employment_Type
            from Hpd_Agreements q
            join Hpd_Trans_Robots Tr
              on Tr.Company_Id = q.Company_Id
             and Tr.Filial_Id = q.Filial_Id
             and Tr.Trans_Id = q.Trans_Id
           where q.Company_Id = St.Company_Id
             and q.Filial_Id = St.Filial_Id
             and q.Staff_Id = St.Staff_Id
             and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
             and q.Action = Hpd_Pref.c_Transaction_Action_Continue
             and q.Period = (select max(w.Period)
                               from Hpd_Agreements w
                              where w.Company_Id = St.Company_Id
                                and w.Filial_Id = St.Filial_Id
                                and w.Staff_Id = St.Staff_Id
                                and w.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                                and w.Action = Hpd_Pref.c_Transaction_Action_Continue
                                and w.Period <= Trunc(sysdate)))
   where St.State = 'A';

  update Href_Staffs St
     set St.Employment_Type =
         (select Pr.Employment_Type
            from Hpd_Hirings q
            join Hpd_Page_Robots Pr
              on Pr.Company_Id = q.Company_Id
             and Pr.Filial_Id = q.Filial_Id
             and Pr.Page_Id = q.Page_Id
           where q.Company_Id = St.Company_Id
             and q.Filial_Id = St.Filial_Id
             and q.Staff_Id = St.Staff_Id)
   where St.State = 'P';
  commit;
end;
/

----------------------------------------------------------------------------------------------------  
prompt update robot position employment kind
----------------------------------------------------------------------------------------------------  
update hrm_robots q
   set q.position_employment_kind = 'S';
commit;

----------------------------------------------------------------------------------------------------  
prompt update hpd_cv_contracts.contract_employment_kind
----------------------------------------------------------------------------------------------------  
update hpd_cv_contracts q
   set q.contract_employment_kind = 'F';
commit;

----------------------------------------------------------------------------------------------------  
prompt update description and description in html columns
----------------------------------------------------------------------------------------------------  
update Hrec_Vacancies w
   set Description        =
       (select q.Responsibilities || ' ' || q.Requirements || ' ' || q.Note
          from Hrec_Vacancies q
         where q.Company_Id = w.Company_Id
           and q.Filial_Id = w.Filial_Id
           and q.Vacancy_Id = w.Vacancy_Id),
       Description_In_Html =
       (select '<p>' || q.Responsibilities || '</p>' || --
               '<p>' || q.Requirements || '</p>' || --
               '<p>' || q.Note || '</p>'
          from Hrec_Vacancies q
         where q.Company_Id = w.Company_Id
           and q.Filial_Id = w.Filial_Id
           and q.Vacancy_Id = w.Vacancy_Id);
commit;

----------------------------------------------------------------------------------------------------  
prompt columns filled by default value
----------------------------------------------------------------------------------------------------
update htt_calendars 
   set monthly_limit = 'N',
       daily_limit   = 'N';
commit;



