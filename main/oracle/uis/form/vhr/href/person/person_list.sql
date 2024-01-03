set define off
prompt PATH /vhr/href/person/person_list
begin
uis.route('/vhr/href/person/person_list$change_state','Ui_Vhr14.Change_State','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_list$delete','Ui_Vhr14.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_list$detach','Ui_Vhr14.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_list+attach$attach','Ui_Vhr14.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_list+attach:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/person/person_list+attach:table','Ui_Vhr14.Detached_Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_list+attach_employee$attach','Ui_Vhr14.Attach_Employee','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_list+attach_employee:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/person/person_list+attach_employee:table','Ui_Vhr14.Detached_Employee_Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/person/person_list:table','Ui_Vhr14.Attached_Query','M','Q','A',null,null,null,null);

uis.path('/vhr/href/person/person_list','vhr14');
uis.form('/vhr/href/person/person_list','/vhr/href/person/person_list','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/person/person_list+attach','/vhr/href/person/person_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/href/person/person_list+attach_employee','/vhr/href/person/person_list','F','A','F','H','M','N',null,'N');

uis.override_form('/anor/mr/person/natural_person_list','vhr','/vhr/href/person/person_list');


uis.action('/vhr/href/person/person_list','add','A','/vhr/href/person/person_add','S','O');
uis.action('/vhr/href/person/person_list','change_state','A',null,null,'A');
uis.action('/vhr/href/person/person_list','delete','A',null,null,'A');
uis.action('/vhr/href/person/person_list','detach','F',null,null,'A');
uis.action('/vhr/href/person/person_list','edit','A','/vhr/href/person/person_edit','S','O');
uis.action('/vhr/href/person/person_list','open_attach','F','/vhr/href/person/person_list+attach','S','O');
uis.action('/vhr/href/person/person_list+attach','attach','F',null,null,'A');
uis.action('/vhr/href/person/person_list+attach_employee','attach','F',null,null,'A');


uis.ready('/vhr/href/person/person_list','.add.change_state.delete.detach.edit.model.open_attach.');
uis.ready('/vhr/href/person/person_list+attach','.attach.model.');
uis.ready('/vhr/href/person/person_list+attach_employee','.attach.model.');

commit;
end;
/
