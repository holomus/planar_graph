set define off
prompt PATH /vhr/api/v1/core/request_kind
begin
uis.route('/vhr/api/v1/core/request_kind$create','Ui_Vhr457.Create_Request_Kind','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/request_kind$delete','Ui_Vhr457.Delete_Request_Kind','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/request_kind$list','Ui_Vhr457.List_Request_Kinds','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/request_kind$update','Ui_Vhr457.Update_Request_Kind','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/request_kind:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/request_kind','vhr457');
uis.form('/vhr/api/v1/core/request_kind','/vhr/api/v1/core/request_kind','A','A','E','H','M','N',null,'N');



uis.action('/vhr/api/v1/core/request_kind','create','A',null,null,'A');
uis.action('/vhr/api/v1/core/request_kind','delete','A',null,null,'A');
uis.action('/vhr/api/v1/core/request_kind','list','A',null,null,'A');
uis.action('/vhr/api/v1/core/request_kind','update','A',null,null,'A');


uis.ready('/vhr/api/v1/core/request_kind','.create.delete.list.model.update.');

commit;
end;
/
