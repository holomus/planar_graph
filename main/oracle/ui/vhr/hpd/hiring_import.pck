create or replace package Ui_Vhr126 is
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Setting(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Template;
  ----------------------------------------------------------------------------------------------------
  Function Import(p Hashmap) return Hashmap;
end Ui_Vhr126;
/
create or replace package body Ui_Vhr126 is
  ----------------------------------------------------------------------------------------------------  
  type Hiring_Rt is record(
    Employee_Id          number,
    Staff_Number         varchar2(50 char),
    Employee_Name        varchar2(752 char),
    Hiring_Date          date,
    Trial_Period         number,
    Robot_Id             number,
    Robot_Name           varchar2(200 char),
    Division_Id          number,
    Division_Name        varchar2(200 char),
    Job_Id               number,
    Job_Name             varchar2(200 char),
    Rank_Id              number,
    Rank_Name            varchar2(200 char),
    Fte                  number,
    Fte_Id               number,
    Fte_Name             varchar2(200 char),
    Schedule_Id          number,
    Schedule_Name        varchar2(100 char),
    Employment_Type      varchar2(1),
    Employment_Type_Name varchar2(100 char),
    Vacation_Days_Limit  number,
    Oper_Type_Name       varchar2(100),
    Oper_Type_Id         number,
    Indicator_Value      number,
    Contract_Number      varchar2(100 char),
    Contract_Date        date,
    Fixed_Term           varchar2(1),
    Expiry_Date          date,
    Fixed_Term_Base_Id   number,
    Fixed_Term_Base_Name varchar2(100 char),
    Concluding_Term      varchar2(300 char),
    Workplace_Equipment  varchar2(300 char),
    Representative_Basis varchar2(300 char),
    Hiring_Conditions    varchar2(300 char),
    Other_Conditions     varchar2(300 char));

  ----------------------------------------------------------------------------------------------------
  g_Employee_Count             number;
  g_Robot_Count                number;
  g_Division_Count             number;
  g_Job_Count                  number;
  g_Rank_Count                 number;
  g_Schedule_Count             number;
  g_Oper_Type_Count            number;
  g_Fixed_Term_Base_Count      number;
  g_Starting_Row               number;
  g_Column_Setting             Hashmap;
  g_Hrm_Setting                Hrm_Settings%rowtype;
  g_Employee_Identifier        varchar2(20);
  g_Robot_Identifier           varchar2(20);
  g_Division_Identifier        varchar2(20);
  g_Job_Identifier             varchar2(20);
  g_Rank_Identifier            varchar2(20);
  g_Schedule_Identifier        varchar2(20);
  g_Fixed_Term_Base_Identifier varchar2(20);
  g_Error_Messages             Arraylist;
  g_Errors                     Arraylist;
  g_Hiring                     Hiring_Rt;

  ----------------------------------------------------------------------------------------------------
  c_Pref_Starting_Row               constant varchar2(50) := 'UI-VHR126:STARTING_ROW';
  c_Pref_Columns                    constant varchar2(50) := 'UI-VHR126:COLUMNS';
  c_Pref_Employee_Identifier        constant varchar2(50) := 'UI-VHR126:EMPLOYEE_IDENTIFIER';
  c_Pref_Robot_Identifier           constant varchar2(50) := 'UI-VHR126:ROBOT_IDENTIFIER';
  c_Pref_Division_Identifier        constant varchar2(50) := 'UI-VHR126:DIVISION_IDENTIFIER';
  c_Pref_Job_Identifier             constant varchar2(50) := 'UI-VHR126:JOB_IDENTIFIER';
  c_Pref_Rank_Identifier            constant varchar2(50) := 'UI-VHR126:RANK_IDENTIFIER';
  c_Pref_Schedule_Identifier        constant varchar2(50) := 'UI-VHR126:SCHEDULE_IDENTIFIER';
  c_Pref_Fixed_Term_Base_Identifier constant varchar2(50) := 'UI-VHR126:FIXED_TERM_BASE_IDENTIFIER';

  c_Staff_Number         constant varchar2(50) := 'staff_number';
  c_Employee_Name        constant varchar2(50) := 'employee_name';
  c_Hiring_Date          constant varchar2(50) := 'hiring_date';
  c_Trial_Period         constant varchar2(50) := 'trial_period';
  c_Robot_Name           constant varchar2(50) := 'robot_name';
  c_Division_Name        constant varchar2(50) := 'division_name';
  c_Job_Name             constant varchar2(50) := 'job_name';
  c_Rank_Name            constant varchar2(50) := 'rank_name';
  c_Fte                  constant varchar2(50) := 'fte';
  c_Schedule_Name        constant varchar2(50) := 'schedule_name';
  c_Employment_Type_Name constant varchar2(50) := 'employment_type_name';
  c_Vacation_Days_Limit  constant varchar2(50) := 'vacation_days_limit';
  c_Oper_Type_Name       constant varchar2(50) := 'oper_type_name';
  c_Indicator_Value      constant varchar2(50) := 'indicator_value';
  c_Contract_Number      constant varchar2(50) := 'contract_number';
  c_Contract_Date        constant varchar2(50) := 'contract_date';
  c_Fixed_Term           constant varchar2(50) := 'fixed_term';
  c_Expiry_Date          constant varchar2(50) := 'expiry_date';
  c_Fixed_Term_Base_Name constant varchar2(50) := 'fixed_term_base_name';
  c_Concluding_Term      constant varchar2(50) := 'concluding_term';
  c_Workplace_Equipment  constant varchar2(50) := 'workplace_equipment';
  c_Representative_Basis constant varchar2(50) := 'representative_basis';
  c_Hiring_Conditions    constant varchar2(50) := 'hiring_conditions';
  c_Other_Conditions     constant varchar2(50) := 'other_conditions';
  c_Identifier_Name      constant varchar2(1) := 'N';
  c_Identifier_Code      constant varchar2(1) := 'C';

  c_Default_Fte_Value constant number := 1;

  g_Default_Columns Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(c_Employee_Name, 1),
                                                       Array_Varchar2(c_Staff_Number, 2),
                                                       Array_Varchar2(c_Hiring_Date, 3),
                                                       Array_Varchar2(c_Trial_Period, 4),
                                                       Array_Varchar2(c_Robot_Name, 5),
                                                       Array_Varchar2(c_Division_Name, 6),
                                                       Array_Varchar2(c_Job_Name, 7),
                                                       Array_Varchar2(c_Rank_Name, 8),
                                                       Array_Varchar2(c_Fte, 9),
                                                       Array_Varchar2(c_Schedule_Name, 10),
                                                       Array_Varchar2(c_Employment_Type_Name, 11),
                                                       Array_Varchar2(c_Vacation_Days_Limit, 12),
                                                       Array_Varchar2(c_Oper_Type_Name, 13),
                                                       Array_Varchar2(c_Indicator_Value, 14),
                                                       Array_Varchar2(c_Contract_Number, 15),
                                                       Array_Varchar2(c_Contract_Date, 16),
                                                       Array_Varchar2(c_Fixed_Term, 17),
                                                       Array_Varchar2(c_Expiry_Date, 18),
                                                       Array_Varchar2(c_Fixed_Term_Base_Name, 19),
                                                       Array_Varchar2(c_Concluding_Term, 20),
                                                       Array_Varchar2(c_Workplace_Equipment, 21),
                                                       Array_Varchar2(c_Representative_Basis, 22),
                                                       Array_Varchar2(c_Hiring_Conditions, 23),
                                                       Array_Varchar2(c_Other_Conditions, 24));

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
    return b.Translate('UI-VHR126:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Identifiers return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(c_Identifier_Name, t('identifier:name')),
                           Array_Varchar2(c_Identifier_Code, t('identifier:code')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Fixed_Term_Yes return varchar2 is
  begin
    return t('fixed_term:yes');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Fixed_Term_No return varchar2 is
  begin
    return t('fixed_term:no');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Starting_Row return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pref_Starting_Row),
               2);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Identifier(i_Code varchar2) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => i_Code),
               c_Identifier_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Columns return Matrix_Varchar2 is
    v_Column  Hashmap;
    v_Matrix1 Matrix_Varchar2;
    v_Matrix2 Matrix_Varchar2;
  
    --------------------------------------------------    
    Function Column_Number(i_Key varchar2) return varchar2 is
    begin
      return v_Column.o_Varchar2(i_Key);
    end;
  begin
    v_Column := Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Code       => c_Pref_Columns));
  
    if v_Column is null then
      v_Column := Hashmap();
    
      for i in 1 .. g_Default_Columns.Count
      loop
        v_Column.Put(g_Default_Columns(i) (1), g_Default_Columns(i) (2));
      end loop;
    end if;
  
    v_Matrix1 := Matrix_Varchar2(Array_Varchar2(c_Employee_Name,
                                                t('employee name'),
                                                Column_Number(c_Employee_Name)),
                                 Array_Varchar2(c_Staff_Number,
                                                t('staff_number'),
                                                Column_Number(c_Staff_Number)),
                                 Array_Varchar2(c_Hiring_Date,
                                                t('hiring date'),
                                                Column_Number(c_Hiring_Date)),
                                 Array_Varchar2(c_Trial_Period,
                                                t('trial period'),
                                                Column_Number(c_Trial_Period)),
                                 Array_Varchar2(c_Robot_Name,
                                                t('robot name'),
                                                Column_Number(c_Robot_Name)),
                                 Array_Varchar2(c_Division_Name,
                                                t('division name'),
                                                Column_Number(c_Division_Name)),
                                 Array_Varchar2(c_Job_Name, t('job name'), Column_Number(c_Job_Name)),
                                 Array_Varchar2(c_Rank_Name,
                                                t('rank name'),
                                                Column_Number(c_Rank_Name)),
                                 Array_Varchar2(c_Fte, t('fte'), Column_Number(c_Fte)),
                                 Array_Varchar2(c_Schedule_Name,
                                                t('schedule name'),
                                                Column_Number(c_Schedule_Name)),
                                 Array_Varchar2(c_Employment_Type_Name,
                                                t('employment type name'),
                                                Column_Number(c_Employment_Type_Name)),
                                 Array_Varchar2(c_Vacation_Days_Limit,
                                                t('vacation days limit'),
                                                Column_Number(c_Vacation_Days_Limit)),
                                 Array_Varchar2(c_Oper_Type_Name,
                                                t('oper type name'),
                                                Column_Number(c_Oper_Type_Name)),
                                 Array_Varchar2(c_Indicator_Value,
                                                t('indicator value'),
                                                Column_Number(c_Indicator_Value)),
                                 Array_Varchar2(c_Contract_Number,
                                                t('contract number'),
                                                Column_Number(c_Contract_Number)),
                                 Array_Varchar2(c_Contract_Date,
                                                t('contract date'),
                                                Column_Number(c_Contract_Date)),
                                 Array_Varchar2(c_Fixed_Term,
                                                t('fixed term'),
                                                Column_Number(c_Fixed_Term)),
                                 Array_Varchar2(c_Expiry_Date,
                                                t('expiry date'),
                                                Column_Number(c_Expiry_Date)),
                                 Array_Varchar2(c_Fixed_Term_Base_Name,
                                                t('fixed term base name'),
                                                Column_Number(c_Fixed_Term_Base_Name)),
                                 Array_Varchar2(c_Concluding_Term,
                                                t('concluding term'),
                                                Column_Number(c_Concluding_Term)),
                                 Array_Varchar2(c_Workplace_Equipment,
                                                t('workplace equipment'),
                                                Column_Number(c_Workplace_Equipment)),
                                 Array_Varchar2(c_Representative_Basis,
                                                t('representative basis'),
                                                Column_Number(c_Representative_Basis)),
                                 Array_Varchar2(c_Hiring_Conditions,
                                                t('hiring conditions'),
                                                Column_Number(c_Hiring_Conditions)),
                                 Array_Varchar2(c_Other_Conditions,
                                                t('other conditions'),
                                                Column_Number(c_Other_Conditions)));
  
    select *
      bulk collect
      into v_Matrix2
      from table(v_Matrix1);
  
    return v_Matrix2;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    g_Starting_Row   := Load_Starting_Row;
    g_Column_Setting := Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Code       => c_Pref_Columns));
    g_Hrm_Setting    := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id);
  
    if g_Column_Setting is null then
      g_Column_Setting := Hashmap();
    
      for i in 1 .. g_Default_Columns.Count
      loop
        g_Column_Setting.Put(g_Default_Columns(i) (1), g_Default_Columns(i) (2));
      end loop;
    end if;
  
    g_Errors := Arraylist();
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Set_Global_Variables;
  
    Result.Put('custom_fte_id', Href_Pref.c_Custom_Fte_Id);
    Result.Put('identifiers', Fazo.Zip_Matrix(Identifiers));
    Result.Put('starting_row', Load_Starting_Row);
    Result.Put('position_enable', g_Hrm_Setting.Position_Enable);
    Result.Put('employee_identifier', Load_Identifier(c_Pref_Employee_Identifier));
    Result.Put('robot_identifier', Load_Identifier(c_Pref_Robot_Identifier));
    Result.Put('division_identifier', Load_Identifier(c_Pref_Division_Identifier));
    Result.Put('job_identifier', Load_Identifier(c_Pref_Job_Identifier));
    Result.Put('rank_identifier', Load_Identifier(c_Pref_Rank_Identifier));
    Result.Put('schedule_identifier', Load_Identifier(c_Pref_Schedule_Identifier));
    Result.Put('fixed_term_base_identifier', Load_Identifier(c_Pref_Fixed_Term_Base_Identifier));
    Result.Put('items', Fazo.Zip_Matrix(Load_Columns));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Setting(p Hashmap) is
    v_Column_Keys    Array_Varchar2 := p.r_Array_Varchar2('keys');
    v_Column_Numbers Array_Varchar2 := p.r_Array_Varchar2('column_numbers');
    v_Column         Hashmap := Hashmap();
  begin
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Starting_Row,
                           i_Value      => p.r_Number('starting_row'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Employee_Identifier,
                           i_Value      => p.r_Varchar2('employee_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Robot_Identifier,
                           i_Value      => p.r_Varchar2('robot_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Division_Identifier,
                           i_Value      => p.r_Varchar2('division_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Job_Identifier,
                           i_Value      => p.r_Varchar2('job_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Rank_Identifier,
                           i_Value      => p.r_Varchar2('rank_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Schedule_Identifier,
                           i_Value      => p.r_Varchar2('schedule_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Fixed_Term_Base_Identifier,
                           i_Value      => p.r_Varchar2('fixed_term_base_identifier'));
  
    for i in 1 .. v_Column_Keys.Count
    loop
      v_Column.Put(v_Column_Keys(i), v_Column_Numbers(i));
    end loop;
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Columns,
                           i_Value      => v_Column.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table return b_Table is
    v_Indicator_Id number;
    v_Matrix       Matrix_Varchar2;
    a              b_Table;
    c              b_Table;
  begin
    a := b_Report.New_Table;
    a.New_Row;
  
    -- employee: column - 1
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Employee_Count := 0;
    for r in (select w.Name
                from Mhr_Employees q
                join Mr_Natural_Persons w
                  on q.Company_Id = w.Company_Id
                 and q.Employee_Id = w.Person_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
               order by w.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Employee_Count := g_Employee_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- robot: column - 2
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Robot_Count := 0;
    for r in (select w.Name
                from Mrf_Robots w
               where w.Company_Id = Ui.Company_Id
                 and w.Filial_Id = Ui.Filial_Id
                 and exists (select 1
                        from Hrm_Robots f
                       where f.Company_Id = w.Company_Id
                         and f.Filial_Id = w.Filial_Id
                         and f.Robot_Id = w.Robot_Id)
               order by w.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Robot_Count := g_Robot_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- division: column - 3
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Division_Count := 0;
    for r in (select w.Name
                from Mhr_Divisions w
                join Hrm_Divisions Dv
                  on Dv.Company_Id = w.Company_Id
                 and Dv.Filial_Id = w.Filial_Id
                 and Dv.Division_Id = w.Division_Id
                 and Dv.Is_Department = 'Y'
               where w.Company_Id = Ui.Company_Id
                 and w.Filial_Id = Ui.Filial_Id
               order by w.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Division_Count := g_Division_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- job: column - 4
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Job_Count := 0;
    for r in (select q.Name
                from Mhr_Jobs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Job_Count := g_Job_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- rank: column - 5
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Rank_Count := 0;
    for r in (select q.Name
                from Mhr_Ranks q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Rank_Count := g_Rank_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- schedule: column - 6
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Schedule_Count := 0;
    for r in (select q.Name
                from Htt_Schedules q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Schedule_Count := g_Schedule_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- oper type: column - 7
    c := b_Report.New_Table;
    c.New_Row;
  
    v_Indicator_Id    := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    g_Oper_Type_Count := 0;
    for r in (select q.Name
                from Mpr_Oper_Types q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A'
                 and q.Pcode in (Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                                 Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                                 Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                                 Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized)
                 and exists (select 1
                        from Hpr_Oper_Type_Indicators w
                       where w.Company_Id = Ui.Company_Id
                         and w.Oper_Type_Id = q.Oper_Type_Id
                         and w.Indicator_Id = v_Indicator_Id))
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Oper_Type_Count := g_Oper_Type_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- employment type: column - 8
    v_Matrix := Hpd_Util.Employment_Types;
    c        := b_Report.New_Table;
    c.New_Row;
    for i in 1 .. v_Matrix(1).Count
    loop
      c.Data(v_Matrix(2) (i));
      c.New_Row;
    end loop;
  
    a.Data(c);
  
    -- fixed term: column - 9
    c := b_Report.New_Table;
    c.New_Row;
  
    c.Data(t_Fixed_Term_Yes);
    c.New_Row;
    c.Data(t_Fixed_Term_No);
    c.New_Row;
  
    a.Data(c);
  
    -- fixed term base: column - 10
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Fixed_Term_Base_Count := 0;
    for r in (select q.Name
                from Href_Fixed_Term_Bases q
               where q.Company_Id = Ui.Company_Id
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Fixed_Term_Base_Count := g_Fixed_Term_Base_Count + 1;
    end loop;
  
    a.Data(c);
  
    return a;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    a              b_Table;
    v_Source_Name  varchar2(10) := 'data';
    v_Source_Table b_Table;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Columns_All  Matrix_Varchar2;
    v_Begin_Index  number;
  
    --------------------------------------------------     
    Function Column_Order(i_Key varchar2) return number is
      v_Column_Order number;
    begin
      for i in 1 .. v_Columns_All.Count
      loop
        if v_Columns_All(i) (1) = i_Key then
          v_Column_Order := v_Columns_All(i) (3);
          exit;
        end if;
      end loop;
    
      return v_Column_Order;
    end;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null
    ) is
      v_Column_Order number := Column_Order(i_Column_Key);
    begin
      if v_Column_Order is null then
        v_Left_Matrix.Extend;
        v_Left_Matrix(v_Left_Matrix.Count) := Array_Varchar2(i_Column_Data, i_Column_Width);
      else
        if v_Column_Order > v_Begin_Index then
          for i in v_Begin_Index + 1 .. v_Column_Order
          loop
            v_Data_Matrix.Extend;
            v_Data_Matrix(v_Data_Matrix.Count) := Array_Varchar2(null, null);
          end loop;
        
          v_Begin_Index := v_Column_Order;
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        else
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        end if;
      end if;
    end;
  
    --------------------------------------------------                  
    Procedure Push_Left_Data is
    begin
      for i in 1 .. v_Left_Matrix.Count
      loop
        v_Data_Matrix.Extend;
        v_Data_Matrix(v_Data_Matrix.Count) := v_Left_Matrix(i);
      end loop;
    end;
  begin
    g_Employee_Identifier        := Load_Identifier(c_Pref_Employee_Identifier);
    g_Robot_Identifier           := Load_Identifier(c_Pref_Robot_Identifier);
    g_Division_Identifier        := Load_Identifier(c_Pref_Division_Identifier);
    g_Job_Identifier             := Load_Identifier(c_Pref_Job_Identifier);
    g_Rank_Identifier            := Load_Identifier(c_Pref_Rank_Identifier);
    g_Schedule_Identifier        := Load_Identifier(c_Pref_Schedule_Identifier);
    g_Fixed_Term_Base_Identifier := Load_Identifier(c_Pref_Fixed_Term_Base_Identifier);
  
    v_Columns_All := Load_Columns;
    v_Data_Matrix := Matrix_Varchar2();
    v_Left_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    Set_Global_Variables;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    a := b_Report.New_Table;
    a.Current_Style('header');
    a.New_Row;
  
    v_Source_Table := Source_Table;
  
    if g_Employee_Identifier = c_Identifier_Code then
      Set_Column(c_Employee_Name, t('employee code'), 300);
    else
      Set_Column(c_Employee_Name, t('employee name'), 300);
    end if;
  
    if g_Hrm_Setting.Position_Enable = 'Y' then
      if g_Robot_Identifier = c_Identifier_Code then
        Set_Column(c_Robot_Name, t('robot code'), 300);
      else
        Set_Column(c_Robot_Name, t('robot name'), 300);
      end if;
    else
      if g_Division_Identifier = c_Identifier_Code then
        Set_Column(c_Division_Name, t('division code'), 300);
      else
        Set_Column(c_Division_Name, t('division name'), 300);
      end if;
    
      if g_Job_Identifier = c_Identifier_Code then
        Set_Column(c_Job_Name, t('job code'), 300);
      else
        Set_Column(c_Job_Name, t('job name'), 300);
      end if;
    end if;
  
    if g_Rank_Identifier = c_Identifier_Code then
      Set_Column(c_Rank_Name, t('rank code'), 200);
    else
      Set_Column(c_Rank_Name, t('rank'), 200);
    end if;
  
    if g_Schedule_Identifier = c_Identifier_Code then
      Set_Column(c_Schedule_Name, t('schedule code'), 200);
    else
      Set_Column(c_Schedule_Name, t('schedule name'), 200);
    end if;
  
    if g_Fixed_Term_Base_Identifier = c_Identifier_Code then
      Set_Column(c_Fixed_Term_Base_Name, t('fixed term base code'), 200);
    else
      Set_Column(c_Fixed_Term_Base_Name, t('fixed term base name'), 200);
    end if;
  
    Set_Column(c_Staff_Number, t('staff_number'), 200);
    Set_Column(c_Robot_Name, t('robot name'), 200);
    Set_Column(c_Hiring_Date, t('hiring date'), 100);
    Set_Column(c_Trial_Period, t('trial period'), 100);
    Set_Column(c_Fte, t('fte'), 100);
    Set_Column(c_Employment_Type_Name, t('employment type name'), 200);
    Set_Column(c_Vacation_Days_Limit, t('vacation days limit'), 100);
    Set_Column(c_Indicator_Value, t('indicator value'), 100);
    Set_Column(c_Oper_Type_Name, t('oper type name'), 200);
    Set_Column(c_Contract_Number, t('contract number'), 100);
    Set_Column(c_Contract_Date, t('contract date'), 100);
    Set_Column(c_Fixed_Term, t('fixed term'), 100);
    Set_Column(c_Expiry_Date, t('expiry date'), 100);
    Set_Column(c_Concluding_Term, t('concluding term'), 100);
    Set_Column(c_Workplace_Equipment, t('workplace equipment'), 100);
    Set_Column(c_Representative_Basis, t('representative basis'), 100);
    Set_Column(c_Hiring_Conditions, t('hiring conditions'), 100);
    Set_Column(c_Other_Conditions, t('other conditions'), 100);
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      a.Column_Width(i, v_Data_Matrix(i) (2));
      a.Data(v_Data_Matrix(i) (1));
    end loop;
  
    if g_Employee_Count > 0 and g_Employee_Identifier <> c_Identifier_Code then
      a.Column_Data_Source(Column_Order(c_Employee_Name),
                           1,
                           102,
                           v_Source_Name,
                           1,
                           g_Employee_Count); -- employee
    end if;
  
    if g_Hrm_Setting.Position_Enable = 'Y' then
      if g_Robot_Count > 0 then
        a.Column_Data_Source(Column_Order(c_Robot_Name), 1, 102, v_Source_Name, 2, g_Robot_Count); -- robot
      end if;
    else
      if g_Division_Count > 0 and g_Division_Identifier <> c_Identifier_Code then
        a.Column_Data_Source(Column_Order(c_Division_Name),
                             1,
                             102,
                             v_Source_Name,
                             3,
                             g_Division_Count); -- division
      end if;
    
      if g_Job_Count > 0 and g_Job_Identifier <> c_Identifier_Code then
        a.Column_Data_Source(Column_Order(c_Job_Name), 1, 102, v_Source_Name, 4, g_Job_Count); -- job
      end if;
    end if;
  
    if g_Rank_Count > 0 and g_Rank_Identifier <> c_Identifier_Code then
      a.Column_Data_Source(Column_Order(c_Rank_Name), 1, 102, v_Source_Name, 5, g_Rank_Count); -- rank
    end if;
  
    if g_Schedule_Count > 0 and g_Schedule_Identifier <> c_Identifier_Code then
      a.Column_Data_Source(Column_Order(c_Schedule_Name),
                           1,
                           102,
                           v_Source_Name,
                           6,
                           g_Schedule_Count); -- schedule
    end if;
  
    if g_Oper_Type_Count > 0 then
      a.Column_Data_Source(Column_Order(c_Oper_Type_Name),
                           1,
                           102,
                           v_Source_Name,
                           7,
                           g_Oper_Type_Count);
    end if;
  
    a.Column_Data_Source(Column_Order(c_Employment_Type_Name), 1, 102, v_Source_Name, 8, 3); -- employment type
    a.Column_Data_Source(Column_Order(c_Fixed_Term), 1, 102, v_Source_Name, 9, 2); -- fixed_term
  
    if g_Fixed_Term_Base_Count > 0 and g_Fixed_Term_Base_Identifier <> c_Identifier_Code then
      a.Column_Data_Source(Column_Order(c_Fixed_Term_Base_Name),
                           1,
                           102,
                           v_Source_Name,
                           10,
                           g_Fixed_Term_Base_Count); -- fixed_term_base
    end if;
  
    b_Report.Add_Sheet(t('hirings'), a);
  
    -- template data  
    b_Report.Add_Sheet(i_Name  => v_Source_Name, --
                       p_Table => v_Source_Table);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Operation is
  begin
    g_Hiring := null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Clear_Error_Messages is
  begin
    g_Error_Messages := Arraylist();
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Employee(i_Value varchar2) is
    v_Person_Id number;
    r_Person    Mr_Natural_Persons%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Employee_Identifier = c_Identifier_Code then
      v_Person_Id := Md_Util.Person_Id_By_Code(i_Company_Id => Ui.Company_Id, i_Code => i_Value);
    else
      v_Person_Id := Md_Util.Person_Id_By_Name(i_Company_Id => Ui.Company_Id, i_Name => i_Value);
    end if;
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                          i_Person_Id  => v_Person_Id);
  
    g_Hiring.Employee_Name := r_Person.Name;
    g_Hiring.Employee_Id   := r_Person.Person_Id;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with employee $2{employee}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Hiring_Date(i_Value varchar2) is
  begin
    g_Hiring.Hiring_Date := Mr_Util.Convert_To_Date(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with hiring date $2{hiring_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Trial_Period(i_Value varchar2) is
  begin
    g_Hiring.Trial_Period := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with trial period $2{trial_period}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Set_Staff_Number(i_Value varchar2) is
  begin
    g_Hiring.Staff_Number := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with staff number $2{staff_number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Robot(i_Value varchar2) is
    r_Robot Mrf_Robots%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Robot_Identifier = c_Identifier_Code then
      g_Hiring.Robot_Id := Mrf_Util.Robot_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Code       => i_Value);
    else
      g_Hiring.Robot_Id := Mrf_Util.Robot_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Name       => i_Value);
    end if;
  
    r_Robot := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Robot_Id   => g_Hiring.Robot_Id);
  
    g_Hiring.Robot_Name := r_Robot.Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with robot $2{robot}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division(i_Value varchar2) is
    r_Division Mhr_Divisions%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Division_Identifier = c_Identifier_Code then
      g_Hiring.Division_Id := Mhr_Util.Division_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id,
                                                           i_Code       => i_Value);
    else
      g_Hiring.Division_Id := Mhr_Util.Division_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id,
                                                           i_Name       => i_Value);
    end if;
  
    r_Division := z_Mhr_Divisions.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Division_Id => g_Hiring.Division_Id);
  
    g_Hiring.Division_Name := r_Division.Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division $2{division}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Job(i_Value varchar2) is
    r_Job Mhr_Jobs%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Job_Identifier = c_Identifier_Code then
      g_Hiring.Job_Id := Mhr_Util.Job_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Code       => i_Value);
    else
      g_Hiring.Job_Id := Mhr_Util.Job_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Name       => i_Value);
    end if;
  
    r_Job := z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Job_Id     => g_Hiring.Job_Id);
  
    g_Hiring.Job_Name := r_Job.Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job $2{job}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Rank(i_Value varchar2) is
    r_Rank Mhr_Ranks%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Rank_Identifier = c_Identifier_Code then
      g_Hiring.Rank_Id := Mhr_Util.Rank_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Code       => i_Value);
    else
      g_Hiring.Rank_Id := Mhr_Util.Rank_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Name       => i_Value);
    end if;
  
    r_Rank := z_Mhr_Ranks.Load(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Rank_Id    => g_Hiring.Rank_Id);
  
    g_Hiring.Rank_Name := r_Rank.Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with rank $2{rank}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fte(i_Value varchar2) is
    r_Fte Href_Ftes%rowtype;
  begin
    g_Hiring.Fte := Nvl(to_number(i_Value), c_Default_Fte_Value);
  
    if g_Hrm_Setting.Parttime_Enable = 'N' and Trunc(to_number(i_Value)) <> to_number(i_Value) then
      g_Hiring.Fte := c_Default_Fte_Value;
    end if;
  
    if to_number(i_Value) = 0 then
      g_Hiring.Fte := c_Default_Fte_Value;
    end if;
  
    g_Hiring.Fte := Least(g_Hiring.Fte, c_Default_Fte_Value);
  
    g_Hiring.Fte_Id := Uit_Hpd.Get_Fte_Id(g_Hiring.Fte);
  
    if g_Hiring.Fte_Id = Href_Pref.c_Custom_Fte_Id then
      g_Hiring.Fte_Name := Href_Util.t_Custom_Fte_Name;
    else
      r_Fte := z_Href_Ftes.Load(i_Company_Id => Ui.Company_Id, i_Fte_Id => g_Hiring.Fte_Id);
    
      g_Hiring.Fte_Name := r_Fte.Name;
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fte $2{fte}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Schedule(i_Value varchar2) is
    r_Schedule Htt_Schedules%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Schedule_Identifier = c_Identifier_Code then
      g_Hiring.Schedule_Id := Htt_Util.Schedule_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id,
                                                           i_Code       => i_Value);
    else
      g_Hiring.Schedule_Id := Htt_Util.Schedule_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id,
                                                           i_Name       => i_Value);
    end if;
  
    r_Schedule := z_Htt_Schedules.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Schedule_Id => g_Hiring.Schedule_Id);
  
    g_Hiring.Schedule_Name := r_Schedule.Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with schedule $2{schedule}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Employment_Type(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    if i_Value = Hpd_Util.t_Employment_Type_Main_Job then
      g_Hiring.Employment_Type := Hpd_Pref.c_Employment_Type_Main_Job;
    elsif i_Value = Hpd_Util.t_Employment_Type_External_Parttime then
      g_Hiring.Employment_Type := Hpd_Pref.c_Employment_Type_External_Parttime;
    elsif i_Value = Hpd_Util.t_Employment_Type_Internal_Parttime then
      g_Hiring.Employment_Type := Hpd_Pref.c_Employment_Type_Internal_Parttime;
    end if;
  
    g_Hiring.Employment_Type_Name := i_Value;
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Set_Vacation_Days_Limit(i_Value varchar2) is
  begin
    if not to_number(i_Value) between 0 and 365 then
      g_Error_Messages.Push(t('vacation days limit must be between 0 and 365'));
    end if;
  
    g_Hiring.Vacation_Days_Limit := to_number(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with vacation days limit $2{vacation_days_limit}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Oper_Type_Name(i_Value varchar) is
    v_Oper_Type_Id number;
    v_Indicator_Id number;
  begin
    if i_Value is null then
      return;
    end if;
  
    v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    select q.Oper_Type_Id
      into v_Oper_Type_Id
      from Mpr_Oper_Types q
     where q.Company_Id = Ui.Company_Id
       and q.Name = i_Value
       and q.State = 'A'
       and q.Pcode in (Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                       Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                       Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                       Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized)
       and exists (select 1
              from Hpr_Oper_Type_Indicators w
             where w.Company_Id = Ui.Company_Id
               and w.Oper_Type_Id = q.Oper_Type_Id
               and w.Indicator_Id = v_Indicator_Id);
  
    g_Hiring.Oper_Type_Name := i_Value;
    g_Hiring.Oper_Type_Id   := v_Oper_Type_Id;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with oper type $2{oper_type_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
    
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Indicator_Value(i_Value varchar) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Hiring.Indicator_Value := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with indicator value $2{indicator_value}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;
  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Contract_Number(i_Value varchar2) is
  begin
    g_Hiring.Contract_Number := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with contract number $2{contract_number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Contract_Date(i_Value varchar2) is
  begin
    g_Hiring.Contract_Date := Mr_Util.Convert_To_Date(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with contract date $2{hiring_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fixed_Term(i_Value varchar2) is
  begin
    if i_Value = t_Fixed_Term_Yes then
      g_Hiring.Fixed_Term := 'Y';
    else
      g_Hiring.Fixed_Term := 'N';
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Expiry_Date(i_Value varchar2) is
  begin
    g_Hiring.Expiry_Date := Mr_Util.Convert_To_Date(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with expiry date $2{expiry_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fixed_Term_Base(i_Value varchar2) is
    r_Fixed_Term_Bases Href_Fixed_Term_Bases%rowtype;
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Fixed_Term_Base_Identifier = c_Identifier_Code then
      g_Hiring.Fixed_Term_Base_Id := Href_Util.Fixed_Term_Base_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                                          i_Code       => i_Value);
    else
      g_Hiring.Fixed_Term_Base_Id := Href_Util.Fixed_Term_Base_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                                          i_Name       => i_Value);
    end if;
  
    r_Fixed_Term_Bases := z_Href_Fixed_Term_Bases.Load(i_Company_Id         => Ui.Company_Id,
                                                       i_Fixed_Term_Base_Id => g_Hiring.Fixed_Term_Base_Id);
  
    g_Hiring.Fixed_Term_Base_Name := r_Fixed_Term_Bases.Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fixed term $2{fixed_term}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Concluding_Term(i_Value varchar2) is
  begin
    g_Hiring.Concluding_Term := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with concluding term $2{concluding_term}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Workplace_Equipment(i_Value varchar2) is
  begin
    g_Hiring.Workplace_Equipment := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with workplace equipment $2{workplace_equipment}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Representative_Basis(i_Value varchar2) is
  begin
    g_Hiring.Representative_Basis := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with representative basis $2{representative_basis}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Hiring_Conditions(i_Value varchar2) is
  begin
    g_Hiring.Hiring_Conditions := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with hiring conditions $2{hiring_conditions}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Other_Conditions(i_Value varchar2) is
  begin
    g_Hiring.Other_Conditions := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with other conditions $2{other_conditions}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Column
  (
    i_Sheet       Excel_Sheet,
    i_Row_Index   number,
    i_Column_Name varchar2
  ) is
    v_Column_Number number;
    v_Cell_Value    varchar2(4000);
  begin
    v_Column_Number := g_Column_Setting.o_Varchar2(i_Column_Name);
    v_Cell_Value    := i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
  
    case i_Column_Name
      when c_Employee_Name then
        Set_Employee(v_Cell_Value);
      when c_Staff_Number then
        Set_Staff_Number(v_Cell_Value);
      when c_Hiring_Date then
        Set_Hiring_Date(v_Cell_Value);
      when c_Trial_Period then
        Set_Trial_Period(v_Cell_Value);
      when c_Robot_Name then
        if g_Hrm_Setting.Position_Enable = 'Y' then
          Set_Robot(v_Cell_Value);
        end if;
      when c_Division_Name then
        if g_Hrm_Setting.Position_Enable = 'N' then
          Set_Division(v_Cell_Value);
        end if;
      when c_Job_Name then
        if g_Hrm_Setting.Position_Enable = 'N' then
          Set_Job(v_Cell_Value);
        end if;
      when c_Rank_Name then
        Set_Rank(v_Cell_Value);
      when c_Fte then
        Set_Fte(v_Cell_Value);
      when c_Schedule_Name then
        Set_Schedule(v_Cell_Value);
      when c_Employment_Type_Name then
        Set_Employment_Type(v_Cell_Value);
      when c_Vacation_Days_Limit then
        Set_Vacation_Days_Limit(v_Cell_Value);
      when c_Oper_Type_Name then
        Set_Oper_Type_Name(v_Cell_Value);
      when c_Indicator_Value then
        Set_Indicator_Value(v_Cell_Value);
      when c_Contract_Number then
        Set_Contract_Number(v_Cell_Value);
      when c_Contract_Date then
        Set_Contract_Date(v_Cell_Value);
      when c_Fixed_Term then
        Set_Fixed_Term(v_Cell_Value);
      when c_Expiry_Date then
        Set_Expiry_Date(v_Cell_Value);
      when c_Fixed_Term_Base_Name then
        Set_Fixed_Term_Base(v_Cell_Value);
      when c_Concluding_Term then
        Set_Concluding_Term(v_Cell_Value);
      when c_Workplace_Equipment then
        Set_Workplace_Equipment(v_Cell_Value);
      when c_Representative_Basis then
        Set_Representative_Basis(v_Cell_Value);
      when c_Hiring_Conditions then
        Set_Hiring_Conditions(v_Cell_Value);
      when c_Other_Conditions then
        Set_Other_Conditions(v_Cell_Value);
      else
        null;
    end case;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Parse_Item
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
  begin
    Parse_Column(i_Sheet, i_Row_Index, c_Employee_Name);
    Parse_Column(i_Sheet, i_Row_Index, c_Staff_Number);
    Parse_Column(i_Sheet, i_Row_Index, c_Hiring_Date);
    Parse_Column(i_Sheet, i_Row_Index, c_Trial_Period);
  
    if g_Hrm_Setting.Position_Enable = 'Y' then
      Parse_Column(i_Sheet, i_Row_Index, c_Robot_Name);
    else
      Parse_Column(i_Sheet, i_Row_Index, c_Division_Name);
      Parse_Column(i_Sheet, i_Row_Index, c_Job_Name);
    end if;
  
    Parse_Column(i_Sheet, i_Row_Index, c_Rank_Name);
    Parse_Column(i_Sheet, i_Row_Index, c_Fte);
    Parse_Column(i_Sheet, i_Row_Index, c_Schedule_Name);
    Parse_Column(i_Sheet, i_Row_Index, c_Employment_Type_Name);
    Parse_Column(i_Sheet, i_Row_Index, c_Vacation_Days_Limit);
    Parse_Column(i_Sheet, i_Row_Index, c_Oper_Type_Name);
    Parse_Column(i_Sheet, i_Row_Index, c_Indicator_Value);
    Parse_Column(i_Sheet, i_Row_Index, c_Contract_Number);
    Parse_Column(i_Sheet, i_Row_Index, c_Contract_Date);
    Parse_Column(i_Sheet, i_Row_Index, c_Fixed_Term);
    Parse_Column(i_Sheet, i_Row_Index, c_Expiry_Date);
    Parse_Column(i_Sheet, i_Row_Index, c_Fixed_Term_Base_Name);
    Parse_Column(i_Sheet, i_Row_Index, c_Concluding_Term);
    Parse_Column(i_Sheet, i_Row_Index, c_Workplace_Equipment);
    Parse_Column(i_Sheet, i_Row_Index, c_Representative_Basis);
    Parse_Column(i_Sheet, i_Row_Index, c_Hiring_Conditions);
    Parse_Column(i_Sheet, i_Row_Index, c_Other_Conditions);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Hiring_To_Array return Array_Varchar2 is
  begin
    return Array_Varchar2(g_Hiring.Employee_Id,
                          g_Hiring.Staff_Number,
                          g_Hiring.Employee_Name,
                          g_Hiring.Hiring_Date,
                          g_Hiring.Trial_Period,
                          g_Hiring.Robot_Id,
                          g_Hiring.Robot_Name,
                          g_Hiring.Division_Id,
                          g_Hiring.Division_Name,
                          g_Hiring.Job_Id,
                          g_Hiring.Job_Name,
                          g_Hiring.Rank_Id,
                          g_Hiring.Rank_Name,
                          g_Hiring.Fte,
                          g_Hiring.Fte_Id,
                          g_Hiring.Fte_Name,
                          g_Hiring.Schedule_Id,
                          g_Hiring.Schedule_Name,
                          g_Hiring.Employment_Type,
                          g_Hiring.Employment_Type_Name,
                          g_Hiring.Vacation_Days_Limit,
                          g_Hiring.Oper_Type_Name,
                          g_Hiring.Oper_Type_Id,
                          g_Hiring.Indicator_Value,
                          g_Hiring.Contract_Number,
                          g_Hiring.Contract_Date,
                          g_Hiring.Fixed_Term,
                          g_Hiring.Expiry_Date,
                          g_Hiring.Fixed_Term_Base_Id,
                          g_Hiring.Fixed_Term_Base_Name,
                          g_Hiring.Concluding_Term,
                          g_Hiring.Workplace_Equipment,
                          g_Hiring.Representative_Basis,
                          g_Hiring.Hiring_Conditions,
                          g_Hiring.Other_Conditions);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Item(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Hiring.Employee_Id is not null then
      o_Items.Extend;
      o_Items(o_Items.Count) := Hiring_To_Array;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Error(i_Row_Index number) is
    v_Error Hashmap;
  begin
    if g_Error_Messages.Count > 0 then
      v_Error := Hashmap();
    
      v_Error.Put('row_id', i_Row_Index);
      v_Error.Put('items', g_Error_Messages);
    
      g_Errors.Push(v_Error);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import(p Hashmap) return Hashmap is
    v_Sheets Arraylist;
    v_Sheet  Excel_Sheet;
    v_Items  Matrix_Varchar2 := Matrix_Varchar2();
    result   Hashmap := Hashmap();
  begin
    v_Sheets := p.r_Arraylist('template');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      Clear_Operation;
      Clear_Error_Messages;
    
      Parse_Item(v_Sheet, i);
      Push_Item(v_Items);
    
      Push_Error(i);
    end loop;
  
    Result.Put('items', Fazo.Zip_Matrix(v_Items));
    Result.Put('errors', g_Errors);
  
    return result;
  end;

end Ui_Vhr126;
/
