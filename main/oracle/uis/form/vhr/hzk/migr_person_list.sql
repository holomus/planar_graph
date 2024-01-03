set define off
prompt PATH /vhr/hzk/migr_person_list
begin
uis.route('/vhr/hzk/migr_person_list$delete','Ui_Vhr87.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hzk/migr_person_list$migr','Ui_Vhr87.Migr','M',null,'A',null,null,null,null);
uis.route('/vhr/hzk/migr_person_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hzk/migr_person_list:persons','Ui_Vhr87.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hzk/migr_person_list:table','Ui_Vhr87.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hzk/migr_person_list','vhr87');
uis.form('/vhr/hzk/migr_person_list','/vhr/hzk/migr_person_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hzk/migr_person_list','delete','A',null,null,'A');
uis.action('/vhr/hzk/migr_person_list','migr','A',null,null,'A');
uis.action('/vhr/hzk/migr_person_list','tracks','A','/vhr/hzk/migr_track_list','S','O');


uis.ready('/vhr/hzk/migr_person_list','.delete.migr.model.tracks.');

commit;
end;
/
