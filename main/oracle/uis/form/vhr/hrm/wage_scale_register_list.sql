set define off
prompt PATH /vhr/hrm/wage_scale_register_list
begin
uis.route('/vhr/hrm/wage_scale_register_list$delete','Ui_Vhr255.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register_list$post','Ui_Vhr255.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register_list$unpost','Ui_Vhr255.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/wage_scale_register_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hrm/wage_scale_register_list:table','Ui_Vhr255.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrm/wage_scale_register_list','vhr255');
uis.form('/vhr/hrm/wage_scale_register_list','/vhr/hrm/wage_scale_register_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrm/wage_scale_register_list','add','F','/vhr/hrm/wage_scale_register+add','S','O');
uis.action('/vhr/hrm/wage_scale_register_list','delete','F',null,null,'A');
uis.action('/vhr/hrm/wage_scale_register_list','edit','F','/vhr/hrm/wage_scale_register+edit','S','O');
uis.action('/vhr/hrm/wage_scale_register_list','post','F',null,null,'A');
uis.action('/vhr/hrm/wage_scale_register_list','unpost','F',null,null,'A');
uis.action('/vhr/hrm/wage_scale_register_list','view','F','/vhr/hrm/wage_scale_register_view','S','O');


uis.ready('/vhr/hrm/wage_scale_register_list','.add.delete.edit.model.post.unpost.view.');

commit;
end;
/
