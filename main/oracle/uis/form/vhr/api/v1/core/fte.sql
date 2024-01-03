set define off
prompt PATH /vhr/api/v1/core/fte
begin
uis.route('/vhr/api/v1/core/fte$create','Ui_Vhr349.Create_Fte','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/fte$delete','Ui_Vhr349.Delete_Fte','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/fte$list','Ui_Vhr349.List_Ftes','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/fte$update','Ui_Vhr349.Update_Fte','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/core/fte','vhr349');
uis.form('/vhr/api/v1/core/fte','/vhr/api/v1/core/fte','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/fte','create','A',null,null,'A');
uis.action('/vhr/api/v1/core/fte','delete','A',null,null,'A');
uis.action('/vhr/api/v1/core/fte','list','A',null,null,'A');
uis.action('/vhr/api/v1/core/fte','update','A',null,null,'A');


uis.ready('/vhr/api/v1/core/fte','.create.delete.list.model.update.');

commit;
end;
/
