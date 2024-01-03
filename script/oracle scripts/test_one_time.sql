create sequence one_time_job_sq;
create table one_time_job(
  id          number(20) not null,
  worked_time date       not null,
  constraint one_time_job_pk primary key (id)
);

create table runner(
  id   number(20) not null  
);
