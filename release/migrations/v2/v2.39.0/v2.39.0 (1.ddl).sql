prompt adding ignore tracks and images settings
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hac_hik_devices add ignore_tracks varchar2(1);

----------------------------------------------------------------------------------------------------
alter table htt_devices add ignore_images varchar2(1);

----------------------------------------------------------------------------------------------------
prompt adding allow_rank to robots
----------------------------------------------------------------------------------------------------
alter table hpd_page_robots add allow_rank varchar2(1);

alter table hpd_page_robots add constraint hpd_page_robots_c5 check (allow_rank in ('Y', 'N'));
alter table hpd_page_robots add constraint hpd_page_robots_c6 check (allow_rank = 'Y' or allow_rank = 'N' and rank_id is null);

comment on column hpd_page_robots.allow_rank is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
prompt hper plan rules fixes
alter table hper_plan_type_rules modify from_percent number(6,3);
alter table hper_plan_type_rules modify to_percent number(6,3);

alter table hper_plan_rules modify from_percent number(6,3);
alter table hper_plan_rules modify to_percent number(6,3);

alter table hper_staff_plan_rules modify from_percent number(6,3);
alter table hper_staff_plan_rules modify to_percent number(6,3);

alter table hper_staff_plan_type_rules modify from_percent number(6,3);
alter table hper_staff_plan_type_rules modify to_percent number(6,3);
