prompt increment_permit and note column added
----------------------------------------------------------------------------------------------------
alter table htm_recommended_rank_staffs add increment_permit varchar2(1);
alter table htm_recommended_rank_staffs add note varchar2(300 char);
