exec fazo_z.Drop_Object_If_Exists('uit_htt_staff_divisions');
---------------------------------------------------------------------------------------------------- 
create global temporary table uit_htt_staff_divisions (
  company_id                   number(20) not null, 
  filial_id                    number(20) not null, 
  staff_id                     number(20) not null, 
  division_id                  number(20) not null,
  period_begin                 date       not null,
  period_end                   date       not null,
  constraint uit_htt_staff_divisions_pk primary key (company_id, filial_id, staff_id, division_id, period_begin)
);

comment on table uit_htt_staff_divisions is 'Periods where staff was in certain division';
