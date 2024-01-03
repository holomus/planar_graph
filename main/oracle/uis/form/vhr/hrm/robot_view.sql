set define off
prompt PATH /vhr/hrm/robot_view
begin
uis.route('/vhr/hrm/robot_view:extra_robot_audit','Ui_Vhr663.Query_Extra_Robot_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:main_robot_audit','Ui_Vhr663.Query_Main_Robot_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:model','Ui_Vhr663.Model','M','M','A','Y',null,null,null,'S');
uis.route('/vhr/hrm/robot_view:robot_divisions_audit','Ui_Vhr663.Query_Robot_Divisions_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:robot_hidden_salary_job_groups_audit','Ui_Vhr663.Query_Robot_Job_Groups_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:robot_indicators_audit','Ui_Vhr663.Query_Robot_Indicators_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:robot_oper_types_audit','Ui_Vhr663.Query_Robot_Oper_Types_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:robot_roles_audit','Ui_Vhr663.Query_Robot_Roles_Audits','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/robot_view:robot_vacation_limit_audit','Ui_Vhr663.Query_Robot_Vacation_Limit_Audits','M','Q','A',null,null,null,null,'S');

uis.path('/vhr/hrm/robot_view','vhr663');
uis.form('/vhr/hrm/robot_view','/vhr/hrm/robot_view','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hrm/robot_view','audit','F',null,null,'G');
uis.action('/vhr/hrm/robot_view','audit_details','F','/vhr/hrm/robot_audit_details','D','O');
uis.action('/vhr/hrm/robot_view','edit','F','/vhr/hrm/robot+edit','S','O');


uis.ready('/vhr/hrm/robot_view','.audit.audit_details.edit.model.');

commit;
end;
/
