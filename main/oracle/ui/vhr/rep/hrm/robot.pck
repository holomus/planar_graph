create or replace package Ui_Vhr260 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr260;
/
create or replace package body Ui_Vhr260 is
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
    return b.Translate('UI-VHR260:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('date', Trunc(sysdate));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Job_Count
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Date        date
  ) return number is
    result number;
  begin
    select count(distinct(q.Job_Id))
      into result
      from Mrf_Robots q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Division_Id = i_Division_Id
       and exists (select 1
              from Hrm_Robots r
             where r.Company_Id = q.Company_Id
               and r.Filial_Id = q.Filial_Id
               and r.Robot_Id = q.Robot_Id
               and r.Opened_Date <= i_Date
               and (r.Closed_Date is null or r.Closed_Date >= i_Date));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run_All
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Date        date,
    i_Division_Id number := null
  ) is
    a                      b_Table := b_Report.New_Table();
    v_Column               number := 1;
    v_Planned              number := 0;
    v_Booked               number := 0;
    v_Occupied             number := 0;
    v_Fte                  number := 0;
    v_Job_Count            number;
    v_Dummy                number;
    v_Division_Name        Mhr_Divisions.Name%type;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Division_Ids         Array_Number;
    v_Parent_Id            number;
    v_Nls_Language         varchar2(100) := Uit_Href.Get_Nls_Language;
  
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
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
    --------------------------------------------------
    Procedure Get_Ftes
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Division_Id number,
      i_Date        date,
      o_Planned     out number,
      o_Booked      out number,
      o_Occupied    out number,
      o_Fte         out number
    ) is
    begin
      select sum(r.Planed_Fte), sum(r.Booked_Fte), sum(r.Occupied_Fte), sum(r.Fte)
        into o_Planned, o_Booked, o_Occupied, o_Fte
        from Mhr_Divisions q
        join Mrf_Robots w
          on w.Company_Id = q.Company_Id
         and w.Filial_Id = q.Filial_Id
         and w.Division_Id = q.Division_Id
         and exists (select 1
                from Hrm_Robots r
               where r.Company_Id = w.Company_Id
                 and r.Filial_Id = w.Filial_Id
                 and r.Robot_Id = w.Robot_Id
                 and r.Opened_Date <= i_Date
                 and (r.Closed_Date is null or r.Closed_Date >= i_Date))
        join Hrm_Robot_Turnover r
          on r.Company_Id = w.Company_Id
         and r.Filial_Id = w.Filial_Id
         and r.Robot_Id = w.Robot_Id
         and r.Period = (select max(x.Period)
                           from Hrm_Robot_Turnover x
                          where x.Company_Id = w.Company_Id
                            and x.Filial_Id = w.Filial_Id
                            and x.Robot_Id = w.Robot_Id
                            and x.Period <= i_Date)
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and (q.Division_Id = i_Division_Id or exists
              (select 1
                 from Mhr_Parent_Divisions Pr
                where Pr.Company_Id = q.Company_Id
                  and Pr.Filial_Id = q.Filial_Id
                  and Pr.Parent_Id = i_Division_Id
                  and Pr.Division_Id = q.Division_Id));
    end;
    --------------------------------------------------     
    Procedure Print_Jobs
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Division_Id number,
      i_Date        date
    ) is
    begin
      v_Dummy := 0;
      for Rt in (select (select y.Name
                           from Mhr_Jobs y
                          where y.Company_Id = i_Company_Id
                            and y.Filial_Id = i_Filial_Id
                            and y.Job_Id = q.Job_Id) as Job_Name,
                        sum(r.Planed_Fte) as Planned,
                        sum(r.Booked_Fte) as Booked,
                        sum(r.Occupied_Fte) as Occupied,
                        sum(r.Fte) as Fte
                   from Mrf_Robots q
                   join Hrm_Robot_Turnover r
                     on r.Company_Id = q.Company_Id
                    and r.Filial_Id = q.Filial_Id
                    and r.Robot_Id = q.Robot_Id
                    and r.Period = (select max(x.Period)
                                      from Hrm_Robot_Turnover x
                                     where x.Company_Id = q.Company_Id
                                       and x.Filial_Id = q.Filial_Id
                                       and x.Robot_Id = q.Robot_Id
                                       and x.Period <= i_Date)
                  where q.Company_Id = i_Company_Id
                    and q.Filial_Id = i_Filial_Id
                    and q.Division_Id = i_Division_Id
                    and exists
                  (select 1
                           from Hrm_Robots r
                          where r.Company_Id = q.Company_Id
                            and r.Filial_Id = q.Filial_Id
                            and r.Robot_Id = q.Robot_Id
                            and r.Opened_Date <= i_Date
                            and (r.Closed_Date is null or r.Closed_Date >= i_Date))
                  group by q.Job_Id
                  order by 1)
      loop
        a.Data(Rt.Job_Name);
        a.Data(Rt.Planned);
        a.Data(Rt.Booked);
        a.Data(Rt.Occupied);
        a.Data(Rt.Fte);
      
        v_Dummy := v_Dummy + 1;
      
        if v_Dummy <> v_Job_Count then
          a.New_Row;
        end if;
        v_Planned  := v_Planned + Rt.Planned;
        v_Booked   := v_Booked + Rt.Booked;
        v_Occupied := v_Occupied + Rt.Occupied;
        v_Fte      := v_Fte + Rt.Fte;
      end loop;
    end;
    -------------------------------------------------- 
    Procedure Print_Divisions
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Division_Id number,
      i_Date        date
    ) is
      v_Style_Name   varchar2(50);
      v_Div_Name     Mhr_Divisions.Name%type;
      v_Div_Planned  number;
      v_Div_Booked   number;
      v_Div_Occupied number;
      v_Div_Fte      number;
      v_Level        number;
    begin
      Get_Ftes(i_Company_Id  => i_Company_Id,
               i_Filial_Id   => i_Filial_Id,
               i_Division_Id => i_Division_Id,
               i_Date        => i_Date,
               o_Planned     => v_Div_Planned,
               o_Booked      => v_Div_Booked,
               o_Occupied    => v_Div_Occupied,
               o_Fte         => v_Div_Fte);
    
      if v_Div_Planned is null then
        return;
      end if;
    
      v_Div_Name := z_Mhr_Divisions.Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => i_Division_Id).Name;
    
      v_Level := z_Mhr_Parent_Divisions.Take(i_Company_Id => i_Company_Id, --
                 i_Filial_Id => i_Filial_Id, --
                 i_Division_Id => i_Division_Id, --
                 i_Parent_Id => v_Parent_Id).Lvl;
    
      case v_Level
        when 1 then
          v_Style_Name := 'second_level';
        when 2 then
          v_Style_Name := 'third_level';
        when 3 then
          v_Style_Name := 'fourth_level';
        else
          v_Style_Name := 'first_level';
      end case;
    
      v_Job_Count := Get_Job_Count(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Division_Id => i_Division_Id,
                                   i_Date        => i_Date);
    
      a.New_Row;
      a.Data(i_Val => v_Div_Name, i_Style_Name => v_Style_Name, i_Rowspan => 1 + v_Job_Count);
      a.Data('', v_Style_Name);
      a.Data(v_Div_Planned, v_Style_Name);
      a.Data(v_Div_Booked, v_Style_Name);
      a.Data(v_Div_Occupied, v_Style_Name);
      a.Data(v_Div_Fte, v_Style_Name);
    
      a.New_Row;
      Print_Jobs(i_Company_Id  => i_Company_Id,
                 i_Filial_Id   => i_Filial_Id,
                 i_Division_Id => i_Division_Id,
                 i_Date        => i_Date);
    end;
  begin
    a.Current_Style('root bold');
    a.New_Row;
  
    if i_Division_Id is not null then
      a.New_Row;
      select d.Name
        into v_Division_Name
        from Mhr_Divisions d
       where d.Company_Id = i_Company_Id
         and d.Filial_Id = i_Filial_Id
         and d.Division_Id = i_Division_Id;
    
      a.Data(t('division: $1', v_Division_Name), i_Colspan => 5);
    end if;
  
    --info  
    a.New_Row;
    a.Data(t('date: $1', to_char(i_Date, 'dd mon yyyy', v_Nls_Language)), i_Colspan => 5);
  
    -- header
    a.Current_Style('header');
  
    a.New_Row;
    a.New_Row;
    Print_Header(t('division name'), 1, 1, 200);
    Print_Header(t('job name'), 1, 1, 200);
    Print_Header(t('planned'), 1, 1, 75);
    Print_Header(t('booked'), 1, 1, 75);
    Print_Header(t('occupied'), 1, 1, 75);
    Print_Header(t('free'), 1, 1, 75);
  
    -- body
    a.Current_Style('body_centralized');
  
    if i_Division_Id is null then
      if v_Access_All_Employees = 'N' then
        v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                             i_Indirect         => true,
                                                             i_Manual           => true,
                                                             i_Only_Departments => 'Y');
      end if;
    
      for Pr in (select q.Division_Id, q.Parent_Id
                   from (select p.Division_Id,
                                case
                                   when v_Access_All_Employees = 'Y' or
                                        Dv.Parent_Department_Id in
                                        (select Column_Value
                                           from table(v_Division_Ids)) then
                                    Dv.Parent_Department_Id
                                   else
                                    null
                                 end Parent_Id
                           from Mhr_Divisions p
                           join Hrm_Divisions Dv
                             on Dv.Company_Id = p.Company_Id
                            and Dv.Filial_Id = p.Filial_Id
                            and Dv.Division_Id = p.Division_Id
                            and Dv.Is_Department = 'Y'
                          where p.Company_Id = i_Company_Id
                            and p.Filial_Id = i_Filial_Id
                            and (v_Access_All_Employees = 'Y' or --
                                p.Division_Id in (select Column_Value
                                                     from table(v_Division_Ids)))
                            and exists
                          (select 1
                                   from Mrf_Robots Mr
                                  where Mr.Company_Id = p.Company_Id
                                    and Mr.Filial_Id = p.Filial_Id
                                    and Mr.Division_Id = p.Division_Id
                                    and exists
                                  (select 1
                                           from Hrm_Robots r
                                          where r.Company_Id = Mr.Company_Id
                                            and r.Filial_Id = Mr.Filial_Id
                                            and r.Robot_Id = Mr.Robot_Id
                                            and r.Opened_Date <= i_Date
                                            and (r.Closed_Date is null or r.Closed_Date >= i_Date)))) q
                  start with q.Parent_Id is null
                 connect by prior q.Division_Id = q.Parent_Id)
      loop
        if Pr.Parent_Id is null then
          v_Parent_Id := Pr.Division_Id;
        end if;
        Print_Divisions(i_Company_Id  => i_Company_Id,
                        i_Filial_Id   => i_Filial_Id,
                        i_Division_Id => Pr.Division_Id,
                        i_Date        => i_Date);
      end loop;
    else
      v_Parent_Id := i_Division_Id;
      for Pr in (select r.*
                   from (select p.Division_Id
                           from Mhr_Divisions p
                          where p.Company_Id = i_Company_Id
                            and p.Filial_Id = i_Filial_Id
                            and p.Division_Id = i_Division_Id
                         union
                         select q.Division_Id
                           from Mhr_Parent_Divisions q
                          where q.Company_Id = i_Company_Id
                            and q.Filial_Id = i_Filial_Id
                            and q.Parent_Id = i_Division_Id) r
                   join Hrm_Divisions Dv
                     on Dv.Company_Id = i_Company_Id
                    and Dv.Filial_Id = i_Filial_Id
                    and Dv.Division_Id = r.Division_Id
                    and Dv.Is_Department = 'Y'
                  where exists
                  (select 1
                           from Mrf_Robots Mr
                          where Mr.Company_Id = i_Company_Id
                            and Mr.Filial_Id = i_Filial_Id
                            and Mr.Division_Id = r.Division_Id
                            and exists
                          (select 1
                                   from Hrm_Robots r
                                  where r.Company_Id = Mr.Company_Id
                                    and r.Filial_Id = Mr.Filial_Id
                                    and r.Robot_Id = Mr.Robot_Id
                                    and r.Opened_Date <= i_Date
                                    and (r.Closed_Date is null or r.Closed_Date >= i_Date)))
                  order by 1)
      
      loop
        Print_Divisions(i_Company_Id  => i_Company_Id,
                        i_Filial_Id   => i_Filial_Id,
                        i_Division_Id => Pr.Division_Id,
                        i_Date        => i_Date);
      end loop;
    end if;
  
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('total'), 'footer center', 2);
    a.Data(v_Planned);
    a.Data(v_Booked);
    a.Data(v_Occupied);
    a.Data(v_Fte);
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Division_Id   number := p.o_Number('division_id');
    v_Division_Name Mhr_Divisions.Name%type;
  begin
    if v_Division_Id is not null then
      v_Division_Name := ' (' || z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, --
                         i_Filial_Id => Ui.Filial_Id, --
                         i_Division_Id => v_Division_Id).Name || ') ';
    end if;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name || v_Division_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    -- first level
    b_Report.New_Style(i_Style_Name        => 'first_level',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#c6efce',
                       i_Font_Color        => '#006100');
  
    -- second level
    b_Report.New_Style(i_Style_Name        => 'second_level',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#b4c6e7',
                       i_Font_Color        => '#006100');
  
    -- third level
    b_Report.New_Style(i_Style_Name        => 'third_level',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#ffe699',
                       i_Font_Color        => '#006100');
  
    -- fourth level
    b_Report.New_Style(i_Style_Name        => 'fourth_level',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#f8cbad',
                       i_Font_Color        => '#006100');
  
    Run_All(i_Company_Id  => v_Company_Id,
            i_Filial_Id   => v_Filial_Id,
            i_Date        => Nvl(p.o_Date('date'), Trunc(sysdate)),
            i_Division_Id => p.o_Number('division_id'));
  
    b_Report.Close_Book();
  end;

end Ui_Vhr260;
/
