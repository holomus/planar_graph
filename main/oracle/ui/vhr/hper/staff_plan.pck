create or replace package Ui_Vhr135 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Parts(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Tasks(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Save_Plan_Part(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Plan_Part(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Tasks(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Completed(p Hashmap);
end Ui_Vhr135;
/
create or replace package body Ui_Vhr135 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Data       Hper_Staff_Plans%rowtype;
    v_Matrix     Matrix_Varchar2;
    v_Data       Hashmap;
    v_Emp_Id     number;
    v_References Hashmap := Hashmap;
    result       Hashmap := Hashmap();
  begin
    r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                      i_Filial_Id     => Ui.Filial_Id,
                                      i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                    i_All      => true,
                                    i_Self     => true,
                                    i_Direct   => true,
                                    i_Undirect => true);
  
    v_Data := z_Hper_Staff_Plans.To_Map(r_Data, --
                                        z.Staff_Plan_Id,
                                        z.Staff_Id,
                                        z.Main_Calc_Type,
                                        z.Extra_Calc_Type,
                                        z.Begin_Date,
                                        z.End_Date,
                                        z.Main_Plan_Amount,
                                        z.Extra_Plan_Amount,
                                        z.Main_Fact_Amount,
                                        z.Extra_Fact_Amount,
                                        z.Main_Fact_Percent,
                                        z.Extra_Fact_Percent,
                                        z.c_Main_Fact_Percent,
                                        z.c_Extra_Fact_Percent,
                                        z.Status);
  
    v_Emp_Id := Href_Util.Get_Employee_Id(i_Company_Id => r_Data.Company_Id,
                                          i_Filial_Id  => r_Data.Filial_Id,
                                          i_Staff_Id   => r_Data.Staff_Id);
  
    v_Data.Put('plan_date', to_char(r_Data.Plan_Date, Href_Pref.c_Date_Format_Month));
    v_Data.Put('main_calc_type_name', Hper_Util.t_Plan_Calc_Type(r_Data.Main_Calc_Type));
    v_Data.Put('extra_calc_type_name', Hper_Util.t_Plan_Calc_Type(r_Data.Extra_Calc_Type));
    v_Data.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Division_Id => r_Data.Division_Id).Name);
    v_Data.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Job_Id => r_Data.Job_Id).Name);
    v_Data.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Rank_Id => r_Data.Rank_Id).Name);
    v_Data.Put('employment_type_name', Hpd_Util.t_Employment_Type(r_Data.Employment_Type));
    v_Data.Put('photo_sha',
               z_Md_Persons.Take(i_Company_Id => r_Data.Company_Id, --
               i_Person_Id => v_Emp_Id).Photo_Sha);
    v_Data.Put('gender',
               z_Mr_Natural_Persons.Take(i_Company_Id => r_Data.Company_Id, i_Person_Id => v_Emp_Id).Gender);
    v_Data.Put('staff_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Data.Company_Id, i_Person_Id => v_Emp_Id).Name);
  
    v_Data.Put('manager_name',
               Href_Util.Get_Manager_Name(i_Company_Id => r_Data.Company_Id,
                                          i_Filial_Id  => r_Data.Filial_Id,
                                          i_Staff_Id   => r_Data.Staff_Id));
  
    Result.Put('data', v_Data);
  
    -- plans
    select Array_Varchar2(q.Plan_Type_Id,
                          w.Name,
                          k.Name,
                          q.Plan_Type,
                          q.Plan_Value,
                          q.Plan_Amount,
                          q.Fact_Value,
                          q.Fact_Percent,
                          q.Fact_Amount,
                          q.Calc_Kind,
                          Hper_Util.t_Calc_Kind(q.Calc_Kind),
                          q.Note,
                          q.Fact_Note)
      bulk collect
      into v_Matrix
      from Hper_Staff_Plan_Items q
      join Hper_Plan_Types w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Plan_Type_Id = q.Plan_Type_Id
      left join Hper_Plan_Groups k
        on k.Company_Id = w.Company_Id
       and k.Filial_Id = w.Filial_Id
       and k.Plan_Group_Id = w.Plan_Group_Id
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Staff_Plan_Id = r_Data.Staff_Plan_Id
     order by k.Order_No, Lower(k.Name), w.Order_No, Lower(w.Name);
  
    Result.Put('plans', Fazo.Zip_Matrix(v_Matrix));
  
    -- plan rules 
    select Array_Varchar2(q.Plan_Type_Id, Nullif(q.From_Percent, 0), q.To_Percent, q.Fact_Amount)
      bulk collect
      into v_Matrix
      from Hper_Staff_Plan_Rules q
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Staff_Plan_Id = r_Data.Staff_Plan_Id
     order by q.From_Percent;
  
    Result.Put('rules', Fazo.Zip_Matrix(v_Matrix));
  
    v_References.Put('access_level', Uit_Href.User_Access_Level_For_Staff(r_Data.Staff_Id));
    v_References.Put('ual_direct', Href_Pref.c_User_Access_Level_Direct_Employee);
    v_References.Put('ual_undirect', Href_Pref.c_User_Access_Level_Undirect_Employee);
  
    Result.Put('references', v_References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Parts(p Hashmap) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Part_Id,
                          to_char(q.Part_Date, Href_Pref.c_Date_Format_Minute),
                          q.Amount,
                          q.Note,
                          to_char(q.Created_On, Href_Pref.c_Date_Format_Second),
                          (select t.Name
                             from Md_Users t
                            where t.Company_Id = q.Company_Id
                              and t.User_Id = q.Created_By),
                          (select t.Name
                             from Md_Users t
                            where t.Company_Id = q.Company_Id
                              and t.User_Id = q.Modified_By),
                          to_char(q.Modified_On, Href_Pref.c_Date_Format_Second))
      bulk collect
      into v_Matrix
      from Hper_Staff_Plan_Parts q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Plan_Id = p.r_Number('staff_plan_id')
       and q.Plan_Type_Id = p.r_Number('plan_type_id')
     order by q.Part_Date;
  
    Result.Put('parts', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Tasks(p Hashmap) return Arraylist is
    r_Staff_Plan   Hper_Staff_Plans%rowtype;
    v_Plan_Type_Id number := p.r_Number('plan_type_id');
    v_Matrix       Matrix_Varchar2;
  begin
    r_Staff_Plan := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                            i_Filial_Id     => Ui.Filial_Id,
                                            i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    select Array_Varchar2(q.Task_Id,
                          q.Title,
                          to_char(q.Begin_Time, Href_Pref.c_Date_Format_Minute),
                          to_char(q.End_Time, Href_Pref.c_Date_Format_Minute),
                          q.Grade)
      bulk collect
      into v_Matrix
      from Ms_Tasks q
     where q.Company_Id = r_Staff_Plan.Company_Id
       and q.Task_Id in
           (select Column_Value
              from table(Hper_Util.Plan_Tasks(i_Company_Id    => r_Staff_Plan.Company_Id,
                                              i_Filial_Id     => r_Staff_Plan.Filial_Id,
                                              i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id,
                                              i_Plan_Type_Id  => v_Plan_Type_Id)))
       and q.Status_Id =
           Ms_Pref.Task_Status_Id(i_Company_Id => Ui.Company_Id,
                                  i_Pcode      => Ms_Pref.c_Pc_Status_Finished);
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Update
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    p               Hashmap
  ) is
    v_Values Matrix_Varchar2 := Matrix_Varchar2(p.r_Array_Varchar2('plan_type_id'),
                                                p.r_Array_Varchar2('fact_value'),
                                                p.r_Array_Varchar2('fact_note'));
  begin
    Hper_Api.Staff_Plan_Update(i_Company_Id    => i_Company_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Staff_Plan_Id => i_Staff_Plan_Id,
                               i_Values        => Fazo.Transpose(v_Values));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id, i_Direct => true);
  
    Plan_Update(i_Company_Id    => r_Data.Company_Id,
                i_Filial_Id     => r_Data.Filial_Id,
                i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                p               => p);
  
    if r_Data.Status = Hper_Pref.c_Staff_Plan_Status_Draft and p.o_Varchar2('set_new_status') = 'Y' then
      Hper_Api.Staff_Plan_Set_New(i_Company_Id    => r_Data.Company_Id,
                                  i_Filial_Id     => r_Data.Filial_Id,
                                  i_Staff_Plan_Id => r_Data.Staff_Plan_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Plan_Part(p Hashmap) return Hashmap is
    r_Staff_Plan Hper_Staff_Plans%rowtype;
    r_Plan_Part  Hper_Staff_Plan_Parts%rowtype;
    v_Part_Id    number := p.o_Number('part_id');
    result       Hashmap := Hashmap();
  begin
    r_Staff_Plan := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                                 i_Filial_Id     => Ui.Filial_Id,
                                                 i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Staff_Plan.Staff_Id, i_Direct => true);
  
    if v_Part_Id is not null then
      r_Plan_Part := z_Hper_Staff_Plan_Parts.Load(i_Company_Id => r_Staff_Plan.Company_Id,
                                                  i_Filial_Id  => r_Staff_Plan.Filial_Id,
                                                  i_Part_Id    => v_Part_Id);
    else
      r_Plan_Part.Company_Id := r_Staff_Plan.Company_Id;
      r_Plan_Part.Filial_Id  := r_Staff_Plan.Filial_Id;
      r_Plan_Part.Part_Id    := Hper_Next.Part_Id;
    end if;
  
    r_Plan_Part.Staff_Plan_Id := r_Staff_Plan.Staff_Plan_Id;
  
    z_Hper_Staff_Plan_Parts.To_Row(r_Plan_Part, p, z.Plan_Type_Id, z.Part_Date, z.Amount, z.Note);
  
    Hper_Api.Staff_Plan_Part_Save(r_Plan_Part);
  
    Result.Put('fact_value',
               z_Hper_Staff_Plan_Items.Take(i_Company_Id => r_Plan_Part.Company_Id, --
               i_Filial_Id => r_Plan_Part.Filial_Id, --
               i_Staff_Plan_Id => r_Plan_Part.Staff_Plan_Id, --
               i_Plan_Type_Id => r_Plan_Part.Plan_Type_Id).Fact_Value);
    Result.Put('part_id', r_Plan_Part.Part_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Plan_Part(p Hashmap) is
    r_Plan_Part  Hper_Staff_Plan_Parts%rowtype;
    r_Staff_Plan Hper_Staff_Plans%rowtype;
  begin
    r_Plan_Part := z_Hper_Staff_Plan_Parts.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Part_Id    => p.r_Number('part_id'));
  
    r_Staff_Plan := z_Hper_Staff_Plans.Load(i_Company_Id    => r_Plan_Part.Company_Id,
                                            i_Filial_Id     => r_Plan_Part.Filial_Id,
                                            i_Staff_Plan_Id => r_Plan_Part.Staff_Plan_Id);
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Staff_Plan.Staff_Id, i_Direct => true);
  
    Hper_Api.Staff_Plan_Part_Delete(i_Company_Id => r_Plan_Part.Company_Id,
                                    i_Filial_Id  => r_Plan_Part.Filial_Id,
                                    i_Part_Id    => r_Plan_Part.Part_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Tasks(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id, i_Direct => true);
  
    Hper_Api.Staff_Plan_Save_Tasks(i_Company_Id    => r_Data.Company_Id,
                                   i_Filial_Id     => r_Data.Filial_Id,
                                   i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                                   i_Plan_Type_Id  => p.r_Number('plan_type_id'),
                                   i_Task_Ids      => Nvl(p.o_Array_Number('task_ids'),
                                                          Array_Number()),
                                   i_Fact_Note     => p.o_Varchar2('fact_note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Waiting(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id, i_Direct => true);
  
    if r_Data.Status in (Hper_Pref.c_Staff_Plan_Status_Draft, Hper_Pref.c_Staff_Plan_Status_New) then
      Plan_Update(i_Company_Id    => r_Data.Company_Id,
                  i_Filial_Id     => r_Data.Filial_Id,
                  i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                  p               => p);
    end if;
  
    Hper_Api.Staff_Plan_Set_Waiting(i_Company_Id    => r_Data.Company_Id,
                                    i_Filial_Id     => r_Data.Filial_Id,
                                    i_Staff_Plan_Id => r_Data.Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id, i_Direct => true);
  
    Hper_Api.Staff_Plan_Set_New(i_Company_Id    => r_Data.Company_Id,
                                i_Filial_Id     => r_Data.Filial_Id,
                                i_Staff_Plan_Id => r_Data.Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Completed(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Staff_Plan_Id => p.r_Number('staff_plan_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                    i_Direct   => true,
                                    i_Undirect => true);
  
    Hper_Api.Staff_Plan_Set_Completed(i_Company_Id         => r_Data.Company_Id,
                                      i_Filial_Id          => r_Data.Filial_Id,
                                      i_Staff_Plan_Id      => r_Data.Staff_Plan_Id,
                                      i_Main_Fact_Percent  => p.r_Number('main_fact_percent'),
                                      i_Extra_Fact_Percent => p.r_Number('extra_fact_percent'));
  end;

end Ui_Vhr135;
/
