set define off
prompt PATH /vhr/hsc/process_action
begin
uis.route('/vhr/hsc/process_action+add:code_is_unique','Ui_Vhr492.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process_action+add:model','Ui_Vhr492.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/process_action+add:name_is_unique','Ui_Vhr492.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process_action+add:save','Ui_Vhr492.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/process_action+edit:code_is_unique','Ui_Vhr492.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process_action+edit:model','Ui_Vhr492.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/process_action+edit:name_is_unique','Ui_Vhr492.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process_action+edit:save','Ui_Vhr492.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hsc/process_action','vhr492');
uis.form('/vhr/hsc/process_action+add','/vhr/hsc/process_action','F','A','F','H','M','N',null,null);
uis.form('/vhr/hsc/process_action+edit','/vhr/hsc/process_action','A','A','F','H','M','N',null,null);





uis.ready('/vhr/hsc/process_action+add','.model.');
uis.ready('/vhr/hsc/process_action+edit','..');

commit;
end;
/
