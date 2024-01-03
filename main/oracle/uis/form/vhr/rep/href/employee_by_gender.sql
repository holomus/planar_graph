set define off
prompt PATH /vhr/rep/href/employee_by_gender
begin
uis.route('/vhr/rep/href/employee_by_gender:edu_stages','Ui_Vhr291.Query_Edu_Stages',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/employee_by_gender:model','Ui_Vhr291.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/employee_by_gender:ranks','Ui_Vhr291.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/employee_by_gender:run','Ui_Vhr291.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/href/employee_by_gender','vhr291');
uis.form('/vhr/rep/href/employee_by_gender','/vhr/rep/href/employee_by_gender','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/href/employee_by_gender','select_edu_stage','F','/vhr/href/edu_stage_list','D','O');
uis.action('/vhr/rep/href/employee_by_gender','select_rank','F','/anor/mhr/rank_list','D','O');


uis.ready('/vhr/rep/href/employee_by_gender','.model.select_edu_stage.select_rank.');

commit;
end;
/
