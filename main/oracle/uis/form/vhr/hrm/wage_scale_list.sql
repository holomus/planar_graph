set define off
prompt PATH /vhr/hrm/wage_scale_list
begin
uis.route('/vhr/hrm/wage_scale_list$delete','Ui_Vhr254.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/wage_scale_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,null);
uis.route('/vhr/hrm/wage_scale_list:table','Ui_Vhr254.Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/wage_scale_list','vhr254');
uis.form('/vhr/hrm/wage_scale_list','/vhr/hrm/wage_scale_list','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hrm/wage_scale_list','add','F','/vhr/hrm/wage_scale+add','S','O');
uis.action('/vhr/hrm/wage_scale_list','delete','F',null,null,'A');
uis.action('/vhr/hrm/wage_scale_list','edit','F','/vhr/hrm/wage_scale+edit','S','O');
uis.action('/vhr/hrm/wage_scale_list','info','F','/vhr/hrm/wage_scale_register_view','S','O');
uis.action('/vhr/hrm/wage_scale_list','list','F','/vhr/hrm/wage_scale_register_list','S','O');

uis.form_sibling('vhr','/vhr/hrm/wage_scale_list','/vhr/hrm/wage_scale_register_list',1);

uis.ready('/vhr/hrm/wage_scale_list','.add.delete.edit.info.list.model.');

commit;
end;
/
