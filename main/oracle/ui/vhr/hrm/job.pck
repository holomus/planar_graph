create or replace package Ui_Vhr659 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Coa return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Origins(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Roles return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Coa_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Ref_Name(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr659;
/
create or replace package body Ui_Vhr659 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Coa return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_coa', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('coa_id');
    q.Varchar2_Field('gen_name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_job_groups', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Origins(p Hashmap) return Fazo_Query is
  begin
    return Mkr_Util.Origin_Query(i_Ref_Origin_Id => p.r_Number('ref_origin_id'),
                                 i_Params        => Fazo.Zip_Map('company_id',
                                                                 Ui.Company_Id,
                                                                 'filial_id',
                                                                 Ui.Filial_Id,
                                                                 'user_id',
                                                                 Ui.User_Id,
                                                                 'project_code',
                                                                 Ui.Project_Code,
                                                                 'manual_data_access_value',
                                                                 Mrf_Pref.c_Pref_Da_Show_All));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Roles return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_roles', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('role_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Coa_Info(p Hashmap) return Hashmap is
  begin
    return Mkr_Util.Coa_Info(i_Company_Id => Ui.Company_Id, --
                             i_Coa_Id     => p.r_Number('coa_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Ref_Name(p Hashmap) return varchar2 is
  begin
    return Mk_Util.Ref_Name(i_Company_Id => Ui.Company_Id,
                            i_Ref_Type   => p.r_Number('ref_type'),
                            i_Ref_Id     => p.r_Number('ref_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Job_Roles(i_Job_Id number) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Role_Id, t.Name)
      bulk collect
      into v_Matrix
      from Md_Roles t
     where t.Company_Id = Ui.Company_Id
       and exists (select 1
              from Hrm_Job_Roles q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Job_Id = i_Job_Id
               and q.Role_Id = t.Role_Id)
     order by t.Order_No;
  
    Result.Put('roles', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap;
  begin
    select Array_Varchar2(q.Division_Id, q.Name, q.Parent_Id)
      bulk collect
      into v_Matrix
      from Mhr_Divisions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.State = 'A'
     order by Lower(q.Name);
  
    result := Fazo.Zip_Map('origin_kind_query',
                           Mkr_Pref.c_Ok_Query,
                           'origin_kind_date',
                           Mkr_Pref.c_Ok_Date,
                           'origin_kind_number',
                           Mkr_Pref.c_Ok_Number);
  
    Result.Put('divisions', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('operation_kinds', Fazo.Zip_Matrix(Mpr_Util.Operation_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap;
  begin
    Result.Put('data', Fazo.Zip_Map('state', 'A'));
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data         Mhr_Jobs%rowtype;
    v_Division_Ids Array_Number;
    v_Coa_Info     Hashmap;
    v_Data         Hashmap;
    result         Hashmap := Hashmap;
  begin
    r_Data := z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Job_Id     => p.r_Number('job_id'));
  
    v_Data := z_Mhr_Jobs.To_Map(r_Data,
                                z.Job_Id,
                                z.Name,
                                z.Job_Group_Id,
                                z.Expense_Coa_Id,
                                z.Code,
                                z.State);
    v_Data.Put('job_group_name',
               z_Mhr_Job_Groups.Take(i_Company_Id => r_Data.Company_Id, i_Job_Group_Id => r_Data.Job_Group_Id).Name);
    v_Data.Put('expense_coa_name',
               z_Mk_Coa.Take(i_Company_Id => r_Data.Company_Id, i_Coa_Id => r_Data.Expense_Coa_Id).Gen_Name);
  
    v_Coa_Info := Mkr_Util.Coa_Info(i_Company_Id => Ui.Company_Id,
                                    i_Coa_Id     => r_Data.Expense_Coa_Id,
                                    i_Ref_Set    => r_Data.Expense_Ref_Set);
    v_Data.Put('expense_ref_types', Nvl(v_Coa_Info.o_Arraylist('ref_types'), Arraylist()));
  
    select q.Division_Id
      bulk collect
      into v_Division_Ids
      from Mhr_Job_Divisions q
     where q.Company_Id = r_Data.Company_Id
       and q.Job_Id = r_Data.Job_Id;
  
    v_Data.Put('division_ids', v_Division_Ids);
    v_Data.Put_All(Load_Job_Roles(r_Data.Job_Id));
  
    Result.Put('data', v_Data);
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data         Mhr_Jobs%rowtype;
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Role_Ids     Array_Number := Nvl(p.o_Array_Number('role_ids'), Array_Number());
  begin
    r_Data := z_Mhr_Jobs.To_Row(p,
                                z.Name,
                                z.Code,
                                z.Division_Id,
                                z.Expense_Coa_Id,
                                z.Job_Group_Id,
                                z.State);
  
    r_Data.Company_Id        := Ui.Company_Id;
    r_Data.Filial_Id         := Ui.Filial_Id;
    r_Data.Job_Id            := Mhr_Next.Job_Id;
    r_Data.c_Divisions_Exist := 'N';
  
    Mhr_Api.Job_Save(r_Data);
  
    for i in 1 .. v_Division_Ids.Count
    loop
      Mhr_Api.Job_Attach_Division(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Job_Id      => r_Data.Job_Id,
                                  i_Division_Id => v_Division_Ids(i));
    end loop;
  
    Hrm_Api.Job_Roles_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Job_Id     => r_Data.Job_Id,
                           i_Role_Ids   => v_Role_Ids);
  
    return Fazo.Zip_Map('job_id', r_Data.Job_Id, 'name', r_Data.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data         Mhr_Jobs%rowtype;
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Role_Ids     Array_Number := Nvl(p.o_Array_Number('role_ids'), Array_Number());
  begin
    r_Data := z_Mhr_Jobs.Lock_Load(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Job_Id     => p.r_Number('job_id'));
  
    z_Mhr_Jobs.To_Row(r_Data,
                      p,
                      z.Job_Id,
                      z.Name,
                      z.Job_Group_Id,
                      z.Expense_Coa_Id,
                      z.Code,
                      z.State);
  
    Mhr_Api.Job_Save(r_Data);
  
    for i in 1 .. v_Division_Ids.Count
    loop
      Mhr_Api.Job_Attach_Division(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Job_Id      => r_Data.Job_Id,
                                  i_Division_Id => v_Division_Ids(i));
    end loop;
  
    for r in (select *
                from Mhr_Job_Divisions q
               where q.Company_Id = r_Data.Company_Id
                 and q.Filial_Id = r_Data.Filial_Id
                 and q.Job_Id = r_Data.Job_Id
                 and q.Division_Id not member of v_Division_Ids)
    loop
      Mhr_Api.Job_Detach_Division(i_Company_Id  => r.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Job_Id      => r.Job_Id,
                                  i_Division_Id => r.Division_Id);
    end loop;
  
    Hrm_Api.Job_Roles_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Job_Id     => r_Data.Job_Id,
                           i_Role_Ids   => v_Role_Ids);
  
    return Fazo.Zip_Map('job_id', r_Data.Job_Id, 'name', r_Data.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           Gen_Name   = null,
           State      = null;
  
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null,
           State        = null;
  
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Parent_Id   = null,
           name        = null,
           State       = null;
  
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Job_Id      = null,
           Division_Id = null;
  
    update Md_Roles
       set Company_Id = null,
           Role_Id    = null,
           name       = null,
           State      = null,
           Order_No   = null;
  end;

end Ui_Vhr659;
/
