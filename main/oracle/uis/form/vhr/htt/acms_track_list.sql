set define off
prompt PATH /vhr/htt/acms_track_list
begin
uis.route('/vhr/htt/acms_track_list$integrate','Ui_Vhr474.Integrate','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/acms_track_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/acms_track_list:table','Ui_Vhr474.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/acms_track_list','vhr474');
uis.form('/vhr/htt/acms_track_list','/vhr/htt/acms_track_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/acms_track_list','integrate','A',null,null,'A');


uis.ready('/vhr/htt/acms_track_list','.integrate.model.');

commit;
end;
/
