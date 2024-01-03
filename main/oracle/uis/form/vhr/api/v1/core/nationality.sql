set define off
prompt PATH /vhr/api/v1/core/nationality
begin
uis.route('/vhr/api/v1/core/nationality$create','Ui_Vhr460.Create_Nationality','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/nationality$delete','Ui_Vhr460.Delete_Nationality','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/nationality$list','Ui_Vhr460.List_Nationalities','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/nationality$update','Ui_Vhr460.Update_Nationality','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/core/nationality','vhr460');
uis.form('/vhr/api/v1/core/nationality','/vhr/api/v1/core/nationality','F','A','E','H','M','N',null,'N');



uis.action('/vhr/api/v1/core/nationality','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/nationality','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/nationality','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/nationality','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/nationality','.create.delete.list.model.update.');

commit;
end;
/
