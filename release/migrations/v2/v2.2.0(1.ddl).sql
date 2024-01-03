prompt migr from 15.07.2022 1.ddl
----------------------------------------------------------------------------------------------------
prompt new table htt_potential_outputs
---------------------------------------------------------------------------------------------------- 
create table htt_potential_outputs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,  
  employee_id                     number(20) not null,
  track_date                      date       not null,
  track_id                        number(20) not null,
  track_datetime                  date       not null,
  device_id                       number(20) not null,
  constraint htt_potential_outputs_pk primary key (company_id, filial_id, employee_id, track_date) using index tablespace GWS_INDEX,
  constraint htt_potential_outputs_u1 unique (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_potential_outputs_f1 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id) on delete cascade,
  constraint htt_potential_outputs_f2 foreign key (company_id, filial_id, track_id) references htt_tracks(company_id, filial_id, track_id) on delete cascade,
  constraint htt_potential_outputs_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_potential_outputs_c1 check (trunc(track_datetime) = track_date)
) tablespace GWS_INDEX;

comment on table htt_potential_outputs is 'Keeps check tracks that potentially will be converted to output tracks';

----------------------------------------------------------------------------------------------------
prompt htt_tracks table added previous_type
----------------------------------------------------------------------------------------------------
alter table htt_tracks add original_type varchar2(1);
alter table htt_tracks add constraint htt_tracks_c6 check (original_type in ('I', 'O', 'C'));

update htt_tracks p
   set p.original_type = p.track_type;
commit;

alter table htt_tracks modify original_type not null;

comment on column htt_tracks.original_type is '(I)nput, (O)utput, (C)heck. Keeps original track types when its changed';

----------------------------------------------------------------------------------------------------
prompt htt_devices table added autogen_inputs, autogen_outputs
----------------------------------------------------------------------------------------------------
alter table htt_devices add autogen_inputs varchar2(1);
alter table htt_devices add autogen_outputs varchar2(1);

alter table htt_devices add constraint htt_devices_c5 check (autogen_inputs in ('Y', 'N'));
alter table htt_devices add constraint htt_devices_c6 check (autogen_outputs in ('Y', 'N'));

update htt_devices
   set autogen_inputs = 'N',
       autogen_outputs = 'N';
commit;
       
alter table htt_devices modify autogen_inputs not null;
alter table htt_devices modify autogen_outputs not null;

----------------------------------------------------------------------------------------------------
prompt adding foreing key on devices in htt_tracks table
----------------------------------------------------------------------------------------------------
update Htt_Tracks t
   set t.Device_Id = null
 where t.Device_Id is not null
   and not exists (select 1
          from Htt_Devices Dv
         where Dv.Company_Id = t.Company_Id
           and Dv.Device_Id = t.Device_Id);
commit;           

alter table htt_tracks rename constraint htt_tracks_f5 to htt_tracks_f6;
alter table htt_tracks rename constraint htt_tracks_f4 to htt_tracks_f5;
alter table htt_tracks rename constraint htt_tracks_f3 to htt_tracks_f4;

alter table htt_tracks add constraint htt_tracks_f3 foreign key (company_id, device_id) references htt_devices(company_id, device_id);

alter index htt_tracks_i6 rename to htt_tracks_i7;
alter index htt_tracks_i5 rename to htt_tracks_i6;
alter index htt_tracks_i4 rename to htt_tracks_i5;
alter index htt_tracks_i3 rename to htt_tracks_i4;

create index htt_tracks_i3 on htt_tracks(company_id, device_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt href module tables small changes
----------------------------------------------------------------------------------------------------
alter table href_institutions add code varchar2(50);
alter table href_institutions add constraint href_institutions_c3 check (decode(trim(code), code, 1, 0) = 1);
create unique index href_institutions_u3 on href_institutions(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

alter table href_lang_levels add code varchar2(50);
alter table href_lang_levels add constraint href_lang_levels_c3 check (decode(trim(code), code, 1, 0) = 1);
create unique index href_lang_levels_u3 on href_lang_levels(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

alter table href_document_types add code varchar2(50);
alter table href_document_types add constraint href_document_types_c3 check (decode(trim(code), code, 1, 0) = 1);
create unique index href_document_types_u3 on href_document_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

alter table href_relation_degrees add code varchar2(50);
alter table href_relation_degrees add constraint href_relation_degrees_c3 check (decode(trim(code), code, 1, 0) = 1);
create unique index href_relation_degrees_u3 on href_relation_degrees(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

alter table href_marital_statuses add code varchar2(50);
alter table href_marital_statuses add constraint href_marital_statuses_c3 check (decode(trim(code), code, 1, 0) = 1);
create unique index href_marital_statuses_u3 on href_marital_statuses(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt hpd_journal_page_cache constraint name fix
----------------------------------------------------------------------------------------------------
alter table hpd_journal_page_cache drop constraint hpd_journal_staff_cache_pk;
alter table hpd_journal_page_cache add constraint hpd_journal_page_cache_pk primary key (company_id, filial_id, staff_id);

alter table hpd_journal_page_cache drop constraint hpd_journal_staff_cache_c1;
alter table hpd_journal_page_cache add constraint hpd_journal_page_cache_c1 check (company_id is null) deferrable initially deferred;

----------------------------------------------------------------------------------------------------
prompt learn module small changes
----------------------------------------------------------------------------------------------------
alter table hln_trainings modify address varchar2(300 char);
alter table hln_questions modify name varchar2(2000 char);
alter table hln_question_options modify name varchar2(1000 char);

----------------------------------------------------------------------------------------------------   
prompt hzk_attlog_errors added status
----------------------------------------------------------------------------------------------------
alter table hzk_attlog_errors add status varchar(1);
alter table hzk_attlog_errors add constraint hzk_attlog_errors_c1 check (status in ('N', 'D'));

update hzk_attlog_errors
   set status = 'N';
commit;

alter table hzk_attlog_errors modify status not null;

comment on column hzk_attlog_errors.status is '(N)ew, (D)one';

----------------------------------------------------------------------------------------------------   
prompt href_dismissal_reasons added reason_type
----------------------------------------------------------------------------------------------------
alter table href_dismissal_reasons add reason_type varchar(1);
alter table href_dismissal_reasons add constraint href_dismissal_reasons_c3 check (reason_type in ('P', 'N'));

update href_dismissal_reasons
   set reason_type = 'P';

commit;

alter table href_dismissal_reasons modify reason_type not null;

comment on column href_dismissal_reasons.reason_type is '(P)ositive, (N)egative';

----------------------------------------------------------------------------------------------------
prompt fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_potential_outputs');
exec fazo_z.run('htt_tracks');
exec fazo_z.run('htt_devices');

exec fazo_z.run('href_institutions');
exec fazo_z.run('href_lang_levels');
exec fazo_z.run('href_document_types');
exec fazo_z.run('href_relation_degrees');
exec fazo_z.run('href_marital_statuses');
exec fazo_z.run('href_dismissal_reasons');

exec fazo_z.run('hpd_journal_page_cache');

exec fazo_z.run('hzk_attlog_errors');

exec fazo_z.run('hln_trainings');
exec fazo_z.run('hln_questions');
exec fazo_z.run('hln_question_options');
