set define off
prompt PATH /vhr/api/v1/pro/employment_source
begin
uis.route('/vhr/api/v1/pro/employment_source$create','Ui_Vhr417.Create_Employment_Source','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/employment_source$delete','Ui_Vhr417.Delete_Employment_Source','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/pro/employment_source$list','Ui_Vhr417.List_Employment_Sources','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/employment_source$update','Ui_Vhr417.Update_Employment_Source','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/pro/employment_source','vhr417');
uis.form('/vhr/api/v1/pro/employment_source','/vhr/api/v1/pro/employment_source','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/employment_source','create','A',null,null,'A');
uis.action('/vhr/api/v1/pro/employment_source','delete','A',null,null,'A');
uis.action('/vhr/api/v1/pro/employment_source','list','A',null,null,'A');
uis.action('/vhr/api/v1/pro/employment_source','update','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/employment_source','.create.delete.list.model.update.');

commit;
end;
/
