prompt migr from 07.03.2022
prompt DDL
alter table htt_devices modify use_settings not null;

exec fazo_z.Run;
exec fazo_z.Compile_Invalid_Objects;
