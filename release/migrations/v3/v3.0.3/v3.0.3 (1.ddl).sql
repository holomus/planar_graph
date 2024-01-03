prompt add company_id to OLX Data Mapping Tables
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
alter table hrec_olx_job_categories add company_id number(20);
alter table hrec_olx_attributes add company_id number(20);
alter table hrec_olx_attribute_values add company_id number(20);
alter table hrec_olx_regions add company_id number(20);
alter table hrec_olx_cities add company_id number(20);
alter table hrec_olx_districts add company_id number(20);

alter table hrec_olx_attributes drop constraint hrec_olx_attributes_f1;

alter table hrec_olx_job_categories drop constraint hrec_olx_job_categories_pk;
---------------------------------------------------------------------------------------------------- 
alter table hrec_olx_attribute_values drop constraint hrec_olx_attribute_values_f1;
alter table hrec_olx_published_vacancy_attributes drop constraint hrec_olx_published_vacancy_attributes_f2;

alter table hrec_olx_attributes drop constraint hrec_olx_attributes_pk;

----------------------------------------------------------------------------------------------------
alter table hrec_olx_published_vacancy_attributes drop constraint hrec_olx_published_vacancy_attributes_f3;

alter table hrec_olx_attribute_values drop constraint hrec_olx_attribute_values_pk;

----------------------------------------------------------------------------------------------------
alter table hrec_olx_districts drop constraint hrec_olx_districts_f1;

alter table hrec_olx_integration_regions drop constraint hrec_olx_integration_regions_f2;

alter table hrec_olx_cities drop constraint hrec_olx_cities_pk;

alter table hrec_olx_cities drop constraint hrec_olx_cities_f1;

alter table hrec_olx_regions drop constraint hrec_olx_regions_pk;

drop index hrec_olx_cities_i1;

drop index hrec_olx_integration_regions_i1;

----------------------------------------------------------------------------------------------------
alter table hrec_olx_integration_regions drop constraint hrec_olx_integration_regions_f3;

alter table hrec_olx_districts drop constraint hrec_olx_districts_pk;

drop index hrec_olx_districts_i1;
drop index hrec_olx_integration_regions_i2;
