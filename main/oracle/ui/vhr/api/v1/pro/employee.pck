create or replace package Ui_Vhr266 is
  ---------------------------------------------------------------------------------------------------- 
  Function List_Employees(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr266;
/
create or replace package body Ui_Vhr266 is
  ----------------------------------------------------------------------------------------------------
  -- employee keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Staff_Id             constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id          constant varchar2(50) := 'employee_id';
  c_Key_Employee_Created_On  constant varchar2(50) := 'created_on';
  c_Key_Employee_Modified_On constant varchar2(50) := 'modified_on';
  c_Key_Employee_Number      constant varchar2(50) := 'employee_number';
  c_Key_Employee_Code        constant varchar2(50) := 'employee_code';
  c_Key_Employee_Kind_Code   constant varchar2(50) := 'employee_kind_code';
  c_Key_Employee_Kind_Name   constant varchar2(50) := 'employee_kind_name';
  c_Key_Employee_Name        constant varchar2(50) := 'employee_name';
  c_Key_Hiring_Date          constant varchar2(50) := 'hiring_date';
  c_Key_Dismissal_Date       constant varchar2(50) := 'dismissal_date';
  c_Key_Position_Id          constant varchar2(50) := 'position_id';
  c_Key_Division_Id          constant varchar2(50) := 'division_id';
  c_Key_Job_Id               constant varchar2(50) := 'job_id';
  c_Key_Rank_Id              constant varchar2(50) := 'rank_id';
  c_Key_Schedule_Id          constant varchar2(50) := 'schedule_id';
  c_Key_First_Name           constant varchar2(50) := 'first_name';
  c_Key_Last_Name            constant varchar2(50) := 'last_name';
  c_Key_Middle_Name          constant varchar2(50) := 'middle_name';
  c_Key_Gender               constant varchar2(50) := 'gender';
  c_Key_Birthday             constant varchar2(50) := 'birthday';
  c_Key_Address              constant varchar2(50) := 'address';
  c_Key_Main_Phone           constant varchar2(50) := 'main_phone';
  c_Key_Tin                  constant varchar2(50) := 'tin';
  c_Key_Iapa                 constant varchar2(50) := 'iapa';
  c_Key_Npin                 constant varchar2(50) := 'npin';
  c_Key_Employee_State       constant varchar2(50) := 'employee_state';
  c_Key_Fte_Id               constant varchar2(50) := 'fte_id';

  ---------------------------------------------------------------------------------------------------- 
  Function List_Employees(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Fte_Id     number := i_Data.o_Number('fte_id');
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Staff_Ids Array_Number := Nvl(i_Data.o_Array_Number('staff_ids'), Array_Number());
    v_Staff_Cnt number := v_Staff_Ids.Count;
  
    v_Employee  Gmap;
    v_Employees Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for Emp in (select *
                  from (select p.Company_Id,
                               p.Modified_Id,
                               St.Staff_Id,
                               St.Employee_Id,
                               St.Created_On,
                               St.Fte_Id,
                               St.Modified_On,
                               St.Staff_Number   Employee_Number,
                               w.Code            Employee_Code,
                               w.Name            Employee_Name,
                               St.Staff_Kind     Employee_Kind,
                               q.State           Employee_State,
                               St.Hiring_Date,
                               St.Dismissal_Date,
                               St.Robot_Id,
                               St.Division_Id,
                               St.Job_Id,
                               St.Rank_Id,
                               St.Schedule_Id,
                               w.First_Name,
                               w.Last_Name,
                               w.Middle_Name,
                               w.Gender,
                               w.Birthday,
                               r.Tin,
                               r.Address,
                               r.Main_Phone,
                               n.Iapa,
                               n.Npin
                          from Href_Staffs St
                          join Md_Persons p
                            on p.Company_Id = St.Company_Id
                           and p.Person_Id = St.Employee_Id
                          join Mhr_Employees q
                            on q.Company_Id = St.Company_Id
                           and q.Filial_Id = St.Filial_Id
                           and q.Employee_Id = St.Employee_Id
                          join Mr_Natural_Persons w
                            on w.Company_Id = St.Company_Id
                           and w.Person_Id = St.Employee_Id
                          join Mr_Person_Details r
                            on r.Company_Id = w.Company_Id
                           and r.Person_Id = w.Person_Id
                          left join Href_Person_Details n
                            on n.Company_Id = w.Company_Id
                           and n.Person_Id = w.Person_Id
                         where St.Company_Id = v_Company_Id
                           and St.Filial_Id = v_Filial_Id
                           and (v_Staff_Cnt = 0 or --                 
                               St.Staff_Id member of v_Staff_Ids)
                           and St.State = 'A'
                           and (v_Fte_Id is null or St.Fte_Id = v_Fte_Id)) Qr
                 where Qr.Company_Id = v_Company_Id
                   and Qr.Modified_Id > v_Start_Id
                 order by Qr.Modified_Id
                 fetch first v_Limit Rows only)
    loop
      v_Employee := Gmap;
    
      v_Employee.Put(c_Key_Staff_Id, Emp.Staff_Id);
      v_Employee.Put(c_Key_Employee_Id, Emp.Employee_Id);
      v_Employee.Put(c_Key_Employee_Created_On, Emp.Created_On);
      v_Employee.Put(c_Key_Employee_Modified_On, Emp.Modified_On);
      v_Employee.Put(c_Key_Employee_Number, Emp.Employee_Number);
      v_Employee.Put(c_Key_Employee_Code, Emp.Employee_Code);
      v_Employee.Put(c_Key_Employee_Name, Emp.Employee_Name);
      v_Employee.Put(c_Key_First_Name, Emp.First_Name);
      v_Employee.Put(c_Key_Last_Name, Emp.Last_Name);
      v_Employee.Put(c_Key_Middle_Name, Emp.Middle_Name);
      v_Employee.Put(c_Key_Gender, Emp.Gender);
      v_Employee.Put(c_Key_Birthday, Emp.Birthday);
      v_Employee.Put(c_Key_Address, Emp.Address);
      v_Employee.Put(c_Key_Main_Phone, Emp.Main_Phone);
      v_Employee.Put(c_Key_Tin, Emp.Tin);
      v_Employee.Put(c_Key_Iapa, Emp.Iapa);
      v_Employee.Put(c_Key_Npin, Emp.Npin);
      v_Employee.Put(c_Key_Hiring_Date, Emp.Hiring_Date);
      v_Employee.Put(c_Key_Dismissal_Date, Emp.Dismissal_Date);
      v_Employee.Put(c_Key_Position_Id, Emp.Robot_Id);
      v_Employee.Put(c_Key_Division_Id, Emp.Division_Id);
      v_Employee.Put(c_Key_Job_Id, Emp.Job_Id);
      v_Employee.Put(c_Key_Rank_Id, Emp.Rank_Id);
      v_Employee.Put(c_Key_Schedule_Id, Emp.Schedule_Id);
      v_Employee.Put(c_Key_Employee_Kind_Code, Emp.Employee_Kind);
      v_Employee.Put(c_Key_Employee_Kind_Name, Href_Util.t_Staff_Kind(Emp.Employee_Kind));
      v_Employee.Put(c_Key_Employee_State, Emp.Employee_State);
      v_Employee.Put(c_Key_Fte_Id, Emp.Fte_Id);
    
      v_Last_Id := Emp.Modified_Id;
    
      v_Employees.Push(v_Employee.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Employees, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr266;
/
