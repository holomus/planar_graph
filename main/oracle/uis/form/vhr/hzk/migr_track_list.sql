set define off
prompt PATH /vhr/hzk/migr_track_list
begin
uis.route('/vhr/hzk/migr_track_list$delete','Ui_Vhr88.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hzk/migr_track_list$migr','Ui_Vhr88.Migr','M',null,'A',null,null,null,null);
uis.route('/vhr/hzk/migr_track_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hzk/migr_track_list:table','Ui_Vhr88.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hzk/migr_track_list','vhr88');
uis.form('/vhr/hzk/migr_track_list','/vhr/hzk/migr_track_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hzk/migr_track_list','delete','A',null,null,'A');
uis.action('/vhr/hzk/migr_track_list','migr','A',null,null,'A');


uis.ready('/vhr/hzk/migr_track_list','.delete.migr.model.');

commit;
end;
/
