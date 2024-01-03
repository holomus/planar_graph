set define off
prompt PATH /vhr/hln/testing_view
begin
uis.route('/vhr/hln/testing_view:answers','Ui_Vhr227.Query_Answer','M','Q','A',null,null,null,null);
uis.route('/vhr/hln/testing_view:model','Ui_Vhr227.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hln/testing_view','vhr227');
uis.form('/vhr/hln/testing_view','/vhr/hln/testing_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/testing_view','answers','F',null,null,'A');


uis.ready('/vhr/hln/testing_view','.answers.model.');

commit;
end;
/
