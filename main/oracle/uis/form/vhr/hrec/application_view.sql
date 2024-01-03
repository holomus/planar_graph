set define off
prompt PATH /vhr/hrec/application_view
begin
uis.route('/vhr/hrec/application_view$to_approved','Ui_Vhr587.Change_Status_To_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_view$to_canceled','Ui_Vhr587.Change_Status_To_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_view$to_completed','Ui_Vhr587.Change_Status_To_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_view$to_draft','Ui_Vhr587.Change_Status_To_Draft','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_view$to_waiting','Ui_Vhr587.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_view:model','Ui_Vhr587.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hrec/application_view','vhr587');
uis.form('/vhr/hrec/application_view','/vhr/hrec/application_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/application_view','create_vacancy','F','/vhr/hrec/vacancy+add','D','O');
uis.action('/vhr/hrec/application_view','edit','F','/vhr/hrec/application+edit','D','O');
uis.action('/vhr/hrec/application_view','to_approved','F',null,null,'A');
uis.action('/vhr/hrec/application_view','to_canceled','F',null,null,'A');
uis.action('/vhr/hrec/application_view','to_completed','F',null,null,'A');
uis.action('/vhr/hrec/application_view','to_draft','F',null,null,'A');
uis.action('/vhr/hrec/application_view','to_waiting','F',null,null,'A');


uis.ready('/vhr/hrec/application_view','.create_vacancy.edit.model.to_approved.to_canceled.to_completed.to_draft.to_waiting.');

commit;
end;
/
