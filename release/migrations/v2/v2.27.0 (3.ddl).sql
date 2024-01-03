prompt dropping subject_id from trainings
----------------------------------------------------------------------------------------------------
-- drop subject_id column from hln_trainings table
---------------------------------------------------------------------------------------------------- 
alter table hln_trainings drop constraint hln_trainings_f2;
alter table hln_trainings drop column subject_id;

---------------------------------------------------------------------------------------------------- 
-- rename other foreign key and indexes
---------------------------------------------------------------------------------------------------- 
alter table hln_trainings rename constraint hln_trainings_f3 to hln_trainings_f2; 
alter table hln_trainings rename constraint hln_trainings_f4 to hln_trainings_f3;
alter index hln_trainings_i3 rename to hln_trainings_i2;
alter index hln_trainings_i4 rename to hln_trainings_i3;

----------------------------------------------------------------------------------------------------
prompt dropping region_id from business trips
----------------------------------------------------------------------------------------------------
-- drop region_id column from hpd_business_trips table
---------------------------------------------------------------------------------------------------- 
alter table hpd_business_trips drop constraint hpd_business_trips_f2;
alter table hpd_business_trips drop column region_id;

---------------------------------------------------------------------------------------------------- 
-- rename other foreign key and make nullable person_id
---------------------------------------------------------------------------------------------------- 
alter table hpd_business_trips rename constraint hpd_business_trips_f3 to hpd_business_trips_f2;
alter table hpd_business_trips rename constraint hpd_business_trips_f4 to hpd_business_trips_f3;
alter table hpd_business_trips modify person_id null;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hln_training_current_subjects');
exec fazo_z.run('hln_trainings');
exec fazo_z.run('hpd_business_trip_regions');
exec fazo_z.run('hpd_business_trips');
