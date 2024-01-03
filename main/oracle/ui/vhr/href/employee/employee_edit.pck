create or replace package Ui_Vhr324 is
  ----------------------------------------------------------------------------------------------------
  Function Load_User(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Person(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Staff(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Location(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Toggle_Access_All(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Toggle_Employee_State(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Toggle_User_State(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Save_Photo(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Tab_Config(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Block_Employee_Tracking(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unblock_Employee_Tracking(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Query_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Dismiss_Employee(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Upload_Images(p Hashmap) return Hashmap;
end Ui_Vhr324;
/
create or replace package body Ui_Vhr324 is
  ----------------------------------------------------------------------------------------------------
  -- Employee edit form tab configuration
  ----------------------------------------------------------------------------------------------------
  c_Pref_Employee_Tab_Config constant varchar2(50) := 'vhr:href:employee_tab_config';

  ----------------------------------------------------------------------------------------------------
  Function Load_User(p Hashmap) return Hashmap is
    r_User Md_Users%rowtype;
    result Hashmap;
  begin
    r_User := z_Md_Users.Take(i_Company_Id => Ui.Company_Id, -- 
                              i_User_Id    => p.r_Number('employee_id'));
  
    result := z_Md_Users.To_Map(r_User, z.Login);
  
    if z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                               i_User_Id    => r_User.User_Id,
                               i_Filial_Id  => Ui.Filial_Id) then
      Result.Put('user_state', r_User.State);
    else
      Result.Put('user_state', 'P');
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Person(p Hashmap) return Hashmap is
    r_Person           Md_Persons%rowtype;
    r_Natural_Person   Mr_Natural_Persons%rowtype;
    r_Mr_Person_Detail Mr_Person_Details%rowtype;
    result             Hashmap;
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                  i_Person_Id  => p.r_Number('employee_id'));
  
    result := z_Md_Persons.To_Map(r_Person, -- 
                                  z.Photo_Sha,
                                  z.Email);
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Person.Company_Id,
                                                  i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Natural_Persons.To_Map(r_Natural_Person, z.Name, z.Gender));
  
    r_Mr_Person_Detail := z_Mr_Person_Details.Load(i_Company_Id => r_Person.Company_Id,
                                                   i_Person_Id  => r_Person.Person_Id);
  
    Result.Put_All(z_Mr_Person_Details.To_Map(r_Mr_Person_Detail, z.Main_Phone));
    Result.Put('key_person',
               z_Href_Person_Details.Take(i_Company_Id => r_Person.Company_Id, i_Person_Id => r_Person.Person_Id).Key_Person);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff(p Hashmap) return Hashmap is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Employee_Id number := p.r_Number('employee_id');
  
    v_Status varchar2(1);
    r_Staff  Href_Staffs%rowtype;
  
    v_Curr_Date date := Trunc(sysdate);
  
    result Hashmap;
  begin
    r_Staff.Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                       i_Filial_Id   => v_Filial_Id,
                                                       i_Employee_Id => v_Employee_Id);
  
    r_Staff := z_Href_Staffs.Take(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => r_Staff.Staff_Id);
  
    v_Status := Uit_Href.Get_Staff_Status(i_Hiring_Date    => r_Staff.Hiring_Date,
                                          i_Dismissal_Date => r_Staff.Dismissal_Date,
                                          i_Date           => v_Curr_Date);
  
    result := z_Href_Staffs.To_Map(r_Staff,
                                   z.Staff_Id,
                                   z.Staff_Number,
                                   z.Hiring_Date,
                                   z.Dismissal_Date,
                                   z.Division_Id,
                                   z.Org_Unit_Id);
  
    Result.Put('manager_name',
               Href_Util.Get_Manager_Name(i_Company_Id  => v_Company_Id,
                                          i_Filial_Id   => v_Filial_Id,
                                          i_Employee_Id => v_Employee_Id));
    Result.Put('status', v_Status);
    Result.Put('status_name', Href_Util.t_Staff_Status(v_Status));
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Division_Id => r_Staff.Division_Id).Name);
    Result.Put('org_unit_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Staff.Company_Id, --
               i_Filial_Id => r_Staff.Filial_Id, --
               i_Division_Id => r_Staff.Org_Unit_Id).Name);
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
    Result.Put('schedule_id', r_Staff.Schedule_Id);
    Result.Put('wage',
               Uit_Hpd.Get_Closest_Wage_With_Access(i_Staff_Id => r_Staff.Staff_Id,
                                                    i_Period   => Nvl(r_Staff.Dismissal_Date,
                                                                      v_Curr_Date),
                                                    i_User_Id  => v_Employee_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Location(p Hashmap) return Hashmap is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Employee_Id number := p.r_Number('employee_id');
  
    v_Loc_Ids   Array_Number;
    v_Loc_Names Array_Varchar2;
  begin
    select Lp.Location_Id
      bulk collect
      into v_Loc_Ids
      from Htt_Location_Persons Lp
     where Lp.Company_Id = v_Company_Id
       and Lp.Filial_Id = v_Filial_Id
       and Lp.Person_Id = v_Employee_Id;
  
    select Lc.Name
      bulk collect
      into v_Loc_Names
      from Htt_Locations Lc
     where Lc.Company_Id = v_Company_Id
       and Lc.Location_Id member of v_Loc_Ids
     order by Lc.Name
     fetch first 3 Rows only;
  
    return Fazo.Zip_Map('location_names',
                        Fazo.Gather(v_Loc_Names, ', '),
                        'location_count',
                        v_Loc_Ids.Count);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Tab_Config return Hashmap is
    v_Config varchar2(4000);
  begin
    v_Config := Ui.User_Setting_Load(i_Setting_Code  => c_Pref_Employee_Tab_Config,
                                     i_Default_Value => '{}');
  
    return Fazo.Parse_Map(v_Config);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Block_Employee_Tracking(p Hashmap) is
  begin
    Htt_Api.Block_Employee_Tracking(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Employee_Id => p.r_Number('employee_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unblock_Employee_Tracking(p Hashmap) is
  begin
    Htt_Api.Unblock_Employee_Tracking(i_Company_Id  => Ui.Company_Id,
                                      i_Filial_Id   => Ui.Filial_Id,
                                      i_Employee_Id => p.r_Number('employee_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('pg_female',
                           Md_Pref.c_Pg_Female,
                           'ss_working',
                           Href_Pref.c_Staff_Status_Working,
                           'ss_dismissed',
                           Href_Pref.c_Staff_Status_Dismissed,
                           'ss_unknown',
                           Href_Pref.c_Staff_Status_Unknown);
  
    Result.Put('tab_config', Load_Tab_Config);
    Result.Put('duplicate_prevention', Hface_Util.Duplicate_Prevention(Ui.Company_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix           Matrix_Varchar2 := Matrix_Varchar2();
    v_Employee_Id      number := p.r_Number('employee_id');
    v_Blocked_Tracking varchar2(1) := 'N';
    v_Doc_Type_Id      number;
    r_Employee         Mhr_Employees%rowtype;
    r_Document         Href_Person_Documents%rowtype;
    result             Hashmap;
  
    -------------------------------------------------- 
    Procedure Get_Passport_Info is
    begin
      select q.*
        into r_Document
        from Href_Person_Documents q
       where q.Company_Id = r_Employee.Company_Id
         and q.Person_Id = v_Employee_Id
         and q.Doc_Type_Id = v_Doc_Type_Id
       order by q.Begin_Date desc nulls last
       fetch first 1 row only;
    exception
      when No_Data_Found then
        null;
    end;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
  
    r_Employee := z_Mhr_Employees.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Employee_Id => v_Employee_Id);
  
    result := z_Mhr_Employees.To_Map(r_Employee,
                                     z.Employee_Id,
                                     z.State,
                                     i_State => 'employee_state');
  
    if Md_Util.Grant_Has(i_Company_Id   => Ui.Company_Id,
                         i_Project_Code => Ui.Project_Code,
                         i_Filial_Id    => Ui.Filial_Id,
                         i_User_Id      => Ui.User_Id,
                         i_Form         => Uit_Href.c_Form_Rep_Timesheet,
                         i_Action_Key   => Md_Pref.c_Form_Sign) then
      Fazo.Push(v_Matrix,
                Uit_Href.c_Form_Rep_Timesheet || ':run',
                Ui_Kernel.Form_Name(Uit_Href.c_Form_Rep_Timesheet),
                Uit_Href.c_Form_Rep_Timesheet);
    end if;
  
    v_Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => r_Employee.Company_Id,
                                           i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
  
    Get_Passport_Info;
  
    Result.Put('passport_series', r_Document.Doc_Series);
    Result.Put('passport_number', r_Document.Doc_Number);
    Result.Put('passport_id', r_Document.Document_Id);
  
    if z_Htt_Blocked_Person_Tracking.Exist(i_Company_Id  => r_Employee.Company_Id,
                                           i_Filial_Id   => r_Employee.Filial_Id,
                                           i_Employee_Id => r_Employee.Employee_Id) then
      v_Blocked_Tracking := 'Y';
    end if;
  
    Result.Put('blocked_tracking', v_Blocked_Tracking);
    Result.Put('reports', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('photo_as_face_rec', Htt_Util.Photo_As_Face_Rec(Ui.Company_Id));
  
    Result.Put_All(Load_User(p));
  
    Result.Put_All(Load_Person(p));
  
    Result.Put_All(Load_Staff(p));
  
    Result.Put_All(Load_Location(p));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Toggle_Access_All(p Hashmap) return Hashmap is
    v_Employee_Id number := p.r_Number('employee_id');
  
    r_Person_Detail Href_Person_Details%rowtype;
  begin
    r_Person_Detail := z_Href_Person_Details.Load(i_Company_Id => Ui.Company_Id,
                                                  i_Person_Id  => v_Employee_Id);
  
    if r_Person_Detail.Access_All_Employees = 'Y' then
      r_Person_Detail.Access_All_Employees := 'N';
    else
      r_Person_Detail.Access_All_Employees := 'Y';
    end if;
  
    Href_Api.Person_Detail_Save(r_Person_Detail, false);
  
    return Fazo.Zip_Map('access_all', r_Person_Detail.Access_All_Employees);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Toggle_Employee_State(p Hashmap) return Hashmap is
    v_Employee_Id             number := p.r_Number('employee_id');
    v_Location_Global_Sync_On boolean := Htt_Util.Location_Sync_Global_Load(i_Company_Id => Ui.Company_Id,
                                                                            i_Filial_Id  => Ui.Filial_Id) = 'Y';
    r_Employee                Mhr_Employees%rowtype;
  begin
    r_Employee := z_Mhr_Employees.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Employee_Id => v_Employee_Id);
  
    if r_Employee.State = 'A' then
      r_Employee.State := 'P';
    else
      r_Employee.State := 'A';
    end if;
  
    Mhr_Api.Employee_Save(r_Employee);
  
    if v_Location_Global_Sync_On then
      Htt_Api.Person_Global_Sync_All_Location(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Person_Id  => v_Employee_Id);
    end if;
  
    return Fazo.Zip_Map('state', r_Employee.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Toggle_User_State(p Hashmap) return Hashmap is
    r_Person      Mr_Natural_Persons%rowtype;
    r_User        Md_Users%rowtype;
    v_Employee_Id number := p.r_Number('employee_id');
    v_Role_Id     number;
    v_State       varchar2(1);
  begin
    if not z_Md_Users.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                 i_User_Id    => v_Employee_Id,
                                 o_Row        => r_User) then
      r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                 i_Person_Id  => v_Employee_Id);
    
      z_Md_Users.Init(p_Row        => r_User,
                      i_Company_Id => r_Person.Company_Id,
                      i_User_Id    => r_Person.Person_Id,
                      i_Name       => r_Person.Name,
                      i_User_Kind  => Md_Pref.c_Uk_Normal,
                      i_Gender     => r_Person.Gender,
                      i_State      => 'A');
    
      v_Role_Id := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                   i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
    
      Md_Api.User_Save(r_User);
    
      Md_Api.Role_Grant(i_Company_Id => r_Person.Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  
    if z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                               i_User_Id    => v_Employee_Id,
                               i_Filial_Id  => Ui.Filial_Id) then
      Md_Api.User_Remove_Filial(i_Company_Id   => Ui.Company_Id,
                                i_User_Id      => v_Employee_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Remove_Roles => false);
    
      v_State := 'P';
    else
      if r_User.State = 'P' then
        Href_Error.Raise_030(r_User.Name);
      end if;
    
      Md_Api.User_Add_Filial(i_Company_Id => Ui.Company_Id,
                             i_User_Id    => v_Employee_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    
      v_State := 'A';
    end if;
  
    return Fazo.Zip_Map('state', v_State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Photo(p Hashmap) return Hashmap is
    v_Employee_Id number := p.r_Number('employee_id');
    v_Photo_Sha   Md_Persons.Photo_Sha%type := p.r_Varchar2('photo_sha');
  
    r_Person Md_Persons%rowtype;
  begin
    r_Person := z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                  i_Person_Id  => v_Employee_Id);
  
    Md_Api.Person_Update(i_Company_Id => Ui.Company_Id,
                         i_Person_Id  => v_Employee_Id,
                         i_Photo_Sha  => Option_Varchar2(v_Photo_Sha));
  
    if p.r_Varchar2('photo_as_face_rec') = 'Y' then
      Htt_Api.Person_Photo_Update(i_Company_Id    => Ui.Company_Id,
                                  i_Person_Id     => v_Employee_Id,
                                  i_Old_Photo_Sha => r_Person.Photo_Sha,
                                  i_New_Photo_Sha => v_Photo_Sha);
    end if;
  
    return Fazo.Zip_Map('old_photo_sha',
                        r_Person.Photo_Sha,
                        'photo_sha',
                        v_Photo_Sha,
                        'is_main',
                        z_Htt_Person_Photos.Take(i_Company_Id => Ui.Company_Id, --
                        i_Person_Id => v_Employee_Id, --
                        i_Photo_Sha => v_Photo_Sha).Is_Main);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Tab_Config(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => c_Pref_Employee_Tab_Config, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Employee(p Hashmap) is
    v_Employee_Id number := p.r_Number('employee_id');
  begin
    Href_Api.Employee_Delete(i_Company_Id  => Ui.Company_Id,
                             i_Filial_Id   => Ui.Filial_Id,
                             i_Employee_Id => v_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Reasons return Fazo_Query is
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
  Function Get_Influences(p Hashmap) return Hashmap is
  begin
    return Uit_Href.Get_Influences(i_Employee_Id         => p.r_Number('employee_id'),
                                   i_Dismissal_Reason_Id => p.o_Number('dismissal_reason_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Dismiss_Employee(p Hashmap) return Hashmap is
    r_Staff          Href_Staffs%rowtype;
    v_Status         varchar2(1);
    v_Dismissal      Hpd_Pref.Dismissal_Journal_Rt;
    v_Dismissal_Date date := p.r_Date('dismissal_date');
  
    --------------------------------------------------
    Procedure Assert_Staff(o_Staff out Href_Staffs%rowtype) is
    begin
      o_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Staff_Id   => p.r_Number('staff_id'));
    
      if o_Staff.Employee_Id <> p.r_Number('employee_id') then
        b.Raise_Unauthenticated;
      end if;
    end;
  begin
    Assert_Staff(r_Staff);
  
    Hpd_Util.Dismissal_Journal_New(o_Journal         => v_Dismissal,
                                   i_Company_Id      => r_Staff.Company_Id,
                                   i_Filial_Id       => r_Staff.Filial_Id,
                                   i_Journal_Id      => Hpd_Next.Journal_Id,
                                   i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r_Staff.Company_Id,
                                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                   i_Journal_Number  => null,
                                   i_Journal_Date    => v_Dismissal_Date,
                                   i_Journal_Name    => null);
  
    Hpd_Util.Journal_Add_Dismissal(p_Journal              => v_Dismissal,
                                   i_Page_Id              => Hpd_Next.Page_Id,
                                   i_Staff_Id             => r_Staff.Staff_Id,
                                   i_Dismissal_Date       => v_Dismissal_Date,
                                   i_Dismissal_Reason_Id  => p.o_Number('dismissal_reason_id'),
                                   i_Employment_Source_Id => null,
                                   i_Based_On_Doc         => null,
                                   i_Note                 => p.o_Varchar2('note'));
  
    Hpd_Api.Dismissal_Journal_Save(v_Dismissal);
  
    Hpd_Api.Journal_Post(i_Company_Id => v_Dismissal.Company_Id,
                         i_Filial_Id  => v_Dismissal.Filial_Id,
                         i_Journal_Id => v_Dismissal.Journal_Id);
  
    v_Status := Uit_Href.Get_Staff_Status(i_Hiring_Date    => r_Staff.Hiring_Date,
                                          i_Dismissal_Date => v_Dismissal_Date,
                                          i_Date           => Trunc(sysdate));
  
    return Fazo.Zip_Map('dismissal_date',
                        v_Dismissal_Date,
                        'status',
                        v_Status,
                        'status_name',
                        Href_Util.t_Staff_Status(v_Status));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hface.Calculate_Photo_Vector(i_Person_Id  => p.r_Number('person_id'),
                                            i_Photo_Shas => p.r_Array_Varchar2('photo_shas'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Upload_Images(p Hashmap) return Hashmap is
  begin
    return p;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null,
           Reason_Type         = null;
  end;

end Ui_Vhr324;
/
