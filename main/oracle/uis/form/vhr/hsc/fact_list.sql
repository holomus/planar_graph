set define off
prompt PATH /vhr/hsc/fact_list
begin
uis.route('/vhr/hsc/fact_list+actual$delete','Ui_Vhr538.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/fact_list+actual:model','Ui_Vhr538.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/fact_list+actual:table','Ui_Vhr538.Query_Actual',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_list+predicted$delete','Ui_Vhr538.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/fact_list+predicted:model','Ui_Vhr538.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/fact_list+predicted:table','Ui_Vhr538.Query_Predicted',null,'Q','A',null,null,null,null);

uis.path('/vhr/hsc/fact_list','vhr538');
uis.form('/vhr/hsc/fact_list+actual','/vhr/hsc/fact_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hsc/fact_list+predicted','/vhr/hsc/fact_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hsc/fact_list+actual','add_actual','F','/vhr/hsc/fact+add','S','O');
uis.action('/vhr/hsc/fact_list+actual','delete','F',null,null,'A');
uis.action('/vhr/hsc/fact_list+actual','dynamic_import','F','/vhr/hsc/dynamic_fact_import','S','O');
uis.action('/vhr/hsc/fact_list+actual','edit','F','/vhr/hsc/fact+edit','S','O');
uis.action('/vhr/hsc/fact_list+actual','import','F','/vhr/hsc/fact_import','S','O');
uis.action('/vhr/hsc/fact_list+predicted','add','F','/vhr/hsc/fact+add','S','O');
uis.action('/vhr/hsc/fact_list+predicted','delete','F',null,null,'A');
uis.action('/vhr/hsc/fact_list+predicted','edit','F','/vhr/hsc/fact+edit','S','O');
uis.action('/vhr/hsc/fact_list+predicted','import','F','/vhr/hsc/fact_import','S','O');
uis.action('/vhr/hsc/fact_list+predicted','predict','F','/vhr/hsc/fact_predict','S','O');


uis.ready('/vhr/hsc/fact_list+predicted','.add.delete.edit.import.model.predict.');
uis.ready('/vhr/hsc/fact_list+actual','.add_actual.delete.dynamic_import.edit.import.model.');

commit;
end;
/
