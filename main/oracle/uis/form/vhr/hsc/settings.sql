set define off
prompt PATH /vhr/hsc/settings
begin
uis.route('/vhr/hsc/settings:division_groups','Ui_Vhr496.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/settings:model','Ui_Vhr496.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/settings:save','Ui_Vhr496.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/hsc/settings','vhr496');
uis.form('/vhr/hsc/settings','/vhr/hsc/settings','F','A','F','HM','M','N',null,null);





uis.ready('/vhr/hsc/settings','.model.');

commit;
end;
/
