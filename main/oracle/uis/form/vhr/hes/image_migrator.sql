set define off
prompt PATH /vhr/hes/image_migrator
begin
uis.route('/vhr/hes/image_migrator:download_person_shas','Ui_Vhr584.Download_Person_Shas',null,'JO','A',null,null,null,null);
uis.route('/vhr/hes/image_migrator:upload_person_shas','Ui_Vhr584.Upload_Photo_Shas','JA',null,'A',null,null,null,null);

uis.path('/vhr/hes/image_migrator','vhr584');
uis.form('/vhr/hes/image_migrator','/vhr/hes/image_migrator','A','A','E','Z','M','Y',null,'N');





uis.ready('/vhr/hes/image_migrator','.model.');

commit;
end;
/
