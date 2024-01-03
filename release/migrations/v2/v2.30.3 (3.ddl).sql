prompt increment_permit and note column added
----------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_staffs modify increment_permit not null;
alter table htm_recommended_rank_staffs add constraint htm_recommended_rank_staffs_c3 check (increment_permit in ('Y', 'N'));

exec fazo_z.run('htm_recommended_rank_staffs');
