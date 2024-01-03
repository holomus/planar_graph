set define off
prompt PATH /vhr/hln/question_group_list
begin
uis.route('/vhr/hln/question_group_list$delete','Ui_Vhr209.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/question_group_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/question_group_list:table','Ui_Vhr209.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hln/question_group_list','vhr209');
uis.form('/vhr/hln/question_group_list','/vhr/hln/question_group_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hln/question_group_list','add','F','/vhr/hln/question_group+add','S','O');
uis.action('/vhr/hln/question_group_list','delete','F',null,null,'A');
uis.action('/vhr/hln/question_group_list','edit','F','/vhr/hln/question_group+edit','S','O');
uis.action('/vhr/hln/question_group_list','types','F','/vhr/hln/question_type_list','S','O');
uis.action('/vhr/hln/question_group_list','view','F','/vhr/hln/view/question_group_view','S','O');


uis.ready('/vhr/hln/question_group_list','.add.delete.edit.model.types.view.');

commit;
end;
/
