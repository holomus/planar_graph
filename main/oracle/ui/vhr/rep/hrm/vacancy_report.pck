create or replace package Ui_Vhr578 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr578;
/
create or replace package body Ui_Vhr578 is
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
    return b.Translate('UI-VHR578:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_job_groups', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('job_group_id');
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
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('date', Trunc(sysdate));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Vacancy
  (
    i_Date               date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number,
    i_Job_Group_Ids      Array_Number,
    i_Job_Ids            Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Division_Group_Cnt   number := i_Division_Group_Ids.Count;
    v_Division_Cnt         number;
    v_Job_Group_Cnt        number := i_Job_Group_Ids.Count;
    v_Job_Cnt              number := i_Job_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    a                      b_Table := b_Report.New_Table();
  
    --------------------------------------------------
    Procedure Print_Info is
      v_Default_Limit number := 5;
      v_Limit         number;
      v_Colspan       number := 11;
      t_Other         varchar2(20) := t('... others');
      v_Names         Array_Varchar2 := Array_Varchar2();
    begin
      a.Current_Style('root bold');
      a.New_Row;
      a.New_Row;
      a.Data(t('date: $1{date}', i_Date), i_Colspan => v_Colspan);
    
      if v_Division_Group_Cnt > 0 then
        a.New_Row;
      
        v_Limit := Least(v_Default_Limit, v_Division_Group_Cnt);
        v_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Names(i) := z_Mhr_Division_Groups.Load(i_Company_Id => v_Company_Id, i_Division_Group_Id => i_Division_Group_Ids(i)).Name;
        end loop;
      
        if v_Division_Group_Cnt > v_Limit then
          Fazo.Push(v_Names, t_Other);
        end if;
      
        a.Data(t('division groups: $1{division_group_names}', Fazo.Gather(v_Names, ',')),
               i_Colspan => v_Colspan);
      end if;
    
      if v_Division_Cnt > 0 then
        a.New_Row;
      
        v_Limit := Least(v_Default_Limit, v_Division_Cnt);
        v_Names := Array_Varchar2();
        v_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Names(i) := z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => i_Division_Ids(i)).Name;
        end loop;
      
        if v_Division_Cnt > v_Limit then
          Fazo.Push(v_Names, t_Other);
        end if;
      
        a.Data(t('divisions: $1{division_names}', Fazo.Gather(v_Names, ',')),
               i_Colspan => v_Colspan);
      end if;
    
      if v_Job_Group_Cnt > 0 then
        a.New_Row;
      
        v_Limit := Least(v_Default_Limit, v_Job_Group_Cnt);
        v_Names := Array_Varchar2();
        v_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Names(i) := z_Mhr_Job_Groups.Load(i_Company_Id => v_Company_Id, i_Job_Group_Id => i_Job_Group_Ids(i)).Name;
        end loop;
      
        if v_Job_Group_Cnt > v_Limit then
          Fazo.Push(v_Names, t_Other);
        end if;
      
        a.Data(t('job_groups: $1{job_group_names}', Fazo.Gather(v_Names, ',')),
               i_Colspan => v_Colspan);
      end if;
    
      if v_Job_Cnt > 0 then
        a.New_Row;
      
        v_Limit := Least(v_Default_Limit, v_Job_Cnt);
        v_Names := Array_Varchar2();
        v_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Names(i) := z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Job_Id => i_Job_Ids(i)).Name;
        end loop;
      
        if v_Job_Cnt > v_Limit then
          Fazo.Push(v_Names, t_Other);
        end if;
      
        a.Data(t('jobs: $1{job_names}', Fazo.Gather(v_Names, ',')), i_Colspan => v_Colspan);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
      v_Martix Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('order number'), 50),
                                                  Array_Varchar2(t('division group'), 250),
                                                  Array_Varchar2(t('division'), 250),
                                                  Array_Varchar2(t('team'), 250),
                                                  Array_Varchar2(t('job_group'), 250),
                                                  Array_Varchar2(t('job'), 250),
                                                  Array_Varchar2(t('robot'), 250),
                                                  Array_Varchar2(t('begin date'), 250));
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      for i in 1 .. v_Martix.Count
      loop
        a.Data(v_Martix(i) (1));
        a.Column_Width(i, v_Martix(i) (2));
      end loop;
    end;
  begin
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                                  i_Indirect         => true,
                                                                  i_Manual           => true,
                                                                  i_Only_Departments => 'Y');
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Division_Cnt := v_Filter_Division_Ids.Count;
  
    -- body
    a.Current_Style('body_centralized');
  
    for r in (select Rownum,
                     (select Dg.Name
                        from Mhr_Division_Groups Dg
                       where Dg.Company_Id = d.Company_Id
                         and Dg.Division_Group_Id = d.Division_Group_Id) Division_Group_Name,
                     d.Name Division_Name,
                     case
                        when Rb.Org_Unit_Id != q.Division_Id then
                         (select s.Name
                            from Mhr_Divisions s
                           where s.Company_Id = Rb.Company_Id
                             and s.Filial_Id = Rb.Filial_Id
                             and s.Division_Id = Rb.Org_Unit_Id)
                        else
                         ''
                      end Team_Name,
                     (select Jg.Name
                        from Mhr_Job_Groups Jg
                       where Jg.Company_Id = j.Company_Id
                         and Jg.Job_Group_Id = j.Job_Group_Id) Job_Group_Name,
                     j.Name Job_Name,
                     q.Name Robot_Name,
                     (select max(f.Trans_Date)
                        from Hrm_Robot_Transactions f
                       where f.Company_Id = q.Company_Id
                         and f.Filial_Id = q.Filial_Id
                         and f.Robot_Id = q.Robot_Id
                         and f.Trans_Date <= Rt.Period) Begin_Date
                from Mrf_Robots q
                join Hrm_Robots Rb
                  on Rb.Company_Id = q.Company_Id
                 and Rb.Filial_Id = q.Filial_Id
                 and Rb.Robot_Id = q.Robot_Id
                join Hrm_Robot_Turnover Rt
                  on Rt.Company_Id = q.Company_Id
                 and Rt.Filial_Id = q.Filial_Id
                 and Rt.Robot_Id = q.Robot_Id
                 and Rt.Period = (select max(Qt.Period)
                                    from Hrm_Robot_Turnover Qt
                                   where Qt.Company_Id = q.Company_Id
                                     and Qt.Filial_Id = q.Filial_Id
                                     and Qt.Robot_Id = q.Robot_Id
                                     and Qt.Period <= i_Date)
                join Mhr_Divisions d
                  on d.Company_Id = q.Company_Id
                 and d.Filial_Id = q.Filial_Id
                 and d.Division_Id = q.Division_Id
                 and exists (select 1
                        from Hrm_Divisions Dv
                       where Dv.Company_Id = d.Company_Id
                         and Dv.Filial_Id = d.Filial_Id
                         and Dv.Division_Id = d.Division_Id
                         and Dv.Is_Department = 'Y')
                join Mhr_Jobs j
                  on j.Company_Id = q.Company_Id
                 and j.Filial_Id = q.Filial_Id
                 and j.Job_Id = q.Job_Id
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.State = 'A'
                 and Rt.Fte > 0
                 and (v_Division_Group_Cnt = 0 or --
                     d.Division_Group_Id member of i_Division_Group_Ids)
                 and (v_Access_All_Employees = 'Y' and v_Division_Cnt = 0 or --
                     d.Division_Id member of v_Filter_Division_Ids)
                 and (v_Job_Group_Cnt = 0 or --
                     j.Job_Group_Id member of i_Job_Group_Ids)
                 and (v_Job_Cnt = 0 or --
                     j.Job_Id member of i_Job_Ids))
    loop
      a.New_Row;
      a.Data(to_char(r.Rownum)); -- To prevent the format from getting corrupted in Excel
      a.Data(r.Division_Group_Name);
      a.Data(r.Division_Name);
      a.Data(r.Team_Name);
      a.Data(r.Job_Group_Name);
      a.Data(r.Job_Name);
      a.Data(r.Robot_Name);
      a.Data(r.Begin_Date);
    end loop;
  
    b_Report.Add_Sheet(i_Name => t('vacancy'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Data               date := p.r_Date('date');
    v_Division_Group_Ids Array_Number := Nvl(p.o_Array_Number('division_group_ids'), Array_Number());
    v_Division_Ids       Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Job_Group_Ids      Array_Number := Nvl(p.o_Array_Number('job_group_ids'), Array_Number());
    v_Job_Ids            Array_Number := Nvl(p.o_Array_Number('job_ids'), Array_Number());
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    Run_Vacancy(i_Date               => v_Data,
                i_Division_Group_Ids => v_Division_Group_Ids,
                i_Division_Ids       => v_Division_Ids,
                i_Job_Group_Ids      => v_Job_Group_Ids,
                i_Job_Ids            => v_Job_Ids);
  
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
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null,
           State        = null;
  end;

end Ui_Vhr578;
/
