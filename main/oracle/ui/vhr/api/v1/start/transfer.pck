create or replace package Ui_Vhr340 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Transfers(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Transfer(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Transfer(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Transfer(p Hashmap);
end Ui_Vhr340;
/
create or replace package body Ui_Vhr340 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Transfers(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(p.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
    v_Jt_Transfer number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    v_Salary_Type varchar2(1);
    v_Transfer    Gmap;
    v_Transfers   Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select k.Company_Id,
                             k.Filial_Id,
                             k.Modified_Id,
                             k.Journal_Id,
                             k.Page_Id,
                             k.Employee_Id,
                             k.Staff_Id,
                             t.Transfer_Begin,
                             n.Division_Id,
                             n.Job_Id,
                             n.Fte_Id,
                             Ps.Schedule_Id,
                             Ot.Pcode as Oper_Type_Pcode,
                             (select Pi.Indicator_Value
                                from Hpd_Page_Indicators Pi
                               where Pi.Company_Id = v_Company_Id
                                 and Pi.Filial_Id = v_Filial_Id
                                 and Pi.Page_Id = k.Page_Id
                                 and Pi.Indicator_Id = Oti.Indicator_Id) as Indicator_Value
                        from Hpd_Journal_Pages k
                        join Hpd_Transfers t
                          on t.Company_Id = v_Company_Id
                         and t.Filial_Id = v_Filial_Id
                         and t.Page_Id = k.Page_Id
                        join Hpd_Page_Robots n
                          on n.Company_Id = v_Company_Id
                         and n.Filial_Id = v_Filial_Id
                         and n.Page_Id = k.Page_Id
                        left join Hpd_Page_Schedules Ps
                          on Ps.Company_Id = v_Company_Id
                         and Ps.Filial_Id = v_Filial_Id
                         and Ps.Page_Id = k.Page_Id
                        left join Hpd_Oper_Type_Indicators Oti
                          on Oti.Company_Id = v_Company_Id
                         and Oti.Filial_Id = v_Filial_Id
                         and Oti.Page_Id = k.Page_Id
                        left join Mpr_Oper_Types Ot
                          on Ot.Company_Id = v_Company_Id
                         and Ot.Oper_Type_Id = Oti.Oper_Type_Id
                       where k.Company_Id = v_Company_Id
                         and k.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or k.Journal_Id member of v_Journal_Ids)
                         and exists (select 1
                                from Hpd_Journals j
                               where j.Company_Id = v_Company_Id
                                 and j.Filial_Id = v_Filial_Id
                                 and j.Journal_Id = k.Journal_Id
                                 and j.Posted = 'Y'
                                 and j.Journal_Type_Id = v_Jt_Transfer)
                         and (Ot.Oper_Type_Id is null or
                             Ot.Pcode in
                             (Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                               Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                               Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                               Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized))) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Transfer := Gmap();
    
      v_Transfer.Put('journal_id', r.Journal_Id);
      v_Transfer.Put('page_id', r.Page_Id);
      v_Transfer.Put('employee_id', r.Employee_Id);
      v_Transfer.Put('staff_id', r.Staff_Id);
      v_Transfer.Put('change_date', r.Transfer_Begin);
      v_Transfer.Put('division_id', r.Division_Id);
      v_Transfer.Put('job_id', r.Job_Id);
      v_Transfer.Put('fte_id', r.Fte_Id);
      v_Transfer.Put('schedule_id', r.Schedule_Id);
      v_Transfer.Put('salary', r.Indicator_Value);
    
      case r.Oper_Type_Pcode
        when Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly then
          v_Salary_Type := Uit_Hpr.c_Salary_Type_Monthly;
        when Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily then
          v_Salary_Type := Uit_Hpr.c_Salary_Type_Daily;
        when Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly then
          v_Salary_Type := Uit_Hpr.c_Salary_Type_Hourly;
        when Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized then
          v_Salary_Type := Uit_Hpr.c_Salary_Type_Monthly_Summarized;
        else
          v_Salary_Type := null;
      end case;
    
      v_Transfer.Put('salary_type', v_Salary_Type);
    
      v_Last_Id := r.Modified_Id;
    
      v_Transfers.Push(v_Transfer.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Transfers, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p         Hashmap,
    i_Journal Hpd_Journals%rowtype,
    i_Page_Id number := null
  ) is
    p_Journal    Hpd_Pref.Transfer_Journal_Rt;
    p_Robot      Hpd_Pref.Robot_Rt;
    p_Contract   Hpd_Pref.Contract_Rt;
    p_Oper_Types Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    p_Indicators Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
  
    v_Page_Id      number;
    v_Robot_Id     number;
    v_Staff_Id     number;
    v_Indicator_Id number;
    v_Change_Date  date := p.r_Date('change_date');
    v_Salary_Type  varchar2(1) := p.o_Varchar2('salary_type');
  
    r_Robot          Hrm_Robots%rowtype;
    r_Transfer       Hpd_Transfers%rowtype;
    r_Vacation_Limit Hpd_Page_Vacation_Limits%rowtype;
    r_Page_Contract  Hpd_Page_Contracts%rowtype;
    r_Page_Robot     Hpd_Page_Robots%rowtype;
  begin
    Hpd_Util.Transfer_Journal_New(o_Journal         => p_Journal,
                                  i_Company_Id      => Ui.Company_Id,
                                  i_Filial_Id       => Ui.Filial_Id,
                                  i_Journal_Id      => i_Journal.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                  i_Journal_Number  => i_Journal.Journal_Number,
                                  i_Journal_Date    => v_Change_Date,
                                  i_Journal_Name    => i_Journal.Journal_Name);
  
    v_Page_Id  := Coalesce(i_Page_Id, Uit_Hpd.Get_Page_Id(p_Journal.Journal_Id));
    v_Robot_Id := Uit_Hpd.Get_Robot_Id(v_Page_Id);
  
    if i_Journal.Company_Id is not null then
      r_Robot := z_Hrm_Robots.Load(i_Company_Id => p_Journal.Company_Id,
                                   i_Filial_Id  => p_Journal.Filial_Id,
                                   i_Robot_Id   => v_Robot_Id);
    
      r_Page_Robot := z_Hpd_Page_Robots.Lock_Load(i_Company_Id => p_Journal.Company_Id,
                                                  i_Filial_Id  => p_Journal.Filial_Id,
                                                  i_Page_Id    => v_Page_Id);
    
      r_Transfer := z_Hpd_Transfers.Lock_Load(i_Company_Id => p_Journal.Company_Id,
                                              i_Filial_Id  => p_Journal.Filial_Id,
                                              i_Page_Id    => v_Page_Id);
    
      r_Vacation_Limit := z_Hpd_Page_Vacation_Limits.Take(i_Company_Id => p_Journal.Company_Id,
                                                          i_Filial_Id  => p_Journal.Filial_Id,
                                                          i_Page_Id    => v_Page_Id);
    
      r_Page_Contract := z_Hpd_Page_Contracts.Take(i_Company_Id => p_Journal.Company_Id,
                                                   i_Filial_Id  => p_Journal.Filial_Id,
                                                   i_Page_Id    => v_Page_Id);
    
      Hpd_Util.Contract_New(o_Contract             => p_Contract,
                            i_Contract_Number      => r_Page_Contract.Contract_Number,
                            i_Contract_Date        => r_Page_Contract.Contract_Date,
                            i_Fixed_Term           => r_Page_Contract.Fixed_Term,
                            i_Expiry_Date          => r_Page_Contract.Expiry_Date,
                            i_Fixed_Term_Base_Id   => r_Page_Contract.Fixed_Term_Base_Id,
                            i_Concluding_Term      => r_Page_Contract.Concluding_Term,
                            i_Hiring_Conditions    => r_Page_Contract.Hiring_Conditions,
                            i_Other_Conditions     => r_Page_Contract.Other_Conditions,
                            i_Workplace_Equipment  => r_Page_Contract.Workplace_Equipment,
                            i_Representative_Basis => r_Page_Contract.Representative_Basis);
    end if;
  
    Hpd_Util.Robot_New(o_Robot           => p_Robot,
                       i_Robot_Id        => v_Robot_Id,
                       i_Division_Id     => p.r_Number('division_id'),
                       i_Job_Id          => p.r_Number('job_id'),
                       i_Rank_Id         => r_Page_Robot.Rank_Id,
                       i_Wage_Scale_Id   => r_Robot.Wage_Scale_Id,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                       i_Fte_Id          => p.o_Number('fte_id'),
                       i_Fte             => r_Page_Robot.Fte);
  
    if v_Salary_Type is not null then
      v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                               i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    
      Hpd_Util.Indicator_Add(p_Indicator       => p_Indicators,
                             i_Indicator_Id    => v_Indicator_Id,
                             i_Indicator_Value => p.r_Number('salary'));
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Types,
                             i_Oper_Type_Id  => Uit_Hpr.Get_Salary_Type_Id(v_Salary_Type),
                             i_Indicator_Ids => Array_Number(v_Indicator_Id));
    end if;
  
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id   => p_Journal.Company_Id,
                                                 i_Filial_Id    => p_Journal.Filial_Id,
                                                 i_Employee_Id  => p.r_Number('employee_id'),
                                                 i_Period_Begin => v_Change_Date,
                                                 i_Period_End   => v_Change_Date);
  
    Hpd_Util.Journal_Add_Transfer(p_Journal             => p_Journal,
                                  i_Page_Id             => v_Page_Id,
                                  i_Transfer_Begin      => v_Change_Date,
                                  i_Transfer_End        => r_Transfer.Transfer_End,
                                  i_Staff_Id            => v_Staff_Id,
                                  i_Schedule_Id         => p.o_Number('schedule_id'),
                                  i_Vacation_Days_Limit => r_Vacation_Limit.Days_Limit,
                                  i_Is_Booked           => 'N',
                                  i_Transfer_Reason     => r_Transfer.Transfer_Reason,
                                  i_Transfer_Base       => r_Transfer.Transfer_Base,
                                  i_Robot               => p_Robot,
                                  i_Contract            => p_Contract,
                                  i_Indicators          => p_Indicators,
                                  i_Oper_Types          => p_Oper_Types);
  
    Hpd_Api.Transfer_Journal_Save(p_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                         i_Filial_Id  => p_Journal.Filial_Id,
                         i_Journal_Id => p_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Transfer(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Page_Id number := Hpd_Next.Page_Id;
  begin
    r_Journal.Journal_Id := Hpd_Next.Journal_Id;
  
    save(p, r_Journal, v_Page_Id);
  
    return Fazo.Zip_Map('journal_id', r_Journal.Journal_Id, 'page_id', v_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Transfer(p Hashmap) is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                           i_Filial_Id  => r_Journal.Filial_Id,
                           i_Journal_Id => r_Journal.Journal_Id,
                           i_Repost     => true);
  
    save(p, r_Journal);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Transfer(p Hashmap) is
    v_Journal_Id number := p.r_Number('journal_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Hpd_Api.Journal_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  end;

end Ui_Vhr340;
/
