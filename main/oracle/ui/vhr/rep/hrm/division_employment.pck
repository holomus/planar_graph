create or replace package Ui_Vhr579 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Divisions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr579;
/
create or replace package body Ui_Vhr579 is
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
    return b.Translate('UI-VHR579:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  -- returns only divisions with division groups
  -- division with division group is qualified as department
  -- access filter is still applied
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Divisions return Fazo_Query is
    v_Query varchar2(4000);
    v_Param Hashmap;
    q       Fazo_Query;
  begin
    v_Query := 'select q.*
                  from mhr_divisions q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = :state
                   and q.division_group_id is not null';
  
    v_Param := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id, 'state', 'A');
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and q.division_id member of :division_ids ';
    
      v_Param.Put('division_ids',
                  Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                     i_Indirect => true,
                                                     i_Manual   => true));
    end if;
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('division_id', 'division_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('period', Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cached_Division_Job_Counts
  (
    o_Counts_Cache out nocopy Fazo.Number_Code_Aat,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Period       date,
    i_Division_Ids Array_Number
  ) is
    v_Divisions_Cnt number := i_Division_Ids.Count;
  begin
    if v_Divisions_Cnt = 0 then
      return;
    end if;
  
    for r in (select Dv.Division_Id, p.Job_Id, count(1) Cnt
                from Hpd_Agreements_Cache q
                join Mrf_Robots p
                  on p.Company_Id = q.Company_Id
                 and p.Filial_Id = q.Filial_Id
                 and p.Robot_Id = q.Robot_Id
                left join Mhr_Parent_Divisions Pd
                  on Pd.Company_Id = p.Company_Id
                 and Pd.Filial_Id = p.Filial_Id
                 and Pd.Division_Id = p.Division_Id
                 and Pd.Lvl = (select min(Sd.Lvl)
                                 from Mhr_Parent_Divisions Sd
                                where Sd.Company_Id = p.Company_Id
                                  and Sd.Filial_Id = p.Filial_Id
                                  and Sd.Division_Id = p.Division_Id
                                  and Sd.Division_Id not member of i_Division_Ids
                                  and Sd.Parent_Id member of i_Division_Ids)
                join Mhr_Divisions Dv
                  on Dv.Company_Id = p.Company_Id
                 and Dv.Filial_Id = p.Filial_Id
                 and Dv.Division_Id = Nvl(Pd.Parent_Id, p.Division_Id)
                 and Dv.Division_Id member of i_Division_Ids
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and i_Period between q.Begin_Date and q.End_Date
               group by cube(Dv.Division_Id, p.Job_Id))
    loop
      o_Counts_Cache(r.Division_Id || ':' || r.Job_Id) := r.Cnt;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employment_Count
  (
    i_Counts_Cache in out nocopy Fazo.Number_Code_Aat,
    i_Division_Id  number,
    i_Job_Id       number
  ) return number is
  begin
    return i_Counts_Cache(i_Division_Id || ':' || i_Job_Id);
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Print_Info
  (
    a                    in out nocopy b_Table,
    i_Period             date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number
  ) is
    v_Divisions_Cnt       number := i_Division_Ids.Count;
    v_Division_Groups_Cnt number := i_Division_Group_Ids.Count;
    v_Default_Limit       number := 5;
    v_Limit               number;
    v_Colspan             number := 11;
    v_Nls_Language        varchar2(100) := Uit_Href.Get_Nls_Language;
    t_Other               varchar2(20) := t('...others');
    v_Names               Array_Varchar2 := Array_Varchar2();
  begin
    a.Current_Style('root bold');
    a.New_Row;
    a.New_Row;
  
    a.Data(t('date: $1', to_char(i_Period, 'dd mon yyyy', v_Nls_Language)), i_Colspan => 5);
  
    if v_Division_Groups_Cnt > 0 then
      a.New_Row;
    
      v_Limit := Least(v_Default_Limit, v_Division_Groups_Cnt);
      v_Names := Array_Varchar2();
    
      for i in 1 .. v_Limit
      loop
        Fazo.Push(v_Names,
                  z_Mhr_Division_Groups.Load(i_Company_Id => Ui.Company_Id, --
                  i_Division_Group_Id => i_Division_Group_Ids(i)).Name);
      end loop;
    
      if v_Division_Groups_Cnt > v_Limit then
        Fazo.Push(v_Names, t_Other);
      end if;
    
      a.Data(t('division groups: $1{division_group_names}', Fazo.Gather(v_Names, ',')),
             i_Colspan => v_Colspan);
    end if;
  
    if v_Divisions_Cnt > 0 then
      a.New_Row;
    
      v_Limit := Least(v_Default_Limit, v_Divisions_Cnt);
      v_Names := Array_Varchar2();
    
      for i in 1 .. v_Limit
      loop
        Fazo.Push(v_Names,
                  z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, --
                  i_Filial_Id => Ui.Filial_Id, --
                  i_Division_Id => i_Division_Ids(i)).Name);
      end loop;
    
      if v_Divisions_Cnt > v_Limit then
        Fazo.Push(v_Names, t_Other);
      end if;
    
      a.Data(t('divisions: $1{division_names}', Fazo.Gather(v_Names, ',')), i_Colspan => v_Colspan);
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Print_Header
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number
  ) is
    v_Column   number := 1;
    r_Division Mhr_Divisions%rowtype;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number,
      i_Style_Name   varchar2 := null
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan, i_Style_Name => i_Style_Name);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
  begin
    a.Current_Style('header');
    a.New_Row;
    a.New_Row(200);
    Print_Header(t('jobs'), 1, 1, 100);
  
    for i in 1 .. i_Division_Ids.Count
    loop
      r_Division := z_Mhr_Divisions.Load(i_Company_Id  => Ui.Company_Id,
                                         i_Filial_Id   => Ui.Filial_Id,
                                         i_Division_Id => i_Division_Ids(i));
    
      Print_Header(r_Division.Name, 1, 1, 25, 'header rotate');
    end loop;
  
    Print_Header(t('totals'), 1, 1, 100);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Body
  (
    a              in out nocopy b_Table,
    p_Counts_Cache in out nocopy Fazo.Number_Code_Aat,
    i_Division_Ids Array_Number
  ) is
  
    --------------------------------------------------
    Procedure Print_Divisions(i_Job_Id number) is
    begin
      for i in 1 .. i_Division_Ids.Count
      loop
        if i_Job_Id is not null then
          a.Data(Get_Employment_Count(i_Counts_Cache => p_Counts_Cache,
                                      i_Division_Id  => i_Division_Ids(i),
                                      i_Job_Id       => i_Job_Id));
        else
          a.Add_Data(1);
        end if;
      end loop;
    
      if i_Job_Id is not null then
        a.Data(Get_Employment_Count(i_Counts_Cache => p_Counts_Cache,
                                    i_Division_Id  => null,
                                    i_Job_Id       => i_Job_Id));
      else
        a.Add_Data(1);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Print_Job_Group(i_Job_Group_Id number) is
    begin
      if i_Job_Group_Id is null then
        return;
      end if;
    
      a.New_Row;
      a.Data(z_Mhr_Job_Groups.Load(i_Company_Id => Ui.Company_Id, i_Job_Group_Id => i_Job_Group_Id).Name,
             'body_centralized bold italic underline');
      Print_Divisions(null);
    end;
  
  begin
    a.Current_Style('body_centralized');
  
    for r in (select q.*
                from Mhr_Jobs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A'
               order by q.Job_Group_Id nulls first)
    loop
      Print_Job_Group(r.Job_Group_Id);
      a.New_Row;
      a.Data(r.Name);
      Print_Divisions(r.Job_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Footer
  (
    a              in out nocopy b_Table,
    p_Counts_Cache in out nocopy Fazo.Number_Code_Aat,
    i_Division_Ids Array_Number
  ) is
  begin
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('totals'), 'footer center');
  
    for i in 1 .. i_Division_Ids.Count
    loop
      a.Data(Get_Employment_Count(i_Counts_Cache => p_Counts_Cache,
                                  i_Division_Id  => i_Division_Ids(i),
                                  i_Job_Id       => null));
    end loop;
  
    a.Data(Get_Employment_Count(i_Counts_Cache => p_Counts_Cache,
                                i_Division_Id  => null,
                                i_Job_Id       => null));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run_Report
  (
    i_Period             date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number
  ) is
    a              b_Table := b_Report.New_Table();
    v_Counts_Cache Fazo.Number_Code_Aat;
  
    v_Division_Groups_Cnt  number := i_Division_Group_Ids.Count;
    v_Filter_Divisions_Cnt number;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
  
    v_Division_Ids Array_Number := Array_Number();
  begin
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                                  i_Indirect         => true,
                                                                  i_Manual           => true,
                                                                  i_Only_Departments => 'Y');
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Filter_Divisions_Cnt := v_Filter_Division_Ids.Count;
  
    select q.Division_Id
      bulk collect
      into v_Division_Ids
      from Mhr_Divisions q
      join Hrm_Divisions Dv
        on Dv.Company_Id = q.Company_Id
       and Dv.Filial_Id = q.Filial_Id
       and Dv.Division_Id = q.Division_Id
       and Dv.Is_Department = 'Y'
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and (v_Access_All_Employees = 'Y' and v_Filter_Divisions_Cnt = 0 or -- 
           q.Division_Id member of v_Filter_Division_Ids)
       and (v_Division_Groups_Cnt = 0 or q.Division_Group_Id member of i_Division_Group_Ids)
       and q.Division_Group_Id is not null
       and q.State = 'A';
  
    Cached_Division_Job_Counts(o_Counts_Cache => v_Counts_Cache,
                               i_Company_Id   => Ui.Company_Id,
                               i_Filial_Id    => Ui.Filial_Id,
                               i_Period       => i_Period,
                               i_Division_Ids => v_Division_Ids);
  
    Print_Info(a                    => a,
               i_Period             => i_Period,
               i_Division_Group_Ids => i_Division_Group_Ids,
               i_Division_Ids       => i_Division_Ids);
    Print_Header(a              => a, --
                 i_Division_Ids => v_Division_Ids);
    Print_Body(a              => a, --
               p_Counts_Cache => v_Counts_Cache,
               i_Division_Ids => v_Division_Ids);
    Print_Footer(a              => a, --
                 p_Counts_Cache => v_Counts_Cache,
                 i_Division_Ids => v_Division_Ids);
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    b_Report.New_Style(i_Style_Name       => 'rotate',
                       i_Text_Rotate      => -90,
                       i_Horizontal_Align => b_Report.a_Left,
                       i_Vertical_Align   => b_Report.a_Middle);
  
    Run_Report(i_Period             => Nvl(p.o_Date('period'), Trunc(sysdate)),
               i_Division_Group_Ids => Nvl(p.o_Array_Number('division_group_ids'), Array_Number()),
               i_Division_Ids       => Nvl(p.o_Array_Number('division_ids'), Array_Number()));
  
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
  
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Parent_Id   = null,
           State       = null;
  end;

end Ui_Vhr579;
/
