create or replace package Ui_Vhr35 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Document_To_Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Document_To_Progress(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Sign_Document(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Sign_Document(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr35;
/
create or replace package body Ui_Vhr35 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2 := Mdf_Pref.Document_Statuses;
    q        Fazo_Query;
  begin
    v_Query := 'select t.*,
                       (select k.application_id
                          from hpd_application_journals k
                         where k.company_id = t.company_id
                           and k.filial_id = t.filial_id
                           and k.journal_id = t.journal_id) application_id,
                       (select sd.status
                          from mdf_sign_documents sd
                         where sd.company_id = t.company_id
                           and sd.document_id = t.sign_document_id
                           and sd.filial_id = t.filial_id) as sign_document_status,
                       case
                         when exists (select 1
                                 from hpd_sign_templates st
                                where st.company_id = t.company_id
                                  and st.filial_id = t.filial_id
                                  and st.journal_type_id = t.journal_type_id) then
                            ''Y''
                           else
                            ''N''
                       end as has_sign_template
                  from hpd_journals t
                 where t.company_id = :company_id
                   and t.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and (not exists (select 1
                                         from hpd_journal_staffs je
                                         join href_staffs q
                                           on q.company_id = je.company_id
                                          and q.filial_id = je.filial_id
                                          and q.staff_id = je.staff_id
                                          and (q.employee_id = :user_id
                                           or q.org_unit_id not member of :division_ids)
                                          and (t.journal_type_id <> :tk_adjustment
                                           or q.employee_id <> :user_id)
                                        where je.company_id = t.company_id
                                          and je.filial_id = t.filial_id
                                          and je.journal_id = t.journal_id)
                              and exists (select 1
                                     from hpd_journal_staffs js
                                    where js.company_id = t.company_id
                                      and js.filial_id = t.filial_id
                                      and js.journal_id = t.journal_id)
                               or exists (select 1
                                     from mdf_sign_document_persons q
                                    where q.company_id = :company_id
                                      and q.document_id = t.sign_document_id
                                      and q.person_id = :user_id))';
    
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
      v_Params.Put('tk_adjustment',
                   Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                            i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('journal_id',
                   'journal_type_id',
                   'created_by',
                   'modified_by',
                   'posted_order_no',
                   'application_id');
  
    q.Varchar2_Field('journal_number',
                     'journal_name',
                     'posted',
                     'source_table',
                     'sign_document_status',
                     'has_sign_template');
    q.Date_Field('journal_date', 'created_on', 'modified_on');
  
    q.Multi_Number_Field('division_ids',
                         'select * from hpd_journal_divisions je where je.company_id = :company_id and je.filial_id = :filial_id',
                         '@journal_id=$journal_id',
                         'division_id');
  
    q.Refer_Field('division_names',
                  'division_ids',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
  
    q.Multi_Number_Field('employee_ids',
                         'select * from hpd_journal_employees je where je.company_id = :company_id and je.filial_id = :filial_id',
                         '@journal_id=$journal_id',
                         'employee_id');
  
    q.Refer_Field('employee_names',
                  'employee_ids',
                  'select * from mr_natural_persons mrp where mrp.company_id = :company_id',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1
                             from href_staffs s
                            where s.company_id = w.company_id
                              and s.filial_id = :filial_id
                              and s.employee_id = w.person_id)');
    q.Refer_Field('journal_type_name',
                  'journal_type_id',
                  'hpd_journal_types',
                  'journal_type_id',
                  'name',
                  'select *
                     from hpd_journal_types s
                    where s.company_id = :company_id');
    q.Refer_Field('pcode',
                  'journal_type_id',
                  'hpd_journal_types',
                  'journal_type_id',
                  'pcode',
                  'select *
                     from hpd_journal_types s
                    where s.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('sign_document_status_name', 'sign_document_status', v_Matrix(1), v_Matrix(2));
    q.Option_Field('has_sign_template_name',
                   'has_sign_template',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('application_number',
                  'application_id',
                  'hpd_applications',
                  'application_id',
                  'application_number',
                  'select *
                     from hpd_applications t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
  
    q.Map_Field('application_id2', '$application_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Easy_Report_Forms return Matrix_Varchar2 is
    v_Forms     Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Hiring,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Labor_Contract,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Hiring_Multiple,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Labor_Contract,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Transfer,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Transfer_Multiple,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Dismissal,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Dismissal_Multiple,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Sick_Leave,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave)),
                                                   Array_Varchar2(Hpd_Pref.c_Easy_Report_Form_Sick_Leave_Multiple,
                                                                  Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                           i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple)));
    v_Templates Matrix_Varchar2;
    result      Matrix_Varchar2 := Matrix_Varchar2();
  begin
    for i in 1 .. v_Forms.Count
    loop
      continue when not Md_Util.Grant_Has_Form(i_Company_Id   => Ui.Company_Id,
                                               i_Project_Code => Ui.Project_Code,
                                               i_Filial_Id    => Ui.Filial_Id,
                                               i_User_Id      => Ui.User_Id,
                                               i_Form         => v_Forms(i) (1));
    
      v_Templates := Uit_Ker.Templates(i_Form => v_Forms(i) (1));
    
      for j in 1 .. v_Templates.Count
      loop
        v_Templates(j).Extend();
        v_Templates(j)(v_Templates(j).Count) := v_Forms(i) (2);
      
        Result.Extend();
        result(Result.Count) := v_Templates(j);
      end loop;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Journal_Type_Id, q.Name, q.Pcode)
      bulk collect
      into v_Matrix
      from Hpd_Journal_Types q
     where q.Company_Id = Ui.Company_Id
     order by q.Order_No;
  
    Result.Put('journal_types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('pcode_hiring', Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    Result.Put('pcode_hiring_multiple', Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
    Result.Put('pcode_hiring_contract', Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor);
    Result.Put('pcode_transfer', Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    Result.Put('pcode_transfer_multiple', Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
    Result.Put('pcode_dismissal', Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    Result.Put('pcode_dismissal_multiple', Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple);
    Result.Put('pcode_wage_change', Hpd_Pref.c_Pcode_Journal_Type_Wage_Change);
    Result.Put('pcode_wage_change_multiple', Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple);
    Result.Put('pcode_rank_change', Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
    Result.Put('pcode_rank_change_multiple', Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple);
    Result.Put('pcode_schedule_change', Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
    Result.Put('pcode_vacation_limit_change', Hpd_Pref.c_Pcode_Journal_Type_Limit_Change);
    Result.Put('pcode_sick_leave', Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
    Result.Put('pcode_sick_leave_multiple', Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple);
    Result.Put('pcode_business_trip', Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
    Result.Put('pcode_business_trip_multiple',
               Hpd_Pref.c_Pcode_Journal_Type_Business_Trip_Multiple);
    Result.Put('pcode_vacation', Hpd_Pref.c_Pcode_Journal_Type_Vacation);
    Result.Put('pcode_vacation_multiple', Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple);
    Result.Put('pcode_overtime', Hpd_Pref.c_Pcode_Journal_Type_Overtime);
    Result.Put('pcode_timebook_adjustment', Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment);
    Result.Put('reports', Fazo.Zip_Matrix(Easy_Report_Forms));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
    v_Tmp_List        Arraylist;
    v_List            Arraylist := Arraylist();
    result            Hashmap := Hashmap();
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => v_Journal_Ids(i));
    
      v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Journal_Id => v_Journal_Ids(i)).Journal_Type_Id;
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                                i_User_Id         => v_User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => v_Company_Id,
                                                                               i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                  v_Journal_Ids(i),
                                                                  'journal_type_id',
                                                                  v_Journal_Type_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    
      v_Tmp_List := Hisl_Util.Journal_Requests(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id,
                                               i_Journal_Id => v_Journal_Ids(i));
    
      for j in 1 .. v_Tmp_List.Count
      loop
        v_List.Push(v_Tmp_List.r_Hashmap(j));
      end loop;
    end loop;
  
    if v_List.Count > 0 then
      Result.Put('cos_requests', v_List);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap) is
  begin
    Hisl_Api.Process_Response(i_Company_Id    => Ui.Company_Id,
                              i_Filial_Id     => Ui.Filial_Id,
                              i_Status        => p.r_Varchar2('status'),
                              i_Url           => p.r_Varchar2('url'),
                              i_Request_Body  => p.r_Varchar2('request_body'),
                              i_Response_Body => p.r_Varchar2('response_body'),
                              i_User_Id       => p.o_Number('user_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort_Desc(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Journal_Id => v_Journal_Ids(i));
    
      v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Journal_Id => v_Journal_Ids(i)).Journal_Type_Id;
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                  i_User_Id         => v_User_Id,
                                                                                                  i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => v_Company_Id,
                                                                               i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                  v_Journal_Ids(i),
                                                                  'journal_type_id',
                                                                  v_Journal_Type_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Document_To_Draft(p Hashmap) is
    r_Journal    Hpd_Journals%rowtype;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Filial_Id,
                                            i_Journal_Id => v_Ids(i));
    
      if r_Journal.Sign_Document_Id is not null then
        Mdf_Api.Document_Draft(i_Company_Id  => v_Company_Id,
                               i_Document_Id => r_Journal.Sign_Document_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Document_To_Progress(p Hashmap) is
    r_Journal    Hpd_Journals%rowtype;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Filial_Id,
                                            i_Journal_Id => v_Ids(i));
    
      if r_Journal.Sign_Document_Id is not null then
        Mdf_Api.Document_Process(i_Company_Id  => v_Company_Id,
                                 i_Document_Id => r_Journal.Sign_Document_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Sign_Document(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Journal_Ids Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Save_Journal_Sign_Document(i_Company_Id  => v_Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Journal_Id  => v_Journal_Ids(i),
                                         i_Document_Id => Mdf_Next.Document_Id,
                                         i_Lang_Code   => Ui_Context.Lang_Code);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Sign_Document(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Journal_Ids Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Save_Journal_Sign_Document(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => v_Filial_Id,
                                         i_Journal_Id => v_Journal_Ids(i),
                                         i_Lang_Code  => Ui_Context.Lang_Code,
                                         i_Is_Draft   => true);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Type_Id number;
    v_Journal_Ids     Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Journal_Id => v_Journal_Ids(i)).Journal_Type_Id;
    
      Hpd_Api.Journal_Delete(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Journal_Id => v_Journal_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpd_Util.t_Notification_Title_Journal_Delete(i_Company_Id      => v_Company_Id,
                                                                                                  i_User_Id         => v_User_Id,
                                                                                                  i_Journal_Type_Id => v_Journal_Type_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Journals
       set Company_Id      = null,
           Filial_Id       = null,
           Journal_Id      = null,
           Journal_Type_Id = null,
           Journal_Number  = null,
           Journal_Date    = null,
           Journal_Name    = null,
           Posted          = null,
           Source_Table    = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Hpd_Journal_Staffs
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Staff_Id   = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Division_Id = null,
           Org_Unit_Id = null;
    update Hpd_Journal_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Journal_Id  = null,
           Employee_Id = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Hpd_Applications
       set Company_Id         = null,
           Filial_Id          = null,
           Application_Id     = null,
           Application_Number = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Hpd_Application_Journals
       set Company_Id     = null,
           Filial_Id      = null,
           Application_Id = null,
           Journal_Id     = null;
    update Mdf_Sign_Documents
       set Company_Id  = null,
           Document_Id = null,
           Filial_Id   = null,
           Status      = null;
  end;

end Ui_Vhr35;
/
