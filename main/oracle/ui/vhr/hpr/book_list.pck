create or replace package Ui_Vhr63 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap);
end Ui_Vhr63;
/
create or replace package body Ui_Vhr63 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap;
  begin
    select Array_Varchar2(q.Book_Type_Id, q.Name)
      bulk collect
      into v_Matrix
      from Hpr_Book_Types q
     where q.Company_Id = Ui.Company_Id
     order by q.Order_No;
  
    Result.Put('book_types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('month', to_char(Add_Months(sysdate, -1), Href_Pref.c_Date_Format_Month));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Month  date := p.o_Date('month', Href_Pref.c_Date_Format_Month);
  begin
    v_Query := 'select bk.book_id,
                       bk.book_number,
                       bk.book_date,
                       bk.book_name,
                       bk.month,
                       bk.division_id,
                       bk.currency_id,
                       (select mk.round_model
                          from mk_currencies mk
                         where mk.company_id = :company_id
                           and mk.currency_id = bk.currency_id) as round_model,
                       bk.posted,
                       bk.barcode,
                       bk.note,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_accrued_amount
                          else
                           -1
                        end) c_accrued_amount,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_accrued_amount_base
                          else
                           -1
                        end) c_accrued_amount_base,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_deducted_amount
                          else
                           -1
                        end) c_deducted_amount,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_deducted_amount_base
                          else
                           -1
                        end) c_deducted_amount_base,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_income_tax_amount
                          else
                           -1
                        end) c_income_tax_amount,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_pension_payment_amount
                          else
                           -1
                        end) c_pension_payment_amount,
                       (case
                          when bk.access_to_hidden_salary = ''Y'' then
                           bk.c_social_payment_amount
                          else
                           -1
                        end) c_social_payment_amount,
                       bk.book_type_id,
                       bk.created_by,
                       bk.created_on,
                       bk.modified_by,
                       bk.modified_on
                  from (select w.*,
                               q.book_type_id,
                               (case
                                  when exists
                                   (select 1
                                          from hpr_book_operations o
                                          join mpr_book_operations k
                                            on k.company_id = o.company_id
                                           and k.filial_id = o.filial_id
                                           and k.book_id = o.book_id
                                           and k.operation_id = o.operation_id
                                         where o.company_id = q.company_id
                                           and o.filial_id = q.filial_id
                                           and o.book_id = q.book_id
                                           and uit_hrm.access_to_hidden_salary_job(i_job_id      => (select ch.job_id
                                                                                                       from hpr_charges ch
                                                                                                      where ch.company_id =
                                                                                                            o.company_id
                                                                                                        and ch.filial_id =
                                                                                                            o.filial_id
                                                                                                        and ch.charge_id =
                                                                                                            o.charge_id),
                                                                                   i_employee_id => k.employee_id) = ''N'') then
                                   ''N''
                                  else
                                   ''Y''
                                end) access_to_hidden_salary
                          from hpr_books q
                          join mpr_books w
                            on w.company_id = q.company_id
                           and w.filial_id = q.filial_id
                           and w.book_id = q.book_id
                           and (:month is null or w.month = :month)
                         where q.company_id = :company_id
                           and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'month',
                             v_Month);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query ||
                 ' and not exists (select 1
                              from hpr_book_operations bo
                              join href_staffs st
                                on st.company_id = bo.company_id
                               and st.filial_id = bo.filial_id
                               and st.staff_id = bo.staff_id
                             where bo.company_id = :company_id
                               and bo.filial_id = :filial_id
                               and bo.book_id = q.book_id
                               and st.employee_id <> :user_id
                               and hpd_util.get_closest_org_unit_id(i_company_id => bo.company_id,
                                                                    i_filial_id  => bo.filial_id,
                                                                    i_staff_id   => bo.staff_id,
                                                                    i_period     => least(last_day(w.month),
                                                                                          nvl(st.dismissal_date,
                                                                                              last_day(w.month)))) not member of :division_ids)';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
      v_Params.Put('user_id', Ui.User_Id);
    end if;
  
    v_Query := v_Query || ') bk';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('book_id',
                   'currency_id',
                   'division_id',
                   'c_accrued_amount',
                   'c_accrued_amount_base',
                   'c_deducted_amount',
                   'c_deducted_amount_base',
                   'c_income_tax_amount',
                   'c_pension_payment_amount',
                   'c_social_payment_amount');
    q.Number_Field('book_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('book_number', 'round_model', 'posted', 'barcode', 'note', 'book_name');
    q.Date_Field('book_date', 'month', 'created_on', 'modified_on');
  
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
                     from mk_currencies w
                    where w.company_id = :company_id');
    q.Refer_Field('book_type_name',
                  'book_type_id',
                  'hpr_book_types',
                  'book_type_id',
                  'name',
                  'select *
                     from hpr_book_types w
                    where w.company_id = :company_id');
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
  
    q.Map_Field('scale',
                'select to_number(Substr($round_model, 1, 4), ''S9D9'', ''NLS_NUMERIC_CHARACTERS=''''. '''''') 
                   from dual');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_User_Id    number := Ui.User_Id;
    r_Book       Mpr_Books%rowtype;
    v_Book_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('book_id'));
  begin
    for i in 1 .. v_Book_Ids.Count
    loop
      Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Ids(i));
    
      r_Book := z_Mpr_Books.Load(i_Company_Id => v_Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Book_Id    => v_Book_Ids(i));
    
      Hpr_Api.Book_Delete(i_Company_Id => v_Company_Id,
                          i_Filial_Id  => v_Filial_Id,
                          i_Book_Id    => v_Book_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => r_Book.Company_Id,
                                  i_Filial_Id     => r_Book.Filial_Id,
                                  i_Title         => Hpr_Util.t_Notification_Title_Book_Delete(i_Company_Id  => v_Company_Id,
                                                                                               i_User_Id     => v_User_Id,
                                                                                               i_Book_Number => r_Book.Book_Number,
                                                                                               i_Month       => r_Book.Month),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_User_Id    number := Ui.User_Id;
    r_Book       Mpr_Books%rowtype;
    v_Book_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('book_id'));
  begin
    for i in 1 .. v_Book_Ids.Count
    loop
      Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Ids(i));
    
      Hpr_Api.Book_Post(i_Company_Id => v_Company_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Book_Id    => v_Book_Ids(i));
    
      r_Book := z_Mpr_Books.Load(i_Company_Id => v_Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Book_Id    => v_Book_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => r_Book.Company_Id,
                                  i_Filial_Id     => r_Book.Filial_Id,
                                  i_Title         => Hpr_Util.t_Notification_Title_Book_Post(i_Company_Id  => v_Company_Id,
                                                                                             i_User_Id     => v_User_Id,
                                                                                             i_Book_Number => r_Book.Book_Number,
                                                                                             i_Month       => r_Book.Month),
                                  i_Uri           => Hpr_Pref.c_Form_Book_View,
                                  i_Uri_Param     => Fazo.Zip_Map('book_id', r_Book.Book_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_User_Id    number := Ui.User_Id;
    r_Book       Mpr_Books%rowtype;
    v_Book_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('book_id'));
  begin
    for i in 1 .. v_Book_Ids.Count
    loop
      Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Ids(i));
    
      Hpr_Api.Book_Unpost(i_Company_Id => v_Company_Id,
                          i_Filial_Id  => v_Filial_Id,
                          i_Book_Id    => v_Book_Ids(i));
    
      r_Book := z_Mpr_Books.Load(i_Company_Id => v_Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Book_Id    => v_Book_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => r_Book.Company_Id,
                                  i_Filial_Id     => r_Book.Filial_Id,
                                  i_Title         => Hpr_Util.t_Notification_Title_Book_Unpost(i_Company_Id  => v_Company_Id,
                                                                                               i_User_Id     => v_User_Id,
                                                                                               i_Book_Number => r_Book.Book_Number,
                                                                                               i_Month       => r_Book.Month),
                                  i_Uri           => Hpr_Pref.c_Form_Book_View,
                                  i_Uri_Param     => Fazo.Zip_Map('book_id', r_Book.Book_Id),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap) is
  begin
    Ui.Grant_Check('transactions');
  
    Uit_Mkr.Journal_Transactions_Run(i_Company_Id   => Ui.Company_Id,
                                     i_Filial_Id    => Ui.Filial_Id,
                                     i_Journal_Code => Mpr_Util.Jcode_Book(p.r_Number('book_id')),
                                     i_Report_Type  => p.r_Varchar2('rt'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mpr_Books
       set Company_Id               = null,
           Filial_Id                = null,
           Book_Id                  = null,
           Book_Number              = null,
           Book_Date                = null,
           month                    = null,
           Division_Id              = null,
           Posted                   = null,
           Barcode                  = null,
           Note                     = null,
           c_Accrued_Amount         = null,
           c_Accrued_Amount_Base    = null,
           c_Deducted_Amount        = null,
           c_Deducted_Amount_Base   = null,
           c_Income_Tax_Amount      = null,
           c_Pension_Payment_Amount = null,
           c_Social_Payment_Amount  = null,
           Created_By               = null,
           Created_On               = null,
           Modified_By              = null,
           Modified_On              = null;
    update Hpr_Books
       set Company_Id   = null,
           Filial_Id    = null,
           Book_Id      = null,
           Book_Type_Id = null;
    update Hpr_Book_Types
       set Company_Id   = null,
           Book_Type_Id = null,
           name         = null,
           Pcode        = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update Hpr_Book_Types
       set Company_Id   = null,
           Book_Type_Id = null,
           name         = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Hpr_Book_Operations
       set Company_Id   = null,
           Filial_Id    = null,
           Book_Id      = null,
           Operation_Id = null,
           Charge_Id    = null;
    update Hpr_Charges
       set Company_Id = null,
           Filial_Id  = null,
           Charge_Id  = null,
           Job_Id     = null;
    update Mpr_Book_Operations
       set Company_Id   = null,
           Filial_Id    = null,
           Book_Id      = null,
           Operation_Id = null,
           Employee_Id  = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Employee_Id    = null,
           Dismissal_Date = null;
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(null, null));
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
  end;

end Ui_Vhr63;
/
