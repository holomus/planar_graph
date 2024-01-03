set define off
prompt PATH /vhr/htm/recommended_rank_document
begin
uis.route('/vhr/htm/recommended_rank_document+add:load_staffs','Ui_Vhr550.Load_Staffs','JO','JA','A',null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document+add:model','Ui_Vhr550.Add_Model',null,'JO','A','Y',null,null,null);
uis.route('/vhr/htm/recommended_rank_document+add:save','Ui_Vhr550.Add','JO','JO','A',null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document+edit:load_staffs','Ui_Vhr550.Load_Staffs','JO','JA','A',null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document+edit:model','Ui_Vhr550.Edit_Model','JO','JO','A','Y',null,null,null);
uis.route('/vhr/htm/recommended_rank_document+edit:save','Ui_Vhr550.Edit','JO','JO','A',null,null,null,null);

uis.path('/vhr/htm/recommended_rank_document','vhr550');
uis.form('/vhr/htm/recommended_rank_document+add','/vhr/htm/recommended_rank_document','F','A','F','H','M','N',null,null);
uis.form('/vhr/htm/recommended_rank_document+edit','/vhr/htm/recommended_rank_document','F','A','F','H','M','N',null,null);





uis.ready('/vhr/htm/recommended_rank_document+add','.model.');
uis.ready('/vhr/htm/recommended_rank_document+edit','.model.');

commit;
end;
/
