create or replace package Ui_Vhr495 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Processes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Actions(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr495;
/
create or replace package body Ui_Vhr495 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Objects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_divisions t
                      where t.company_id = :company_id
                        and t.filial_id = :filial_id
                        and t.state = :state
                        and exists (select 1
                               from hsc_object_groups s
                              where s.company_id = t.company_id
                                and s.filial_id = t.filial_id
                                and s.division_group_id = t.division_group_id)',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('division_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_areas',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('area_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Processes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_processes',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('process_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Actions(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_process_actions',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'process_id',
                                 p.r_Number('process_id'),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('action_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_drivers',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('driver_id');
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
  begin
    return Fazo.Zip_Map('driver_constant_id',
                        Hsc_Util.Driver_Constant_Id(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Object_Id number := p.o_Number('object_id');
    result      Hashmap := Hashmap();
  begin
    if v_Object_Id is not null then
      Result.Put('object_id', v_Object_Id);
      Result.Put('object_name',
                 z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, --
                 i_Filial_Id => Ui.Filial_Id, i_Division_Id => v_Object_Id).Name);
    end if;
  
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Norm   Hsc_Object_Norms%rowtype;
    v_Matrix Matrix_Varchar2;
    result   Hashmap;
  begin
    r_Norm := z_Hsc_Object_Norms.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Norm_Id    => p.r_Number('norm_id'));
  
    result := z_Hsc_Object_Norms.To_Map(r_Norm,
                                        z.Object_Id,
                                        z.Norm_Id,
                                        z.Process_Id,
                                        z.Action_Id,
                                        z.Driver_Id,
                                        z.Area_Id,
                                        z.Job_Id,
                                        z.Time_Value,
                                        z.Action_Period);
  
    Result.Put('object_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Division_Id => r_Norm.Object_Id).Name);
    Result.Put('process_name',
               z_Hsc_Processes.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Process_Id => r_Norm.Process_Id).Name);
    Result.Put('action_name',
               z_Hsc_Process_Actions.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Action_Id => r_Norm.Action_Id).Name);
    Result.Put('driver_name',
               z_Hsc_Drivers.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Driver_Id => r_Norm.Driver_Id).Name);
    Result.Put('area_name',
               z_Hsc_Areas.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Area_Id => r_Norm.Area_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Norm.Company_Id, --
               i_Filial_Id => r_Norm.Filial_Id, i_Job_Id => r_Norm.Job_Id).Name);
  
    select Array_Varchar2(t.Day_No, t.Frequency)
      bulk collect
      into v_Matrix
      from Hsc_Object_Norm_Actions t
     where t.Company_Id = r_Norm.Company_Id
       and t.Filial_Id = r_Norm.Filial_Id
       and t.Norm_Id = r_Norm.Norm_Id;
  
    Result.Put('actions', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Norm_Id number,
    p         Hashmap
  ) is
    v_Norm       Hsc_Pref.Object_Norm_Rt;
    v_Object_Ids Array_Number;
    v_Actions    Arraylist;
    v_Action     Hashmap;
  begin
    Hsc_Util.Object_Norm_New(o_Norm          => v_Norm,
                             i_Company_Id    => Ui.Company_Id,
                             i_Filial_Id     => Ui.Filial_Id,
                             i_Object_Id     => p.o_Number('object_id'),
                             i_Norm_Id       => i_Norm_Id,
                             i_Process_Id    => p.r_Number('process_id'),
                             i_Action_Id     => p.r_Number('action_id'),
                             i_Driver_Id     => p.r_Number('driver_id'),
                             i_Area_Id       => p.r_Number('area_id'),
                             i_Division_Id   => null,
                             i_Job_Id        => p.r_Number('job_id'),
                             i_Time_Value    => p.r_Number('time_value'),
                             i_Action_Period => p.o_Varchar2('action_period'));
  
    v_Actions := Nvl(p.o_Arraylist('actions'), Arraylist());
  
    for i in 1 .. v_Actions.Count
    loop
      v_Action := Treat(v_Actions.r_Hashmap(i) as Hashmap);
    
      Hsc_Util.Object_Norm_Add_Action(p_Norm      => v_Norm,
                                      i_Day_No    => v_Action.r_Number('day_no'),
                                      i_Frequency => v_Action.r_Number('frequency'));
    end loop;
  
    if i_Norm_Id is null then
      v_Object_Ids := p.r_Array_Number('object_ids');
    
      for i in 1 .. v_Object_Ids.Count
      loop
        v_Norm.Object_Id := v_Object_Ids(i);
        v_Norm.Norm_Id   := Hsc_Next.Object_Norm_Id;
      
        Hsc_Api.Object_Norm_Save(v_Norm);
      end loop;
    else
      Hsc_Api.Object_Norm_Save(v_Norm);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(null, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Norm Hsc_Object_Norms%rowtype;
  begin
    r_Norm := z_Hsc_Object_Norms.Lock_Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Norm_Id    => p.r_Number('norm_id'));
  
    save(r_Norm.Norm_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Object_Groups
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Group_Id = null;
    update Mhr_Divisions
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Id       = null,
           name              = null,
           Parent_Id         = null,
           Division_Group_Id = null,
           State             = null;
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null,
           State      = null;
    update Hsc_Processes
       set Company_Id = null,
           Filial_Id  = null,
           Process_Id = null,
           name       = null,
           State      = null;
    update Hsc_Process_Actions
       set Company_Id = null,
           Filial_Id  = null,
           Action_Id  = null,
           Process_Id = null,
           name       = null,
           State      = null;
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null,
           State      = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr495;
/
