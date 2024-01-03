create or replace package Ui_Vhr586 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Job return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr586;
/
create or replace package body Ui_Vhr586 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Job return Fazo_Query is
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
  Function Add_Model return Hashmap is
  begin
    return References;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Application Hrec_Applications%rowtype;
    result        Hashmap;
  begin
    r_Application := z_Hrec_Applications.Load(i_Company_Id     => Ui.Company_Id,
                                              i_Filial_Id      => Ui.Filial_Id,
                                              i_Application_Id => p.r_Number('application_id'));
  
    result := z_Hrec_Applications.To_Map(r_Application,
                                         z.Application_Id,
                                         z.Application_Number,
                                         z.Division_Id,
                                         z.Job_Id,
                                         z.Quantity,
                                         z.Wage,
                                         z.Responsibilities,
                                         z.Requirements,
                                         z.Note);
  
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Application.Company_Id, i_Filial_Id => r_Application.Filial_Id, i_Job_Id => r_Application.Job_Id).Name);
    Result.Put_All(References(r_Application.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    p                Hashmap,
    i_Application_Id number
  ) return Hashmap is
    v_Application Hrec_Pref.Application_Rt;
  begin
    Hrec_Util.Application_New(o_Application        => v_Application,
                              i_Company_Id         => Ui.Company_Id,
                              i_Filial_Id          => Ui.Filial_Id,
                              i_Application_Id     => i_Application_Id,
                              i_Application_Number => p.o_Varchar2('application_number'),
                              i_Division_Id        => p.r_Number('division_id'),
                              i_Job_Id             => p.r_Number('job_id'),
                              i_Quantity           => p.r_Number('quantity'),
                              i_Wage               => p.o_Number('wage'),
                              i_Responsibilities   => p.o_Varchar2('responsibilities'),
                              i_Requirements       => p.o_Varchar2('requirements'),
                              i_Status             => p.r_Varchar2('status'),
                              i_Note               => p.o_Varchar2('note'));
  
    Hrec_Api.Application_Save(v_Application);
  
    return Fazo.Zip_Map('application_id', i_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hrec_Next.Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Application Hrec_Applications%rowtype;
  begin
    r_Application := z_Hrec_Applications.Lock_Load(i_Company_Id     => Ui.Company_Id,
                                                   i_Filial_Id      => Ui.Filial_Id,
                                                   i_Application_Id => p.r_Number('application_id'));
  
    return save(p, r_Application.Application_Id);
  end;

end Ui_Vhr586;
/
