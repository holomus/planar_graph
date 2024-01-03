create or replace package Ui_Vhr540 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Modal return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr540;
/
create or replace package body Ui_Vhr540 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id => i_Division_Id)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Modal return Hashmap is
    result Hashmap := Hashmap();
  begin
    result := Fazo.Zip_Map('opened_date', Trunc(sysdate), 'quantity', 1);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Application Hpd_Applications%rowtype;
    r_Robot       Hpd_Application_Create_Robots%rowtype;
    result        Hashmap;
  begin
    r_Application := z_Hpd_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Application_Id => p.r_Number('application_id'));
  
    result := z_Hpd_Applications.To_Map(r_Application,
                                        z.Application_Id,
                                        z.Application_Number,
                                        z.Application_Date,
                                        z.Status);
  
    r_Robot := z_Hpd_Application_Create_Robots.Load(i_Company_Id     => r_Application.Company_Id,
                                                    i_Filial_Id      => r_Application.Filial_Id,
                                                    i_Application_Id => r_Application.Application_Id);
  
    Result.Put_All(z_Hpd_Application_Create_Robots.To_Map(r_Robot,
                                                          z.Name,
                                                          z.Opened_Date,
                                                          z.Division_Id,
                                                          z.Job_Id,
                                                          z.Quantity,
                                                          z.Note));
  
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Division_Id => r_Robot.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Job_Id => r_Robot.Job_Id).Name);
    Result.Put('references', References(r_Robot.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p                Hashmap,
    i_Application_Id number
  ) return Hashmap is
    v_Application Hpd_Pref.Application_Create_Robot_Rt;
    r_Data        Hpd_Applications%rowtype;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    Hpd_Util.Application_Create_Robot_New(o_Application    => v_Application,
                                          i_Company_Id     => Ui.Company_Id,
                                          i_Filial_Id      => Ui.Filial_Id,
                                          i_Application_Id => i_Application_Id,
                                          i_Name           => p.r_Varchar2('name'),
                                          i_Opened_Date    => p.r_Date('opened_date'),
                                          i_Division_Id    => p.r_Number('division_id'),
                                          i_Job_Id         => p.r_Number('job_id'),
                                          i_Quantity       => p.r_Number('quantity'),
                                          i_Note           => p.o_Varchar2('note'));
  
    Hpd_Api.Application_Create_Robot_Save(v_Application);
  
    -- notification send after saving application
    r_Data := z_Hpd_Applications.Lock_Load(i_Company_Id     => v_Application.Company_Id,
                                           i_Filial_Id      => v_Application.Filial_Id,
                                           i_Application_Id => v_Application.Application_Id);
  
    v_Grant_Part := Hpd_Pref.c_App_Grant_Part_Create_Robot;
  
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
    z_Hpd_Application_Create_Robots.Lock_Only(i_Company_Id     => Ui.Company_Id,
                                              i_Filial_Id      => Ui.Filial_Id,
                                              i_Application_Id => v_Application_Id);
  
    return save(p, v_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr540;
/
