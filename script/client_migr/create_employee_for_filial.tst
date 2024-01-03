PL/SQL Developer Test script 3.0
69
-- Created on 06.12.2022 by SANJAR 
declare
  v_Old_Company_Id number := 480;
  v_Company_Id     number := 580;
  v_Filial_Id      number := 48905;

  r_Employee Mhr_Employees%rowtype;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select Np.Person_Id,
                   Nvl((select p.State
                         from Old_Vx_Org_Persons p
                        where p.Company_Id = v_Old_Company_Id
                          and p.Person_Id = q.Old_Id),
                       Np.State) State
              from Mr_Natural_Persons Np
              join Migr_Keys_Store_One q
                on q.Company_Id = v_Company_Id
               and q.Key_Name = 'person_id'
               and q.New_Id = Np.Person_Id
             where Np.Company_Id = v_Company_Id
               and not exists (select 1
                      from Mhr_Employees p
                     where p.Company_Id = Np.Company_Id
                       and p.Filial_Id = v_Filial_Id
                       and p.Employee_Id = Np.Person_Id))
  loop
    r_Employee.Company_Id  := v_Company_Id;
    r_Employee.Filial_Id   := v_Filial_Id;
    r_Employee.Employee_Id := r.Person_Id;
  
    r_Employee.State := r.State;
  
    Mhr_Api.Employee_Save(r_Employee);
  
    z_Mrf_Persons.Save_One(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Person_Id  => r.Person_Id,
                           i_State      => r.State);
  
  end loop;

  for r in (select p.Employee_Id,
                   Nvl((select w.State
                         from Old_Vx_Org_Persons w
                        where w.Company_Id = v_Old_Company_Id
                          and w.Person_Id = q.Old_Id),
                       p.State) State
              from Mhr_Employees p
              join Migr_Keys_Store_One q
                on q.Company_Id = v_Company_Id
               and q.Key_Name = 'person_id'
               and q.New_Id = p.Employee_Id
             where p.Company_Id = v_Company_Id
               and p.Filial_Id = v_Filial_Id)
  loop
    z_Mhr_Employees.Update_One(i_Company_Id  => v_Company_Id,
                               i_Filial_Id   => v_Filial_Id,
                               i_Employee_Id => r.Employee_Id,
                               i_State       => Option_Varchar2(r.State));
  
    z_Mrf_Persons.Save_One(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Person_Id  => r.Employee_Id,
                           i_State      => r.State);
  
  end loop;
end;
0
0
