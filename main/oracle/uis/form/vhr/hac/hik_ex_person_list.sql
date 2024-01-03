set define off
prompt PATH /vhr/hac/hik_ex_person_list
begin
uis.route('/vhr/hac/hik_ex_person_list$delete','Ui_Vhr590.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_person_list$match_persons','Ui_Vhr590.Match_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_person_list:load_person_photo','Ui_Vhr590.Load_Person_Photo','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_person_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_ex_person_list:table','Ui_Vhr590.Query_Hik_Persons','M','Q','A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_person_list:table_persons','Ui_Vhr590.Query_Persons','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_ex_person_list','vhr590');
uis.form('/vhr/hac/hik_ex_person_list','/vhr/hac/hik_ex_person_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_ex_person_list','delete','A',null,null,'A');
uis.action('/vhr/hac/hik_ex_person_list','match_persons','A',null,null,'A');


uis.ready('/vhr/hac/hik_ex_person_list','.delete.match_persons.model.');

commit;
end;
/
