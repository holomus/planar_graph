create or replace package Ui_Vhr226 is
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr226;
/
create or replace package body Ui_Vhr226 is
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Htt_Terminal_Models%rowtype;
  begin
    if Ui.Company_Id <> Md_Pref.Company_Head then
      b.Raise_Unauthorized;
    end if;
  
    r_Data := z_Htt_Terminal_Models.Load(p.r_Number('model_id'));
  
    return z_Htt_Terminal_Models.To_Map(r_Data,
                                        z.Model_Id,
                                        z.Name,
                                        z.Photo_Sha,
                                        z.Support_Face_Recognation,
                                        z.Support_Fprint,
                                        z.Support_Rfid_Card,
                                        z.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Data Htt_Terminal_Models%rowtype;
  begin
    if Ui.Company_Id <> Md_Pref.Company_Head then
      b.Raise_Unauthorized;
    end if;
  
    r_Data := z_Htt_Terminal_Models.Load(p.r_Number('model_id'));
  
    z_Htt_Terminal_Models.To_Row(r_Data,
                                 p,
                                 z.Name,
                                 z.Photo_Sha,
                                 z.Support_Face_Recognation,
                                 z.Support_Fprint,
                                 z.Support_Rfid_Card,
                                 z.State);
  
    Htt_Api.Terminal_Model_Save(r_Data);
  end;

end Ui_Vhr226;
/
