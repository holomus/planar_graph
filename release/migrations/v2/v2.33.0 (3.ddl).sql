prompt remove note column from hpr_book_operations
----------------------------------------------------------------------------------------------------  
alter table hpr_book_operations drop column note;

---------------------------------------------------------------------------------------------------- 
prompt adding multiple application transfers
----------------------------------------------------------------------------------------------------
alter table hpd_application_transfers add constraint hpd_application_transfers_pk primary key(company_id,
                                                                                              filial_id,
                                                                                              application_unit_id)
  using index tablespace GWS_INDEX;
  
alter table hpd_application_transfers add constraint hpd_application_transfers_u1 unique(application_unit_id)
  using index tablespace GWS_INDEX;
  
alter index hpd_application_transfers_i2 rename to hpd_application_transfers_i3;
alter index hpd_application_transfers_i1 rename to hpd_application_transfers_i2;

create index hpd_application_transfers_i1 on hpd_application_transfers(company_id,
                                                                       filial_id,
                                                                       application_id) tablespace GWS_INDEX;
                                                                       
----------------------------------------------------------------------------------------------------
prompt adding division manager_status
---------------------------------------------------------------------------------------------------- 
alter table hrm_divisions modify manager_status not null;             

create index href_person_details_i2 on href_person_details(company_id, npin) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('hpr_book_operations');
exec fazo_z.run('hpd_application_transfers');
exec fazo_z.run('hrm_divisions');
