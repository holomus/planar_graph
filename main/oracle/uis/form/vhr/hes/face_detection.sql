set define off
prompt PATH /vhr/hes/face_detection
begin
uis.route('/vhr/hes/face_detection:model','Ui_Vhr621.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hes/face_detection:save_vector','Ui_Vhr621.Save_Vector','JO',null,'A',null,null,null,null);
uis.route('/vhr/hes/face_detection:upload_photo','Ui_Vhr621.Upload_Photo','M',null,'A',null,null,null,null);

uis.path('/vhr/hes/face_detection','vhr621');
uis.form('/vhr/hes/face_detection','/vhr/hes/face_detection','A','A','F','HM','M','N',null,null);





uis.ready('/vhr/hes/face_detection','.model.');

commit;
end;
/
