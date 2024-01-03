prompt migr 07.10.2021
---------------------------------------------------------------------------------------------------- 
alter table htt_devices add host     varchar2(15);
alter table htt_devices add login    varchar2(50 char);
alter table htt_devices add password varchar2(40);
---------------------------------------------------------------------------------------------------- 
exec fazo_z.Run('htt_devices');
---------------------------------------------------------------------------------------------------- 
declare
begin
  z_Htt_Device_Types.Save_One(i_Device_Type_Id => Htt_Device_Types_Sq.Nextval, -- because of new sequence added to htt_next
                              i_Name           => 'Verifix Hikvision',
                              i_State          => 'A',
                              i_Pcode          => Htt_Pref.c_Pcode_Device_Type_Hikvision);
  commit;
end;
/
