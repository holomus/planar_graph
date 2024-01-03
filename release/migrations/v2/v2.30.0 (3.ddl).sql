prompt document changes
----------------------------------------------------------------------------------------------------
alter table href_document_types modify is_required not null;
alter table href_person_documents modify is_valid not null;
alter table href_person_documents modify status not null;

---------------------------------------------------------------------------------------------------- 
prompt adding hrm_divisions
----------------------------------------------------------------------------------------------------
alter table hrm_robots modify org_unit_id not null;
alter table hrm_settings modify advanced_org_structure not null;
alter table href_staffs modify org_unit_id not null;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_person_details');
exec fazo_z.run('href_document_types');
exec fazo_z.run('href_excluded_document_types');
exec fazo_z.run('href_person_documents');
exec fazo_z.run('hrm_divisions');
exec fazo_z.run('hrm_robots');
exec fazo_z.run('hrm_settings');
exec fazo_z.run('href_staffs');
exec fazo_z.run('htt_change_days');
