set define off
prompt PATH /vhr/hln/question_type_list
begin
uis.route('/vhr/hln/question_type_list$delete','Ui_Vhr211.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/question_type_list:model','Ui_Vhr211.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/question_type_list:table','Ui_Vhr211.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/question_type_list','vhr211');
uis.form('/vhr/hln/question_type_list','/vhr/hln/question_type_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/question_type_list','add','F','/vhr/hln/question_type+add','S','O');
uis.action('/vhr/hln/question_type_list','close','F',null,null,'A');
uis.action('/vhr/hln/question_type_list','delete','F',null,null,'A');
uis.action('/vhr/hln/question_type_list','edit','F','/vhr/hln/question_type+edit','S','O');
uis.action('/vhr/hln/question_type_list','view','F','/vhr/hln/view/question_type_view','S','O');


uis.ready('/vhr/hln/question_type_list','.add.close.delete.edit.model.view.');

commit;
end;
/
