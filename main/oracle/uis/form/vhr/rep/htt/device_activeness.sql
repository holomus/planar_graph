set define off
prompt PATH /vhr/rep/htt/device_activeness
begin
uis.route('/vhr/rep/htt/device_activeness:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/htt/device_activeness:table','Ui_Vhr319.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/htt/device_activeness','vhr319');
uis.form('/vhr/rep/htt/device_activeness','/vhr/rep/htt/device_activeness','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/rep/htt/device_activeness','view','A','/core/md/company_view','S','O');


uis.ready('/vhr/rep/htt/device_activeness','.model.view.');

commit;
end;
/
