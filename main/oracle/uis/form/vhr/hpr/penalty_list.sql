set define off
prompt PATH /vhr/hpr/penalty_list
begin
uis.route('/vhr/hpr/penalty_list$delete','Ui_Vhr306.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/penalty_list:common_penalties','Ui_Vhr306.Query_Common_Penalty',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/penalty_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpr/penalty_list:standart_penalties','Ui_Vhr306.Query_Standart_Penalty',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpr/penalty_list','vhr306');
uis.form('/vhr/hpr/penalty_list','/vhr/hpr/penalty_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hpr/penalty_list','add','F','/vhr/hpr/penalty+add','S','O');
uis.action('/vhr/hpr/penalty_list','copy','F','/vhr/hpr/penalty+copy','S','O');
uis.action('/vhr/hpr/penalty_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/penalty_list','edit','F','/vhr/hpr/penalty+edit','S','O');


uis.ready('/vhr/hpr/penalty_list','.add.copy.delete.edit.model.');

commit;
end;
/
