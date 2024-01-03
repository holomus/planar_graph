create or replace package Ui_Vhr664 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr664;
/
create or replace package body Ui_Vhr664 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR664:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Main_Robot
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Mrf_Robots%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Mrf_Robots t
               where t.t_Company_Id = v_Company_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Mrf_Robots t
                 where t.t_Company_Id = v_Company_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Mrf_Robots.Difference(r, r_Last);
    
      Get_Difference(z.Robot_Group_Id,
                     t('robot group name'),
                     z_Mr_Robot_Groups.Take(i_Company_Id => v_Company_Id, i_Robot_Group_Id => r_Last.Robot_Group_Id).Name,
                     z_Mr_Robot_Groups.Take(i_Company_Id => v_Company_Id, i_Robot_Group_Id => r.Robot_Group_Id).Name);
    
      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.Code, t('code'), r_Last.Code, r.Code);
      Get_Difference(z.Person_Id,
                     t('person name'),
                     z_Md_Persons.Take(i_Company_Id => v_Company_Id, i_Person_Id => r_Last.Person_Id).Name,
                     z_Md_Persons.Take(i_Company_Id => v_Company_Id, i_Person_Id => r.Person_Id).Name);
      Get_Difference(z.Division_Id,
                     t('division name'),
                     z_Mhr_Divisions.Take(i_Company_Id => v_Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Last.Division_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => v_Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r.Division_Id).Name);
      Get_Difference(z.Job_Id,
                     t('job name'),
                     z_Mhr_Jobs.Take(i_Company_Id => v_Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => r_Last.Job_Id).Name,
                     z_Mhr_Jobs.Take(i_Company_Id => v_Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => r.Job_Id).Name);
      Get_Difference(z.Manager_Id,
                     t('manager name'),
                     z_Mrf_Robots.Take(i_Company_Id => v_Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => r_Last.Manager_Id).Name,
                     z_Mrf_Robots.Take(i_Company_Id => v_Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => r.Manager_Id).Name);
    
      if z.State member of v_Diff_Columns then
        Fazo.Push(v_Data,
                  t('state'),
                  Md_Util.Decode(r_Last.State, 'A', Ui.t_Active, 'P', Ui.t_Passive),
                  Md_Util.Decode(r.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
      end if;
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Extra_Robot
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Hrm_Robots%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hrm_Robots t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hrm_Robots t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hrm_Robots.Difference(r, r_Last);
    
      Get_Difference(z.Org_Unit_Id,
                     t('org unit name'),
                     z_Mhr_Divisions.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => r_Last.Org_Unit_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => r.Org_Unit_Id).Name);
    
      Get_Difference(z.Opened_Date, t('opened date'), r_Last.Opened_Date, r.Opened_Date);
      Get_Difference(z.Closed_Date, t('closed date'), r_Last.Closed_Date, r.Closed_Date);
    
      Get_Difference(z.Schedule_Id,
                     t('schedule name'),
                     z_Htt_Schedules.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Schedule_Id => r_Last.Schedule_Id).Name,
                     z_Htt_Schedules.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Schedule_Id => r.Schedule_Id).Name);
    
      Get_Difference(z.Rank_Id,
                     t('rank name'),
                     z_Mhr_Ranks.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Rank_Id => r_Last.Rank_Id).Name,
                     z_Mhr_Ranks.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Rank_Id => r.Rank_Id).Name);
    
      Get_Difference(z.Labor_Function_Id,
                     t('labor function name'),
                     z_Href_Labor_Functions.Take(i_Company_Id => v_Company_Id, i_Labor_Function_Id => r_Last.Labor_Function_Id).Name,
                     z_Href_Labor_Functions.Take(i_Company_Id => v_Company_Id, i_Labor_Function_Id => r.Labor_Function_Id).Name);
    
      Get_Difference(z.Description, t('description'), r_Last.Description, r.Description);
      Get_Difference(z.Hiring_Condition,
                     t('hiring condition'),
                     r_Last.Hiring_Condition,
                     r.Hiring_Condition);
    
      if z.Contractual_Wage member of v_Diff_Columns then
        Fazo.Push(v_Data,
                  t('contactual wage'),
                  Md_Util.Decode(r_Last.Contractual_Wage, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                  Md_Util.Decode(r.Contractual_Wage, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      end if;
    
      Get_Difference(z.Wage_Scale_Id,
                     t('wage scale name'),
                     z_Hrm_Wage_Scales.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Wage_Scale_Id => r_Last.Wage_Scale_Id).Name,
                     z_Hrm_Wage_Scales.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Wage_Scale_Id => r.Wage_Scale_Id).Name);
    
      if z.Access_Hidden_Salary member of v_Diff_Columns then
        Fazo.Push(v_Data,
                  t('access to hidden salary'),
                  Md_Util.Decode(r_Last.Access_Hidden_Salary, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                  Md_Util.Decode(r.Access_Hidden_Salary, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      end if;
    
      if z.Position_Employment_Kind member of v_Diff_Columns then
        Fazo.Push(v_Data,
                  t('position employment kind'),
                  Md_Util.Decode(r_Last.Position_Employment_Kind,
                                 Hrm_Pref.c_Position_Employment_Contractor,
                                 Hrm_Util.t_Position_Employment(Hrm_Pref.c_Position_Employment_Contractor),
                                 Hrm_Pref.c_Position_Employment_Staff,
                                 Hrm_Util.t_Position_Employment(Hrm_Pref.c_Position_Employment_Staff)),
                  Md_Util.Decode(r.Position_Employment_Kind,
                                 Hrm_Pref.c_Position_Employment_Contractor,
                                 Hrm_Util.t_Position_Employment(Hrm_Pref.c_Position_Employment_Contractor),
                                 Hrm_Pref.c_Position_Employment_Staff,
                                 Hrm_Util.t_Position_Employment(Hrm_Pref.c_Position_Employment_Staff)));
      end if;
    
      Get_Difference(z.Currency_Id,
                     t('currency name'),
                     z_Mk_Currencies.Take(i_Company_Id => v_Company_Id, i_Currency_Id => r_Last.Currency_Id).Name,
                     z_Mk_Currencies.Take(i_Company_Id => v_Company_Id, i_Currency_Id => r.Currency_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Robot_Roles
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Mrf_Robot_Roles%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Mrf_Robot_Roles t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Mrf_Robot_Roles t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Mrf_Robot_Roles.Difference(r, r_Last);
    
      Get_Difference(z.Role_Id,
                     t('role name'),
                     z_Md_Roles.Take(i_Company_Id => v_Company_Id, i_Role_Id => r_Last.Role_Id).Name,
                     z_Md_Roles.Take(i_Company_Id => v_Company_Id, i_Role_Id => r.Role_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Robot_Divisions
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Hrm_Robot_Divisions%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hrm_Robot_Divisions t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hrm_Robot_Divisions t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hrm_Robot_Divisions.Difference(r, r_Last);
    
      Get_Difference(z.Division_Id,
                     t('division name'),
                     z_Mhr_Divisions.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => r_Last.Division_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => r.Division_Id).Name);
    
      if z.Access_Type member of v_Diff_Columns then
        Fazo.Push(v_Data,
                  t('access type'),
                  Md_Util.Decode(r_Last.Access_Type,
                                 Hrm_Pref.c_Access_Type_Manual,
                                 Hrm_Util.t_Robot_Division_Access_Type(Hrm_Pref.c_Access_Type_Manual),
                                 Hrm_Pref.c_Access_Type_Structural,
                                 Hrm_Util.t_Robot_Division_Access_Type(Hrm_Pref.c_Access_Type_Structural)),
                  Md_Util.Decode(r.Access_Type,
                                 Hrm_Pref.c_Access_Type_Manual,
                                 Hrm_Util.t_Robot_Division_Access_Type(Hrm_Pref.c_Access_Type_Manual),
                                 Hrm_Pref.c_Access_Type_Structural,
                                 Hrm_Util.t_Robot_Division_Access_Type(Hrm_Pref.c_Access_Type_Structural)));
      end if;
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Robot_Oper_Types
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Hrm_Robot_Oper_Types%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hrm_Robot_Oper_Types t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hrm_Robot_Oper_Types t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hrm_Robot_Oper_Types.Difference(r, r_Last);
    
      Get_Difference(z.Oper_Type_Id,
                     t('oper type name'),
                     z_Mpr_Oper_Types.Take(i_Company_Id => v_Company_Id, i_Oper_Type_Id => r_Last.Oper_Type_Id).Name,
                     z_Mpr_Oper_Types.Take(i_Company_Id => v_Company_Id, i_Oper_Type_Id => r.Oper_Type_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Robot_Indicators
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Hrm_Robot_Indicators%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hrm_Robot_Indicators t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hrm_Robot_Indicators t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hrm_Robot_Indicators.Difference(r, r_Last);
    
      Get_Difference(z.Indicator_Id,
                     t('indicator name'),
                     z_Href_Indicators.Take(i_Company_Id => v_Company_Id, i_Indicator_Id => r_Last.Indicator_Id).Name,
                     z_Href_Indicators.Take(i_Company_Id => v_Company_Id, i_Indicator_Id => r.Indicator_Id).Name);
      Get_Difference(z.Indicator_Value,
                     t('indicator value'),
                     r_Last.Indicator_Value,
                     r.Indicator_Value);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Robot_Vacation_Limit
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Hrm_Robot_Vacation_Limits%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hrm_Robot_Vacation_Limits t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hrm_Robot_Vacation_Limits t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hrm_Robot_Vacation_Limits.Difference(r, r_Last);
    
      Get_Difference(z.Days_Limit, t('days limit'), r_Last.Days_Limit, r.Days_Limit);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Robot_Job_Groups
  (
    i_Robot_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    r_Last         x_Hrm_Robot_Hidden_Salary_Job_Groups%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hrm_Robot_Hidden_Salary_Job_Groups t
               where t.t_Company_Id = v_Company_Id
                 and t.t_Filial_Id = v_Filial_Id
                 and t.Robot_Id = i_Robot_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hrm_Robot_Hidden_Salary_Job_Groups t
                 where t.t_Company_Id = v_Company_Id
                   and t.t_Filial_Id = v_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hrm_Robot_Hidden_Salary_Job_Groups.Difference(r, r_Last);
    
      Get_Difference(z.Job_Group_Id,
                     t('job group name'),
                     z_Mhr_Job_Groups.Take(i_Company_Id => v_Company_Id, i_Job_Group_Id => r_Last.Job_Group_Id).Name,
                     z_Mhr_Job_Groups.Take(i_Company_Id => v_Company_Id, i_Job_Group_Id => r.Job_Group_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    result       Hashmap := Hashmap();
    v_Robot_Id   number := p.r_Number('robot_id');
    v_Context_Id number := p.r_Number('context_id');
  begin
    Result.Put('main_robot',
               Fazo.Zip_Matrix(Main_Robot(i_Robot_Id => v_Robot_Id, i_Context_Id => v_Context_Id)));
    Result.Put('extra_robot',
               Fazo.Zip_Matrix(Extra_Robot(i_Robot_Id => v_Robot_Id, i_Context_Id => v_Context_Id)));
    Result.Put('robot_roles',
               Fazo.Zip_Matrix(Robot_Roles(i_Robot_Id => v_Robot_Id, i_Context_Id => v_Context_Id)));
    Result.Put('robot_divisions',
               Fazo.Zip_Matrix(Robot_Divisions(i_Robot_Id   => v_Robot_Id,
                                               i_Context_Id => v_Context_Id)));
    Result.Put('robot_oper_types',
               Fazo.Zip_Matrix(Robot_Oper_Types(i_Robot_Id   => v_Robot_Id,
                                                i_Context_Id => v_Context_Id)));
    Result.Put('robot_indicators',
               Fazo.Zip_Matrix(Robot_Indicators(i_Robot_Id   => v_Robot_Id,
                                                i_Context_Id => v_Context_Id)));
    Result.Put('robot_vacation_limit',
               Fazo.Zip_Matrix(Robot_Vacation_Limit(i_Robot_Id   => v_Robot_Id,
                                                    i_Context_Id => v_Context_Id)));
    Result.Put('robot_job_groups',
               Fazo.Zip_Matrix(Robot_Job_Groups(i_Robot_Id   => v_Robot_Id,
                                                i_Context_Id => v_Context_Id)));
  
    return result;
  end;

end Ui_Vhr664;
/
