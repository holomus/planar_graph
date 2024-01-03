prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt staff structure fix
----------------------------------------------------------------------------------------------------
alter table href_staffs modify hiring_date not null;
alter table href_staffs modify division_id not null;
alter table href_staffs modify job_id not null;
alter table href_staffs modify fte not null;
alter table href_staffs modify schedule_id not null;
alter table href_staffs modify robot_id not null;

alter table href_staffs drop constraint href_staffs_f2;
alter table href_staffs drop constraint href_staffs_f3;

alter table href_staffs add constraint href_staffs_f2 foreign key(company_id, filial_id, parent_id) references href_staffs(company_id,
                                                                                                                           filial_id,
                                                                                                                           staff_id);
alter table href_staffs add constraint href_staffs_f3 foreign key(company_id, created_by) references md_users(company_id,
                                                                                                              user_id);
alter table href_staffs add constraint href_staffs_f4 foreign key(company_id, modified_by) references md_users(company_id,
                                                                                                               user_id);

alter table href_staffs drop constraint href_staffs_c2;
alter table href_staffs drop constraint href_staffs_c3;

alter table href_staffs add constraint href_staffs_c2 check(staff_kind in ('P', 'S'));
alter table href_staffs add constraint href_staffs_c3 check(trunc(hiring_date) = hiring_date);
alter table href_staffs add constraint href_staffs_c4 check(trunc(dismissal_date) = dismissal_date);
alter table href_staffs add constraint href_staffs_c5 check(hiring_date <= dismissal_date);
alter table href_staffs add constraint href_staffs_c6 check(fte > 0 and fte <= 1);
alter table href_staffs add constraint href_staffs_c7 check(state in ('A', 'P'));
alter table href_staffs add constraint href_staffs_c8 check(state = 'P' or
                                                            state = 'A' and
                                                            decode(staff_kind, 'S', 1, 0) =
                                                            nvl2(parent_id, 1, 0)) deferrable initially deferred;

drop index href_staffs_i1;
drop index href_staffs_i2;
drop index href_staffs_i3;
drop index href_staffs_i4;
drop index href_staffs_i5;
drop index href_staffs_i6;
drop index href_staffs_i7;

create index href_staffs_i1 on href_staffs(company_id, filial_id, employee_id) tablespace gws_index;
create index href_staffs_i2 on href_staffs(company_id, filial_id, robot_id) tablespace gws_index;
create index href_staffs_i3 on href_staffs(company_id, filial_id, division_id) tablespace gws_index;
create index href_staffs_i4 on href_staffs(company_id, filial_id, job_id) tablespace gws_index;
create index href_staffs_i5 on href_staffs(company_id, filial_id, rank_id) tablespace gws_index;
create index href_staffs_i6 on href_staffs(company_id, filial_id, schedule_id) tablespace gws_index;
create index href_staffs_i7 on href_staffs(company_id, filial_id, parent_id) tablespace gws_index;
create index href_staffs_i8 on href_staffs(company_id, created_by) tablespace gws_index;
create index href_staffs_i9 on href_staffs(company_id, modified_by) tablespace gws_index;

alter table href_staffs drop column position_id;
alter table href_staffs drop column status;
