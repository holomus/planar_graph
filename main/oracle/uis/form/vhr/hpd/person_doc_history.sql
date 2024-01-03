set define off
prompt PATH /vhr/hpd/person_doc_history
begin
uis.route('/vhr/hpd/person_doc_history:model','Ui_Vhr262.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/person_doc_history:primary_staffs','Ui_Vhr262.Query_Primary_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/person_doc_history:secondary_staffs0','Ui_Vhr262.Query_Secondary_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/person_doc_history:secondary_staffs1','Ui_Vhr262.Query_Secondary_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/person_doc_history:secondary_staffs2','Ui_Vhr262.Query_Secondary_Staffs','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/person_doc_history','vhr262');
uis.form('/vhr/hpd/person_doc_history','/vhr/hpd/person_doc_history','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/person_doc_history','dismissal_multiple_view','F','/vhr/hpd/view/dismissal_view','S','O');
uis.action('/vhr/hpd/person_doc_history','dismissal_view','F','/vhr/hpd/view/dismissal_view','S','O');
uis.action('/vhr/hpd/person_doc_history','hiring_multiple_view','F','/vhr/hpd/view/hiring_view','S','O');
uis.action('/vhr/hpd/person_doc_history','hiring_view','F','/vhr/hpd/view/hiring_view','S','O');
uis.action('/vhr/hpd/person_doc_history','rank_change','F','/vhr/hpd/view/rank_change_view','S','O');
uis.action('/vhr/hpd/person_doc_history','rank_change_view','F','/vhr/hpd/view/rank_change_view','S','O');
uis.action('/vhr/hpd/person_doc_history','schedule_change_view','F','/vhr/hpd/view/schedule_change_view','S','O');
uis.action('/vhr/hpd/person_doc_history','transfer_multiple_view','F','/vhr/hpd/view/transfer_view','S','O');
uis.action('/vhr/hpd/person_doc_history','transfer_view','F','/vhr/hpd/view/transfer_view','S','O');
uis.action('/vhr/hpd/person_doc_history','vacation_limit_change_view','F','/vhr/hpd/view/vacation_limit_change_view','S','O');
uis.action('/vhr/hpd/person_doc_history','wage_change_view','F','/vhr/hpd/view/wage_change_view','S','O');


uis.ready('/vhr/hpd/person_doc_history','.dismissal_multiple_view.dismissal_view.hiring_multiple_view.hiring_view.model.rank_change.rank_change_view.schedule_change_view.transfer_multiple_view.transfer_view.vacation_limit_change_view.wage_change_view.');

commit;
end;
/
