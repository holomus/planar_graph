set define off
prompt PATH /vhr/hrm/settings
begin
uis.route('/vhr/hrm/settings:model','Ui_Vhr69.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrm/settings:save','Ui_Vhr69.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/hrm/settings','vhr69');
uis.form('/vhr/hrm/settings','/vhr/hrm/settings','F','A','F','HM','M','N',null);





uis.ready('/vhr/hrm/settings','.model.');

commit;
end;
/
