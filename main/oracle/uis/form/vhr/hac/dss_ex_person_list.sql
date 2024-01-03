set define off
prompt PATH /vhr/hac/dss_ex_person_list
begin
uis.route('/vhr/hac/dss_ex_person_list$delete','Ui_Vhr531.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_person_list$match_persons','Ui_Vhr531.Match_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_person_list:get_persons','Ui_Vhr531.Get_Persons','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_person_list:load_person_photo','Ui_Vhr531.Load_Person_Photo','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_person_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_ex_person_list:table','Ui_Vhr531.Query_Dss_Persons','M','Q','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_person_list:table_persons','Ui_Vhr531.Query_Persons','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_ex_person_list','vhr531');
uis.form('/vhr/hac/dss_ex_person_list','/vhr/hac/dss_ex_person_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_ex_person_list','delete','A',null,null,'A');
uis.action('/vhr/hac/dss_ex_person_list','match_persons','A',null,null,'A');


uis.ready('/vhr/hac/dss_ex_person_list','.delete.match_persons.model.');

commit;
end;
/
