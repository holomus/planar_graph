set define off
prompt PATH /vhr/hln/pass_testing
begin
uis.route('/vhr/hln/pass_testing:finish','Ui_Vhr222.Finish_Testing','M','M','A',null,null,null,null);
uis.route('/vhr/hln/pass_testing:mark','Ui_Vhr222.Mark_Question','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/pass_testing:model','Ui_Vhr222.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/pass_testing:send_answer','Ui_Vhr222.Send_Answer','M','M','A',null,null,null,null);

uis.path('/vhr/hln/pass_testing','vhr222');
uis.form('/vhr/hln/pass_testing','/vhr/hln/pass_testing','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/pass_testing','view_result','F','/vhr/hln/testing_view','R','O');


uis.ready('/vhr/hln/pass_testing','.model.view_result.');

commit;
end;
/
