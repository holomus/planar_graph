create or replace package Ui_Vhr257 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Robot_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Roles return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Labor_Functions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Template(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Job_Roles(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr257;
/
create or replace package body Ui_Vhr257 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Robot_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mr_robot_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('robot_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs w
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id
                        and w.state = ''A''
                        and (w.c_divisions_exist = ''N'' 
                         or exists (select 1
                               from mhr_job_divisions r
                              where r.company_id = :company_id
                                and r.filial_id = :filial_id
                                and r.job_id = w.job_id
                                and r.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.r_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_ranks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('rank_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Roles return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_roles', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('role_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Labor_Functions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_labor_functions', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('labor_function_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrm_wage_scales',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('wage_scale_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mpr_oper_types', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name', 'operation_kind');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.job_group_id, q.name 
                       from mhr_job_groups q 
                      where q.company_id = :company_id
                        and q.state = ''A'' 
                        and exists (select 1 
                               from hrm_hidden_salary_job_groups w
                              where w.company_id = q.company_id
                                and w.job_group_id = q.job_group_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist is
    v_Oper_Type_Id number := p.r_Number('oper_type_id');
    v_Matrix       Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Indicator_Id, q.Name)
      bulk collect
      into v_Matrix
      from Href_Indicators q
     where q.Company_Id = Ui.Company_Id
       and q.Used = Href_Pref.c_Indicator_Used_Constantly
       and exists (select 1
              from Hpr_Oper_Type_Indicators w
             where w.Company_Id = Ui.Company_Id
               and w.Oper_Type_Id = v_Oper_Type_Id
               and w.Indicator_Id = q.Indicator_Id)
     order by q.Name;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap is
    v_Register_Id number := Hrm_Util.Closest_Register_Id(i_Company_Id    => Ui.Company_Id,
                                                         i_Filial_Id     => Ui.Filial_Id,
                                                         i_Wage_Scale_Id => p.r_Number('wage_scale_id'),
                                                         i_Period        => Nvl(p.o_Date('opened_date'),
                                                                                Trunc(sysdate)));
    v_Ids         Array_Number;
    result        Hashmap := Hashmap();
  begin
    select distinct q.Indicator_Id
      bulk collect
      into v_Ids
      from Hrm_Register_Rank_Indicators q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Register_Id = v_Register_Id;
  
    Result.Put('ids', v_Ids);
  
    return result;
  exception
    when No_Data_Found then
      return Hashmap();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('org_units',
               Fazo.Zip_Matrix(Uit_Hrm.Get_Org_Units(i_Division_Id => p.r_Number('division_id'))));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Oper_Types
  (
    i_Robot_Id          number,
    i_Access_Salary_Job varchar2
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    if i_Access_Salary_Job = 'Y' then
      select Array_Varchar2(q.Indicator_Id,
                            (select w.Name
                               from Href_Indicators w
                              where w.Company_Id = q.Company_Id
                                and w.Indicator_Id = q.Indicator_Id),
                            q.Indicator_Value)
        bulk collect
        into v_Matrix
        from Hrm_Robot_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = i_Robot_Id;
    
      Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id, w.Name, w.Operation_Kind)
        bulk collect
        into v_Matrix
        from Hrm_Robot_Oper_Types q
        join Mpr_Oper_Types w
          on w.Company_Id = q.Company_Id
         and w.Oper_Type_Id = q.Oper_Type_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = i_Robot_Id;
    
      Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id, q.Indicator_Id)
        bulk collect
        into v_Matrix
        from Hrm_Oper_Type_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = i_Robot_Id;
    
      Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Template(p Hashmap) return Hashmap is
    v_Matrix                  Matrix_Varchar2;
    r_Template                Hrm_Job_Templates%rowtype;
    v_Division_Id             number := p.r_Number('division_id');
    v_Job_Id                  number := p.r_Number('job_id');
    v_Access_To_Hidden_Salary varchar2(1);
    result                    Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Division(v_Division_Id);
  
    r_Template := Hrm_Util.Load_Template(i_Company_Id  => Ui.Company_Id,
                                         i_Filial_Id   => Ui.Filial_Id,
                                         i_Division_Id => v_Division_Id,
                                         i_Job_Id      => v_Job_Id,
                                         i_Rank_Id     => p.o_Number('rank_id'));
  
    v_Access_To_Hidden_Salary := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => v_Job_Id,
                                                                     i_Employee_Id => p.o_Number('employee_id'));
  
    if v_Access_To_Hidden_Salary = 'N' then
      r_Template.Wage_Scale_Id := null;
    end if;
  
    result := z_Hrm_Job_Templates.To_Map(r_Template,
                                         z.Schedule_Id,
                                         z.Wage_Scale_Id,
                                         z.Vacation_Days_Limit);
  
    Result.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary);
  
    if v_Access_To_Hidden_Salary = 'Y' then
      select Array_Varchar2(q.Oper_Type_Id, w.Name, w.Operation_Kind)
        bulk collect
        into v_Matrix
        from Hrm_Template_Oper_Types q
        join Mpr_Oper_Types w
          on w.Company_Id = q.Company_Id
         and w.Oper_Type_Id = q.Oper_Type_Id
       where q.Company_Id = r_Template.Company_Id
         and q.Filial_Id = r_Template.Filial_Id
         and q.Template_Id = r_Template.Template_Id;
    
      Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Indicator_Id,
                            (select w.Name
                               from Href_Indicators w
                              where q.Indicator_Id = w.Indicator_Id
                                and q.Company_Id = w.Company_Id),
                            q.Indicator_Value)
        bulk collect
        into v_Matrix
        from Hrm_Template_Indicators q
       where q.Company_Id = r_Template.Company_Id
         and q.Filial_Id = r_Template.Filial_Id
         and q.Template_Id = r_Template.Template_Id;
    
      Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id, q.Indicator_Id)
        bulk collect
        into v_Matrix
        from Hrm_Temp_Oper_Type_Indicators q
       where q.Company_Id = r_Template.Company_Id
         and q.Filial_Id = r_Template.Filial_Id
         and q.Template_Id = r_Template.Template_Id;
    
      Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Template.Company_Id, --
               i_Filial_Id => r_Template.Filial_Id, --
               i_Schedule_Id => r_Template.Schedule_Id).Name);
    Result.Put('wage_scale_name',
               z_Hrm_Wage_Scales.Take(i_Company_Id => r_Template.Company_Id, --
               i_Filial_Id => r_Template.Filial_Id, --
               i_Wage_Scale_Id => r_Template.Wage_Scale_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Job_Roles(p Hashmap) return Hashmap is
    v_Job_Id number := p.r_Number('job_id');
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Role_Id, t.Name)
      bulk collect
      into v_Matrix
      from Md_Roles t
     where t.Company_Id = Ui.Company_Id
       and exists (select 1
              from Hrm_Job_Roles q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Job_Id = v_Job_Id
               and q.Role_Id = t.Role_Id)
     order by t.Order_No;
  
    Result.Put('roles', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References
  (
    i_Division_Id number := null,
    i_Robot_Id    number := null
  ) return Hashmap is
    r_Settings     Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                 i_Filial_Id  => Ui.Filial_Id);
    v_Division_Ids Array_Number;
    result         Hashmap := Hashmap();
  begin
    select Rd.Division_Id
      bulk collect
      into v_Division_Ids
      from Hrm_Robot_Divisions Rd
     where Rd.Company_Id = Ui.Company_Id
       and Rd.Filial_Id = Ui.Filial_Id
       and Rd.Robot_Id = i_Robot_Id;
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
    Result.Put('allowed_divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(v_Division_Ids, i_Is_Department => 'N')));
    Result.Put('wage_indicator_id',
               Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
    Result.Put('access_to_salary_setting', Hrm_Util.Restrict_To_View_All_Salaries(Ui.Company_Id));
    Result.Put('position_enabled', r_Settings.Position_Enable);
    Result.Put('parttime_enable', r_Settings.Parttime_Enable);
    Result.Put('advanced_org_structure', r_Settings.Advanced_Org_Structure);
    Result.Put('employment_kinds', Fazo.Zip_Matrix_Transposed(Hrm_Util.Position_Employments));
    Result.Put('allowed_currencies', Uit_Hpr.Load_Allowed_Currencies);
  
    if i_Division_Id is not null then
      Result.Put('org_units',
                 Fazo.Zip_Matrix(Uit_Hrm.Get_Org_Units(i_Division_Id => i_Division_Id)));
    end if;
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('opened_date', Trunc(sysdate));
    Result.Put('contractual_wage', 'Y');
    Result.Put('state', 'A');
    Result.Put('count', 1);
    Result.Put('references', References);
    Result.Put('access_all_hidden_salary', 'N');
    Result.Put('access_salary_job', 'Y');
    Result.Put('position_employment_kind', Hrm_Pref.c_Position_Employment_Staff);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Hrm_Robot                Hrm_Robots%rowtype;
    r_Mrf_Robot                Mrf_Robots%rowtype;
    v_Division_Ids             Array_Number;
    v_Matrix                   Matrix_Varchar2;
    v_Access_Salary_Job        varchar2(1);
    v_Access_To_Salary_Setting varchar2(1) := Hrm_Util.Restrict_To_View_All_Salaries(Ui.Company_Id);
    result                     Hashmap;
  begin
    r_Hrm_Robot := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Robot_Id   => p.r_Number('robot_id'));
    r_Mrf_Robot := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Robot_Id   => r_Hrm_Robot.Robot_Id);
  
    Uit_Href.Assert_Access_To_Division(i_Division_Id => r_Mrf_Robot.Division_Id);
  
    v_Access_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => r_Mrf_Robot.Job_Id);
  
    if v_Access_Salary_Job = 'N' then
      r_Hrm_Robot.Contractual_Wage := 'Y';
      r_Hrm_Robot.Wage_Scale_Id    := null;
    end if;
  
    result := z_Hrm_Robots.To_Map(r_Hrm_Robot,
                                  z.Robot_Id,
                                  z.Org_Unit_Id,
                                  z.Opened_Date,
                                  z.Closed_Date,
                                  z.Schedule_Id,
                                  z.Rank_Id,
                                  z.Labor_Function_Id,
                                  z.Description,
                                  z.Hiring_Condition,
                                  z.Contractual_Wage,
                                  z.Wage_Scale_Id,
                                  z.Position_Employment_Kind,
                                  z.Org_Unit_Id);
  
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Mrf_Robot.Company_Id, i_Filial_Id => r_Mrf_Robot.Filial_Id, i_Division_Id => r_Mrf_Robot.Division_Id).Name);
    Result.Put('org_unit_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Hrm_Robot.Company_Id, i_Filial_Id => r_Hrm_Robot.Filial_Id, i_Division_Id => r_Hrm_Robot.Org_Unit_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Filial_Id => r_Hrm_Robot.Filial_Id, i_Schedule_Id => r_Hrm_Robot.Schedule_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Filial_Id => r_Hrm_Robot.Filial_Id, i_Rank_Id => r_Hrm_Robot.Rank_Id).Name);
    Result.Put('labor_function_name',
               z_Href_Labor_Functions.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Labor_Function_Id => r_Hrm_Robot.Labor_Function_Id).Name);
    Result.Put('wage_scale_name',
               z_Hrm_Wage_Scales.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Filial_Id => r_Hrm_Robot.Filial_Id, i_Wage_Scale_Id => r_Hrm_Robot.Wage_Scale_Id).Name);
    Result.Put('vacation_days_limit',
               z_Hrm_Robot_Vacation_Limits.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Filial_Id => r_Hrm_Robot.Filial_Id, i_Robot_Id => r_Hrm_Robot.Robot_Id).Days_Limit);
  
    if v_Access_Salary_Job = 'Y' then
      Result.Put('currency_id', r_Hrm_Robot.Currency_Id);
      Result.Put('currency_name',
                 z_Mk_Currencies.Take(i_Company_Id => r_Hrm_Robot.Company_Id, i_Currency_Id => r_Hrm_Robot.Currency_Id).Name);
    end if;
  
    Result.Put_All(z_Mrf_Robots.To_Map(r_Mrf_Robot,
                                       z.Name,
                                       z.Code,
                                       z.Division_Id,
                                       z.Job_Id,
                                       z.Robot_Group_Id,
                                       z.State));
  
    select q.Division_Id
      bulk collect
      into v_Division_Ids
      from Mhr_Divisions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Division_Id in (select Rd.Division_Id
                               from Hrm_Robot_Divisions Rd
                              where Rd.Company_Id = q.Company_Id
                                and Rd.Filial_Id = q.Filial_Id
                                and Rd.Robot_Id = r_Hrm_Robot.Robot_Id)
     order by Lower(q.Name);
  
    Result.Put('allowed_division_ids', v_Division_Ids);
    Result.Put('access_to_salary_setting', v_Access_To_Salary_Setting);
    Result.Put('access_all_hidden_salary', r_Hrm_Robot.Access_Hidden_Salary);
  
    if v_Access_To_Salary_Setting = 'Y' then
      if r_Hrm_Robot.Access_Hidden_Salary = 'N' and Ui.Grant_Has('restrict_hidden_salary') then
        select Array_Varchar2(q.Job_Group_Id,
                              (select w.Name
                                 from Mhr_Job_Groups w
                                where w.Company_Id = q.Company_Id
                                  and w.Job_Group_Id = q.Job_Group_Id))
          bulk collect
          into v_Matrix
          from Hrm_Robot_Hidden_Salary_Job_Groups q
         where q.Company_Id = r_Hrm_Robot.Company_Id
           and q.Filial_Id = r_Hrm_Robot.Filial_Id
           and q.Robot_Id = r_Hrm_Robot.Robot_Id;
      
        Result.Put('job_groups', Fazo.Zip_Matrix(v_Matrix));
      end if;
    end if;
  
    select Array_Varchar2(Rl.Role_Id,
                          (select q.Name
                             from Md_Roles q
                            where q.Company_Id = Rl.Company_Id
                              and q.Role_Id = Rl.Role_Id))
      bulk collect
      into v_Matrix
      from Mrf_Robot_Roles Rl
     where Rl.Company_Id = Ui.Company_Id
       and Rl.Filial_Id = Ui.Filial_Id
       and Rl.Robot_Id = r_Hrm_Robot.Robot_Id;
  
    Result.Put('roles', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Mrf_Robot.Company_Id, i_Filial_Id => r_Mrf_Robot.Filial_Id, i_Job_Id => r_Mrf_Robot.Job_Id).Name);
    Result.Put('robot_group_name',
               z_Mr_Robot_Groups.Take(i_Company_Id => r_Mrf_Robot.Company_Id, i_Robot_Group_Id => r_Mrf_Robot.Robot_Group_Id).Name);
    Result.Put('references',
               References(i_Division_Id => r_Mrf_Robot.Division_Id,
                          i_Robot_Id    => r_Hrm_Robot.Robot_Id));
    Result.Put('access_salary_job', v_Access_Salary_Job);
    Result.Put_All(Get_Oper_Types(r_Mrf_Robot.Robot_Id, v_Access_Salary_Job));
    Result.Put('access_edit_div_job_of_robot',
               Hrm_Util.Access_Edit_Div_Job_Of_Robot(i_Company_Id => r_Hrm_Robot.Company_Id,
                                                     i_Filial_Id  => r_Hrm_Robot.Filial_Id,
                                                     i_Robot_Id   => r_Hrm_Robot.Robot_Id));
    Result.Put('planned_fte',
               Hrm_Util.Get_Planned_Fte(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Robot_Id   => r_Hrm_Robot.Robot_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Data
  (
    p          Hashmap,
    i_Robot_Id number := null
  ) return Hrm_Pref.Robot_Rt is
    p_Robot                         Hrm_Pref.Robot_Rt;
    v_Indicators                    Arraylist;
    v_Oper_Types                    Arraylist;
    v_Indicator                     Hashmap;
    v_Oper_Type                     Hashmap;
    v_Subordinate_Division_Ids      Array_Number;
    v_User_Access_All_Employees     varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Non_Visible_Allowed_Divisions Array_Number;
    v_Access_Hidden_Salary          varchar2(1) := p.r_Varchar2('access_all_hidden_salary');
  begin
    if not Ui.Grant_Has('restrict_hidden_salary') then
      v_Access_Hidden_Salary := Nvl(z_Hrm_Robots.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => i_Robot_Id).Access_Hidden_Salary,
                                    'N');
    end if;
  
    Hrm_Util.Robot_New(o_Robot                    => p_Robot,
                       i_Company_Id               => Ui.Company_Id,
                       i_Filial_Id                => Ui.Filial_Id,
                       i_Robot_Id                 => i_Robot_Id,
                       i_Name                     => p.r_Varchar2('name'),
                       i_Code                     => p.o_Varchar2('code'),
                       i_Robot_Group_Id           => p.o_Number('robot_group_id'),
                       i_Division_Id              => p.r_Number('division_id'),
                       i_Job_Id                   => p.r_Number('job_id'),
                       i_Org_Unit_Id              => p.o_Number('org_unit_id'),
                       i_State                    => p.r_Varchar2('state'),
                       i_Opened_Date              => p.r_Date('opened_date'),
                       i_Closed_Date              => p.o_Date('closed_date'),
                       i_Schedule_Id              => p.o_Number('schedule_id'),
                       i_Rank_Id                  => p.o_Number('rank_id'),
                       i_Labor_Function_Id        => p.o_Number('labor_function_id'),
                       i_Description              => p.o_Varchar2('description'),
                       i_Hiring_Condition         => p.o_Varchar2('hiring_condition'),
                       i_Vacation_Days_Limit      => p.o_Number('vacation_days_limit'),
                       i_Wage_Scale_Id            => p.o_Number('wage_scale_id'),
                       i_Access_Hidden_Salary     => v_Access_Hidden_Salary,
                       i_Planned_Fte              => Nvl(p.o_Number('planned_fte'), 1),
                       i_Contractual_Wage         => p.r_Varchar2('contractual_wage'),
                       i_Position_Employment_Kind => Nvl(p.o_Varchar2('position_employment_kind'),
                                                         Hrm_Pref.c_Position_Employment_Staff),
                       i_Currency_Id              => p.o_Number('currency_id'),
                       i_Role_Ids                 => Nvl(p.o_Array_Number('role_ids'),
                                                         Array_Number()),
                       i_Allowed_Division_Ids     => Nvl(p.o_Array_Number('allowed_division_ids'),
                                                         Array_Number()));
  
    p_Robot.Allowed_Division_Ids := Hrm_Util.Fix_Allowed_Divisions(i_Company_Id           => Ui.Company_Id,
                                                                   i_Filial_Id            => Ui.Filial_Id,
                                                                   i_Robot_Id             => i_Robot_Id,
                                                                   i_Allowed_Division_Ids => p_Robot.Allowed_Division_Ids);
  
    if i_Robot_Id is not null then
      v_Subordinate_Division_Ids := Uit_Href.Get_All_Subordinate_Divisions;
    
      select Rd.Division_Id
        bulk collect
        into v_Non_Visible_Allowed_Divisions
        from Hrm_Robot_Divisions Rd
       where Rd.Company_Id = Ui.Company_Id
         and Rd.Filial_Id = Ui.Filial_Id
         and Rd.Robot_Id = i_Robot_Id
         and (v_User_Access_All_Employees = 'N' and Rd.Division_Id not member of
              v_Subordinate_Division_Ids);
    
      p_Robot.Allowed_Division_Ids := p_Robot.Allowed_Division_Ids multiset union distinct
                                      v_Non_Visible_Allowed_Divisions;
    end if;
  
    v_Indicators := p.o_Arraylist('indicators');
  
    for j in 1 .. v_Indicators.Count
    loop
      v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
    
      Hrm_Util.Indicator_Add(p_Robot           => p_Robot,
                             i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                             i_Indicator_Value => Nvl(v_Indicator.o_Number('indicator_value'), 0));
    end loop;
  
    v_Oper_Types := p.o_Arraylist('oper_types');
  
    for j in 1 .. v_Oper_Types.Count
    loop
      v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(j) as Hashmap);
    
      Hrm_Util.Oper_Type_Add(p_Robot         => p_Robot,
                             i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                             i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                    Array_Number()));
    end loop;
  
    return p_Robot;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap is
    v_Origin_Robot  Hrm_Pref.Robot_Rt;
    v_Robot         Hrm_Pref.Robot_Rt;
    v_Count         number := p.r_Number('count');
    v_Job_Group_Ids Array_Number := p.r_Array_Number('job_group_ids');
    v_Grand_Has     boolean := Ui.Grant_Has('restrict_hidden_salary');
    v_Robot_Ids     Array_Number := Array_Number();
    result          Hashmap;
  begin
    v_Origin_Robot := Load_Data(p);
    v_Robot_Ids.Extend(v_Count);
  
    for i in 1 .. v_Count
    loop
      v_Robot := v_Origin_Robot;
    
      v_Robot.Robot.Robot_Id := Mrf_Next.Robot_Id;
      v_Robot.Robot.Name     := v_Robot.Robot.Name || '(' || v_Robot.Robot.Robot_Id || ')';
    
      if v_Robot.Robot.Code is not null then
        v_Robot.Robot.Code := v_Robot.Robot.Code || '(' || v_Robot.Robot.Robot_Id || ')';
      end if;
    
      Hrm_Api.Robot_Save(v_Robot);
    
      if v_Grand_Has then
        Hrm_Api.Robot_Hidden_Salary_Job_Groups_Save(i_Company_Id    => v_Robot.Robot.Company_Id,
                                                    i_Filial_Id     => v_Robot.Robot.Filial_Id,
                                                    i_Robot_Id      => v_Robot.Robot.Robot_Id,
                                                    i_Job_Group_Ids => v_Job_Group_Ids);
      end if;
    
      v_Robot_Ids(i) := v_Robot.Robot.Robot_Id;
    end loop;
  
    -- DEPRICATED: robot_id not supported, use robot_ids instead   
    result := Fazo.Zip_Map('robot_id', v_Robot.Robot.Robot_Id, 'name', v_Robot.Robot.Name);
    Result.Put('robot_ids', v_Robot_Ids);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    v_Robot Hrm_Pref.Robot_Rt;
  begin
    v_Robot := Load_Data(p, p.r_Number('robot_id'));
  
    Hrm_Api.Robot_Save(v_Robot);
  
    if Ui.Grant_Has('restrict_hidden_salary') then
      Hrm_Api.Robot_Hidden_Salary_Job_Groups_Save(i_Company_Id    => v_Robot.Robot.Company_Id,
                                                  i_Filial_Id     => v_Robot.Robot.Filial_Id,
                                                  i_Robot_Id      => v_Robot.Robot.Robot_Id,
                                                  i_Job_Group_Ids => p.r_Array_Number('job_group_ids'));
    end if;
  
    return Fazo.Zip_Map('robot_id', v_Robot.Robot.Robot_Id, 'name', v_Robot.Robot.Name);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Validation is
  begin
    update Mr_Robot_Groups
       set Company_Id     = null,
           Robot_Group_Id = null,
           name           = null,
           State          = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           Filial_Id         = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null,
           Order_No   = null;
    update Href_Labor_Functions
       set Company_Id        = null,
           Labor_Function_Id = null,
           name              = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null,
           State         = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
    update Md_Roles
       set Company_Id = null,
           State      = null;
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null,
           State        = null;
    update Hrm_Hidden_Salary_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null;
  end;

end Ui_Vhr257;
/
