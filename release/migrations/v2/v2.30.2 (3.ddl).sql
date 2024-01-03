prompt htm recommended changes
----------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_documents drop constraint htm_recommended_rank_documents_c3;
alter table htm_recommended_rank_documents drop constraint htm_recommended_rank_documents_c4;

alter table htm_recommended_rank_documents modify status not null;
alter table htm_recommended_rank_documents add constraint htm_recommended_rank_documents_c3 check (status in ('N', 'W', 'A'));
alter table htm_recommended_rank_documents add constraint htm_recommended_rank_documents_c4 check (status <> 'A' and journal_id is null or journal_id is not null) deferrable initially deferred;

comment on column htm_recommended_rank_documents.status is '(N)ew, (W)aiting, (A)pproved';
