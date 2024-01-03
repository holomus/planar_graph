prompt adding hrm_setting column
----------------------------------------------------------------------------------------------------
alter table hrm_settings add position_fixing varchar2(1);
alter table hrm_settings add constraint hrm_settings_c10 check (position_fixing in ('Y', 'N'));
