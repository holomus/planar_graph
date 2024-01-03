prompt adding schedule flex to individual schedules
----------------------------------------------------------------------------------------------------
alter table htt_schedule_registries add schedule_kind varchar2(1);

alter table htt_schedule_registries modify shift null;
alter table htt_schedule_registries modify input_acceptance null;
alter table htt_schedule_registries modify output_acceptance null;

alter table htt_schedule_registries add constraint htt_schedule_registries_c15 check (schedule_kind in ('C', 'F', 'H'));
alter table htt_schedule_registries add constraint htt_schedule_registries_c16 check (decode(schedule_kind, 'F', 0, 3) = nvl2(shift, 1, 0) + nvl2(input_acceptance, 1, 0) + nvl2(output_acceptance, 1, 0));
alter table htt_schedule_registries add constraint htt_schedule_registries_c17 check (decode(schedule_kind, 'H', 0, 3) >= decode(count_late, 'Y', 1, 0) + decode(count_early, 'Y', 1, 0) + decode(count_lack, 'Y', 1, 0));

comment on column htt_schedule_registries.schedule_kind     is '(C)ustom, (F)lexible, (H)ourly. When (F)lexible cannot set shift, input/output acceptance. When (H)ourly will calculate only turnout from input to output';

alter table htt_unit_schedule_days modify shift_begin_time null;
alter table htt_unit_schedule_days modify shift_end_time   null;
alter table htt_unit_schedule_days modify input_border     null;
alter table htt_unit_schedule_days modify output_border    null;

alter table htt_staff_schedule_days modify shift_begin_time null;
alter table htt_staff_schedule_days modify shift_end_time   null;
alter table htt_staff_schedule_days modify input_border     null;
alter table htt_staff_schedule_days modify output_border    null;

alter table htt_robot_schedule_days modify shift_begin_time null;
alter table htt_robot_schedule_days modify shift_end_time   null;
alter table htt_robot_schedule_days modify input_border     null;
alter table htt_robot_schedule_days modify output_border    null;
