create or replace package Ui_Vhr338 is
  ----------------------------------------------------------------------------------------------------
  Function List_Jobs(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Job(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Job(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Job(p Hashmap);
end Ui_Vhr338;
/
create or replace package body Ui_Vhr338 is
  ----------------------------------------------------------------------------------------------------
  Function List_Jobs(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Array Array_Number := Nvl(p.o_Array_Number('job_ids'), Array_Number());
    v_Cnt   number := v_Array.Count;
    v_Jobs  Glist := Glist();
    v_Job   Gmap;
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for c in (select *
                from (select s.*
                        from Mhr_Jobs s
                       where s.Company_Id = v_Company_Id
                         and s.Filial_Id = v_Filial_Id
                         and (v_Cnt = 0 or s.Job_Id member of v_Array)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Job := Gmap();
    
      v_Job.Put('job_id', c.Job_Id);
      v_Job.Put('name', c.Name);
      v_Job.Put('code', c.Code);
      v_Job.Put('state', c.State);
    
      v_Last_Id := c.Modified_Id;
    
      v_Jobs.Push(v_Job.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Jobs, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p     Hashmap,
    i_Job Mhr_Jobs%rowtype
  ) is
    r_Job Mhr_Jobs%rowtype := i_Job;
  begin
    r_Job.Name              := p.o_Varchar2('name');
    r_Job.Code              := p.o_Varchar2('code');
    r_Job.State             := Nvl(r_Job.State, 'A');
    r_Job.c_Divisions_Exist := Nvl(r_Job.c_Divisions_Exist, 'N');
  
    Mhr_Api.Job_Save(i_Job => r_Job);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Job(p Hashmap) return Hashmap is
    r_Job Mhr_Jobs%rowtype;
  begin
    r_Job.Company_Id := Ui.Company_Id;
    r_Job.Filial_Id  := Ui.Filial_Id;
    r_Job.Job_Id     := Mhr_Next.Job_Id;
  
    save(p, r_Job);
  
    return Fazo.Zip_Map('job_id', r_Job.Job_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Job(p Hashmap) is
    r_Job Mhr_Jobs%rowtype;
  begin
    r_Job := z_Mhr_Jobs.Lock_Load(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Job_Id     => p.r_Number('job_id'));
  
    save(p, r_Job);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Job(p Hashmap) is
  begin
    Mhr_Api.Job_Delete(i_Company_Id => Ui.Company_Id,
                       i_Filial_Id  => Ui.Filial_Id,
                       i_Job_Id     => p.r_Number('job_id'));
  end;

end Ui_Vhr338;
/
