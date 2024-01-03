create or replace package Uit_Hlic is
  ----------------------------------------------------------------------------------------------------
  Function Is_Terminated return varchar2;
end Uit_Hlic;
/
create or replace package body Uit_Hlic is
  ----------------------------------------------------------------------------------------------------
  Function Is_Terminated return varchar2 is
    r_Subscription Kl_Subscriptions%rowtype;
  
    v_Curr_Date date := Trunc(Current_Date);
  begin
    r_Subscription := z_Kl_Subscriptions.Take(i_Company_Id   => Ui.Company_Id,
                                              i_Project_Code => Verifix.Project_Code);
  
    r_Subscription.End_Date := Nvl(r_Subscription.End_Date, Href_Pref.c_Max_Date);
  
    return case when r_Subscription.End_Date < v_Curr_Date then 'Y' else 'N' end;
  end;

end Uit_Hlic;
/
