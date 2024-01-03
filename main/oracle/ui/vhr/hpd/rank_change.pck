create or replace package Ui_Vhr263 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------       
  Function Get_Staff_Infos(p Hashmap) return Arraylist;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Wage(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr263;
/
create or replace package body Ui_Vhr263 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'period',
                             p.r_Date('change_date'));
  
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
    q.Map_Field('old_rank_name',
                'select q.name
                   from mhr_ranks q
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.rank_id = hpd_util.get_closest_rank_id(:company_id, :filial_id, $staff_id, to_date(:period) - 1)');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
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
  Function Get_Staff_Info(p Hashmap) return Hashmap is
    v_Change_Date             date := p.r_Date('change_date');
    v_Staff_Id                number := p.r_Number('staff_id');
    v_Employee_Id             number := p.r_Number('employee_id');
    v_Old_Rank_Id             number;
    v_Access_To_Hidden_Salary varchar2(1);
    result                    Hashmap;
  begin
    v_Access_To_Hidden_Salary := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                                                                                                  i_Filial_Id  => Ui.Filial_Id,
                                                                                                                  i_Staff_Id   => v_Staff_Id,
                                                                                                                  i_Period     => v_Change_Date),
                                                                     i_Employee_Id => v_Employee_Id);
  
    v_Old_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => Ui.Company_Id, --
                                                  i_Filial_Id  => Ui.Filial_Id, --
                                                  i_Staff_Id   => v_Staff_Id, --
                                                  i_Period     => v_Change_Date - 1);
  
    result := Fazo.Zip_Map('old_rank_name',
                           z_Mhr_Ranks.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Rank_Id => v_Old_Rank_Id).Name,
                           'old_rank_id',
                           v_Old_Rank_Id,
                           'access_to_hidden_salary',
                           v_Access_To_Hidden_Salary);
  
    if v_Access_To_Hidden_Salary = 'Y' then
      Result.Put('old_wage',
                 Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Staff_Id   => v_Staff_Id,
                                           i_Period     => v_Change_Date - 1));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Get_Staff_Infos(p Hashmap) return Arraylist is
    v_Staff_Ids   Array_Number := p.r_Array_Number('staff_ids');
    v_Change_Date date := p.r_Date('change_date');
    v_Result      Arraylist := Arraylist();
    v_Data        Hashmap;
    v_Old_Rank_Id number;
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Data := Hashmap();
    
      v_Old_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => Ui.Company_Id, --
                                                    i_Filial_Id  => Ui.Filial_Id, --
                                                    i_Staff_Id   => v_Staff_Ids(i), --
                                                    i_Period     => v_Change_Date - 1);
    
      v_Data.Put('old_rank_name',
                 z_Mhr_Ranks.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Rank_Id => v_Old_Rank_Id).Name);
      v_Data.Put('old_rank_id', v_Old_Rank_Id);
      v_Data.Put('staff_id', v_Staff_Ids(i));
    
      v_Result.Push(v_Data);
    end loop;
  
    return v_Result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Wage(p Hashmap) return Hashmap is
    v_Change_Date             date := p.r_Date('change_date');
    v_Staff_Id                number := p.r_Number('staff_id');
    v_Employee_Id             number := p.r_Number('employee_id');
    v_Access_To_Hidden_Salary varchar2(1);
  begin
    v_Access_To_Hidden_Salary := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                                                                                                  i_Filial_Id  => Ui.Filial_Id,
                                                                                                                  i_Staff_Id   => v_Staff_Id,
                                                                                                                  i_Period     => v_Change_Date),
                                                                     i_Employee_Id => v_Employee_Id);
  
    if v_Access_To_Hidden_Salary = 'Y' then
      return Fazo.Zip_Map('new_wage',
                          Hrm_Util.Closest_Wage(i_Company_Id    => Ui.Company_Id,
                                                i_Filial_Id     => Ui.Filial_Id,
                                                i_Wage_Scale_Id => Hpd_Util.Get_Closest_Wage_Scale_Id(i_Company_Id => Ui.Company_Id,
                                                                                                      i_Filial_Id  => Ui.Filial_Id,
                                                                                                      i_Staff_Id   => v_Staff_Id,
                                                                                                      i_Period     => v_Change_Date),
                                                i_Period        => p.r_Date('change_date'),
                                                i_Rank_Id       => p.r_Number('rank_id')));
    else
      return Hashmap();
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
  begin
    return Fazo.Zip_Map('journal_type_id',
                        Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Rank_Change),
                        'user_id',
                        Ui.User_Id,
                        'et_contractor',
                        Hpd_Pref.c_Employment_Type_Contractor,
                        'access_all_employee',
                        Uit_Href.User_Access_All_Employees);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Rank_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                           i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_date',
                           Trunc(sysdate),
                           'change_date',
                           Trunc(sysdate),
                           'journal_type_id',
                           v_Journal_Type_Id);
  
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
    v_Matrix               Matrix_Varchar2;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Rank_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                           i_Journal_Type_Id => r_Journal.Journal_Type_Id) or
       r_Journal.Source_Table is not null then
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
  
    select Array_Varchar2(Rc.Page_Id,
                           Rc.Change_Date,
                           Rc.Staff_Id,
                           Rc.Employee_Id,
                           Rc.Employee_Name,
                           Rc.Old_Rank_Id,
                           Rc.Old_Rank_Name,
                           case
                             when Rc.Access_To_Hidden_Salary = 'Y' then
                              Rc.Old_Wage
                             else
                              null
                           end,
                           case
                             when Rc.Access_To_Hidden_Salary = 'Y' then
                              Rc.New_Wage
                             else
                              null
                           end,
                           Rc.New_Rank_Id,
                           Rc.New_Rank_Name,
                           Rc.Access_To_Hidden_Salary)
      bulk collect
      into v_Matrix
      from (select q.Page_Id,
                   w.Change_Date,
                   q.Staff_Id,
                   q.Employee_Id,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = q.Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => q.Company_Id,
                                                i_Filial_Id  => q.Filial_Id,
                                                i_Staff_Id   => q.Staff_Id,
                                                i_Period     => w.Change_Date - 1) as Old_Rank_Id,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = w.Company_Id
                       and k.Filial_Id = w.Filial_Id
                       and k.Rank_Id =
                           Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => q.Company_Id,
                                                        i_Filial_Id  => q.Filial_Id,
                                                        i_Staff_Id   => q.Staff_Id,
                                                        i_Period     => w.Change_Date - 1)) as Old_Rank_Name,
                   Hpd_Util.Get_Closest_Wage(i_Company_Id => q.Company_Id,
                                             i_Filial_Id  => q.Filial_Id,
                                             i_Staff_Id   => q.Staff_Id,
                                             i_Period     => w.Change_Date - 1) as Old_Wage,
                   Hrm_Util.Closest_Wage(i_Company_Id    => q.Company_Id,
                                         i_Filial_Id     => q.Filial_Id,
                                         i_Wage_Scale_Id => Hpd_Util.Get_Closest_Wage_Scale_Id(i_Company_Id => q.Company_Id,
                                                                                               i_Filial_Id  => q.Filial_Id,
                                                                                               i_Staff_Id   => q.Staff_Id,
                                                                                               i_Period     => w.Change_Date),
                                         i_Period        => w.Change_Date,
                                         i_Rank_Id       => w.Rank_Id) as New_Wage,
                   w.Rank_Id as New_Rank_Id,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = w.Company_Id
                       and k.Filial_Id = w.Filial_Id
                       and k.Rank_Id = w.Rank_Id) as New_Rank_Name,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                                                                                    i_Filial_Id  => q.Filial_Id,
                                                                                                    i_Staff_Id   => q.Staff_Id,
                                                                                                    i_Period     => w.Change_Date),
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary
              from Hpd_Journal_Pages q
              join Hpd_Rank_Changes w
                on w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Page_Id = q.Page_Id
             where q.Company_Id = r_Journal.Company_Id
               and q.Filial_Id = r_Journal.Filial_Id
               and q.Journal_Id = r_Journal.Journal_Id) Rc;
  
    Result.Put('rank_changes', Fazo.Zip_Matrix(v_Matrix));
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
    p_Journal            Hpd_Pref.Rank_Change_Journal_Rt;
    v_Changes            Arraylist := p.r_Arraylist('rank_changes');
    v_Change             Hashmap;
    v_Page_Id            number;
    v_Staff_Id           number;
    v_Notification_Title varchar2(500);
    v_Posted             varchar2(1) := p.r_Varchar2('posted');
    v_Journal_Type_Id    number := p.r_Number('journal_type_id');
    v_User_Id            number := Ui.User_Id;
  begin
    Hpd_Util.Rank_Change_Journal_New(o_Journal         => p_Journal,
                                     i_Company_Id      => Ui.Company_Id,
                                     i_Filial_Id       => Ui.Filial_Id,
                                     i_Journal_Id      => i_Journal_Id,
                                     i_Journal_Number  => p.o_Varchar2('journal_number'),
                                     i_Journal_Date    => p.r_Date('journal_date'),
                                     i_Journal_Name    => p.o_Varchar2('journal_name'),
                                     i_Journal_Type_Id => v_Journal_Type_Id,
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
    
      Hpd_Util.Journal_Add_Rank_Change(p_Journal     => p_Journal,
                                       i_Page_Id     => v_Page_Id,
                                       i_Staff_Id    => v_Staff_Id,
                                       i_Change_Date => v_Change.r_Date('change_date'),
                                       i_Rank_Id     => v_Change.r_Number('rank_id'));
    end loop;
  
    -- notification title should make before saving journal
    if i_Exists = false and v_Posted = 'N' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Save(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => v_Journal_Type_Id);
    elsif i_Repost = false and v_Posted = 'Y' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => v_Journal_Type_Id);
    else
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Update(i_Company_Id      => p_Journal.Company_Id,
                                                                           i_User_Id         => v_User_Id,
                                                                           i_Journal_Type_Id => v_Journal_Type_Id);
    end if;
  
    Hpd_Api.Rank_Change_Journal_Save(p_Journal);
  
    if v_Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  
    -- notification send after saving journal
    Href_Core.Send_Notification(i_Company_Id    => p_Journal.Company_Id,
                                i_Filial_Id     => p_Journal.Filial_Id,
                                i_Title         => v_Notification_Title,
                                i_Uri           => Hpd_Pref.c_Form_Rank_Change_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                p_Journal.Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
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
           Org_Unit_Id     = null,
           Employee_Id     = null,
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
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null,
           Order_No   = null;
    Uie.x(Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => null,
                                       i_Filial_Id  => null,
                                       i_Staff_Id   => null,
                                       i_Period     => null));
  end;

end Ui_Vhr263;
/
