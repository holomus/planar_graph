set define off
prompt PATH /vhr/hln/check_answers
begin
uis.route('/vhr/hln/check_answers:finish','Ui_Vhr228.Finish','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/check_answers:model','Ui_Vhr228.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hln/check_answers','vhr228');
uis.form('/vhr/hln/check_answers','/vhr/hln/check_answers','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hln/check_answers','.model.');

commit;
end;
/
