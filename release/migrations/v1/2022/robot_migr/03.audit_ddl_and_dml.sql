prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt new page_robots_audit table
----------------------------------------------------------------------------------------------------
declare
begin
  Md_Api.Audit_Start_One(i_Company_Id  => Md_Pref.Company_Head,
                         i_Table_Name  => 'HPD_PAGE_ROBOTS',
                         i_Column_List => 'PAGE_ID,ROBOT_ID,RANK_ID,EMPLOYMENT_TYPE,FTE',
                         i_Parent_Name => 'HPD_JOURNAL_PAGES');
  Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_ROBOTS_I1',
                            i_Table_Name  => 'HPD_PAGE_ROBOTS',
                            i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
  Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_ROBOTS_I2',
                            i_Table_Name  => 'HPD_PAGE_ROBOTS',
                            i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt merge data from x_hpd_page_jobs to x_hpd_page_robots
----------------------------------------------------------------------------------------------------
declare
  v_Filial_Head number;
  r_Robot       Hpd_Page_Robots%rowtype;
begin
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
  
    for Fl in (select *
                 from Md_Filials q
                where q.Company_Id = Cmp.Company_Id
                  and q.Filial_Id <> v_Filial_Head
                  and q.State = 'A')
    loop
      insert into x_Hpd_Page_Robots
        (t_Company_Id,
         t_Audit_Id,
         t_Filial_Id,
         t_Event,
         t_Timestamp,
         t_Date,
         t_User_Id,
         t_Source_Project_Code,
         t_Session_Id,
         t_Context_Id,
         Page_Id,
         Robot_Id,
         Rank_Id,
         Employment_Type,
         Fte)
        select Pj.t_Company_Id, --
               Pj.t_Audit_Id, --
               Pj.t_Filial_Id, --
               Pj.t_Event, --
               Pj.t_Timestamp, --
               Pj.t_Date, --
               Pj.t_User_Id, --
               Pj.t_Source_Project_Code, --
               Pj.t_Session_Id, --
               Pj.t_Context_Id, --
               Pj.Page_Id, --
               Pr.Robot_Id, --
               Pj.Rank_Id, --
               Pj.Employment_Type, --
               Pr.Fte
          from x_Hpd_Page_Jobs Pj
          join Hpd_Page_Robots Pr
            on Pr.Company_Id = Pj.t_Company_Id
           and Pr.Filial_Id = Pj.t_Filial_Id
           and Pr.Page_Id = Pj.Page_Id
         where Pj.t_Company_Id = Fl.Company_Id
           and Pj.t_Filial_Id = Fl.Filial_Id;
    
      commit;
    end loop;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run('x_hpd_page_robots')
----------------------------------------------------------------------------------------------------
exec fazo_z.run('x_hpd_page_robots');
