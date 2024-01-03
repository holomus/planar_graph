create or replace package Ui_Vhr541 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr541;
/
create or replace package body Ui_Vhr541 is
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
                             'hiring_date',
                             p.r_Date('hiring_date'));
  
    v_Query := 'select p.*,
                       q.division_id,
                       q.job_id,
                       q.name,
                       (select min(fte)
                          from hrm_robot_turnover rob
                         where rob.company_id = p.company_id
                           and rob.filial_id = p.filial_id
                           and rob.robot_id = p.robot_id
                           and (rob.period >= :hiring_date or
                               rob.period = (select max(rt.period)
                                                from hrm_robot_turnover rt
                                               where rt.company_id = rob.company_id
                                                 and rt.filial_id = rob.filial_id
                                                 and rt.robot_id = rob.robot_id
                                                 and rt.period <= :hiring_date))) fte
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
  Function References(i_Region_Id number := null) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    Result.Put('pg_female', Md_Pref.c_Pg_Female);
    Result.Put('genders', Fazo.Zip_Matrix_Transposed(Md_Util.Person_Genders));
    Result.Put('crs', Uit_Href.Col_Required_Settings);
    Result.Put('employment_types', Fazo.Zip_Matrix(Hpd_Util.Employment_Types));
  
    select Array_Varchar2(t.Region_Id, t.Name, t.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and (t.State = 'A' or t.Region_Id = i_Region_Id)
     order by t.Name;
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('gender', Md_Pref.c_Pg_Male, 'hiring_date', Trunc(sysdate));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Application Hpd_Applications%rowtype;
    r_Hiring      Hpd_Application_Hirings%rowtype;
    result        Hashmap;
  begin
    r_Application := z_Hpd_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Application_Id => p.r_Number('application_id'));
  
    result := z_Hpd_Applications.To_Map(r_Application,
                                        z.Application_Id,
                                        z.Application_Number,
                                        z.Application_Date);
  
    r_Hiring := z_Hpd_Application_Hirings.Load(i_Company_Id     => Ui.Company_Id,
                                               i_Filial_Id      => Ui.Filial_Id,
                                               i_Application_Id => r_Application.Application_Id);
  
    Result.Put_All(z_Hpd_Application_Hirings.To_Map(r_Hiring,
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
    Result.Put('robot_name',
               z_Mrf_Robots.Load(i_Company_Id => r_Hiring.Company_Id, i_Filial_Id => r_Hiring.Filial_Id, i_Robot_Id => r_Hiring.Robot_Id).Name);
  
    Result.Put('employment_type_name', Hpd_Util.t_Employment_Type(r_Hiring.Employment_Type));
  
    Result.Put('references', References(r_Hiring.Region_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p                Hashmap,
    i_Application_Id number
  ) return Hashmap is
    v_Application Hpd_Pref.Application_Hiring_Rt;
    r_Data        Hpd_Applications%rowtype;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    Hpd_Util.Application_Hiring_New(o_Application     => v_Application,
                                    i_Company_Id      => Ui.Company_Id,
                                    i_Filial_Id       => Ui.Filial_Id,
                                    i_Application_Id  => i_Application_Id,
                                    i_Hiring_Date     => p.r_Date('hiring_date'),
                                    i_Robot_Id        => p.r_Number('robot_id'),
                                    i_Note            => p.o_Varchar2('note'),
                                    i_First_Name      => p.r_Varchar2('first_name'),
                                    i_Last_Name       => p.r_Varchar2('last_name'),
                                    i_Middle_Name     => p.o_Varchar2('middle_name'),
                                    i_Birthday        => p.o_Date('birthday'),
                                    i_Gender          => p.r_Varchar2('gender'),
                                    i_Phone           => p.o_Varchar2('phone'),
                                    i_Email           => p.o_Varchar2('email'),
                                    i_Photo_Sha       => p.o_Varchar2('photo_sha'),
                                    i_Address         => p.o_Varchar2('address'),
                                    i_Legal_Address   => p.o_Varchar2('legal_address'),
                                    i_Region_Id       => p.o_Number('region_id'),
                                    i_Passport_Series => p.o_Varchar2('passport_series'),
                                    i_Passport_Number => p.o_Varchar2('passport_number'),
                                    i_Npin            => p.o_Varchar2('npin'),
                                    i_Iapa            => p.o_Varchar2('iapa'),
                                    i_Employment_Type => p.r_Varchar2('employment_type'));
  
    Hpd_Api.Application_Hiring_Save(v_Application);
  
    -- notification send after saving application
    r_Data := z_Hpd_Applications.Lock_Load(i_Company_Id     => v_Application.Company_Id,
                                           i_Filial_Id      => v_Application.Filial_Id,
                                           i_Application_Id => v_Application.Application_Id);
  
    v_Grant_Part := Hpd_Pref.c_App_Grant_Part_Hiring;
  
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
    z_Hpd_Application_Hirings.Lock_Only(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => v_Application_Id);
  
    return save(p, v_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
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

end Ui_Vhr541;
/
