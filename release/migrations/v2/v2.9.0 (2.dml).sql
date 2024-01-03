prompt migr from 17.10.2022 (2.dml)
----------------------------------------------------------------------------------------------------
prompt changing wage sheets
----------------------------------------------------------------------------------------------------
update hpr_wage_sheets p
   set p.sheet_kind = 'R';
commit;

update hpr_wage_sheets p
   set p.posted = 'N'
 where p.posted is null;
commit;
   
