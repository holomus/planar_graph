create or replace package Ui_Vhr278 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap);
end Ui_Vhr278;
/
create or replace package body Ui_Vhr278 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs w
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id
                        and w.state = ''A''
                        and (w.c_divisions_exist = ''N'' 
                         or exists (select 1
                               from mhr_job_divisions r
                              where r.company_id = :company_id
                                and r.filial_id = :filial_id
                                and r.job_id = w.job_id
                                and r.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.r_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
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
  
    q.Number_Field('rank_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Wage_Scales return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrm_wage_scales',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('wage_scale_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mpr_oper_types', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name', 'operation_kind');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist is
    v_Oper_Type_Id number := p.r_Number('oper_type_id');
    v_Matrix       Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Indicator_Id, q.Name)
      bulk collect
      into v_Matrix
      from Href_Indicators q
     where q.Company_Id = Ui.Company_Id
       and q.Used = Href_Pref.c_Indicator_Used_Constantly
       and exists (select 1
              from Hpr_Oper_Type_Indicators w
             where w.Company_Id = Ui.Company_Id
               and w.Oper_Type_Id = v_Oper_Type_Id
               and w.Indicator_Id = q.Indicator_Id)
     order by q.Name;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2 is
  begin
    return Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => p.o_Number('job_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Oper_Types
  (
    i_Template_Id       number,
    i_Access_Salary_Job varchar2
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    if i_Access_Salary_Job = 'Y' then
      select Array_Varchar2(q.Indicator_Id,
                            (select w.Name
                               from Href_Indicators w
                              where w.Company_Id = q.Company_Id
                                and w.Indicator_Id = q.Indicator_Id),
                            q.Indicator_Value)
        bulk collect
        into v_Matrix
        from Hrm_Template_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Template_Id = i_Template_Id;
    
      Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id,
                            (select w.Name
                               from Mpr_Oper_Types w
                              where w.Company_Id = q.Company_Id
                                and w.Oper_Type_Id = q.Oper_Type_Id))
        bulk collect
        into v_Matrix
        from Hrm_Template_Oper_Types q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Template_Id = i_Template_Id;
    
      Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Oper_Type_Id, q.Indicator_Id)
        bulk collect
        into v_Matrix
        from Hrm_Temp_Oper_Type_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Template_Id = i_Template_Id;
    
      Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id  => i_Division_Id,
                                                 i_Check_Access => false)));
    Result.Put('wage_indicator_id',
               Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('access_salary_job', 'Y');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Template          Hrm_Job_Templates%rowtype;
    v_Access_Salary_Job varchar2(1);
    result              Hashmap;
  begin
    r_Template := z_Hrm_Job_Templates.Load(i_Company_Id  => Ui.Company_Id,
                                           i_Filial_Id   => Ui.Filial_Id,
                                           i_Template_Id => p.r_Number('template_id'));
  
    v_Access_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => r_Template.Job_Id);
  
    if v_Access_Salary_Job = 'N' then
      r_Template.Wage_Scale_Id := null;
    end if;
  
    result := z_Hrm_Job_Templates.To_Map(r_Template,
                                         z.Template_Id,
                                         z.Division_Id,
                                         z.Job_Id,
                                         z.Rank_Id,
                                         z.Schedule_Id,
                                         z.Vacation_Days_Limit,
                                         z.Wage_Scale_Id);
  
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Template.Company_Id, i_Filial_Id => r_Template.Filial_Id, i_Job_Id => r_Template.Job_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Template.Company_Id, i_Filial_Id => r_Template.Filial_Id, i_Schedule_Id => r_Template.Schedule_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Template.Company_Id, i_Filial_Id => r_Template.Filial_Id, i_Rank_Id => r_Template.Rank_Id).Name);
    Result.Put('wage_scale_name',
               z_Hrm_Wage_Scales.Take(i_Company_Id => r_Template.Company_Id, i_Filial_Id => r_Template.Filial_Id, i_Wage_Scale_Id => r_Template.Wage_Scale_Id).Name);
    Result.Put('references', References(r_Template.Division_Id));
    Result.Put('access_salary_job', v_Access_Salary_Job);
    Result.Put_All(Get_Oper_Types(r_Template.Template_Id, v_Access_Salary_Job));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p             Hashmap,
    i_Template_Id number := null
  ) is
    p_Template   Hrm_Pref.Job_Template_Rt;
    v_Indicators Arraylist;
    v_Oper_Types Arraylist;
    v_Indicator  Hashmap;
    v_Oper_Type  Hashmap;
  begin
    Hrm_Util.Job_Template_New(o_Template            => p_Template,
                              i_Company_Id          => Ui.Company_Id,
                              i_Filial_Id           => Ui.Filial_Id,
                              i_Template_Id         => i_Template_Id,
                              i_Division_Id         => p.r_Number('division_id'),
                              i_Job_Id              => p.r_Number('job_id'),
                              i_Rank_Id             => p.o_Number('rank_id'),
                              i_Schedule_Id         => p.o_Number('schedule_id'),
                              i_Vacation_Days_Limit => p.o_Number('vacation_days_limit'),
                              i_Wage_Scale_Id       => p.o_Number('wage_scale_id'));
  
    v_Indicators := p.o_Arraylist('indicators');
  
    for j in 1 .. v_Indicators.Count
    loop
      v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
    
      Hrm_Util.Job_Temp_Add_Indicator(p_Template        => p_Template,
                                      i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                                      i_Indicator_Value => Nvl(v_Indicator.o_Number('indicator_value'),
                                                               0));
    end loop;
  
    v_Oper_Types := p.o_Arraylist('oper_types');
  
    for j in 1 .. v_Oper_Types.Count
    loop
      v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(j) as Hashmap);
    
      Hrm_Util.Job_Temp_Add_Oper_Type(p_Template      => p_Template,
                                      i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                                      i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                             Array_Number()));
    end loop;
  
    Hrm_Api.Job_Template_Save(i_Template => p_Template, i_User_Id => Ui.User_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Add(p Hashmap) is
  begin
    save(p, Hrm_Next.Job_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap) is
    v_Template_Id number := p.r_Number('template_id');
  begin
    z_Hrm_Job_Templates.Lock_Only(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Template_Id => v_Template_Id);
  
    save(p, v_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           Filial_Id         = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null,
           Order_No   = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null,
           State         = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
  end;

end Ui_Vhr278;
/
