create or replace package Ui_Vhr275 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Managers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------        
  Function Query_Subfilials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr275;
/
create or replace package body Ui_Vhr275 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Managers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select mr.robot_id,
                            mr.name robot_name,
                            mr.person_id
                       from mrf_robots mr
                      where mr.company_id = :company_id
                        and mr.filial_id = :filial_id
                        and exists (select 1
                               from hrm_robots hr
                              where hr.company_id = :company_id
                                and hr.filial_id = :filial_id
                                and hr.robot_id = mr.robot_id )',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('robot_id', 'person_id');
    q.Map_Field('name',
                '$robot_name || '' (''|| (select pw.name from md_persons pw where pw.company_id = :company_id and pw.person_id = $person_id) ||'')''');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_staffs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('employee_id', 'job_id', 'robot_id', 'division_id', 'staff_id');
    q.Varchar2_Field('staff_number', 'state', 'status');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Refer_Field('name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons np
                    where np.company_id = :company_id');
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs jb
                    where jb.company_id = :company_id
                      and jb.filial_id = :filial_id');
  
    q.Map_Field('status',
                'uit_href.get_staff_status($hiring_date, $dismissal_date, trunc(sysdate))');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_division_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('division_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------        
  Function Query_Subfilials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mrf_subfilials', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('subfilial_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Table      => Zt.Mhr_Divisions,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
    v_Dummy      varchar2(1);
    v_Parent_Id  number := p.o_Number('parent_id');
    v_Lower_Name Mhr_Divisions.Name%type := Lower(p.o_Varchar2('name'));
  begin
    select 'x'
      into v_Dummy
      from Mhr_Divisions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and Lower(q.Name) = v_Lower_Name
       and ((v_Parent_Id is null and q.Parent_Id is null) or v_Parent_Id = q.Parent_Id);
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Manager_Id number
  ) return number is
    v_Staff_Id number;
  begin
    select q.Staff_Id
      into v_Staff_Id
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Manager_Id
       and q.State = 'A'
       and q.Hiring_Date <= Trunc(sysdate)
       and (q.Dismissal_Date is null or q.Dismissal_Date >= Trunc(sysdate));
  
    return v_Staff_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id   => i_Division_Id,
                                                 i_Check_Access  => false,
                                                 i_Is_Department => 'N')));
    Result.Put('sk_flexible', Htt_Pref.c_Schedule_Kind_Flexible);
    Result.Put('t_division_kind_team', Hrm_Util.t_Division_Kind_Team);
    Result.Put('t_division_kind_department', Hrm_Util.t_Division_Kind_Department);
    Result.Put('advanced_org_structure',
               Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Advanced_Org_Structure);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    v_Subfilial_Setting varchar2(1) := Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                                            i_Filial_Id  => Ui.Filial_Id);
    v_Data              Hashmap;
    result              Hashmap := Hashmap();
  begin
    v_Data := Fazo.Zip_Map('state',
                           'A',
                           'opened_date',
                           Trunc(sysdate),
                           'is_department',
                           'Y',
                           'allow_use_subfilial',
                           v_Subfilial_Setting);
  
    Result.Put('data', v_Data);
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data              Mhr_Divisions%rowtype;
    r_Division          Hrm_Divisions%rowtype;
    v_Staff_Id          number;
    v_Schedule_Id       number;
    v_Division_Id       number := p.r_Number('division_id');
    v_Position_Enable   varchar2(1);
    v_Manager_Id        number;
    v_Data              Hashmap;
    v_Subfilial_Setting varchar2(1) := Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                                            i_Filial_Id  => Ui.Filial_Id);
    result              Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Division(i_Division_Id => v_Division_Id);
  
    v_Position_Enable := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Position_Enable;
  
    Result.Put('position_enable', v_Position_Enable);
  
    r_Data := z_Mhr_Divisions.Load(i_Company_Id  => Ui.Company_Id,
                                   i_Filial_Id   => Ui.Filial_Id,
                                   i_Division_Id => v_Division_Id);
  
    r_Division := z_Hrm_Divisions.Load(i_Company_Id  => r_Data.Company_Id,
                                       i_Filial_Id   => r_Data.Filial_Id,
                                       i_Division_Id => r_Data.Division_Id);
  
    v_Data := z_Mhr_Divisions.To_Map(r_Data,
                                     z.Division_Id,
                                     z.Name,
                                     z.Parent_Id,
                                     z.Division_Group_Id,
                                     z.Opened_Date,
                                     z.Closed_Date,
                                     z.State,
                                     z.Code);
  
    v_Schedule_Id := z_Hrm_Division_Schedules.Take(i_Company_Id => r_Data.Company_Id, --
                     i_Filial_Id => r_Data.Filial_Id, --
                     i_Division_Id => r_Data.Division_Id).Schedule_Id;
  
    if r_Division.Manager_Status = Hrm_Pref.c_Division_Manager_Status_Manual then
      v_Manager_Id := z_Mrf_Division_Managers.Take(i_Company_Id => r_Data.Company_Id, --
                      i_Filial_Id => r_Data.Filial_Id, --
                      i_Division_Id => r_Data.Division_Id).Manager_Id;
    end if;
  
    if v_Position_Enable = 'Y' then
      v_Data.Put('manager_name',
                 z_Mrf_Robots.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => v_Manager_Id).Name);
    else
      v_Staff_Id := Get_Staff_Id(Ui.Company_Id, Ui.Filial_Id, v_Manager_Id);
    
      v_Data.Put('staff_id', v_Staff_Id);
      v_Data.Put('manager_name',
                 Href_Util.Staff_Name(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Staff_Id   => v_Staff_Id));
    end if;
  
    v_Data.Put('manager_id', v_Manager_Id);
    v_Data.Put('division_group_name',
               z_Mhr_Division_Groups.Take(i_Company_Id => Ui.Company_Id, i_Division_Group_Id => r_Data.Division_Group_Id).Name);
    v_Data.Put('parent_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Division_Id => r_Data.Parent_Id).Name);
    v_Data.Put('schedule_id', v_Schedule_Id);
    v_Data.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Data.Company_Id, --
               i_Filial_Id => r_Data.Filial_Id, --
               i_Schedule_Id => v_Schedule_Id).Name);
    v_Data.Put('is_department', r_Division.Is_Department);
    v_Data.Put('allow_use_subfilial', v_Subfilial_Setting);
  
    if v_Subfilial_Setting = 'Y' then
      v_Data.Put('subfilial_id', r_Division.Subfilial_Id);
      v_Data.Put('subfilial_name',
                 z_Mrf_Subfilials.Take(i_Company_Id => Ui.Company_Id, i_Subfilial_Id => r_Division.Subfilial_Id).Name);
    end if;
  
    Result.Put('data', v_Data);
    Result.Put_All(References(r_Data.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Manager
  (
    p          Hashmap,
    i_Division Mhr_Divisions%rowtype
  ) is
    v_Manager_Id number := p.o_Number('manager_id');
  begin
    if v_Manager_Id is not null then
      Hrm_Api.Division_Manager_Save(i_Company_Id  => i_Division.Company_Id,
                                    i_Filial_Id   => i_Division.Filial_Id,
                                    i_Division_Id => i_Division.Division_Id,
                                    i_Robot_Id    => v_Manager_Id);
    else
      Hrm_Api.Division_Manager_Delete(i_Company_Id  => i_Division.Company_Id,
                                      i_Filial_Id   => i_Division.Filial_Id,
                                      i_Division_Id => i_Division.Division_Id);
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap is
    v_Division Hrm_Pref.Division_Rt;
    r_Data     Mhr_Divisions%rowtype;
  begin
    r_Data := z_Mhr_Divisions.To_Row(p,
                                     z.Name,
                                     z.Parent_Id,
                                     z.Division_Group_Id,
                                     z.Opened_Date,
                                     z.Closed_Date,
                                     z.State,
                                     z.Code);
  
    r_Data.Company_Id  := Ui.Company_Id;
    r_Data.Filial_Id   := Ui.Filial_Id;
    r_Data.Division_Id := Mhr_Next.Division_Id;
  
    Hrm_Util.Division_New(o_Division      => v_Division,
                          i_Division      => r_Data,
                          i_Schedule_Id   => p.o_Number('schedule_id'),
                          i_Manager_Id    => p.o_Number('manager_id'),
                          i_Is_Department => p.r_Varchar2('is_department'),
                          i_Subfilial_Id  => p.o_Number('subfilial_id'));
  
    Hrm_Api.Division_Save(v_Division);
  
    return z_Mhr_Divisions.To_Map(r_Data, z.Division_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Division    Hrm_Pref.Division_Rt;
    v_Division_Id number := p.r_Number('division_id');
    r_Data        Mhr_Divisions%rowtype;
  begin
    Uit_Href.Assert_Access_To_Division(i_Division_Id => v_Division_Id);
  
    r_Data := z_Mhr_Divisions.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                        i_Filial_Id   => Ui.Filial_Id,
                                        i_Division_Id => v_Division_Id);
  
    z_Mhr_Divisions.To_Row(r_Data,
                           p,
                           z.Name,
                           z.Parent_Id,
                           z.Division_Group_Id,
                           z.Opened_Date,
                           z.Closed_Date,
                           z.State,
                           z.Code);
  
    Hrm_Util.Division_New(o_Division      => v_Division,
                          i_Division      => r_Data,
                          i_Schedule_Id   => p.o_Number('schedule_id'),
                          i_Manager_Id    => p.o_Number('manager_id'),
                          i_Is_Department => p.r_Varchar2('is_department'),
                          i_Subfilial_Id  => p.o_Number('subfilial_id'));
  
    Hrm_Api.Division_Save(v_Division);
  
    return z_Mhr_Divisions.To_Map(r_Data, z.Division_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Robot_Id       = null,
           Staff_Number   = null,
           Job_Id         = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null,
           State             = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mrf_Subfilials
       set Company_Id   = null,
           Subfilial_Id = null,
           name         = null,
           State        = null;
    Uie.x(Uit_Href.Get_Staff_Status(null, null, null));
  end;

end Ui_Vhr275;
/
