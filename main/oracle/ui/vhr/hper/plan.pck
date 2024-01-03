create or replace package Ui_Vhr136 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Journal_Pages(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Plan_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr136;
/
create or replace package body Ui_Vhr136 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Journal_Pages(p Hashmap) return Fazo_Query is
    v_Query     varchar2(32767);
    v_Plan_Date date := p.o_Date('plan_date', Href_Pref.c_Date_Format_Month);
    v_Params    Hashmap;
    v_Matrix    Matrix_Varchar2;
    q           Fazo_Query;
  begin
    v_Query := 'with staff_transactions as
                       (select q.*
                          from hpd_transactions q
                         where q.company_id = :company_id
                           and q.filial_id = :filial_id
                           and q.trans_type = :robot_trans_type
                           and (q.begin_date <= :month_end_date and
                               nvl(q.end_date, :end_date) >= :month_begin_date)
                           and exists (select 1
                                  from hpd_agreements a
                                 where a.company_id = q.company_id
                                   and a.filial_id = q.filial_id
                                   and a.trans_id = q.trans_id))
                      select st.journal_id,
                             st.page_id,
                             st.staff_id,
                             st.begin_date,
                             st.end_date,
                             st.trans_type,
                             rb.org_unit_id,
                             t.division_id,
                             t.job_id,
                             w.rank_id,
                             w.employment_type,
                             r.employee_id
                        from staff_transactions st
                        join hpd_page_robots w
                          on w.company_id = st.company_id
                         and w.filial_id = st.filial_id
                         and w.page_id = st.page_id
                        join mrf_robots t
                          on t.company_id = w.company_id
                         and t.filial_id = w.filial_id
                         and t.robot_id = w.robot_id
                        join hrm_robots rb
                          on rb.company_id = w.company_id
                         and rb.filial_id = w.filial_id
                         and rb.robot_id = w.robot_id
                        join hpd_journal_pages r
                          on r.company_id = w.company_id
                         and r.filial_id = w.filial_id
                         and r.page_id = w.page_id
                       where st.begin_date = (select max(s.begin_date)
                                               from staff_transactions s
                                              where s.staff_id = st.staff_id)
                         and not exists (select 1
                                    from hper_plans t
                                   where t.company_id = w.company_id
                                     and t.filial_id = w.filial_id
                                     and t.plan_date = :plan_date
                                     and t.journal_page_id = r.page_id)
                         and exists (select 1 
                                from href_staffs d 
                               where d.company_id = st.company_id
                                 and d.filial_id = st.filial_id
                                 and d.staff_id = st.staff_id
                                 and d.employee_id <> :user_id
                                 and d.state = ''A''
                                 and nvl(d.dismissal_date, :end_date) >= :month_end_date)';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'end_date',
                             Href_Pref.c_Max_Date,
                             'plan_date',
                             v_Plan_Date,
                             'month_begin_date',
                             Hper_Util.Month_Begin_Date(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Date       => v_Plan_Date),
                             'month_end_date',
                             Hper_Util.Month_End_Date(i_Company_Id => Ui.Company_Id,
                                                      i_Filial_Id  => Ui.Filial_Id,
                                                      i_Date       => v_Plan_Date));
  
    v_Params.Put('robot_trans_type', Hpd_Pref.c_Transaction_Type_Robot);
    v_Params.Put('user_id', Ui.User_Id);
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query            => v_Query,
                                                i_Include_Self     => false,
                                                i_Include_Undirect => false);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('journal_id',
                   'page_id',
                   'staff_id',
                   'employee_id',
                   'division_id',
                   'job_id',
                   'rank_id');
    q.Varchar2_Field('employment_type', 'trans_type');
    q.Date_Field('begin_date', 'end_date');
  
    q.Refer_Field('staff_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons q
                    where q.company_id = :company_id');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
  
    v_Matrix := Hpd_Util.Employment_Types;
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    v_Params Hashmap := Hashmap();
    q        Fazo_Query;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_id', Ui.Filial_Id);
    v_Params.Put('division_ids', Nvl(p.o_Array_Number('division_id'), Array_Number()));
  
    q := Fazo_Query('select q.*, 
                            w.name group_name
                       from mhr_jobs q
                       left join mhr_job_groups w
                         on w.company_id = :company_id
                        and w.job_group_id = q.job_group_id
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''
                        and (q.c_divisions_exist = ''N'' or exists
                             (select 1
                                from mhr_job_divisions s
                               where s.company_id = q.company_id
                                 and s.filial_id = q.filial_id
                                 and s.job_id = q.job_id
                                 and s.division_id member of :division_ids))',
                    v_Params);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'group_name');
  
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
  Function Query_Plan_Types(p Hashmap) return Fazo_Query is
    v_Params      Hashmap := Hashmap();
    v_Division_Id Array_Number;
    q             Fazo_Query;
  begin
    if p.Has('division_id') then
      v_Division_Id := p.o_Array_Number('division_id');
    end if;
  
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_id', Ui.Filial_Id);
    v_Params.Put('division_ids', v_Division_Id);
  
    q := Fazo_Query('select q.plan_type_id,
                            q.name,
                            q.order_no,
                            w.plan_group_id,
                            w.name group_name,
                            w.order_no group_order_no
                       from hper_plan_types q
                       left join hper_plan_groups w
                         on q.company_id = w.company_id
                        and q.filial_id = w.filial_id
                        and q.plan_group_id = w.plan_group_id
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A'' ' || --
                    case
                      when v_Division_Id is not null then
                       ' and (q.c_divisions_exist = ''N''
                          or exists (select 1
                                from hper_plan_type_divisions s
                               where s.company_id = q.company_id
                                 and s.filial_id = q.filial_id
                                 and s.plan_type_id = q.plan_type_id
                                 and s.division_id member of :division_ids))'
                      else
                       null
                    end,
                    v_Params);
  
    q.Number_Field('plan_type_id', 'order_no', 'group_order_no');
    q.Varchar2_Field('name', 'group_name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Grant_Has_Standard_Plans is
  begin
    return;
    if not Md_Util.Grant_Has(i_Company_Id   => Ui.Company_Id,
                             i_Project_Code => Ui.Project_Code,
                             i_Filial_Id    => Ui.Filial_Id,
                             i_User_Id      => Ui.User_Id,
                             i_Form         => '/vhr/hper/plan_list',
                             i_Action_Key   => 'standard_plans') then
      b.Raise_Unauthorized;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    r_Plan      Hper_Plans%rowtype;
    r_Page      Hpd_Journal_Pages%rowtype;
    v_Plan_Id   number := p.o_Number('plan_id');
    v_Plan_Kind varchar2(1) := p.r_Varchar2('plan_kind');
    v_Data      Hashmap;
    result      Hashmap;
  begin
    if v_Plan_Id is null then
      result := Hashmap();
    
      if v_Plan_Kind = Hper_Pref.c_Plan_Kind_Standard then
        Uit_Href.Assert_Access_All_Employees;
      else
        Uit_Href.Assert_Has_Access_Direct;
      end if;
    
      v_Data := Fazo.Zip_Map('plan_date', --
                             to_char(sysdate, Href_Pref.c_Date_Format_Month),
                             'plan_kind',
                             v_Plan_Kind,
                             'main_calc_type',
                             Hper_Pref.c_Plan_Calc_Type_Weight,
                             'extra_calc_type',
                             Hper_Pref.c_Plan_Calc_Type_Weight);
    
      Result.Put('data', v_Data);
      Result.Put('plan_types', Fazo.Zip_Matrix(Hper_Util.Plan_Types));
    
    else
      r_Plan := z_Hper_Plans.Load(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Plan_Id    => v_Plan_Id);
    
      if r_Plan.Plan_Kind = Hper_Pref.c_Plan_Kind_Standard then
        Uit_Href.Assert_Access_All_Employees;
        Grant_Has_Standard_Plans;
      else
        r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => r_Plan.Company_Id,
                                           i_Filial_Id  => r_Plan.Filial_Id,
                                           i_Page_Id    => r_Plan.Journal_Page_Id);
      
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Page.Staff_Id,
                                        i_All      => true,
                                        i_Direct   => true);
      end if;
    
      result := Edit_Model(Fazo.Zip_Map('plan_id',
                                        v_Plan_Id, --
                                        'plan_date',
                                        sysdate,
                                        'action',
                                        'copy'));
    end if;
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    Result.Put('employment_types', Fazo.Zip_Matrix(Hpd_Util.Employment_Types(true)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Plan       Hper_Plans%rowtype;
    r_Page       Hpd_Journal_Pages%rowtype;
    r_Page_Robot Hpd_Page_Robots%rowtype;
    r_Robot      Mrf_Robots %rowtype;
    v_Matrix     Matrix_Varchar2;
    v_Data       Hashmap;
    result       Hashmap := Hashmap();
  begin
    r_Plan := z_Hper_Plans.Load(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Plan_Id    => p.r_Number('plan_id'));
  
    if r_Plan.Plan_Kind = Hper_Pref.c_Plan_Kind_Standard then
      Uit_Href.Assert_Access_All_Employees;
      Grant_Has_Standard_Plans;
    else
      r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => r_Plan.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Page_Id    => r_Plan.Journal_Page_Id);
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Page.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    end if;
  
    v_Data := z_Hper_Plans.To_Map(r_Plan, --
                                  z.Plan_Kind,
                                  z.Main_Calc_Type,
                                  z.Extra_Calc_Type,
                                  z.Note);
  
    if r_Plan.Journal_Page_Id is not null then
      r_Page_Robot := z_Hpd_Page_Robots.Load(i_Company_Id => r_Plan.Company_Id,
                                             i_Filial_Id  => r_Plan.Filial_Id,
                                             i_Page_Id    => r_Plan.Journal_Page_Id);
    
      r_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Page_Robot.Company_Id,
                                   i_Filial_Id  => r_Page_Robot.Filial_Id,
                                   i_Robot_Id   => r_Page_Robot.Robot_Id);
    
      r_Plan.Division_Id := r_Robot.Division_Id;
      r_Plan.Job_Id      := r_Robot.Job_Id;
      r_Plan.Rank_Id     := r_Page_Robot.Rank_Id;
    end if;
  
    if p.o_Varchar2('action') = 'copy' then
      v_Data.Put('plan_date', to_char(p.r_Date('plan_date'), Href_Pref.c_Date_Format_Month));
      v_Data.Put('journal_page_id', r_Plan.Journal_Page_Id);
      v_Data.Put('division_id', r_Plan.Division_Id);
      v_Data.Put('job_id', r_Plan.Job_Id);
      v_Data.Put('rank_id', r_Plan.Rank_Id);
      v_Data.Put('employment_type', r_Plan.Employment_Type);
    else
      v_Data.Put('plan_id', r_Plan.Plan_Id);
      v_Data.Put('plan_date', to_char(r_Plan.Plan_Date, Href_Pref.c_Date_Format_Month));
    end if;
  
    v_Data.Put('staff_name',
               z_Mr_Natural_Persons.Take(i_Company_Id => r_Page.Company_Id, i_Person_Id => r_Page.Employee_Id).Name);
    v_Data.Put('division_id', r_Plan.Division_Id);
    v_Data.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Plan.Company_Id, i_Filial_Id => r_Plan.Filial_Id, i_Division_Id => r_Plan.Division_Id).Name);
    v_Data.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Plan.Company_Id, i_Filial_Id => r_Plan.Filial_Id, i_Job_Id => r_Plan.Job_Id).Name);
    v_Data.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Plan.Company_Id, i_Filial_Id => r_Plan.Filial_Id, i_Rank_Id => r_Plan.Rank_Id).Name);
    v_Data.Put('employment_type_name', Hpd_Util.t_Employment_Type(r_Plan.Employment_Type));
  
    Result.Put('data', v_Data);
  
    -- plans
    select Array_Varchar2(w.Plan_Type_Id,
                          w.Name,
                          w.Order_No,
                          k.Name,
                          k.Order_No,
                          q.Plan_Type,
                          q.Plan_Value,
                          q.Plan_Amount,
                          q.Note)
      bulk collect
      into v_Matrix
      from Hper_Plan_Items q
      join Hper_Plan_Types w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Plan_Type_Id = q.Plan_Type_Id
      left join Hper_Plan_Groups k
        on k.Company_Id = w.Company_Id
       and k.Filial_Id = w.Filial_Id
       and k.Plan_Group_Id = w.Plan_Group_Id
     where q.Company_Id = r_Plan.Company_Id
       and q.Filial_Id = r_Plan.Filial_Id
       and q.Plan_Id = r_Plan.Plan_Id
     order by q.Order_No;
  
    Result.Put('plans', Fazo.Zip_Matrix(v_Matrix));
  
    -- plan rules
    select Array_Varchar2(q.Plan_Type_Id, Nullif(q.From_Percent, 0), q.To_Percent, q.Fact_Amount)
      bulk collect
      into v_Matrix
      from Hper_Plan_Rules q
     where q.Company_Id = r_Plan.Company_Id
       and q.Filial_Id = r_Plan.Filial_Id
       and q.Plan_Id = r_Plan.Plan_Id
     order by q.From_Percent;
  
    Result.Put('rules', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('plan_types', Fazo.Zip_Matrix(Hper_Util.Plan_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p_Plan in out Hper_Pref.Plan_Rt,
    p      Hashmap
  ) is
    r_Page Hpd_Journal_Pages%rowtype;
  
    v_Item  Hashmap;
    v_Items Arraylist;
  
    v_Rule  Hashmap;
    v_Rules Arraylist;
  begin
    if p_Plan.Journal_Page_Id is not null then
      r_Page := z_Hpd_Journal_Pages.Lock_Load(i_Company_Id => p_Plan.Company_Id,
                                              i_Filial_Id  => p_Plan.Filial_Id,
                                              i_Page_Id    => p_Plan.Journal_Page_Id);
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Page.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    else
      Uit_Href.Assert_Access_All_Employees;
      Grant_Has_Standard_Plans;
    end if;
  
    -- plans
    v_Items := Nvl(p.o_Arraylist('plans'), Arraylist());
  
    for i in 1 .. v_Items.Count
    loop
      v_Item := Treat(v_Items.r_Hashmap(i) as Hashmap);
    
      Hper_Util.Plan_Add_Item(p_Plan         => p_Plan,
                              i_Plan_Type_Id => v_Item.r_Number('plan_type_id'),
                              i_Plan_Type    => v_Item.r_Varchar2('plan_type'),
                              i_Plan_Value   => v_Item.r_Number('plan_value'),
                              i_Plan_Amount  => v_Item.r_Number('plan_amount'),
                              i_Note         => v_Item.o_Varchar2('note'));
    
      -- plan rules
      v_Rules := Nvl(v_Item.o_Arraylist('rules'), Arraylist());
    
      for j in 1 .. v_Rules.Count
      loop
        v_Rule := Treat(v_Rules.r_Hashmap(j) as Hashmap);
      
        Hper_Util.Plan_Add_Rule(p_Item         => p_Plan.Items(p_Plan.Items.Count),
                                i_From_Percent => v_Rule.o_Number('from_percent'),
                                i_To_Percent   => v_Rule.o_Number('to_percent'),
                                i_Fact_Amount  => v_Rule.o_Number('fact_amount'));
      end loop;
    end loop;
  
    Hper_Api.Plan_Save(p_Plan);
  
    if p.o_Varchar2('regen_emp_plans') = 'Y' then
      Hper_Api.Gen_Plans(i_Company_Id => p_Plan.Company_Id,
                         i_Filial_Id  => p_Plan.Filial_Id,
                         i_Plan_Id    => p_Plan.Plan_Id,
                         i_Date       => Trunc(sysdate, 'MON'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number(null));
    v_Plan_Copy    Hper_Pref.Plan_Rt;
    v_Plan         Hper_Pref.Plan_Rt;
  begin
    Hper_Util.Plan_New(o_Plan            => v_Plan_Copy,
                       i_Company_Id      => Ui.Company_Id,
                       i_Filial_Id       => Ui.Filial_Id,
                       i_Plan_Id         => null,
                       i_Plan_Date       => p.r_Date('plan_date', Href_Pref.c_Date_Format_Month),
                       i_Main_Calc_Type  => p.r_Varchar2('main_calc_type'),
                       i_Extra_Calc_Type => p.r_Varchar2('extra_calc_type'),
                       i_Journal_Page_Id => p.o_Number('journal_page_id'),
                       i_Job_Id          => p.o_Number('job_id'),
                       i_Rank_Id         => p.o_Number('rank_id'),
                       i_Employment_Type => p.o_Varchar2('employment_type'),
                       i_Note            => p.o_Varchar2('note'));
  
    for i in 1 .. v_Division_Ids.Count
    loop
      v_Plan             := v_Plan_Copy;
      v_Plan.Plan_Id     := Hper_Next.Plan_Id;
      v_Plan.Division_Id := v_Division_Ids(i);
    
      save(v_Plan, p);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    v_Plan Hper_Pref.Plan_Rt;
  begin
    Hper_Util.Plan_New(o_Plan            => v_Plan,
                       i_Company_Id      => Ui.Company_Id,
                       i_Filial_Id       => Ui.Filial_Id,
                       i_Plan_Id         => p.r_Number('plan_id'),
                       i_Main_Calc_Type  => p.r_Varchar2('main_calc_type'),
                       i_Extra_Calc_Type => p.r_Varchar2('extra_calc_type'),
                       i_Note            => p.o_Varchar2('note'));
  
    save(v_Plan, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Transactions
       set Company_Id = null,
           Filial_Id  = null,
           Trans_Type = null,
           Journal_Id = null,
           Page_Id    = null,
           Staff_Id   = null,
           Begin_Date = null,
           End_Date   = null;
    update Hpd_Agreements
       set Company_Id = null,
           Filial_Id  = null,
           Trans_Id   = null;
    update Hpd_Page_Robots
       set Company_Id      = null,
           Filial_Id       = null,
           Page_Id         = null,
           Robot_Id        = null,
           Rank_Id         = null,
           Employment_Type = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           Job_Id      = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null;
    update Hpd_Journal_Pages
       set Company_Id  = null,
           Filial_Id   = null,
           Journal_Id  = null,
           Page_Id     = null,
           Employee_Id = null;
    update Hper_Plans
       set Company_Id      = null,
           Filial_Id       = null,
           Plan_Id         = null,
           Plan_Kind       = null,
           Journal_Page_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Filial_Id         = null,
           Job_Id            = null,
           name              = null,
           Job_Group_Id      = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Hper_Plan_Types
       set Company_Id        = null,
           Filial_Id         = null,
           Plan_Type_Id      = null,
           name              = null,
           Plan_Group_Id     = null,
           State             = null,
           Order_No          = null,
           c_Divisions_Exist = null;
    update Hper_Plan_Groups
       set Company_Id    = null,
           Filial_Id     = null,
           Plan_Group_Id = null,
           name          = null,
           Order_No      = null;
    update Hper_Plan_Type_Divisions
       set Company_Id   = null,
           Filial_Id    = null,
           Plan_Type_Id = null,
           Division_Id  = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Dismissal_Date = null,
           State          = null,
           Employee_Id    = null;
  end;

end Ui_Vhr136;
/
