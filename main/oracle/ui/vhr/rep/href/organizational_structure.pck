create or replace package Ui_Vhr299 is
  ----------------------------------------------------------------------------------------------------  
  Function Division_Children(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
end Ui_Vhr299;
/
create or replace package body Ui_Vhr299 is
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Employees
  (
    i_Filial_Id      number,
    i_Manager_Id     number,
    i_Divisions_Mode varchar2 := 'Y',
    i_Division_Id    number := null
  ) return Arraylist is
    v_Date   date := Trunc(sysdate);
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(Np.Name,
                          Np.Gender,
                          p.Photo_Sha,
                          p.Email,
                          Pd.Main_Phone,
                          (select r.Name
                             from Md_Regions r
                            where r.Company_Id = Pd.Company_Id
                              and r.Region_Id = Pd.Region_Id),
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = q.Company_Id
                              and j.Filial_Id = q.Filial_Id
                              and j.Job_Id = q.Job_Id))
      bulk collect
      into v_Matrix
      from Href_Staffs q
      join Mr_Natural_Persons Np
        on Np.Company_Id = q.Company_Id
       and Np.Person_Id = q.Employee_Id
      join Md_Persons p
        on p.Company_Id = Np.Company_Id
       and p.Person_Id = Np.Person_Id
      join Mr_Person_Details Pd
        on Pd.Company_Id = p.Company_Id
       and Pd.Person_Id = p.Person_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Employee_Id <> Nvl(i_Manager_Id, -1)
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= v_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)
       and (i_Divisions_Mode = 'Y' and Nvl(q.Org_Unit_Id, -1) = Nvl(i_Division_Id, -1) or
           Nvl(i_Divisions_Mode, 'N') != 'Y')
       and q.State = 'A'
     order by Lower(Np.Name)
     fetch first 20 Rows only;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Divisions
  (
    i_Filial_Id   number,
    i_Division_Id number := null
  ) return Arraylist is
    v_Division Hashmap;
    v_Date     date := Trunc(sysdate);
    result     Arraylist := Arraylist;
  begin
    for r in (select d.Division_Id,
                     d.Name,
                     (select Hd.Is_Department
                        from Hrm_Divisions Hd
                       where Hd.Company_Id = d.Company_Id
                         and Hd.Filial_Id = d.Filial_Id
                         and Hd.Division_Id = d.Division_Id) Is_Department,
                     e.Employee_Id Manager_Id,
                     Np.Name Manager_Name,
                     Np.Gender Manager_Gender,
                     (select j.Name
                        from Mhr_Jobs j
                       where j.Company_Id = e.Company_Id
                         and j.Filial_Id = e.Filial_Id
                         and j.Job_Id = e.Job_Id) Manager_Job,
                     p.Photo_Sha Manager_Photo_Sha,
                     p.Email Manager_Email,
                     Pd.Main_Phone Manager_Phone,
                     (select r.Name
                        from Md_Regions r
                       where r.Company_Id = Pd.Company_Id
                         and r.Region_Id = Pd.Region_Id) Manager_Region,
                     (select count(*)
                        from Href_Staffs St
                       where St.Company_Id = d.Company_Id
                         and St.Filial_Id = d.Filial_Id
                         and St.Employee_Id <> Nvl(e.Employee_Id, -1)
                         and St.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                         and St.Hiring_Date <= v_Date
                         and (St.Dismissal_Date is null or St.Dismissal_Date >= v_Date)
                         and St.Org_Unit_Id = d.Division_Id
                         and St.State = 'A') Employees_Count,
                     (select count(*)
                        from Mhr_Divisions s
                       where s.Company_Id = d.Company_Id
                         and s.Filial_Id = d.Filial_Id
                         and s.Parent_Id = d.Division_Id
                         and s.State = 'A') Subdivisions_Count
                from Mhr_Divisions d
                left join Mhr_Employees e
                  on e.Company_Id = d.Company_Id
                 and e.Filial_Id = d.Filial_Id
                 and e.Employee_Id = (select Mr.Person_Id
                                        from Mrf_Robots Mr
                                       where Mr.Company_Id = d.Company_Id
                                         and Mr.Filial_Id = d.Filial_Id
                                         and exists (select 1
                                                from Mrf_Division_Managers Dm
                                               where Dm.Company_Id = d.Company_Id
                                                 and Dm.Filial_Id = d.Filial_Id
                                                 and Dm.Division_Id = d.Division_Id
                                                 and Dm.Manager_Id = Mr.Robot_Id))
                left join Mr_Natural_Persons Np
                  on Np.Company_Id = e.Company_Id
                 and Np.Person_Id = e.Employee_Id
                left join Md_Persons p
                  on p.Company_Id = Np.Company_Id
                 and p.Person_Id = Np.Person_Id
                left join Mr_Person_Details Pd
                  on Pd.Company_Id = p.Company_Id
                 and Pd.Person_Id = p.Person_Id
               where d.Company_Id = Ui.Company_Id
                 and d.Filial_Id = i_Filial_Id
                 and Nvl(d.Parent_Id, -1) = Nvl(i_Division_Id, -1)
                 and d.State = 'A'
               order by Lower(d.Name))
    loop
      v_Division := Fazo.Zip_Map('filial_id',
                                 i_Filial_Id,
                                 'division_id',
                                 r.Division_Id,
                                 'division_name',
                                 r.Name,
                                 'is_department',
                                 r.Is_Department,
                                 'manager_name',
                                 r.Manager_Name,
                                 'manager_gender',
                                 r.Manager_Gender);
    
      v_Division.Put('manager_job', r.Manager_Job);
      v_Division.Put('manager_email', r.Manager_Email);
      v_Division.Put('manager_phone', r.Manager_Phone);
      v_Division.Put('manager_region', r.Manager_Region);
      v_Division.Put('manager_photo_sha', r.Manager_Photo_Sha);
      v_Division.Put('employees_count', r.Employees_Count);
      v_Division.Put('subdivisions_count', r.Subdivisions_Count);
      v_Division.Put('employees',
                     Get_Employees(i_Filial_Id   => i_Filial_Id,
                                   i_Manager_Id  => r.Manager_Id, --
                                   i_Division_Id => r.Division_Id));
    
      Result.Push(v_Division);
    end loop;
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Filials return Arraylist is
    v_Filial      Hashmap;
    v_Filial_Head number := Md_Pref.Filial_Head(Ui.Company_Id);
    v_Date        date := Trunc(sysdate);
    result        Arraylist := Arraylist;
  begin
    for r in (select f.Filial_Id,
                     f.Name,
                     Np.Person_Id Manager_Id,
                     Np.Name Manager_Name,
                     Np.Gender Manager_Gender,
                     (select j.Name
                        from Mhr_Jobs j
                       where j.Company_Id = e.Company_Id
                         and j.Filial_Id = e.Filial_Id
                         and j.Job_Id = e.Job_Id) Manager_Job,
                     p.Photo_Sha Manager_Photo_Sha,
                     p.Email Manager_Email,
                     Pd.Main_Phone Manager_Phone,
                     (select r.Name
                        from Md_Regions r
                       where r.Company_Id = Pd.Company_Id
                         and r.Region_Id = Pd.Region_Id) Manager_Region,
                     (select count(*)
                        from Href_Staffs St
                       where St.Company_Id = f.Company_Id
                         and St.Filial_Id = f.Filial_Id
                         and St.Employee_Id <> Nvl(Np.Person_Id, -1)
                         and St.Hiring_Date <= v_Date
                         and St.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                         and (St.Dismissal_Date is null or St.Dismissal_Date >= v_Date)
                         and St.State = 'A') Employees_Count,
                     (select count(*)
                        from Mhr_Divisions s
                       where s.Company_Id = f.Company_Id
                         and s.Filial_Id = f.Filial_Id
                         and s.Parent_Id is null
                         and s.State = 'A') Subdivisions_Count
                from Md_Filials f
                left join Mr_Natural_Persons Np
                  on Np.Company_Id = f.Company_Id
                 and Np.Person_Id = (select Lp.Primary_Person_Id
                                       from Mr_Legal_Persons Lp
                                      where Lp.Company_Id = f.Company_Id
                                        and Lp.Person_Id = f.Filial_Id)
                left join Mhr_Employees e
                  on e.Company_Id = Np.Company_Id
                 and e.Filial_Id = f.Filial_Id
                 and e.Employee_Id = Np.Person_Id
                left join Md_Persons p
                  on p.Company_Id = Np.Company_Id
                 and p.Person_Id = Np.Person_Id
                left join Mr_Person_Details Pd
                  on Pd.Company_Id = p.Company_Id
                 and Pd.Person_Id = p.Person_Id
               where f.Company_Id = Ui.Company_Id
                 and f.Filial_Id <> v_Filial_Head
                 and f.State = 'A'
               order by Lower(f.Name))
    loop
      v_Filial := Fazo.Zip_Map('filial_id',
                               r.Filial_Id,
                               'division_name',
                               r.Name,
                               'manager_name',
                               r.Manager_Name,
                               'manager_gender',
                               r.Manager_Gender,
                               'manager_job',
                               r.Manager_Job);
    
      v_Filial.Put('manager_email', r.Manager_Email);
      v_Filial.Put('manager_phone', r.Manager_Phone);
      v_Filial.Put('manager_region', r.Manager_Region);
      v_Filial.Put('manager_photo_sha', r.Manager_Photo_Sha);
      v_Filial.Put('employees_count', r.Employees_Count);
      v_Filial.Put('subdivisions_count', r.Subdivisions_Count);
      v_Filial.Put('employees',
                   Get_Employees(i_Filial_Id      => r.Filial_Id, --
                                 i_Manager_Id     => r.Manager_Id,
                                 i_Divisions_Mode => 'N'));
    
      Result.Push(v_Filial);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Division_Children(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Get_Divisions(i_Filial_Id   => p.r_Number('filial_id'),
                             i_Division_Id => p.o_Number('division_id')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result               Hashmap := Hashmap();
    r_Natural_Person     Mr_Natural_Persons%rowtype;
    r_Person             Md_Persons%rowtype;
    r_Person_Details     Mr_Person_Details%rowtype;
    r_Employee           Mhr_Employees%rowtype;
    r_Division           Mhr_Divisions%rowtype;
    v_Divisions          Arraylist;
    v_Manager_Id         number;
    v_Head_Division_Name varchar2(300);
  
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Div_Cnt          number := 0;
    v_Head_Division_Id number;
  
    --------------------------------------------------
    Function Divisions_Count return number is
      result number;
    begin
      select count(*)
        into result
        from Mhr_Divisions d
       where d.Company_Id = v_Company_Id
         and d.Filial_Id = v_Filial_Id
         and d.Parent_Id is null
         and d.State = 'A';
    
      return result;
    end;
  
    --------------------------------------------------
    Function Head_Division_Id return number is
      result number;
    begin
      select d.Division_Id
        into result
        from Mhr_Divisions d
       where d.Company_Id = v_Company_Id
         and d.Filial_Id = v_Filial_Id
         and d.Parent_Id is null
         and d.State = 'A';
    
      return result;
    end;
  
    --------------------------------------------------
    Function Head_Division_Manager_Id(i_Division_Id number) return number is
      result number;
    begin
      select e.Employee_Id
        into result
        from Mhr_Employees e
       where e.Company_Id = v_Company_Id
         and e.Filial_Id = v_Filial_Id
         and e.Employee_Id = (select Mr.Person_Id
                                from Mrf_Robots Mr
                               where Mr.Company_Id = v_Company_Id
                                 and Mr.Filial_Id = v_Filial_Id
                                 and exists (select 1
                                        from Mrf_Division_Managers Dm
                                       where Dm.Company_Id = v_Company_Id
                                         and Dm.Filial_Id = v_Filial_Id
                                         and Dm.Division_Id = i_Division_Id
                                         and Dm.Manager_Id = Mr.Robot_Id));
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    if Ui.Is_Filial_Head then
      Result.Put('divisions', Get_Filials);
    
      v_Head_Division_Name := z_Md_Companies.Load(v_Company_Id).Name;
    else
      v_Div_Cnt := Divisions_Count;
    
      if v_Div_Cnt = 1 then
        v_Head_Division_Id := Head_Division_Id;
      
        r_Division := z_Mhr_Divisions.Load(i_Company_Id  => v_Company_Id,
                                           i_Filial_Id   => v_Filial_Id,
                                           i_Division_Id => v_Head_Division_Id);
      
        v_Head_Division_Name := r_Division.Name;
        v_Manager_Id         := Head_Division_Manager_Id(r_Division.Division_Id);
        v_Divisions          := Get_Divisions(i_Filial_Id   => v_Filial_Id,
                                              i_Division_Id => r_Division.Division_Id); -- 3641
      else
        v_Manager_Id := z_Mr_Legal_Persons.Take(i_Company_Id => v_Company_Id, --
                        i_Person_Id => v_Filial_Id).Primary_Person_Id;
      
        v_Head_Division_Name := z_Md_Filials.Load(i_Company_Id => v_Company_Id, --
                                i_Filial_Id => v_Filial_Id).Name;
      
        v_Divisions := Get_Divisions(v_Filial_Id);
      end if;
    
      r_Natural_Person := z_Mr_Natural_Persons.Take(i_Company_Id => v_Company_Id, --
                                                    i_Person_Id  => v_Manager_Id);
      r_Person         := z_Md_Persons.Take(i_Company_Id => r_Natural_Person.Company_Id, --
                                            i_Person_Id  => r_Natural_Person.Person_Id);
      r_Person_Details := z_Mr_Person_Details.Take(i_Company_Id => r_Person.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);
      r_Employee       := z_Mhr_Employees.Take(i_Company_Id  => v_Company_Id,
                                               i_Filial_Id   => v_Filial_Id,
                                               i_Employee_Id => r_Person.Person_Id);
    
      Result.Put('manager_name', r_Natural_Person.Name);
      Result.Put('manager_gender', r_Natural_Person.Gender);
      Result.Put('manager_division',
                 z_Mhr_Divisions.Take(i_Company_Id => r_Employee.Company_Id, --
                 i_Filial_Id => r_Employee.Filial_Id, i_Division_Id => r_Employee.Division_Id).Name);
      Result.Put('manager_job',
                 z_Mhr_Jobs.Take(i_Company_Id => r_Employee.Company_Id, --
                 i_Filial_Id => r_Employee.Filial_Id, i_Job_Id => r_Employee.Job_Id).Name);
      Result.Put('manager_photo_sha', r_Person.Photo_Sha);
      Result.Put('manager_email', r_Person.Email);
      Result.Put('manager_phone', r_Person_Details.Main_Phone);
      Result.Put('manager_region',
                 z_Md_Regions.Take(i_Company_Id => r_Person_Details.Company_Id, --
                 i_Region_Id => r_Person_Details.Region_Id).Name);
      Result.Put('divisions', v_Divisions);
    end if;
  
    Result.Put('head_division_name', v_Head_Division_Name);
    Result.Put('head_division_id', v_Head_Division_Id);
    Result.Put('head_division_employees',
               Get_Employees(i_Filial_Id      => v_Filial_Id,
                             i_Manager_Id     => v_Manager_Id,
                             i_Divisions_Mode => 'Y',
                             i_Division_Id    => v_Head_Division_Id));
  
    return result;
  end;

end Ui_Vhr299;
/
