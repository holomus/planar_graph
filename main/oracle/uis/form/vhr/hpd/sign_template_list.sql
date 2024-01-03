set define off
prompt PATH /vhr/hpd/sign_template_list
begin
uis.route('/vhr/hpd/sign_template_list$delete','Ui_Vhr650.Del','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpd/sign_template_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/hpd/sign_template_list:table','Ui_Vhr650.Query',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/hpd/sign_template_list','vhr650');
uis.form('/vhr/hpd/sign_template_list','/vhr/hpd/sign_template_list','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hpd/sign_template_list','add','F','/vhr/hpd/sign_template+add','S','O');
uis.action('/vhr/hpd/sign_template_list','delete','F',null,null,'A');
uis.action('/vhr/hpd/sign_template_list','edit','F','/vhr/hpd/sign_template+edit','S','O');


uis.ready('/vhr/hpd/sign_template_list','.add.delete.edit.model.');

commit;
end;
/
