create or replace package Ui_Vhr546 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Journal(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_New_To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_From_Waiting_To_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_In_Progress_To_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Canceled(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_In_Progress(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Completed(p Hashmap);
end Ui_Vhr546;
/
create or replace package body Ui_Vhr546 is
  ----------------------------------------------------------------------------------------------------
  Function Grant_Has(i_Grant varchar2) return varchar2 is
  begin
    return Uit_Hpd.Application_Grant_Has(Hpd_Pref.c_App_Grant_Part_Hiring || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Grant(i_Grant varchar2) is
  begin
    Uit_Hpd.Application_Assert_Grant(Hpd_Pref.c_App_Grant_Part_Hiring || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    q Fazo_Query;
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    q := Fazo_Query('select t.person_id,
                            t.name,
                            case
                              when exists (select 1
                                      from mhr_employees k
                                     where k.company_id = t.company_id
                                       and k.filial_id = :filial_id
                                       and k.employee_id = t.person_id) then
                               ''Y''
                              else
                               ''N''
                            end is_attached
                       from mr_natural_persons t
                      where t.company_id = :company_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name', 'is_attached');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('genders', Fazo.Zip_Matrix_Transposed(Md_Util.Person_Genders));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Application Hpd_Applications%rowtype;
    r_Hiring      Hpd_Application_Hirings%rowtype;
    result        Hashmap;
  begin
    r_Application.Application_Id := p.r_Number('application_id');
  
    r_Application := z_Hpd_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Application_Id => r_Application.Application_Id);
  
    result := z_Hpd_Applications.To_Map(r_Application,
                                        z.Application_Id,
                                        z.Application_Number,
                                        z.Application_Date,
                                        z.Status,
                                        z.Closing_Note,
                                        z.Created_On,
                                        z.Modified_On);
  
    Result.Put('status_name', Hpd_Util.t_Application_Status(r_Application.Status));
    Result.Put('created_by_name',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => r_Application.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => r_Application.Modified_By).Name);
  
    r_Hiring := z_Hpd_Application_Hirings.Load(i_Company_Id     => Ui.Company_Id,
                                               i_Filial_Id      => Ui.Filial_Id,
                                               i_Application_Id => r_Application.Application_Id);
  
    Result.Put_All(z_Hpd_Application_Hirings.To_Map(r_Hiring,
                                                    z.Employee_Id,
                                                    z.Hiring_Date,
                                                    z.Robot_Id,
                                                    z.Note,
                                                    z.First_Name,
                                                    z.Last_Name,
                                                    z.Middle_Name,
                                                    z.Birthday,
                                                    z.Gender,
                                                    z.Phone,
                                                    z.Email,
                                                    z.Photo_Sha,
                                                    z.Address,
                                                    z.Legal_Address,
                                                    z.Region_Id,
                                                    z.Passport_Series,
                                                    z.Passport_Number,
                                                    z.Npin,
                                                    z.Iapa,
                                                    z.Employment_Type));
    Result.Put('employee_name',
               z_Md_Persons.Take(i_Company_Id => Ui.Company_Id, i_Person_Id => r_Hiring.Employee_Id).Name);
    Result.Put('robot_name',
               z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => r_Hiring.Robot_Id).Name);
    Result.Put('employment_type_name', Hpd_Util.t_Employment_Type(r_Hiring.Employment_Type));
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => r_Hiring.Region_Id).Name);
    Result.Put('journal_id',
               z_Hpd_Application_Journals.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Application_Id => r_Application.Application_Id).Journal_Id);
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring));
  
    Result.Put('grant_has_applicant', Grant_Has(Hpd_Pref.c_App_Grantee_Applicant));
    Result.Put('grant_has_manager', Grant_Has(Hpd_Pref.c_App_Grantee_Manager));
    Result.Put('grant_has_hr', Grant_Has(Hpd_Pref.c_App_Grantee_Hr));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Employee(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Bind_Employee(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Application_Id => p.r_Number('application_id'),
                                      i_Employee_Id    => p.o_Number('employee_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Journal(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    -- todo: journal yaratish va bind qilish bitta sessiyada bo'lishini ta'minlash kerak
    Hpd_Api.Application_Bind_Journal(i_Company_Id     => Ui.Company_Id,
                                     i_Filial_Id      => Ui.Filial_Id,
                                     i_Application_Id => p.r_Number('application_id'),
                                     i_Journal_Id     => p.r_Number('journal_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap) is
    r_Person   Mr_Natural_Persons%rowtype;
    r_Employee Mhr_Employees%rowtype;
    r_User     Md_Users%rowtype;
    v_Role_Id  number;
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Person_Id  => p.r_Number('person_id'));
  
    Mrf_Api.Filial_Add_Person(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Person_Id  => r_Person.Person_Id,
                              i_State      => r_Person.State);
  
    if not z_Mhr_Employees.Exist(i_Company_Id  => Ui.Company_Id,
                                 i_Filial_Id   => Ui.Filial_Id,
                                 i_Employee_Id => r_Person.Person_Id) then
    
      r_Employee.Company_Id  := Ui.Company_Id;
      r_Employee.Filial_Id   := Ui.Filial_Id;
      r_Employee.Employee_Id := r_Person.Person_Id;
      r_Employee.State       := 'A';
    
      Mhr_Api.Employee_Save(i_Employee => r_Employee);
    end if;
  
    if not z_Md_Users.Exist(i_Company_Id => r_Person.Company_Id,
                            i_User_Id    => r_Person.Person_Id,
                            o_Row        => r_User) then
      z_Md_Users.Init(p_Row        => r_User,
                      i_Company_Id => r_Person.Company_Id,
                      i_User_Id    => r_Person.Person_Id,
                      i_Name       => r_Person.Name,
                      i_User_Kind  => Md_Pref.c_Uk_Normal,
                      i_Gender     => r_Person.Gender,
                      i_State      => 'A');
    
      Md_Api.User_Save(r_User);
    end if;
  
    if not z_Md_User_Filials.Exist(i_Company_Id => r_Person.Company_Id,
                                   i_User_Id    => r_Person.Person_Id,
                                   i_Filial_Id  => Ui.Filial_Id) then
      Md_Api.User_Add_Filial(i_Company_Id => r_Person.Company_Id,
                             i_User_Id    => r_Person.Person_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => r_Person.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if not z_Md_User_Roles.Exist(i_Company_Id => r_Person.Company_Id,
                                 i_User_Id    => r_Person.Person_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Role_Id    => v_Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => r_Person.Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_New_To_Waiting(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Api.Application_Status_Waiting(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Application_Id => p.r_Number('application_id'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Change_Status_To_Waiting(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Waiting(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_New(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Api.Application_Status_New(i_Company_Id     => Ui.Company_Id,
                                   i_Filial_Id      => Ui.Filial_Id,
                                   i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Status_From_Waiting_To_Approved(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Approved(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_From_In_Progress_To_Approved(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_Approved(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Canceled(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Canceled(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => p.r_Number('application_id'),
                                        i_Closing_Note   => p.o_Varchar2('closing_note'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_In_Progress(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_In_Progress(i_Company_Id     => Ui.Company_Id,
                                           i_Filial_Id      => Ui.Filial_Id,
                                           i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Status_To_Completed(p Hashmap) is
  begin
    Assert_Grant(Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_Completed(i_Company_Id     => Ui.Company_Id,
                                         i_Filial_Id      => Ui.Filial_Id,
                                         i_Application_Id => p.r_Number('application_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr546;
/
