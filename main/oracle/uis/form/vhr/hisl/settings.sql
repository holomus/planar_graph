set define off
prompt PATH /vhr/hisl/settings
begin
uis.route('/vhr/hisl/settings$add_division','Ui_Vhr581.Division_Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hisl/settings$add_user','Ui_Vhr581.User_Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hisl/settings$remove_division','Ui_Vhr581.Division_Remove','M',null,'A',null,null,null,null);
uis.route('/vhr/hisl/settings$remove_user','Ui_Vhr581.User_Remove','M',null,'A',null,null,null,null);
uis.route('/vhr/hisl/settings$save_setting','Ui_Vhr581.Setting_Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hisl/settings:model','Ui_Vhr581.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hisl/settings:persons','Ui_Vhr581.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hisl/settings:table_divisions','Ui_Vhr581.Query_Divisions',null,'Q','A',null,null,null,null);
uis.route('/vhr/hisl/settings:table_logs','Ui_Vhr581.Query_Logs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hisl/settings:table_users','Ui_Vhr581.Query_Users',null,'Q','A',null,null,null,null);

uis.path('/vhr/hisl/settings','vhr581');
uis.form('/vhr/hisl/settings','/vhr/hisl/settings','F','A','F','HM','M','N',null,null);



uis.action('/vhr/hisl/settings','add_division','F',null,null,'A');
uis.action('/vhr/hisl/settings','add_user','F',null,null,'A');
uis.action('/vhr/hisl/settings','remove_division','F',null,null,'A');
uis.action('/vhr/hisl/settings','remove_user','F',null,null,'A');
uis.action('/vhr/hisl/settings','save_setting','F',null,null,'A');


uis.ready('/vhr/hisl/settings','.add_division.add_user.model.remove_division.remove_user.save_setting.');

commit;
end;
/
