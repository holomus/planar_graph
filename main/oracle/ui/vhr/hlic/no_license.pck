create or replace package Ui_Vhr336 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr336;
/
create or replace package body Ui_Vhr336 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Filial_Head number := Md_Pref.Filial_Head(Ui.Company_Id);
  
    v_Curr_Date date := Trunc(Current_Date);
    v_Month_End date := Last_Day(v_Curr_Date);
  
    result Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Put_Balance_Info is
      v_Available number;
      v_Used      number;
      v_Required  number;
    begin
      begin
        select Lb.Available_Amount, Lb.Used_Amount, Lb.Required_Amount
          into v_Available, v_Used, v_Required
          from Kl_License_Balances Lb
         where Lb.Company_Id = Ui.Company_Id
           and Lb.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
           and Lb.Balance_Date between v_Curr_Date and v_Month_End
           and Lb.Required_Amount > 0
         order by Lb.Required_Amount desc
         fetch first row only;
      exception
        when No_Data_Found then
          v_Available := 0;
          v_Used      := 0;
          v_Required  := 0;
      end;
    
      Result.Put('license_employee',
                 Fazo.Zip_Map('license_code',
                              Hlic_Pref.c_License_Code_Hrm_Base,
                              'available_amount',
                              v_Available,
                              'used_amount',
                              v_Used,
                              'required_amount',
                              v_Required));
    end;
  begin
    Put_Balance_Info;
  
    Result.Put('terminated', Uit_Hlic.Is_Terminated);
  
    if z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                               i_User_Id    => Ui.User_Id,
                               i_Filial_Id  => v_Filial_Head) then
      Result.Put('filial_head', v_Filial_Head);
    end if;
  
    return result;
  end;

end Ui_Vhr336;
/
