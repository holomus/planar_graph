set define off
prompt PATH /vhr/hsc/driver_list
begin
uis.route('/vhr/hsc/driver_list$delete','Ui_Vhr489.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/driver_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hsc/driver_list:table','Ui_Vhr489.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hsc/driver_list','vhr489');
uis.form('/vhr/hsc/driver_list','/vhr/hsc/driver_list','F','A','F','HM','M','N',null,null);



uis.action('/vhr/hsc/driver_list','add','F','/vhr/hsc/driver+add','S','O');
uis.action('/vhr/hsc/driver_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/driver_list','edit','F','/vhr/hsc/driver+edit','S','O');


uis.ready('/vhr/hsc/driver_list','.add.delete.edit.model.');

commit;
end;
/
