create or replace package Ui_Vhr293 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr293;
/
create or replace package body Ui_Vhr293 is
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
    return b.Translate('UI-VHR293:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select *
                  from href_staffs w
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.hiring_date <= :max_date
                   and (w.dismissal_date is null or
                       w.dismissal_date >= :min_date)
                   and w.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = w.company_id
                           and e.filial_id = w.filial_id
                           and e.employee_id = w.employee_id
                           and e.state = ''A'')';
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'min_date',
                                 p.r_Date('begin_date'),
                                 'max_date',
                                 p.r_Date('end_date')));
    q.Number_Field('employee_id', 'staff_id', 'division_id', 'job_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    v_Matrix := Href_Util.Staff_Kinds;
  
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('name',
                'select q.name
                  from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    v_Division_Ids Array_Number := p.o_Array_Number('division_ids');
    v_Params       Hashmap;
    v_Query        varchar2(32767);
    q              Fazo_Query;
  begin
    v_Query := 'select *
                  from mhr_jobs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if not Fazo.Is_Empty(v_Division_Ids) then
      v_Query := v_Query || --
                 ' and (q.c_divisions_exist = ''N'' or exists 
                        (select 1
                           from Mhr_Job_Divisions w
                          where w.Company_Id = q.Company_Id
                            and w.Filial_Id = q.Filial_Id
                            and w.Job_Id = q.Job_Id
                            and w.Division_Id in (select *
                                                    from table(:Division_Ids))))';
    
      v_Params.Put('division_ids', v_Division_Ids);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate)));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Run_Late
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number,
    i_Staff_Ids    Array_Number
  ) is
    v_Division_Count number := i_Division_Ids.Count;
    v_Job_Count      number := i_Job_Ids.Count;
    v_Staff_Count    number := i_Staff_Ids.Count;
  
    v_Division_Names Array_Varchar2;
    v_Job_Names      Array_Varchar2;
  
    a        b_Table := b_Report.New_Table();
    v_Column number := 1;
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1);
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Late_Tk_Id   number;
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  begin
    -- info
    a.Current_Style('root bold');
  
    a.New_Row;
    if v_Division_Count <> 0 then
      a.New_Row;
    
      select d.Name
        bulk collect
        into v_Division_Names
        from Mhr_Divisions d
       where d.Company_Id = i_Company_Id
         and d.Filial_Id = i_Filial_Id
         and d.Division_Id member of i_Division_Ids;
    
      a.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => 5);
    end if;
  
    if v_Job_Count <> 0 then
      a.New_Row;
      select q.Name
        bulk collect
        into v_Job_Names
        from Mhr_Jobs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Job_Id member of i_Job_Ids;
    
      a.Data(t('job: $1', Fazo.Gather(v_Job_Names, ', ')), i_Colspan => 5);
    end if;
  
    a.New_Row;
    a.Data(t('period: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 5);
    a.New_Row;
    -- header
    a.Current_Style('header');
  
    a.New_Row;
    Print_Header(t('rownum'), 1, 2, 50);
    Print_Header(t('staff number'), 1, 2, 100);
    Print_Header(t('name'), 1, 2, 250);
    Print_Header(t('division'), 1, 2, 200);
    Print_Header(t('job'), 1, 2, 200);
    Print_Header(t('rank'), 1, 2, 100);
    Print_Header(t('late_count'), 1, 2, 75);
  
    -- body
    a.Current_Style('body_centralized');
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    v_Late_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true,
                                                                    i_Gather_Chiefs      => false);
    end if;
  
    for r in (select Rownum, b.*
                from (select q.*,
                             w.Name,
                             w.Gender,
                             (select count(w.Fact_Value)
                                from Htt_Timesheets t
                                join Htt_Timesheet_Facts w
                                  on w.Company_Id = t.Company_Id
                                 and w.Filial_Id = t.Filial_Id
                                 and w.Timesheet_Id = t.Timesheet_Id
                                 and w.Time_Kind_Id = v_Late_Tk_Id
                                 and w.Fact_Value > 0
                               where t.Company_Id = w.Company_Id
                                 and t.Filial_Id = q.Filial_Id
                                 and t.Staff_Id = q.Staff_Id
                                 and t.Timesheet_Date between i_Begin_Date and
                                     Least(i_End_Date, Trunc(sysdate))) Late_Count
                        from Href_Staffs q
                        join Mr_Natural_Persons w
                          on w.Company_Id = q.Company_Id
                         and w.Person_Id = q.Employee_Id
                        join Mhr_Employees k
                          on k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Employee_Id = q.Employee_Id
                         and k.State = 'A'
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.Hiring_Date <= i_End_Date
                         and i_Begin_Date <= Nvl(q.Dismissal_Date, i_Begin_Date)
                         and (v_Division_Count = 0 or q.Division_Id member of i_Division_Ids)
                         and (v_Job_Count = 0 or q.Job_Id member of i_Job_Ids)
                         and (v_Staff_Count = 0 or q.Staff_Id member of i_Staff_Ids)
                         and (v_Access_All_Employees = 'Y' or q.Employee_Id = v_User_Id or --
                             q.Org_Unit_Id member of v_Subordinate_Divisions)
                         and q.State = 'A'
                       order by Late_Count desc) b)
    loop
      if r.Late_Count > 0 then
        a.New_Row;
        a.Data(r.Rownum);
        a.Data(r.Staff_Number);
        a.Data(r.Name,
               'body middle',
               i_Param => Fazo.Zip_Map('staff_id', r.Staff_Id,'begin_date', i_Begin_Date,'end_date', i_End_Date).Json());
        a.Data(to_char(z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r.Division_Id).Name),
               'body left');
        a.Data(to_char(z_Mhr_Jobs.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => r.Job_Id).Name),
               'body left');
        a.Data(to_char(z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => r.Rank_Id).Name),
               'body left');
        a.Data(r.Late_Count);
      end if;
    end loop;
  
    b_Report.Add_Sheet(t('late'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Absence
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number,
    i_Staff_Ids    Array_Number
  ) is
    v_Division_Count number := i_Division_Ids.Count;
    v_Job_Count      number := i_Job_Ids.Count;
    v_Staff_Count    number := i_Staff_Ids.Count;
  
    v_Division_Names Array_Varchar2;
    v_Job_Names      Array_Varchar2;
  
    a        b_Table := b_Report.New_Table();
    v_Column number := 1;
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1);
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Absence_Tk_Id number;
    v_Nls_Language  varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  begin
    -- info
    a.Current_Style('root bold');
  
    a.New_Row;
    if v_Division_Count <> 0 then
      a.New_Row;
    
      select d.Name
        bulk collect
        into v_Division_Names
        from Mhr_Divisions d
       where d.Company_Id = i_Company_Id
         and d.Filial_Id = i_Filial_Id
         and d.Division_Id member of i_Division_Ids;
    
      a.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => 5);
    end if;
  
    if v_Job_Count <> 0 then
      a.New_Row;
      select q.Name
        bulk collect
        into v_Job_Names
        from Mhr_Jobs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Job_Id member of i_Job_Ids;
    
      a.Data(t('job: $1', Fazo.Gather(v_Job_Names, ', ')), i_Colspan => 5);
    end if;
  
    a.New_Row;
    a.Data(t('period: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 5);
    a.New_Row;
    -- header
    a.Current_Style('header');
  
    a.New_Row;
    Print_Header(t('rownum'), 1, 2, 50);
    Print_Header(t('staff number'), 1, 2, 100);
    Print_Header(t('name'), 1, 2, 250);
    Print_Header(t('division'), 1, 2, 200);
    Print_Header(t('job'), 1, 2, 200);
    Print_Header(t('rank'), 1, 2, 100);
    Print_Header(t('absence_count'), 1, 2, 75);
  
    -- body
    a.Current_Style('body_centralized');
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    v_Absence_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true,
                                                                    i_Gather_Chiefs      => false);
    end if;
  
    for r in (select b.*, Rownum
                from (select q.*,
                             w.Name,
                             w.Gender,
                             (select count(w.Fact_Value)
                                from Htt_Timesheets t
                                join Htt_Timesheet_Facts w
                                  on w.Company_Id = t.Company_Id
                                 and w.Filial_Id = t.Filial_Id
                                 and w.Timesheet_Id = t.Timesheet_Id
                                 and w.Time_Kind_Id = v_Absence_Tk_Id
                                 and w.Fact_Value = t.Plan_Time
                                 and w.Fact_Value > 0
                               where t.Company_Id = q.Company_Id
                                 and t.Filial_Id = q.Filial_Id
                                 and t.Staff_Id = q.Staff_Id
                                 and t.Timesheet_Date between i_Begin_Date and
                                     Least(i_End_Date, Trunc(sysdate) - 1)) Absence_Count
                        from Href_Staffs q
                        join Mr_Natural_Persons w
                          on w.Company_Id = q.Company_Id
                         and w.Person_Id = q.Employee_Id
                        join Mhr_Employees k
                          on k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Employee_Id = q.Employee_Id
                         and k.State = 'A'
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.Hiring_Date <= i_End_Date
                         and i_Begin_Date <= Nvl(q.Dismissal_Date, i_Begin_Date)
                         and (v_Division_Count = 0 or q.Division_Id member of i_Division_Ids)
                         and (v_Job_Count = 0 or q.Job_Id member of i_Job_Ids)
                         and (v_Staff_Count = 0 or q.Staff_Id member of i_Staff_Ids)
                         and (v_Access_All_Employees = 'Y' or q.Employee_Id = v_User_Id or --
                             q.Org_Unit_Id member of v_Subordinate_Divisions)
                         and q.State = 'A'
                       order by Absence_Count desc) b)
    loop
      if r.Absence_Count > 0 then
        a.New_Row;
        a.Data(r.Rownum);
        a.Data(r.Staff_Number);
        a.Data(r.Name,
               'body middle',
               i_Param => Fazo.Zip_Map('staff_id', r.Staff_Id,'begin_date', i_Begin_Date,'end_date', i_End_Date).Json());
        a.Data(z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r.Division_Id).Name,
               'body left');
        a.Data(z_Mhr_Jobs.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => r.Job_Id).Name,
               'body left');
        a.Data(z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => r.Rank_Id).Name,
               'body left');
        a.Data(r.Absence_Count);
      end if;
    end loop;
  
    b_Report.Add_Sheet(i_Name => t('absence'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Staff_Ids  Array_Number;
    v_Param      Hashmap;
  begin
    v_Staff_Ids := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Ids(i),
                                      i_All      => true,
                                      i_Self     => true,
                                      i_Direct   => true,
                                      i_Undirect => true);
    end loop;
  
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
    
      if v_Param.Has('staff_id') then
        v_Param := Fazo.Zip_Map('staff_ids',
                                v_Param.r_Number('staff_id'),
                                'begin_date',
                                v_Param.r_Date('begin_date'),
                                'end_date',
                                v_Param.r_Date('end_date'));
        v_Param.Put_All(Fazo.Parse_Map(p.r_Varchar2('table_param')));
      
        b_Report.Redirect_To_Report('/vhr/rep/htt/timesheet:run', v_Param);
      end if;
    else
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => Ui.Current_Form_Name);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
    
      Run_Late(i_Company_Id   => v_Company_Id,
               i_Filial_Id    => v_Filial_Id,
               i_Begin_Date   => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
               i_End_Date     => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
               i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
               i_Job_Ids      => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
               i_Staff_Ids    => v_Staff_Ids);
    
      Run_Absence(i_Company_Id   => v_Company_Id,
                  i_Filial_Id    => v_Filial_Id,
                  i_Begin_Date   => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
                  i_End_Date     => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
                  i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                  i_Job_Ids      => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
                  i_Staff_Ids    => v_Staff_Ids);
    
      b_Report.Close_Book();
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
           Staff_Kind     = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null,
           Code       = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
  end;

end Ui_Vhr293;
/
