drop table migr_biruni_files;
create table migr_biruni_files(
  sha varchar2(64) not null primary key
);
insert into migr_biruni_files (sha)
select q.sha from md_company_files q where q.company_id = 840;

commit;
drop table migr_biruni_filespace;
create table migr_biruni_filespace(
  sha                             varchar2(64)                   not null,
  file_content                    blob                           not null,
  constraint migr_biruni_filespace_pk primary key (sha) using index tablespace GWS_FILE_INDEX
) tablespace GWS_FILE_DATA nologging;
