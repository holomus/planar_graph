set define off
prompt PATH /vhr/href/candidate/candidate_form_settings
begin
uis.route('/vhr/href/candidate/candidate_form_settings:edu_stages','Ui_Vhr298.Query_Edu_Stages',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate_form_settings:languages','Ui_Vhr298.Query_Languages',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate_form_settings:model','Ui_Vhr298.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/candidate/candidate_form_settings:save','Ui_Vhr298.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/href/candidate/candidate_form_settings','vhr298');
uis.form('/vhr/href/candidate/candidate_form_settings','/vhr/href/candidate/candidate_form_settings','F','A','F','HM','M','N',null,'N');





uis.ready('/vhr/href/candidate/candidate_form_settings','.model.');

commit;
end;
/
