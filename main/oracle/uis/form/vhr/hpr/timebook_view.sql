set define off
prompt PATH /vhr/hpr/timebook_view
begin
uis.route('/vhr/hpr/timebook_view$post','Ui_Vhr163.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/timebook_view$unpost','Ui_Vhr163.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/timebook_view:model','Ui_Vhr163.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hpr/timebook_view','vhr163');
uis.form('/vhr/hpr/timebook_view','/vhr/hpr/timebook_view','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/hpr/timebook_view','edit','F','/vhr/hpr/timebook+edit','S','O');
uis.action('/vhr/hpr/timebook_view','post','F',null,null,'A');
uis.action('/vhr/hpr/timebook_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpr/timebook_view','.edit.model.post.unpost.');

commit;
end;
/
