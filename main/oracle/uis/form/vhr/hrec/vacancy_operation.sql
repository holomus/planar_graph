set define off
prompt PATH /vhr/hrec/vacancy_operation
begin
uis.route('/vhr/hrec/vacancy_operation$change_hh_stage','Ui_Vhr576.Change_Hh_Stage','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation$delete_operation','Ui_Vhr576.Delete_Operation','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation$load_candidate_info','Ui_Vhr576.Load_Olx_Candidate_Info','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation$load_hh_candidates','Ui_Vhr576.Load_Hh_Vacation_Candidates','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation$load_olx_candidates','Ui_Vhr576.Load_Olx_Vacation_Candidates','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:add_candidate','Ui_Vhr576.Add_Candidate','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:get_candidate_ids','Ui_Vhr576.Get_Candidate_Ids','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:get_candidate_operations','Ui_Vhr576.Get_Candidate_Operations','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:get_candidates','Ui_Vhr576.Get_Candidates','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:load_form','Ui_Vhr576.Model','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:model','Ui_Vhr576.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_operation:reject_reasons','Ui_Vhr576.Query_Reject_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_operation:save_operation','Ui_Vhr576.Save_Operation','M',null,'A',null,null,null,null);

uis.path('/vhr/hrec/vacancy_operation','vhr576');
uis.form('/vhr/hrec/vacancy_operation','/vhr/hrec/vacancy_operation','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/vacancy_operation','add_operation','F',null,null,'G');
uis.action('/vhr/hrec/vacancy_operation','add_reject_reason','F','/vhr/hrec/reject_reason+add','D','O');
uis.action('/vhr/hrec/vacancy_operation','change_hh_stage','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_operation','delete_operation','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_operation','edit_operation','F',null,null,'G');
uis.action('/vhr/hrec/vacancy_operation','load_candidate_info','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_operation','load_hh_candidates','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_operation','load_olx_candidates','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_operation','select_candidate','F','/vhr/href/candidate/candidate_list','D','O');
uis.action('/vhr/hrec/vacancy_operation','select_reject_reason','F','/vhr/hrec/reject_reason_list','D','O');


uis.ready('/vhr/hrec/vacancy_operation','.add_operation.add_reject_reason.change_hh_stage.delete_operation.edit_operation.load_candidate_info.load_hh_candidates.load_olx_candidates.model.select_candidate.select_reject_reason.');

commit;
end;
/
