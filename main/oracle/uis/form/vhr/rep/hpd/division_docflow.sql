set define off
prompt PATH /vhr/rep/hpd/division_docflow
begin
uis.route('/vhr/rep/hpd/division_docflow:model','Ui_Vhr295.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpd/division_docflow:run','Ui_Vhr295.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/division_docflow','vhr295');
uis.form('/vhr/rep/hpd/division_docflow','/vhr/rep/hpd/division_docflow','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hpd/division_docflow','.model.');

commit;
end;
/
