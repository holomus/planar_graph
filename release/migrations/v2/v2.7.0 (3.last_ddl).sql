prompt migr from 23.09.2022 (3.last_ddl)
----------------------------------------------------------------------------------------------------
prompt drop staffing and position table and sequences
----------------------------------------------------------------------------------------------------
drop table hrm_pos_registers;
drop table hrm_staff_indicators;
drop table hrm_staff_oper_types;
drop table hrm_staff_positions;
drop table hrm_staffings;
drop table hrm_pos_indicators;
drop table hrm_pos_oper_types;
drop table hrm_positions;

drop sequence hrm_staff_positions_sq;
drop sequence hrm_staffings_sq;
drop sequence hrm_positions_sq;

----------------------------------------------------------------------------------------------------
prompt drop unneccesary packages
----------------------------------------------------------------------------------------------------
drop package ui_vhr65;
drop package ui_vhr66;
drop package ui_vhr67;
drop package ui_vhr68;
drop package ui_vhr115;
drop package ui_vhr127;

exec fazo_z.run('hrm_positions');
