set define off
prompt PATH /vhr/href/fte
begin
uis.route('/vhr/href/fte+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/fte+add:name_is_unique','Ui_Vhr311.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/fte+add:save','Ui_Vhr311.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/fte+edit:model','Ui_Vhr311.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/fte+edit:name_is_unique','Ui_Vhr311.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/fte+edit:save','Ui_Vhr311.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/fte','vhr311');
uis.form('/vhr/href/fte+add','/vhr/href/fte','A','A','F','H','M','N',null,null);
uis.form('/vhr/href/fte+edit','/vhr/href/fte','A','A','F','H','M','N',null,null);





uis.ready('/vhr/href/fte+edit','.model.');
uis.ready('/vhr/href/fte+add','.model.');

commit;
end;
/
