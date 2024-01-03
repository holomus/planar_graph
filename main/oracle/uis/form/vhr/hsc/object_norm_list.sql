set define off
prompt PATH /vhr/hsc/object_norm_list
begin
uis.route('/vhr/hsc/object_norm_list$delete','Ui_Vhr494.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,null);
uis.route('/vhr/hsc/object_norm_list:objects','Ui_Vhr494.Query_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_list:table','Ui_Vhr494.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hsc/object_norm_list','vhr494');
uis.form('/vhr/hsc/object_norm_list','/vhr/hsc/object_norm_list','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hsc/object_norm_list','add','F','/vhr/hsc/object_norm+add','S','O');
uis.action('/vhr/hsc/object_norm_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/object_norm_list','edit','F','/vhr/hsc/object_norm+edit','S','O');
uis.action('/vhr/hsc/object_norm_list','import','F','/vhr/hsc/object_norm_import','D','O');


uis.ready('/vhr/hsc/object_norm_list','.add.delete.edit.import.model.');

commit;
end;
/
