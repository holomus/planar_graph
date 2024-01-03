set define off
prompt PATH /vhr/href/fixed_term_base_list
begin
uis.route('/vhr/href/fixed_term_base_list$delete','Ui_Vhr70.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/fixed_term_base_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/fixed_term_base_list:table','Ui_Vhr70.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/fixed_term_base_list','vhr70');
uis.form('/vhr/href/fixed_term_base_list','/vhr/href/fixed_term_base_list','A','A','F','HM','M','N',null);



uis.action('/vhr/href/fixed_term_base_list','add','A','/vhr/href/fixed_term_base+add','S','O');
uis.action('/vhr/href/fixed_term_base_list','delete','A',null,null,'A');
uis.action('/vhr/href/fixed_term_base_list','edit','A','/vhr/href/fixed_term_base+edit','S','O');



uis.ready('/vhr/href/fixed_term_base_list','.add.delete.edit.model.');

commit;
end;
/
