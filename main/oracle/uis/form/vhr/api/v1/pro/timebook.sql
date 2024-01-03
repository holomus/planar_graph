set define off
prompt PATH /vhr/api/v1/pro/timebook
begin
uis.route('/vhr/api/v1/pro/timebook$list','Ui_Vhr267.List_Timebooks','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/timebook$list_details','Ui_Vhr267.List_Timebook_Details','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/timebook:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/pro/timebook','vhr267');
uis.form('/vhr/api/v1/pro/timebook','/vhr/api/v1/pro/timebook','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/timebook','list','F',null,null,'A');
uis.action('/vhr/api/v1/pro/timebook','list_details','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/timebook','.list.list_details.model.');

commit;
end;
/
