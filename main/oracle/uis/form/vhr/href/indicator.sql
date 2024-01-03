set define off
prompt PATH /vhr/href/indicator
begin
uis.route('/vhr/href/indicator+add:identifier_is_unique','Ui_Vhr58.Identifier_Is_Unique','M','V','A',null,null,null,null,null);
uis.route('/vhr/href/indicator+add:indicator_groups','Ui_Vhr58.Query_Indicator_Groups',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/href/indicator+add:model','Ui_Vhr58.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/href/indicator+add:save','Ui_Vhr58.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/indicator+edit:identifier_is_unique','Ui_Vhr58.Identifier_Is_Unique','M','V','A',null,null,null,null,null);
uis.route('/vhr/href/indicator+edit:indicator_groups','Ui_Vhr58.Query_Indicator_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/indicator+edit:model','Ui_Vhr58.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/href/indicator+edit:save','Ui_Vhr58.Edit','M','M','A',null,null,null,null,null);

uis.path('/vhr/href/indicator','vhr58');
uis.form('/vhr/href/indicator+add','/vhr/href/indicator','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/href/indicator+edit','/vhr/href/indicator','F','A','F','H','M','N',null,'N',null);





uis.ready('/vhr/href/indicator+add','.model.');
uis.ready('/vhr/href/indicator+edit','.model.');

commit;
end;
/
