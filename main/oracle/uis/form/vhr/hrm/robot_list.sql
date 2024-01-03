set define off
prompt PATH /vhr/hrm/robot_list
begin
uis.route('/vhr/hrm/robot_list$delete','Ui_Vhr252.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot_list$fix_position_org_structure','Ui_Vhr252.Fix_Position_Org_Structure','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot_list$set_closed_date','Ui_Vhr252.Set_Closed_Date','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot_list:jobs','Ui_Vhr252.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot_list:model','Ui_Vhr252.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/robot_list:table','Ui_Vhr252.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/robot_list','vhr252');
uis.form('/vhr/hrm/robot_list','/vhr/hrm/robot_list','F','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mrf/robot_list','vhr','/vhr/hrm/robot_list');


uis.action('/vhr/hrm/robot_list','add','F','/vhr/hrm/robot+add','S','O');
uis.action('/vhr/hrm/robot_list','delete','F',null,null,'A');
uis.action('/vhr/hrm/robot_list','edit','F','/vhr/hrm/robot+edit','S','O');
uis.action('/vhr/hrm/robot_list','fix_position_org_structure','F',null,null,'A');
uis.action('/vhr/hrm/robot_list','robot_migr','F','/vhr/hrm/robot_migr','S','O');
uis.action('/vhr/hrm/robot_list','set_closed_date','F',null,null,'A');
uis.action('/vhr/hrm/robot_list','view','F','/vhr/hrm/robot_view','S','O');

uis.form_sibling('vhr','/vhr/hrm/robot_list','/vhr/rep/hrm/robot_structure',1);

uis.ready('/vhr/hrm/robot_list','.add.delete.edit.fix_position_org_structure.model.robot_migr.set_closed_date.view.');

commit;
end;
/
