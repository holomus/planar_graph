set define off
prompt PATH /vhr/hzk/command_list
begin
uis.route('/vhr/hzk/command_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hzk/command_list:table','Ui_Vhr284.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hzk/command_list','vhr284');
uis.form('/vhr/hzk/command_list','/vhr/hzk/command_list','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/hzk/command_list','.model.');

commit;
end;
/
