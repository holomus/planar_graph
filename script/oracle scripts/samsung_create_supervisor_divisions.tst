PL/SQL Developer Test script 3.0
41
-- Created on 10/19/2022 by ADHAM 
declare
  -- Local variables here
  i             integer;
  v_Division_Id number;
  r_Division    Mhr_Divisions%rowtype;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(940);
  for r in (select q.*,
                   (select w.Name
                      from Md_Persons w
                     where w.Person_Id = q.Employee_Id) name,
                   k.Robot_Id
              from Mhr_Employees q
              join Href_Staffs k
                on q.Filial_Id = k.Filial_Id
               and q.Employee_Id = k.Employee_Id
             where q.Company_Id = 940
               and q.Job_Id = 33955
               and q.State = 'A'
               and k.Dismissal_Date is null)
  loop
    v_Division_Id          := Mhr_Next.Division_Id;
    r_Division.Company_Id  := 940;
    r_Division.Filial_Id   := r.Filial_Id;
    r_Division.Division_Id := v_Division_Id;
    r_Division.Parent_Id   := r.Division_Id;
    r_Division.State       := 'A';
    r_Division.Name        := 'Супервизор (' || r.Name || ')';
    r_Division.Opened_Date := Trunc(sysdate);
  
    Mhr_Api.Division_Save(r_Division);
    Hrm_Api.Division_Manager_Save(i_Company_Id  => r.Company_Id,
                                  i_Filial_Id   => r.Filial_Id,
                                  i_Division_Id => v_Division_Id,
                                  i_Robot_Id    => r.Robot_Id);
  end loop;
  Biruni_Route.Context_End;
end;
0
0
