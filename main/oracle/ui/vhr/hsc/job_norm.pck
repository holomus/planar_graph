create or replace package Ui_Vhr553 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr553;
/
create or replace package body Ui_Vhr553 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.name
                       from hsc_objects q
                       join mhr_divisions w
                         on w.company_id = q.company_id
                        and w.filial_id = q.filial_id
                        and w.division_id = q.object_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('object_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

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
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('month', to_char(sysdate, Href_Pref.c_Date_Format_Month));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Norm Hsc_Job_Norms%rowtype;
    result Hashmap;
  begin
    r_Norm := z_Hsc_Job_Norms.Load(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Norm_Id    => p.r_Number('norm_id'));
  
    result := z_Hsc_Job_Norms.To_Map(r_Norm,
                                     z.Norm_Id,
                                     z.Object_Id,
                                     z.Job_Id,
                                     z.Monthly_Hours,
                                     z.Monthly_Days,
                                     z.Idle_Margin,
                                     z.Absense_Margin);
  
    Result.Put('month', to_char(r_Norm.Month, Href_Pref.c_Date_Format_Month));
    Result.Put('object_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Division_Id => r_Norm.Object_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Job_Id => r_Norm.Job_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p         Hashmap,
    i_Norm_Id number
    
  ) is
    r_Norm Hsc_Job_Norms%rowtype;
  begin
    z_Hsc_Job_Norms.Init(p_Row            => r_Norm,
                         i_Company_Id     => Ui.Company_Id,
                         i_Filial_Id      => Ui.Filial_Id,
                         i_Norm_Id        => i_Norm_Id,
                         i_Object_Id      => p.r_Number('object_id'),
                         i_Division_Id    => null,
                         i_Job_Id         => p.r_Number('job_id'),
                         i_Month          => p.r_Date('month', Href_Pref.c_Date_Format_Month),
                         i_Monthly_Hours  => p.r_Number('monthly_hours'),
                         i_Monthly_Days   => p.r_Number('monthly_days'),
                         i_Idle_Margin    => p.r_Number('idle_margin'),
                         i_Absense_Margin => p.r_Number('absense_margin'));
  
    Hsc_Api.Job_Norm_Save(r_Norm);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(p, Hsc_Next.Job_Norm_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Norm Hsc_Job_Norms%rowtype;
  begin
    r_Norm := z_Hsc_Job_Norms.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Norm_Id    => p.r_Number('norm_id'));
  
    save(p, r_Norm.Norm_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           Parent_Id   = null,
           State       = null;
    update Hsc_Objects
       set Company_Id = null,
           Filial_Id  = null,
           Object_Id  = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr553;
/
