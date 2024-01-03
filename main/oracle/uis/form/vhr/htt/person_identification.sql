set define off
prompt PATH /vhr/htt/person_identification
begin
uis.route('/vhr/htt/person_identification$regen_qrcode','Ui_Vhr90.Regen_Qrcode','M','M','A',null,null,null,null);
uis.route('/vhr/htt/person_identification:calculate_photo_vector','Ui_Vhr90.Calculate_Photo_Vector','M','R','A',null,null,null,null);
uis.route('/vhr/htt/person_identification:model','Ui_Vhr90.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/person_identification:save','Ui_Vhr90.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/person_identification:upload_images','Ui_Vhr90.Upload_Images','M','M','A',null,null,null,null);

uis.path('/vhr/htt/person_identification','vhr90');
uis.form('/vhr/htt/person_identification','/vhr/htt/person_identification','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/person_identification','regen_qrcode','A',null,null,'A');


uis.ready('/vhr/htt/person_identification','.model.regen_qrcode.');

commit;
end;
/
