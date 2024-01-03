create or replace package Ui_Vhr149 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr149;
/
create or replace package body Ui_Vhr149 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2(w.Name,
                          w.Bank_Code,
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

end Ui_Vhr149;
/
