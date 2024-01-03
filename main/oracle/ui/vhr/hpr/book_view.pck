create or replace package Ui_Vhr170 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Operations(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Book_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Operation_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr170;
/
create or replace package body Ui_Vhr170 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR170:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Operations(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2 := Mpr_Util.Operation_Kinds;
  begin
    q := Fazo_Query('select bk.operation_id,
                            bk.employee_id,
                            bk.oper_type_id,
                            case
                               when bk.access_to_hidden_salary = ''Y'' then
                                bk.amount
                               else
                                -1
                             end amount,
                            case
                               when bk.access_to_hidden_salary = ''Y'' then
                                bk.amount_base
                               else
                                -1
                             end amount_base,
                            case
                               when bk.access_to_hidden_salary = ''Y'' then
                                bk.net_amount
                               else
                                -1
                             end net_amount,
                            case
                               when bk.access_to_hidden_salary = ''Y'' then
                                bk.income_tax_amount
                               else
                                -1
                             end income_tax_amount,
                            case
                               when bk.access_to_hidden_salary = ''Y'' then
                                bk.pension_payment_amount
                               else
                                -1
                             end pension_payment_amount,
                            case
                               when bk.access_to_hidden_salary = ''Y'' then
                                bk.social_payment_amount
                               else
                                -1
                             end social_payment_amount,
                            bk.order_no,
                            bk.operation_kind,
                            bk.iapa,
                            bk.npin,
                            bk.tin,
                            bk.note
                       from (select q.*,
                                    pd.iapa,
                                    pd.npin,
                                    (select mp.tin
                                       from mr_person_details mp
                                      where mp.company_id = q.company_id
                                        and mp.person_id = q.employee_id) tin,
                                    w.operation_kind,
                                    uit_hrm.access_to_hidden_salary_job(i_job_id      => (select ch.job_id
                                                                                            from hpr_charges ch
                                                                                           where ch.company_id =
                                                                                                 o.company_id
                                                                                             and ch.filial_id = o.filial_id
                                                                                             and ch.charge_id = o.charge_id),
                                                                        i_employee_id => q.employee_id) access_to_hidden_salary
                               from mpr_book_operations q
                               join hpr_book_operations o
                                 on q.company_id = o.company_id
                                and q.filial_id = o.filial_id
                                and q.book_id = o.book_id
                                and q.operation_id = o.operation_id
                               join mpr_oper_types w
                                 on w.company_id = q.company_id
                                and w.oper_type_id = q.oper_type_id
                               left join href_person_details pd
                                 on pd.company_id = q.company_id
                                and pd.person_id = q.employee_id
                              where q.company_id = :company_id
                                and q.filial_id = :filial_id
                                and q.book_id = :book_id) bk',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'book_id',
                                 p.r_Number('book_id')));
  
    q.Number_Field('operation_id',
                   'employee_id',
                   'oper_type_id',
                   'amount',
                   'amount_base',
                   'net_amount',
                   'income_tax_amount',
                   'pension_payment_amount',
                   'social_payment_amount',
                   'order_no');
    q.Varchar2_Field('operation_kind', 'iapa', 'npin', 'tin', 'note');
  
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons s
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees f
                            where f.company_id = s.company_id
                              and f.filial_id = :filial_id
                              and f.employee_id = s.person_id)');
    q.Refer_Field('oper_type_name',
                  'oper_type_id',
                  'mpr_oper_types',
                  'oper_type_id',
                  'name',
                  'select *
                     from mpr_oper_types
                    where company_id = :company_id');
  
    q.Option_Field('operation_kind_name', 'operation_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Book_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_mpr_books q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.book_id = :book_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'book_id',
                                 p.r_Number('book_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'division_id',
                   'currency_id');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'book_number',
                     'book_name',
                     'posted',
                     'barcode',
                     'note');
    q.Date_Field('t_timestamp', 't_date', 'book_date', 'month');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, --
                                  Ui.t_No));
  
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies s
                    where s.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Operation_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_mpr_book_operations q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.book_id = :book_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'book_id',
                                 p.r_Number('book_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'employee_id',
                   'oper_type_id',
                   'amount',
                   'amount_base',
                   'net_amount',
                   'income_tax_amount');
    q.Number_Field('pension_payment_amount', 'social_payment_amount');
    q.Varchar2_Field('t_event', 't_source_project_code', 'note');
    q.Date_Field('t_timestamp', 't_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons s
                    where s.company_id = :company_id
                      and exists (select 1
                             from x_mpr_book_operations w
                            where w.t_company_id = s.company_id
                              and w.t_filial_id = :filial_id
                              and w.employee_id = s.person_id)');
    q.Refer_Field('oper_type_name',
                  'oper_type_id',
                  'mpr_oper_types',
                  'oper_type_id',
                  'name',
                  'select *
                     from mpr_oper_types
                    where company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_User_Id    number := Ui.User_Id;
    v_Book_Id    number := p.r_Number('book_id');
  begin
    Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Id);
  
    Hpr_Api.Book_Post(i_Company_Id => v_Company_Id,
                      i_Filial_Id  => v_Filial_Id,
                      i_Book_Id    => v_Book_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpr_Util.t_Notification_Title_Book_Post(i_Company_Id  => v_Company_Id,
                                                                                           i_User_Id     => v_User_Id,
                                                                                           i_Book_Number => p.r_Varchar2('book_number'),
                                                                                           i_Month       => p.r_Date('month')),
                                i_Uri           => Hpr_Pref.c_Form_Book_View,
                                i_Uri_Param     => Fazo.Zip_Map('book_id', v_Book_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_User_Id    number := Ui.User_Id;
    v_Book_Id    number := p.r_Number('book_id');
  begin
    Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Id);
  
    Hpr_Api.Book_Unpost(i_Company_Id => v_Company_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Book_Id    => v_Book_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpr_Util.t_Notification_Title_Book_Unpost(i_Company_Id  => v_Company_Id,
                                                                                             i_User_Id     => v_User_Id,
                                                                                             i_Book_Number => p.r_Varchar2('book_number'),
                                                                                             i_Month       => p.r_Date('month')),
                                i_Uri           => Hpr_Pref.c_Form_Book_View,
                                i_Uri_Param     => Fazo.Zip_Map('book_id', v_Book_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Data                    Mpr_Books%rowtype;
    r_Currency                Mk_Currencies%rowtype;
    v_Book_Type_Id            number;
    v_Access_To_Hidden_Salary varchar2(1);
    v_Book_Id                 number := p.r_Number('book_id');
    result                    Hashmap := Hashmap;
  
    --------------------------------------------------
    Function Get_Access_To_Hidden_Salary return varchar2 is
      v_Dummy varchar2(1);
    begin
      select 'X'
        into v_Dummy
        from Hpr_Book_Operations q
        join Mpr_Book_Operations k
          on q.Company_Id = k.Company_Id
         and q.Filial_Id = k.Filial_Id
         and q.Book_Id = k.Book_Id
         and q.Operation_Id = k.Operation_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Book_Id = r_Data.Book_Id
         and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => (select Ch.Job_Id
                                                                     from Hpr_Charges Ch
                                                                    where Ch.Company_Id =
                                                                          q.Company_Id
                                                                      and Ch.Filial_Id = q.Filial_Id
                                                                      and Ch.Charge_Id = q.Charge_Id),
                                                 i_Employee_Id => k.Employee_Id) = 'N'
         and Rownum = 1;
    
      return 'N';
    exception
      when No_Data_Found then
        return 'Y';
    end;
  begin
    Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Id);
  
    r_Data := z_Mpr_Books.Load(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Book_Id    => v_Book_Id);
  
    result := z_Mpr_Books.To_Map(r_Data,
                                 z.Book_Id,
                                 z.Book_Number,
                                 z.Book_Date,
                                 z.Book_Name,
                                 z.Month,
                                 z.Posted,
                                 z.Note,
                                 z.Created_On,
                                 z.Modified_On);
  
    v_Access_To_Hidden_Salary := Get_Access_To_Hidden_Salary;
  
    Result.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary);
  
    if v_Access_To_Hidden_Salary = 'Y' then
      Result.Put('c_accrued_amount', r_Data.c_Accrued_Amount);
      Result.Put('c_accrued_amount_base', r_Data.c_Accrued_Amount_Base);
      Result.Put('c_deducted_amount', r_Data.c_Deducted_Amount);
      Result.Put('c_deducted_amount_base', r_Data.c_Deducted_Amount_Base);
      Result.Put('c_income_tax_amount', r_Data.c_Income_Tax_Amount);
      Result.Put('c_pension_payment_amount', r_Data.c_Pension_Payment_Amount);
      Result.Put('c_social_payment_amount', r_Data.c_Social_Payment_Amount);
    end if;
  
    v_Book_Type_Id := z_Hpr_Books.Load(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Book_Id => r_Data.Book_Id).Book_Type_Id;
  
    Result.Put('month', to_char(r_Data.Month, 'Month yyyy'));
    Result.Put('book_type_name',
               z_Hpr_Book_Types.Load(i_Company_Id => r_Data.Company_Id, i_Book_Type_Id => v_Book_Type_Id).Name);
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, --
               i_Filial_Id => r_Data.Filial_Id, --
               i_Division_Id => r_Data.Division_Id).Name);
  
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => r_Data.Company_Id,
                                       i_Currency_Id => r_Data.Currency_Id);
  
    Result.Put('currency_name', r_Currency.Name);
    Result.Put('round_model', r_Currency.Round_Model);
    Result.Put('scale',
               to_number(Substr(r_Currency.Round_Model, 1, 4),
                         'S9D9',
                         'NLS_NUMERIC_CHARACTERS=''. '''));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mpr_Book_Operations
       set Company_Id             = null,
           Filial_Id              = null,
           Book_Id                = null,
           Operation_Id           = null,
           Employee_Id            = null,
           Oper_Type_Id           = null,
           Amount                 = null,
           Amount_Base            = null,
           Net_Amount             = null,
           Income_Tax_Amount      = null,
           Pension_Payment_Amount = null,
           Social_Payment_Amount  = null,
           Order_No               = null;
    update Hpr_Book_Operations
       set Company_Id   = null,
           Filial_Id    = null,
           Book_Id      = null,
           Operation_Id = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Mr_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Tin        = null;
    update x_Mpr_Books
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Session_Id          = null,
           t_Context_Id          = null,
           Book_Id               = null,
           Book_Number           = null,
           Book_Date             = null,
           Book_Name             = null,
           month                 = null,
           Division_Id           = null,
           Currency_Id           = null,
           Posted                = null,
           Barcode               = null,
           Note                  = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update x_Mpr_Book_Operations
       set t_Company_Id           = null,
           t_Audit_Id             = null,
           t_Filial_Id            = null,
           t_Event                = null,
           t_Timestamp            = null,
           t_Date                 = null,
           t_User_Id              = null,
           t_Source_Project_Code  = null,
           t_Session_Id           = null,
           t_Context_Id           = null,
           Book_Id                = null,
           Operation_Id           = null,
           Employee_Id            = null,
           Oper_Type_Id           = null,
           Amount                 = null,
           Amount_Base            = null,
           Net_Amount             = null,
           Income_Tax_Amount      = null,
           Pension_Payment_Amount = null,
           Social_Payment_Amount  = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null;
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
  end;

end Ui_Vhr170;
/
