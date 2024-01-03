alter table biruni_filespace_controller rename constraint biruni_filespace_controller_pk to biruni_filespace_controller_pk_old;
alter index biruni_filespace_controller_pk rename to biruni_filespace_controller_pk_old;
alter table biruni_filespace rename constraint biruni_filespace_pk to biruni_filespace_pk_old;
alter index biruni_filespace_pk rename to biruni_filespace_pk_old;

----------------------------------------------------------------------------------------------------
create table biruni_filespace_controller_new(
  sha                             varchar2(64)                   not null,
  constraint biruni_filespace_controller_pk primary key (sha) using index tablespace GWS_FILE_INDEX
) tablespace GWS_FILE_DATA nologging;

----------------------------------------------------------------------------------------------------
create table biruni_filespace_new(
  sha                             varchar2(64)                   not null,
  file_content                    blob                           not null,
  constraint biruni_filespace_pk primary key (sha) using index tablespace GWS_FILE_INDEX
) tablespace GWS_FILE_DATA nologging;

alter table biruni_filespace_controller rename to biruni_filespace_controller_old;
alter table biruni_filespace_controller_new rename to biruni_filespace_controller;
alter table biruni_filespace rename to biruni_filespace_old;
alter table biruni_filespace_new rename to biruni_filespace;

insert into Biruni_Filespace_Controller
  (Sha)
  select distinct Photo_Sha
    from Biruni_Easy_Report_Template_Photos;

insert into Biruni_Filespace
  (Sha, File_Content)
  select q.Sha, q.File_Content
    from Biruni_Filespace_Old q
    join Biruni_Filespace_Controller w
      on q.Sha = w.Sha;
commit;

alter table biruni_easy_report_template_photos drop constraint biruni_easy_report_template_photos_f2;
alter table biruni_easy_report_template_photos add constraint biruni_easy_report_template_photos_f2 foreign key (photo_sha) references biruni_filespace(sha);
