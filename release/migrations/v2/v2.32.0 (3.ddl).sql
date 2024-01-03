prompt adding hh integration
----------------------------------------------------------------------------------------------------
alter table Hrec_Vacancies Modify name varchar2(100 char) not null;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hln_attestations');
exec fazo_z.run('hln_testings');

exec fazo_z.run('hpr_charges'); 
exec fazo_z.run('hpr_charge_documents');
exec fazo_z.run('hpr_charge_document_operations');

exec fazo_z.run('hes_oauth2');

exec fazo_z.Run('hrec_');
