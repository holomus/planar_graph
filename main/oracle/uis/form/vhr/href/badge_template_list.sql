set define off
prompt PATH /vhr/href/badge_template_list
begin
uis.route('/vhr/href/badge_template_list$delete','Ui_Vhr453.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/badge_template_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/badge_template_list:save','Ui_Vhr453.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/href/badge_template_list:table','Ui_Vhr453.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/badge_template_list','vhr453');
uis.form('/vhr/href/badge_template_list','/vhr/href/badge_template_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/href/badge_template_list','add','A',null,null,'G');
uis.action('/vhr/href/badge_template_list','delete','A',null,null,'A');
uis.action('/vhr/href/badge_template_list','edit','A',null,null,'G');


uis.ready('/vhr/href/badge_template_list','.add.delete.edit.model.');

commit;
end;
/
