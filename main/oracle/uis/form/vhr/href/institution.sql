set define off
prompt PATH /vhr/href/institution
begin
uis.route('/vhr/href/institution+add:code_is_unique','Ui_Vhr8.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/institution+add:model','Ui_Vhr8.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/institution+add:name_is_unique','Ui_Vhr8.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/institution+add:save','Ui_Vhr8.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/institution+edit:code_is_unique','Ui_Vhr8.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/institution+edit:model','Ui_Vhr8.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/institution+edit:name_is_unique','Ui_Vhr8.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/institution+edit:save','Ui_Vhr8.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/institution','vhr8');
uis.form('/vhr/href/institution+add','/vhr/href/institution','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/institution+edit','/vhr/href/institution','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/institution+add','.model.');
uis.ready('/vhr/href/institution+edit','.model.');

commit;
end;
/
