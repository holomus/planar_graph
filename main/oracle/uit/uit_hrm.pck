create or replace package Uit_Hrm is
  ----------------------------------------------------------------------------------------------------
  Function Robot_Fte
  (
    i_Robot_Id     number,
    i_Period_Begin date,
    i_Period_End   date := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Division_Names_Of_Employee(i_Person_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Division_Id       number,
    i_Division_Group_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Access_To_Hidden_Salary_Job
  (
    i_Job_Id      number,
    i_Employee_Id number := null
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Hidden_Salary_Job(i_Job_Id number) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Divisions
  (
    i_Division_Ids  Array_Number,
    i_Check_Access  boolean := true,
    i_Is_Department varchar2 := 'Y'
  ) return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Divisions
  (
    i_Division_Id   number := null,
    i_Check_Access  boolean := true,
    i_Is_Department varchar2 := 'Y'
  ) return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(i_Division_Id number) return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Org_Units return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Divisions_Query
  (
    i_Current_Filial   boolean := true,
    i_Only_Departments boolean := true,
    i_Only_Active      boolean := false
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Departments_Query
  (
    i_Current_Filial boolean := true,
    i_Only_Active    boolean := false
  ) return varchar2;
end Uit_Hrm;
/
create or replace package body Uit_Hrm is
  ----------------------------------------------------------------------------------------------------   
  g_Division_Managers Fazo.Varchar2_Id_Aat;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Fte
  (
    i_Robot_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    result       number;
  begin
    select Nvl(min(Fte), 1)
      into result
      from Hrm_Robot_Turnover Rob
     where Rob.Company_Id = v_Company_Id
       and Rob.Filial_Id = v_Filial_Id
       and Rob.Robot_Id = i_Robot_Id
       and (Rob.Period >= i_Period_Begin or
           Rob.Period = (select max(Rt.Period)
                            from Hrm_Robot_Turnover Rt
                           where Rt.Company_Id = v_Company_Id
                             and Rt.Filial_Id = v_Filial_Id
                             and Rt.Robot_Id = i_Robot_Id
                             and Rt.Period <= i_Period_Begin))
       and (i_Period_End is null or Rob.Period <= i_Period_End);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Division_Names_Of_Employee(i_Person_Id number) return varchar2 is
    v_Division_Names varchar2(32672);
  begin
    select Listagg((select q.Name
                     from Mhr_Divisions q
                    where q.Company_Id = Dm.Company_Id
                      and q.Filial_Id = Dm.Filial_Id
                      and q.Division_Id = Dm.Division_Id),
                   ', ')
      into v_Division_Names
      from Hrm_Division_Managers Dm
     where Dm.Company_Id = Ui.Company_Id
       and Dm.Filial_Id = Ui.Filial_Id
       and Dm.Employee_Id = i_Person_Id;
  
    return v_Division_Names;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Division_Id       number,
    i_Division_Group_Id number
  ) return varchar2 is
    v_Division_Id  number;
    v_Manager_Name Mr_Natural_Persons.Name%type;
  
    --------------------------------------------------
    Function Manager_Name(i_Division_Id number) return varchar2 is
      r_Manager Mrf_Robots%rowtype := Href_Util.Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                                                     i_Filial_Id   => i_Filial_Id,
                                                                     i_Division_Id => i_Division_Id);
    begin
      return z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                                       i_Person_Id  => r_Manager.Person_Id).Name;
    end;
  
    --------------------------------------------------
    Function Manager_Division_Id return number is
      result     number;
      r_Division Mhr_Divisions%rowtype := z_Mhr_Divisions.Load(i_Company_Id  => i_Company_Id,
                                                               i_Filial_Id   => i_Filial_Id,
                                                               i_Division_Id => i_Division_Id);
    begin
      if r_Division.Division_Group_Id = i_Division_Group_Id then
        return i_Division_Id;
      end if;
    
      select Qr.Parent_Id
        into result
        from Mhr_Parent_Divisions Qr
       where Qr.Company_Id = i_Company_Id
         and Qr.Filial_Id = i_Filial_Id
         and Qr.Division_Id = i_Division_Id
         and Qr.Lvl = (select min(Pd.Lvl)
                         from Mhr_Parent_Divisions Pd
                        where Pd.Company_Id = i_Company_Id
                          and Pd.Filial_Id = i_Filial_Id
                          and Pd.Division_Id = i_Division_Id
                          and exists (select 1
                                 from Mhr_Divisions d
                                where d.Company_Id = Pd.Company_Id
                                  and d.Filial_Id = Pd.Filial_Id
                                  and d.Division_Id = Pd.Parent_Id
                                  and d.Division_Group_Id = i_Division_Group_Id));
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    return g_Division_Managers(i_Division_Id);
  exception
    when No_Data_Found then
      if i_Division_Group_Id is null then
        v_Division_Id := i_Division_Id;
      else
        v_Division_Id := Manager_Division_Id;
      end if;
    
      v_Manager_Name := Manager_Name(v_Division_Id);
    
      g_Division_Managers(i_Division_Id) := v_Manager_Name;
    
      return v_Manager_Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_To_Hidden_Salary_Job
  (
    i_Job_Id      number,
    i_Employee_Id number := null
  ) return varchar2 is
  begin
    return Hrm_Util.Access_To_Hidden_Salary_Job(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Job_Id     => i_Job_Id,
                                                i_User_Id    => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Hidden_Salary_Job(i_Job_Id number) return boolean is
  begin
    return Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Job_Id     => i_Job_Id,
                                                    i_User_Id    => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Divisions
  (
    i_Division_Ids  Array_Number,
    i_Check_Access  boolean := true,
    i_Is_Department varchar2 := 'Y'
  ) return Matrix_Varchar2 is
    v_Division_Ids        Array_Number;
    v_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
    result                Matrix_Varchar2;
  begin
    if i_Check_Access and v_Access_All_Employee = 'N' then
      v_Division_Ids := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    if not i_Check_Access or v_Access_All_Employee = 'Y' then
      select Array_Varchar2(q.Division_Id,
                             p.Name,
                             case
                               when i_Is_Department = 'Y' then
                                q.Parent_Department_Id
                               else
                                p.Parent_Id
                             end,
                             'Y')
        bulk collect
        into result
        from Hrm_Divisions q
        join Mhr_Divisions p
          on p.Company_Id = q.Company_Id
         and p.Filial_Id = q.Filial_Id
         and p.Division_Id = q.Division_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and (p.State = 'A' and (i_Is_Department = 'N' or q.Is_Department = 'Y') or
             q.Division_Id in (select *
                                  from table(i_Division_Ids)))
       order by Lower(p.Name);
    else
      select Array_Varchar2(q.Division_Id,
                             p.Name,
                             case
                               when i_Is_Department = 'Y' then
                                q.Parent_Department_Id
                               else
                                p.Parent_Id
                             end,
                             case -- This part is for checking that the nodes are selectable or not on b-tree-select
                               when q.Division_Id in (select Column_Value
                                                        from table(v_Division_Ids)) then
                                'Y'
                               else
                                'N'
                             end)
        bulk collect
        into result
        from Hrm_Divisions q
        join Mhr_Divisions p
          on p.Company_Id = q.Company_Id
         and p.Filial_Id = q.Filial_Id
         and p.Division_Id = q.Division_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and (p.State = 'A' and (i_Is_Department = 'N' or q.Is_Department = 'Y') or
             q.Division_Id in (select *
                                  from table(i_Division_Ids)))
         and q.Division_Id in
             (select Pd.Parent_Id
                from Mhr_Parent_Divisions Pd
               where Pd.Company_Id = Ui.Company_Id
                 and Pd.Filial_Id = Ui.Filial_Id
                 and Pd.Division_Id in (select *
                                          from table(v_Division_Ids))
              union
              select Column_Value
                from table(v_Division_Ids)
              union
              select Column_Value
                from table(i_Division_Ids))
       order by Lower(p.Name);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Divisions
  (
    i_Division_Id   number := null,
    i_Check_Access  boolean := true,
    i_Is_Department varchar2 := 'Y'
  ) return Matrix_Varchar2 is
    v_Division_Ids Array_Number := Array_Number();
  begin
    if i_Division_Id is not null then
      Fazo.Push(v_Division_Ids, i_Division_Id);
    end if;
  
    return Divisions(v_Division_Ids, i_Check_Access, i_Is_Department);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(i_Division_Id number) return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(w.Division_Id,
                           w.Name,
                           case
                             when w.Parent_Id = i_Division_Id then
                              null
                             else
                              w.Parent_Id
                           end)
      bulk collect
      into v_Matrix
      from Hrm_Divisions q
      join Mhr_Divisions w
        on q.Company_Id = w.Company_Id
       and q.Filial_Id = w.Filial_Id
       and q.Division_Id = w.Division_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Parent_Department_Id = i_Division_Id
       and q.Is_Department = 'N';
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Org_Units return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(p.Division_Id, p.Name, p.Parent_Id, q.Parent_Department_Id)
      bulk collect
      into v_Matrix
      from Hrm_Divisions q
      join Mhr_Divisions p
        on p.Company_Id = q.Company_Id
       and p.Filial_Id = q.Filial_Id
       and p.Division_Id = q.Division_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Is_Department = 'N';
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Divisions_Query
  (
    i_Current_Filial   boolean := true,
    i_Only_Departments boolean := true,
    i_Only_Active      boolean := false
  ) return varchar2 is
    v_Query varchar2(4000);
  begin
    v_Query := 'select dv.company_id,
                       dv.division_id,
                       dv.filial_id,
                       dv.name,
                       dv.division_group_id,
                       dv.opened_date,
                       dv.closed_date,
                       dv.state,
                       dv.code,';
  
    if i_Only_Departments then
      v_Query := v_Query || ' sv.parent_department_id parent_id ';
    else
      v_Query := v_Query || ' dv.parent_id ';
    end if;
  
    v_Query := v_Query || ' from mhr_divisions dv
                  join hrm_divisions sv
                    on sv.company_id = dv.company_id
                   and sv.filial_id = dv.filial_id
                   and sv.division_id = dv.division_id
                 where dv.company_id = :company_id';
  
    if i_Current_Filial then
      v_Query := v_Query || ' and dv.filial_id = :filial_id ';
    end if;
  
    if i_Only_Departments then
      v_Query := v_Query || ' and sv.is_department = ''Y'' ';
    end if;
  
    if i_Only_Active then
      v_Query := v_Query || ' and dv.state = ''A'' ';
    end if;
  
    return v_Query;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Departments_Query
  (
    i_Current_Filial boolean := true,
    i_Only_Active    boolean := false
  ) return varchar2 is
  begin
    return Divisions_Query(i_Current_Filial   => i_Current_Filial,
                           i_Only_Departments => true,
                           i_Only_Active      => i_Only_Active);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Divisions
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Id       = null,
           name              = null,
           Parent_Id         = null,
           Division_Group_Id = null,
           Opened_Date       = null,
           Closed_Date       = null,
           State             = null,
           Code              = null;
  
    update Hrm_Divisions
       set Company_Id           = null,
           Filial_Id            = null,
           Division_Id          = null,
           Is_Department        = null,
           Parent_Department_Id = null;
  end;

end Uit_Hrm;
/
