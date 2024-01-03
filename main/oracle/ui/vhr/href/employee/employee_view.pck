create or replace package Ui_Vhr251 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr251;
/
create or replace package body Ui_Vhr251 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Employee         Mhr_Employees%rowtype;
    r_Staff            Href_Staffs%rowtype;
    r_Person_Detail    Href_Person_Details%rowtype;
    r_Person           Md_Persons%rowtype;
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    v_Date             date := Trunc(sysdate);
    v_Status           varchar2(1);
    v_References       Hashmap;
    result             Hashmap;
  begin
    r_Employee := z_Mhr_Employees.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Employee_Id => p.r_Number('employee_id'));
  
    Uit_Href.Assert_Access_To_Employee(r_Employee.Employee_Id);
  
    result := z_Mhr_Employees.To_Map(r_Employee, --
                                     z.Employee_Id,
                                     z.Employee_Number,
                                     z.State,
                                     z.Created_On,
                                     z.Modified_On);
  
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Employee.Company_Id, --
               i_User_Id => r_Employee.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Employee.Company_Id, --
               i_User_Id => r_Employee.Modified_By).Name);
  
    r_Staff  := z_Href_Staffs.Take(i_Company_Id => r_Employee.Company_Id,
                                   i_Filial_Id  => r_Employee.Filial_Id,
                                   i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => r_Employee.Company_Id,
                                                                                  i_Filial_Id   => r_Employee.Filial_Id,
                                                                                  i_Employee_Id => r_Employee.Employee_Id,
                                                                                  i_Date        => v_Date));
    v_Status := Uit_Href.Get_Staff_Status(i_Hiring_Date    => r_Staff.Hiring_Date,
                                          i_Dismissal_Date => r_Staff.Dismissal_Date,
                                          i_Date           => v_Date);
  
    Result.Put_All(z_Href_Staffs.To_Map(r_Staff,
                                        z.Staff_Id,
                                        z.Hiring_Date,
                                        z.Dismissal_Date,
                                        z.Fte,
                                        z.Dismissal_Note));
  
    Result.Put('status', v_Status);
    Result.Put('status_name', Href_Util.t_Staff_Status(v_Status));
    Result.Put('robot_name',
               z_Mrf_Robots.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Robot_Id => r_Staff.Robot_Id).Name);
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Division_Id => r_Staff.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Job_Id => r_Staff.Job_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Rank_Id => r_Staff.Rank_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Schedule_Id => r_Staff.Schedule_Id).Name);
  
    Result.Put('wage',
               case when r_Staff.Company_Id is not null then
               Uit_Hpd.Get_Closest_Wage_With_Access(i_Staff_Id => r_Staff.Staff_Id,
                                                    i_Period   => Nvl(r_Staff.Dismissal_Date,
                                                                      Trunc(sysdate)),
                                                    i_User_Id  => r_Employee.Employee_Id) else null end);
  
    r_Person := z_Md_Persons.Load(i_Company_Id => r_Employee.Company_Id, --
                                  i_Person_Id  => r_Employee.Employee_Id);
  
    Result.Put_All(z_Md_Persons.To_Map(r_Person, --
                                       z.Name,
                                       z.Photo_Sha,
                                       z.Email));
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Natural_Persons.To_Map(r_Natural_Person,
                                               z.First_Name,
                                               z.Last_Name,
                                               z.Middle_Name,
                                               z.Gender,
                                               z.Birthday,
                                               z.Code));
  
    Result.Put('gender_name', Md_Util.t_Person_Gender(r_Natural_Person.Gender));
    Result.Put('manager_name',
               Href_Util.Get_Manager_Name(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Employee_Id => r_Employee.Employee_Id));
  
    r_Mr_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => r_Person.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Person_Details.To_Map(r_Mr_Person_Detail,
                                              z.Tin,
                                              z.Main_Phone,
                                              z.Address,
                                              z.Legal_Address,
                                              z.Region_Id));
  
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => r_Mr_Person_Detail.Company_Id, --
               i_Region_Id => r_Mr_Person_Detail.Region_Id).Name);
  
    r_Person_Detail := z_Href_Person_Details.Take(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Href_Person_Details.To_Map(r_Person_Detail,
                                                z.Iapa,
                                                z.Npin,
                                                z.Key_Person,
                                                z.Access_All_Employees));
  
    Result.Put('access_all_employees_name',
               Md_Util.Decode(r_Person_Detail.Access_All_Employees, 'Y', Ui.t_Yes, 'N', Ui.t_No));
  
    v_References := Fazo.Zip_Map('access_all_employee',
                                 Uit_Href.User_Access_All_Employees,
                                 'pg_female',
                                 Md_Pref.c_Pg_Female,
                                 'ss_working',
                                 Href_Pref.c_Staff_Status_Working,
                                 'ss_dismissed',
                                 Href_Pref.c_Staff_Status_Dismissed,
                                 'ss_unknown',
                                 Href_Pref.c_Staff_Status_Unknown);
  
    v_References.Put('user_id', Ui.User_Id);
  
    Result.Put('references', v_References);
  
    return result;
  end;

end Ui_Vhr251;
/
