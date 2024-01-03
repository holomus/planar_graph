prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt creating robots
---------------------------------------------------------------------------------------------------- 
declare
  v_Filial_Head number;
  v_User_System number;

  v_Robot    Hrm_Pref.Robot_Rt;
  v_Robot_Id number;

  -------------------------------------------------- 
  Function Robot_Name
  (
    i_Robot_Code    varchar2,
    i_Division_Name varchar2,
    i_Job_Name      varchar2,
    i_Rank_Name     varchar2
  ) return varchar2 is
    result varchar2(200 char);
  begin
    result := '/' || i_Division_Name || '/(' || i_Robot_Code || ')';
  
    if i_Rank_Name is not null then
      result := ', ' || i_Rank_Name || result;
    end if;
  
    return i_Job_Name || result;
  end;

begin
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
    v_User_System := Md_Pref.User_System(Cmp.Company_Id);
  
    for Fil in (select p.Filial_Id
                  from Md_Filials p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id <> v_Filial_Head
                   and p.State = 'A')
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => v_User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for r in (select Pj.*,
                       Nvl(Hh.Hiring_Date, Tf.Transfer_Begin) Begin_Date,
                       Tf.Transfer_End End_Date,
                       (select p.Name
                          from Mhr_Divisions p
                         where p.Company_Id = Pj.Company_Id
                           and p.Filial_Id = Pj.Filial_Id
                           and p.Division_Id = Pj.Division_Id) Div_Name,
                       (select q.Name
                          from Mhr_Jobs q
                         where q.Company_Id = Pj.Company_Id
                           and q.Filial_Id = Pj.Filial_Id
                           and q.Job_Id = Pj.Job_Id) Job_Name,
                       (select k.Name
                          from Mhr_Ranks k
                         where k.Company_Id = Pj.Company_Id
                           and k.Filial_Id = Pj.Filial_Id
                           and k.Rank_Id = Pj.Rank_Id) Rank_Name,
                       (select Ps.Schedule_Id
                          from Hpd_Page_Schedules Ps
                         where Ps.Company_Id = Pj.Company_Id
                           and Ps.Filial_Id = Pj.Filial_Id
                           and Ps.Page_Id = Pj.Page_Id) Schedule_Id
                  from Hpd_Page_Jobs Pj
                  left join Hpd_Hirings Hh
                    on Hh.Company_Id = Pj.Company_Id
                   and Hh.Filial_Id = Pj.Filial_Id
                   and Hh.Page_Id = Pj.Page_Id
                  left join Hpd_Transfers Tf
                    on Tf.Company_Id = Pj.Company_Id
                   and Tf.Filial_Id = Pj.Filial_Id
                   and Tf.Page_Id = Pj.Page_Id
                 where Pj.Company_Id = Cmp.Company_Id
                   and Pj.Filial_Id = Fil.Filial_Id)
      loop
        v_Robot_Id := Mrf_Next.Robot_Id;
      
        Hrm_Util.Robot_New(o_Robot                => v_Robot,
                           i_Company_Id           => r.Company_Id,
                           i_Filial_Id            => r.Filial_Id,
                           i_Robot_Id             => v_Robot_Id,
                           i_Name                 => Robot_Name(i_Robot_Code    => v_Robot_Id,
                                                                i_Division_Name => r.Div_Name,
                                                                i_Job_Name      => r.Job_Name,
                                                                i_Rank_Name     => r.Rank_Name),
                           i_Code                 => null,
                           i_Robot_Group_Id       => null,
                           i_Division_Id          => r.Division_Id,
                           i_Job_Id               => r.Job_Id,
                           i_State                => 'A',
                           i_Opened_Date          => r.Begin_Date,
                           i_Closed_Date          => r.End_Date,
                           i_Schedule_Id          => r.Schedule_Id,
                           i_Rank_Id              => r.Rank_Id,
                           i_Vacation_Days_Limit  => null,
                           i_Labor_Function_Id    => r.Labor_Function_Id,
                           i_Description          => 'migrated robot',
                           i_Hiring_Condition     => null,
                           i_Contractual_Wage     => 'Y',
                           i_Wage_Scale_Id        => null,
                           i_Allowed_Division_Ids => Array_Number());
      
        Hrm_Api.Robot_Save(v_Robot);
      
        z_Hpd_Page_Robots.Insert_One(i_Company_Id      => r.Company_Id,
                                     i_Filial_Id       => r.Filial_Id,
                                     i_Page_Id         => r.Page_Id,
                                     i_Robot_Id        => v_Robot_Id,
                                     i_Division_Id     => r.Division_Id,
                                     i_Job_Id          => r.Job_Id,
                                     i_Rank_Id         => null,
                                     i_Employment_Type => r.Employment_Type,
                                     i_Fte             => r.Quantity);
      end loop;
    
      commit;
    end loop;
  end loop;
end;
/
