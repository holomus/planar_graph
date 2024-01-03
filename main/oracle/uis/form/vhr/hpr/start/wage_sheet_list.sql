set define off
prompt PATH /vhr/hpr/start/wage_sheet_list
begin
uis.route('/vhr/hpr/start/wage_sheet_list$delete','Ui_Vhr315.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list$post','Ui_Vhr315.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list$unpost','Ui_Vhr315.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list+onetime$delete','Ui_Vhr315.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list+onetime$post','Ui_Vhr315.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list+onetime$unpost','Ui_Vhr315.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list+onetime:model','Ui_Vhr315.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list+onetime:save_preferences','Ui_Vhr315.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list+onetime:table','Ui_Vhr315.Query_Onetime_Sheets',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list:model','Ui_Vhr315.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list:run','Ui_Vhr315.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list:save_preferences','Ui_Vhr315.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet_list:table','Ui_Vhr315.Query_Regular_Sheets',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpr/start/wage_sheet_list','vhr315');
uis.form('/vhr/hpr/start/wage_sheet_list','/vhr/hpr/start/wage_sheet_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpr/start/wage_sheet_list+onetime','/vhr/hpr/start/wage_sheet_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpr/start/wage_sheet_list','add','F','/vhr/hpr/start/wage_sheet+add','S','O');
uis.action('/vhr/hpr/start/wage_sheet_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/start/wage_sheet_list','edit','F','/vhr/hpr/start/wage_sheet+edit','S','O');
uis.action('/vhr/hpr/start/wage_sheet_list','post','F',null,null,'A');
uis.action('/vhr/hpr/start/wage_sheet_list','run','F',null,null,'A');
uis.action('/vhr/hpr/start/wage_sheet_list','unpost','F',null,null,'A');
uis.action('/vhr/hpr/start/wage_sheet_list+onetime','add','F','/vhr/hpr/start/onetime_sheet+add','S','O');
uis.action('/vhr/hpr/start/wage_sheet_list+onetime','delete','F',null,null,'A');
uis.action('/vhr/hpr/start/wage_sheet_list+onetime','edit','F','/vhr/hpr/start/onetime_sheet+edit','S','O');
uis.action('/vhr/hpr/start/wage_sheet_list+onetime','post','F',null,null,'A');
uis.action('/vhr/hpr/start/wage_sheet_list+onetime','unpost','F',null,null,'A');


uis.ready('/vhr/hpr/start/wage_sheet_list','.add.delete.edit.model.post.run.unpost.');
uis.ready('/vhr/hpr/start/wage_sheet_list+onetime','.add.delete.edit.model.post.unpost.');

commit;
end;
/
