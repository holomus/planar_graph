create or replace package Ui_Vhr577 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr577;
/
create or replace package body Ui_Vhr577 is
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
    return b.Translate('UI-VHR577:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Division_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_division_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('division_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    v_Param Hashmap;
    q       Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
    v_Param.Put('division_ids', p.o_Array_Number('division_id'));
  
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''
                        and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id member of :division_ids))',
                    v_Param);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('begin_date',
                            Trunc(sysdate, 'mon'),
                            'end_date',
                            Trunc(sysdate),
                            'view_hiring',
                            'Y',
                            'view_dismissal',
                            'Y',
                            'view_arrive_transfer',
                            'Y',
                            'view_depart_transfer',
                            'Y'));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Head
  (
    a            in out nocopy b_Table,
    i_Begin_Date date,
    i_End_Date   date,
    i_State      varchar2
  ) is
    v_Widths Array_Number := Array_Number(30, 150, 150, 150, 200, 200, 100, 200);
  begin
    for i in 1 .. v_Widths.Count
    loop
      a.Column_Width(i, v_Widths(i));
    end loop;
  
    a.Data(t('$1 on period $2 - $3', i_State, i_Begin_Date, i_End_Date), i_Colspan => 4);
  
    a.Current_Style('header');
  
    a.New_Row;
    a.Data('#');
    a.Data(t('division group'));
    a.Data(t('division'));
    a.Data(t('job name'));
    a.Data(t('robot name'));
    a.Data(t('staff name'));
    a.Data(t('with date'));
    a.Data(t('note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Body
  (
    a                     in out nocopy b_Table,
    i_Row                 number,
    i_Division_Group_Name varchar2,
    i_Division_Name       varchar2,
    i_Job_Name            varchar2,
    i_Robot_Name          varchar2,
    i_Staff_Name          varchar2,
    i_Begin_Date          date,
    i_Note                varchar2 := null
  ) is
  begin
    a.Current_Style('body');
    a.Data(i_Row);
    a.Data(i_Division_Group_Name);
    a.Data(i_Division_Name);
    a.Data(i_Job_Name);
    a.Data(i_Robot_Name);
    a.Data(i_Staff_Name);
    a.Data(i_Begin_Date);
    a.Data(i_Note);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Hiring
  (
    a                    in out nocopy b_Table,
    i_Begin_Date         date,
    i_End_Date           date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number,
    i_Job_Ids            Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Division_Group_Count number := i_Division_Group_Ids.Count;
    v_Division_Count       number := i_Division_Ids.Count;
    v_Job_Count            number := i_Job_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
  begin
    a.Current_Style('');
    Print_Head(a            => a,
               i_Begin_Date => i_Begin_Date,
               i_End_Date   => i_End_Date,
               i_State      => t('new hirings'));
  
    for r in (select t.Period,
                     (select (select w.Name
                                from Mr_Natural_Persons w
                               where w.Company_Id = St.Company_Id
                                 and w.Person_Id = St.Employee_Id)
                        from Href_Staffs St
                       where St.Company_Id = v_Company_Id
                         and St.Filial_Id = v_Filial_Id
                         and St.Staff_Id = t.Staff_Id) as Staff_Name,
                     (select Mr.Name
                        from Mrf_Robots Mr
                       where Mr.Company_Id = v_Company_Id
                         and Mr.Filial_Id = v_Filial_Id
                         and Mr.Robot_Id = r.Robot_Id) as Robot_Name,
                     (select Dg.Name
                        from Mhr_Division_Groups Dg
                       where Dg.Company_Id = v_Company_Id
                         and Dg.Division_Group_Id =
                             (select Div.Division_Group_Id
                                from Mhr_Divisions Div
                               where Div.Company_Id = v_Company_Id
                                 and Div.Filial_Id = v_Filial_Id
                                 and Div.Division_Id = r.Division_Id)) as Division_Group_Name,
                     (select Dv.Name
                        from Mhr_Divisions Dv
                       where Dv.Company_Id = v_Company_Id
                         and Dv.Filial_Id = v_Filial_Id
                         and Dv.Division_Id = r.Division_Id) as Division_Name,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = v_Company_Id
                         and Jb.Filial_Id = v_Filial_Id
                         and Jb.Job_Id = r.Job_Id) as Job_Name,
                     Rownum
                from Hpd_Agreements t
                join Hpd_Trans_Robots r
                  on r.Company_Id = v_Company_Id
                 and r.Filial_Id = v_Filial_Id
                 and r.Trans_Id = t.Trans_Id
                 and (v_Access_All_Employees = 'Y' and v_Division_Count = 0 or --
                     r.Division_Id member of i_Division_Ids)
                 and (v_Job_Count = 0 or r.Job_Id member of i_Job_Ids)
                 and (v_Division_Group_Count = 0 or exists
                      (select 1
                         from Mhr_Divisions q
                        where q.Company_Id = v_Company_Id
                          and q.Filial_Id = v_Filial_Id
                          and q.Division_Id = r.Division_Id
                          and q.Division_Group_Id member of i_Division_Group_Ids))
               where t.Company_Id = v_Company_Id
                 and t.Filial_Id = v_Filial_Id
                 and t.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and t.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and t.Period between i_Begin_Date and i_End_Date
                 and t.Period =
                     (select min(Ag.Period)
                        from Hpd_Agreements Ag
                       where Ag.Company_Id = v_Company_Id
                         and Ag.Filial_Id = v_Filial_Id
                         and Ag.Staff_Id = t.Staff_Id
                         and Ag.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                         and Ag.Action = Hpd_Pref.c_Transaction_Action_Continue))
    loop
      a.New_Row;
      Print_Body(a                     => a,
                 i_Row                 => r.Rownum,
                 i_Division_Group_Name => r.Division_Group_Name,
                 i_Division_Name       => r.Division_Name,
                 i_Job_Name            => r.Job_Name,
                 i_Robot_Name          => r.Robot_Name,
                 i_Staff_Name          => r.Staff_Name,
                 i_Begin_Date          => r.Period);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Print_Dismissal
  (
    a                    in out nocopy b_Table,
    i_Begin_Date         date,
    i_End_Date           date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number,
    i_Job_Ids            Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Division_Group_Count number := i_Division_Group_Ids.Count;
    v_Division_Count       number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Job_Count            number := i_Job_Ids.Count;
  begin
    a.Current_Style('');
    Print_Head(a            => a,
               i_Begin_Date => i_Begin_Date,
               i_End_Date   => i_End_Date,
               i_State      => t('dismissals'));
  
    for r in (select s.Dismissal_Date,
                     (select k.Name
                        from Href_Dismissal_Reasons k
                       where k.Company_Id = v_Company_Id
                         and k.Dismissal_Reason_Id = s.Dismissal_Reason_Id) as Dismissal_Reason_Name,
                     (select w.Name
                        from Mr_Natural_Persons w
                       where w.Company_Id = v_Company_Id
                         and w.Person_Id = s.Employee_Id) as Staff_Name,
                     (select Mr.Name
                        from Mrf_Robots Mr
                       where Mr.Company_Id = v_Company_Id
                         and Mr.Filial_Id = v_Filial_Id
                         and Mr.Robot_Id = s.Robot_Id) as Robot_Name,
                     (select Dg.Name
                        from Mhr_Division_Groups Dg
                       where Dg.Company_Id = v_Company_Id
                         and Dg.Division_Group_Id = Dv.Division_Group_Id) as Division_Group_Name,
                     Dv.Name as Division_Name,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = v_Company_Id
                         and Jb.Filial_Id = v_Filial_Id
                         and Jb.Job_Id = s.Job_Id) as Job_Name,
                     Rownum
                from Hpd_Dismissal_Transactions d
                join Hpd_Dismissals p
                  on p.Company_Id = d.Company_Id
                 and p.Filial_Id = d.Filial_Id
                 and p.Page_Id = d.Page_Id
                join Href_Staffs s
                  on s.Company_Id = d.Company_Id
                 and s.Filial_Id = d.Filial_Id
                 and s.Staff_Id = d.Staff_Id
                join Mhr_Divisions Dv
                  on Dv.Company_Id = v_Company_Id
                 and Dv.Filial_Id = v_Filial_Id
                 and Dv.Division_Id = s.Division_Id
               where d.Company_Id = v_Company_Id
                 and d.Filial_Id = v_Filial_Id
                 and s.Dismissal_Date between i_Begin_Date and i_End_Date
                 and (v_Access_All_Employees = 'Y' and v_Division_Count = 0 or --
                     s.Division_Id member of i_Division_Ids)
                 and (v_Job_Count = 0 or s.Job_Id member of i_Job_Ids)
                 and (v_Division_Group_Count = 0 or Dv.Division_Group_Id member of
                      i_Division_Group_Ids))
    loop
      a.New_Row;
      Print_Body(a                     => a,
                 i_Row                 => r.Rownum,
                 i_Division_Group_Name => r.Division_Group_Name,
                 i_Division_Name       => r.Division_Name,
                 i_Job_Name            => r.Job_Name,
                 i_Robot_Name          => r.Robot_Name,
                 i_Staff_Name          => r.Staff_Name,
                 i_Begin_Date          => r.Dismissal_Date,
                 i_Note                => r.Dismissal_Reason_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Arrive_Transfer
  (
    a                    in out nocopy b_Table,
    i_Begin_Date         date,
    i_End_Date           date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number,
    i_Job_Ids            Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Division_Group_Count number := i_Division_Group_Ids.Count;
    v_Division_Count       number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Job_Count            number := i_Job_Ids.Count;
  begin
    a.Current_Style('');
    Print_Head(a            => a,
               i_Begin_Date => i_Begin_Date,
               i_End_Date   => i_End_Date,
               i_State      => t('arrive transfers'));
  
    for r in (select t.Period,
                     (select (select w.Name
                                from Mr_Natural_Persons w
                               where w.Company_Id = St.Company_Id
                                 and w.Person_Id = St.Employee_Id)
                        from Href_Staffs St
                       where St.Company_Id = v_Company_Id
                         and St.Filial_Id = v_Filial_Id
                         and St.Staff_Id = t.Staff_Id) as Staff_Name,
                     (select Mr.Name
                        from Mrf_Robots Mr
                       where Mr.Company_Id = v_Company_Id
                         and Mr.Filial_Id = v_Filial_Id
                         and Mr.Robot_Id = r.Robot_Id) as Robot_Name,
                     (select Dg.Name
                        from Mhr_Division_Groups Dg
                       where Dg.Company_Id = v_Company_Id
                         and Dg.Division_Group_Id =
                             (select Div.Division_Group_Id
                                from Mhr_Divisions Div
                               where Div.Company_Id = v_Company_Id
                                 and Div.Filial_Id = v_Filial_Id
                                 and Div.Division_Id = r.Division_Id)) as Division_Group_Name,
                     (select Dv.Name
                        from Mhr_Divisions Dv
                       where Dv.Company_Id = v_Company_Id
                         and Dv.Filial_Id = v_Filial_Id
                         and Dv.Division_Id = r.Division_Id) as Division_Name,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = v_Company_Id
                         and Jb.Filial_Id = v_Filial_Id
                         and Jb.Job_Id = r.Job_Id) as Job_Name,
                     Rownum
                from Hpd_Agreements t
                join Hpd_Trans_Robots r
                  on r.Company_Id = v_Company_Id
                 and r.Filial_Id = v_Filial_Id
                 and r.Trans_Id = t.Trans_Id
                 and (v_Access_All_Employees = 'Y' and v_Division_Count = 0 or -- 
                     r.Division_Id member of i_Division_Ids)
                 and (v_Job_Count = 0 or r.Job_Id member of i_Job_Ids)
                 and (v_Division_Group_Count = 0 or exists
                      (select 1
                         from Mhr_Divisions q
                        where q.Company_Id = v_Company_Id
                          and q.Filial_Id = v_Filial_Id
                          and q.Division_Id = r.Division_Id
                          and q.Division_Group_Id member of i_Division_Group_Ids))
               where t.Company_Id = v_Company_Id
                 and t.Filial_Id = v_Filial_Id
                 and t.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and t.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and t.Period between i_Begin_Date and i_End_Date
                 and exists (select 1
                        from Hpd_Transactions q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and q.Trans_Id = t.Trans_Id
                         and q.Tag = Zt.Hpd_Transfers.Name))
    loop
      a.New_Row;
      Print_Body(a                     => a,
                 i_Row                 => r.Rownum,
                 i_Division_Group_Name => r.Division_Group_Name,
                 i_Division_Name       => r.Division_Name,
                 i_Job_Name            => r.Job_Name,
                 i_Robot_Name          => r.Robot_Name,
                 i_Staff_Name          => r.Staff_Name,
                 i_Begin_Date          => r.Period);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Print_Depart_Transfer
  (
    a                    in out nocopy b_Table,
    i_Begin_Date         date,
    i_End_Date           date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number,
    i_Job_Ids            Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Division_Group_Count number := i_Division_Group_Ids.Count;
    v_Division_Count       number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Job_Count            number := i_Job_Ids.Count;
  begin
    a.Current_Style('');
    Print_Head(a            => a,
               i_Begin_Date => i_Begin_Date,
               i_End_Date   => i_End_Date,
               i_State      => t('depart transfers'));
  
    for r in (select t.Period,
                     (select (select w.Name
                                from Mr_Natural_Persons w
                               where w.Company_Id = St.Company_Id
                                 and w.Person_Id = St.Employee_Id)
                        from Href_Staffs St
                       where St.Company_Id = v_Company_Id
                         and St.Filial_Id = v_Filial_Id
                         and St.Staff_Id = t.Staff_Id) as Staff_Name,
                     (select Mr.Name
                        from Mrf_Robots Mr
                       where Mr.Company_Id = v_Company_Id
                         and Mr.Filial_Id = v_Filial_Id
                         and Mr.Robot_Id = Tr.Robot_Id) as Robot_Name,
                     (select Dg.Name
                        from Mhr_Division_Groups Dg
                       where Dg.Company_Id = v_Company_Id
                         and Dg.Division_Group_Id =
                             (select Div.Division_Group_Id
                                from Mhr_Divisions Div
                               where Div.Company_Id = v_Company_Id
                                 and Div.Filial_Id = v_Filial_Id
                                 and Div.Division_Id = Tr.Division_Id)) as Division_Group_Name,
                     (select Dv.Name
                        from Mhr_Divisions Dv
                       where Dv.Company_Id = v_Company_Id
                         and Dv.Filial_Id = v_Filial_Id
                         and Dv.Division_Id = Tr.Division_Id) as Division_Name,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = v_Company_Id
                         and Jb.Filial_Id = v_Filial_Id
                         and Jb.Job_Id = Tr.Job_Id) as Job_Name,
                     Rownum
                from Hpd_Agreements t
                join Hpd_Agreements Ag
                  on Ag.Company_Id = t.Company_Id
                 and Ag.Filial_Id = t.Filial_Id
                 and Ag.Staff_Id = t.Staff_Id
                 and Ag.Trans_Type = t.Trans_Type
                 and Ag.Period = (select max(r.Period)
                                    from Hpd_Agreements r
                                   where r.Company_Id = v_Company_Id
                                     and r.Filial_Id = v_Filial_Id
                                     and r.Staff_Id = Ag.Staff_Id
                                     and r.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                                     and r.Action = Hpd_Pref.c_Transaction_Action_Continue
                                     and r.Period < t.Period)
                join Hpd_Trans_Robots Tr
                  on Tr.Company_Id = v_Company_Id
                 and Tr.Filial_Id = v_Filial_Id
                 and Tr.Trans_Id = Ag.Trans_Id
                 and (v_Access_All_Employees = 'Y' and v_Division_Count = 0 or --
                     Tr.Division_Id member of i_Division_Ids)
                 and (v_Job_Count = 0 or Tr.Job_Id member of i_Job_Ids)
                 and (v_Division_Group_Count = 0 or exists
                      (select 1
                         from Mhr_Divisions Dv
                        where Dv.Company_Id = v_Company_Id
                          and Dv.Filial_Id = v_Filial_Id
                          and Dv.Division_Id = Tr.Division_Id
                          and Dv.Division_Group_Id member of i_Division_Group_Ids))
               where t.Company_Id = v_Company_Id
                 and t.Filial_Id = v_Filial_Id
                 and t.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                 and t.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and t.Period between i_Begin_Date and i_End_Date
                 and exists (select 1
                        from Hpd_Transactions q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and q.Trans_Id = t.Trans_Id
                         and q.Tag = Zt.Hpd_Transfers.Name))
    loop
      a.New_Row;
      Print_Body(a                     => a,
                 i_Row                 => r.Rownum,
                 i_Division_Group_Name => r.Division_Group_Name,
                 i_Division_Name       => r.Division_Name,
                 i_Job_Name            => r.Job_Name,
                 i_Robot_Name          => r.Robot_Name,
                 i_Staff_Name          => r.Staff_Name,
                 i_Begin_Date          => r.Period);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Begin_Date           date,
    i_End_Date             date,
    i_Division_Group_Ids   Array_Number,
    i_Division_Ids         Array_Number,
    i_Job_Ids              Array_Number,
    i_View_Hiring          varchar,
    i_View_Dismissal       varchar,
    i_View_Arrive_Transfer varchar,
    i_View_Depart_Transfer varchar
  ) is
    a                     b_Table := b_Report.New_Table();
    v_Filter_Division_Ids Array_Number := i_Division_Ids;
  begin
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                                  i_Indirect         => true,
                                                                  i_Manual           => true,
                                                                  i_Only_Departments => 'Y');
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    if i_View_Hiring = 'Y' then
      a.New_Row;
      a.New_Row;
      Print_Hiring(a                    => a,
                   i_Begin_Date         => i_Begin_Date,
                   i_End_Date           => i_End_Date,
                   i_Division_Group_Ids => i_Division_Group_Ids,
                   i_Division_Ids       => v_Filter_Division_Ids,
                   i_Job_Ids            => i_Job_Ids);
    end if;
  
    if i_View_Arrive_Transfer = 'Y' then
      a.New_Row;
      a.New_Row;
      Print_Arrive_Transfer(a                    => a,
                            i_Begin_Date         => i_Begin_Date,
                            i_End_Date           => i_End_Date,
                            i_Division_Group_Ids => i_Division_Group_Ids,
                            i_Division_Ids       => v_Filter_Division_Ids,
                            i_Job_Ids            => i_Job_Ids);
    end if;
  
    if i_View_Depart_Transfer = 'Y' then
      a.New_Row;
      a.New_Row;
      Print_Depart_Transfer(a                    => a,
                            i_Begin_Date         => i_Begin_Date,
                            i_End_Date           => i_End_Date,
                            i_Division_Group_Ids => i_Division_Group_Ids,
                            i_Division_Ids       => v_Filter_Division_Ids,
                            i_Job_Ids            => i_Job_Ids);
    end if;
  
    if i_View_Dismissal = 'Y' then
      a.New_Row;
      a.New_Row;
      Print_Dismissal(a                    => a,
                      i_Begin_Date         => i_Begin_Date,
                      i_End_Date           => i_End_Date,
                      i_Division_Group_Ids => i_Division_Group_Ids,
                      i_Division_Ids       => v_Filter_Division_Ids,
                      i_Job_Ids            => i_Job_Ids);
    end if;
  
    b_Report.Add_Sheet(t('division movement'), a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    Run_All(i_Begin_Date           => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
            i_End_Date             => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
            i_Division_Group_Ids   => Nvl(p.o_Array_Number('division_group_ids'), Array_Number()),
            i_Division_Ids         => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
            i_Job_Ids              => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
            i_View_Hiring          => Nvl(p.o_Varchar2('view_hiring'), 'N'),
            i_View_Dismissal       => Nvl(p.o_Varchar2('view_dismissal'), 'N'),
            i_View_Arrive_Transfer => Nvl(p.o_Varchar2('view_arrive_transfer'), 'N'),
            i_View_Depart_Transfer => Nvl(p.o_Varchar2('view_depart_transfer'), 'N'));
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null,
           State             = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
  end;

end Ui_Vhr577;
/
