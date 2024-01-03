create or replace package Ui_Vhr599 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr599;
/
create or replace package body Ui_Vhr599 is
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
    return b.Translate('UI-VHR599:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Staffing
  (
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Current_Date         date := Trunc(sysdate);
    v_Division_Cnt         number := i_Division_Ids.Count;
    v_Job_Cnt              number := i_Job_Ids.Count;
    v_Column               number := 1;
    v_Order_No             number := 1;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Body_Row_Count       number := 0;
    v_Fte_Count            number;
    v_Div_Job_Count        number;
    a                      b_Table := b_Report.New_Table();
    b                      b_Table;
    c                      b_Table;
    Header_Table           b_Table := b_Report.New_Table();
    Body_Table             b_Table := b_Report.New_Table();
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Rowspan      number,
      i_Colspan      number,
      i_Column_Width number
    ) is
    begin
      Header_Table.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        Header_Table.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Info is
      v_Default_Limit number := 5;
      v_Limit         number;
      v_Colspan       number := 1;
      t_Other         varchar2(20) := t('... others');
      v_Names         Array_Varchar2 := Array_Varchar2();
    begin
      a.New_Row;
    
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
    begin
      Header_Table.Current_Style('header');
      Header_Table.New_Row;
      Header_Table.New_Row;
    
      Print_Header(t('order number'), 2, 1, 50);
      Print_Header(t('division'), 2, 1, 250);
      Print_Header(t('job'), 2, 1, 250);
      Print_Header(t('number of robot and rates'), 1, 6, 250);
      Print_Header(t('robot wage'), 2, 1, 250);
      Print_Header(t('total payroll'), 2, 1, 250);
      Print_Header(t('actual payroll'), 2, 1, 250);
      Print_Header(t('total actual payroll'), 2, 1, 250);
    
      Header_Table.New_Row;
    
      Print_Header(t('count of robot'), 1, 1, 250);
      Print_Header(t('total fte'), 1, 1, 250);
      Print_Header(t('count of employed robot'), 1, 1, 250);
      Print_Header(t('count of vacant posts'), 1, 1, 250);
      Print_Header(t('avarage fte'), 1, 1, 250);
      Print_Header(t('total actual fte'), 1, 1, 250);
    end;
  begin
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
    a.New_Row;
    a.Data(Header_Table);
  
    -- body
    Body_Table.Current_Style('body_centralized');
  
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
  
    for r in (select q.*
                from Mhr_Divisions q
                join Hrm_Divisions Dv
                  on Dv.Company_Id = q.Company_Id
                 and Dv.Filial_Id = q.Filial_Id
                 and Dv.Division_Id = q.Division_Id
                 and Dv.Is_Department = 'Y'
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.State = 'A'
                 and (v_Access_All_Employees = 'Y' and v_Division_Cnt = 0 or --
                     q.Division_Id member of v_Filter_Division_Ids))
    loop
    
      b := b_Report.New_Table();
      b.Current_Style('body_centralized');
    
      v_Div_Job_Count := 0;
    
      for Job in (select Rb.Job_Id,
                         (select j.Name
                            from Mhr_Jobs j
                           where j.Company_Id = v_Company_Id
                             and j.Filial_Id = v_Filial_Id
                             and j.Job_Id = Rb.Job_Id) Job_Name
                    from Mrf_Robots Rb
                    join Hrm_Robots Rh
                      on Rh.Company_Id = Rb.Company_Id
                     and Rh.Filial_Id = Rb.Filial_Id
                     and Rh.Robot_Id = Rb.Robot_Id
                   where Rb.Company_Id = v_Company_Id
                     and Rb.Filial_Id = v_Filial_Id
                     and Rb.Division_Id = r.Division_Id
                     and Rh.Opened_Date <= v_Current_Date
                     and (Rh.Closed_Date is null or v_Current_Date <= Rh.Closed_Date)
                     and (v_Job_Cnt = 0 or Rb.Job_Id member of i_Job_Ids)
                   group by Rb.Job_Id)
      loop
        c := b_Report.New_Table();
        c.Current_Style('body_centralized');
      
        v_Fte_Count := 0;
      
        for Fte in (select count(*) Robot_Cnt, -- robot count
                           sum(Rob.Occupied_Fte) Total_Fte, -- total fte
                           sum(Decode(Rob.Occupied_Fte, Rob.Planed_Fte, 1, 0)) Employed_Robot_Cnt, -- count of employed robot
                           sum(Decode(Rob.Occupied_Fte, Rob.Planed_Fte, 0, 1)) Vocation_Cnt, -- count of robot which has free fte
                           Rob.Planed_Fte,
                           Rob.Robot_Wage
                      from (select Rt.Occupied_Fte,
                                   Rt.Planed_Fte,
                                   Nvl(Hrm_Util.Get_Robot_Wage(i_Company_Id       => v_Company_Id,
                                                               i_Filial_Id        => v_Filial_Id,
                                                               i_Robot_Id         => Rb.Robot_Id,
                                                               i_Contractual_Wage => Hr.Contractual_Wage,
                                                               i_Wage_Scale_Id    => Hr.Wage_Scale_Id,
                                                               i_Rank_Id          => Hr.Rank_Id),
                                       0) Robot_Wage
                              from Mrf_Robots Rb
                              join Hrm_Robots Hr
                                on Hr.Company_Id = Rb.Company_Id
                               and Hr.Filial_Id = Rb.Filial_Id
                               and Hr.Robot_Id = Rb.Robot_Id
                              join Hrm_Robot_Turnover Rt
                                on Rt.Company_Id = Rb.Company_Id
                               and Rt.Filial_Id = Rb.Filial_Id
                               and Rt.Robot_Id = Rb.Robot_Id
                               and Rt.Period = (select max(t.Period)
                                                  from Hrm_Robot_Turnover t
                                                 where t.Company_Id = Rt.Company_Id
                                                   and t.Filial_Id = Rt.Filial_Id
                                                   and t.Robot_Id = Rt.Robot_Id
                                                   and t.Period <= v_Current_Date)
                             where Rb.Company_Id = v_Company_Id
                               and Rb.Filial_Id = v_Filial_Id
                               and Rb.Division_Id = r.Division_Id
                               and Rb.Job_Id = Job.Job_Id
                               and Hr.Opened_Date <= v_Current_Date
                               and (Hr.Closed_Date is null or Hr.Closed_Date >= v_Current_Date)) Rob
                     group by Rob.Planed_Fte, Rob.Robot_Wage
                     order by Rob.Planed_Fte)
        loop
          v_Fte_Count := v_Fte_Count + 1;
        
          c.New_Row;
          c.Data(Fte.Robot_Cnt);
          c.Data(Fte.Total_Fte);
          c.Data(Fte.Employed_Robot_Cnt);
          c.Data(Fte.Vocation_Cnt);
          c.Data(Fte.Planed_Fte);
          c.Data(Fte.Employed_Robot_Cnt * Fte.Planed_Fte);
          c.Data(Fte.Robot_Wage);
          c.Data(Fte.Robot_Wage * Fte.Robot_Cnt);
          c.Data(Fte.Robot_Wage * Fte.Planed_Fte);
          c.Data(Fte.Robot_Wage * Fte.Planed_Fte * Fte.Employed_Robot_Cnt);
        end loop;
      
        if v_Fte_Count > 0 then
          v_Div_Job_Count := v_Div_Job_Count + 1;
        
          b.New_Row;
          b.Data(Job.Job_Name);
          b.Data(c);
        end if;
      
      end loop;
    
      if v_Div_Job_Count > 0 then
        Body_Table.New_Row;
        Body_Table.Data(v_Order_No);
        v_Order_No := v_Order_No + 1;
        Body_Table.Data(r.Name);
        Body_Table.Data(b);
      
        v_Body_Row_Count := v_Body_Row_Count + 1;
      end if;
    end loop;
  
    if v_Body_Row_Count > 0 then
      a.New_Row;
      a.Data(Body_Table);
    end if;
  
    b_Report.Add_Sheet(i_Name => t('vacancy'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Job_Ids      Array_Number := Nvl(p.o_Array_Number('job_ids'), Array_Number());
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    Run_Staffing(i_Division_Ids => v_Division_Ids, i_Job_Ids => v_Job_Ids);
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr599;
/
