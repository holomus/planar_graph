prompt drop hrec_vacancies columns
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------        
alter table hrec_vacancies drop column responsibilities;
alter table hrec_vacancies drop column requirements;
alter table hrec_vacancies drop column note;

----------------------------------------------------------------------------------------------------  
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------  
exec fazo_z.run('hrec_vacancies');
