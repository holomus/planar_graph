prompt dropping old column
----------------------------------------------------------------------------------------------------
alter table htt_persons drop column rfid_code_old;

create unique index htt_persons_u3 on htt_persons(nvl2(rfid_code, company_id, null), rfid_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('hac_server_persons');
exec fazo_z.run('hac_hik_ex_persons');
exec fazo_z.run('hac_dss_ex_persons');
exec fazo_z.run('htt_devices');
exec fazo_z.run('htt_persons');
