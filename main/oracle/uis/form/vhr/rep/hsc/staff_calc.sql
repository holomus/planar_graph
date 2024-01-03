set define off
prompt PATH /vhr/rep/hsc/staff_calc
begin
uis.route('/vhr/rep/hsc/staff_calc:areas','Ui_Vhr555.Query_Areas',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/rep/hsc/staff_calc:jobs','Ui_Vhr555.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/rep/hsc/staff_calc:model','Ui_Vhr555.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/rep/hsc/staff_calc:objects','Ui_Vhr555.Query_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/rep/hsc/staff_calc:run','Ui_Vhr555.Run','M',null,'A',null,null,null,null,null);
uis.route('/vhr/rep/hsc/staff_calc:save_preferences','Ui_Vhr555.Save_Preferences','M',null,'A',null,null,null,null,null);

uis.path('/vhr/rep/hsc/staff_calc','vhr555');
uis.form('/vhr/rep/hsc/staff_calc','/vhr/rep/hsc/staff_calc','F','A','F','H','M','N',null,'N',null);




uis.form_sibling('vhr','/vhr/rep/hsc/staff_calc','/vhr/hsc/job_norm_list',1);
uis.form_sibling('vhr','/vhr/rep/hsc/staff_calc','/vhr/hsc/job_round_list',2);

uis.ready('/vhr/rep/hsc/staff_calc','.model.');

commit;
end;
/
