create or replace package Ui_Vhr500 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr500;
/
create or replace package body Ui_Vhr500 is
  ----------------------------------------------------------------------------------------------------
  c_No_Reason_Id constant number := -1;
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
    return b.Translate('UI-VHR500:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    Result.Put('data',
               Fazo.Zip_Map('begin_date',
                            Trunc(sysdate, 'year'),
                            'end_date',
                            Trunc(sysdate),
                            'employee_kind',
                            'A',
                            'reason_type',
                            'A'));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('employee_kinds',
               Fazo.Zip_Matrix(Matrix_Varchar2(Array_Varchar2(t('all'), 'A'),
                                               Array_Varchar2(t('key employee'), 'Y'),
                                               Array_Varchar2(t('not key employee'), 'N'))));
    Result.Put('reason_types',
               Fazo.Zip_Matrix(Matrix_Varchar2(Array_Varchar2(t('all'), 'A'),
                                               Array_Varchar2(Href_Util.t_Dismissal_Reasons_Type(Href_Pref.c_Dismissal_Reasons_Type_Positive),
                                                              Href_Pref.c_Dismissal_Reasons_Type_Positive),
                                               Array_Varchar2(Href_Util.t_Dismissal_Reasons_Type(Href_Pref.c_Dismissal_Reasons_Type_Negative),
                                                              Href_Pref.c_Dismissal_Reasons_Type_Negative))));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Print_Top
  (
    a               in out b_Table,
    i_Reason_Id     number := null,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Division_Ids  Array_Number,
    i_Job_Ids       Array_Number,
    i_Employee_Kind varchar2,
    i_Reason_Type   varchar2
  ) is
    v_Limit      number := 5;
    v_Colspan    number := 11;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Names      Array_Varchar2 := Array_Varchar2();
  begin
    a.Current_Style('root bold');
    a.New_Row;
  
    if i_Reason_Id is not null then
      a.New_Row;
    
      if i_Reason_Id = c_No_Reason_Id then
        a.Data(t('reason: $1{reason_name}', t('no reason')), i_Colspan => v_Colspan);
      else
        a.Data(t('reason: $1{reason_name}',
                 z_Href_Dismissal_Reasons.Load(i_Company_Id => v_Company_Id, i_Dismissal_Reason_Id => i_Reason_Id).Name),
               i_Colspan => v_Colspan);
      end if;
    end if;
  
    a.New_Row;
    a.Data(t('period: from $1{begin_date} to $2{end_date}', i_Begin_Date, i_End_Date),
           i_Colspan => v_Colspan);
  
    if i_Division_Ids.Count > 0 then
      a.New_Row;
    
      v_Limit := Least(v_Limit, i_Division_Ids.Count);
      v_Names.Extend(v_Limit);
    
      for i in 1 .. v_Limit
      loop
        v_Names(i) := z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => i_Division_Ids(i)).Name;
      end loop;
    
      if v_Limit < i_Division_Ids.Count then
        Fazo.Push(v_Names, t('... others'));
      end if;
    
      a.Data(t('divisions: $1{division_names}', Fazo.Gather(v_Names, ',')), i_Colspan => v_Colspan);
    end if;
  
    if i_Job_Ids.Count > 0 then
      a.New_Row;
      v_Limit := Least(5, i_Job_Ids.Count());
      v_Names := Array_Varchar2();
      v_Names.Extend(v_Limit);
    
      for i in 1 .. v_Limit
      loop
        v_Names(i) := z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Job_Id => i_Job_Ids(i)).Name;
      end loop;
    
      if v_Limit < i_Job_Ids.Count then
        Fazo.Push(v_Names, t('... others'));
      end if;
    
      a.Data(t('jobs: $1{job_names}', Fazo.Gather(v_Names, ',')), i_Colspan => v_Colspan);
    end if;
  
    if i_Employee_Kind <> 'A' then
      a.New_Row;
      a.Data(t('key employee: $1{is_key_employee_name}',
               Md_Util.Decode(i_Employee_Kind, 'Y', Ui.t_Yes, 'N', Ui.t_No)),
             i_Colspan => v_Colspan);
    end if;
  
    if i_Reason_Type <> 'A' then
      a.New_Row;
      a.Data(t('reason type: $1{reason_type}', Href_Util.t_Dismissal_Reasons_Type(i_Reason_Type)),
             i_Colspan => v_Colspan);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Reason_Type   varchar2,
    i_Employee_Kind varchar2,
    i_Division_Ids  Array_Number,
    i_Job_Ids       Array_Number,
    i_Begin_Date    date,
    i_End_Date      date
  ) is
    v_Division_Cnt         number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Job_Cnt              number := i_Job_Ids.Count;
    v_Total                number := 0;
    a                      b_Table := b_Report.New_Table();
    v_Params               Hashmap;
    v_Cache_Matrix         Matrix_Varchar2 := Matrix_Varchar2();
  
    -------------------------------------------------- 
    Procedure Cache_Reason_Type_Count is
    begin
      if v_Access_All_Employees = 'N' then
        v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                    i_Indirect => true,
                                                                    i_Manual   => true);
      
        if i_Division_Ids.Count > 0 then
          v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
        end if;
      end if;
    
      v_Division_Cnt := v_Filter_Division_Ids.Count;
    
      select Array_Varchar2((select r.Name
                              from Href_Dismissal_Reasons r
                             where r.Company_Id = i_Company_Id
                               and r.Dismissal_Reason_Id = q.Dismissal_Reason_Id), --
                            q.Cnt,
                            q.Dismissal_Reason_Id)
        bulk collect
        into v_Cache_Matrix
        from (select count(*) Cnt, w.Dismissal_Reason_Id
                from Hpd_Dismissal_Transactions t
                join Hpd_Dismissals w
                  on w.Company_Id = t.Company_Id
                 and w.Filial_Id = t.Filial_Id
                 and w.Page_Id = t.Page_Id
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and w.Dismissal_Date between i_Begin_Date and i_End_Date
                 and (i_Reason_Type = 'A' or --
                     i_Reason_Type =
                     (select Dr.Reason_Type
                         from Href_Dismissal_Reasons Dr
                        where Dr.Company_Id = w.Company_Id
                          and Dr.Dismissal_Reason_Id = w.Dismissal_Reason_Id))
                 and (i_Employee_Kind = 'A' or --
                     i_Employee_Kind =
                     (select Em.Key_Person
                         from Href_Person_Details Em
                        where Em.Company_Id = i_Company_Id
                          and Em.Person_Id = (select St.Employee_Id
                                                from Href_Staffs St
                                               where St.Company_Id = t.Company_Id
                                                 and St.Filial_Id = t.Filial_Id
                                                 and St.Staff_Id = t.Staff_Id)))
                 and (v_Access_All_Employees = 'Y' and v_Division_Cnt = 0 or --
                     Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => t.Company_Id,
                                                       i_Filial_Id  => t.Filial_Id,
                                                       i_Staff_Id   => t.Staff_Id,
                                                       i_Period     => w.Dismissal_Date) member of
                      v_Filter_Division_Ids)
                 and (v_Job_Cnt = 0 or --
                     Hpd_Util.Get_Closest_Job_Id(i_Company_Id => t.Company_Id,
                                                  i_Filial_Id  => t.Filial_Id,
                                                  i_Staff_Id   => t.Staff_Id,
                                                  i_Period     => w.Dismissal_Date) member of
                      i_Job_Ids)
               group by t.Company_Id, t.Filial_Id, w.Dismissal_Reason_Id
               order by Dismissal_Reason_Id, Cnt desc) q;
    
      for i in 1 .. v_Cache_Matrix.Count
      loop
        v_Total := v_Total + v_Cache_Matrix(i) (2);
      end loop;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Header is
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      a.Data(t('dismissal reason'));
      a.Column_Width(1, 250);
    
      a.Data(t('count'));
      a.Column_Width(2, 250);
    
      a.Data(t('%'));
      a.Column_Width(3, 250);
    end;
  begin
    -- info 
    Print_Top(a               => a,
              i_Begin_Date    => i_Begin_Date,
              i_End_Date      => i_End_Date,
              i_Division_Ids  => i_Division_Ids,
              i_Job_Ids       => i_Job_Ids,
              i_Employee_Kind => i_Employee_Kind,
              i_Reason_Type   => i_Reason_Type);
  
    -- header
    Print_Header;
  
    -- body
    a.Current_Style('body_centralized');
  
    Cache_Reason_Type_Count;
  
    for i in 1 .. v_Cache_Matrix.Count
    loop
      a.New_Row;
      if v_Cache_Matrix(i) (3) is null then
        a.Data(t('no reason'),
               'no_reason',
               i_Param => Fazo.Zip_Map('reason_id', c_No_Reason_Id).Json());
      else
        a.Data(v_Cache_Matrix(i) (1),
               i_Param => Fazo.Zip_Map('reason_id', v_Cache_Matrix(i)(3)).Json());
      end if;
    
      a.Data(v_Cache_Matrix(i) (2));
      a.Data(Round(v_Cache_Matrix(i) (2) / v_Total, 3) * 100);
    end loop;
  
    v_Params := Fazo.Zip_Map('begin_date',
                             i_Begin_Date,
                             'end_date',
                             i_End_Date,
                             'employee_kind',
                             i_Employee_Kind,
                             'reason_type',
                             i_Reason_Type);
  
    v_Params.Put('division_ids', i_Division_Ids);
    v_Params.Put('job_ids', i_Job_Ids);
  
    b_Report.Add_Sheet(i_Name => t('reason_detail'), p_Table => a, i_Param => v_Params.Json);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Reason
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Reason_Id     number,
    i_Employee_Kind varchar2,
    i_Reason_Type   varchar2,
    i_Division_Ids  Array_Number,
    i_Job_Ids       Array_Number,
    i_Begin_Date    date,
    i_End_Date      date
  ) is
    v_Division_Cnt         number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Job_Cnt              number := i_Job_Ids.Count;
    a                      b_Table := b_Report.New_Table();
  
    -------------------------------------------------- 
    Procedure Print_Header is
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      a.Data(t('employee name'));
      a.Column_Width(1, 250);
    
      a.Data(t('last division'));
      a.Column_Width(2, 250);
    
      a.Data(t('last job'));
      a.Column_Width(3, 250);
    
      a.Data(t('dismissal date'));
      a.Column_Width(4, 250);
    end;
  begin
    -- info 
    Print_Top(a               => a,
              i_Reason_Id     => i_Reason_Id,
              i_Begin_Date    => i_Begin_Date,
              i_End_Date      => i_End_Date,
              i_Division_Ids  => i_Division_Ids,
              i_Job_Ids       => i_Job_Ids,
              i_Employee_Kind => i_Employee_Kind,
              i_Reason_Type   => i_Reason_Type);
  
    -- header
    Print_Header;
  
    -- body
    a.Current_Style('body_centralized');
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Division_Cnt := v_Filter_Division_Ids.Count;
  
    for x in (select (select Mr.Name
                        from Mr_Natural_Persons Mr
                       where Mr.Company_Id = i_Company_Id
                         and Mr.Person_Id = St.Employee_Id) Person_Name,
                     (select d.Name
                        from Mhr_Divisions d
                       where d.Company_Id = i_Company_Id
                         and d.Filial_Id = i_Filial_Id
                         and d.Division_Id =
                             Hpd_Util.Get_Closest_Division_Id(i_Company_Id => q.Company_Id,
                                                              i_Filial_Id  => q.Filial_Id,
                                                              i_Staff_Id   => q.Staff_Id,
                                                              i_Period     => St.Dismissal_Date)) Division_Name,
                     (select j.Name
                        from Mhr_Jobs j
                       where j.Company_Id = i_Company_Id
                         and j.Filial_Id = i_Filial_Id
                         and j.Job_Id =
                             Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                                         i_Filial_Id  => q.Filial_Id,
                                                         i_Staff_Id   => q.Staff_Id,
                                                         i_Period     => St.Dismissal_Date)) Job_Name,
                     St.Dismissal_Date,
                     q.Journal_Id
                from Hpd_Dismissal_Transactions q
                join Hpd_Dismissals w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Page_Id = q.Page_Id
                join Href_Staffs St
                  on St.Company_Id = q.Company_Id
                 and St.Filial_Id = q.Filial_Id
                 and St.Staff_Id = q.Staff_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and (i_Reason_Id = c_No_Reason_Id and w.Dismissal_Reason_Id is null or
                     w.Dismissal_Reason_Id = i_Reason_Id)
                 and St.Dismissal_Date between i_Begin_Date and i_End_Date
                 and (i_Employee_Kind = 'A' or
                     i_Employee_Kind = (select Pd.Key_Person
                                           from Href_Person_Details Pd
                                          where Pd.Company_Id = St.Company_Id
                                            and Pd.Person_Id = St.Employee_Id))
                 and (v_Access_All_Employees = 'Y' and v_Division_Cnt = 0 or --
                     Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => q.Company_Id,
                                                       i_Filial_Id  => q.Filial_Id,
                                                       i_Staff_Id   => q.Staff_Id,
                                                       i_Period     => St.Dismissal_Date) member of
                      v_Filter_Division_Ids)
                 and (v_Job_Cnt = 0 or --
                     Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                                  i_Filial_Id  => q.Filial_Id,
                                                  i_Staff_Id   => q.Staff_Id,
                                                  i_Period     => St.Dismissal_Date) member of
                      i_Job_Ids))
    loop
      a.New_Row;
      a.Data(x.Person_Name, i_Param => Fazo.Zip_Map('journal_id', x.Journal_Id).Json());
      a.Data(x.Division_Name);
      a.Data(x.Job_Name);
      a.Data(x.Dismissal_Date);
    end loop;
  
    b_Report.Add_Sheet(i_Name => t('reason_detail'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Reason_Id   number := p.o_Number('reason_id');
    v_Reason_Name varchar2(100);
    v_Param       Hashmap;
  begin
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
    
      if v_Param.Has('reason_id') then
        v_Param := Fazo.Zip_Map('reason_id', v_Param.r_Number('reason_id'));
        v_Param.Put_All(Fazo.Parse_Map(p.r_Varchar2('table_param')));
        b_Report.Redirect_To_Report('/vhr/rep/hpd/dismissal_reason:run', v_Param);
      elsif Md_Util.Grant_Has(i_Company_Id   => v_Company_Id,
                              i_Project_Code => Verifix.Project_Code,
                              i_Filial_Id    => v_Filial_Id,
                              i_User_Id      => Ui.User_Id,
                              i_Form         => '/vhr/hpd/view/dismissal_view',
                              i_Action_Key   => '*') then
        b_Report.Redirect_To_Form('/vhr/hpd/view/dismissal_view',
                                  v_Param,
                                  i_Filial_Id => v_Filial_Id);
      end if;
    else
      if v_Reason_Id is not null then
        if v_Reason_Id = c_No_Reason_Id then
          v_Reason_Name := ' (' || t('no reason') || ')';
        else
          v_Reason_Name := ' (' || z_Href_Dismissal_Reasons.Load(i_Company_Id => v_Company_Id, i_Dismissal_Reason_Id => v_Reason_Id).Name || ')';
        end if;
      end if;
    
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => Ui.Current_Form_Name || v_Reason_Name);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
      -- no reason
      b_Report.New_Style(i_Style_Name        => 'no_reason',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#decefe');
    
      if v_Reason_Id is not null then
        Run_Reason(i_Company_Id    => v_Company_Id,
                   i_Filial_Id     => v_Filial_Id,
                   i_Reason_Id     => v_Reason_Id,
                   i_Employee_Kind => p.o_Varchar2('employee_kind'),
                   i_Reason_Type   => p.o_Varchar2('reason_type'),
                   i_Division_Ids  => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                   i_Job_Ids       => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
                   i_Begin_Date    => p.r_Date('begin_date'),
                   i_End_Date      => p.r_Date('end_date'));
      else
        Run_All(i_Company_Id    => v_Company_Id,
                i_Filial_Id     => v_Filial_Id,
                i_Employee_Kind => p.o_Varchar2('employee_kind'),
                i_Reason_Type   => p.o_Varchar2('reason_type'),
                i_Division_Ids  => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                i_Job_Ids       => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
                i_Begin_Date    => p.r_Date('begin_date'),
                i_End_Date      => p.r_Date('end_date'));
      end if;
    
      b_Report.Close_Book();
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr500;
/
