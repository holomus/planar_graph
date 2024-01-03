set define off
prompt PATH /vhr/hpd/transfer_list
begin
uis.route('/vhr/hpd/transfer_list:model','Ui_Vhr608.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/transfer_list:table','Ui_Vhr608.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/transfer_list','vhr608');
uis.form('/vhr/hpd/transfer_list','/vhr/hpd/transfer_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/transfer_list','add','F','/vhr/hpd/transfer+add','S','O');
uis.action('/vhr/hpd/transfer_list','edit','F','/vhr/hpd/transfer+edit','S','O');
uis.action('/vhr/hpd/transfer_list','multiple_add','F','/vhr/hpd/transfer+multiple_add','S','O');
uis.action('/vhr/hpd/transfer_list','multiple_edit','F','/vhr/hpd/transfer+multiple_edit','S','O');
uis.action('/vhr/hpd/transfer_list','view','F','/vhr/hpd/view/transfer_view','S','O');


uis.ready('/vhr/hpd/transfer_list','.add.edit.model.multiple_add.multiple_edit.view.');

commit;
end;
/
