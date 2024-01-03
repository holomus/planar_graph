prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt hpr_charges modify robot_id not null
----------------------------------------------------------------------------------------------------
alter table hpr_charges modify robot_id number(20) not null;

-- use on error
/*delete Hpr_Charges p
 where p.Status = 'N'
   and p.Amount = 0
   and p.Robot_Id is null;
commit;*/
