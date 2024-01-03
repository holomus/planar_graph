create or replace package Ui_Vhr557 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr557;
/
create or replace package body Ui_Vhr557 is
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
    return b.Translate('UI-VHR557:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(32767);
    v_Param  Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select *
                  from href_staffs w
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.hiring_date <= sysdate
                   and (w.dismissal_date is null or w.dismissal_date >= trunc(sysdate))
                   and w.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = w.filial_id
                           and e.employee_id = w.employee_id
                           and e.state = ''A'')';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('employee_id', 'staff_id', 'division_id');
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
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Info
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number
  ) is
    v_Division_Names varchar2(2000 char);
  begin
    select Listagg(t.Name, ', ' on Overflow Truncate) Within group(order by t.Name)
      into v_Division_Names
      from Mhr_Divisions t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Division_Id member of i_Division_Ids;
  
    a.New_Row;
    a.New_Row;
    a.Data(t('divisions: $1', v_Division_Names), 'root bold', i_Colspan => 2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Header(a in out nocopy b_Table) is
    c b_Table := b_Report.New_Table();
  begin
    c.Column_Width(1, 200);
    c.Column_Width(2, 150);
    c.Column_Width(3, 100);
    c.Column_Width(4, 100);
    c.Column_Width(5, 150);
    c.Column_Width(6, 100);
  
    c.Current_Style('header');
  
    c.New_Row;
    c.Data(t('division'));
    c.Data(t('job'));
    c.Data(t('robot'));
    c.Data(t('date'));
    c.Data(t('source document'));
    c.Data(t('rank'));
  
    a.Current_Style('header');
  
    a.New_Row;
    a.New_Row;
    a.Data(t('employee'));
    a.Data(c);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Body(i_Main_t in out nocopy b_Table) is
    r_Robot                             Mrf_Robots%rowtype;
    v_Staff_Robots_t                    b_Table;
    v_Rank_Changes_t                    b_Table;
    v_Prev_Robot_Id                     number;
    v_Documents                         Fazo.Varchar2_Code_Aat;
    v_Prev_Change_Is_Temporary_Transfer boolean := false;
    c_Temporary_Transfer constant varchar(30 char) := 'TEMPORARY TRANSFER';
  
    -------------------------------------------------- 
    Procedure Print_Robot_Data(i_Robot_Id number) is
      r_Robot Mrf_Robots%rowtype := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id,
                                                      i_Filial_Id  => Ui.Filial_Id,
                                                      i_Robot_Id   => i_Robot_Id);
    begin
      v_Staff_Robots_t.New_Row;
      v_Staff_Robots_t.Current_Style('body middle');
      v_Staff_Robots_t.Data(z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Robot.Division_Id).Name);
      v_Staff_Robots_t.Data(z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => r_Robot.Job_Id).Name);
      v_Staff_Robots_t.Data(r_Robot.Name);
    end;
  begin
    v_Documents(Zt.Hpd_Hirings.Name) := t('hiring');
    v_Documents(Zt.Hpd_Transfers.Name) := t('transfer');
    v_Documents(Zt.Hpd_Rank_Changes.Name) := t('rank change');
    v_Documents(Zt.Htm_Recommended_Rank_Documents.Name) := t('recommended rank document');
    v_Documents(c_Temporary_Transfer) := t('temporary transfer');
  
    i_Main_t.Current_Style('body center');
  
    for Rs in (select t.Staff_Id, t.Employee_Name
                 from Ui_Vhr557_Rank_Changes t
                group by t.Staff_Id, t.Employee_Name
                order by t.Employee_Name)
    loop
      i_Main_t.New_Row;
      i_Main_t.Data(Rs.Employee_Name, 'body middle');
    
      v_Prev_Robot_Id  := null;
      v_Staff_Robots_t := b_Report.New_Table();
      v_Rank_Changes_t := b_Report.New_Table();
    
      for Rr in (select t.*
                   from Ui_Vhr557_Rank_Changes t
                  where t.Staff_Id = Rs.Staff_Id
                  order by t.Change_Date)
      loop
        if v_Prev_Robot_Id is null then
          -- first row
          Print_Robot_Data(Rr.Robot_Id);
          v_Rank_Changes_t := b_Report.New_Table();
        elsif Rr.Robot_Id <> v_Prev_Robot_Id then
          v_Staff_Robots_t.Data(v_Rank_Changes_t);
        
          Print_Robot_Data(Rr.Robot_Id);
          v_Rank_Changes_t := b_Report.New_Table();
        end if;
      
        v_Rank_Changes_t.New_Row;
        v_Rank_Changes_t.Data(Rr.Change_Date, 'body center');
      
        if Rr.Transfer_End_Date is not null then
          Rr.Source_Document_Name             := c_Temporary_Transfer;
          v_Prev_Change_Is_Temporary_Transfer := true;
        elsif v_Prev_Change_Is_Temporary_Transfer then
          Rr.Source_Document_Name             := c_Temporary_Transfer;
          v_Prev_Change_Is_Temporary_Transfer := false;
        end if;
      
        v_Rank_Changes_t.Data(v_Documents(Rr.Source_Document_Name), 'body center');
        v_Rank_Changes_t.Data(Rr.Rank_Name, 'body center');
      
        v_Prev_Robot_Id := Rr.Robot_Id;
      end loop;
    
      v_Staff_Robots_t.Data(v_Rank_Changes_t);
      i_Main_t.Data(v_Staff_Robots_t);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Fill_Data(i_Staff_Ids Array_Number) is
  begin
    insert into Ui_Vhr557_Rank_Changes
      (Staff_Id,
       Robot_Id,
       Change_Date,
       Transfer_End_Date,
       Source_Document_Name,
       Employee_Name,
       Rank_Name)
      select k.Staff_Id,
             Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => k.Company_Id,
                                           i_Filial_Id  => k.Filial_Id,
                                           i_Staff_Id   => k.Staff_Id,
                                           i_Period     => k.Begin_Date) Robot_Id,
             Ag.Period,
             k.End_Date, -- can have value when transaction's tag is HPD_TRANSFERS
             Nvl2((select 'Y' -- recommended rank document
                    from Dual
                   where exists (select 1
                            from Htm_Recommended_Rank_Documents q
                            join Hpd_Journals m
                              on m.Company_Id = q.Company_Id
                             and m.Filial_Id = q.Filial_Id
                             and m.Journal_Id = q.Journal_Id
                           where q.Company_Id = k.Company_Id
                             and q.Filial_Id = k.Filial_Id
                             and q.Journal_Id = k.Journal_Id)),
                  Zt.Htm_Recommended_Rank_Documents.Name,
                  k.Tag) Source_Document_Name,
             (select (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = k.Company_Id
                         and Np.Person_Id = St.Employee_Id)
                from Href_Staffs St
               where St.Company_Id = k.Company_Id
                 and St.Filial_Id = k.Filial_Id
                 and St.Staff_Id = k.Staff_Id) Employee_Name,
             (select (select Rn.Name
                        from Mhr_Ranks Rn
                       where Rn.Company_Id = t.Company_Id
                         and Rn.Filial_Id = t.Filial_Id
                         and Rn.Rank_Id = t.Rank_Id)
                from Hpd_Trans_Ranks t
               where k.Company_Id = t.Company_Id
                 and k.Filial_Id = t.Filial_Id
                 and k.Trans_Id = t.Trans_Id) Rank_Name
        from Hpd_Agreements Ag
        join Hpd_Transactions k
          on k.Company_Id = Ag.Company_Id
         and k.Filial_Id = Ag.Filial_Id
         and k.Trans_Id = Ag.Trans_Id
       where Ag.Company_Id = Ui.Company_Id
         and Ag.Filial_Id = Ui.Filial_Id
         and Ag.Staff_Id member of i_Staff_Ids
         and Ag.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    a              b_Table;
    v_Division_Ids Array_Number := p.o_Array_Number('division_ids');
    v_Staff_Ids    Array_Number := p.o_Array_Number('staff_ids');
  begin
    b_Report.Open_Book_With_Styles(p.o_Varchar2('rt'), Ui.Current_Form_Name);
  
    a := b_Report.New_Table;
    a.Column_Width(1, 200);
  
    if Fazo.Is_Empty(v_Division_Ids) then
      if Uit_Href.User_Access_All_Employees = 'Y' then
        select t.Division_Id
          bulk collect
          into v_Division_Ids
          from Mhr_Divisions t
          join Hrm_Divisions Dv
            on Dv.Company_Id = t.Company_Id
           and Dv.Filial_Id = t.Filial_Id
           and Dv.Division_Id = t.Division_Id
           and Dv.Is_Department = 'Y'
         where t.Company_Id = Ui.Company_Id
           and t.Filial_Id = Ui.Filial_Id
           and t.State = 'A';
      else
        v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                             i_Indirect         => true,
                                                             i_Manual           => true,
                                                             i_Only_Departments => 'Y');
      end if;
    else
      Print_Info(a, v_Division_Ids); -- print division names only if they are explicitly selected
    end if;
  
    if Fazo.Is_Empty(v_Staff_Ids) then
      select t.Staff_Id
        bulk collect
        into v_Staff_Ids
        from Href_Staffs t
       where t.Company_Id = Ui.Company_Id
         and t.Filial_Id = Ui.Filial_Id
         and t.Hiring_Date <= Trunc(sysdate)
         and (t.Dismissal_Date is null or t.Dismissal_Date >= Trunc(sysdate))
         and t.Org_Unit_Id member of v_Division_Ids
         and t.State = 'A';
    end if;
  
    Print_Header(a);
  
    Fill_Data(v_Staff_Ids);
  
    Print_Body(a);
  
    b_Report.Add_Sheet(Ui.Current_Form_Name, a);
    b_Report.Close_Book();
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id   = null,
           Filial_Id    = null,
           Staff_Id     = null,
           Staff_Kind   = null,
           Staff_Number = null,
           Employee_Id  = null,
           Division_Id  = null,
           Org_Unit_Id  = null,
           State        = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null;
  end;

end Ui_Vhr557;
/
