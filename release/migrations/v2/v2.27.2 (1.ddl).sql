prompt adding extra info column
----------------------------------------------------------------------------------------------------
alter table hac_hik_ex_events add extra_info varchar2(4000);

alter table hac_hik_ex_events drop column temperature_data;
alter table hac_hik_ex_events drop column temperature_status;
alter table hac_hik_ex_events drop column wear_mask_status;

exec fazo_z.run('hac_hik_ex_events');
