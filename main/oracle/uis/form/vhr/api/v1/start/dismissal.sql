set define off
prompt PATH /vhr/api/v1/start/dismissal
begin
uis.route('/vhr/api/v1/start/dismissal$create','Ui_Vhr346.Create_Dismissal','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/start/dismissal$delete','Ui_Vhr346.Delete_Dismissal','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/dismissal$list','Ui_Vhr346.List_Dismissals','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/start/dismissal$update','Ui_Vhr346.Update_Dismissal','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/dismissal:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/start/dismissal','vhr346');
uis.form('/vhr/api/v1/start/dismissal','/vhr/api/v1/start/dismissal','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/start/dismissal','create','F',null,null,'A');
uis.action('/vhr/api/v1/start/dismissal','delete','F',null,null,'A');
uis.action('/vhr/api/v1/start/dismissal','list','F',null,null,'A');
uis.action('/vhr/api/v1/start/dismissal','update','F',null,null,'A');


uis.ready('/vhr/api/v1/start/dismissal','.create.delete.list.model.update.');

commit;
end;
/
