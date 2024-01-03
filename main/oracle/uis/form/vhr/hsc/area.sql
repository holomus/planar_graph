set define off
prompt PATH /vhr/hsc/area
begin
uis.route('/vhr/hsc/area+add:code_is_unique','Ui_Vhr533.Code_Is_Unique',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/area+add:drivers','Ui_Vhr533.Query_Drivers',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/area+add:model','Ui_Vhr533.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/area+add:name_is_unique','Ui_Vhr533.Name_Is_Unique','M','V','A',null,null,null,null,null);
uis.route('/vhr/hsc/area+add:save','Ui_Vhr533.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hsc/area+edit:code_is_unique','Ui_Vhr533.Code_Is_Unique',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/area+edit:drivers','Ui_Vhr533.Query_Drivers',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/area+edit:model','Ui_Vhr533.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/area+edit:name_is_unique','Ui_Vhr533.Name_Is_Unique','M','V','A',null,null,null,null,null);
uis.route('/vhr/hsc/area+edit:save','Ui_Vhr533.Edit','M','M','A',null,null,null,null,null);

uis.path('/vhr/hsc/area','vhr533');
uis.form('/vhr/hsc/area+add','/vhr/hsc/area','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hsc/area+edit','/vhr/hsc/area','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hsc/area+add','select_driver','F','/vhr/hsc/driver_list','D','O');
uis.action('/vhr/hsc/area+edit','select_driver','F','/vhr/hsc/driver_list','D','O');


uis.ready('/vhr/hsc/area+add','.model.select_driver.');
uis.ready('/vhr/hsc/area+edit','.model.select_driver.');

commit;
end;
/
