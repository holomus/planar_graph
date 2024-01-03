create or replace package Hlic_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_License_Create(i_License Kl_Global.License_Rt);
end Hlic_Watcher;
/
create or replace package body Hlic_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_License_Create(i_License Kl_Global.License_Rt) is
  begin
    if i_License.License_Code = Hlic_Pref.c_License_Code_Hrm_Base then
      Hlic_Core.Update_Subscription_Date(i_License.Company_Id);
    end if;
  end;

end Hlic_Watcher;
/
