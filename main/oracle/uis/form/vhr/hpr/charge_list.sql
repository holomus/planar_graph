set define off
prompt PATH /vhr/hpr/charge_list
begin
uis.route('/vhr/hpr/charge_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpr/charge_list:table','Ui_Vhr177.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpr/charge_list','vhr177');
uis.form('/vhr/hpr/charge_list','/vhr/hpr/charge_list','F','A','F','H','M','N',null,'N');






uis.ready('/vhr/hpr/charge_list','.model.');

commit;
end;
/
