create or replace package Ui_Vhr529 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Detach(p Hashmap);
end Ui_Vhr529;
/
create or replace package body Ui_Vhr529 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query varchar2(4000);
    q       Fazo_Query;
  begin
    v_Query := 'select *
                  from mhr_jobs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = :state
                   and ';
  
    if p.o_Varchar2('attached') = 'N' then
      v_Query := v_Query || --
                 'not exists (select 1 
                         from htm_experience_jobs w
                        where w.company_id = q.company_id 
                          and w.filial_id = q.filial_id 
                          and w.job_id = q.job_id)';
    else
      v_Query := v_Query || --
                 'exists (select 1
                   from htm_experience_jobs w
                  where w.company_id = q.company_id
                    and w.filial_id = q.filial_id
                    and w.experience_id = :experience_id
                    and w.job_id = q.job_id)';
    end if;
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'experience_id',
                                 p.r_Number('experience_id'),
                                 'state',
                                 'A'));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Attach(p Hashmap) is
    v_Job_Ids       Array_Number := Fazo.Sort(p.r_Array_Number('job_id'));
    v_Experience_Id number := p.r_Number('experience_id');
  begin
    for i in 1 .. v_Job_Ids.Count
    loop
      Htm_Api.Experience_Add_Job(i_Company_Id    => Ui.Company_Id,
                                 i_Filial_Id     => Ui.Filial_Id,
                                 i_Experience_Id => v_Experience_Id,
                                 i_Job_Id        => v_Job_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Detach(p Hashmap) is
    v_Job_Ids       Array_Number := Fazo.Sort(p.r_Array_Number('job_id'));
    v_Experience_Id number := p.r_Number('experience_id');
  begin
    for i in 1 .. v_Job_Ids.Count
    loop
      Htm_Api.Experience_Remove_Job(i_Company_Id    => Ui.Company_Id,
                                    i_Filial_Id     => Ui.Filial_Id,
                                    i_Experience_Id => v_Experience_Id,
                                    i_Job_Id        => v_Job_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Htm_Experience_Jobs
       set Company_Id    = null,
           Filial_Id     = null,
           Experience_Id = null,
           Job_Id        = null;
  end;

end Ui_Vhr529;
/
