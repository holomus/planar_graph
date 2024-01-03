set define off
prompt PATH /vhr/intro/transfers
begin
uis.route('/vhr/intro/transfers:model','Ui_Vhr145.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/intro/transfers:save_staffing_chart_type','Ui_Vhr145.Save_Staffing_Chart_Type','M','M','A',null,null,null,null);

uis.path('/vhr/intro/transfers','vhr145');
uis.form('/vhr/intro/transfers','/vhr/intro/transfers','F','A','F','HM','M','N',null,'N');





uis.ready('/vhr/intro/transfers','.model.');

commit;
end;
/
