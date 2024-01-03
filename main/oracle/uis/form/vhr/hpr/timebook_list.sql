set define off
prompt PATH /vhr/hpr/timebook_list
begin
uis.route('/vhr/hpr/timebook_list$delete','Ui_Vhr74.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/timebook_list$post','Ui_Vhr74.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/timebook_list$unpost','Ui_Vhr74.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/timebook_list:model','Ui_Vhr74.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/timebook_list:save_setting','Ui_Vhr74.Save_Settings','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/timebook_list:table','Ui_Vhr74.Query','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/timebook_list:time_kinds','Ui_Vhr74.Query_Time_Kinds',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpr/timebook_list','vhr74');
uis.form('/vhr/hpr/timebook_list','/vhr/hpr/timebook_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hpr/timebook_list','add','F','/vhr/hpr/timebook+add','S','O');
uis.action('/vhr/hpr/timebook_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/timebook_list','edit','F','/vhr/hpr/timebook+edit','S','O');
uis.action('/vhr/hpr/timebook_list','post','F',null,null,'A');
uis.action('/vhr/hpr/timebook_list','unpost','F',null,null,'A');
uis.action('/vhr/hpr/timebook_list','view','A','/vhr/hpr/timebook_view','S','O');

uis.form_sibling('vhr','/vhr/hpr/timebook_list','/vhr/hpd/timebook_adjustment_list',1);

uis.ready('/vhr/hpr/timebook_list','.add.delete.edit.model.post.unpost.view.');

commit;
end;
/
