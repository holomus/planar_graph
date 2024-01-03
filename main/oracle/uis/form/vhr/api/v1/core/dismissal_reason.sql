set define off
prompt PATH /vhr/api/v1/core/dismissal_reason
begin
uis.route('/vhr/api/v1/core/dismissal_reason$create','Ui_Vhr341.Create_Dismissal_Reason','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/dismissal_reason$delete','Ui_Vhr341.Delete_Dismissal_Reason','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/dismissal_reason$list','Ui_Vhr341.List_Dismissal_Reasons','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/dismissal_reason$update','Ui_Vhr341.Update_Dismissal_Reason','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/core/dismissal_reason','vhr341');
uis.form('/vhr/api/v1/core/dismissal_reason','/vhr/api/v1/core/dismissal_reason','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/dismissal_reason','create','A',null,null,'A');
uis.action('/vhr/api/v1/core/dismissal_reason','delete','A',null,null,'A');
uis.action('/vhr/api/v1/core/dismissal_reason','list','A',null,null,'A');
uis.action('/vhr/api/v1/core/dismissal_reason','update','A',null,null,'A');


uis.ready('/vhr/api/v1/core/dismissal_reason','.create.delete.list.model.update.');

commit;
end;
/
