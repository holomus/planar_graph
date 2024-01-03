set define off
prompt PATH /vhr/hrm/wage_scale_register
begin
uis.route('/vhr/hrm/wage_scale_register+add:indicators','Ui_Vhr256.Query_Indicators',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+add:model','Ui_Vhr256.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+add:ranks','Ui_Vhr256.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+add:save','Ui_Vhr256.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+add:wage_scales','Ui_Vhr256.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+edit:indicators','Ui_Vhr256.Query_Indicators',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+edit:model','Ui_Vhr256.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+edit:ranks','Ui_Vhr256.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+edit:save','Ui_Vhr256.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register+edit:wage_scales','Ui_Vhr256.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/wage_scale_register','vhr256');
uis.form('/vhr/hrm/wage_scale_register+add','/vhr/hrm/wage_scale_register','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hrm/wage_scale_register+edit','/vhr/hrm/wage_scale_register','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hrm/wage_scale_register+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/wage_scale_register+add','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/wage_scale_register+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/wage_scale_register+add','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hrm/wage_scale_register+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/wage_scale_register+edit','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/wage_scale_register+edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/wage_scale_register+edit','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');


uis.ready('/vhr/hrm/wage_scale_register+add','.add_rank.add_wage_scale.model.select_rank.select_wage_scale.');
uis.ready('/vhr/hrm/wage_scale_register+edit','.add_rank.add_wage_scale.model.select_rank.select_wage_scale.');

commit;
end;
/
