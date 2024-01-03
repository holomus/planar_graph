alter table Hpd_Trans_Robots add division_id number(20);
alter table hpd_trans_robots add job_id      number(20);

update hpd_trans_robots q
   set q.division_id = (select w.division_id from mrf_robots w where w.robot_id = q.robot_id),
       q.job_id      = (select w.job_id from mrf_robots w where w.robot_id = q.robot_id);
       
alter table hpd_trans_robots modify division_id not null;       
alter table hpd_trans_robots modify job_id not null;
