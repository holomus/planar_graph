set define off
prompt PATH /vhr/hln/assess_list
begin
uis.route('/vhr/hln/assess_list:assess','Ui_Vhr240.Assess_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/assess_list:model','Ui_Vhr240.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hln/assess_list','vhr240');
uis.form('/vhr/hln/assess_list','/vhr/hln/assess_list','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hln/assess_list','.model.');

commit;
end;
/
