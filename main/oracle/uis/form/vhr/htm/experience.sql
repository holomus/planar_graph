set define off
prompt PATH /vhr/htm/experience
begin
uis.route('/vhr/htm/experience+add:exams','Ui_Vhr528.Query_Exams',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+add:indicator','Ui_Vhr528.Query_Indicators',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+add:model','Ui_Vhr528.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htm/experience+add:rank','Ui_Vhr528.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+add:save','Ui_Vhr528.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+add:subjects','Ui_Vhr528.Query_Subjects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+edit:exams','Ui_Vhr528.Query_Exams',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+edit:indicator','Ui_Vhr528.Query_Indicators',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+edit:model','Ui_Vhr528.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htm/experience+edit:rank','Ui_Vhr528.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+edit:save','Ui_Vhr528.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htm/experience+edit:subjects','Ui_Vhr528.Query_Subjects',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/htm/experience','vhr528');
uis.form('/vhr/htm/experience+add','/vhr/htm/experience','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/htm/experience+edit','/vhr/htm/experience','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/htm/experience+add','select_indicator','F','/vhr/href/indicator_list','D','O');
uis.action('/vhr/htm/experience+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/htm/experience+edit','select_indicator','F','/vhr/href/indicator_list','D','O');
uis.action('/vhr/htm/experience+edit','select_rank','F','/anor/mhr/rank_list','D','O');


uis.ready('/vhr/htm/experience+add','.model.select_indicator.select_rank.');
uis.ready('/vhr/htm/experience+edit','.model.select_indicator.select_rank.');

commit;
end;
/
