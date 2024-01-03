prompt moving rfid_codes
----------------------------------------------------------------------------------------------------
update htt_persons q
   set q.rfid_code = q.rfid_code_old
 where q.rfid_code_old is not null;
commit;

----------------------------------------------------------------------------------------------------
prompt updating hikvision, dahua devices
----------------------------------------------------------------------------------------------------
declare
begin
  update Htt_Devices q
     set q.Has_Rfid              = 'N',
         q.Has_Photo_Recognition = 'Y'
   where q.Device_Type_Id in
         (select p.Device_Type_Id
            from Htt_Device_Types p
           where p.Pcode in
                 (Htt_Pref.c_Pcode_Device_Type_Hikvision, Htt_Pref.c_Pcode_Device_Type_Dahua));
  commit;
end;
/
