create or replace package Ui_Vhr543 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Info(p Hashmap) return Hashmap;
end Ui_Vhr543;
/
create or replace package body Ui_Vhr543 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query varchar2(32000);
    q       Fazo_Query;
  begin
    v_Query := 'select q.staff_id,
                       q.employee_id,
                       q.staff_number,
                       q.hiring_date,
                       q.dismissal_date,
                       q.division_id,
                       q.org_unit_id,
                       (select w.name
                          from mr_natural_persons w
                         where w.company_id = q.company_id
                           and w.person_id = q.employee_id) name
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('staff_id', 'employee_id', 'division_id');
    q.Varchar2_Field('staff_number', 'name');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Reasons return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Href_Util.Dismissal_Reasons_Type;
    q        Fazo_Query;
  begin
    q := Fazo_Query('href_dismissal_reasons', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('dismissal_reason_id');
    q.Varchar2_Field('name', 'reason_type');
  
    q.Option_Field('reason_type_name', 'reason_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('dismissal_date', Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Application Hpd_Applications%rowtype;
    r_Dismissal   Hpd_Application_Dismissals%rowtype;
    result        Hashmap;
  begin
    r_Application := z_Hpd_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Application_Id => p.r_Number('application_id'));
  
    result := z_Hpd_Applications.To_Map(r_Application,
                                        z.Application_Id,
                                        z.Application_Number,
                                        z.Application_Date);
  
    r_Dismissal := z_Hpd_Application_Dismissals.Load(i_Company_Id     => Ui.Company_Id,
                                                     i_Filial_Id      => Ui.Filial_Id,
                                                     i_Application_Id => r_Application.Application_Id);
  
    Result.Put_All(z_Hpd_Application_Dismissals.To_Map(r_Dismissal,
                                                       z.Staff_Id,
                                                       z.Dismissal_Date,
                                                       z.Dismissal_Reason_Id,
                                                       z.Note));
    Result.Put('staff_name',
               Href_Util.Staff_Name(i_Company_Id => r_Dismissal.Company_Id,
                                    i_Filial_Id  => r_Dismissal.Filial_Id,
                                    i_Staff_Id   => r_Dismissal.Staff_Id));
    Result.Put('dismissal_reason_name',
               z_Href_Dismissal_Reasons.Take(i_Company_Id => Ui.Company_Id, i_Dismissal_Reason_Id => r_Dismissal.Dismissal_Reason_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p                Hashmap,
    i_Application_Id number
  ) return Hashmap is
    v_Application Hpd_Pref.Application_Dismissal_Rt;
    r_Data        Hpd_Applications%rowtype;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    Hpd_Util.Application_Dismissal_New(o_Application         => v_Application,
                                       i_Company_Id          => Ui.Company_Id,
                                       i_Filial_Id           => Ui.Filial_Id,
                                       i_Application_Id      => i_Application_Id,
                                       i_Staff_Id            => p.r_Number('staff_id'),
                                       i_Dismissal_Date      => p.r_Date('dismissal_date'),
                                       i_Dismissal_Reason_Id => p.o_Number('dismissal_reason_id'),
                                       i_Note                => p.o_Varchar2('note'));
  
    Hpd_Api.Application_Dismissal_Save(v_Application);
  
    -- notification send after saving application
    r_Data := z_Hpd_Applications.Lock_Load(i_Company_Id     => v_Application.Company_Id,
                                           i_Filial_Id      => v_Application.Filial_Id,
                                           i_Application_Id => v_Application.Application_Id);
  
    v_Grant_Part := Hpd_Pref.c_App_Grant_Part_Dismissal;
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Data.Company_Id,
                                           i_Filial_Id      => r_Data.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Created(i_Company_Id          => r_Data.Company_Id,
                                                                                                                 i_User_Id             => v_User_Id,
                                                                                                                 i_Application_Type_Id => r_Data.Application_Type_Id,
                                                                                                                 i_Application_Number  => r_Data.Application_Number),
                                           i_Grants         => Array_Varchar2(v_Grant_Part ||
                                                                              Hpd_Pref.c_App_Grantee_Applicant),
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Data.Application_Id),
                                           i_Except_User_Id => v_User_Id);
  
    return Fazo.Zip_Map('application_id', i_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hpd_Next.Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Application_Id number := p.r_Number('application_id');
  begin
    z_Hpd_Applications.Lock_Only(i_Company_Id     => Ui.Company_Id,
                                 i_Filial_Id      => Ui.Filial_Id,
                                 i_Application_Id => v_Application_Id);
  
    return save(p, v_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Info(p Hashmap) return Hashmap is
    r_Staff Href_Staffs%rowtype;
    result  Hashmap := Hashmap();
  begin
    r_Staff := z_Href_Staffs.Take(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Staff_Id   => p.o_Number('staff_id'));
  
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Division_Id => r_Staff.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Job_Id => r_Staff.Job_Id).Name);
    Result.Put('manager_name',
               Href_Util.Get_Manager_Name(i_Company_Id  => r_Staff.Company_Id,
                                          i_Filial_Id   => r_Staff.Filial_Id,
                                          i_Employee_Id => r_Staff.Employee_Id));
    Result.Put('phone_number',
               z_Mr_Person_Details.Take(i_Company_Id => r_Staff.Company_Id, i_Person_Id => r_Staff.Employee_Id).Main_Phone);
  
    if Hrm_Util.Load_Setting(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id).Position_Enable = 'Y' then
      Result.Put('robot_name',
                 z_Mrf_Robots.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Robot_Id => r_Staff.Robot_Id).Name);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null,
           Reason_Type         = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr543;
/
