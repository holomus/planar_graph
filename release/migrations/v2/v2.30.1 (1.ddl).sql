prompt checks dropped about the negativity of sales_amount and amount
---------------------------------------------------------------------------------------------------
alter table hpr_sales_bonus_payment_operations drop constraint hpr_sales_bonus_payment_operations_c5;
alter table hpr_sales_bonus_payment_operations drop constraint hpr_sales_bonus_payment_operations_c7;

alter table hpr_sales_bonus_payment_operations rename constraint hpr_sales_bonus_payment_operations_c6 to hpr_sales_bonus_payment_operations_c5;


alter table hpr_sales_bonus_payment_operation_periods drop constraint hpr_sales_bonus_payment_operation_periods_c3;
alter table hpr_sales_bonus_payment_operation_periods drop constraint hpr_sales_bonus_payment_operation_periods_c2;
