set define off
prompt PATH /vhr/hsc/area_list
begin
uis.route('/vhr/hsc/area_list$delete','Ui_Vhr532.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/area_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,null);
uis.route('/vhr/hsc/area_list:table','Ui_Vhr532.Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hsc/area_list','vhr532');
uis.form('/vhr/hsc/area_list','/vhr/hsc/area_list','F','A','F','HM','M','N',null,null,null);



uis.action('/vhr/hsc/area_list','add','F','/vhr/hsc/area+add','S','O');
uis.action('/vhr/hsc/area_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/area_list','edit','F','/vhr/hsc/area+edit','S','O');


uis.ready('/vhr/hsc/area_list','.add.delete.edit.model.');

commit;
end;
/
