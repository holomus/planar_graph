prompt adding schedule changes
----------------------------------------------------------------------------------------------------
alter table htt_schedules modify schedule_kind not null;
alter table htt_schedules add constraint htt_schedules_c13 check (schedule_kind in ('C', 'F', 'H'));
alter table htt_schedules add constraint htt_schedules_c14 check (decode(schedule_kind, 'F', 0, 3) = nvl2(shift, 1, 0) + nvl2(input_acceptance, 1, 0) + nvl2(output_acceptance, 1, 0));
alter table htt_schedules add constraint htt_schedules_c15 check (decode(schedule_kind, 'H', 0, 3) >= decode(count_late, 'Y', 1, 0) + decode(count_early, 'Y', 1, 0) + decode(count_lack, 'Y', 1, 0));

----------------------------------------------------------------------------------------------------
alter table htt_timesheets modify schedule_kind not null;

alter table htt_timesheets add constraint htt_timesheets_c24 check (schedule_kind in ('C', 'F', 'H'));

----------------------------------------------------------------------------------------------------
alter table htt_tracks modify trans_input  not null;
alter table htt_tracks modify trans_output not null;

alter table htt_tracks add constraint htt_tracks_c7 check (trans_input in ('Y', 'N'));
alter table htt_tracks add constraint htt_tracks_c8 check (trans_output in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
alter table htt_timesheet_tracks modify trans_input  not null;
alter table htt_timesheet_tracks modify trans_output not null;
alter table htt_timesheet_tracks add constraint htt_timesheet_tracks_c2 check (track_type in ('I', 'O', 'C', 'M', 'P'));
alter table htt_timesheet_tracks add constraint htt_timesheet_tracks_c3 check (trans_input in ('Y', 'N'));
alter table htt_timesheet_tracks add constraint htt_timesheet_tracks_c4 check (trans_output in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt add missing foreign keys
----------------------------------------------------------------------------------------------------
alter table hper_staff_plans add constraint hper_staff_plans_f6 foreign key (company_id, created_by) references md_users(company_id, user_id);

alter table hper_staff_plan_parts add constraint hper_staff_plan_parts_f2 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table hper_staff_plan_parts add constraint hper_staff_plan_parts_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id);

alter table hlic_required_dates rename constraint hlic_required_dates_f2 to hlic_required_dates_f3;
alter table hlic_required_dates rename constraint hlic_required_dates_f1 to hlic_required_dates_f2;
alter table hlic_required_dates add constraint hlic_required_dates_f1 foreign key (company_id, interval_id) references hlic_required_intervals(company_id, interval_id);

alter table htt_request_helpers rename constraint htt_request_helpers_f1 to htt_request_helpers_f2;
alter table htt_request_helpers add constraint htt_request_helpers_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id);

alter table htt_timesheet_helpers rename constraint htt_timesheet_helpers_f1 to htt_timesheet_helpers_f2;
alter table htt_timesheet_helpers add constraint htt_timesheet_helpers_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id);

comment on table htt_timesheet_helpers is 'Keeps extra information about timesheet day';

alter table hpr_timebook_staffs add constraint hpr_timebook_staffs_f3 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id);
alter table hpr_timebook_staffs add constraint hpr_timebook_staffs_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id);
alter table hpr_timebook_staffs add constraint hpr_timebook_staffs_f5 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id);

drop table hpr_oper_type_templates;

create sequence htt_acms_tracks_sq;
