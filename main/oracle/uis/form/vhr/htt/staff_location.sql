set define off
prompt PATH /vhr/htt/staff_location
begin
uis.route('/vhr/htt/staff_location$attach','Ui_Vhr234.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_location$detach','Ui_Vhr234.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_location:locations','Ui_Vhr234.Query_Locations','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/staff_location:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/htt/staff_location','vhr234');
uis.form('/vhr/htt/staff_location','/vhr/htt/staff_location','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/staff_location','attach','F',null,null,'A');
uis.action('/vhr/htt/staff_location','detach','F',null,null,'A');


uis.ready('/vhr/htt/staff_location','.attach.detach.model.');

commit;
end;
/
