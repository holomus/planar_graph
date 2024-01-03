prompt adding ignore tracks and images settings
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
---------------------------------------------------------------------------------------------------- 
update hac_hik_devices q
   set q.ignore_tracks = 'N';

update htt_devices q
   set q.ignore_images = 'N';

---------------------------------------------------------------------------------------------------- 
prompt adding allow_rank to robots
----------------------------------------------------------------------------------------------------
update hpd_page_robots q
   set q.allow_rank = 'Y'
 where q.rank_id is not null;

update hpd_page_robots q
   set q.allow_rank = 'N'
 where q.rank_id is null;
commit;
