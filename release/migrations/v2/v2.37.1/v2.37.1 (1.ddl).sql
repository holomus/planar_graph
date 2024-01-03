prompt adding index to Materialized View
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------  
create index Htt_Employee_Monthly_Attendances_Mv_i1 on Htt_Employee_Monthly_Attendances_Mv(company_id, filial_id, staff_id, month);
