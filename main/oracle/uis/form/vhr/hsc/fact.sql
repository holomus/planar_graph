set define off
prompt PATH /vhr/hsc/fact
begin
uis.route('/vhr/hsc/fact+add:areas','Ui_Vhr539.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact+add:drivers','Ui_Vhr539.Query_Drivers',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact+add:model','Ui_Vhr539.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/fact+add:objects','Ui_Vhr539.Query_Objects',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact+add:save','Ui_Vhr539.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/fact+edit:areas','Ui_Vhr539.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact+edit:drivers','Ui_Vhr539.Query_Drivers',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact+edit:model','Ui_Vhr539.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/fact+edit:objects','Ui_Vhr539.Query_Objects',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact+edit:save','Ui_Vhr539.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hsc/fact','vhr539');
uis.form('/vhr/hsc/fact+add','/vhr/hsc/fact','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hsc/fact+edit','/vhr/hsc/fact','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hsc/fact+add','select_area','F','/vhr/hsc/area_list','D','O');
uis.action('/vhr/hsc/fact+add','select_driver','F','/vhr/hsc/driver_list','D','O');
uis.action('/vhr/hsc/fact+edit','select_area','F','/vhr/hsc/area_list','S','O');
uis.action('/vhr/hsc/fact+edit','select_driver','F','/vhr/hsc/driver_list','S','O');


uis.ready('/vhr/hsc/fact+add','.model.select_area.select_driver.');
uis.ready('/vhr/hsc/fact+edit','.model.select_area.select_driver.');

commit;
end;
/
