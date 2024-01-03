set define off
prompt PATH /vhr/href/person/person_reference_view
begin
uis.route('/vhr/href/person/person_reference_view:model','Ui_Vhr150.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/person/person_reference_view','vhr150');
uis.form('/vhr/href/person/person_reference_view','/vhr/href/person/person_reference_view','A','A','F','H','M','N',null,'N');






uis.ready('/vhr/href/person/person_reference_view','.model.');

commit;
end;
/
