create or replace package Ui_Vhr258 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Robot_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Labor_Functions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
end Ui_Vhr258;
/
create or replace package body Ui_Vhr258 is
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
    q := Fazo_Query('mpr_oper_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'operation_kind',
                                 Mpr_Pref.c_Ok_Accrual,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('oper_type_id');
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
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2 is
  begin
    return Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => p.o_Number('job_id'));
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
  Function Model return Hashmap is
    v_Matrix       Matrix_Varchar2;
    v_Division_Ids Array_Number;
    v_Date         date := Trunc(sysdate);
    result         Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Robot_Id,
                          q.Name,
                          q.Code,
                          q.Robot_Group_Id,
                          (select g.Name
                             from Mr_Robot_Groups g
                            where g.Company_Id = q.Company_Id
                              and g.Robot_Group_Id = q.Robot_Group_Id),
                          q.Division_Id,
                          q.Job_Id,
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = q.Company_Id
                              and j.Filial_Id = q.Filial_Id
                              and j.Job_Id = q.Job_Id),
                          q.State,
                          v_Date, -- opened_date,
                          'Y', -- contractual_wage
                          'N', -- is_valid
                          Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => q.Job_Id)),
           q.Division_Id
      bulk collect
      into v_Matrix, v_Division_Ids
      from Mrf_Robots q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and not exists (select 1
              from Hrm_Robots w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Robot_Id = q.Robot_Id);
  
    Result.Put('robots', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Ids => v_Division_Ids)));
    Result.Put('wage_indicator_id',
               Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Roles
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return Array_Number is
    result Array_Number;
  begin
    select Rl.Role_Id
      bulk collect
      into result
      from Mrf_Robot_Roles Rl
     where Rl.Company_Id = i_Company_Id
       and Rl.Filial_Id = i_Filial_Id
       and Rl.Robot_Id = i_Robot_Id;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    p_Robot      Hrm_Pref.Robot_Rt;
    v_Robots     Arraylist := p.r_Arraylist('robots');
    v_Indicators Arraylist;
    v_Oper_Types Arraylist;
    v_Robot      Hashmap;
    v_Indicator  Hashmap;
    v_Oper_Type  Hashmap;
    v_Person_Id  number;
  begin
    for i in 1 .. v_Robots.Count
    loop
      v_Robot := Treat(v_Robots.r_Hashmap(i) as Hashmap);
    
      Hrm_Util.Robot_New(o_Robot                => p_Robot,
                         i_Company_Id           => Ui.Company_Id,
                         i_Filial_Id            => Ui.Filial_Id,
                         i_Robot_Id             => v_Robot.r_Number('robot_id'),
                         i_Name                 => v_Robot.r_Varchar2('name'),
                         i_Code                 => v_Robot.o_Varchar2('code'),
                         i_Robot_Group_Id       => v_Robot.o_Number('robot_group_id'),
                         i_Division_Id          => v_Robot.r_Number('division_id'),
                         i_Org_Unit_Id          => v_Robot.o_Number('org_unit_id'),
                         i_Job_Id               => v_Robot.r_Number('job_id'),
                         i_State                => v_Robot.r_Varchar2('state'),
                         i_Opened_Date          => v_Robot.r_Date('opened_date'),
                         i_Closed_Date          => v_Robot.o_Date('closed_date'),
                         i_Schedule_Id          => v_Robot.o_Number('schedule_id'),
                         i_Vacation_Days_Limit  => v_Robot.o_Number('vacation_days_limit'),
                         i_Rank_Id              => v_Robot.o_Number('rank_id'),
                         i_Labor_Function_Id    => v_Robot.o_Number('labor_function_id'),
                         i_Description          => v_Robot.o_Varchar2('description'),
                         i_Hiring_Condition     => v_Robot.o_Varchar2('hiring_condition'),
                         i_Wage_Scale_Id        => v_Robot.o_Number('wage_scale_id'),
                         i_Currency_Id          => v_Robot.o_Number('currency_id'),
                         i_Access_Hidden_Salary => 'N',
                         i_Contractual_Wage     => v_Robot.r_Varchar2('contractual_wage'),
                         i_Role_Ids             => Get_Robot_Roles(i_Company_Id => Ui.Company_Id,
                                                                   i_Filial_Id  => Ui.Filial_Id,
                                                                   i_Robot_Id   => v_Robot.r_Number('robot_id')));
    
      v_Indicators := v_Robot.o_Arraylist('indicators');
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
      
        Hrm_Util.Indicator_Add(p_Robot           => p_Robot,
                               i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                               i_Indicator_Value => Nvl(v_Indicator.o_Number('indicator_value'), 0));
      end loop;
    
      v_Oper_Types := v_Robot.o_Arraylist('oper_types');
    
      for j in 1 .. v_Oper_Types.Count
      loop
        v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(j) as Hashmap);
      
        Hrm_Util.Oper_Type_Add(p_Robot         => p_Robot,
                               i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                               i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                      Array_Number()));
      end loop;
    
      v_Person_Id := z_Mrf_Robots.Load(i_Company_Id => p_Robot.Robot.Company_Id, --
                     i_Filial_Id => p_Robot.Robot.Filial_Id, --
                     i_Robot_Id => p_Robot.Robot.Robot_Id).Person_Id;
    
      Hrm_Api.Robot_Save(p_Robot);
    
      if v_Person_Id is not null then
        Hrm_Api.Restore_Robot_Person(i_Company_Id => p_Robot.Robot.Company_Id,
                                     i_Filial_Id  => p_Robot.Robot.Filial_Id,
                                     i_Robot_Id   => p_Robot.Robot.Robot_Id,
                                     i_Person_Id  => v_Person_Id);
      end if;
    end loop;
  
    Mrf_Api.Gen_Robot_Person_Roles;
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
  end;

end Ui_Vhr258;
/
