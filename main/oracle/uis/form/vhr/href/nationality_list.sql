set define off
prompt PATH /vhr/href/nationality_list
begin
uis.route('/vhr/href/nationality_list$delete','Ui_Vhr449.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/nationality_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/nationality_list:table','Ui_Vhr449.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/nationality_list','vhr449');
uis.form('/vhr/href/nationality_list','/vhr/href/nationality_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/nationality_list','add','A','/vhr/href/nationality+add','S','O');
uis.action('/vhr/href/nationality_list','delete','A',null,null,'A');
uis.action('/vhr/href/nationality_list','edit','A','/vhr/href/nationality+edit','S','O');


uis.ready('/vhr/href/nationality_list','.add.delete.edit.model.');

commit;
end;
/
