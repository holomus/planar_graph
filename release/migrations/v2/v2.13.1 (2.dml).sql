prompt migr from 16.12.2022 (1.dml)
declare
  v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
begin
  insert into Htt_Hikvision_Devices
    (Company_Id,
     Device_Id,
     Dynamic_Ip,
     Host,
     Login,
     Password)
    select q.Company_Id,
           q.Device_Id,
           'N',
           q.Host,
           q.Login,
           q.Password
      from Htt_Devices q
     where q.Device_Type_Id = v_Device_Type_Id;
end;
/
commit;
