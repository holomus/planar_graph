prompt migr from 09.08.2022
----------------------------------------------------------------------------------------------------
prompt adding penalty_time column 
----------------------------------------------------------------------------------------------------
alter table hpr_penalty_policies add penalty_time number(4);

alter table hpr_penalty_policies drop constraint hpr_penalty_policies_c8;

alter table hpr_penalty_policies add constraint hpr_penalty_policies_c8 check (penalty_coef is not null and penalty_coef >= 0 or 
                                            penalty_time is not null and penalty_time >= 0 or
                                           (penalty_per_time is null or penalty_per_time > 0) and
                                            penalty_amount is not null and penalty_amount >= 0);
                                               
alter table hpr_penalty_policies add constraint hpr_penalty_policies_c9 check (nvl2(penalty_coef, 1, 0) + nvl2(penalty_amount, 1, 0) + nvl2(penalty_time, 1, 0) = 1);

comment on column hpr_penalty_policies.penalty_coef     is 'Coef that multiplies penalty time: late time is 5 min, with coef 2 it will be 10 min';
comment on column hpr_penalty_policies.penalty_amount   is 'Penalty amount that will be taken from employee. It shows monetary amount';
comment on column hpr_penalty_policies.penalty_per_time is 'Penalty amount will be multiplied by number of periods from this column';
comment on column hpr_penalty_policies.penalty_time     is 'Penalty time will be set to this value: late time is 5 min, penalty time is 30 min then penalty late time is 30 min';
