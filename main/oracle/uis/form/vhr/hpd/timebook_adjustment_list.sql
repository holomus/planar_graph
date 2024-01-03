set define off
prompt PATH /vhr/hpd/timebook_adjustment_list
begin
uis.route('/vhr/hpd/timebook_adjustment_list$delete','Ui_Vhr589.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment_list$post','Ui_Vhr589.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment_list$unpost','Ui_Vhr589.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment_list:model','Ui_Vhr589.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/timebook_adjustment_list:table','Ui_Vhr589.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/timebook_adjustment_list','vhr589');
uis.form('/vhr/hpd/timebook_adjustment_list','/vhr/hpd/timebook_adjustment_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/timebook_adjustment_list','add','F','/vhr/hpd/timebook_adjustment+add','S','O');
uis.action('/vhr/hpd/timebook_adjustment_list','delete','F',null,null,'A');
uis.action('/vhr/hpd/timebook_adjustment_list','edit','F','/vhr/hpd/timebook_adjustment+edit','S','O');
uis.action('/vhr/hpd/timebook_adjustment_list','post','F',null,null,'A');
uis.action('/vhr/hpd/timebook_adjustment_list','unpost','F',null,null,'A');
uis.action('/vhr/hpd/timebook_adjustment_list','view','F','/vhr/hpd/view/timebook_adjustment_view','S','O');


uis.ready('/vhr/hpd/timebook_adjustment_list','.add.delete.edit.model.post.unpost.view.');

commit;
end;
/
