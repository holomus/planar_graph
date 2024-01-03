create or replace package Ui_Vhr542 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr542;
/
create or replace package body Ui_Vhr542 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(3000);
    v_Params Hashmap;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'transfer_begin',
                             p.r_Date('transfer_begin'));
  
    v_Query := 'select p.*,
                       q.division_id,
                       q.job_id,
                       q.name,
                       (select min(fte)
                          from hrm_robot_turnover rob
                         where rob.company_id = p.company_id
                           and rob.filial_id = p.filial_id
                           and rob.robot_id = p.robot_id
                           and (rob.period >= :transfer_begin or
                               rob.period = (select max(rt.period)
                                                from hrm_robot_turnover rt
                                               where rt.company_id = rob.company_id
                                                 and rt.filial_id = rob.filial_id
                                                 and rt.robot_id = rob.robot_id
                                                 and rt.period <= :transfer_begin))) fte
                  from hrm_robots p
                  join mrf_robots q
                    on q.company_id = p.company_id
                   and q.filial_id = p.filial_id
                   and q.robot_id = p.robot_id
                 where p.company_id = :company_id
                   and p.filial_id = :filial_id';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and p.org_unit_id in (select column_value from table(:division_ids))';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('robot_id', 'fte');
    q.Date_Field('opened_date', 'closed_date');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query varchar2(32000);
    q       Fazo_Query;
  begin
    v_Query := 'select q.employee_id,
                       q.staff_id,
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
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('transfer_begin', Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Application    Hpd_Applications%rowtype;
    v_Transfer_Units Matrix_Varchar2;
    result           Hashmap;
  begin
    r_Application := z_Hpd_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Application_Id => p.r_Number('application_id'));
  
    result := z_Hpd_Applications.To_Map(r_Application,
                                        z.Application_Id,
                                        z.Application_Number,
                                        z.Application_Date,
                                        z.Status);
  
    select Array_Varchar2(t.Application_Unit_Id,
                          t.Staff_Id,
                          Href_Util.Staff_Name(i_Company_Id => t.Company_Id,
                                               i_Filial_Id  => t.Filial_Id,
                                               i_Staff_Id   => t.Staff_Id),
                          t.Transfer_Begin,
                          t.Robot_Id,
                          (select q.Name
                             from Mrf_Robots q
                            where q.Company_Id = t.Company_Id
                              and q.Filial_Id = t.Filial_Id
                              and q.Robot_Id = t.Robot_Id),
                          t.Note)
      bulk collect
      into v_Transfer_Units
      from Hpd_Application_Transfers t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Application_Id = r_Application.Application_Id;
  
    Result.Put('transfer_units', Fazo.Zip_Matrix(v_Transfer_Units));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p                Hashmap,
    i_Application_Id number
  ) return Hashmap is
    v_Application         Hpd_Pref.Application_Transfer_Rt;
    v_List                Arraylist;
    v_Transfer            Hashmap;
    r_Data                Hpd_Applications%rowtype;
    v_Grant_Part          varchar2(200);
    v_User_Id             number := Md_Env.User_Id;
    v_Application_Unit_Id number;
  begin
    Hpd_Util.Application_Transfer_New(o_Application    => v_Application,
                                      i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Application_Id => i_Application_Id);
  
    v_List := p.r_Arraylist('transfer_units');
  
    for i in 1 .. v_List.Count
    loop
      v_Transfer := Treat(v_List.r_Hashmap(i) as Hashmap);
    
      v_Application_Unit_Id := v_Transfer.o_Number('application_unit_id');
    
      if v_Application_Unit_Id is null then
        v_Application_Unit_Id := Hpd_Next.Application_Unit_Id;
      end if;
    
      Hpd_Util.Application_Add_Transfer(o_Application         => v_Application,
                                        i_Application_Unit_Id => v_Application_Unit_Id,
                                        i_Staff_Id            => v_Transfer.r_Number('staff_id'),
                                        i_Transfer_Begin      => v_Transfer.r_Date('transfer_begin'),
                                        i_Robot_Id            => v_Transfer.r_Number('robot_id'),
                                        i_Note                => v_Transfer.o_Varchar2('note'));
    end loop;
  
    Hpd_Api.Application_Transfer_Save(i_Application_Type => Hpd_Pref.c_Pcode_Application_Type_Transfer,
                                      i_Transfer         => v_Application);
  
    -- notification send after saving application
    r_Data := z_Hpd_Applications.Lock_Load(i_Company_Id     => v_Application.Company_Id,
                                           i_Filial_Id      => v_Application.Filial_Id,
                                           i_Application_Id => v_Application.Application_Id);
  
    v_Grant_Part := Hpd_Pref.c_App_Grant_Part_Transfer;
  
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
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null,
           Opened_Date = null,
           Closed_Date = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null,
           State      = null;
    update Hrm_Robot_Turnover
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Period     = null,
           Fte        = null;
  end;

end Ui_Vhr542;
/
