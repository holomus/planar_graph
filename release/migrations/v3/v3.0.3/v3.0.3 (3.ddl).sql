prompt add company_id to OLX Data Mapping Tables
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hrec_olx_job_categories modify company_id number(20) not null;

alter table hrec_olx_job_categories add constraint hrec_olx_job_categories_pk primary key (company_id, category_code) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hrec_olx_attributes modify company_id number(20) not null;

alter table hrec_olx_attributes add constraint hrec_olx_attributes_pk primary key (company_id, category_code, attribute_code) using index tablespace GWS_INDEX;
alter table hrec_olx_attributes add constraint hrec_olx_attributes_f1 foreign key (company_id, category_code) 
      references hrec_olx_job_categories(company_id, category_code) on delete cascade;

alter table hrec_olx_published_vacancy_attributes add constraint hrec_olx_published_vacancy_attributes_f2 foreign key (company_id, category_code, code) 
      references hrec_olx_attributes(company_id, category_code, attribute_code);
      
----------------------------------------------------------------------------------------------------
alter table hrec_olx_attribute_values modify company_id number(20) not null;

alter table hrec_olx_attribute_values add constraint hrec_olx_attribute_values_pk primary key (company_id, category_code, attribute_code, code) using index tablespace GWS_INDEX;
alter table hrec_olx_attribute_values add constraint hrec_olx_attribute_values_f1 foreign key (company_id, category_code, attribute_code) 
     references hrec_olx_attributes(company_id, category_code, attribute_code) on delete cascade;
     
alter table hrec_olx_published_vacancy_attributes add constraint hrec_olx_published_vacancy_attributes_f3 foreign key (company_id, category_code, code, value) 
      references hrec_olx_attribute_values(company_id, category_code, attribute_code, code);
      
----------------------------------------------------------------------------------------------------
alter table hrec_olx_regions modify company_id number(20) not null;

alter table hrec_olx_regions add constraint hrec_olx_regions_pk primary key (company_id, region_code) using index tablespace GWS_INDEX;
            
----------------------------------------------------------------------------------------------------
alter table hrec_olx_cities modify company_id number(20) not null;


alter table hrec_olx_cities add constraint hrec_olx_cities_pk primary key (company_id, city_code) using index tablespace GWS_INDEX;
alter table hrec_olx_cities add constraint hrec_olx_cities_f1 foreign key (company_id, region_code) references hrec_olx_regions(company_id, region_code) on delete cascade;

create index hrec_olx_cities_i1 on hrec_olx_cities(company_id, region_code) tablespace GWS_INDEX;

alter table hrec_olx_integration_regions add constraint hrec_olx_integration_regions_f2 foreign key (company_id, city_code) 
     references hrec_olx_cities(company_id, city_code) on delete cascade;

create index hrec_olx_integration_regions_i1 on hrec_olx_integration_regions(company_id, city_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hrec_olx_districts modify company_id number(20) not null;

alter table hrec_olx_districts add constraint hrec_olx_districts_pk primary key (company_id, district_code) using index tablespace GWS_INDEX;
alter table hrec_olx_districts add constraint hrec_olx_districts_f1 foreign key (company_id, city_code) references hrec_olx_cities(company_id, city_code) on delete cascade;

create index hrec_olx_districts_i1 on hrec_olx_districts(company_id, city_code) tablespace GWS_INDEX;

alter table hrec_olx_integration_regions add constraint hrec_olx_integration_regions_f3 foreign key (company_id, district_code) 
      references hrec_olx_districts(company_id, district_code) on delete cascade;

create index hrec_olx_integration_regions_i2 on hrec_olx_integration_regions(company_id, district_code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hrec_olx_job_categories');
exec fazo_z.run('hrec_olx_attributes');
exec fazo_z.run('hrec_olx_attribute_values');
exec fazo_z.run('hrec_olx_regions');
exec fazo_z.run('hrec_olx_cities');
exec fazo_z.run('hrec_olx_districts');
