prompt migr from 05.01.2022
----------------------------------------------------------------------------------------------------
prompt drop hpr tables
----------------------------------------------------------------------------------------------------
-- if 12_2021(29_d_sh_p1) didn't raise error
-- then this script colud be run
-- before dropping, Lock_Interval_Error_Logs must be analysed
drop table lock_interval_error_logs;

-- drop structures and delete data
----------------------------------------------------------------------------------------------------
drop table hpr_timebook_parts;
drop table hpr_book_oper_indicators;
drop table hpr_book_oper_locks;

alter table hpr_timebooks drop column status;
alter table hpr_book_operations drop (part_begin, part_end);

----------------------------------------------------------------------------------------------------
drop table Hpd_Page_Indicators_Old;
drop table Hpd_Line_Trans_Indicators_Old;

