prompt adding agreements cache index
----------------------------------------------------------------------------------------------------
create index hpd_agreements_cache_i3 on hpd_agreements_cache(company_id, filial_id, begin_date, end_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding hln_training_current_subjects
----------------------------------------------------------------------------------------------------
create table hln_training_current_subjects(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  training_id                     number(20) not null,
  subject_id                      number(20) not null,
  constraint hln_training_current_subjects_pk primary key (company_id, filial_id, training_id, subject_id) using index tablespace GWS_INDEX,
  constraint hln_training_current_subjects_f1 foreign key (company_id, filial_id, training_id) references hln_trainings(company_id, filial_id, training_id) on delete cascade,
  constraint hln_training_current_subjects_f2 foreign key (company_id, filial_id, subject_id) references hln_training_subjects(company_id, filial_id, subject_id)
) tablespace GWS_DATA;

create index hln_training_current_subjects_i1 on hln_training_current_subjects(company_id, filial_id, subject_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding hpd_business_trip_regions
----------------------------------------------------------------------------------------------------
create table hpd_business_trip_regions(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timeoff_Id                      number(20) not null,
  region_id                       number(20) not null,
  order_no                        number(5)  not null,
  constraint hpd_business_trip_regions_pk primary key (company_id, filial_id, timeoff_id, region_id, order_no) using index tablespace GWS_INDEX,
  constraint hpd_business_trip_regions_f1 foreign key (company_id, filial_id, timeoff_Id) references hpd_business_trips(company_id, filial_id, timeoff_Id) on delete cascade,
  constraint hpd_business_trip_regions_f2 foreign key (company_id, region_id) references md_regions(company_id, region_id)
) tablespace GWS_DATA;

create index hpd_business_trip_regions_i1 on hpd_business_trip_regions(company_id, region_id) tablespace GWS_INDEX;

comment on column hpd_business_trip_regions.order_no is 'Order of regions on business trip';
