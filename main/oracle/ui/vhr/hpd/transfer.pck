create or replace package Ui_Vhr51 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
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
  Function Query_Oper_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Fixed_Term_Bases return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Wage_Scale(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Template(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Robot(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------   
  Function Load_Rank_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------   
  Function Load_Wage_Scale_Indicator_Ids(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr51;
/
create or replace package body Ui_Vhr51 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select * 
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.state = ''A''';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))
                              and s.employee_id <> :user_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id', 'fte');
    q.Varchar2_Field('staff_number', 'staff_kind', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Robots(p Hashmap) return Fazo_Query is
    q              Fazo_Query;
    v_Query        varchar2(3000);
    v_Params       Hashmap;
    v_End_Filter   varchar2(100) := '';
    v_Transfer_End date := p.o_Date('transfer_end');
  begin
    if v_Transfer_End is not null then
      v_End_Filter := ' and rob.period <= :transfer_end';
    end if;
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'transfer_begin',
                             p.r_Date('transfer_begin'),
                             'transfer_end',
                             v_Transfer_End);
  
    v_Query := 'select p.*,
                       q.division_id,
                       q.job_id,
                       q.name,
                       (select min(fte)
                          from hrm_robot_turnover rob
                         where rob.company_id = p.company_id
                           and rob.filial_id = p.filial_id
                           and rob.robot_id = p.robot_id
                           and (rob.period >= :transfer_begin or
                                rob.period = (select max(rt.period)
                                             from hrm_robot_turnover rt
                                            where rt.company_id = rob.company_id
                                              and rt.filial_id = rob.filial_id
                                              and rt.robot_id = rob.robot_id
                                              and rt.period <= :transfer_begin))' ||
               v_End_Filter || ') fte 
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
  
    q.Multi_Number_Field('employee_ids',
                         'select q.person_id,
                                 q.robot_id 
                            from mrf_robot_persons q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id',
                         '@robot_id = $robot_id',
                         'person_id');
  
    q.Refer_Field('employee_names',
                  'employee_ids',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select q.* 
                     from mr_natural_persons q
                    where q.company_id = :company_id
                      and exists (select 1
                             from mrf_robot_persons rp
                            where rp.company_id = :company_id
                              and rp.filial_id = :filial_id
                              and rp.person_id = q.person_id)');
  
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
  Function Query_Fixed_Term_Bases return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_fixed_term_bases',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('fixed_term_base_id');
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
  Function Get_Wage_Scale(p Hashmap) return Hashmap is
    v_Matrix      Matrix_Varchar2;
    v_Rank_Id     number := p.r_Number('rank_id');
    v_Register_Id number := Hrm_Util.Closest_Register_Id(i_Company_Id    => Ui.Company_Id,
                                                         i_Filial_Id     => Ui.Filial_Id,
                                                         i_Wage_Scale_Id => p.r_Number('wage_scale_id'),
                                                         i_Period        => p.r_Date('transfer_begin'));
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
  Function Get_Robot(p Hashmap) return Hashmap is
    r_Settings                Hrm_Settings%rowtype;
    r_Current_Staff           Href_Staffs%rowtype;
    r_Robot                   Hrm_Robots%rowtype;
    r_Base_Robot              Mrf_Robots%rowtype;
    v_Matrix                  Matrix_Varchar2;
    v_Access_To_Hidden_Salary varchar2(1);
    v_Transfer_Begin          date := p.r_Date('transfer_begin');
    v_Busy_Robots_Mode        boolean := Nvl(p.o_Varchar2('busy_robots_mode'), 'N') = 'Y';
    v_Fte                     number;
    v_Current_Staff           Hashmap;
    result                    Hashmap;
  
    --------------------------------------------------
    Function Get_Current_Staff
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Robot_Id   number,
      i_Period     date
    ) return Href_Staffs%rowtype is
      v_Staff_Id number;
    begin
      select q.Staff_Id
        into v_Staff_Id
        from Hpd_Agreements_Cache q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Robot_Id = i_Robot_Id
         and i_Period between q.Begin_Date and q.End_Date
         and Rownum = 1;
    
      return z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => v_Staff_Id);
    exception
      when No_Data_Found then
        return null;
    end;
  
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
                                  z.Opened_Date,
                                  z.Closed_Date,
                                  z.Schedule_Id,
                                  z.Rank_Id,
                                  z.Contractual_Wage,
                                  z.Hiring_Condition,
                                  i_Hiring_Condition => 'hiring_conditions');
    Result.Put_All(z_Mrf_Robots.To_Map(r_Base_Robot, z.Name, z.Division_Id, z.Job_Id));
  
    if v_Access_To_Hidden_Salary = 'Y' then
      Result.Put('currency_id', r_Robot.Currency_Id);
      Result.Put('currency_name',
                 z_Mk_Currencies.Take(i_Company_Id => r_Robot.Company_Id, i_Currency_Id => r_Robot.Currency_Id).Name);
    end if;
  
    Result.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary);
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
        Result.Put_All(Load_Wage_Scale_Indicator_Ids(Fazo.Zip_Map('transfer_begin',
                                                                  v_Transfer_Begin,
                                                                  'wage_scale_id',
                                                                  r_Robot.Wage_Scale_Id)));
      end if;
    end if;
  
    v_Fte := Coalesce(p.o_Number('fte'),
                      Uit_Hrm.Robot_Fte(i_Robot_Id     => r_Robot.Robot_Id,
                                        i_Period_Begin => v_Transfer_Begin,
                                        i_Period_End   => p.o_Date('transfer_end')));
  
    if v_Busy_Robots_Mode then
      r_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id);
    
      if r_Settings.Position_Enable = 'Y' then
        r_Current_Staff := Get_Current_Staff(i_Company_Id => r_Robot.Company_Id,
                                             i_Filial_Id  => r_Robot.Filial_Id,
                                             i_Robot_Id   => r_Robot.Robot_Id,
                                             i_Period     => Trunc(sysdate));
      
        v_Current_Staff := z_Href_Staffs.To_Map(r_Current_Staff, z.Staff_Id, z.Employee_Id);
      
        v_Current_Staff.Put('name',
                            Href_Util.Staff_Name(i_Company_Id => r_Current_Staff.Company_Id,
                                                 i_Filial_Id  => r_Current_Staff.Filial_Id,
                                                 i_Staff_Id   => r_Current_Staff.Staff_Id));
      
        Result.Put('swapped_staff', v_Current_Staff);
      
        v_Fte := Nvl(Hpd_Util.Get_Closest_Fte(i_Company_Id => r_Current_Staff.Company_Id,
                                              i_Filial_Id  => r_Current_Staff.Filial_Id,
                                              i_Staff_Id   => r_Current_Staff.Staff_Id,
                                              i_Period     => v_Transfer_Begin),
                     Href_Pref.c_Default_Fte);
      end if;
    end if;
  
    Result.Put_All(Uit_Href.Get_Fte(v_Fte));
  
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
                                                  i_Period        => p.r_Date('transfer_date'));
  
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
                                                  i_Period        => p.r_Date('transfer_begin'));
  
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
  Function Get_Transfers
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Page_Ids        Array_Number;
    v_Matrix          Matrix_Varchar2;
    v_Custom_Fte_Name varchar2(32767) := Href_Util.t_Custom_Fte_Name;
    result            Hashmap := Hashmap();
  begin
    select Array_Varchar2(Tr.Page_Id,
                           Tr.Transfer_Begin,
                           Tr.Transfer_End,
                           Tr.Is_Booked,
                           Tr.Staff_Id,
                           Tr.Employee_Id,
                           Tr.Employee_Name,
                           Tr.Robot_Id,
                           Tr.Robot_Name,
                           Tr.Division_Id,
                           Tr.Job_Id,
                           Tr.Job_Name,
                           Tr.Org_Unit_Id,
                           case
                             when Tr.Allow_Rank = 'Y' or Tr.Rank_Id is not null then
                              'N'
                             else
                              'Y'
                           end,
                           Tr.Rank_Id,
                           Tr.Rank_Name,
                           Tr.Schedule_Id,
                           Tr.Schedule_Name,
                           case
                             when Tr.Access_To_Hidden_Salary_Job = 'Y' then
                              Tr.Currency_Id
                             else
                              null
                           end,
                           case
                             when Tr.Access_To_Hidden_Salary_Job = 'Y' then
                              Tr.Currency_Name
                             else
                              null
                           end,
                           Tr.Days_Limit,
                           Tr.Contractual_Wage,
                           Tr.Employment_Type,
                           Tr.Employment_Type_Name,
                           Tr.Fte_Id,
                           Tr.Fte_Name,
                           Tr.Fte,
                           case
                             when Tr.Access_To_Hidden_Salary_Job = 'Y' then
                              Tr.Wage_Scale_Id
                             else
                              null
                           end,
                           case
                             when Tr.Access_To_Hidden_Salary_Job = 'Y' then
                              Tr.Wage_Scale_Name
                             else
                              null
                           end,
                           Tr.Transfer_Reason,
                           Tr.Transfer_Base,
                           Tr.Fixed_Term,
                           Tr.Expiry_Date,
                           Tr.Fixed_Term_Base_Id,
                           Tr.Fixed_Term_Base_Name,
                           Tr.Concluding_Term,
                           Tr.Hiring_Conditions,
                           Tr.Other_Conditions,
                           Tr.Workplace_Equipment,
                           Tr.Representative_Basis,
                           Tr.Access_To_Hidden_Salary_Job),
           case
             when Tr.Access_To_Hidden_Salary_Job = 'Y' then
              Tr.Page_Id
             else
              null
           end
      bulk collect
      into v_Matrix, v_Page_Ids
      from (select q.Page_Id,
                   w.Transfer_Begin,
                   w.Transfer_End,
                   Nvl(m.Is_Booked, 'N') Is_Booked,
                   q.Staff_Id,
                   q.Employee_Id,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = q.Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   m.Robot_Id,
                   t.Name as Robot_Name,
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
                   m.Allow_Rank,
                   m.Rank_Id,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = m.Company_Id
                       and k.Filial_Id = m.Filial_Id
                       and k.Rank_Id = m.Rank_Id) as Rank_Name,
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
                   Pl.Days_Limit,
                   (select k.Contractual_Wage
                      from Hrm_Robots k
                     where k.Company_Id = m.Company_Id
                       and k.Filial_Id = m.Filial_Id
                       and k.Robot_Id = m.Robot_Id) as Contractual_Wage,
                   m.Employment_Type,
                   Hpd_Util.t_Employment_Type(m.Employment_Type) as Employment_Type_Name,
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
                   w.Transfer_Reason,
                   w.Transfer_Base,
                   Nvl(c.Fixed_Term, 'N') as Fixed_Term,
                   c.Expiry_Date,
                   c.Fixed_Term_Base_Id,
                   (select k.Name
                      from Href_Fixed_Term_Bases k
                     where k.Company_Id = c.Company_Id
                       and k.Fixed_Term_Base_Id = c.Fixed_Term_Base_Id) as Fixed_Term_Base_Name,
                   c.Concluding_Term,
                   c.Hiring_Conditions,
                   c.Other_Conditions,
                   c.Workplace_Equipment,
                   c.Representative_Basis,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => t.Job_Id,
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary_Job
              from Hpd_Journal_Pages q
              join Hpd_Transfers w
                on w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Page_Id = q.Page_Id
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
              left join Hpd_Page_Vacation_Limits Pl
                on Pl.Company_Id = q.Company_Id
               and Pl.Filial_Id = q.Filial_Id
               and Pl.Page_Id = q.Page_Id
              left join Hpd_Page_Contracts c
                on c.Company_Id = q.Company_Id
               and c.Filial_Id = q.Filial_Id
               and c.Page_Id = q.Page_Id
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
               and q.Journal_Id = i_Journal_Id) Tr;
  
    Result.Put('transfers', Fazo.Zip_Matrix(v_Matrix));
  
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
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Info(p Hashmap) return Hashmap is
    r_Trans_Robot   Hpd_Trans_Robots%rowtype;
    r_Robot         Mrf_Robots%rowtype;
    r_h_Robot       Hrm_Robots%rowtype;
    v_Division_Name varchar2(400 char);
    v_Staff_Id      number := p.r_Number('staff_id');
    v_Period        date := p.r_Date('transfer_begin');
    v_Schedule_Id   number;
    v_Rank_Id       number;
    result          Hashmap := Hashmap();
  begin
    r_Trans_Robot := Hpd_Util.Closest_Robot(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Staff_Id   => v_Staff_Id,
                                            i_Period     => v_Period);
    r_Robot       := z_Mrf_Robots.Take(i_Company_Id => r_Trans_Robot.Company_Id,
                                       i_Filial_Id  => r_Trans_Robot.Filial_Id,
                                       i_Robot_Id   => r_Trans_Robot.Robot_Id);
  
    if r_Robot.Robot_Id is not null then
      r_h_Robot := z_Hrm_Robots.Load(i_Company_Id => r_Robot.Company_Id,
                                     i_Filial_Id  => r_Robot.Filial_Id,
                                     i_Robot_Id   => r_Robot.Robot_Id);
    
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => r_Robot.Company_Id,
                                                        i_Filial_Id  => r_Robot.Filial_Id,
                                                        i_Staff_Id   => v_Staff_Id,
                                                        i_Period     => v_Period);
    
      v_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Robot.Company_Id,
                                                i_Filial_Id  => r_Robot.Filial_Id,
                                                i_Staff_Id   => v_Staff_Id,
                                                i_Period     => v_Period);
    
      v_Division_Name := z_Mhr_Divisions.Load(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Division_Id => r_Robot.Division_Id).Name;
    
      if r_h_Robot.Org_Unit_Id <> r_Robot.Division_Id then
        v_Division_Name := v_Division_Name || '/' || --
                           z_Mhr_Divisions.Load(i_Company_Id => r_h_Robot.Company_Id, i_Filial_Id => r_h_Robot.Filial_Id, i_Division_Id => r_h_Robot.Org_Unit_Id).Name;
      end if;
    
      Result.Put('current_job',
                 z_Mhr_Jobs.Load(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Job_Id => r_Robot.Job_Id).Name);
      Result.Put('current_rank',
                 z_Mhr_Ranks.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Rank_Id => v_Rank_Id).Name);
      Result.Put('current_rank_id', v_Rank_Id);
      Result.Put('current_division', v_Division_Name);
      Result.Put('current_schedule',
                 z_Htt_Schedules.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Schedule_Id => v_Schedule_Id).Name);
      Result.Put('current_robot_id', r_Robot.Robot_Id);
    
      if Hrm_Util.Load_Setting(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id).Position_Enable = 'Y' then
        Result.Put('current_robot', r_Robot.Name);
      
        Result.Put('current_fte', r_Trans_Robot.Fte);
      end if;
    end if;
  
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
    Result.Put('pek_staff', Hrm_Pref.c_Position_Employment_Staff);
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer));
    Result.Put('employment_types', Fazo.Zip_Matrix(Hpd_Util.Employment_Types));
    Result.Put('wage_id',
               Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
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
                                         z.Keep_Schedule,
                                         z.Keep_Vacation_Limit));
  
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
    Result.Put('user_id', Ui.User_Id);
    Result.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
    Result.Put('all_org_units', Fazo.Zip_Matrix(Uit_Hrm.Org_Units));
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
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
    if not Hpd_Util.Is_Transfer_Journal(i_Company_Id      => Ui.Company_Id,
                                        i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_type_id',
                           v_Journal_Type_Id,
                           'journal_date',
                           Trunc(sysdate),
                           'transfer_begin',
                           Trunc(sysdate),
                           'employment_type',
                           Hpd_Pref.c_Employment_Type_Main_Job,
                           'employment_type_name',
                           Hpd_Util.t_Employment_Type(Hpd_Pref.c_Employment_Type_Main_Job));
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('fixed_term', 'N');
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
  
    if not Hpd_Util.Is_Transfer_Journal(i_Company_Id      => Ui.Company_Id,
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
                                    z.Journal_Name);
  
    Result.Put_All(Get_Transfers(i_Company_Id => r_Journal.Company_Id,
                                 i_Filial_Id  => r_Journal.Filial_Id,
                                 i_Journal_Id => r_Journal.Journal_Id));
  
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Journal_Id number,
    p            Hashmap,
    i_Repost     boolean := false,
    i_Exists     boolean := false
  ) return Hashmap is
    p_Journal            Hpd_Pref.Transfer_Journal_Rt;
    p_Robot              Hpd_Pref.Robot_Rt;
    p_Contract           Hpd_Pref.Contract_Rt;
    p_Indicator          Href_Pref.Indicator_Nt;
    p_Oper_Type          Href_Pref.Oper_Type_Nt;
    v_Transfers          Arraylist := p.r_Arraylist('transfer');
    v_Transfer           Hashmap;
    v_Page_Id            number;
    v_Staff_Id           number;
    v_Indicator          Hashmap;
    v_Oper_Type          Hashmap;
    v_Indicators         Arraylist;
    v_Oper_Types         Arraylist;
    v_Notification_Title varchar2(500);
    v_Posted             varchar2(1) := p.r_Varchar2('posted');
    v_User_Id            number := Ui.User_Id;
    v_Rank_Id            number;
    v_Allow_Rank         varchar2(1);
    result               Hashmap;
  begin
    Hpd_Util.Transfer_Journal_New(o_Journal         => p_Journal,
                                  i_Company_Id      => Ui.Company_Id,
                                  i_Filial_Id       => Ui.Filial_Id,
                                  i_Journal_Id      => i_Journal_Id,
                                  i_Journal_Type_Id => p.r_Number('journal_type_id'),
                                  i_Journal_Number  => p.o_Varchar2('journal_number'),
                                  i_Journal_Date    => p.r_Date('journal_date'),
                                  i_Journal_Name    => p.o_Varchar2('journal_name'),
                                  i_Lang_Code       => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Transfers.Count
    loop
      v_Transfer := Treat(v_Transfers.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Transfer.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Page_Id := v_Transfer.o_Number('page_id');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      v_Rank_Id    := v_Transfer.o_Number('rank_id');
      v_Allow_Rank := 'Y';
    
      if v_Transfer.o_Varchar2('rank_remains') = 'Y' then
        v_Rank_Id    := null;
        v_Allow_Rank := 'N';            
      end if;
    
      Hpd_Util.Robot_New(o_Robot           => p_Robot,
                         i_Robot_Id        => v_Transfer.o_Number('robot_id'),
                         i_Division_Id     => v_Transfer.o_Number('division_id'),
                         i_Job_Id          => v_Transfer.o_Number('job_id'),
                         i_Org_Unit_Id     => v_Transfer.o_Number('org_unit_id'),
                         i_Rank_Id         => v_Rank_Id,
                         i_Allow_Rank      => v_Allow_Rank,
                         i_Wage_Scale_Id   => v_Transfer.o_Number('wage_scale_id'),
                         i_Employment_Type => v_Transfer.r_Varchar2('employment_type'),
                         i_Fte_Id          => v_Transfer.o_Number('fte_id'),
                         i_Fte             => v_Transfer.o_Number('fte'));
    
      if p_Robot.Division_Id is not null then
        Uit_Href.Assert_Access_To_Division(p_Robot.Division_Id);
      end if;
    
      if p_Robot.Fte_Id = Href_Pref.c_Custom_Fte_Id then
        p_Robot.Fte_Id := null;
      end if;
    
      if p_Robot.Division_Id is not null and p_Robot.Job_Id is not null then
        if p_Robot.Robot_Id is null then
          p_Robot.Robot_Id := Mrf_Next.Robot_Id;
        end if;
      end if;
    
      Hpd_Util.Contract_New(o_Contract             => p_Contract,
                            i_Contract_Number      => null,
                            i_Contract_Date        => null,
                            i_Fixed_Term           => v_Transfer.o_Varchar2('fixed_term'),
                            i_Expiry_Date          => v_Transfer.o_Date('expiry_date'),
                            i_Fixed_Term_Base_Id   => v_Transfer.o_Number('fixed_term_base_id'),
                            i_Concluding_Term      => v_Transfer.o_Varchar2('concluding_term'),
                            i_Hiring_Conditions    => v_Transfer.o_Varchar2('hiring_conditions'),
                            i_Other_Conditions     => v_Transfer.o_Varchar2('other_conditions'),
                            i_Workplace_Equipment  => v_Transfer.o_Varchar2('workplace_equipment'),
                            i_Representative_Basis => v_Transfer.o_Varchar2('representative_basis'));
    
      v_Indicators := v_Transfer.r_Arraylist('indicators');
      p_Indicator  := Href_Pref.Indicator_Nt();
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
      
        Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                               i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                               i_Indicator_Value => v_Indicator.r_Number('indicator_value'));
      end loop;
    
      v_Oper_Types := v_Transfer.r_Arraylist('oper_types');
      p_Oper_Type  := Href_Pref.Oper_Type_Nt();
    
      for j in 1 .. v_Oper_Types.Count
      loop
        v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(j) as Hashmap);
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                               i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                               i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                      Array_Number()));
      end loop;
    
      Hpd_Util.Journal_Add_Transfer(p_Journal             => p_Journal,
                                    i_Page_Id             => v_Page_Id,
                                    i_Transfer_Begin      => v_Transfer.r_Date('transfer_begin'),
                                    i_Transfer_End        => v_Transfer.o_Date('transfer_end'),
                                    i_Staff_Id            => v_Staff_Id,
                                    i_Schedule_Id         => v_Transfer.o_Number('schedule_id'),
                                    i_Currency_Id         => v_Transfer.o_Number('currency_id'),
                                    i_Vacation_Days_Limit => v_Transfer.o_Number('vacation_days_limit'),
                                    i_Transfer_Reason     => v_Transfer.o_Varchar2('transfer_reason'),
                                    i_Transfer_Base       => v_Transfer.o_Varchar2('transfer_base'),
                                    i_Is_Booked           => Nvl(v_Transfer.o_Varchar2('is_booked'),
                                                                 'N'),
                                    i_Robot               => p_Robot,
                                    i_Contract            => p_Contract,
                                    i_Indicators          => p_Indicator,
                                    i_Oper_Types          => p_Oper_Type);
    end loop;
  
    -- notification title should make before saving journal
    if i_Exists = false and v_Posted = 'N' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Save(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    elsif i_Repost = false and v_Posted = 'Y' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    else
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Update(i_Company_Id      => p_Journal.Company_Id,
                                                                           i_User_Id         => v_User_Id,
                                                                           i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    end if;
  
    Hpd_Api.Transfer_Journal_Save(p_Journal, i_Delay_Repairing => i_Repost);
  
    if v_Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  
    if i_Repost then
      Hpd_Api.Journal_Repairing(i_Company_Id => p_Journal.Company_Id,
                                i_Filial_Id  => p_Journal.Filial_Id,
                                i_Journal_Id => p_Journal.Journal_Id);
    end if;
  
    -- notification send after saving journal
    Href_Core.Send_Notification(i_Company_Id    => p_Journal.Company_Id,
                                i_Filial_Id     => p_Journal.Filial_Id,
                                i_Title         => v_Notification_Title,
                                i_Uri           => Hpd_Pref.c_Form_Transfer_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                p_Journal.Journal_Id,
                                                                'journal_type_id',
                                                                p_Journal.Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  
    result := Fazo.Zip_Map('journal_id', --
                           i_Journal_Id,
                           'journal_name',
                           p_Journal.Journal_Name);
  
    if v_Posted = 'Y' then
      Result.Put('cos_requests',
                 Hisl_Util.Journal_Requests(i_Company_Id => p_Journal.Company_Id,
                                            i_Filial_Id  => p_Journal.Filial_Id,
                                            i_Journal_Id => p_Journal.Journal_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap) is
  begin
    Hisl_Api.Process_Response(i_Company_Id    => Ui.Company_Id,
                              i_Filial_Id     => Ui.Filial_Id,
                              i_Status        => p.r_Varchar2('status'),
                              i_Url           => p.r_Varchar2('url'),
                              i_Request_Body  => p.r_Varchar2('request_body'),
                              i_Response_Body => p.r_Varchar2('response_body'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpd_Next.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Repost  boolean := false;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    if p.r_Varchar2('posted') = 'Y' and r_Journal.Posted = 'Y' then
      v_Repost := true;
    end if;
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => v_Repost);
    end if;
  
    return save(r_Journal.Journal_Id, p, v_Repost, true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Employee_Id     = null,
           Org_Unit_Id     = null,
           Hiring_Date     = null,
           Dismissal_Date  = null,
           Division_Id     = null,
           Employment_Type = null,
           Fte             = null,
           Staff_Kind      = null,
           State           = null;
    update Mr_Natural_Persons
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
    update Mhr_Jobs
       set Company_Id        = null,
           Filial_Id         = null,
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
    update Href_Fixed_Term_Bases
       set Company_Id         = null,
           Fixed_Term_Base_Id = null,
           name               = null,
           State              = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Wage_Scale_Id = null,
           name          = null,
           State         = null;
    update Mrf_Robot_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Person_Id  = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr51;
/
