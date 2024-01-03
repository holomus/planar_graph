prompt adding nighttime column to hpr_sheet_parts
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update hpr_sheet_parts q
   set q.nighttime_amount = 0;

----------------------------------------------------------------------------------------------------
prompt add for_recruitment column for hln_exams
----------------------------------------------------------------------------------------------------     
update hln_exams 
   set for_recruitment = 'N';
   
----------------------------------------------------------------------------------------------------
prompt adding modified_id to hrec_vacancies
----------------------------------------------------------------------------------------------------
update hrec_vacancies q
   set q.modified_id = biruni_modified_sq.nextval;
   
----------------------------------------------------------------------------------------------------
prompt adding hrm_seetings columns
----------------------------------------------------------------------------------------------------
update Hrm_Settings q
   set q.Keep_Salary         = q.Position_Check,
       q.Keep_Vacation_Limit = q.Position_Check,
       q.Keep_Schedule       = q.Position_Check,
       q.Keep_Rank           = q.Position_Check; 
       
----------------------------------------------------------------------------------------------------
prompt adding weights to schedule
----------------------------------------------------------------------------------------------------
update htt_schedules 
   set use_weights = 'N';
commit;
