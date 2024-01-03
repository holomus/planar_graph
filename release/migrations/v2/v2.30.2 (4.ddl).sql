prompt htm recommended changes
----------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_documents drop column posted;
exec fazo_z.run('htm_recommended_rank_documents');
