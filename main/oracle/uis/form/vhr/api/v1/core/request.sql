set define off
prompt PATH /vhr/api/v1/core/request
begin
uis.route('/vhr/api/v1/core/request$create','Ui_Vhr455.Create_Request','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/request$delete','Ui_Vhr455.Delete_Request','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/request$list','Ui_Vhr455.List_Requests','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/request$update','Ui_Vhr455.Update_Request','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/request:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/request','vhr455');
uis.form('/vhr/api/v1/core/request','/vhr/api/v1/core/request','F','A','E','H','M','N',null,'N');



uis.action('/vhr/api/v1/core/request','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/request','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/request','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/request','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/request','.create.delete.list.model.update.');

commit;
end;
/
