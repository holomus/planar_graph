set define off
prompt PATH /vhr/rep/href/employee_activeness
begin
uis.route('/vhr/rep/href/employee_activeness:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/href/employee_activeness:table','Ui_Vhr318.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/href/employee_activeness','vhr318');
uis.form('/vhr/rep/href/employee_activeness','/vhr/rep/href/employee_activeness','A','A','F','HM','M','Y',null,'N');



uis.action('/vhr/rep/href/employee_activeness','view','A','/core/md/company_view','S','O');


uis.ready('/vhr/rep/href/employee_activeness','.model.view.');

commit;
end;
/
