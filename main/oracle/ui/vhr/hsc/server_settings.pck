create or replace package Ui_Vhr575 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
end Ui_Vhr575;
/
create or replace package body Ui_Vhr575 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Settings Hsc_Server_Settings%rowtype;
  begin
    r_Settings := z_Hsc_Server_Settings.Take(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
  
    r_Settings.Predict_Server_Url := Nvl(r_Settings.Predict_Server_Url,
                                         Hsc_Pref.c_Predict_Server_Url);
  
    return z_Hsc_Server_Settings.To_Map(r_Settings,
                                        z.Ftp_Server_Url,
                                        z.Ftp_Username,
                                        z.Ftp_Password,
                                        z.Predict_Server_Url,
                                        z.Last_Ftp_File_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Settings Hsc_Server_Settings%rowtype;
  begin
    r_Settings := z_Hsc_Server_Settings.To_Row(p,
                                               z.Ftp_Server_Url,
                                               z.Ftp_Username,
                                               z.Ftp_Password,
                                               z.Predict_Server_Url,
                                               z.Last_Ftp_File_Date);
  
    r_Settings.Company_Id := Ui.Company_Id;
    r_Settings.Filial_Id  := Ui.Filial_Id;
  
    Hsc_Api.Server_Settings_Save(r_Settings);
  end;

end Ui_Vhr575;
/
