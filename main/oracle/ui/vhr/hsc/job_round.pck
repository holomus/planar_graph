create or replace package Ui_Vhr645 is
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
end Ui_Vhr645;
/
create or replace package body Ui_Vhr645 is
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
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('round_model_types', Fazo.Zip_Matrix(Mkr_Util.Round_Model_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('round_model_type', 'R');
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Round Hsc_Job_Rounds%rowtype;
    result  Hashmap;
  begin
    r_Round := z_Hsc_Job_Rounds.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Round_Id   => p.r_Number('round_id'));
  
    result := z_Hsc_Job_Rounds.To_Map(r_Round,
                                      z.Round_Id,
                                      z.Object_Id,
                                      z.Job_Id,
                                      z.Monthly_Hours,
                                      z.Monthly_Days,
                                      z.Idle_Margin,
                                      z.Absense_Margin,
                                      z.Round_Model_Type);
  
    Result.Put('object_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Round.Company_Id, --
               i_Filial_Id => r_Round.Filial_Id, i_Division_Id => r_Round.Object_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Round.Company_Id, --
               i_Filial_Id => r_Round.Filial_Id, i_Job_Id => r_Round.Job_Id).Name);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p          Hashmap,
    i_Round_Id number
    
  ) is
    r_Round Hsc_Job_Rounds%rowtype;
  begin
    z_Hsc_Job_Rounds.Init(p_Row              => r_Round,
                          i_Company_Id       => Ui.Company_Id,
                          i_Filial_Id        => Ui.Filial_Id,
                          i_Round_Id         => i_Round_Id,
                          i_Object_Id        => p.r_Number('object_id'),
                          i_Division_Id      => null,
                          i_Job_Id           => p.r_Number('job_id'),
                          i_Round_Model_Type => p.r_Varchar2('round_model_type'));
  
    Hsc_Api.Job_Round_Save(r_Round);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(p, Hsc_Next.Job_Round_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Round Hsc_Job_Rounds%rowtype;
  begin
    r_Round := z_Hsc_Job_Rounds.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Round_Id   => p.r_Number('round_id'));
  
    save(p, r_Round.Round_Id);
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

end Ui_Vhr645;
/
