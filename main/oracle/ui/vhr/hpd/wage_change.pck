create or replace package Ui_Vhr128 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr128;
/
create or replace package body Ui_Vhr128 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select * 
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.state = ''A''';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))
                              and s.employee_id <> :user_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'staff_kind', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query is
    v_Wage_Group_Id         number;
    v_Bonus_Group_Id        number;
    v_Penalty_Group_Id      number;
    v_Perf_Penalty_Group_Id number;
    v_Overtime_Group_Id     number;
    v_Param                 Hashmap;
    q                       Fazo_Query;
  begin
    v_Wage_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
  
    v_Bonus_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                               i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf);
  
    v_Penalty_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  
    v_Perf_Penalty_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                      i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  
    v_Overtime_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Overtime);
  
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'wage_group_id',
                            v_Wage_Group_Id,
                            'bonus_group_id',
                            v_Bonus_Group_Id,
                            'penalty_group_id',
                            v_Penalty_Group_Id,
                            'perf_penalty_group_id',
                            v_Perf_Penalty_Group_Id,
                            'operation_kind',
                            p.r_Varchar2('operation_kind'));
    v_Param.Put('overtime_group_id', v_Overtime_Group_Id);
  
    q := Fazo_Query('select q.*
                       from mpr_oper_types q
                      where q.company_id = :company_id
                        and q.operation_kind = :operation_kind
                        and q.state = ''A''
                        and exists (select 1
                               from hpr_oper_types p
                              where p.company_id = q.company_id
                                and p.oper_type_id = q.oper_type_id
                                and p.oper_group_id in (:wage_group_id, :bonus_group_id, :penalty_group_id, :perf_penalty_group_id, :overtime_group_id))',
                    v_Param);
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name');
  
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
  Function Get_Staff_Info(p Hashmap) return Hashmap is
    v_Staff_Id    number := p.r_Number('staff_id');
    v_Change_Date date := p.r_Date('change_date');
  begin
    return Fazo.Zip_Map('access_to_hidden_salary_job',
                        Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                                                                                         i_Filial_Id  => Ui.Filial_Id,
                                                                                                         i_Staff_Id   => v_Staff_Id,
                                                                                                         i_Period     => v_Change_Date),
                                                            i_Employee_Id => p.r_Number('employee_id')),
                        'contractual_wage',
                        Hpd_Util.Get_Closest_Contractual_Wage(i_Company_Id => Ui.Company_Id,
                                                              i_Filial_Id  => Ui.Filial_Id,
                                                              i_Staff_Id   => v_Staff_Id,
                                                              i_Period     => v_Change_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Wage_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Page_Ids Array_Number;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap();
  begin
    select Array_Varchar2(Wg.Page_Id,
                           Wg.Change_Date,
                           Wg.Staff_Id,
                           Wg.Employee_Id,
                           Wg.Employee_Name,
                           case
                             when Wg.Access_To_Hidden_Salary = 'Y' then
                              Wg.Currency_Id
                             else
                              null
                           end,
                           case
                             when Wg.Access_To_Hidden_Salary = 'Y' then
                              Wg.Currency_Name
                             else
                              null
                           end,
                           case
                             when Wg.Access_To_Hidden_Salary = 'Y' then
                              Wg.Contractual_Wage
                             else
                              null
                           end,
                           Wg.Access_To_Hidden_Salary),
           case
             when Wg.Access_To_Hidden_Salary = 'Y' then
              Wg.Page_Id
             else
              null
           end
      bulk collect
      into v_Matrix, v_Page_Ids
      from (select q.Page_Id,
                   w.Change_Date,
                   q.Staff_Id,
                   q.Employee_Id,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = q.Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   Pc.Currency_Id,
                   (select Cr.Name
                      from Mk_Currencies Cr
                     where Cr.Company_Id = Pc.Company_Id
                       and Cr.Currency_Id = Pc.Currency_Id) as Currency_Name,
                   Hpd_Util.Get_Closest_Contractual_Wage(i_Company_Id => q.Company_Id,
                                                         i_Filial_Id  => q.Filial_Id,
                                                         i_Staff_Id   => q.Staff_Id,
                                                         i_Period     => w.Change_Date) as Contractual_Wage,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => i_Company_Id,
                                                                                                    i_Filial_Id  => i_Filial_Id,
                                                                                                    i_Staff_Id   => q.Staff_Id,
                                                                                                    i_Period     => w.Change_Date),
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary
              from Hpd_Journal_Pages q
              join Hpd_Wage_Changes w
                on w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Page_Id = q.Page_Id
              left join Hpd_Page_Currencies Pc
                on Pc.Company_Id = q.Company_Id
               and Pc.Filial_Id = q.Filial_Id
               and Pc.Page_Id = q.Page_Id
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Journal_Id = i_Journal_Id) Wg;
  
    Result.Put('wage_changes', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id,
                          q.Indicator_Id,
                          (select w.Name
                             from Href_Indicators w
                            where w.Company_Id = q.Company_Id
                              and w.Indicator_Id = q.Indicator_Id),
                          q.Indicator_Value)
      bulk collect
      into v_Matrix
      from Hpd_Page_Indicators q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id, q.Oper_Type_Id, w.Name, w.Operation_Kind)
      bulk collect
      into v_Matrix
      from Hpd_Page_Oper_Types q
      join Mpr_Oper_Types w
        on w.Company_Id = q.Company_Id
       and w.Oper_Type_Id = q.Oper_Type_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id, q.Oper_Type_Id, q.Indicator_Id)
      bulk collect
      into v_Matrix
      from Hpd_Oper_Type_Indicators q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('wage_id',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
  
    Result.Put('allowed_currencies', Uit_Hpr.Load_Allowed_Currencies);
    Result.Put('user_id', Ui.User_Id);
    Result.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
    Result.Put('access_oper_group_ids',
               Array_Number(Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty),
                            Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Overtime)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Wage_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                           i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_date', Trunc(sysdate), 'change_date', Trunc(sysdate));
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Wage_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                           i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null then
      Uit_Hpd.Check_Access_To_Edit_Journal(i_Document_Status => v_Sign_Document_Status,
                                           i_Posted          => r_Journal.Posted,
                                           i_Journal_Number  => r_Journal.Journal_Number);
      v_Has_Sign_Document := 'Y';
    end if;
  
    for r in (select s.Staff_Id
                from Hpd_Journal_Staffs s
               where s.Company_Id = r_Journal.Company_Id
                 and s.Filial_Id = r_Journal.Filial_Id
                 and s.Journal_Id = r_Journal.Journal_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
    end loop;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Type_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Posted);
  
    Result.Put_All(Get_Wage_Changes(i_Company_Id => r_Journal.Company_Id,
                                    i_Filial_Id  => r_Journal.Filial_Id,
                                    i_Journal_Id => r_Journal.Journal_Id));
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Journal_Id number,
    p            Hashmap,
    i_Repost     boolean := false,
    i_Exists     boolean := false
  ) return Hashmap is
    p_Journal            Hpd_Pref.Wage_Change_Journal_Rt;
    p_Indicator          Href_Pref.Indicator_Nt;
    p_Oper_Type          Href_Pref.Oper_Type_Nt;
    v_Changes            Arraylist := p.r_Arraylist('wage_changes');
    v_Change             Hashmap;
    v_Page_Id            number;
    v_Staff_Id           number;
    v_Indicator          Hashmap;
    v_Oper_Type          Hashmap;
    v_Indicators         Arraylist;
    v_Oper_Types         Arraylist;
    v_Notification_Title varchar2(500);
    v_Posted             varchar2(1) := p.r_Varchar2('posted');
    v_User_Id            number := Ui.User_Id;
  begin
    Hpd_Util.Wage_Change_Journal_New(o_Journal         => p_Journal,
                                     i_Company_Id      => Ui.Company_Id,
                                     i_Filial_Id       => Ui.Filial_Id,
                                     i_Journal_Id      => i_Journal_Id,
                                     i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change),
                                     i_Journal_Number  => p.o_Varchar2('journal_number'),
                                     i_Journal_Date    => p.r_Date('journal_date'),
                                     i_Journal_Name    => p.o_Varchar2('journal_name'),
                                     i_Lang_Code       => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Change.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Page_Id := v_Change.o_Number('page_id');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      v_Indicators := v_Change.r_Arraylist('indicators');
      p_Indicator  := Href_Pref.Indicator_Nt();
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
      
        Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                               i_Indicator_Id    => v_Indicator.r_Number('indicator_id'),
                               i_Indicator_Value => v_Indicator.r_Number('indicator_value'));
      end loop;
    
      v_Oper_Types := v_Change.r_Arraylist('oper_types');
      p_Oper_Type  := Href_Pref.Oper_Type_Nt();
    
      for j in 1 .. v_Oper_Types.Count
      loop
        v_Oper_Type := Treat(v_Oper_Types.r_Hashmap(j) as Hashmap);
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                               i_Oper_Type_Id  => v_Oper_Type.r_Number('oper_type_id'),
                               i_Indicator_Ids => Nvl(v_Oper_Type.o_Array_Number('indicator_ids'),
                                                      Array_Number()));
      end loop;
    
      Hpd_Util.Journal_Add_Wage_Change(p_Journal     => p_Journal,
                                       i_Page_Id     => v_Page_Id,
                                       i_Staff_Id    => v_Staff_Id,
                                       i_Change_Date => v_Change.r_Date('change_date'),
                                       i_Currency_Id => v_Change.o_Number('currency_id'),
                                       i_Indicators  => p_Indicator,
                                       i_Oper_Types  => p_Oper_Type);
    end loop;
  
    -- notification title should make before saving journal
    if i_Exists = false and v_Posted = 'N' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Save(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    elsif i_Repost = false and v_Posted = 'Y' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    else
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Update(i_Company_Id      => p_Journal.Company_Id,
                                                                           i_User_Id         => v_User_Id,
                                                                           i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    end if;
  
    Hpd_Api.Wage_Change_Journal_Save(p_Journal);
  
    if v_Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  
    -- notification send after saving journal
    Href_Core.Send_Notification(i_Company_Id    => p_Journal.Company_Id,
                                i_Filial_Id     => p_Journal.Filial_Id,
                                i_Title         => v_Notification_Title,
                                i_Uri           => Hpd_Pref.c_Form_Wage_Change_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                p_Journal.Journal_Id,
                                                                'journal_type_id',
                                                                p_Journal.Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  
    return Fazo.Zip_Map('journal_id', i_Journal_Id, 'journal_name', p_Journal.Journal_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpd_Next.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Repost  boolean;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    v_Repost := r_Journal.Posted = 'Y' and p.r_Varchar2('posted') = 'Y';
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => v_Repost);
    end if;
  
    return save(r_Journal.Journal_Id, p, v_Repost, true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Employee_Id     = null,
           Org_Unit_Id     = null,
           Hiring_Date     = null,
           Dismissal_Date  = null,
           Employment_Type = null,
           Division_Id     = null,
           Staff_Kind      = null,
           State           = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
    update Hpr_Oper_Types
       set Company_Id    = null,
           Oper_Type_Id  = null,
           Oper_Group_Id = null;
  end;

end Ui_Vhr128;
/
