set define off
prompt PATH /vhr/htt/terminal_model
begin
uis.route('/vhr/htt/terminal_model+edit:model','Ui_Vhr226.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/terminal_model+edit:save','Ui_Vhr226.Edit','M',null,'A',null,null,null,null);

uis.path('/vhr/htt/terminal_model','vhr226');
uis.form('/vhr/htt/terminal_model+edit','/vhr/htt/terminal_model','H','A','F','H','M','Y',null,null);






uis.ready('/vhr/htt/terminal_model+edit','.model.');

commit;
end;
/
