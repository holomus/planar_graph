prompt document changes
----------------------------------------------------------------------------------------------------
update href_document_types set is_required = 'N';
update href_person_documents set is_valid = 'Y', status = 'N';
commit;

----------------------------------------------------------------------------------------------------
prompt adding hrm_divisions
----------------------------------------------------------------------------------------------------
update hrm_robots q
   set q.org_unit_id = (select p.division_id
                          from mrf_robots p
                         where p.company_id = q.company_id
                           and p.filial_id = q.filial_id
                           and p.robot_id = q.robot_id);
commit;

----------------------------------------------------------------------------------------------------
update hrm_settings q 
   set q.advanced_org_structure = 'N';
commit;

----------------------------------------------------------------------------------------------------
update href_staffs q
   set q.org_unit_id = q.division_id;
commit;

----------------------------------------------------------------------------------------------------
insert into hrm_divisions
  (company_id, filial_id, division_id, parent_department_id, is_department)
  select q.company_id, q.filial_id, q.division_id, q.parent_id, 'Y'
    from mhr_divisions q;
commit;
