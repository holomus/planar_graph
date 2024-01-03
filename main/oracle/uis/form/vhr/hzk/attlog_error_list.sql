set define off
prompt PATH /vhr/hzk/attlog_error_list
begin
uis.route('/vhr/hzk/attlog_error_list$eval','Ui_Vhr282.Eval','M',null,'A',null,null,null,null);
uis.route('/vhr/hzk/attlog_error_list:model','Ui_Vhr282.Model',null,'M','S','Y',null,null,null);
uis.route('/vhr/hzk/attlog_error_list:table','Ui_Vhr282.Query','M','Q','S',null,null,null,null);

uis.path('/vhr/hzk/attlog_error_list','vhr282');
uis.form('/vhr/hzk/attlog_error_list','/vhr/hzk/attlog_error_list','A','S','F','H','M','N',null,'N');



uis.action('/vhr/hzk/attlog_error_list','eval','A',null,null,'A');


uis.ready('/vhr/hzk/attlog_error_list','.eval.model.');

commit;
end;
/
