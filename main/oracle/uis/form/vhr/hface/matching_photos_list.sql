set define off
prompt PATH /vhr/hface/matching_photos_list
begin
uis.route('/vhr/hface/matching_photos_list$add_recognition_job','Ui_Vhr630.Add_Recognition_Job','M','R','A',null,null,null,null);
uis.route('/vhr/hface/matching_photos_list$calculate_vector','Ui_Vhr630.Calculate_Photo_Vector','M','R','A',null,null,null,null);
uis.route('/vhr/hface/matching_photos_list:check_recognition','Ui_Vhr630.Check_Recognition_Job',null,'R','A',null,null,null,null);
uis.route('/vhr/hface/matching_photos_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hface/matching_photos_list:table','Ui_Vhr630.Query_Matching_Photos',null,'Q','A',null,null,null,null);

uis.path('/vhr/hface/matching_photos_list','vhr630');
uis.form('/vhr/hface/matching_photos_list','/vhr/hface/matching_photos_list','H','A','F','H','M','Y',null,'N');



uis.action('/vhr/hface/matching_photos_list','add_recognition_job','H',null,null,'A');
uis.action('/vhr/hface/matching_photos_list','calculate_vector','H',null,null,'A');


uis.ready('/vhr/hface/matching_photos_list','.add_recognition_job.calculate_vector.model.');

commit;
end;
/
