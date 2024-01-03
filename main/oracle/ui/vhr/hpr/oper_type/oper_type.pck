create or replace package Ui_Vhr61 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Coas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Origins(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Coa_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Accrual_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Deduction_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Accrual_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Deduction_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Formula_Validate(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr61;
/
create or replace package body Ui_Vhr61 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hpr_oper_groups', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('oper_group_id');
    q.Varchar2_Field('operation_kind', 'name', 'estimation_type', 'estimation_formula');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Coas return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_coa', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('coa_id');
    q.Varchar2_Field('gen_name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Origins(p Hashmap) return Fazo_Query is
  begin
    return Mkr_Util.Origin_Query(i_Ref_Origin_Id => p.r_Number('ref_origin_id'),
                                 i_Params        => Fazo.Zip_Map('company_id',
                                                                 Ui.Company_Id,
                                                                 'filial_id',
                                                                 Ui.Filial_Id,
                                                                 'project_code',
                                                                 Ui.Project_Code));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Coa_Info(p Hashmap) return Hashmap is
  begin
    return Mkr_Util.Coa_Info(i_Company_Id => Ui.Company_Id, --
                             i_Coa_Id     => p.r_Number('coa_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Ref_Name(p Hashmap) return varchar2 is
  begin
    return Mk_Util.Ref_Name(i_Company_Id => Ui.Company_Id,
                            i_Ref_Type   => p.r_Number('ref_type'),
                            i_Ref_Id     => p.r_Number('ref_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Wage_Indicator_Group number;
  
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    Result.Put('origin_kind_query', Mkr_Pref.c_Ok_Query);
    Result.Put('origin_kind_date', Mkr_Pref.c_Ok_Date);
    Result.Put('origin_kind_number', Mkr_Pref.c_Ok_Number);
    Result.Put('origin_kind_text', Mkr_Pref.c_Ok_Text);
  
    Result.Put('accounting_types', Fazo.Zip_Matrix(Mpr_Util.Accounting_Types));
    Result.Put('estimation_types', Fazo.Zip_Matrix(Hpr_Util.Estimation_Types));
  
    v_Wage_Indicator_Group := Href_Util.Indicator_Group_Id(i_Company_Id => Ui.Company_Id,
                                                           i_Pcode      => Href_Pref.c_Pcode_Indicator_Group_Wage);
  
    select Array_Varchar2(t.Indicator_Id, t.Name, t.Identifier)
      bulk collect
      into v_Matrix
      from Href_Indicators t
     where t.Company_Id = Ui.Company_Id
       and t.Indicator_Group_Id = v_Wage_Indicator_Group;
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('operation_kinds', Fazo.Zip_Matrix(Mpr_Util.Operation_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(i_Operation_Kind varchar2) return Hashmap is
    v_Data Hashmap;
    result Hashmap := Hashmap();
  begin
    v_Data := Fazo.Zip_Map('operation_kind',
                           i_Operation_Kind,
                           'accounting_type',
                           Mpr_Pref.c_At_Employee,
                           'estimation_type',
                           Hpr_Pref.c_Estimation_Type_Formula,
                           'state',
                           'A');
  
    if i_Operation_Kind = Mpr_Pref.c_Ok_Accrual then
      v_Data.Put('income_tax_exists', 'N');
      v_Data.Put('pension_payment_exists', 'N');
      v_Data.Put('social_payment_exists', 'N');
    end if;
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Accrual_Model return Hashmap is
  begin
    return Add_Model(Mpr_Pref.c_Ok_Accrual);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Deduction_Model return Hashmap is
  begin
    return Add_Model(Mpr_Pref.c_Ok_Deduction);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model
  (
    i_Operation_Kind varchar2,
    p                Hashmap
  ) return Hashmap is
    r_Oper_Type       Mpr_Oper_Types%rowtype;
    r_Oper_Type_Extra Hpr_Oper_Types%rowtype;
    v_Coa_Info        Hashmap;
    v_Data            Hashmap;
    result            Hashmap := Hashmap();
  begin
    r_Oper_Type := z_Mpr_Oper_Types.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                              i_Oper_Type_Id => p.r_Number('oper_type_id'));
  
    if r_Oper_Type.Operation_Kind != i_Operation_Kind then
      b.Raise_Not_Implemented;
    end if;
  
    r_Oper_Type_Extra := z_Hpr_Oper_Types.Take(i_Company_Id   => Ui.Company_Id,
                                               i_Oper_Type_Id => p.r_Number('oper_type_id'));
  
    v_Data := z_Mpr_Oper_Types.To_Map(r_Oper_Type,
                                      z.Oper_Type_Id,
                                      z.Operation_Kind,
                                      z.Name,
                                      z.Short_Name,
                                      z.Accounting_Type,
                                      z.Corr_Coa_Id,
                                      z.Corr_Ref_Set,
                                      z.Income_Tax_Exists,
                                      z.Income_Tax_Rate,
                                      z.Pension_Payment_Exists,
                                      z.Pension_Payment_Rate,
                                      z.Social_Payment_Exists,
                                      z.Social_Payment_Rate,
                                      z.Note,
                                      z.State,
                                      z.Code);
  
    v_Data.Put('oper_group_name',
               z_Hpr_Oper_Groups.Take(i_Company_Id => Ui.Company_Id, i_Oper_Group_Id => r_Oper_Type_Extra.Oper_Group_Id).Name);
    v_Data.Put('oper_group_id', r_Oper_Type_Extra.Oper_Group_Id);
    v_Data.Put('estimation_type', r_Oper_Type_Extra.Estimation_Type);
    v_Data.Put('estimation_formula', r_Oper_Type_Extra.Estimation_Formula);
  
    if r_Oper_Type.Corr_Coa_Id is not null then
      v_Data.Put('corr_coa_name',
                 z_Mk_Coa.Load(i_Company_Id => Ui.Company_Id, --
                 i_Coa_Id => r_Oper_Type.Corr_Coa_Id).Gen_Name);
    end if;
  
    v_Coa_Info := Mkr_Util.Coa_Info(i_Company_Id => Ui.Company_Id,
                                    i_Coa_Id     => r_Oper_Type.Corr_Coa_Id,
                                    i_Ref_Set    => r_Oper_Type.Corr_Ref_Set);
  
    v_Data.Put('corr_ref_types', Nvl(v_Coa_Info.o_Arraylist('ref_types'), Arraylist()));
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Accrual_Model(p Hashmap) return Hashmap is
  begin
    return Edit_Model(Mpr_Pref.c_Ok_Accrual, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Deduction_Model(p Hashmap) return Hashmap is
  begin
    return Edit_Model(Mpr_Pref.c_Ok_Deduction, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Oper_Type_Id number,
    p              Hashmap
  ) return Hashmap is
    v_Oper_Type Hpr_Pref.Oper_Type_Rt;
  
    v_Ref_Types    Array_Number := p.o_Array_Number('ref_type');
    v_Ref_Ids      Array_Varchar2 := p.o_Array_Varchar2('ref_id');
    v_Ref_Codes    Array_Number;
    v_Corr_Ref_Set varchar2(300);
  begin
    v_Ref_Codes := Array_Number();
    v_Ref_Codes.Extend(v_Ref_Types.Count);
  
    for i in 1 .. v_Ref_Types.Count
    loop
      Fazo.Push(v_Ref_Codes,
                Mkr_Util.Get_Ref_Code(i_Company_Id => Ui.Company_Id,
                                      i_Ref_Type   => v_Ref_Types(i),
                                      i_Ref_Id     => v_Ref_Ids(i)));
    end loop;
  
    if v_Ref_Codes.Count <> 0 then
      v_Corr_Ref_Set := Mk_Util.To_Ref_Set(v_Ref_Codes);
    else
      v_Corr_Ref_Set := null;
    end if;
  
    Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                           i_Company_Id             => Ui.Company_Id,
                           i_Oper_Type_Id           => i_Oper_Type_Id,
                           i_Oper_Group_Id          => p.o_Number('oper_group_id'),
                           i_Estimation_Type        => p.r_Varchar2('estimation_type'),
                           i_Estimation_Formula     => p.o_Varchar2('estimation_formula'),
                           i_Operation_Kind         => p.r_Varchar2('operation_kind'),
                           i_Name                   => p.r_Varchar2('name'),
                           i_Short_Name             => p.o_Varchar2('short_name'),
                           i_Accounting_Type        => p.r_Varchar2('accounting_type'),
                           i_Corr_Coa_Id            => p.o_Number('corr_coa_id'),
                           i_Corr_Ref_Set           => v_Corr_Ref_Set,
                           i_Income_Tax_Exists      => p.o_Varchar2('income_tax_exists'),
                           i_Income_Tax_Rate        => p.o_Varchar2('income_tax_rate'),
                           i_Pension_Payment_Exists => p.o_Varchar2('pension_payment_exists'),
                           i_Pension_Payment_Rate   => p.o_Varchar2('pension_payment_rate'),
                           i_Social_Payment_Exists  => p.o_Varchar2('social_payment_exists'),
                           i_Social_Payment_Rate    => p.o_Varchar2('social_payment_rate'),
                           i_Note                   => p.o_Varchar2('note'),
                           i_State                  => p.r_Varchar2('state'),
                           i_Code                   => p.o_Varchar2('code'));
  
    Hpr_Api.Oper_Type_Save(v_Oper_Type);
  
    return Fazo.Zip_Map('oper_type_id',
                        v_Oper_Type.Oper_Type.Oper_Type_Id,
                        'name',
                        v_Oper_Type.Oper_Type.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Formula_Validate(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('errors',
               Hpr_Util.Formula_Validate(i_Company_Id => Ui.Company_Id,
                                         i_Formula    => p.r_Varchar2('formula')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Mpr_Next.Oper_Type_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Oper_Type Mpr_Oper_Types%rowtype;
  begin
    r_Oper_Type := z_Mpr_Oper_Types.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                              i_Oper_Type_Id => p.r_Number('oper_type_id'));
  
    return save(r_Oper_Type.Oper_Type_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpr_Oper_Groups
       set Oper_Group_Id  = null,
           Operation_Kind = null,
           name           = null;
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           Gen_Name   = null,
           State      = null;
  
  end;

end Ui_Vhr61;
/
