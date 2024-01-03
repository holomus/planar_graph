create or replace package Ui_Vhr59 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Accruals return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Deductions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Accruals(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del_Deductions(p Hashmap);
end Ui_Vhr59;
/
create or replace package body Ui_Vhr59 is
  ----------------------------------------------------------------------------------------------------
  Function Query(i_Operation_Kind varchar2) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*, 
                            s.oper_group_id,
                            s.estimation_type,
                            s.estimation_formula
                       from mpr_oper_types q 
                       left join hpr_oper_types s
                         on q.company_id = s.company_id
                        and q.oper_type_id = s.oper_type_id
                      where q.company_id = :company_id
                        and q.operation_kind = :operation_kind',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'operation_kind', i_Operation_Kind));
  
    q.Number_Field('oper_type_id',
                   'oper_group_id',
                   'corr_coa_id',
                   'income_tax_rate',
                   'pension_payment_rate',
                   'social_payment_rate',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('name',
                     'short_name',
                     'accounting_type',
                     'corr_ref_set',
                     'income_tax_exists',
                     'pension_payment_exists',
                     'social_payment_exists',
                     'note',
                     'state',
                     'code');
    q.Varchar2_Field('estimation_type', 'estimation_formula', 'operation_kind', 'pcode');
    q.Date_Field('created_on', 'modified_on');
  
    v_Matrix := Mpr_Util.Accounting_Types;
  
    q.Option_Field('accounting_type_name', 'accounting_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpr_Util.Estimation_Types;
  
    q.Option_Field('estimation_type_name', 'estimation_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('income_tax_exists_name',
                   'income_tax_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('pension_payment_exists_name',
                   'pension_payment_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('social_payment_exists_name',
                   'social_payment_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Refer_Field('oper_group_name',
                  'oper_group_id',
                  'hpr_oper_groups',
                  'oper_group_id',
                  'name',
                  'select *
                     from hpr_oper_groups
                    where company_id = :company_id');
    q.Refer_Field('corr_coa_name',
                  'corr_coa_id',
                  'mk_coa',
                  'coa_id',
                  'gen_name',
                  'select *
                     from mk_coa
                    where company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users 
                    where company_id = :company_id');
  
    q.Map_Field('corr_ref_set_name', 'mk_util.ref_names(:company_id, $corr_ref_set)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Accruals return Fazo_Query is
  begin
    return Query(Mpr_Pref.c_Ok_Accrual);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Deductions return Fazo_Query is
  begin
    return Query(Mpr_Pref.c_Ok_Deduction);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del
  (
    i_Operation_Kind varchar2,
    p                Hashmap
  ) is
    r_Data           Hpr_Oper_Types%rowtype;
    v_Operation_Kind varchar2(1);
    v_Oper_Type_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('oper_type_id'));
  begin
    for i in 1 .. v_Oper_Type_Ids.Count
    loop
      v_Operation_Kind := z_Mpr_Oper_Types.Take(i_Company_Id => Ui.Company_Id, --
                          i_Oper_Type_Id => v_Oper_Type_Ids(i)).Operation_Kind;
    
      r_Data := z_Hpr_Oper_Types.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                           i_Oper_Type_Id => v_Oper_Type_Ids(i));
    
      if v_Operation_Kind != i_Operation_Kind then
        b.Raise_Not_Implemented;
      end if;
    
      Hpr_Api.Oper_Type_Delete(i_Company_Id   => Ui.Company_Id, --
                               i_Oper_Type_Id => v_Oper_Type_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Accruals(p Hashmap) is
  begin
    Del(Mpr_Pref.c_Ok_Accrual, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Deductions(p Hashmap) is
  begin
    Del(Mpr_Pref.c_Ok_Deduction, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mpr_Oper_Types
       set Company_Id             = null,
           Oper_Type_Id           = null,
           Operation_Kind         = null,
           name                   = null,
           Short_Name             = null,
           Accounting_Type        = null,
           Corr_Coa_Id            = null,
           Corr_Ref_Set           = null,
           Income_Tax_Exists      = null,
           Income_Tax_Rate        = null,
           Pension_Payment_Exists = null,
           Pension_Payment_Rate   = null,
           Social_Payment_Exists  = null,
           Social_Payment_Rate    = null,
           Note                   = null,
           State                  = null,
           Code                   = null,
           Pcode                  = null,
           Created_By             = null,
           Created_On             = null,
           Modified_By            = null,
           Modified_On            = null;
    update Hpr_Oper_Types
       set Company_Id         = null,
           Oper_Type_Id       = null,
           Oper_Group_Id      = null,
           Estimation_Type    = null,
           Estimation_Formula = null;
    update Hpr_Oper_Groups
       set Oper_Group_Id  = null,
           Operation_Kind = null,
           name           = null;
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           Gen_Name   = null,
           State      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    Uie.x(Mk_Util.Ref_Names(null, ''));
  end;

end Ui_Vhr59;
/
