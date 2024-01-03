create or replace package Ui_Vhr145 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Save_Staffing_Chart_Type(p Hashmap) return Hashmap;
end Ui_Vhr145;
/
create or replace package body Ui_Vhr145 is
  c_Staffing_Chart_Type_Setting_Code  constant Md_User_Settings.Setting_Code%type := 'ui_vhr145:staffing_chart_type';
  c_Staffing_Chart_Type_By_Divisions  constant varchar2(1) := 'D';
  c_Staffing_Chart_Type_By_Job_Groups constant varchar2(1) := 'J';
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
    return b.Translate('UI-VHR145:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staffs_Count
  (
    i_Division_Id  number := null,
    i_Job_Group_Id number := null
  ) return number is
    result number;
  begin
    if i_Division_Id is not null and i_Job_Group_Id is not null then
      b.Raise_Fatal('UI-VHR145: staffs_count does not work if both division_id and job_group_id are specified');
    elsif i_Job_Group_Id is not null then
      select sum(w.Fte)
        into result
        from Href_Staffs w
       where w.Company_Id = Ui.Company_Id
         and w.Filial_Id = Ui.Filial_Id
         and (w.Dismissal_Date is null or w.Dismissal_Date >= Trunc(sysdate))
         and exists (select 1
                from Mhr_Jobs m
               where m.Company_Id = w.Company_Id
                 and m.Filial_Id = w.Filial_Id
                 and m.Job_Id = w.Job_Id
                 and m.Job_Group_Id = i_Job_Group_Id)
         and w.State = 'A';
    else
      -- either only division_id is specified or no parameters are specified
      select sum(w.Fte)
        into result
        from Href_Staffs w
       where w.Company_Id = Ui.Company_Id
         and w.Filial_Id = Ui.Filial_Id
         and (w.Dismissal_Date is null or w.Dismissal_Date >= Trunc(sysdate))
         and Nvl2(i_Division_Id, w.Division_Id, 1) = Nvl(i_Division_Id, 1)
         and w.State = 'A';
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacancies
  (
    i_Division_Id  number := null,
    i_Job_Group_Id number := null
  ) return number is
    r_Settings    Hrm_Settings%rowtype;
    v_Used_Places number;
    v_All_Places  number;
  begin
    if i_Division_Id is not null and i_Job_Group_Id is not null then
      b.Raise_Fatal('UI-VHR145: staffs_count does not work if both division_id and job_group_id are specified');
    end if;
  
    r_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    if r_Settings.Position_Enable = 'N' then
      return 0;
    end if;
  
    v_Used_Places := Staffs_Count(i_Division_Id => i_Division_Id, i_Job_Group_Id => i_Job_Group_Id);
  
    if i_Job_Group_Id is not null then
      select count(q.Robot_Id)
        into v_All_Places
        from Mrf_Robots q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and exists (select 1
                from Mhr_Jobs m
               where m.Company_Id = q.Company_Id
                 and m.Filial_Id = q.Filial_Id
                 and m.Job_Id = q.Job_Id
                 and m.Job_Group_Id = i_Job_Group_Id)
         and exists (select 1
                from Hrm_Robots w
               where w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Robot_Id = q.Robot_Id);
    else
      -- either only division_id is specified or no parameters are specified
      select count(q.Robot_Id)
        into v_All_Places
        from Mrf_Robots q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and Nvl2(i_Division_Id, q.Division_Id, 1) = Nvl(i_Division_Id, 1)
         and exists (select 1
                from Hrm_Robots w
               where w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Robot_Id = q.Robot_Id);
    end if;
  
    if (v_All_Places - v_Used_Places) > 0 then
      return(v_All_Places - v_Used_Places);
    else
      return 0;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage(i_Date date) return varchar2 is
    r_Trans        Hpd_Transactions%rowtype;
    v_Indicator_Id number;
    v_Value        number;
    v_Trans_Id     number;
    v_Summ         number := 0;
  begin
    v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    for Wage in (select q.Staff_Id
                   from Href_Staffs q
                  where q.Company_Id = Ui.Company_Id
                    and q.Filial_Id = Ui.Filial_Id
                    and (q.Dismissal_Date is null or q.Dismissal_Date >= Trunc(sysdate))
                    and q.State = 'A')
    loop
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Staff_Id   => Wage.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => i_Date);
    
      r_Trans := z_Hpd_Transactions.Take(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Trans_Id   => v_Trans_Id);
    
      if r_Trans.Page_Id is not null then
        select Nvl(sum(q.Indicator_Value), 0)
          into v_Value
          from Hpd_Page_Indicators q
         where q.Company_Id = r_Trans.Company_Id
           and q.Filial_Id = r_Trans.Filial_Id
           and q.Page_Id = r_Trans.Page_Id
           and q.Indicator_Id = v_Indicator_Id;
      
        v_Summ := v_Summ + v_Value;
      end if;
    end loop;
  
    return to_char(Round(v_Summ / 1000000, 2), '999G999G990D00');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Payroll_Fund return varchar2 is
  begin
    return t('$1 m', Wage(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissals
  (
    i_Division_Id  number := null,
    i_Job_Group_Id number := null
  ) return number is
    result number;
  begin
    if i_Division_Id is not null and i_Job_Group_Id is not null then
      b.Raise_Fatal('UI-VHR145: staffs_count does not work if both division_id and job_group_id are specified');
    elsif i_Division_Id is null and i_Job_Group_Id is null then
      b.Raise_Fatal('UI-VHR145: staffs_count does not work if both division_id and job_group_id are null');
    elsif i_Job_Group_Id is not null then
      select count(q.Staff_Id)
        into result
        from Href_Staffs q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and (q.Dismissal_Date is not null or q.Dismissal_Date >= Trunc(sysdate))
         and exists (select 1
                from Mhr_Jobs m
               where m.Company_Id = q.Company_Id
                 and m.Filial_Id = q.Filial_Id
                 and m.Job_Id = q.Job_Id
                 and m.Job_Group_Id = i_Job_Group_Id)
         and q.State = 'A';
    elsif i_Division_Id is not null then
      select count(r.Staff_Id)
        into result
        from Mhr_Divisions q
        join Href_Staffs r
          on r.Company_Id = q.Company_Id
         and r.Filial_Id = q.Filial_Id
         and r.Division_Id = q.Division_Id
         and (r.Dismissal_Date is not null or r.Dismissal_Date >= Trunc(sysdate))
         and r.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Division_Id = i_Division_Id;
    end if;
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Staffing_Chart_Type return varchar2 is
  begin
    return Md_Api.User_Setting_Load(i_Company_Id    => Ui.Company_Id,
                                    i_User_Id       => Ui.User_Id,
                                    i_Filial_Id     => Ui.Filial_Id,
                                    i_Setting_Code  => c_Staffing_Chart_Type_Setting_Code,
                                    i_Default_Value => c_Staffing_Chart_Type_By_Divisions);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staffing return Hashmap is
    v_Element_Info        Hashmap := Hashmap();
    v_Array               Arraylist := Arraylist();
    result                Hashmap := Hashmap();
    v_Staff_Count         number;
    v_Dismissal_Count     number;
    v_Vacancies_Count     number;
    v_Staffing_Chart_Type varchar2(1) := Staffing_Chart_Type;
  begin
    if v_Staffing_Chart_Type = c_Staffing_Chart_Type_By_Divisions then
      for r_Division in (select q.Name, q.Division_Id
                           from Mhr_Divisions q
                           join Hrm_Divisions Dv
                             on Dv.Company_Id = q.Company_Id
                            and Dv.Filial_Id = q.Filial_Id
                            and Dv.Division_Id = q.Division_Id
                            and Dv.Is_Department = 'Y'
                          where q.Company_Id = Ui.Company_Id
                            and q.Filial_Id = Ui.Filial_Id)
      loop
        v_Staff_Count     := Staffs_Count(i_Division_Id => r_Division.Division_Id);
        v_Dismissal_Count := Dismissals(i_Division_Id => r_Division.Division_Id);
        v_Vacancies_Count := Vacancies(i_Division_Id => r_Division.Division_Id);
      
        if (v_Staff_Count > 0 or v_Dismissal_Count > 0 or v_Vacancies_Count > 0) then
          v_Element_Info.Put('name', r_Division.Name);
          v_Element_Info.Put('staffs', v_Staff_Count);
          v_Element_Info.Put('dismissals', v_Dismissal_Count);
          v_Element_Info.Put('vacancies', v_Vacancies_Count);
        
          v_Array.Push(v_Element_Info);
        end if;
      end loop;
    
      Result.Put('staffing_by_divisions', v_Array);
    elsif v_Staffing_Chart_Type = c_Staffing_Chart_Type_By_Job_Groups then
      for r_Job_Group in (select q.Name, q.Job_Group_Id
                            from Mhr_Job_Groups q
                           where q.Company_Id = Ui.Company_Id)
      loop
        v_Staff_Count     := Staffs_Count(i_Job_Group_Id => r_Job_Group.Job_Group_Id);
        v_Dismissal_Count := Dismissals(i_Job_Group_Id => r_Job_Group.Job_Group_Id);
        v_Vacancies_Count := Vacancies(i_Job_Group_Id => r_Job_Group.Job_Group_Id);
      
        if (v_Staff_Count > 0 or v_Dismissal_Count > 0 or v_Vacancies_Count > 0) then
          v_Element_Info.Put('name', r_Job_Group.Name);
          v_Element_Info.Put('staffs', v_Staff_Count);
          v_Element_Info.Put('dismissals', v_Dismissal_Count);
          v_Element_Info.Put('vacancies', v_Vacancies_Count);
        
          v_Array.Push(v_Element_Info);
        end if;
      end loop;
    
      Result.Put('staffing_by_job_groups', v_Array);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Transfers return Matrix_Varchar2 is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    r_Trans_Old    Hpd_Transactions%rowtype;
    r_Trans_New    Hpd_Transactions%rowtype;
    v_Matrix       Matrix_Varchar2 := Matrix_Varchar2();
    v_Data         Array_Varchar2;
    v_Calc         Calc := Calc;
    v_Transfers    Array_Varchar2;
    v_Old_Trans_Id number;
    v_New_Trans_Id number;
  begin
    for Staff in (select q.Staff_Id, q.Hiring_Date
                    from Href_Staffs q
                   where q.Company_Id = Ui.Company_Id
                     and q.Filial_Id = Ui.Filial_Id
                     and (q.Dismissal_Date is null or q.Dismissal_Date >= Trunc(sysdate))
                     and q.State = 'A')
    loop
      v_New_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Staff_Id   => Staff.Staff_Id,
                                                    i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                                                    i_Period     => sysdate);
    
      r_Trans_New := z_Hpd_Transactions.Take(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_New_Trans_Id);
    
      v_Old_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Staff_Id   => Staff.Staff_Id,
                                                    i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                                                    i_Period     => r_Trans_New.Begin_Date - 1);
    
      r_Trans_Old := z_Hpd_Transactions.Take(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Trans_Id   => v_Old_Trans_Id);
    
      if r_Trans_New.Page_Id > 0 and r_Trans_Old.Page_Id > 0 then
        select w.Division_Id
          bulk collect
          into v_Data
          from Hpd_Page_Robots q
          join Mrf_Robots r
            on r.Company_Id = q.Company_Id
           and r.Filial_Id = q.Filial_Id
           and r.Robot_Id = q.Robot_Id
          join Mhr_Divisions w
            on w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and w.Division_Id = r.Division_Id
         where q.Company_Id = Ui.Company_Id
           and q.Filial_Id = Ui.Filial_Id
           and q.Page_Id in (r_Trans_New.Page_Id, r_Trans_Old.Page_Id);
      
        v_Calc.Plus(Fazo.Gather(v_Data, '#'), 1); -- 1 value is a quantity of transfered staff
      end if;
    end loop;
  
    v_Transfers := v_Calc.Keyset();
  
    for i in 1 .. v_Transfers.Count
    loop
      v_Data := Fazo.Split(v_Transfers(i), '#');
    
      for y in 1 .. v_Data.Count
      loop
        v_Data(y) := z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, --
                     i_Filial_Id => v_Filial_Id, --
                     i_Division_Id => to_number(v_Data(y))).Name;
      end loop;
    
      Fazo.Push(v_Data, v_Calc.Get_Value(v_Transfers(i)));
      Fazo.Push(v_Matrix, v_Data);
    end loop;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wages return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2 := Matrix_Varchar2();
    v_Date   date := Last_Day(sysdate);
  begin
    for i in 1 .. 5
    loop
      Fazo.Push(v_Matrix, Array_Varchar2(to_char(v_Date, 'yyyy-mm-dd'), Wage(v_Date)));
      v_Date := Add_Months(v_Date, -1);
    end loop;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('staffs_count', Staffs_Count);
    Result.Put('vacancies_count', Vacancies);
    Result.Put('turnover',
               Uit_Href.Staff_Turnovers(i_Begin_Date => Trunc(sysdate, 'YEAR'),
                                        i_End_Date   => Last_Day(Add_Months(Trunc(sysdate, 'YEAR'),
                                                                            11))));
    Result.Put('payroll_fund', Payroll_Fund);
    Result.Put('transfers', Fazo.Zip_Matrix(Transfers));
    Result.Put('wages', Fazo.Zip_Matrix(Wages));
  
    Result.Put('staffing_chart_type_by_divisions', c_Staffing_Chart_Type_By_Divisions);
    Result.Put('staffing_chart_type_by_job_groups', c_Staffing_Chart_Type_By_Job_Groups);
    Result.Put('staffing_chart_type', Staffing_Chart_Type);
    Result.Put_All(Staffing);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Save_Staffing_Chart_Type(p Hashmap) return Hashmap is
    v_Staffing_Chart_Type varchar2(1) := p.r_Varchar2('staffing_chart_type');
    result                Hashmap := Hashmap();
  begin
    Md_Api.User_Setting_Save(i_Company_Id    => Ui.Company_Id,
                             i_User_Id       => Ui.User_Id,
                             i_Filial_Id     => Ui.Filial_Id,
                             i_Setting_Code  => c_Staffing_Chart_Type_Setting_Code,
                             i_Setting_Value => v_Staffing_Chart_Type);
  
    if p.r_Varchar2('chart_built') = 'N' then
      Result.Put_All(Staffing);
    end if;
  
    return result;
  end;

end Ui_Vhr145;
/
