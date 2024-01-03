set define off
declare
begin
delete mt_project_tapes t where t.project_code = 'vhr';
----------------------------------------------------------------------------------------------------
dbms_output.put_line('==== Project tapes ====');
uis.project_tape('vhr','save_input');
commit;
end;
/
