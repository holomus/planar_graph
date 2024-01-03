create or replace package Ui_Vhr637 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employment_Sources return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Service_Names return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Load_Rank_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------   
  Function Load_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Wage_Scale(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Robot(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Template(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr637;
/
create or replace package body Ui_Vhr637 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query is
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Query                varchar2(32767);
    v_Params               Hashmap;
    q                      Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'hiring_date',
                             p.r_Date('hiring_date'),
                             'sk_primary',
                             Href_Pref.c_Staff_Kind_Primary,
                             'st_unknown',
                             Href_Pref.c_Staff_Status_Unknown);
  
    if v_Access_All_Employees = 'Y' then
      v_Query := 'select nvl(q.employee_id, cn.candidate_id) employee_id,';
    else
      v_Query := 'select q.employee_id,';
    end if;
  
    v_Query := v_Query || --
               '       uit_href.get_staff_status(q.hiring_date, q.dismissal_date, :hiring_date) as status
                  from (select g.*, 
                               s.staff_id, 
                               s.hiring_date, 
                               s.dismissal_date,
                               s.org_unit_id
                          from mhr_employees g
                          left join href_staffs s
                            on s.company_id = g.company_id
                           and s.filial_id = g.filial_id
                           and s.employee_id = g.employee_id
                           and s.staff_kind = :sk_primary
                           and s.state = ''A''
                           and s.hiring_date = (select max(s1.hiring_date)
                                                  from href_staffs s1
                                                 where s1.company_id = g.company_id
                                                   and s1.filial_id = g.filial_id
                                                   and s1.employee_id = g.employee_id
                                                   and s1.staff_kind = :sk_primary
                                                   and s1.state = ''A''
                                                   and s1.hiring_date <= :hiring_date)
                         where g.company_id = :company_id
                           and g.filial_id = :filial_id) q';
  
    if v_Access_All_Employees = 'Y' then
      v_Query := v_Query || ' full join (select w.*
                               from href_candidates w
                              where w.company_id = :company_id
                                and w.filial_id = :filial_id) cn
                    on cn.candidate_id = q.employee_id ';
    else
      v_Query := v_Query || --
                 ' where (q.staff_id is null or q.org_unit_id member of :division_ids)
                     and q.employee_id <> :user_id';
    
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('status');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Robots(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(3000);
    v_Params Hashmap;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'hiring_date',
                             p.r_Date('hiring_date'));
  
    v_Query := 'select p.*,
                       q.division_id,
                       q.job_id,
                       q.name,
                       (select min(fte)
                          from hrm_robot_turnover rob
                         where rob.company_id = p.company_id
                           and rob.filial_id = p.filial_id
                           and rob.robot_id = p.robot_id
                           and (rob.period >= :hiring_date or
                               rob.period = (select max(rt.period)
                                             from hrm_robot_turnover rt
                                            where rt.company_id = rob.company_id
                                              and rt.filial_id = rob.filial_id
                                              and rt.robot_id = rob.robot_id
                                              and rt.period <= :hiring_date))) fte
                  from hrm_robots p
                  join mrf_robots q
                    on q.company_Id = p.company_id
                   and q.filial_Id = p.filial_id
                   and q.robot_Id = p.robot_id
                 where p.company_Id = :company_id
                   and p.filial_Id = :filial_id';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and p.org_unit_id in (select column_value from table(:division_ids))';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('robot_id', 'division_id', 'org_unit_id', 'job_id', 'rank_id', 'fte');
    q.Date_Field('opened_date', 'closed_date');
    q.Varchar2_Field('name', 'position_employment_kind');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id      
                        and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.o_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'state');
  
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
  Function Query_Ftes return Fazo_Query is
  begin
    return Uit_Href.Query_Ftes;
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
  Function Query_Employment_Sources return Fazo_Query is
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A');
  
    v_Params.Put('kinds',
                 Array_Varchar2(Href_Pref.c_Employment_Source_Kind_Hiring,
                                Href_Pref.c_Employment_Source_Kind_Both));
  
    q := Fazo_Query('select *
                       from href_employment_sources q
                      where q.company_id = :company_id
                        and q.kind member of :kinds
                        and q.state = :state',
                    v_Params);
  
    q.Number_Field('source_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query is
    v_Wage_Group_Id         number;
    v_Bonus_Group_Id        number;
    v_Penalty_Group_Id      number;
    v_Perf_Penalty_Group_Id number;
    v_Overtime_Group_Id     number;
    v_Param                 Hashmap;
    q                       Fazo_Query;
  begin
    v_Wage_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
  
    v_Bonus_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                               i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf);
  
    v_Penalty_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  
    v_Perf_Penalty_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                      i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  
    v_Overtime_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Overtime);
  
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'wage_group_id',
                            v_Wage_Group_Id,
                            'bonus_group_id',
                            v_Bonus_Group_Id,
                            'penalty_group_id',
                            v_Penalty_Group_Id,
                            'perf_penalty_group_id',
                            v_Perf_Penalty_Group_Id,
                            'operation_kind',
                            p.r_Varchar2('operation_kind'));
    v_Param.Put('overtime_group_id', v_Overtime_Group_Id);
  
    q := Fazo_Query('select q.*
                       from mpr_oper_types q
                      where q.company_id = :company_id
                        and q.operation_kind = :operation_kind
                        and q.state = ''A''
                        and exists (select 1
                               from hpr_oper_types p
                              where p.company_id = q.company_id
                                and p.oper_type_id = q.oper_type_id
                                and p.oper_group_id in (:wage_group_id, :bonus_group_id, :penalty_group_id, :perf_penalty_group_id, :overtime_group_id))',
                    v_Param);
  
    q.Number_Field('oper_type_id');
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
  Function Query_Service_Names return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_cached_contract_item_names',
                    Fazo.Zip_Map('company_id', Ui.Company_Id),
                    true);
  
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Load_Rank_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap is
    v_Wage_Scale_Id number;
    v_Register_Id   number;
    v_Matrix        Matrix_Varchar2;
    v_Rank_Id       number := p.r_Number('rank_id');
    result          Hashmap := Hashmap();
  begin
    v_Wage_Scale_Id := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id, --
                       i_Filial_Id => Ui.Filial_Id, --
                       i_Robot_Id => p.r_Number('robot_id')).Wage_Scale_Id;
  
    if v_Wage_Scale_Id is null then
      Result.Put('rank_wage_scale_indicators', Arraylist());
    
      return result;
    end if;
  
    v_Register_Id := Hrm_Util.Closest_Register_Id(i_Company_Id    => Ui.Company_Id,
                                                  i_Filial_Id     => Ui.Filial_Id,
                                                  i_Wage_Scale_Id => v_Wage_Scale_Id,
                                                  i_Period        => p.r_Date('hiring_date'));
  
    select Array_Varchar2(w.Indicator_Id,
                          w.Indicator_Value,
                          (select q.Name
                             from Href_Indicators q
                            where q.Company_Id = w.Company_Id
                              and q.Indicator_Id = w.Indicator_Id))
      bulk collect
      into v_Matrix
      from Hrm_Register_Rank_Indicators w
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = Ui.Filial_Id
       and w.Register_Id = v_Register_Id
       and w.Rank_Id = v_Rank_Id;
  
    Result.Put('rank_wage_scale_indicators', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  exception
    when No_Data_Found then
      Result.Put('rank_wage_scale_indicators', Arraylist());
    
      return result;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Load_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap is
    v_Wage_Scale_Robot_Id number;
    v_Register_Id         number;
    v_Indicator_Ids       Array_Number;
    result                Hashmap := Hashmap();
  begin
    if p.o_Varchar2('for_edit') = 'Y' then
      if p.r_Varchar2('position_enable') = 'Y' then
        v_Wage_Scale_Robot_Id := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id, --
                                 i_Filial_Id => Ui.Filial_Id, --
                                 i_Robot_Id => p.r_Number('robot_id')).Wage_Scale_Id;
      else
        v_Wage_Scale_Robot_Id := p.o_Number('wage_scale_id');
      end if;
    
      if v_Wage_Scale_Robot_Id is null then
        Result.Put('wage_scale_indicator_ids', Array_Number());
      
        return result;
      end if;
    else
      v_Wage_Scale_Robot_Id := p.r_Number('wage_scale_id');
    end if;
  
    v_Register_Id := Hrm_Util.Closest_Register_Id(i_Company_Id    => Ui.Company_Id,
                                                  i_Filial_Id     => Ui.Filial_Id,
                                                  i_Wage_Scale_Id => v_Wage_Scale_Robot_Id,
                                                  i_Period        => p.r_Date('hiring_date'));
  
    select distinct w.Indicator_Id
      bulk collect
      into v_Indicator_Ids
      from Hrm_Register_Rank_Indicators w
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = Ui.Filial_Id
       and w.Register_Id = v_Register_Id;
  
    Result.Put('wage_scale_indicator_ids', v_Indicator_Ids);
    return result;
  exception
    when No_Data_Found then
      Result.Put('wage_scale_indicator_ids', Array_Number());
    
      return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Wage_Scale(p Hashmap) return Hashmap is
    v_Matrix      Matrix_Varchar2;
    v_Rank_Id     number := p.r_Number('rank_id');
    v_Register_Id number := Hrm_Util.Closest_Register_Id(i_Company_Id    => Ui.Company_Id,
                                                         i_Filial_Id     => Ui.Filial_Id,
                                                         i_Wage_Scale_Id => p.r_Number('wage_scale_id'),
                                                         i_Period        => p.r_Date('hiring_date'));
    result        Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Indicator_Id,
                          q.Indicator_Value,
                          (select w.Name
                             from Href_Indicators w
                            where w.Company_Id = q.Company_Id
                              and w.Indicator_Id = q.Indicator_Id))
      bulk collect
      into v_Matrix
      from Hrm_Register_Rank_Indicators q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Register_Id = v_Register_Id
       and q.Rank_Id = v_Rank_Id;
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
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
  Function Get_Robot(p Hashmap) return Hashmap is
    r_Robot                   Hrm_Robots%rowtype;
    r_Base_Robot              Mrf_Robots%rowtype;
    v_Matrix                  Matrix_Varchar2;
    v_Access_To_Hidden_Salary varchar2(1);
    result                    Hashmap;
  begin
    r_Robot := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Robot_Id   => p.r_Number('robot_id'));
  
    r_Base_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Robot.Company_Id,
                                      i_Filial_Id  => r_Robot.Filial_Id,
                                      i_Robot_Id   => r_Robot.Robot_Id);
  
    Uit_Href.Assert_Access_To_Division(r_Base_Robot.Division_Id);
  
    v_Access_To_Hidden_Salary := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r_Base_Robot.Job_Id,
                                                                     i_Employee_Id => p.o_Number('employee_id'));
  
    if v_Access_To_Hidden_Salary = 'N' then
      r_Robot.Contractual_Wage := 'Y';
    end if;
  
    result := z_Hrm_Robots.To_Map(r_Robot,
                                  z.Robot_Id,
                                  z.Org_Unit_Id,
                                  z.Rank_Id,
                                  z.Schedule_Id,
                                  z.Contractual_Wage,
                                  z.Hiring_Condition,
                                  i_Hiring_Condition => 'hiring_conditions');
    Result.Put_All(z_Mrf_Robots.To_Map(r_Base_Robot, z.Division_Id, z.Job_Id));
  
    if v_Access_To_Hidden_Salary = 'Y' then
      Result.Put('currency_id', r_Robot.Currency_Id);
      Result.Put('currency_name',
                 z_Mk_Currencies.Take(i_Company_Id => r_Robot.Company_Id, i_Currency_Id => r_Robot.Currency_Id).Name);
    end if;
  
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Base_Robot.Company_Id, i_Filial_Id => r_Base_Robot.Filial_Id, i_Division_Id => r_Base_Robot.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Base_Robot.Company_Id, i_Filial_Id => r_Base_Robot.Filial_Id, i_Job_Id => r_Base_Robot.Job_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Schedule_Id => r_Robot.Schedule_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Rank_Id => r_Robot.Rank_Id).Name);
    Result.Put('vacation_days_limit',
               z_Hrm_Robot_Vacation_Limits.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Robot_Id => r_Robot.Robot_Id).Days_Limit);
    Result.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary);
  
    if v_Access_To_Hidden_Salary = 'Y' then
      select Array_Varchar2(q.Oper_Type_Id, w.Name, w.Operation_Kind)
        bulk collect
        into v_Matrix
        from Hrm_Robot_Oper_Types q
        join Mpr_Oper_Types w
          on w.Company_Id = q.Company_Id
         and w.Oper_Type_Id = q.Oper_Type_Id
       where q.Company_Id = r_Robot.Company_Id
         and q.Filial_Id = r_Robot.Filial_Id
         and q.Robot_Id = r_Robot.Robot_Id;
    
      Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id, q.Indicator_Id)
        bulk collect
        into v_Matrix
        from Hrm_Oper_Type_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Robot_Id = r_Robot.Robot_Id;
    
      Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
    
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
         and q.Robot_Id = r_Robot.Robot_Id;
    
      Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
    
      if r_Robot.Wage_Scale_Id is not null then
        Result.Put_All(Load_Wage_Scale_Indicator_Ids(Fazo.Zip_Map('hiring_date',
                                                                  p.r_Date('hiring_date'),
                                                                  'wage_scale_id',
                                                                  r_Robot.Wage_Scale_Id)));
      end if;
    end if;
  
    Result.Put_All(Uit_Href.Get_Fte(Coalesce(p.o_Number('fte'),
                                             Uit_Hrm.Robot_Fte(i_Robot_Id     => r_Robot.Robot_Id,
                                                               i_Period_Begin => p.r_Date('hiring_date')))));
  
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
               z_Htt_Schedules.Take(i_Company_Id => r_Template.Company_Id, i_Filial_Id => r_Template.Filial_Id, i_Schedule_Id => r_Template.Schedule_Id).Name);
    Result.Put('wage_scale_name',
               z_Hrm_Wage_Scales.Take(i_Company_Id => r_Template.Company_Id, i_Filial_Id => r_Template.Filial_Id, i_Wage_Scale_Id => r_Template.Wage_Scale_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hirings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Page_Ids        Array_Number;
    v_Full_Page_Ids   Array_Number;
    v_Matrix          Matrix_Varchar2;
    v_Custom_Fte_Name varchar2(32767) := Href_Util.t_Custom_Fte_Name;
    result            Hashmap := Hashmap();
  begin
    select Array_Varchar2(Hir.Page_Id,
                           Hir.Hiring_Date,
                           Hir.Dismissal_Date,
                           Hir.Employment_Source_Id,
                           Hir.Employment_Source_Name,
                           Hir.Is_Booked,
                           Hir.Employee_Id,
                           Hir.Staff_Number,
                           Hir.Employee_Name,
                           Hir.Robot_Id,
                           Hir.Robot_Name,
                           Hir.Schedule_Id,
                           Hir.Schedule_Name,
                           case
                             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
                              Hir.Currency_Id
                             else
                              null
                           end,
                           case
                             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
                              Hir.Currency_Name
                             else
                              null
                           end,
                           Hir.Contractual_Wage,
                           Hir.Division_Id,
                           Hir.Job_Id,
                           Hir.Org_Unit_Id,
                           Hir.Job_Name,
                           Hir.Rank_Id,
                           Hir.Rank_Name,
                           Hir.Fte_Id,
                           Hir.Fte_Name,
                           Hir.Fte,
                           case
                             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
                              Hir.Wage_Scale_Id
                             else
                              null
                           end,
                           case
                             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
                              Hir.Wage_Scale_Name
                             else
                              null
                           end,
                           Hir.Contract_Id,
                           Hir.Contract_Number,
                           Hir.Contract_Kind,
                           Hir.Access_To_Add_Item,
                           Hir.Note,
                           Hir.Access_To_Hidden_Salary_Job),
           case
             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
              Hir.Page_Id
             else
              null
           end,
           Hir.Page_Id
      bulk collect
      into v_Matrix, v_Page_Ids, v_Full_Page_Ids
      from (select q.Page_Id,
                   w.Hiring_Date,
                   w.Dismissal_Date,
                   w.Employment_Source_Id,
                   Nvl(m.Is_Booked, 'N') Is_Booked,
                   (select k.Name
                      from Href_Employment_Sources k
                     where k.Company_Id = q.Company_Id
                       and k.Source_Id = w.Employment_Source_Id) as Employment_Source_Name,
                   q.Employee_Id,
                   (select s.Staff_Number
                      from Href_Staffs s
                     where s.Company_Id = q.Company_Id
                       and s.Filial_Id = q.Filial_Id
                       and s.Staff_Id = q.Staff_Id) as Staff_Number,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = q.Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   m.Robot_Id,
                   t.Name as Robot_Name,
                   s.Schedule_Id,
                   (select k.Name
                      from Htt_Schedules k
                     where k.Company_Id = s.Company_Id
                       and k.Filial_Id = s.Filial_Id
                       and k.Schedule_Id = s.Schedule_Id) as Schedule_Name,
                   Pc.Currency_Id,
                   (select Cr.Name
                      from Mk_Currencies Cr
                     where Cr.Company_Id = Pc.Company_Id
                       and Cr.Currency_Id = Pc.Currency_Id) as Currency_Name,
                   (select k.Contractual_Wage
                      from Hrm_Robots k
                     where k.Company_Id = m.Company_Id
                       and k.Filial_Id = m.Filial_Id
                       and k.Robot_Id = m.Robot_Id) as Contractual_Wage,
                   t.Division_Id,
                   t.Job_Id,
                   (select k.Name
                      from Mhr_Jobs k
                     where k.Company_Id = t.Company_Id
                       and k.Filial_Id = t.Filial_Id
                       and k.Job_Id = t.Job_Id) as Job_Name,
                   case
                      when t.Division_Id = Hr.Org_Unit_Id then
                       null
                      else
                       Hr.Org_Unit_Id
                    end Org_Unit_Id,
                   m.Rank_Id,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = m.Company_Id
                       and k.Filial_Id = m.Filial_Id
                       and k.Rank_Id = m.Rank_Id) as Rank_Name,
                   Nvl(m.Fte_Id, Href_Pref.c_Custom_Fte_Id) as Fte_Id,
                   Nvl((select Hf.Name
                         from Href_Ftes Hf
                        where Hf.Company_Id = m.Company_Id
                          and Hf.Fte_Id = m.Fte_Id),
                       v_Custom_Fte_Name) as Fte_Name,
                   m.Fte,
                   Hr.Wage_Scale_Id,
                   (select k.Name
                      from Hrm_Wage_Scales k
                     where k.Company_Id = Hr.Company_Id
                       and k.Filial_Id = Hr.Filial_Id
                       and k.Wage_Scale_Id = Hr.Wage_Scale_Id) as Wage_Scale_Name,
                   c.Contract_Id,
                   c.Contract_Number,
                   c.Contract_Kind,
                   c.Access_To_Add_Item,
                   c.Note,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => t.Job_Id,
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary_Job
              from Hpd_Journal_Pages q
              join Hpd_Hirings w
                on w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Page_Id = q.Page_Id
              join Hpd_Cv_Contracts c
                on c.Company_Id = q.Company_Id
               and c.Filial_Id = q.Filial_Id
               and c.Page_Id = q.Page_Id
              left join Hpd_Page_Robots m
                on m.Company_Id = q.Company_Id
               and m.Filial_Id = q.Filial_Id
               and m.Page_Id = q.Page_Id
              left join Hpd_Page_Schedules s
                on s.Company_Id = q.Company_Id
               and s.Filial_Id = q.Filial_Id
               and s.Page_Id = q.Page_Id
              left join Hpd_Page_Currencies Pc
                on Pc.Company_Id = q.Company_Id
               and Pc.Filial_Id = q.Filial_Id
               and Pc.Page_Id = q.Page_Id
              left join Mrf_Robots t
                on t.Company_Id = m.Company_Id
               and t.Filial_Id = m.Filial_Id
               and t.Robot_Id = m.Robot_Id
              left join Hrm_Robots Hr
                on Hr.Company_Id = m.Company_Id
               and Hr.Filial_Id = m.Filial_Id
               and Hr.Robot_Id = m.Robot_Id
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Journal_Id = i_Journal_Id) Hir;
  
    Result.Put('hirings', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(Qr.Page_Id,
                          Qr.Indicator_Id,
                          (select w.Name
                             from Href_Indicators w
                            where w.Company_Id = i_Company_Id
                              and w.Indicator_Id = Qr.Indicator_Id),
                          Qr.Indicator_Value)
      bulk collect
      into v_Matrix
      from (select q.Page_Id, q.Indicator_Id, q.Indicator_Value
              from Hpd_Page_Indicators q
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Page_Id in (select *
                                   from table(v_Page_Ids)
                                  where Column_Value is not null)
            union
            select p.Page_Id, Rb.Indicator_Id, Rb.Indicator_Value
              from Hpd_Page_Robots p
              join Hrm_Robot_Indicators Rb
                on Rb.Company_Id = p.Company_Id
               and Rb.Filial_Id = p.Filial_Id
               and Rb.Robot_Id = p.Robot_Id
               and not exists (select *
                      from Hpd_Page_Indicators k
                     where k.Company_Id = p.Company_Id
                       and k.Filial_Id = p.Filial_Id
                       and k.Page_Id = p.Page_Id
                       and k.Indicator_Id = Rb.Indicator_Id)
             where p.Company_Id = i_Company_Id
               and p.Filial_Id = i_Filial_Id
               and p.Page_Id in (select *
                                   from table(v_Page_Ids)
                                  where Column_Value is not null)) Qr;
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id, q.Oper_Type_Id, w.Name, w.Operation_Kind)
      bulk collect
      into v_Matrix
      from Hpd_Page_Oper_Types q
      join Mpr_Oper_Types w
        on w.Company_Id = q.Company_Id
       and w.Oper_Type_Id = q.Oper_Type_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id, q.Oper_Type_Id, q.Indicator_Id)
      bulk collect
      into v_Matrix
      from Hpd_Oper_Type_Indicators q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(c.Page_Id, q.Contract_Item_Id, q.Name, q.Quantity, q.Amount)
      bulk collect
      into v_Matrix
      from Hpd_Cv_Contracts c
      join Hpd_Cv_Contract_Items q
        on q.Company_Id = c.Company_Id
       and q.Filial_Id = c.Filial_Id
       and q.Contract_Id = c.Contract_Id
     where c.Company_Id = i_Company_Id
       and c.Filial_Id = i_Filial_Id
       and c.Page_Id in (select *
                           from table(v_Full_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('contract_services', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(c.Page_Id,
                          q.File_Sha,
                          (select s.File_Name
                             from Biruni_Files s
                            where s.Sha = q.File_Sha),
                          q.Note)
      bulk collect
      into v_Matrix
      from Hpd_Cv_Contracts c
      join Hpd_Cv_Contract_Files q
        on q.Company_Id = c.Company_Id
       and q.Filial_Id = c.Filial_Id
       and q.Contract_Id = c.Contract_Id
     where c.Company_Id = i_Company_Id
       and c.Filial_Id = i_Filial_Id
       and c.Page_Id in (select *
                           from table(v_Full_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('contract_files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    r_Setting Hrm_Settings%rowtype;
    v_Fte_Id  number;
    result    Hashmap := Hashmap();
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('sk_flexible', Htt_Pref.c_Schedule_Kind_Flexible);
    Result.Put('pek_contractor', Hrm_Pref.c_Position_Employment_Contractor);
    Result.Put('custom_fte_id', Href_Pref.c_Custom_Fte_Id);
  
    Result.Put_All(z_Hrm_Settings.To_Map(r_Setting,
                                         z.Position_Enable,
                                         z.Position_Booking,
                                         z.Parttime_Enable,
                                         z.Rank_Enable,
                                         z.Wage_Scale_Enable,
                                         z.Advanced_Org_Structure,
                                         z.Keep_Rank,
                                         z.Keep_Salary,
                                         z.Keep_Schedule));
  
    v_Fte_Id := Href_Util.Fte_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time);
  
    Result.Put('fte',
               Fazo.Zip_Map('fte_id',
                            v_Fte_Id,
                            'name',
                            z_Href_Ftes.Load(i_Company_Id => Ui.Company_Id, i_Fte_Id => v_Fte_Id).Name,
                            'fte_value',
                            1));
  
    Result.Put('allowed_currencies', Uit_Hpr.Load_Allowed_Currencies);
    Result.Put('all_org_units', Fazo.Zip_Matrix(Uit_Hrm.Org_Units));
    Result.Put('access_oper_group_ids',
               Array_Number(Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Overtime)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Contractor_Journal(i_Company_Id      => Ui.Company_Id,
                                          i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_type_id',
                           v_Journal_Type_Id,
                           'journal_date',
                           Trunc(sysdate),
                           'hiring_date',
                           Trunc(sysdate),
                           'dismissal_date',
                           Last_Day(Trunc(sysdate)));
  
    Result.Put('contract_kind', Hpd_Pref.c_Cv_Contract_Kind_Simple);
    Result.Put('access_to_add_item', 'Y');
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Contractor_Journal(i_Company_Id      => Ui.Company_Id,
                                          i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null then
      Uit_Hpd.Check_Access_To_Edit_Journal(i_Document_Status => v_Sign_Document_Status,
                                           i_Posted          => r_Journal.Posted,
                                           i_Journal_Number  => r_Journal.Journal_Number);
      v_Has_Sign_Document := 'Y';
    end if;
  
    for r in (select s.Staff_Id
                from Hpd_Journal_Staffs s
               where s.Company_Id = r_Journal.Company_Id
                 and s.Filial_Id = r_Journal.Filial_Id
                 and s.Journal_Id = r_Journal.Journal_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
    end loop;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Type_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Posted);
  
    Result.Put_All(Get_Hirings(i_Company_Id => r_Journal.Company_Id,
                               i_Filial_Id  => r_Journal.Filial_Id,
                               i_Journal_Id => r_Journal.Journal_Id));
  
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(i_Employee_Id number) is
    r_User       Md_Users%rowtype;
    r_Person     Mr_Natural_Persons%rowtype;
    r_Employee   Mhr_Employees%rowtype;
    v_Htt_Person Htt_Pref.Person_Rt;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Role_Id    number;
  begin
    r_Employee.Company_Id  := v_Company_Id;
    r_Employee.Filial_Id   := v_Filial_Id;
    r_Employee.Employee_Id := i_Employee_Id;
  
    if z_Mhr_Employees.Exist(i_Company_Id  => r_Employee.Company_Id,
                             i_Filial_Id   => r_Employee.Filial_Id,
                             i_Employee_Id => r_Employee.Employee_Id) then
      return;
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => r_Employee.Company_Id,
                                               i_Person_Id  => r_Employee.Employee_Id);
  
    Mrf_Api.Filial_Add_Person(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => v_Filial_Id,
                              i_Person_Id  => r_Person.Person_Id,
                              i_State      => r_Person.State);
  
    r_Employee.State := 'A';
    Mhr_Api.Employee_Save(r_Employee);
  
    if not z_Md_Users.Exist(i_Company_Id => r_Employee.Company_Id,
                            i_User_Id    => r_Employee.Employee_Id,
                            o_Row        => r_User) then
      z_Md_Users.Init(p_Row        => r_User,
                      i_Company_Id => r_Person.Company_Id,
                      i_User_Id    => r_Person.Person_Id,
                      i_Name       => r_Person.Name,
                      i_User_Kind  => Md_Pref.c_Uk_Normal,
                      i_Gender     => r_Person.Gender,
                      i_State      => 'A');
    
      Md_Api.User_Save(r_User);
    end if;
  
    if not z_Md_User_Filials.Exist(i_Company_Id => v_Company_Id,
                                   i_User_Id    => r_Person.Person_Id,
                                   i_Filial_Id  => v_Filial_Id) then
      Md_Api.User_Add_Filial(i_Company_Id => v_Company_Id,
                             i_User_Id    => r_Person.Person_Id,
                             i_Filial_Id  => v_Filial_Id);
    end if;
  
    if not z_Md_User_Roles.Exist(i_Company_Id => v_Company_Id,
                                 i_User_Id    => r_Person.Person_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Role_Id    => v_Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  
    if not z_Htt_Persons.Exist(i_Company_Id => v_Company_Id, --
                               i_Person_Id  => r_Person.Person_Id) then
      Htt_Util.Person_New(o_Person     => v_Htt_Person,
                          i_Company_Id => v_Company_Id,
                          i_Person_Id  => r_Person.Person_Id,
                          i_Pin        => null,
                          i_Pin_Code   => null,
                          i_Rfid_Code  => null,
                          i_Qr_Code    => Htt_Util.Qr_Code_Gen(r_Person.Person_Id));
    
      if Htt_Util.Pin_Autogenerate(r_Person.Company_Id) = 'Y' then
        v_Htt_Person.Pin := Htt_Core.Next_Pin(r_Person.Company_Id);
      end if;
    
      Htt_Api.Person_Save(v_Htt_Person);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Journal_Id number,
    p            Hashmap,
    i_Repost     boolean := false
  ) return Hashmap is
    v_Journal           Hpd_Pref.Hiring_Journal_Rt;
    v_Robot             Hpd_Pref.Robot_Rt;
    v_Cv_Contract       Hpd_Pref.Cv_Contract_Rt;
    v_Indicator         Href_Pref.Indicator_Nt;
    v_Oper_Type         Href_Pref.Oper_Type_Nt;
    v_Hirings           Arraylist := p.r_Arraylist('hirings');
    v_Hiring            Hashmap;
    v_Page_Id           number;
    v_Robot_Id          number;
    v_Employee_Id       number;
    v_Contract_Id       number;
    v_Division_Id       number;
    v_Item_Id           number;
    v_Hiring_Date       date;
    v_Dismissal_Date    date;
    v_Indicator_Map     Hashmap;
    v_Oper_Type_Map     Hashmap;
    v_Indicators        Arraylist;
    v_Oper_Types        Arraylist;
    v_Contract_Services Arraylist;
    v_Item              Hashmap;
    v_Contract_Files    Arraylist;
    v_File              Hashmap;
    v_Posted            varchar2(1) := p.r_Varchar2('posted');
    result              Hashmap;
  begin
    Hpd_Util.Hiring_Journal_New(o_Journal         => v_Journal,
                                i_Company_Id      => Ui.Company_Id,
                                i_Filial_Id       => Ui.Filial_Id,
                                i_Journal_Id      => i_Journal_Id,
                                i_Journal_Type_Id => p.r_Number('journal_type_id'),
                                i_Journal_Number  => p.o_Varchar2('journal_number'),
                                i_Journal_Date    => p.r_Date('journal_date'),
                                i_Journal_Name    => p.o_Varchar2('journal_name'));
  
    for i in 1 .. v_Hirings.Count
    loop
      v_Hiring         := Treat(v_Hirings.r_Hashmap(i) as Hashmap);
      v_Page_Id        := v_Hiring.o_Number('page_id');
      v_Employee_Id    := v_Hiring.r_Number('employee_id');
      v_Division_Id    := v_Hiring.r_Number('division_id');
      v_Hiring_Date    := v_Hiring.r_Date('hiring_date');
      v_Dismissal_Date := v_Hiring.r_Date('dismissal_date');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      v_Robot_Id := v_Hiring.o_Number('robot_id');
    
      if v_Robot_Id is null then
        v_Robot_Id := Mrf_Next.Robot_Id;
      end if;
    
      Hpd_Util.Robot_New(o_Robot           => v_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => v_Division_Id,
                         i_Job_Id          => v_Hiring.r_Number('job_id'),
                         i_Org_Unit_Id     => v_Hiring.o_Number('org_unit_id'),
                         i_Rank_Id         => v_Hiring.o_Number('rank_id'),
                         i_Wage_Scale_Id   => v_Hiring.o_Number('wage_scale_id'),
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Contractor,
                         i_Fte_Id          => v_Hiring.o_Number('fte_id'),
                         i_Fte             => v_Hiring.o_Number('fte'));
    
      Uit_Href.Assert_Access_To_Division(v_Robot.Division_Id);
    
      if v_Robot.Fte_Id = Href_Pref.c_Custom_Fte_Id then
        v_Robot.Fte_Id := null;
      end if;
    
      v_Indicators := v_Hiring.r_Arraylist('hiring_indicators');
      v_Indicator  := Href_Pref.Indicator_Nt();
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator_Map := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
      
        Hpd_Util.Indicator_Add(p_Indicator       => v_Indicator,
                               i_Indicator_Id    => v_Indicator_Map.r_Number('indicator_id'),
                               i_Indicator_Value => v_Indicator_Map.r_Number('indicator_value'));
      end loop;
    
      v_Oper_Types := v_Hiring.r_Arraylist('hiring_oper_types');
      v_Oper_Type  := Href_Pref.Oper_Type_Nt();
    
      for j in 1 .. v_Oper_Types.Count
      loop
        v_Oper_Type_Map := Treat(v_Oper_Types.r_Hashmap(j) as Hashmap);
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => v_Oper_Type,
                               i_Oper_Type_Id  => v_Oper_Type_Map.r_Number('oper_type_id'),
                               i_Indicator_Ids => Nvl(v_Oper_Type_Map.o_Array_Number('indicator_ids'),
                                                      Array_Number()));
      end loop;
    
      Attach_Employee(v_Employee_Id);
    
      v_Contract_Id := v_Hiring.o_Number('contract_id');
    
      if v_Contract_Id is null then
        v_Contract_Id := Hpd_Next.Cv_Contract_Id;
      end if;
    
      Hpd_Util.Cv_Contract_New(o_Contract                 => v_Cv_Contract,
                               i_Company_Id               => Ui.Company_Id,
                               i_Filial_Id                => Ui.Filial_Id,
                               i_Contract_Id              => v_Contract_Id,
                               i_Contract_Number          => v_Hiring.o_Varchar2('contract_number'),
                               i_Page_Id                  => v_Page_Id,
                               i_Division_Id              => v_Division_Id,
                               i_Person_Id                => v_Employee_Id,
                               i_Begin_Date               => v_Hiring_Date,
                               i_End_Date                 => v_Dismissal_Date,
                               i_Contract_Kind            => v_Hiring.r_Varchar2('contract_kind'),
                               i_Contract_Employment_Kind => Hpd_Pref.c_Contract_Employment_Staff_Member,
                               i_Access_To_Add_Item       => v_Hiring.r_Varchar2('access_to_add_item'),
                               i_Early_Closed_Date        => null,
                               i_Early_Closed_Note        => null,
                               i_Note                     => v_Hiring.o_Varchar2('note'));
    
      v_Contract_Services := v_Hiring.r_Arraylist('contract_services');
    
      for i in 1 .. v_Contract_Services.Count
      loop
        v_Item    := Treat(v_Contract_Services.r_Hashmap(i) as Hashmap);
        v_Item_Id := v_Item.o_Number('contract_item_id');
      
        if v_Item_Id is null then
          v_Item_Id := Hpd_Next.Cv_Contract_Item_Id;
        end if;
      
        Hpd_Util.Cv_Contract_Add_Item(o_Contract         => v_Cv_Contract,
                                      i_Contract_Item_Id => v_Item_Id,
                                      i_Name             => v_Item.r_Varchar2('name'),
                                      i_Quantity         => v_Item.o_Number('quantity'),
                                      i_Amount           => v_Item.o_Number('amount'));
      end loop;
    
      v_Contract_Files := v_Hiring.r_Arraylist('hiring_contract_files');
    
      for i in 1 .. v_Contract_Files.Count
      loop
        v_File := Treat(v_Contract_Files.r_Hashmap(i) as Hashmap);
      
        Hpd_Util.Cv_Contract_Add_File(o_Contract => v_Cv_Contract,
                                      i_File_Sha => v_File.r_Varchar2('file_sha'),
                                      i_Note     => v_File.o_Varchar2('note'));
      end loop;
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => v_Journal,
                                  i_Page_Id              => v_Page_Id,
                                  i_Employee_Id          => v_Employee_Id,
                                  i_Staff_Number         => v_Hiring.o_Varchar2('staff_number'),
                                  i_Hiring_Date          => v_Hiring_Date,
                                  i_Dismissal_Date       => v_Dismissal_Date,
                                  i_Trial_Period         => Nvl(v_Hiring.o_Number('trial_period'), 0),
                                  i_Employment_Source_Id => v_Hiring.o_Number('source_id'),
                                  i_Schedule_Id          => v_Hiring.o_Number('schedule_id'),
                                  i_Currency_Id          => v_Hiring.o_Number('currency_id'),
                                  i_Vacation_Days_Limit  => v_Hiring.o_Number('vacation_days_limit'),
                                  i_Is_Booked            => Nvl(v_Hiring.o_Varchar2('is_booked'),
                                                                'N'),
                                  i_Robot                => v_Robot,
                                  i_Contract             => null,
                                  i_Cv_Contract          => v_Cv_Contract,
                                  i_Indicators           => v_Indicator,
                                  i_Oper_Types           => v_Oper_Type);
    end loop;
  
    Hpd_Api.Hiring_Journal_Save(v_Journal, i_Delay_Repairing => i_Repost);
  
    if v_Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    if i_Repost then
      Hpd_Api.Journal_Repairing(i_Company_Id => v_Journal.Company_Id,
                                i_Filial_Id  => v_Journal.Filial_Id,
                                i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    result := Fazo.Zip_Map('journal_id', --
                           i_Journal_Id,
                           'journal_name',
                           v_Journal.Journal_Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpd_Next.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Repost  boolean;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    v_Repost := r_Journal.Posted = 'Y' and p.r_Varchar2('posted') = 'Y';
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => v_Repost);
    end if;
  
    return save(r_Journal.Journal_Id, p, v_Repost);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Staff_Kind     = null,
           State          = null;
  
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  
    update Hrm_Robots
       set Company_Id               = null,
           Filial_Id                = null,
           Robot_Id                 = null,
           Org_Unit_Id              = null,
           Rank_Id                  = null,
           Opened_Date              = null,
           Closed_Date              = null,
           Position_Employment_Kind = null;
  
    update Hrm_Robot_Turnover
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Period     = null,
           Fte        = null;
  
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           Job_Id      = null,
           name        = null;
  
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
  
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Job_Id      = null,
           Division_Id = null;
  
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null,
           Order_No   = null;
  
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
  
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
  
    update Hpr_Oper_Types
       set Company_Id    = null,
           Oper_Type_Id  = null,
           Oper_Group_Id = null;
  
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Wage_Scale_Id = null,
           name          = null,
           State         = null;
  
    update Href_Cached_Contract_Item_Names
       set Company_Id = null,
           name       = null;
  
    Uie.x(Uit_Href.Get_Staff_Status(i_Hiring_Date    => null,
                                    i_Dismissal_Date => null,
                                    i_Date           => null));
  end;

end Ui_Vhr637;
/
