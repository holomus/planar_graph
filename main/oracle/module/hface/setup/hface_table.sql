prompt Face Recognition Table
prompt (c) 2023 Verifix HRM

----------------------------------------------------------------------------------------------------
create table hface_service_settings(
  code               varchar2(1)   not null,
  host               varchar2(150) not null,
  username           varchar2(150) not null,
  password           varchar2(150) not null,
  constraint hface_service_settings_pk primary key (code) using index tablespace GWS_INDEX,
  constraint hface_service_settings_c1 check (code='U')
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create table hface_photo_vectors (
  photo_sha          varchar2(64) not null,
  photo_vector       clob         not null,
  constraint hface_photo_vectors_pk primary key (photo_sha) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hface_calculated_photos(
  company_id         number(20)   not null,
  photo_sha          varchar2(64) not null,
  photo_id           number(20)   not null,
  constraint hface_calculated_photos_pk primary key (company_id, photo_sha) using index tablespace GWS_INDEX,
  constraint hface_calculated_photos_u1 unique (company_id, photo_id) using index tablespace GWS_INDEX,
  constraint hface_calculated_photos_f1 foreign key (photo_sha) references biruni_files(sha) on delete cascade
) tablespace GWS_DATA;

comment on column hface_calculated_photos.photo_id is 'Used for join';

----------------------------------------------------------------------------------------------------
create table hface_matched_photos(
  company_id         number(20)   not null,
  photo_sha          varchar2(64) not null,
  matched_sha        varchar2(64) not null,
  match_score        number       not null,
  constraint hface_matched_photos_pk primary key (company_id, photo_sha, matched_sha) using index tablespace GWS_INDEX,
  constraint hface_matched_photos_f1 foreign key (company_id, photo_sha) references hface_calculated_photos(company_id, photo_sha) on delete cascade,
  constraint hface_matched_photos_f2 foreign key (company_id, matched_sha) references hface_calculated_photos(company_id, photo_sha) on delete cascade
) tablespace GWS_DATA;

create index hface_matched_photos_i1 on hface_matched_photos(company_id, matched_sha) tablespace GWS_INDEX;
create index hface_matched_photos_i2 on hface_matched_photos(company_id, match_score) tablespace GWS_INDEX;
