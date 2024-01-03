prompt document changes
----------------------------------------------------------------------------------------------------
alter table href_person_details add corporate_email varchar2(300);

----------------------------------------------------------------------------------------------------
alter table href_document_types rename constraint href_document_types_c4 to href_document_types_c5;
alter table href_document_types rename constraint href_document_types_c3 to href_document_types_c4;
alter table href_document_types rename constraint href_document_types_c2 to href_document_types_c3;

alter table href_document_types add is_required varchar2(1);
alter table href_document_types add constraint href_document_types_c2 check (is_required in ('Y', 'N'));

comment on column href_document_types.is_required is '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table href_excluded_document_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  division_id                     number(20) not null,
  job_id                          number(20) not null,
  doc_type_id                     number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint href_excluded_document_types_pk primary key (company_id, filial_id, division_id, job_id, doc_type_id) using index tablespace GWS_INDEX,
  constraint href_excluded_document_types_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint href_excluded_document_types_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint href_excluded_document_types_f3 foreign key (company_id, doc_type_id) references href_document_types(company_id, doc_type_id) on delete cascade,
  constraint href_excluded_document_types_f4 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index href_excluded_document_types_i1 on href_excluded_document_types(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index href_excluded_document_types_i2 on href_excluded_document_types(company_id, doc_type_id) tablespace GWS_INDEX;
create index href_excluded_document_types_i3 on href_excluded_document_types(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table href_person_documents add is_valid varchar2(1);
alter table href_person_documents add status varchar2(1);
alter table href_person_documents add rejected_note varchar2(300 char);

alter table href_person_documents add constraint href_person_documents_c1 check (is_valid in ('Y', 'N'));
alter table href_person_documents add constraint href_person_documents_c2 check (status in ('N', 'A', 'R'));

comment on column href_person_documents.is_valid is '(Y)es, (N)o';
comment on column href_person_documents.status is '(N)ew, (A)pproved, (R)ejected';

---------------------------------------------------------------------------------------------------- 
prompt adding hrm_divisions
----------------------------------------------------------------------------------------------------
create table hrm_divisions(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  division_id                     number(20)  not null,
  parent_department_id            number(20),
  is_department                   varchar2(1) not null,
  constraint hrm_divisions_pk primary key (company_id, filial_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_divisions_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_divisions_f2 foreign key (company_id, filial_id, parent_department_id) references hrm_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_divisions_c1 check (is_department in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table hrm_divisions is 'Additional VERIFIX specific info about divisions';

comment on column hrm_divisions.is_department is '(Y)es, (N)o. Default value:(Y)es. When row in hrm_divisions does not exist, division is considered as department';

----------------------------------------------------------------------------------------------------
alter table hrm_robots add org_unit_id number(20);

alter table hrm_robots rename constraint hrm_robots_f7 to hrm_robots_f8;
alter table hrm_robots rename constraint hrm_robots_f6 to hrm_robots_f7;

alter table hrm_robots add constraint hrm_robots_f6 foreign key (company_id, filial_id, org_unit_id) references mhr_divisions(company_id, filial_id, division_id);

alter index hrm_robots_i6 rename to hrm_robots_i7;
alter index hrm_robots_i5 rename to hrm_robots_i6;

create index hrm_robots_i5 on hrm_robots(company_id, filial_id, org_unit_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hrm_settings add advanced_org_structure varchar2(1);

alter table hrm_settings add constraint hrm_settings_c11 check (advanced_org_structure in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
alter table href_staffs add org_unit_id number(20);

alter index href_staffs_i10 rename to href_staffs_i12;
alter index href_staffs_i9 rename to href_staffs_i11;

create index href_staffs_i9 on href_staffs(company_id, filial_id, org_unit_id) tablespace GWS_INDEX;
create index href_staffs_i10 on href_staffs(company_id, employee_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding check to htt_change_days
---------------------------------------------------------------------------------------------------- 
alter table htt_change_days add constraint htt_change_days_c12 check (change_date != swapped_date); 
