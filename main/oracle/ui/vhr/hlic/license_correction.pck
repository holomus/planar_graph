create or replace package Ui_Vhr351 is
  ----------------------------------------------------------------------------------------------------
  Function Load_License_Monthly_Barchart return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
end Ui_Vhr351;
/
create or replace package body Ui_Vhr351 is
  ----------------------------------------------------------------------------------------------------
  Function Load_License_Monthly_Barchart return Hashmap is
    v_Company_Id       number := Ui.Company_Id;
    v_Curr_Date        date := Trunc(Current_Date);
    v_Three_Months_End date := Last_Day(Add_Months(v_Curr_Date, 2));
  
    v_Amounts Matrix_Varchar2;
  
    result Hashmap := Hashmap();
  begin
    select Array_Varchar2(Trunc(Bl.Balance_Date, 'mon'),
                          min(Bl.Available_Amount) --
                          Keep(Dense_Rank last order by Bl.Used_Amount + Bl.Required_Amount),
                          max(Bl.Used_Amount + Bl.Required_Amount))
      bulk collect
      into v_Amounts
      from Kl_License_Balances Bl
     where Bl.Company_Id = v_Company_Id
       and Bl.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
       and Bl.Balance_Date between v_Curr_Date and v_Three_Months_End
     group by Trunc(Bl.Balance_Date, 'mon');
  
    Result.Put('data', Fazo.Zip_Matrix(v_Amounts));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Filial_Head number := Md_Pref.Filial_Head(Ui.Company_Id);
  
    result Hashmap := Hashmap();
  begin
    if z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                               i_User_Id    => Ui.User_Id,
                               i_Filial_Id  => v_Filial_Head) then
      Result.Put('filial_head', v_Filial_Head);
    end if;
  
    return result;
  end;

end Ui_Vhr351;
/
