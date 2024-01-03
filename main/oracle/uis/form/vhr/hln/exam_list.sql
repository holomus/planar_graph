set define off
prompt PATH /vhr/hln/exam_list
begin
uis.route('/vhr/hln/exam_list$delete','Ui_Vhr215.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/exam_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/exam_list:table','Ui_Vhr215.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hln/exam_list','vhr215');
uis.form('/vhr/hln/exam_list','/vhr/hln/exam_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/exam_list','add','F','/vhr/hln/exam+add','S','O');
uis.action('/vhr/hln/exam_list','delete','F',null,null,'A');
uis.action('/vhr/hln/exam_list','edit','F','/vhr/hln/exam+edit','S','O');


uis.ready('/vhr/hln/exam_list','.add.delete.edit.model.');

commit;
end;
/
