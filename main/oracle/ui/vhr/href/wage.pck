create or replace package Ui_Vhr144 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr144;
/
create or replace package body Ui_Vhr144 is
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
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_ranks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('rank_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Wages%rowtype;
    result Hashmap;
  begin
    r_Data := z_Href_Wages.Load(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Wage_Id    => p.r_Number('wage_id'));
  
    result := z_Href_Wages.To_Map(r_Data, z.Wage_Id, z.Job_Id, z.Rank_Id, z.Wage_Begin, z.Wage_End);
  
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Job_Id => r_Data.Job_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Rank_Id => r_Data.Rank_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Wages%rowtype;
  begin
    r_Data            := z_Href_Wages.To_Row(p, z.Job_Id, z.Rank_Id, z.Wage_Begin, z.Wage_End);
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Wage_Id    := Href_Next.Wage_Id;
  
    if r_Data.Wage_End is null then
      r_Data.Wage_End := r_Data.Wage_Begin;
    end if;
  
    Href_Api.Wage_Save(r_Data);
  
    return z_Href_Wages.To_Map(r_Data, z.Wage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Wages%rowtype;
  begin
    r_Data := z_Href_Wages.Lock_Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Wage_Id    => p.r_Number('wage_id'));
  
    z_Href_Wages.To_Row(r_Data, p, z.Job_Id, z.Rank_Id, z.Wage_Begin, z.Wage_End);
  
    if r_Data.Wage_End is null then
      r_Data.Wage_End := r_Data.Wage_Begin;
    end if;
  
    Href_Api.Wage_Save(r_Data);
  
    return z_Href_Wages.To_Map(r_Data, z.Wage_Id, z.Wage_Begin);
  end;

end Ui_Vhr144;
/
