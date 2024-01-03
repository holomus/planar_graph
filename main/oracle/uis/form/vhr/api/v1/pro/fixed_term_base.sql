set define off
prompt PATH /vhr/api/v1/pro/fixed_term_base
begin
uis.route('/vhr/api/v1/pro/fixed_term_base$create','Ui_Vhr418.Create_Fixed_Term_Base','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/fixed_term_base$delete','Ui_Vhr418.Delete_Fixed_Term_Base','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/pro/fixed_term_base$list','Ui_Vhr418.List_Fixed_Term_Bases','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/fixed_term_base$update','Ui_Vhr418.Update_Fixed_Term_Base','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/pro/fixed_term_base','vhr418');
uis.form('/vhr/api/v1/pro/fixed_term_base','/vhr/api/v1/pro/fixed_term_base','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/fixed_term_base','create','A',null,null,'A');
uis.action('/vhr/api/v1/pro/fixed_term_base','delete','A',null,null,'A');
uis.action('/vhr/api/v1/pro/fixed_term_base','list','A',null,null,'A');
uis.action('/vhr/api/v1/pro/fixed_term_base','update','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/fixed_term_base','.create.delete.list.model.update.');

commit;
end;
/
