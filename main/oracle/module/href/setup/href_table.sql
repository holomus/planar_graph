prompt References module
prompt (c) 2020 Verifix HR
----------------------------------------------------------------------------------------------------
-- staff
-- todo not added foriegn keys to cash fields because htt_schedules runs after href module
----------------------------------------------------------------------------------------------------
create table href_staffs(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  staff_id                        number(20)        not null,
  staff_number                    varchar2(50 char),
  staff_kind                      varchar2(1)       not null,
  employee_id                     number(20)        not null,
  hiring_date                     date              not null,
  dismissal_date                  date,
  robot_id                        number(20)        not null,
  division_id                     number(20)        not null,
  job_id                          number(20)        not null,
  org_unit_id                     number(20)        not null,
  fte                             number(20,6)      not null,
  fte_id                          number(20),
  rank_id                         number(20),
  schedule_id                     number(20),
  dismissal_reason_id             number(20),
  dismissal_note                  varchar2(300 char),
  parent_id                       number(20),
  state                           varchar2(1)       not null,
  employment_type                 varchar2(1)       not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_staffs_pk primary key (company_id, filial_id, staff_id) using index tablespace GWS_INDEX,
  constraint href_staffs_u1 unique (staff_id) using index tablespace GWS_INDEX,
  constraint href_staffs_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint href_staffs_f2 foreign key(company_id, filial_id, parent_id) references href_staffs(company_id, filial_id, staff_id),
  constraint href_staffs_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_staffs_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_staffs_c1 check (decode(trim(staff_number), staff_number, 1, 0) = 1),
  constraint href_staffs_c2 check (staff_kind in ('P', 'S')),
  constraint href_staffs_c3 check (trunc(hiring_date) = hiring_date),
  constraint href_staffs_c4 check (trunc(dismissal_date) = dismissal_date),
  constraint href_staffs_c5 check (hiring_date <= dismissal_date),
  constraint href_staffs_c6 check (fte > 0 and fte <= 1),
  constraint href_staffs_c7 check (state in ('A', 'P')),
  constraint href_staffs_c8 check (state = 'P' or state = 'A' and decode(staff_kind, 'S', 1, 0) = nvl2(parent_id, 1, 0)) deferrable initially deferred,
  constraint href_staffs_c9 check (employment_type in ('M', 'E', 'I', 'C'))
) tablespace GWS_DATA;

comment on column href_staffs.staff_kind      is '(P)rimary, (S)econdary';
comment on column href_staffs.state           is '(A)ctive, (P)assive';
comment on column href_staffs.employment_type is '(M)ain job, (E)xternal parttime, (I)nternal parttime, (C)ontractor';
comment on column href_staffs.division_id     is 'cache fiedls';
comment on column href_staffs.job_id          is 'cache fiedls';
comment on column href_staffs.rank_id         is 'cache fiedls';
comment on column href_staffs.schedule_id     is 'cache fiedls';

create unique index href_staffs_u2 on href_staffs(nvl2(staff_number,company_id, null), nvl2(staff_number, filial_id, null), upper(staff_number)) tablespace GWS_INDEX;

create index href_staffs_i1 on href_staffs(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index href_staffs_i2 on href_staffs(company_id, filial_id, robot_id) tablespace GWS_INDEX;
create index href_staffs_i3 on href_staffs(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index href_staffs_i4 on href_staffs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index href_staffs_i5 on href_staffs(company_id, filial_id, fte_id) tablespace GWS_INDEX;
create index href_staffs_i6 on href_staffs(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index href_staffs_i7 on href_staffs(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index href_staffs_i8 on href_staffs(company_id, filial_id, parent_id) tablespace GWS_INDEX;
create index href_staffs_i9 on href_staffs(company_id, filial_id, org_unit_id) tablespace GWS_INDEX;
create index href_staffs_i10 on href_staffs(company_id, employee_id) tablespace GWS_INDEX;
create index href_staffs_i11 on href_staffs(company_id, created_by) tablespace GWS_INDEX;
create index href_staffs_i12 on href_staffs(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_employee_divisions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  employee_id                     number(20) not null,
  division_id                     number(20) not null,
  constraint href_employee_divisions_pk primary key (company_id, filial_id, employee_id, division_id) using index tablespace GWS_INDEX,
  constraint href_employee_divisions_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id) on delete cascade,
  constraint href_employee_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade
) tablespace GWS_DATA;

comment on table href_employee_divisions is 'Keeps manual access of employee for divisions, when position is not enabled';

create index href_employee_divisions_i1 on href_employee_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_fixed_term_bases(
  company_id                      number(20)         not null,
  fixed_term_base_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  text                            varchar2(300 char),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20),
  constraint href_fixed_term_bases_pk primary key (company_id, fixed_term_base_id) using index tablespace GWS_INDEX,
  constraint href_fixed_term_bases_u1 unique (fixed_term_base_id) using index tablespace GWS_INDEX,
  constraint href_fixed_term_bases_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_fixed_term_bases_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_fixed_term_bases_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_fixed_term_bases_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_fixed_term_bases_c2 check (state in ('A', 'P')),
  constraint href_fixed_term_bases_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_fixed_term_bases.state is '(A)ctive, (P)assive';

create unique index href_fixed_term_bases_u3 on href_fixed_term_bases(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_fixed_term_bases_u4 on href_fixed_term_bases(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_fixed_term_bases_i1 on href_fixed_term_bases(company_id, created_by) tablespace GWS_INDEX;
create index href_fixed_term_bases_i2 on href_fixed_term_bases(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_edu_stages( 
  company_id                      number(20)         not null,
  edu_stage_id                    number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  order_no                        number(6),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_edu_stages_pk primary key (company_id, edu_stage_id) using index tablespace GWS_INDEX,
  constraint href_edu_stages_u1 unique (edu_stage_id) using index tablespace GWS_INDEX,
  constraint href_edu_stages_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_edu_stages_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_edu_stages_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_edu_stages_c2 check (state in ('A', 'P')),
  constraint href_edu_stages_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_edu_stages.state is '(A)ctive, (P)assive';

create unique index href_edu_stages_u2 on href_edu_stages(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_edu_stages_u3 on href_edu_stages(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_edu_stages_i1 on href_edu_stages(company_id, code) tablespace GWS_INDEX;
create index href_edu_stages_i2 on href_edu_stages(company_id, created_by) tablespace GWS_INDEX;
create index href_edu_stages_i3 on href_edu_stages(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_science_branches(
  company_id                      number(20)         not null,
  science_branch_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_science_branches_pk primary key (company_id, science_branch_id) using index tablespace GWS_INDEX,
  constraint href_science_branches_u1 unique (science_branch_id) using index tablespace GWS_INDEX,
  constraint href_science_branches_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_science_branches_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_science_branches_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_science_branches_c2 check (state in ('A', 'P')),
  constraint href_science_branches_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_science_branches.state is '(A)ctive, (P)assive';

create unique index href_science_branches_u2 on href_science_branches(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_science_branches_u3 on href_science_branches(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_science_branches_i1 on href_science_branches(company_id, created_by) tablespace GWS_INDEX;
create index href_science_branches_i2 on href_science_branches(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_institutions(
  company_id                      number(20)         not null,
  institution_id                  number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_institutions_pk primary key (company_id, institution_id) using index tablespace GWS_INDEX,
  constraint href_institutions_u1 unique (institution_id) using index tablespace GWS_INDEX,
  constraint href_institutions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_institutions_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_institutions_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_institutions_c2 check (state in ('A', 'P')),
  constraint href_institutions_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_institutions.state is '(A)ctive, (P)assive';

create unique index href_institutions_u2 on href_institutions(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_institutions_u3 on href_institutions(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_institutions_i1 on href_institutions(company_id, created_by) tablespace GWS_INDEX;
create index href_institutions_i2 on href_institutions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_specialties(
  company_id                      number(20)         not null,
  specialty_id                    number(20)         not null,
  name                            varchar2(100 char) not null,
  kind                            varchar2(1)        not null,
  parent_id                       number(20),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_specialties_pk primary key (company_id, specialty_id) using index tablespace GWS_INDEX,
  constraint href_specialties_u1 unique (specialty_id) using index tablespace GWS_INDEX,
  constraint href_specialties_f1 foreign key (company_id, parent_id) references href_specialties(company_id, specialty_id) on delete cascade,
  constraint href_specialties_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_specialties_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_specialties_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_specialties_c2 check (kind in ('G', 'S')),
  constraint href_specialties_c3 check (state in ('A', 'P')),
  constraint href_specialties_c4 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_specialties.kind is '(G)roup of specialties, (S)pecialty';
comment on column href_specialties.state is '(A)ctive, (P)assive';

create unique index href_specialties_u2 on href_specialties(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_specialties_u3 on href_specialties(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_specialties_i1 on href_specialties(company_id, parent_id) tablespace GWS_INDEX;
create index href_specialties_i2 on href_specialties(company_id, created_by) tablespace GWS_INDEX;
create index href_specialties_i3 on href_specialties(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_langs(
  company_id                      number(20)         not null,
  lang_id                         number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_langs_pk primary key (company_id, lang_id) using index tablespace GWS_INDEX,
  constraint href_langs_u1 unique (lang_id) using index tablespace GWS_INDEX,
  constraint href_langs_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_langs_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_langs_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_langs_c2 check (state in ('A', 'P')),
  constraint href_langs_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_langs.state is '(A)ctive, (P)assive';

create unique index href_langs_u2 on href_langs(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_langs_u3 on href_langs(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_langs_i1 on href_langs(company_id, created_by) tablespace GWS_INDEX;
create index href_langs_i2 on href_langs(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_lang_levels(
  company_id                      number(20)         not null,
  lang_level_id                   number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  order_no                        number(6),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_lang_levels_pk primary key (company_id, lang_level_id) using index tablespace GWS_INDEX,
  constraint href_lang_levels_u1 unique (lang_level_id) using index tablespace GWS_INDEX,
  constraint href_lang_levels_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_lang_levels_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_lang_levels_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_lang_levels_c2 check (state in ('A', 'P')),
  constraint href_lang_levels_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_lang_levels.state is '(A)ctive, (P)assive';

create unique index href_lang_levels_u2 on href_lang_levels(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_lang_levels_u3 on href_lang_levels(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_lang_levels_i1 on href_lang_levels(company_id, created_by) tablespace GWS_INDEX;
create index href_lang_levels_i2 on href_lang_levels(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_document_types(
  company_id                      number(20)         not null,
  doc_type_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  is_required                     varchar2(1)        not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_document_types_pk primary key (company_id, doc_type_id)using index tablespace GWS_INDEX,
  constraint href_document_types_u1 unique (doc_type_id) using index tablespace GWS_INDEX,
  constraint href_document_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_document_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_document_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_document_types_c2 check (is_required in ('Y', 'N')),
  constraint href_document_types_c3 check (state in ('A', 'P')),
  constraint href_document_types_c4 check (decode(trim(code), code, 1, 0) = 1),
  constraint href_document_types_c5 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_document_types.is_required is '(Y)es, (N)o';
comment on column href_document_types.state is '(A)ctive, (P)assive';

create unique index href_document_types_u2 on href_document_types(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_document_types_u3 on href_document_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;
create unique index href_document_types_u4 on href_document_types(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index href_document_types_i1 on href_document_types(company_id, created_by) tablespace GWS_INDEX;
create index href_document_types_i2 on href_document_types(company_id, modified_by) tablespace GWS_INDEX;

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
create table href_reference_types(
  company_id                      number(20)         not null,
  reference_type_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_reference_types_pk primary key (company_id, reference_type_id) using index tablespace GWS_INDEX,
  constraint href_reference_types_u1 unique (reference_type_id) using index tablespace GWS_INDEX,
  constraint href_reference_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_reference_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_reference_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_reference_types_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint href_reference_types_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_reference_types.state is '(A)ctive, (P)assive';

create unique index href_reference_types_u2 on href_reference_types(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_reference_types_u3 on href_reference_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_reference_types_i1 on href_reference_types(company_id, created_by) tablespace GWS_INDEX;
create index href_reference_types_i2 on href_reference_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_relation_degrees(
  company_id                      number(20)         not null,
  relation_degree_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar(50),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_relation_degrees_pk primary key (company_id, relation_degree_id) using index tablespace GWS_INDEX,
  constraint href_relation_degrees_u1 unique (relation_degree_id) using index tablespace GWS_INDEX,
  constraint href_relation_degrees_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_relation_degrees_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_relation_degrees_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_relation_degrees_c2 check (state in ('A', 'P')),
  constraint href_relation_degrees_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_relation_degrees.state is '(A)ctive, (P)assive';

create unique index href_relation_degrees_u2 on href_relation_degrees(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_relation_degrees_u3 on href_relation_degrees(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_relation_degrees_i1 on href_relation_degrees(company_id, created_by) tablespace GWS_INDEX;
create index href_relation_degrees_i2 on href_relation_degrees(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_marital_statuses(
  company_id                      number(20)         not null,
  marital_status_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_marital_statuses_pk primary key (company_id, marital_status_id) using index tablespace GWS_INDEX,
  constraint href_marital_statuses_u1 unique (marital_status_id) using index tablespace GWS_INDEX,
  constraint href_marital_statuses_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_marital_statuses_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_marital_statuses_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_marital_statuses_c2 check (state in ('A', 'P')),
  constraint href_marital_statuses_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_marital_statuses.state is '(A)ctive, (P)assive';

create unique index href_marital_statuses_u2 on href_marital_statuses(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_marital_statuses_u3 on href_marital_statuses(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_marital_statuses_i1 on href_marital_statuses(company_id, created_by) tablespace GWS_INDEX;
create index href_marital_statuses_i2 on href_marital_statuses(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_experience_types(
  company_id                      number(20)         not null,
  experience_type_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_experience_types_pk primary key (company_id, experience_type_id) using index tablespace GWS_INDEX,
  constraint href_experience_types_u1 unique (experience_type_id) using index tablespace GWS_INDEX,
  constraint href_experience_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_experience_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_experience_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_experience_types_c2 check (state in ('A', 'P')),
  constraint href_experience_types_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_experience_types.state is '(A)ctive, (P)assive';

create unique index href_experience_types_u2 on href_experience_types(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_experience_types_u3 on href_experience_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_experience_types_i1 on href_experience_types(company_id, created_by) tablespace GWS_INDEX;
create index href_experience_types_i2 on href_experience_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_nationalities(
  company_id                      number(20)         not null,
  nationality_id                  number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,  
  modified_id                     number(20)   not null,
  constraint href_nationalities_pk primary key (company_id, nationality_id) using index tablespace GWS_INDEX,
  constraint href_nationalities_u1 unique (nationality_id) using index tablespace GWS_INDEX,
  constraint href_nationalities_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_nationalities_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_nationalities_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_nationalities_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_nationalities_c2 check (state in ('A', 'P')),
  constraint href_nationalities_c3 check (decode(trim(code), code, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_nationalities.state is '(A)ctive, (P)assive';

create unique index href_nationalities_u3 on href_nationalities(company_id, lower(name)) tablespace GWS_INDEX;
create unique index href_nationalities_u4 on href_nationalities(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_nationalities_i1 on href_nationalities(company_id, created_by) tablespace GWS_INDEX;
create index href_nationalities_i2 on href_nationalities(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_awards(
  company_id                      number(20)         not null,
  award_id                        number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_awards_pk primary key (company_id, award_id) using index tablespace GWS_INDEX,
  constraint href_awards_u1 unique (award_id) using index tablespace GWS_INDEX,
  constraint href_awards_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_awards_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_awards_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_awards_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_awards.state is '(A)ctive, (P)assive';

create unique index href_awards_u2 on href_awards(company_id, lower(name)) tablespace GWS_INDEX;

create index href_awards_i1 on href_awards(company_id, created_by) tablespace GWS_INDEX;
create index href_awards_i2 on href_awards(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_inventory_types(
  company_id                      number(20)         not null,
  inventory_type_id               number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_inventory_types_pk primary key (company_id, inventory_type_id) using index tablespace GWS_INDEX,
  constraint href_inventory_types_u1 unique (inventory_type_id) using index tablespace GWS_INDEX,
  constraint href_inventory_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_inventory_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_inventory_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_inventory_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index href_inventory_types_u2 on href_inventory_types(company_id, lower(name)) tablespace GWS_INDEX;

create index href_inventory_types_i1 on href_inventory_types(company_id, created_by) tablespace GWS_INDEX;
create index href_inventory_types_i2 on href_inventory_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_details(
  company_id                      number(20)  not null,
  person_id                       number(20)  not null,
  extra_phone                     varchar2(100 char),
  iapa                            varchar2(20 char),
  npin                            varchar2(14 char),
  corporate_email                 varchar2(300),
  nationality_id                  number(20),
  key_person                      varchar2(1) not null,
  access_all_employees            varchar2(1) not null,
  access_hidden_salary            varchar2(1) not null,
  constraint href_person_details_pk primary key (company_id, person_id) using index tablespace GWS_INDEX,
  constraint href_person_details_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_details_f2 foreign key (company_id, nationality_id) references href_nationalities(company_id, nationality_id),
  constraint href_person_details_c1 check (decode(trim(iapa), iapa, 1, 0) = 1),
  constraint href_person_details_c2 check (decode(trim(npin), npin, 1, 0) = 1),
  constraint href_person_details_c3 check (key_person in ('Y', 'N')),
  constraint href_person_details_c4 check (access_all_employees in ('Y', 'N')),
  constraint href_person_details_c5 check (access_hidden_salary in ('Y', 'N'))
) tablespace GWS_DATA;

comment on column href_person_details.iapa                 is 'Individual Accumulative Pension Account (ИНПС)';
comment on column href_person_details.npin                 is 'Natural Personal Identification Number (ПИНФЛ)';
comment on column href_person_details.access_hidden_salary is '(Y)es, (N)o. Has access to view hidden salary';

create unique index href_person_details_u1 on href_person_details(nvl2(iapa, company_id, null), iapa) tablespace GWS_INDEX;
create unique index href_person_details_u2 on href_person_details(nvl2(npin, company_id, null), npin) tablespace GWS_INDEX;

create index href_person_details_i1 on href_person_details(company_id, nationality_id) tablespace GWS_INDEX;
create index href_person_details_i2 on href_person_details(company_id, npin) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_edu_stages(
  company_id                      number(20) not null,
  person_edu_stage_id             number(20) not null,
  person_id                       number(20) not null,
  edu_stage_id                    number(20) not null,
  institution_id                  number(20),
  begin_date                      date,
  end_date                        date,
  specialty_id                    number(20),
  qualification                   varchar2(100 char), 
  course                          number(1),
  hour_amount                     number(6),
  base                            varchar2(50 char),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_edu_stages_pk primary key (company_id, person_edu_stage_id) using index tablespace GWS_INDEX,
  constraint href_person_edu_stages_u1 unique (person_edu_stage_id) using index tablespace GWS_INDEX,
  constraint href_person_edu_stages_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_edu_stages_f2 foreign key (company_id, edu_stage_id) references href_edu_stages(company_id, edu_stage_id),
  constraint href_person_edu_stages_f3 foreign key (company_id, institution_id) references href_institutions(company_id, institution_id),
  constraint href_person_edu_stages_f4 foreign key (company_id, specialty_id) references href_specialties(company_id, specialty_id),
  constraint href_person_edu_stages_f5 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_edu_stages_f6 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index href_person_edu_stages_i1 on href_person_edu_stages(company_id, person_id) tablespace GWS_INDEX;
create index href_person_edu_stages_i2 on href_person_edu_stages(company_id, edu_stage_id) tablespace GWS_INDEX;
create index href_person_edu_stages_i3 on href_person_edu_stages(company_id, institution_id) tablespace GWS_INDEX;
create index href_person_edu_stages_i4 on href_person_edu_stages(company_id, specialty_id) tablespace GWS_INDEX;
create index href_person_edu_stages_i5 on href_person_edu_stages(company_id, created_by) tablespace GWS_INDEX;
create index href_person_edu_stages_i6 on href_person_edu_stages(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_edu_stage_files(
  company_id                      number(20)   not null,
  person_edu_stage_id             number(20)   not null,
  sha                             varchar2(64) not null,
  constraint href_person_edu_stage_files_pk primary key (company_id, person_edu_stage_id, sha) using index tablespace GWS_INDEX,
  constraint href_person_edu_stage_files_f1 foreign key (company_id, person_edu_stage_id) references href_person_edu_stages(company_id, person_edu_stage_id) on delete cascade,
  constraint href_person_edu_stage_files_f2 foreign key (sha) references biruni_files(sha)
) tablespace GWS_DATA;

create index href_person_edu_stage_files_i1 on href_person_edu_stage_files(sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_langs(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  lang_id                         number(20) not null,
  lang_level_id                   number(20),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_langs_pk primary key (company_id, person_id, lang_id) using index tablespace GWS_INDEX,
  constraint href_person_langs_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_langs_f2 foreign key (company_id, lang_id) references href_langs(company_id, lang_id),
  constraint href_person_langs_f3 foreign key (company_id, lang_level_id) references href_lang_levels(company_id, lang_level_id),
  constraint href_person_langs_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_langs_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index href_person_langs_i1 on href_person_langs(company_id, lang_id) tablespace GWS_INDEX;
create index href_person_langs_i2 on href_person_langs(company_id, lang_level_id) tablespace GWS_INDEX;
create index href_person_langs_i3 on href_person_langs(company_id, created_by) tablespace GWS_INDEX;
create index href_person_langs_i4 on href_person_langs(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_documents(
  company_id                      number(20)  not null,
  document_id                     number(20)  not null,
  person_id                       number(20)  not null,
  doc_type_id                     number(20)  not null,
  doc_series                      varchar2(50 char),
  doc_number                      varchar2(50 char),
  issued_by                       varchar2(150 char),
  issued_date                     date,
  begin_date                      date,
  expiry_date                     date,  
  is_valid                        varchar2(1) not null,
  status                          varchar2(1) not null,
  note                            varchar2(300 char),
  rejected_note                   varchar2(300 char),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_documents_pk primary key (company_id, document_id) using index tablespace GWS_INDEX,
  constraint href_person_documents_u1 unique (document_id) using index tablespace GWS_INDEX,
  constraint href_person_documents_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_documents_f2 foreign key (company_id, doc_type_id) references href_document_types(company_id, doc_type_id),
  constraint href_person_documents_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_documents_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_documents_c1 check (is_valid in ('Y', 'N')),
  constraint href_person_documents_c2 check (status in ('N', 'A', 'R'))
) tablespace GWS_DATA;

comment on column href_person_documents.is_valid is '(Y)es, (N)o';
comment on column href_person_documents.status is '(N)ew, (A)pproved, (R)ejected';

create unique index href_person_documents_u2 on href_person_documents(nvl2(doc_series || doc_number, company_id, null), nvl2(doc_series || doc_number, doc_type_id, null), doc_series || doc_number) tablespace GWS_INDEX;

create index href_person_documents_i1 on href_person_documents(company_id, person_id) tablespace GWS_INDEX;
create index href_person_documents_i2 on href_person_documents(company_id, doc_type_id) tablespace GWS_INDEX;
create index href_person_documents_i3 on href_person_documents(company_id, created_by) tablespace GWS_INDEX;
create index href_person_documents_i4 on href_person_documents(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_document_files(
  company_id                      number(20)   not null,
  document_id                     number(20)   not null,
  sha                             varchar2(64) not null,
  constraint href_person_document_files_pk primary key (company_id, document_id, sha) using index tablespace GWS_INDEX,
  constraint href_person_document_files_f1 foreign key (company_id, document_id) references href_person_documents(company_id, document_id) on delete cascade,
  constraint href_person_document_files_f2 foreign key (sha) references biruni_files(sha)
) tablespace GWS_DATA;

create index href_person_document_files_i1 on href_person_document_files(sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_references(
  company_id                      number(20)         not null,
  person_reference_id             number(20)         not null,
  person_id                       number(20)         not null,
  reference_type_id               number(20)         not null,
  ref_number                      varchar2(50 char)  not null,
  ref_date                        date,
  start_date                      date,
  end_date                        date,
  name                            varchar2(100 char) not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_references_pk primary key (company_id, person_reference_id) using index tablespace GWS_INDEX,
  constraint href_person_references_u1 unique (person_reference_id) using index tablespace GWS_INDEX,
  constraint href_person_references_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_references_f2 foreign key (company_id, reference_type_id) references href_reference_types(company_id, reference_type_id),
  constraint href_person_references_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_references_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_references_c1 check (start_date <= end_date)
) tablespace GWS_DATA;

create index href_person_references_i1 on href_person_references(company_id, person_id) tablespace GWS_INDEX;
create index href_person_references_i2 on href_person_references(company_id, reference_type_id) tablespace GWS_INDEX;
create index href_person_references_i3 on href_person_references(company_id, created_by) tablespace GWS_INDEX;
create index href_person_references_i4 on href_person_references(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_family_members(
  company_id                      number(20)         not null,
  person_family_member_id         number(20)         not null,
  person_id                       number(20)         not null,
  name                            varchar2(300 char) not null,
  relation_degree_id              number(20),
  birthday                        date,
  workplace                       varchar2(200 char),
  is_dependent                    varchar2(1)        not null,
  is_private                      varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_family_members_pk primary key (company_id, person_family_member_id) using index tablespace GWS_INDEX,
  constraint href_person_family_members_u1 unique (person_family_member_id) using index tablespace GWS_INDEX,
  constraint href_person_family_members_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_family_members_f2 foreign key (company_id, relation_degree_id) references href_relation_degrees(company_id, relation_degree_id),
  constraint href_person_family_members_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_family_members_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_family_members_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_person_family_members_c2 check (is_dependent in ('Y', 'N')),
  constraint href_person_family_members_c3 check (is_private in ('Y', 'N'))
) tablespace GWS_DATA;

create index href_person_family_members_i1 on href_person_family_members(company_id, person_id) tablespace GWS_INDEX;
create index href_person_family_members_i2 on href_person_family_members(company_id, relation_degree_id) tablespace GWS_INDEX;
create index href_person_family_members_i3 on href_person_family_members(company_id, created_by) tablespace GWS_INDEX;
create index href_person_family_members_i4 on href_person_family_members(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_marital_statuses(
  company_id                      number(20) not null,
  person_marital_status_id        number(20) not null,
  person_id                       number(20) not null,
  marital_status_id               number(20) not null,
  start_date                      date       not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_marital_statuses_pk primary key (company_id, person_marital_status_id) using index tablespace GWS_INDEX,
  constraint href_person_marital_statuses_u1 unique (person_marital_status_id) using index tablespace GWS_INDEX,
  constraint href_person_marital_statuses_u2 unique (company_id, person_id, marital_status_id, start_date) using index tablespace GWS_INDEX,
  constraint href_person_marital_statuses_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_marital_statuses_f2 foreign key (company_id, marital_status_id) references href_marital_statuses(company_id, marital_status_id),
  constraint href_person_marital_statuses_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_marital_statuses_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index href_person_marital_statuses_i1 on href_person_marital_statuses(company_id, marital_status_id) tablespace GWS_INDEX;
create index href_person_marital_statuses_i2 on href_person_marital_statuses(company_id, created_by) tablespace GWS_INDEX;
create index href_person_marital_statuses_i3 on href_person_marital_statuses(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_experiences(
  company_id                      number(20)         not null,
  person_experience_id            number(20)         not null,
  person_id                       number(20)         not null,
  experience_type_id              number(20)         not null,
  is_working                      varchar2(100 char) not null,
  start_date                      date               not null,
  num_year                        number(2),
  num_month                       number(2),
  num_day                         number(2),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_experiences_pk primary key (company_id, person_experience_id) using index tablespace GWS_INDEX,
  constraint href_person_experiences_u1 unique (person_experience_id) using index tablespace GWS_INDEX,
  constraint href_person_experiences_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_experiences_f2 foreign key (company_id, experience_type_id) references href_experience_types(company_id, experience_type_id),
  constraint href_person_experiences_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_experiences_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_experiences_c1 check (is_working in ('Y', 'N')),
  constraint href_person_experiences_c2 check (decode(is_working, 'Y', 0, 'N', 3) = nvl2(num_year, 1, 0) + nvl2(num_month, 1, 0) + nvl2(num_day, 1, 0))
) tablespace GWS_DATA;

create index href_person_experiences_i1 on href_person_experiences(company_id, person_id) tablespace GWS_INDEX;
create index href_person_experiences_i2 on href_person_experiences(company_id, experience_type_id) tablespace GWS_INDEX;
create index href_person_experiences_i3 on href_person_experiences(company_id, created_by) tablespace GWS_INDEX;
create index href_person_experiences_i4 on href_person_experiences(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_awards(
  company_id                      number(20) not null,
  person_award_id                 number(20) not null,
  person_id                       number(20) not null,
  award_id                        number(20) not null,
  doc_title                       varchar2(100 char),
  doc_number                      varchar2(50 char),
  doc_date                        date,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_awards_pk primary key (company_id, person_award_id) using index tablespace GWS_INDEX,
  constraint href_person_awards_u1 unique (person_award_id) using index tablespace GWS_INDEX,
  constraint href_person_awards_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_awards_f2 foreign key (company_id, award_id) references href_awards(company_id, award_id),
  constraint href_person_awards_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_awards_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index href_person_awards_i1 on href_person_awards(company_id, person_id) tablespace GWS_INDEX;
create index href_person_awards_i2 on href_person_awards(company_id, award_id) tablespace GWS_INDEX;
create index href_person_awards_i3 on href_person_awards(company_id, created_by) tablespace GWS_INDEX;
create index href_person_awards_i4 on href_person_awards(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_work_places(
  company_id                      number(20)         not null,
  person_work_place_id            number(20)         not null,
  person_id                       number(20)         not null,
  start_date                      date,
  end_date                        date,
  organization_name               varchar2(250 char) not null,
  job_title                       varchar2(100 char) not null,
  organization_address            varchar2(300 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_work_places_pk primary key (company_id, person_work_place_id) using index tablespace GWS_INDEX,
  constraint href_person_work_places_u1 unique (person_work_place_id) using index tablespace GWS_INDEX,
  constraint href_person_work_places_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_work_places_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_work_places_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_work_places_c1 check (decode(trim(organization_name), organization_name, 1, 0) = 1),
  constraint href_person_work_places_c2 check (decode(trim(job_title), job_title, 1, 0) = 1)
) tablespace GWS_DATA;

create index href_person_work_places_i1 on href_person_work_places(company_id, person_id) tablespace GWS_INDEX;
create index href_person_work_places_i2 on href_person_work_places(company_id, created_by) tablespace GWS_INDEX;
create index href_person_work_places_i3 on href_person_work_places(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_inventories(
  company_id                      number(20) not null,
  person_inventory_id             number(20) not null,
  person_id                       number(20) not null,
  inventory_type_id               number(20) not null,
  date_assigned                   date       not null,
  date_returned                   date,
  note                            varchar2(300 char),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_inventories_pk primary key (company_id, person_inventory_id) using index tablespace GWS_INDEX,
  constraint href_person_inventories_u1 unique (person_inventory_id) using index tablespace GWS_INDEX,
  constraint href_person_inventories_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_inventories_f2 foreign key (company_id, inventory_type_id) references href_inventory_types(company_id, inventory_type_id),
  constraint href_person_inventories_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_inventories_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_person_inventories_c1 check (trunc(date_assigned) = date_assigned),
  constraint href_person_inventories_c2 check (trunc(date_returned) = date_returned),
  constraint href_person_inventories_c3 check (date_assigned <= date_returned)
) tablespace GWS_DATA;

create index href_person_inventories_i1 on href_person_inventories(company_id, person_id) tablespace GWS_INDEX;
create index href_person_inventories_i2 on href_person_inventories(company_id, inventory_type_id) tablespace GWS_INDEX;
create index href_person_inventories_i3 on href_person_inventories(company_id, created_by) tablespace GWS_INDEX;
create index href_person_inventories_i4 on href_person_inventories(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_hidden_salary_job_groups(
  company_id                      number(20) not null,
  person_id                       number(20) not null,
  job_group_id                    number(20) not null,
  constraint href_person_hidden_salary_job_groups_pk primary key (company_id, person_id, job_group_id) using index tablespace GWS_INDEX,
  constraint href_person_hidden_salary_job_groups_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade
-- NEXT constraint is added in hrm module
-- as it references table from hrm module 
-- constraint href_person_hidden_salary_job_groups_f2 foreign key (company_id, job_group_id) references hrm_hidden_salary_job_groups(company_id, job_group_id) on delete cascade
) tablespace GWS_DATA;

create index href_person_hidden_salary_job_groups_i1 on href_person_hidden_salary_job_groups(company_id, job_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_labor_functions(
  company_id                      number(20)         not null,
  labor_function_id               number(20)         not null,
  name                            varchar2(150 char) not null,
  description                     varchar2(300 char),
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_labor_functions_pk primary key (company_id, labor_function_id) using index tablespace GWS_INDEX,
  constraint href_labor_functions_u1 unique (labor_function_id) using index tablespace GWS_INDEX,
  constraint href_labor_functions_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_labor_functions_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_labor_functions_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_labor_functions_c2 check (decode(trim(description), description, 1, 0) = 1),
  constraint href_labor_functions_c3 check (decode(trim(code), code, 1, 0) = 1)  
) tablespace GWS_DATA;

create unique index href_labor_functions_u2 on href_labor_functions(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_labor_functions_i1 on href_labor_functions(company_id, created_by) tablespace GWS_INDEX;
create index href_labor_functions_i2 on href_labor_functions(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------    
create table href_sick_leave_reasons(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  reason_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  coefficient                     number(7,6)        not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20),
  constraint href_sick_leave_reasons_pk primary key (company_id, filial_id, reason_id) using index tablespace GWS_INDEX,
  constraint href_sick_leave_reasons_u1 unique (reason_id) using index tablespace GWS_INDEX,
  constraint href_sick_leave_reasons_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_sick_leave_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_sick_leave_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_sick_leave_reasons_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_sick_leave_reasons_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint href_sick_leave_reasons_c3 check (coefficient between 0 and 1),
  constraint href_sick_leave_reasons_c4 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_sick_leave_reasons.state is '(A)ctive, (P)assive';

create unique index href_sick_leave_reasons_u3 on href_sick_leave_reasons(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

create index href_sick_leave_reasons_i1 on href_sick_leave_reasons(company_id, created_by) tablespace GWS_INDEX;
create index href_sick_leave_reasons_i2 on href_sick_leave_reasons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_business_trip_reasons(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  reason_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20),
  constraint href_business_trip_reasons_pk primary key (company_id, filial_id, reason_id) using index tablespace GWS_INDEX,
  constraint href_business_trip_reasons_u1 unique (reason_id) using index tablespace GWS_INDEX,
  constraint href_business_trip_reasons_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_business_trip_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_business_trip_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_business_trip_reasons_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_business_trip_reasons_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint href_business_trip_reasons_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_business_trip_reasons.state is '(A)ctive, (P)assive';

create unique index href_business_trip_reasons_u3 on href_business_trip_reasons(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

create index href_business_trip_reasons_i1 on href_business_trip_reasons(company_id, created_by) tablespace GWS_INDEX;
create index href_business_trip_reasons_i2 on href_business_trip_reasons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_dismissal_reasons(
  company_id                      number(20)         not null,
  dismissal_reason_id             number(20)         not null,
  name                            varchar2(100 char) not null,
  description                     varchar2(300 char),
  reason_type                     varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint href_dismissal_reasons_pk primary key (company_id, dismissal_reason_id) using index tablespace GWS_INDEX,
  constraint href_dismissal_reasons_u1 unique (dismissal_reason_id) using index tablespace GWS_INDEX,
  constraint href_dismissal_reasons_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_dismissal_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_dismissal_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_dismissal_reasons_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_dismissal_reasons_c2 check (decode(trim(description), description, 1, 0) = 1),
  constraint href_dismissal_reasons_c3 check (reason_type in ('P', 'N'))
) tablespace GWS_DATA;

comment on column href_dismissal_reasons.reason_type is '(P)ositive, (N)egative';

create index href_dismissal_reasons_i1 on href_dismissal_reasons(company_id, created_by) tablespace GWS_INDEX;
create index href_dismissal_reasons_i2 on href_dismissal_reasons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_wages(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  wage_id                         number(20)   not null,
  job_id                          number(20)   not null,
  rank_id                         number(20),
  wage_begin                      number(20,6) not null,
  wage_end                        number(20,6) not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_wages_pk primary key (company_id, filial_id, wage_id) using index tablespace GWS_INDEX,
  constraint href_wages_u1 unique (wage_id) using index tablespace GWS_INDEX,
  constraint href_wages_f1 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint href_wages_f2 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id),
  constraint href_wages_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_wages_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_wages_c1 check (wage_begin > 0 and wage_end > 0 and wage_end >= wage_begin)
) tablespace GWS_DATA;

create unique index href_wages_u2 on href_wages(company_id, filial_id, job_id, rank_id) tablespace GWS_INDEX;

create index href_wages_i1 on href_wages(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index href_wages_i2 on href_wages(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index href_wages_i3 on href_wages(company_id, created_by) tablespace GWS_INDEX;
create index href_wages_i4 on href_wages(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_employment_sources(
  company_id                      number(20)         not null,
  source_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  kind                            varchar2(1)        not null,
  order_no                        number(6),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint href_employment_sources_pk primary key (company_id, source_id) using index tablespace GWS_INDEX,
  constraint href_employment_sources_u1 unique (source_id) using index tablespace GWS_INDEX,
  constraint href_employment_sources_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_employment_sources_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_employment_sources_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_employment_sources_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_employment_sources_c2 check (kind in ('H', 'D', 'B')),
  constraint href_employment_sources_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_employment_sources.kind is '(H)iring, (D)ismissal, (B)oth';
comment on column href_employment_sources.state is '(A)ctive, (P)assive';

create index href_employment_sources_i1 on href_employment_sources(company_id, created_by) tablespace GWS_INDEX;
create index href_employment_sources_i2 on href_employment_sources(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_indicator_groups(
  company_id                      number(20)         not null,
  indicator_group_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  pcode                           varchar2(20)       not null,
  constraint href_indicator_groups_pk primary key (company_id, indicator_group_id) using index tablespace GWS_INDEX,
  constraint href_indicator_groups_u1 unique (indicator_group_id) using index tablespace GWS_INDEX,
  constraint href_indicator_groups_u2 unique (company_id, pcode) using index tablespace GWS_INDEX,
  constraint href_indicator_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_indicator_groups_c2 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table href_indicator_groups is 'Grouping for href_indicators';

----------------------------------------------------------------------------------------------------
create table href_indicators(
  company_id                      number(20)         not null,
  indicator_id                    number(20)         not null,
  indicator_group_id              number(20)         not null,
  name                            varchar2(100 char) not null,
  short_name                      varchar2(50 char),
  identifier                      varchar2(50 char)  not null,
  used                            varchar2(1)        not null,
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20),
  constraint href_indicators_pk primary key (company_id, indicator_id) using index tablespace GWS_INDEX,
  constraint href_indicators_u1 unique (indicator_id) using index tablespace GWS_INDEX,
  constraint href_indicators_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_indicators_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_indicators_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_indicators_f3 foreign key (company_id, indicator_group_id) references href_indicator_groups(company_id, indicator_group_id),
  constraint href_indicators_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_indicators_c2 check (decode(trim(short_name), short_name, 1, 0) = 1),
  constraint href_indicators_c3 check (regexp_like(identifier, '^[[:alpha:]_][[:alnum:]_]*$', 'i')),
  constraint href_indicators_c4 check (used in ('C', 'A')),
  constraint href_indicators_c5 check (state in ('A', 'P')),
  constraint href_indicators_c6 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column href_indicators.used is '(C)onstantly, (A)utomatically';

create unique index href_indicators_u3 on href_indicators(company_id, lower(identifier)) tablespace GWS_INDEX;
create unique index href_indicators_u4 on href_indicators(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index href_indicators_i1 on href_indicators(company_id, created_by) tablespace GWS_INDEX;
create index href_indicators_i2 on href_indicators(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_ftes(
  company_id                      number(20)         not null,
  fte_id                          number(20)         not null,
  name                            varchar2(100 char) not null,
  fte_value                       number(7,6)        not null,
  order_no                        number(6),
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)         not null,
  constraint href_ftes_pk primary key (company_id, fte_id) using index tablespace GWS_INDEX,
  constraint href_ftes_u1 unique (fte_id) using index tablespace GWS_INDEX,
  constraint href_ftes_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX,
  constraint href_ftes_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_ftes_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_ftes_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_ftes_c2 check (fte_value <= 1 and fte_value > 0),
  constraint href_ftes_c3 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index href_ftes_u3 on href_ftes(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;
create unique index href_ftes_u4 on href_ftes(company_id, lower(name)) tablespace GWS_INDEX;

create index href_ftes_i1 on href_ftes(company_id, created_by) tablespace GWS_INDEX;
create index href_ftes_i2 on href_ftes(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- candidate
----------------------------------------------------------------------------------------------------
create table href_candidate_ref_settings(
  company_id                    number(20) not null,
  filial_id                     number(20) not null,
  region                        varchar(1) not null,
  address                       varchar(1) not null,
  experience                    varchar(1) not null,
  source                        varchar(1) not null,
  recommendation                varchar(1) not null,
  cv                            varchar(1) not null,
  constraint href_candidate_ref_settings_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX,
  constraint href_candidate_ref_settings_c1 check (region in ('Y', 'N')),
  constraint href_candidate_ref_settings_c2 check (address in ('Y', 'N')),
  constraint href_candidate_ref_settings_c3 check (experience in ('Y', 'N')),
  constraint href_candidate_ref_settings_c4 check (source in ('Y', 'N')),
  constraint href_candidate_ref_settings_c5 check (recommendation in ('Y', 'N')),
  constraint href_candidate_ref_settings_c6 check (cv in ('Y', 'N'))
) tablespace GWS_DATA;

comment on table href_candidate_ref_settings                      is  'settings for candidate form';
comment on column href_candidate_ref_settings.region              is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.address             is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.experience          is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.source              is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.recommendation      is  '(Y)es, (N)o';
comment on column href_candidate_ref_settings.cv                  is  '(Y)es, (N)o';

----------------------------------------------------------------------------------------------------
create table href_candidate_langs(
  company_id                    number(20) not null,
  filial_id                     number(20) not null,
  lang_id                       number(20) not null,
  order_no                      number(6),
  constraint href_candidate_langs_pk primary key (company_id, filial_id, lang_id) using index tablespace GWS_INDEX,
  constraint href_candidate_langs_f1 foreign key (company_id, lang_id) references href_langs(company_id, lang_id)
) tablespace GWS_DATA;

create index href_candidate_langs_i1 on href_candidate_langs(company_id, lang_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_candidate_edu_stages(
  company_id                    number(20) not null,
  filial_id                     number(20) not null,
  edu_stage_id                  number(20) not null,
  order_no                      number(6),
  constraint href_candidate_edu_stages_pk primary key (company_id, filial_id, edu_stage_id) using index tablespace GWS_INDEX,
  constraint href_candidate_edu_stages_f1 foreign key (company_id, edu_stage_id) references href_edu_stages(company_id, edu_stage_id)
) tablespace GWS_DATA;

create index href_candidate_edu_stages_i1 on href_candidate_edu_stages(company_id, edu_stage_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_candidates(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  candidate_id                    number(20)  not null,
  candidate_kind                  varchar2(1) not null,
  source_id                       number(20),
  wage_expectation                number(9),
  cv_sha                          varchar2(64),
  note                            varchar2(2000 char),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_candidates_pk primary key (company_id, filial_id, candidate_id) using index tablespace GWS_INDEX,
  constraint href_candidates_f1 foreign key (company_id, candidate_id) references mr_natural_persons(company_id, person_id),
  constraint href_candidates_f2 foreign key (company_id, source_id) references href_employment_sources(company_id, source_id),
  constraint href_candidates_f3 foreign key (cv_sha) references biruni_files(sha),
  constraint href_candidates_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_candidates_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_candidates_c1 check (candidate_kind in ('N', 'F'))
) tablespace GWS_DATA;

comment on column href_candidates.candidate_kind is '(N)ew, (F)ormer';

create index href_candidates_i1 on href_candidates(company_id, source_id) tablespace GWS_INDEX;
create index href_candidates_i2 on href_candidates(cv_sha) tablespace GWS_INDEX;
create index href_candidates_i3 on href_candidates(company_id, created_by) tablespace GWS_INDEX;
create index href_candidates_i4 on href_candidates(company_id, modified_by) tablespace GWS_INDEX;
create index href_candidates_i5 on href_candidates(company_id, candidate_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------  
create table href_candidate_recoms(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  candidate_id                    number(20)         not null,
  recommendation_id               number(20)         not null,
  sender_name                     varchar2(300 char) not null,
  sender_phone_number             varchar2(30 char),
  sender_email                    varchar2(320 char),
  file_sha                        varchar2(64),
  order_no                        number(6),
  feedback                        varchar2(300 char),
  note                            varchar2(300 char),
  constraint href_candidate_recoms_pk primary key (company_id, filial_id, recommendation_id) using index tablespace GWS_INDEX,
  constraint href_candidate_recoms_u1 unique (recommendation_id) using index tablespace GWS_INDEX,
  constraint href_candidate_recoms_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade,
  constraint href_candidate_recoms_f2 foreign key (file_sha) references biruni_files(sha),
  constraint href_candidate_recoms_c1 check (decode(trim(sender_name), sender_name, 1, 0) = 1)
) tablespace GWS_DATA;

create index href_candidate_recoms_i1 on href_candidate_recoms(company_id, filial_id, candidate_id) tablespace GWS_INDEX;
create index href_candidate_recoms_i2 on href_candidate_recoms(file_sha) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------   
create table href_candidate_jobs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  candidate_id                    number(20) not null,
  job_id                          number(20) not null,
  constraint href_candidate_jobs_pk primary key (company_id, filial_id, candidate_id, job_id) using index tablespace GWS_INDEX,
  constraint href_candidate_jobs_f1 foreign key (company_id, filial_id, candidate_id) references href_candidates(company_id, filial_id, candidate_id) on delete cascade,
  constraint href_candidate_jobs_f2 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id) on delete cascade
) tablespace GWS_DATA;

create index href_candidate_jobs_i1 on href_candidate_jobs(company_id, filial_id, job_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table href_cached_contract_item_names(
  company_id                      number(20)         not null,
  name                            varchar2(500 char) not null,
  constraint href_cached_contract_item_names_pk primary key (company_id, name) using index tablespace GWS_INDEX,
  constraint href_cached_contract_item_names_c1 check (name = lower(name))
) tablespace GWS_DATA;

comment on table href_cached_contract_item_names is 'Keeps service names. This table used only work with civil contracts.';

----------------------------------------------------------------------------------------------------
create table href_timepad_users(
  company_id                      number(20) not null,
  user_id                         number(20) not null,
  constraint href_timepad_users_pk primary key (company_id) using index tablespace GWS_INDEX,
  constraint href_timepad_users_f1 foreign key (company_id, user_id) references md_users(company_id, user_id)
) tablespace GWS_DATA;

comment on table href_timepad_users is 'Keeps Virtual User Ids for timepad';

create index href_timepad_users_i1 on href_timepad_users(company_id, user_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_badge_templates(
  badge_template_id               number(20)          not null,
  name                            varchar2(100 char)  not null,
  html_value                      varchar2(4000 char) not null,
  state                           varchar2(1)         not null,
  constraint href_badge_templates_pk primary key (badge_template_id) using index tablespace GWS_INDEX,
  constraint href_badge_templates_u1 unique (name) using index tablespace GWS_INDEX,
  constraint href_badge_templates_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_badge_templates_c2 check (decode(trim(html_value), html_value, 1, 0) = 1),
  constraint href_badge_templates_c3 check (state in ('A', 'P'))  
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create table href_bank_accounts(
  company_id                      number(20) not null,
  bank_account_id                 number(20) not null,
  card_number                     varchar2(20),
  constraint href_bank_accounts_pk primary key (company_id, bank_account_id) using index tablespace GWS_INDEX,
  constraint href_bank_accounts_f1 foreign key (company_id, bank_account_id) references mkcs_bank_accounts(company_id, bank_account_id) on delete cascade
) tablespace GWS_DATA;
