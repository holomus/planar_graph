create or replace package Ui_Vhr680 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Credit_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Book(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Archive(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Complete(p Hashmap);
end Ui_Vhr680;
/
create or replace package body Ui_Vhr680 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Credit_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select * 
                       from x_hpr_credits q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.credit_id = :credit_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'credit_id',
                                 p.r_Number('credit_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'credit_id',
                   'employee_id',
                   'credit_amount',
                   'currency_id',
                   'cashbox_id',
                   'bank_account_id');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'credit_number',
                     'payment_type',
                     'status',
                     'note');
    q.Date_Field('t_timestamp', 't_date', 'credit_date', 'booked_date', 'begin_month', 'end_month');
  
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
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from mhr_employees uf
                            where uf.company_id = :company_id
                              and uf.filial_id = :filial_id
                              and uf.employee_id = w.person_id)');
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies w
                    where w.company_id = :company_id');
    q.Refer_Field('bank_account_name',
                  'bank_account_id',
                  'mkcs_bank_accounts',
                  'bank_account_id',
                  'name',
                  'select *
                     from mkcs_bank_accounts w
                    where w.company_id = :company_id');
    q.Refer_Field('cashbox_name',
                  'cashbox_id',
                  'mkcs_cashboxes',
                  'cashbox_id',
                  'name',
                  'select *
                     from mkcs_cashboxes w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
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
  
    v_Matrix := Mpr_Util.Payment_Types;
    q.Option_Field('payment_type_name', 'payment_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpr_Util.Credit_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Credit Hpr_Credits%rowtype;
    result   Hashmap;
  begin
    r_Credit := z_Hpr_Credits.Load(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Credit_Id  => p.r_Number('credit_id'));
  
    result := z_Hpr_Credits.To_Map(r_Credit,
                                   z.Credit_Id,
                                   z.Credit_Number,
                                   z.Credit_Date,
                                   z.Booked_Date,
                                   z.Begin_Month,
                                   z.End_Month,
                                   z.Credit_Amount,
                                   z.Status,
                                   z.Note,
                                   z.Created_On,
                                   z.Modified_On);
  
    Result.Put('status_name', Hpr_Util.t_Credit_Status(r_Credit.Status));
    Result.Put('payment_type_name', Mpr_Util.t_Payment_Type(r_Credit.Payment_Type));
    Result.Put('begin_month', to_char(r_Credit.Begin_Month, 'Month YYYY'));
    Result.Put('end_month', to_char(r_Credit.End_Month, 'Month yyyy'));
    Result.Put('employee_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Credit.Company_Id, i_Person_Id => r_Credit.Employee_Id).Name);
    Result.Put('currency_name',
               z_Mk_Currencies.Load(i_Company_Id => r_Credit.Company_Id, i_Currency_Id => r_Credit.Currency_Id).Name);
  
    if r_Credit.Payment_Type = Mpr_Pref.c_Pt_Cashbox then
      Result.Put('cashbox_name',
                 z_Mkcs_Cashboxes.Take(i_Company_Id => r_Credit.Company_Id, i_Cashbox_Id => r_Credit.Cashbox_Id).Name);
    else
      Result.Put('bank_account_name',
                 z_Mkcs_Bank_Accounts.Take(i_Company_Id => r_Credit.Company_Id, i_Bank_Account_Id => r_Credit.Bank_Account_Id).Name);
    end if;
  
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Credit.Company_Id, i_User_Id => r_Credit.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Credit.Company_Id, i_User_Id => r_Credit.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Draft(p Hashmap) is
  begin
    Hpr_Api.Credit_Draft(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Credit_Id  => p.r_Number('credit_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Book(p Hashmap) is
  begin
    Hpr_Api.Credit_Book(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Credit_Id  => p.r_Number('credit_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Archive(p Hashmap) is
  begin
    Hpr_Api.Credit_Archive(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Credit_Id  => p.r_Number('credit_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Complete(p Hashmap) is
  begin
    Hpr_Api.Credit_Complete(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Credit_Id  => p.r_Number('credit_id'));
  end;

end Ui_Vhr680;
/
