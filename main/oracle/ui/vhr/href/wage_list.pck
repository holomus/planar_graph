create or replace package Ui_Vhr143 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr143;
/
create or replace package body Ui_Vhr143 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_wages',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('wage_id', 'job_id', 'rank_id', 'wage_begin', 'wage_end');
  
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Wage_Ids Array_Number := Fazo.Sort(p.r_Array_Number('wage_id'));
  begin
    for i in 1 .. v_Wage_Ids.Count
    loop
      Href_Api.Wage_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Wage_Id    => v_Wage_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Wages
       set Company_Id = null,
           Filial_Id  = null,
           Wage_Id    = null,
           Job_Id     = null,
           Rank_Id    = null,
           Wage_Begin = null,
           Wage_End   = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
  end;

end Ui_Vhr143;
/
