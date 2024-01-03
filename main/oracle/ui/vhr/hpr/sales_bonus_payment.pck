create or replace package Ui_Vhr484 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Cashboxes return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Bank_Accounts return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Operations(p Hashmap) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------       
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
end Ui_Vhr484;
/
create or replace package body Ui_Vhr484 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr484';

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Matrix    Matrix_Varchar2;
    v_Params    Hashmap;
    v_Staff_Ids Array_Number := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
    q           Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'division_id',
                             p.o_Number('division_id'),
                             'job_id',
                             p.o_Number('job_id'),
                             'begin_date',
                             p.r_Date('begin_date'),
                             'end_date',
                             p.r_Date('end_date'));
  
    v_Params.Put('staff_ids', v_Staff_Ids);
    v_Params.Put('staff_count', v_Staff_Ids.Count);
  
    q := Fazo_Query('select q.*
                       from href_staffs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''
                        and q.hiring_date <= :end_date
                        and nvl(q.dismissal_date, :begin_date) >= :begin_date
                        and (:division_id is null or
                            :division_id = hpd_util.get_closest_division_id(q.company_id, q.filial_id, q.staff_id, :end_date))
                        and (:job_id is null or
                            :job_id = hpd_util.get_closest_job_id(q.company_id, q.filial_id, q.staff_id, :end_date))
                        and (:staff_count = 0 or q.staff_id not member of :staff_ids)',
                    v_Params);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    q.Map_Field('name',
                'select r.name
                   from mr_natural_persons r
                  where r.company_id = :company_id
                    and r.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Cashboxes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mkcs_cashboxes',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('cashbox_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Bank_Accounts return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mkcs_bank_accounts',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'person_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('bank_account_id');
    q.Varchar2_Field('name', 'is_main');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id    
                        and q.state = ''A''  
                        and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.o_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Operations(p Hashmap) return Json_Array_t is
  begin
    return Uit_Hpr.Load_Sales_Bonus_Operations(i_Begin_Date  => p.r_Date('begin_date'),
                                               i_End_Date    => p.r_Date('end_date'),
                                               i_Division_Id => p.o_Number('division_id'),
                                               i_Job_Id      => p.o_Number('job_id'),
                                               i_Bonus_Type  => p.o_Varchar2('bonus_type'),
                                               i_Staff_Ids   => p.o_Array_Number('staff_ids'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id  => i_Division_Id,
                                                 i_Check_Access => false)));
    Result.Put('bonus_types', Fazo.Zip_Matrix_Transposed(Hrm_Util.Bonus_Types));
    Result.Put('payment_types', Fazo.Zip_Matrix_Transposed(Mpr_Util.Payment_Types));
    Result.Put('pt_cashbox', Mpr_Pref.c_Pt_Cashbox);
    Result.Put_All(Uit_Mpr.Load_Round_Value(g_Setting_Code));
  
    -- todo: Owner: Sherzod; text: uncommit
  
    -- Result.Put('bt_successful_delivery', Hrm_Pref.c_Bonus_Type_Successful_Delivery);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('payment_date',
                            Trunc(sysdate),
                            'begin_date',
                            Trunc(sysdate, 'mon'),
                            'end_date',
                            Trunc(sysdate),
                            'payment_type',
                            Mpr_Pref.c_Pt_Cashbox,
                            'filial_id',
                            Ui.Filial_Id));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Payment Hpr_Sales_Bonus_Payments%rowtype;
    v_Matrix  Matrix_Varchar2;
    v_Ids     Array_Number;
    v_Data    Hashmap;
    result    Hashmap := Hashmap();
  begin
    r_Payment := z_Hpr_Sales_Bonus_Payments.Load(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Payment_Id => p.r_Number('payment_id'));
  
    v_Data := z_Hpr_Sales_Bonus_Payments.To_Map(r_Payment,
                                                z.Filial_Id,
                                                z.Payment_Id,
                                                z.Payment_Number,
                                                z.Payment_Date,
                                                z.Payment_Name,
                                                z.Begin_Date,
                                                z.End_Date,
                                                z.Division_Id,
                                                z.Job_Id,
                                                z.Bonus_Type,
                                                z.Payment_Type,
                                                z.Cashbox_Id,
                                                z.Bank_Account_Id,
                                                z.Posted,
                                                z.Note);
  
    v_Data.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => r_Payment.Company_Id, i_Filial_Id => r_Payment.Filial_Id, i_Job_Id => r_Payment.Job_Id).Name);
    v_Data.Put('cashbox_name',
               z_Mkcs_Cashboxes.Take(i_Company_Id => Ui.Company_Id, i_Cashbox_Id => r_Payment.Cashbox_Id).Name);
    v_Data.Put('bank_account_name',
               z_Mkcs_Bank_Accounts.Take(i_Company_Id => Ui.Company_Id, i_Bank_Account_Id => r_Payment.Bank_Account_Id).Name);
  
    if r_Payment.Bonus_Type is not null then
      v_Data.Put('bonus_type_name', Hrm_Util.t_Bonus_Type(r_Payment.Bonus_Type));
    end if;
  
    select Array_Varchar2(q.Operation_Id,
                          q.Staff_Id,
                          (select Np.Name
                             from Mr_Natural_Persons Np
                            where Np.Company_Id = r_Payment.Company_Id
                              and Np.Person_Id = s.Employee_Id),
                          (select t.Staff_Number
                             from Href_Staffs t
                            where t.Company_Id = q.Company_Id
                              and t.Filial_Id = q.Filial_Id
                              and t.Staff_Id = q.Staff_Id),
                          (select Mr.Name
                             from Mrf_Robots Mr
                            where Mr.Company_Id = q.Company_Id
                              and Mr.Filial_Id = q.Filial_Id
                              and Mr.Robot_Id =
                                  Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => q.Company_Id,
                                                                i_Filial_Id  => q.Filial_Id,
                                                                i_Staff_Id   => q.Staff_Id,
                                                                i_Period     => q.Period_End)),
                          (select m.Name
                             from Mhr_Divisions m
                            where m.Company_Id = q.Company_Id
                              and m.Filial_Id = q.Filial_Id
                              and m.Division_Id =
                                  Hpd_Util.Get_Closest_Division_Id(i_Company_Id => q.Company_Id,
                                                                   i_Filial_Id  => q.Filial_Id,
                                                                   i_Staff_Id   => q.Staff_Id,
                                                                   i_Period     => q.Period_End)),
                          q.Job_Id,
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = q.Company_Id
                              and j.Filial_Id = q.Filial_Id
                              and j.Job_Id = q.Job_Id),
                          q.Bonus_Type,
                          q.Period_Begin,
                          q.Period_End,
                          q.Sales_Amount,
                          q.Percentage,
                          q.Amount,
                          s.Employee_Id),
           q.Operation_Id
      bulk collect
      into v_Matrix, v_Ids
      from Hpr_Sales_Bonus_Payment_Operations q
      join Href_Staffs s
        on s.Company_Id = r_Payment.Company_Id
       and s.Filial_Id = r_Payment.Filial_Id
       and s.Staff_Id = q.Staff_Id
     where q.Company_Id = r_Payment.Company_Id
       and q.Filial_Id = r_Payment.Filial_Id
       and q.Payment_Id = r_Payment.Payment_Id;
  
    v_Data.Put('operations', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Operation_Id, q.Period, q.Sales_Amount, q.Amount)
      bulk collect
      into v_Matrix
      from Hpr_Sales_Bonus_Payment_Operation_Periods q
     where q.Company_Id = r_Payment.Company_Id
       and q.Filial_Id = r_Payment.Filial_Id
       and q.Operation_Id in (select *
                                from table(v_Ids));
  
    v_Data.Put('periods', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('data', v_Data);
    Result.Put('references', References(r_Payment.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure save
  (
    i_Payment_Id number,
    p            Hashmap
  ) is
    p_Payment      Hpr_Pref.Sales_Bonus_Payment_Rt;
    v_Operations   Arraylist := p.r_Arraylist('operations');
    v_Operation    Hashmap;
    v_Operation_Id number;
    v_Post         varchar2(1) := p.r_Varchar2('post');
    v_Round_Value  varchar2(100) := p.o_Varchar2('round_value');
  begin
    Hpr_Util.Sales_Bonus_Payment_New(o_Sales_Bonus_Payment => p_Payment,
                                     i_Company_Id          => Ui.Company_Id,
                                     i_Filial_Id           => Ui.Filial_Id,
                                     i_Payment_Id          => i_Payment_Id,
                                     i_Payment_Number      => p.o_Varchar2('payment_number'),
                                     i_Payment_Date        => p.r_Date('payment_date'),
                                     i_Payment_Name        => p.o_Varchar2('payment_name'),
                                     i_Begin_Date          => p.r_Date('begin_date'),
                                     i_End_Date            => p.r_Date('end_date'),
                                     i_Division_Id         => p.o_Number('division_id'),
                                     i_Job_Id              => p.o_Number('job_id'),
                                     i_Bonus_Type          => p.o_Varchar2('bonus_type'),
                                     i_Payment_Type        => p.r_Varchar2('payment_type'),
                                     i_Cashbox_Id          => p.o_Number('cashbox_id'),
                                     i_Bank_Account_Id     => p.o_Number('bank_account_id'),
                                     i_Note                => p.o_Varchar2('note'));
  
    for i in 1 .. v_Operations.Count
    loop
      v_Operation := Treat(v_Operations.r_Hashmap(i) as Hashmap);
    
      v_Operation_Id := v_Operation.o_Number('operation_id');
    
      if v_Operation_Id is null then
        v_Operation_Id := Hpr_Next.Sales_Bonus_Payment_Operation_Id;
      end if;
    
      Hpr_Util.Sales_Bonus_Payment_Add_Operation(p_Sales_Bonus_Payment => p_Payment,
                                                 i_Operation_Id        => v_Operation_Id,
                                                 i_Staff_Id            => v_Operation.r_Number('staff_id'),
                                                 i_Period_Begin        => v_Operation.r_Date('period_begin'),
                                                 i_Period_End          => v_Operation.r_Date('period_end'),
                                                 i_Bonus_Type          => v_Operation.r_Varchar2('bonus_type'),
                                                 i_Job_Id              => v_Operation.r_Number('job_id'),
                                                 i_Percentage          => v_Operation.r_Number('percentage'),
                                                 i_Periods             => v_Operation.r_Array_Date('periods'),
                                                 i_Sales_Amounts       => v_Operation.r_Array_Number('sales_amounts'),
                                                 i_Amounts             => v_Operation.r_Array_Number('amounts'));
    end loop;
  
    Hpr_Api.Sales_Bonus_Payment_Save(p_Payment);
  
    if v_Post = 'Y' then
      Hpr_Api.Sales_Bonus_Payment_Post(i_Company_Id => p_Payment.Company_Id,
                                       i_Filial_Id  => p_Payment.Filial_Id,
                                       i_Payment_Id => i_Payment_Id);
    end if;
  
    -- user preference
    if v_Round_Value is not null then
      Md_Api.User_Setting_Save(i_Company_Id    => p_Payment.Company_Id,
                               i_User_Id       => Ui.User_Id,
                               i_Filial_Id     => p_Payment.Filial_Id,
                               i_Setting_Code  => g_Setting_Code,
                               i_Setting_Value => v_Round_Value);
    else
      Md_Api.User_Settings_Delete(i_Company_Id   => p_Payment.Company_Id,
                                  i_User_Id      => Ui.User_Id,
                                  i_Filial_Id    => p_Payment.Filial_Id,
                                  i_Setting_Code => g_Setting_Code);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Add(p Hashmap) is
  begin
    save(Hpr_Next.Sales_Bonus_Payment_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap) is
    r_Payment Hpr_Sales_Bonus_Payments%rowtype;
  begin
    r_Payment := z_Hpr_Sales_Bonus_Payments.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                      i_Filial_Id  => Ui.Filial_Id,
                                                      i_Payment_Id => p.r_Number('payment_id'));
  
    if r_Payment.Posted = 'Y' then
      Hpr_Api.Sales_Bonus_Payment_Unpost(i_Company_Id => r_Payment.Company_Id,
                                         i_Filial_Id  => r_Payment.Filial_Id,
                                         i_Payment_Id => r_Payment.Payment_Id);
    end if;
  
    save(r_Payment.Payment_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
  begin
    Hpr_Api.Sales_Bonus_Payment_Unpost(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Payment_Id => p.r_Number('payment_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Staff_Kind     = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mkcs_Cashboxes
       set Company_Id = null,
           Cashbox_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Mkcs_Bank_Accounts
       set Company_Id      = null,
           Bank_Account_Id = null,
           name            = null,
           Person_Id       = null,
           Is_Main         = null,
           State           = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Job_Id      = null,
           Division_Id = null;
    Uie.x(Hpd_Util.Get_Closest_Division_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Period     => null));
  end;

end Ui_Vhr484;
/
