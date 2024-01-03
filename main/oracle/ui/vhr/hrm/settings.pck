create or replace package Ui_Vhr69 is
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure save(p Hashmap);
end Ui_Vhr69;
/
create or replace package body Ui_Vhr69 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    return z_Hrm_Settings.To_Map(r_Setting,
                                 z.Position_Enable,
                                 z.Position_Check,
                                 z.Keep_Salary,
                                 z.Keep_Rank,
                                 z.Keep_Schedule,
                                 z.Keep_Vacation_Limit,
                                 z.Position_Booking,
                                 z.Position_History,
                                 z.Position_Fixing,
                                 z.Parttime_Enable,
                                 z.Rank_Enable,
                                 z.Wage_Scale_Enable,
                                 z.Notification_Enable);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Settings     Hrm_Settings%rowtype;
    r_Old_Settings Hrm_Settings%rowtype;
  begin
    r_Old_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id);
  
    r_Settings := z_Hrm_Settings.To_Row(p,
                                        z.Position_Enable,
                                        z.Position_Check,
                                        z.Keep_Salary,
                                        z.Keep_Rank,
                                        z.Keep_Schedule,
                                        z.Keep_Vacation_Limit,
                                        z.Position_Booking,
                                        z.Position_History,
                                        z.Position_Fixing,
                                        z.Parttime_Enable,
                                        z.Rank_Enable,
                                        z.Wage_Scale_Enable,
                                        z.Notification_Enable);
  
    r_Settings.Company_Id             := Ui.Company_Id;
    r_Settings.Filial_Id              := Ui.Filial_Id;
    r_Settings.Autogen_Staff_Number   := r_Old_Settings.Autogen_Staff_Number;
    r_Settings.Advanced_Org_Structure := r_Old_Settings.Advanced_Org_Structure;
  
    Hrm_Api.Setting_Save(r_Settings);
  end;

end Ui_Vhr69;
/
