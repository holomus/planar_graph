prompt fazo_z.run
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpr_wage_sheets');
exec fazo_z.run('hac_sync_persons');
exec fazo_z.run('htt_blocked_person_tracking');
exec fazo_z.run('hpr_credits');
