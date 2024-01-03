prompt migr from 26.11.2022
----------------------------------------------------------------------------------------------------  
prompt add modified id for htt_requests, htt_request_kinds, htt_plan_changes, href_nationalities
----------------------------------------------------------------------------------------------------
alter table htt_requests add modified_id number(20); 
alter table htt_request_kinds add modified_id number(20); 
alter table htt_plan_changes add modified_id number(20);
alter table href_nationalities add modified_id number(20);

----------------------------------------------------------------------------------------------------  
update Htt_Requests
   set Modified_Id = Biruni_Modified_Sq.Nextval;
commit;

update Htt_Request_Kinds
   set Modified_id = Biruni_Modified_Sq.Nextval;
commit;

update Htt_Plan_Changes
   set Modified_id = Biruni_Modified_Sq.Nextval;
commit;

update Href_Nationalities
   set Modified_id = Biruni_Modified_Sq.Nextval;
commit;

----------------------------------------------------------------------------------------------------
alter table htt_requests add constraint htt_requests_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

alter index htt_request_kinds_u2 rename to htt_request_kinds_u3;
alter table htt_request_kinds add constraint htt_request_kinds_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

alter table htt_plan_changes add constraint htt_plan_changes_u2 unique (company_id, filial_id, modified_id) using index tablespace GWS_INDEX;

alter index href_nationalities_u3 rename to href_nationalities_u4;
alter index href_nationalities_u2 rename to href_nationalities_u3;
alter table href_nationalities add constraint href_nationalities_u2 unique (company_id, modified_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------      
alter table htt_requests modify modified_id number(20) not null;
alter table htt_request_kinds modify modified_id number(20) not null;
alter table htt_plan_changes modify modified_id number(20) not null;
alter table href_nationalities modify modified_id number(20) not null;

----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_requests');
exec fazo_z.run('htt_request_kinds');
exec fazo_z.run('htt_plan_changes');
exec fazo_z.Run('href_nationalities');

----------------------------------------------------------------------------------------------------
prompt add check to pcode for some tables
----------------------------------------------------------------------------------------------------
prompt href_document_types
alter table href_document_types add constraint href_document_types_c4 check (decode(trim(pcode), pcode, 1, 0) = 1);
create unique index href_document_types_u4 on href_document_types(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;
drop index href_document_types_i1;
alter index href_document_types_i2 rename to href_document_types_i1;
alter index href_document_types_i3 rename to href_document_types_i2;

prompt href_indicators
alter table href_indicators add constraint href_indicators_c6 check (decode(trim(pcode), pcode, 1, 0) = 1);
drop index href_indicators_i3;
create unique index href_indicators_u4 on href_indicators(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

prompt hln_question_types
alter table hln_question_types add constraint hln_question_types_c4 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt hpr_oper_groups
alter table hpr_oper_groups add constraint hpr_oper_groups_c5 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt hpr_oper_types
alter table hpr_oper_types add constraint hpr_oper_types_c3 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt hpr_book_types
alter table hpr_book_types add constraint hpr_book_types_c2 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt htt_device_types
alter table htt_device_types add constraint htt_device_types_c3 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt htt_time_kinds
alter table htt_time_kinds add constraint htt_time_kinds_c9 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt htt_request_kinds
alter table htt_request_kinds add constraint htt_request_kinds_c12 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt htt_calendars
alter table htt_calendars add constraint htt_calendars_c2 check (decode(trim(pcode), pcode, 1, 0) = 1);

prompt htt_terminal_models
alter table htt_terminal_models add constraint htt_terminal_models_c6 check (decode(trim(pcode), pcode, 1, 0) = 1);

----------------------------------------------------------------------------------------------------
prompt remove unnecessary coulmns in href_person detail
----------------------------------------------------------------------------------------------------
alter table href_person_details drop column scientific_works_exist;
alter table href_person_details drop column inventions_exist;

alter table href_person_details drop constraint href_person_details_c5;
alter table href_person_details drop constraint href_person_details_c6;

alter table href_person_details add constraint href_person_details_c3 check (key_person in ('Y', 'N'));
alter table href_person_details add constraint href_person_details_c4 check (access_all_employees in ('Y', 'N'));

----------------------------------------------------------------------------------------------------
prompt drop unnecessary tables and sequences
----------------------------------------------------------------------------------------------------
drop table href_person_professions;
drop sequence href_person_professions_sq;

drop table href_professions;
drop sequence href_professions_sq;

drop table Href_Person_Acad_Title_Files;

drop table href_person_acad_titles;
drop sequence href_person_acad_titles_sq;

drop table href_person_specialty_files;

drop table href_acad_titles;
drop sequence href_acad_titles_sq;

drop table href_person_specialties;
drop sequence href_person_specialties_sq;

drop table href_person_acad_degree_files;

drop table href_person_acad_degrees;
drop sequence href_person_acad_degrees_sq;

drop table href_acad_degrees;
drop sequence href_acad_degrees_sq;
