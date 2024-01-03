set define off
prompt PATH /vhr/hes/logon_timepad
begin
uis.route('/vhr/hes/logon_timepad$logon_with_qr_code','Ui_Vhr353.Logon_With_Qr_Code','L','L','P',null,null,null,null);

uis.path('/vhr/hes/logon_timepad','vhr353');
uis.form('/vhr/hes/logon_timepad','/vhr/hes/logon_timepad','A','P','E','Z','M','N',null,'N');





uis.ready('/vhr/hes/logon_timepad','.model.');

commit;
end;
/
