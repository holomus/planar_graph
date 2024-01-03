create or replace package Ui_Vhr682 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr682;
/
create or replace package body Ui_Vhr682 is
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
    return b.Translate('UI-VHR682:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Credits
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Credit_Id  number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpr_Credits%rowtype;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    v_Diff_Columns Array_Varchar2;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select q.*
                from x_Hpr_Credits q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Credit_Id = i_Credit_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Hpr_Credits t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.t_Filial_Id = r.t_Filial_Id
                     and t.Credit_Id = r.Credit_Id
                     and t.t_Context_Id <> i_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      else
        r_Last := null;
      end if;
    
      v_Diff_Columns := z_x_Hpr_Credits.Difference(r, r_Last);
    
      Get_Difference(z.Credit_Number, t('credit number'), r_Last.Credit_Number, r.Credit_Number);
      Get_Difference(z.Credit_Date, t('credit date'), r_Last.Credit_Date, r.Credit_Date);
      Get_Difference(z.Booked_Date, t('booked date'), r_Last.Booked_Date, r.Booked_Date);
      Get_Difference(z.Employee_Id,
                     t('employee'),
                     z_Mr_Natural_Persons.Take(i_Company_Id => r_Last.t_Company_Id, i_Person_Id => r_Last.Employee_Id).Name,
                     z_Mr_Natural_Persons.Take(i_Company_Id => r.t_Company_Id, i_Person_Id => r.Employee_Id).Name);
      Get_Difference(z.Begin_Month, t('begin month'), r_Last.Begin_Month, r.Begin_Month);
      Get_Difference(z.End_Month, t('end month'), r_Last.End_Month, r.End_Month);
      Get_Difference(z.Credit_Amount, t('credit amount'), r_Last.Credit_Amount, r.Credit_Amount);
      Get_Difference(z.Currency_Id,
                     t('currency'),
                     z_Mk_Currencies.Take(i_Company_Id => r_Last.t_Company_Id, i_Currency_Id => r_Last.Currency_Id).Name,
                     z_Mk_Currencies.Take(i_Company_Id => r.t_Company_Id, i_Currency_Id => r.Currency_Id).Name);
      Get_Difference(z.Payment_Type,
                     t('payment type'),
                     Mpr_Util.t_Payment_Type(r_Last.Payment_Type),
                     Mpr_Util.t_Payment_Type(r.Payment_Type));
      Get_Difference(z.Cashbox_Id,
                     t('cashbox'),
                     z_Mkcs_Cashboxes.Take(i_Company_Id => r_Last.t_Company_Id, i_Cashbox_Id => r_Last.Cashbox_Id).Name,
                     z_Mkcs_Cashboxes.Take(i_Company_Id => r.t_Company_Id, i_Cashbox_Id => r.Cashbox_Id).Name);
      Get_Difference(z.Bank_Account_Id,
                     t('bank account'),
                     z_Mkcs_Bank_Accounts.Take(i_Company_Id => r_Last.t_Company_Id, i_Bank_Account_Id => r_Last.Bank_Account_Id).Name,
                     z_Mkcs_Bank_Accounts.Take(i_Company_Id => r.t_Company_Id, i_Bank_Account_Id => r.Bank_Account_Id).Name);
      Get_Difference(z.Status,
                     t('status'),
                     Hpr_Util.t_Credit_Status(r_Last.Status),
                     Hpr_Util.t_Credit_Status(r.Status));
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Credit_Id  number := p.r_Number('credit_id');
    v_Context_Id number := p.r_Number('context_id');
    result       Hashmap := Hashmap();
  begin
    Result.Put('credit_number',
               z_Hpr_Credits.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Credit_Id => v_Credit_Id).Credit_Number);
    Result.Put('credit',
               Fazo.Zip_Matrix(Credits(i_Company_Id => v_Company_Id,
                                       i_Filial_Id  => v_Filial_Id,
                                       i_Credit_Id  => v_Credit_Id,
                                       i_Context_Id => v_Context_Id)));
  
    return result;
  end;

end Ui_Vhr682;
/
