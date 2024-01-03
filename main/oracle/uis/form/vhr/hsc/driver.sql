set define off
prompt PATH /vhr/hsc/driver
begin
uis.route('/vhr/hsc/driver+add:code_is_unique','Ui_Vhr490.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/driver+add:measures','Ui_Vhr490.Query_Measures',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/driver+add:model','Ui_Vhr490.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/driver+add:name_is_unique','Ui_Vhr490.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/driver+add:save','Ui_Vhr490.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/driver+edit:code_is_unique','Ui_Vhr490.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/driver+edit:model','Ui_Vhr490.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/driver+edit:name_is_unique','Ui_Vhr490.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/driver+edit:save','Ui_Vhr490.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hsc/driver','vhr490');
uis.form('/vhr/hsc/driver+add','/vhr/hsc/driver','F','A','F','H','M','N',null,null);
uis.form('/vhr/hsc/driver+edit','/vhr/hsc/driver','F','A','F','H','M','N',null,null);
uis.form('/vhr/hsc/driver+view','/vhr/hsc/driver','A','A','F','H','M','N',null,null);



uis.action('/vhr/hsc/driver+add','add_measure','F','/anor/mr/product/measure+add','D','O');
uis.action('/vhr/hsc/driver+add','select_measure','F','/anor/mr/product/measure_list','D','O');


uis.ready('/vhr/hsc/driver+add','.add_measure.model.select_measure.');
uis.ready('/vhr/hsc/driver+edit','.model.');

commit;
end;
/
