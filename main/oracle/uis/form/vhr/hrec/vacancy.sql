set define off
prompt PATH /vhr/hrec/vacancy
begin
uis.route('/vhr/hrec/vacancy+add$publish_head_hunter','Ui_Vhr571.Save_And_Publish_Head_Hunter','M','R','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add$publish_olx','Ui_Vhr571.Save_And_Publish_Olx','M','R','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:exam','Ui_Vhr571.Query_Exams',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:funnel','Ui_Vhr571.Query_Funnel',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:get_attributes','Ui_Vhr571.Get_Attributes','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:job','Ui_Vhr571.Query_Job',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:lang_levels','Ui_Vhr571.Query_Lang_Levels',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:langs','Ui_Vhr571.Query_Langs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:model','Ui_Vhr571.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:olx_category','Ui_Vhr571.Query_Olx_Categories',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:recruiter','Ui_Vhr571.Query_Recruiters',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:save','Ui_Vhr571.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:schedule','Ui_Vhr571.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+add:vacancy_types','Ui_Vhr571.Query_Vacancy_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit$publish_head_hunter','Ui_Vhr571.Save_And_Publish_Head_Hunter','M','R','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit$publish_olx','Ui_Vhr571.Save_And_Publish_Olx','M','R','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:exam','Ui_Vhr571.Query_Exams',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:funnel','Ui_Vhr571.Query_Funnel',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:get_attributes','Ui_Vhr571.Get_Attributes','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:job','Ui_Vhr571.Query_Job',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:lang_levels','Ui_Vhr571.Query_Lang_Levels',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:langs','Ui_Vhr571.Query_Langs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:model','Ui_Vhr571.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:olx_category','Ui_Vhr571.Query_Olx_Categories',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:recruiter','Ui_Vhr571.Query_Recruiters',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:save','Ui_Vhr571.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:schedule','Ui_Vhr571.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy+edit:vacancy_types','Ui_Vhr571.Query_Vacancy_Types','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hrec/vacancy','vhr571');
uis.form('/vhr/hrec/vacancy+add','/vhr/hrec/vacancy','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hrec/vacancy+edit','/vhr/hrec/vacancy','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hrec/vacancy+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrec/vacancy+add','publish_head_hunter','F',null,null,'A');
uis.action('/vhr/hrec/vacancy+add','publish_olx','F',null,null,'A');
uis.action('/vhr/hrec/vacancy+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hrec/vacancy+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrec/vacancy+edit','publish_head_hunter','F',null,null,'A');
uis.action('/vhr/hrec/vacancy+edit','publish_olx','F',null,null,'A');
uis.action('/vhr/hrec/vacancy+edit','select_job','F','/anor/mhr/job_list','D','O');


uis.ready('/vhr/hrec/vacancy+add','.add_job.model.publish_head_hunter.publish_olx.select_job.');
uis.ready('/vhr/hrec/vacancy+edit','.add_job.model.publish_head_hunter.publish_olx.select_job.');

commit;
end;
/
