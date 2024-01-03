prompt migr from 16.12.2022 (3.ddl)
alter table htt_devices drop column host;
alter table htt_devices drop column login;
alter table htt_devices drop column password;

exec fazo_z.run('htt_devices');
