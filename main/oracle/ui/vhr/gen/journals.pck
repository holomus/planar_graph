create or replace package Ui_Vhr233 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Robots(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employment_Sources return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Generate(p Hashmap);
end Ui_Vhr233;
/
create or replace package body Ui_Vhr233 is
  ----------------------------------------------------------------------------------------------------
  c_Section_Hiring    constant varchar2(1) := 'H';
  c_Section_Transfer  constant varchar2(1) := 'T';
  c_Section_Dismissal constant varchar2(1) := 'D';
  c_Section_Oper_Type constant varchar2(1) := 'O';
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
    return b.Translate('UI-VHR233:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('href_staffs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
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
  Function Query_Employees(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            uit_href.get_staff_status(s.hiring_date, s.dismissal_date, :hiring_date) as status
                       from mhr_employees q
                       left join href_staffs s
                         on s.company_id = q.company_id
                        and s.filial_id = q.filial_id
                        and s.employee_id = q.employee_id
                        and s.staff_kind = :sk_primary
                        and s.state = ''A''
                        and s.hiring_date = (select max(s1.hiring_date)
                                               from href_staffs s1
                                              where s1.company_id = q.company_id
                                                and s1.filial_id = q.filial_id
                                                and s1.employee_id = q.employee_id
                                                and s1.staff_kind = :sk_primary
                                                and s1.state = ''A''
                                                and s1.hiring_date <= :hiring_date)
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'hiring_date',
                                 p.r_Date('hiring_date'),
                                 'sk_primary',
                                 Href_Pref.c_Staff_Kind_Primary));
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('employee_number', 'state', 'status');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Robots(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select p.*,
                            q.division_id,
                            q.job_id,
                            q.name
                       from hrm_robots p
                       join mrf_robots q
                         on q.company_Id = p.company_id
                        and q.filial_Id = p.filial_id
                        and q.robot_Id = p.robot_id
                      where p.company_Id = :company_id
                        and p.filial_Id = :filial_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'period',
                                 p.r_Date('period')));
  
    q.Number_Field('robot_id', 'division_id', 'job_id', 'rank_id', 'fte');
    q.Date_Field('opened_date', 'closed_date');
    q.Varchar2_Field('name', 'contractual_wage');
  
    q.Map_Field('fte',
                'select min(fte)
                   from hrm_robot_turnover rob
                  where rob.company_id = :company_id
                    and rob.filial_id = :filial_id
                    and rob.robot_id = $robot_id
                    and (rob.period >= :period or
                        rob.period = (select max(rt.period)
                                      from hrm_robot_turnover rt
                                     where rt.company_id = rob.company_id
                                       and rt.filial_id = rob.filial_id
                                       and rt.robot_id = rob.robot_id
                                       and rt.period <= :period))');
  
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
  Function Query_Employment_Sources return Fazo_Query is
    q Fazo_Query;
  begin
  
    q := Fazo_Query('href_employment_sources',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('source_id');
    q.Varchar2_Field('name', 'kind');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Reasons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_dismissal_reasons', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('dismissal_reason_id');
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
  Function Query_Divisions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query(Uit_Hrm.Departments_Query(i_Only_Active => true),
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('division_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A',
                                 'c_divisions_exist',
                                 'N'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'state', 'c_divisions_exist');
  
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
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('section_hiring', c_Section_Hiring);
    Result.Put('section_transfer', c_Section_Transfer);
    Result.Put('section_dismissal', c_Section_Dismissal);
    Result.Put('section_oper_type', c_Section_Oper_Type);
    Result.Put('es_hiring', Href_Pref.c_Employment_Source_Kind_Hiring);
    Result.Put('es_dismissal', Href_Pref.c_Employment_Source_Kind_Dismissal);
    Result.Put('es_both', Href_Pref.c_Employment_Source_Kind_Both);
    Result.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
    Result.Put('position_enable',
               Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Position_Enable);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Sysdate date;
    v_Data    Hashmap;
    result    Hashmap := Hashmap();
  begin
    v_Sysdate := Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                            i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => Ui.Company_Id,
                                                                                  i_Filial_Id  => Ui.Filial_Id));
  
    v_Data := Fazo.Zip_Map('period_begin',
                           to_char(v_Sysdate, Href_Pref.c_Date_Format_Day),
                           'period_end',
                           to_char(v_Sysdate, Href_Pref.c_Date_Format_Day));
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Hiring
  (
    p                 Hashmap,
    i_Position_Enable varchar2
  ) is
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Oper_Types   Arraylist := p.r_Arraylist('oper_types');
    v_Oper_Type    Hashmap;
  
    v_Sysdate         date;
    v_Employee_Id     number;
    v_Robot_Id        number;
    v_Division_Id     number;
    v_Job_Id          number;
    v_Schedule_Id     number;
    v_Source_Id       number;
    v_Full_Id         number;
    v_Hiring_Date     date;
    v_Indicator_Value number;
    v_Robot_Ids       Array_Number;
    v_Schedule_Ids    Array_Number;
    v_Division_Ids    Array_Number;
    v_Job_Ids         Array_Number;
    v_Source_Ids      Array_Number;
    p_Journal         Hpd_Pref.Hiring_Journal_Rt;
    p_Robot           Hpd_Pref.Robot_Rt;
    p_Contract        Hpd_Pref.Contract_Rt;
    p_Indicators      Href_Pref.Indicator_Nt;
    p_Oper_Types      Href_Pref.Oper_Type_Nt;
    v_Indicators      Arraylist;
    v_Indicator       Hashmap;
    v_Hirings         Arraylist := p.r_Arraylist('staffs');
    v_Hiring          Hashmap;
    r_Robot           Mrf_Robots%rowtype;
  begin
    v_Sysdate := Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                            i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => Ui.Company_Id,
                                                                                  i_Filial_Id  => Ui.Filial_Id));
  
    v_Full_Id := Href_Util.Fte_Id(i_Company_Id => Ui.Company_Id,
                                  i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time);
  
    Hpd_Util.Hiring_Journal_New(o_Journal         => p_Journal,
                                i_Company_Id      => Ui.Company_Id,
                                i_Filial_Id       => Ui.Filial_Id,
                                i_Journal_Id      => Hpd_Next.Journal_Id,
                                i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                              i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple),
                                i_Journal_Number  => null,
                                i_Journal_Date    => Trunc(v_Sysdate),
                                i_Journal_Name    => null);
  
    p_Oper_Types := Href_Pref.Oper_Type_Nt();
  
    for i in 1 .. v_Oper_Types.Count
    loop
      v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(i) as Hashmap);
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Types,
                             i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                             i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                    Array_Number()));
    end loop;
  
    for i in 1 .. v_Hirings.Count
    loop
      v_Hiring := Treat(v_Hirings.r_Hashmap(i) as Hashmap);
    
      v_Employee_Id  := v_Hiring.r_Number('employee_id');
      v_Robot_Ids    := v_Hiring.r_Array_Number('robot_ids');
      v_Division_Ids := v_Hiring.r_Array_Number('division_ids');
      v_Job_Ids      := v_Hiring.r_Array_Number('job_ids');
      v_Schedule_Ids := v_Hiring.r_Array_Number('schedule_ids');
      v_Source_Ids   := v_Hiring.r_Array_Number('source_ids');
    
      if v_Robot_Ids.Count = 0 and i_Position_Enable = 'Y' then
        b.Raise_Error(t('generate_hirings: at least one robot should be selected'));
      end if;
    
      if v_Division_Ids.Count = 0 and i_Position_Enable = 'N' then
        b.Raise_Error(t('generate_hirings: at least one division should be selected'));
      end if;
    
      if v_Job_Ids.Count = 0 and i_Position_Enable = 'N' then
        b.Raise_Error(t('generate_hirings: at least one job should be selected'));
      end if;
    
      if v_Schedule_Ids.Count = 0 then
        b.Raise_Error(t('generate_hirings: at least one schedule should be selected'));
      end if;
    
      if v_Source_Ids.Count = 0 then
        Fazo.Push(v_Source_Ids, null);
      end if;
    
      if i_Position_Enable = 'Y' then
        v_Robot_Id    := v_Robot_Ids(Href_Util.Random_Integer(1, v_Robot_Ids.Count));
        r_Robot       := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Robot_Id   => v_Robot_Id);
        v_Division_Id := r_Robot.Division_Id;
        v_Job_Id      := r_Robot.Job_Id;
      else
        v_Division_Id := v_Division_Ids(Href_Util.Random_Integer(1, v_Division_Ids.Count));
        v_Job_Id      := v_Job_Ids(Href_Util.Random_Integer(1, v_Job_Ids.Count));
        v_Robot_Id    := Mrf_Next.Robot_Id;
      end if;
    
      v_Schedule_Id := v_Schedule_Ids(Href_Util.Random_Integer(1, v_Schedule_Ids.Count));
      v_Source_Id   := v_Source_Ids(Href_Util.Random_Integer(1, v_Source_Ids.Count));
    
      v_Hiring_Date := v_Period_Begin + Href_Util.Random_Integer(0, v_Period_End - v_Period_Begin);
    
      Hpd_Util.Robot_New(o_Robot           => p_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => v_Division_Id,
                         i_Job_Id          => v_Job_Id,
                         i_Rank_Id         => null,
                         i_Wage_Scale_Id   => null,
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte_Id          => v_Full_Id,
                         i_Fte             => null);
    
      p_Indicators := Href_Pref.Indicator_Nt();
      v_Indicators := v_Hiring.r_Arraylist('indicators');
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
      
        v_Indicator_Value := Href_Util.Random_Integer(v_Indicator.r_Number('indicator_left'),
                                                      v_Indicator.r_Number('indicator_right'));
      
        Hpd_Util.Indicator_Add(p_Indicator       => p_Indicators,
                               i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                               i_Indicator_Value => v_Indicator_Value);
      end loop;
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => p_Journal,
                                  i_Page_Id              => Hpd_Next.Page_Id,
                                  i_Employee_Id          => v_Employee_Id,
                                  i_Staff_Number         => null, --
                                  i_Hiring_Date          => v_Hiring_Date,
                                  i_Trial_Period         => 0,
                                  i_Employment_Source_Id => v_Source_Id,
                                  i_Schedule_Id          => v_Schedule_Id,
                                  i_Vacation_Days_Limit  => null,
                                  i_Is_Booked            => 'N',
                                  i_Robot                => p_Robot,
                                  i_Contract             => p_Contract,
                                  i_Indicators           => p_Indicators,
                                  i_Oper_Types           => p_Oper_Types);
    
    end loop;
  
    Hpd_Api.Hiring_Journal_Save(p_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Transfer
  (
    p                 Hashmap,
    i_Position_Enable varchar2
  ) is
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Oper_Types   Arraylist := p.r_Arraylist('oper_types');
    v_Oper_Type    Hashmap;
  
    v_Sysdate         date;
    v_Staff_Id        number;
    v_Robot_Id        number;
    v_Schedule_Id     number;
    v_Transfer_Date   date;
    v_Indicator_Value number;
    v_Division_Id     number;
    v_Job_Id          number;
    v_Full_Id         number;
    v_Robot_Ids       Array_Number;
    v_Schedule_Ids    Array_Number;
    v_Division_Ids    Array_Number;
    v_Job_Ids         Array_Number;
    p_Journal         Hpd_Pref.Transfer_Journal_Rt;
    p_Robot           Hpd_Pref.Robot_Rt;
    p_Contract        Hpd_Pref.Contract_Rt;
    p_Indicators      Href_Pref.Indicator_Nt;
    p_Oper_Types      Href_Pref.Oper_Type_Nt;
    v_Indicators      Arraylist;
    v_Indicator       Hashmap;
    v_Transfers       Arraylist := p.r_Arraylist('staffs');
    v_Transfer        Hashmap;
    r_Robot           Mrf_Robots%rowtype;
  begin
    v_Sysdate := Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                            i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => Ui.Company_Id,
                                                                                  i_Filial_Id  => Ui.Filial_Id));
  
    v_Full_Id := Href_Util.Fte_Id(i_Company_Id => Ui.Company_Id,
                                  i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time);
  
    Hpd_Util.Transfer_Journal_New(o_Journal         => p_Journal,
                                  i_Company_Id      => Ui.Company_Id,
                                  i_Filial_Id       => Ui.Filial_Id,
                                  i_Journal_Id      => Hpd_Next.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple),
                                  i_Journal_Number  => null,
                                  i_Journal_Date    => Trunc(v_Sysdate),
                                  i_Journal_Name    => null);
  
    p_Oper_Types := Href_Pref.Oper_Type_Nt();
  
    for i in 1 .. v_Oper_Types.Count
    loop
      v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(i) as Hashmap);
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Types,
                             i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                             i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                    Array_Number()));
    end loop;
  
    for i in 1 .. v_Transfers.Count
    loop
      v_Transfer := Treat(v_Transfers.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id     := v_Transfer.r_Number('staff_id');
      v_Robot_Ids    := v_Transfer.r_Array_Number('robot_ids');
      v_Division_Ids := v_Transfer.r_Array_Number('division_ids');
      v_Job_Ids      := v_Transfer.r_Array_Number('job_ids');
      v_Schedule_Ids := v_Transfer.r_Array_Number('schedule_ids');
    
      if v_Robot_Ids.Count = 0 and i_Position_Enable = 'Y' then
        b.Raise_Error(t('generate_tranfer: at least one robot should be selected'));
      end if;
    
      if v_Division_Ids.Count = 0 and i_Position_Enable = 'N' then
        b.Raise_Error(t('generate_tranfer: at least one division should be selected'));
      end if;
    
      if v_Job_Ids.Count = 0 and i_Position_Enable = 'Y' then
        b.Raise_Error(t('generate_tranfer: at least one job should be selected'));
      end if;
    
      if v_Schedule_Ids.Count = 0 then
        b.Raise_Error(t('generate_tranfer: at least one schedule should be selected'));
      end if;
    
      if i_Position_Enable = 'Y' then
        v_Robot_Id    := v_Robot_Ids(Href_Util.Random_Integer(1, v_Robot_Ids.Count));
        r_Robot       := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Robot_Id   => v_Robot_Id);
        v_Division_Id := r_Robot.Division_Id;
        v_Job_Id      := r_Robot.Job_Id;
      else
        v_Division_Id := v_Division_Ids(Href_Util.Random_Integer(1, v_Division_Ids.Count));
        v_Job_Id      := v_Job_Ids(Href_Util.Random_Integer(1, v_Job_Ids.Count));
        v_Robot_Id    := Mrf_Next.Robot_Id;
      end if;
    
      v_Schedule_Id := v_Schedule_Ids(Href_Util.Random_Integer(1, v_Schedule_Ids.Count));
    
      v_Transfer_Date := v_Period_Begin +
                         Href_Util.Random_Integer(0, v_Period_End - v_Period_Begin);
    
      Hpd_Util.Robot_New(o_Robot           => p_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => v_Division_Id,
                         i_Job_Id          => v_Job_Id,
                         i_Rank_Id         => null,
                         i_Wage_Scale_Id   => null,
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte_Id          => v_Full_Id,
                         i_Fte             => null);
    
      p_Indicators := Href_Pref.Indicator_Nt();
      v_Indicators := v_Transfer.r_Arraylist('indicators');
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
      
        v_Indicator_Value := Href_Util.Random_Integer(v_Indicator.r_Number('indicator_left'),
                                                      v_Indicator.r_Number('indicator_right'));
      
        Hpd_Util.Indicator_Add(p_Indicator       => p_Indicators,
                               i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                               i_Indicator_Value => v_Indicator_Value);
      end loop;
    
      Hpd_Util.Journal_Add_Transfer(p_Journal             => p_Journal,
                                    i_Page_Id             => Hpd_Next.Page_Id,
                                    i_Transfer_Begin      => v_Transfer_Date,
                                    i_Transfer_End        => null,
                                    i_Staff_Id            => v_Staff_Id,
                                    i_Schedule_Id         => v_Schedule_Id,
                                    i_Vacation_Days_Limit => null,
                                    i_Is_Booked           => 'N',
                                    i_Transfer_Reason     => null,
                                    i_Transfer_Base       => null,
                                    i_Robot               => p_Robot,
                                    i_Contract            => p_Contract,
                                    i_Indicators          => p_Indicators,
                                    i_Oper_Types          => p_Oper_Types);
    end loop;
  
    Hpd_Api.Transfer_Journal_Save(p_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Dismissal(p Hashmap) is
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
  
    v_Sysdate        date;
    v_Staff_Id       number;
    v_Source_Id      number;
    v_Reason_Id      number;
    v_Dismissal_Date date;
    v_Source_Ids     Array_Number;
    v_Reason_Ids     Array_Number;
    p_Journal        Hpd_Pref.Dismissal_Journal_Rt;
    v_Dismissals     Arraylist := p.r_Arraylist('staffs');
    v_Dismissal      Hashmap;
  begin
    v_Sysdate := Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                            i_Timezone  => Htt_Util.Load_Timezone(i_Company_Id => Ui.Company_Id,
                                                                                  i_Filial_Id  => Ui.Filial_Id));
  
    Hpd_Util.Dismissal_Journal_New(o_Journal         => p_Journal,
                                   i_Company_Id      => Ui.Company_Id,
                                   i_Filial_Id       => Ui.Filial_Id,
                                   i_Journal_Id      => Hpd_Next.Journal_Id,
                                   i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple),
                                   i_Journal_Number  => null,
                                   i_Journal_Date    => Trunc(v_Sysdate),
                                   i_Journal_Name    => null);
  
    for i in 1 .. v_Dismissals.Count
    loop
      v_Dismissal := Treat(v_Dismissals.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id   := v_Dismissal.r_Number('staff_id');
      v_Source_Ids := v_Dismissal.r_Array_Number('source_ids');
      v_Reason_Ids := v_Dismissal.r_Array_Number('reason_ids');
    
      if v_Source_Ids.Count = 0 then
        Fazo.Push(v_Source_Ids, null);
      end if;
    
      if v_Reason_Ids.Count = 0 then
        Fazo.Push(v_Reason_Ids, null);
      end if;
    
      v_Source_Id := v_Source_Ids(Href_Util.Random_Integer(1, v_Source_Ids.Count));
      v_Reason_Id := v_Reason_Ids(Href_Util.Random_Integer(1, v_Reason_Ids.Count));
    
      v_Dismissal_Date := v_Period_Begin +
                          Href_Util.Random_Integer(0, v_Period_End - v_Period_Begin);
    
      Hpd_Util.Journal_Add_Dismissal(p_Journal              => p_Journal,
                                     i_Page_Id              => Hpd_Next.Page_Id,
                                     i_Staff_Id             => v_Staff_Id,
                                     i_Dismissal_Date       => v_Dismissal_Date,
                                     i_Dismissal_Reason_Id  => v_Reason_Id,
                                     i_Employment_Source_Id => v_Source_Id,
                                     i_Based_On_Doc         => null,
                                     i_Note                 => null);
    end loop;
  
    Hpd_Api.Dismissal_Journal_Save(p_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate(p Hashmap) is
    v_Section         varchar2(50) := p.r_Varchar2('section');
    v_Position_Enable varchar(1);
  begin
    v_Position_Enable := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Position_Enable;
  
    if v_Section = c_Section_Hiring then
      Generate_Hiring(p, v_Position_Enable);
    elsif v_Section = c_Section_Transfer then
      Generate_Transfer(p, v_Position_Enable);
    elsif v_Section = c_Section_Dismissal then
      Generate_Dismissal(p);
    else
      b.Raise_Not_Implemented;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Staff_Kind     = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id      = null,
           Filial_Id       = null,
           Employee_Id     = null,
           Employee_Number = null,
           State           = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Rank_Id     = null,
           Opened_Date = null,
           Closed_Date = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           name        = null,
           Division_Id = null,
           Job_Id      = null;
    update Hrm_Robot_Turnover
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Period     = null,
           Fte        = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Href_Employment_Sources
       set Company_Id = null,
           Source_Id  = null,
           name       = null,
           Kind       = null,
           State      = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           Filial_Id         = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
  end;

end Ui_Vhr233;
/
