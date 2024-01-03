prompt migr from 23.08.2022 1.ddl
----------------------------------------------------------------------------------------------------
prompt add pcode in htt_request_kinds
----------------------------------------------------------------------------------------------------
alter table htt_request_kinds add pcode varchar2(20);

create unique index htt_request_kinds_u2 on htt_request_kinds(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------  
prompt making null schedule_id for href_staffs
----------------------------------------------------------------------------------------------------
alter table href_staffs modify schedule_id null;
alter table hpr_timebook_staffs modify schedule_id null;

----------------------------------------------------------------------------------------------------
prompt new sequence href_ftes_sq
---------------------------------------------------------------------------------------------------- 
create sequence href_ftes_sq;

----------------------------------------------------------------------------------------------------
prompt htt_person_photos added is_main column
----------------------------------------------------------------------------------------------------
alter table htt_person_photos add is_main varchar2(1);
alter table htt_person_photos add constraint htt_person_photos_c1 check (is_main in ('Y', 'N'));

update htt_person_photos
   set is_main = 'N';
commit;

alter table htt_person_photos modify is_main not null;

----------------------------------------------------------------------------------------------------
prompt htt_persons removed biophoto
----------------------------------------------------------------------------------------------------
alter table htt_persons drop constraint htt_persons_f2;
alter table htt_persons drop constraint htt_persons_f3;
alter table htt_persons drop constraint htt_persons_f4;

drop index htt_persons_i5;
drop index htt_persons_i6;
drop index htt_persons_i7;

alter table htt_persons add constraint htt_persons_f2 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table htt_persons add constraint htt_persons_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index htt_persons_i5 on htt_persons(company_id, created_by) tablespace GWS_INDEX;
create index htt_persons_i6 on htt_persons(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt merge biophoto_sha to htt_person_photos
----------------------------------------------------------------------------------------------------
insert into Htt_Person_Photos
  (Company_Id, Person_Id, Photo_Sha, Is_Main)
  select p.Company_Id, p.Person_Id, p.Biophoto_Sha as Photo_Sha, 'Y' as Is_Main
    from Htt_Persons p
   where p.Biophoto_Sha is not null;

----------------------------------------------------------------------------------------------------
prompt hpd_page_robots added fte_id
----------------------------------------------------------------------------------------------------
alter table hpd_page_robots add fte_id number(20);
alter table hpd_page_robots modify fte null;

alter table hpd_page_robots add constraint hpd_page_robots_f6 foreign key (company_id, fte_id) references href_ftes(company_id, fte_id);
alter table hpd_page_robots add constraint hpd_page_robots_c3 check (fte_id is not null or fte_id is null and fte is not null);

create index hpd_page_robots_i5 on hpd_page_robots(company_id, fte_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding fte_id to hpd_trans_robots
----------------------------------------------------------------------------------------------------
alter table hpd_trans_robots add fte_id number(20);

alter table hpd_trans_robots add constraint hpd_trans_robots_f6 foreign key (company_id, fte_id) references href_ftes(company_id, fte_id);

create index hpd_trans_robots_i5 on hpd_trans_robots(company_id, fte_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changing hper_staff_plans_i1 index
----------------------------------------------------------------------------------------------------
drop index hper_staff_plans_i1;
create index hper_staff_plans_i1 on hper_staff_plans(company_id, filial_id, staff_id, plan_date) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------        
prompt changing wage sheets
----------------------------------------------------------------------------------------------------
alter table Hpr_Wage_Sheets add Round_Value varchar2(5);

update Hpr_Wage_Sheets
   set Round_Value = '-0.0R';
   
alter table Hpr_Wage_Sheets modify Round_Value not null;

alter table hpr_sheet_parts add overtime_amount number(20,6);

update hpr_sheet_parts
   set overtime_amount = 0;
   
alter table hpr_sheet_parts modify overtime_amount not null;

alter table hpr_sheet_parts add accrual_amount as (wage_amount + overtime_amount);
alter table hpr_sheet_parts modify amount as (wage_amount + overtime_amount - (late_amount + early_amount + lack_amount));
 
alter table hpr_sheet_parts drop constraint hpr_sheet_parts_c2;
alter table hpr_sheet_parts add constraint hpr_sheet_parts_c2 check (monthly_amount >= 0 and plan_amount >= 0 
                                   and wage_amount >= 0 and overtime_amount >= 0 
                                   and late_amount >= 0 and early_amount >= 0 and lack_amount >= 0);

----------------------------------------------------------------------------------------------------
delete from Md_Paths p
 where p.Code in ('vhr282', 'vhr284');
commit;
 
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_request_kinds');
exec fazo_z.run('href_ftes');
exec fazo_z.run('htt_person_photos');
exec fazo_z.run('htt_persons');
exec fazo_z.run('hpd_page_robots');
exec fazo_z.run('hpd_trans_robots');
exec fazo_z.run('hpr_sheet_parts'); 
