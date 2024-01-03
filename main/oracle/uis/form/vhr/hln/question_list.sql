set define off
prompt PATH /vhr/hln/question_list
begin
uis.route('/vhr/hln/question_list$delete','Ui_Vhr212.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/question_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/question_list:table','Ui_Vhr212.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hln/question_list','vhr212');
uis.form('/vhr/hln/question_list','/vhr/hln/question_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/question_list','add','F','/vhr/hln/question+add','S','O');
uis.action('/vhr/hln/question_list','delete','F',null,null,'A');
uis.action('/vhr/hln/question_list','edit','F','/vhr/hln/question+edit','S','O');
uis.action('/vhr/hln/question_list','import','F','/vhr/hln/question_import','S','O');

uis.form_sibling('vhr','/vhr/hln/question_list','/vhr/hln/question_group_list',1);

uis.ready('/vhr/hln/question_list','.add.delete.edit.import.model.');

commit;
end;
/
