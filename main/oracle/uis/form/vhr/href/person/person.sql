set define off
prompt PATH /vhr/href/person/person
begin
uis.route('/vhr/href/person/person$save_contacts','Ui_Vhr502.Save_Contacts','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person$save_personal','Ui_Vhr502.Save_Personal','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person:email_is_unique','Ui_Vhr502.Email_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/person/person:model','Ui_Vhr502.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/person/person:nationalities','Ui_Vhr502.Query_Nationalities',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person:phone_is_unique','Ui_Vhr502.Phone_Is_Unique','M','V','A',null,null,null,null);

uis.path('/vhr/href/person/person','vhr502');
uis.form('/vhr/href/person/person','/vhr/href/person/person','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person','add_nationality','A','/vhr/href/nationality+add','D','O');
uis.action('/vhr/href/person/person','save_contacts','A',null,null,'A');
uis.action('/vhr/href/person/person','save_personal','A',null,null,'A');
uis.action('/vhr/href/person/person','select_nationality','A','/vhr/href/nationality_list','D','O');


uis.ready('/vhr/href/person/person','.add_nationality.model.save_contacts.save_personal.select_nationality.');

commit;
end;
/
