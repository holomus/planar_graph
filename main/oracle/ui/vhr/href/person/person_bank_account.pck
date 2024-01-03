create or replace package Ui_Vhr102 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Currencies return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Banks(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Save_Bank_Account(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Bank_Account(p Hashmap);
end Ui_Vhr102;
/
create or replace package body Ui_Vhr102 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Banks(p Hashmap) return Fazo_Query is
    v_Bank_Code varchar2(50) := p.o_Varchar2('bank_code');
    v_Query     varchar2(4000);
    v_Params    Hashmap;
    q           Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
  
    v_Query := 'select *
                  from mkcs_banks q
                 where q.company_id = :company_id 
                   and q.state = ''A''';
  
    if v_Bank_Code is not null then
      v_Query := v_Query || ' and t.bank_code = :bank_code';
      v_Params.Put('bank_code', p.o_Varchar2('bank_code'));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('bank_id');
    q.Varchar2_Field('bank_code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Currencies return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_currencies', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('currency_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id        number := p.r_Number('person_id');
    v_Base_Currency_Id number;
    v_Matrix           Matrix_Varchar2;
    result             Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    result := Fazo.Zip_Map('person_id', v_Person_Id);
  
    if not Ui.Is_Filial_Head then
      v_Base_Currency_Id := Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id);
      Result.Put('base_currency_id', v_Base_Currency_Id);
      Result.Put('base_currency_name',
                 z_Mk_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Currency_Id => v_Base_Currency_Id).Name);
    end if;
  
    select Array_Varchar2(t.Bank_Id,
                          w.Name,
                          w.Bank_Code,
                          t.Bank_Account_Id,
                          t.Bank_Account_Code,
                          t.Name,
                          t.Is_Main,
                          t.Currency_Id,
                          (select w.Name
                             from Mk_Currencies w
                            where w.Company_Id = t.Company_Id
                              and w.Currency_Id = t.Currency_Id),
                          (select w.Card_Number
                             from Href_Bank_Accounts w
                            where w.Company_Id = t.Company_Id
                              and w.Bank_Account_Id = t.Bank_Account_Id),
                          t.State,
                          t.Note)
      bulk collect
      into v_Matrix
      from Mkcs_Bank_Accounts t
      join Mkcs_Banks w
        on w.Company_Id = t.Company_Id
       and w.Bank_Id = t.Bank_Id
     where t.Company_Id = Ui.Company_Id
       and t.Person_Id = v_Person_Id;
  
    Result.Put('bank_accounts', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Bank_Account(p Hashmap) return Hashmap is
    r_Bank_Account Mkcs_Bank_Accounts%rowtype;
    v_Bank_Account Href_Pref.Bank_Account_Rt;
    v_Person_Id    number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Mkcs_Bank_Accounts.Exist_Lock(i_Company_Id      => Ui.Company_Id,
                                           i_Bank_Account_Id => p.o_Number('bank_account_id'),
                                           o_Row             => r_Bank_Account) then
      r_Bank_Account.Company_Id      := Ui.Company_Id;
      r_Bank_Account.Bank_Account_Id := Mkcs_Next.Bank_Account_Id;
    end if;
  
    Href_Util.Bank_Account_New(o_Bank_Account      => v_Bank_Account,
                               i_Company_Id        => r_Bank_Account.Company_Id,
                               i_Bank_Account_Id   => r_Bank_Account.Bank_Account_Id,
                               i_Bank_Id           => p.r_Number('bank_id'),
                               i_Bank_Account_Code => p.r_Varchar2('bank_account_code'),
                               i_Name              => p.r_Varchar2('bank_account_name'),
                               i_Person_Id         => v_Person_Id,
                               i_Is_Main           => p.r_Varchar2('is_main'),
                               i_Currency_Id       => p.r_Number('currency_id'),
                               i_Note              => p.o_Varchar2('note'),
                               i_Card_Number       => p.o_Varchar2('card_number'),
                               i_State             => p.r_Varchar2('state'));
  
    Href_Api.Bank_Account_Save(v_Bank_Account);
  
    return Fazo.Zip_Map('bank_account_id', v_Bank_Account.Bank_Account_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Bank_Account(p Hashmap) is
    v_Bank_Account_Id number := p.r_Number('bank_account_id');
    v_Person_Id       number;
  begin
    v_Person_Id := z_Mkcs_Bank_Accounts.Lock_Load(i_Company_Id => Ui.Company_Id, i_Bank_Account_Id => v_Bank_Account_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Bank_Account_Delete(i_Company_Id      => Ui.Company_Id,
                                 i_Bank_Account_Id => v_Bank_Account_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Mkcs_Banks
       set Company_Id = null,
           Bank_Id    = null,
           Bank_Code  = null,
           name       = null,
           State      = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null,
           State       = null,
           Code        = null;
  end;

end Ui_Vhr102;
/
