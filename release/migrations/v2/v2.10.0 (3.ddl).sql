prompt migr from 28.10.2022 (3.ddl)

alter table htt_request_kinds add constraint htt_request_kinds_c4 check (annually_limited = 'Y' or annual_day_limit is null);
alter table htt_request_kinds add constraint htt_request_kinds_c5 check (annual_day_limit between 0 and 366);
alter table htt_request_kinds add constraint htt_request_kinds_c6 check (user_permitted in ('Y', 'N'));
alter table htt_request_kinds add constraint htt_request_kinds_c7 check (allow_unused_time in ('Y', 'N'));
alter table htt_request_kinds add constraint htt_request_kinds_c8 check (carryover_policy in ('A', 'Z', 'C') and annually_limited = 'Y' or carryover_policy is null and annually_limited = 'N');
alter table htt_request_kinds add constraint htt_request_kinds_c9 check (carryover_cap_days > 0 and carryover_policy = 'C' or carryover_cap_days is null and carryover_policy != 'C');
alter table htt_request_kinds add constraint htt_request_kinds_c10 check (carryover_expires_days > 0 and carryover_policy != 'Z' or carryover_expires_days is null and carryover_policy = 'Z');
alter table htt_request_kinds add constraint htt_request_kinds_c11 check (state in ('A', 'P'));

----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_request_kinds');
