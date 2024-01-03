prompt adding event source type
----------------------------------------------------------------------------------------------------
alter table hac_hik_ex_events drop constraint hac_hik_ex_events_c1;
alter table hac_hik_ex_events add constraint hac_hik_ex_events_c1 check(event_type in ('N', 'M', 'J'));

comment on column hac_hik_ex_events.event_type  is 'N - received from (N)otifications, M - (M)anually retrieved, J - loaded by (J)ob';

exec fazo_z.run('hac_hik_ex_events');
