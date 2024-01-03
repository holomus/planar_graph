prompt migr from 17.11.2022
----------------------------------------------------------------------------------------------------
alter table htt_tracks drop constraint htt_tracks_c2;
alter table htt_tracks add constraint htt_tracks_c2 check (mark_type in ('P', 'T', 'R', 'Q', 'F', 'M', 'A'));
comment on column htt_tracks.mark_type is '(P)assword, (T)ouch, (R)fid card, (Q)R code, (F)ace, (M)anual, (A)uto';
