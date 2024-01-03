prompt migr 22.02.2022
alter table htt_devices add emotion_types varchar2(100);
exec fazo_z.run('htt_devices');
