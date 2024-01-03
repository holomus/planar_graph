PL/SQL Developer Test script 3.0
62
declare
  v_Company_Id   number := 0;
  v_Filial_Head  number := Md_Pref.Filial_Head(v_Company_Id);
  v_Staff_Number Href_Staffs.Staff_Number%type;
  v_Exists       varchar2(1);
begin
  Biruni_Route.Clear_Globals;
  Ui_Context.Init(i_User_Id      => Md_Pref.User_System(v_Company_Id),
                  i_Project_Code => Verifix.Project_Code,
                  i_Filial_Id    => v_Filial_Head);

  for r in (select *
              from Href_Staffs s
             where s.Company_Id = v_Company_Id
               and s.Staff_Number is null
             order by s.Filial_Id, s.Hiring_Date)
  loop
    loop
      v_Staff_Number := Mkr_Core.Gen_Document_Number(i_Company_Id => r.Company_Id,
                                                     i_Filial_Id  => r.Filial_Id,
                                                     i_Table      => Zt.Href_Staffs,
                                                     i_Column     => z.Staff_Number);
    
      begin
        select 'Y'
          into v_Exists
          from Href_Staffs s
         where s.Company_Id = r.Company_Id
           and s.Filial_Id = r.Filial_Id
           and Upper(s.Staff_Number) = Upper(v_Staff_Number);
      exception
        when No_Data_Found then
          exit;
      end;
    end loop;
  
    z_Href_Staffs.Update_One(i_Company_Id   => r.Company_Id,
                             i_Filial_Id    => r.Filial_Id,
                             i_Staff_Id     => r.Staff_Id,
                             i_Staff_Number => Option_Varchar2(v_Staff_Number));
  end loop;

  update Mhr_Employees e
     set e.Employee_Number = Nvl((select s.Staff_Number
                                   from Href_Staffs s
                                  where s.Company_Id = v_Company_Id
                                    and s.Filial_Id = e.Filial_Id
                                    and s.Employee_Id = e.Employee_Id
                                    and s.State = 'A'
                                    and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                                    and s.Hiring_Date =
                                        (select max(s.Hiring_Date)
                                           from Href_Staffs S1
                                          where S1.Company_Id = v_Company_Id
                                            and S1.Filial_Id = e.Filial_Id
                                            and S1.Employee_Id = e.Employee_Id
                                            and S1.State = 'A'
                                            and S1.Staff_Kind = Href_Pref.c_Staff_Kind_Primary)
                                    and Rownum = 1),
                                 e.Employee_Number)
   where e.Company_Id = v_Company_Id;
end;
0
0
