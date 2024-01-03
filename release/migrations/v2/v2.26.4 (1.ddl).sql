prompt adding hsc_area_drivers
----------------------------------------------------------------------------------------------------
alter table hsc_areas add c_drivers_exist varchar2(1);

----------------------------------------------------------------------------------------------------
create table hsc_area_drivers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  area_id                         number(20) not null,
  driver_id                       number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint hsc_area_drivers_pk primary key (company_id, filial_id, area_id, driver_id) using index tablespace GWS_INDEX,
  constraint hsc_area_drivers_f1 foreign key (company_id, filial_id, area_id) references hsc_areas(company_id, filial_id, area_id) on delete cascade,
  constraint hsc_area_drivers_f2 foreign key (company_id, filial_id, driver_id) references hsc_drivers(company_id, filial_id, driver_id) on delete cascade,
  constraint hsc_area_drivers_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index hsc_area_drivers_i1 on hsc_area_drivers(company_id, filial_id, driver_id) tablespace GWS_INDEX;
create index hsc_area_drivers_i2 on hsc_area_drivers(company_id, created_by) tablespace GWS_INDEX;

exec fazo_z.run('hsc_areas');
exec fazo_z.run('hsc_area_drivers');
