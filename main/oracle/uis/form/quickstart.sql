set define off
declare
begin
delete md_quickstart_headings t where t.project_code = 'vhr';
----------------------------------------------------------------------------------------------------
dbms_output.put_line('==== Quick start ====');
uis.quickstart_heading(6,'vhr','Verifix',1);
uis.quickstart_step(44,6,'Oragnization',1,'/anor/mr/filial+add');
uis.quickstart_step(45,6,'Setting',2,'/vhr/hrm/settings');
uis.quickstart_step(46,6,'Division',3,'/vhr/hrm/division+add');
uis.quickstart_step(47,6,'Job',4,'/anor/mhr/job+add');
uis.quickstart_step(48,6,'Rank',5,'/anor/mhr/rank+add');
uis.quickstart_step(49,6,'Position',6,'/vhr/hrm/robot+add');
uis.quickstart_step(50,6,'Schedule',7,'/vhr/htt/schedule+add');
uis.quickstart_step(51,6,'Location',8,'/vhr/htt/location+add');
uis.quickstart_step(53,6,'Employee',9,'/vhr/href/employee/employee_add');
uis.quickstart_step(54,6,'Hiring',10,'/vhr/hpd/journal_list');
commit;
end;
/
