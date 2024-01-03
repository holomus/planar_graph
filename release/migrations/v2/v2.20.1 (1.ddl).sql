prompt migr from 16.03.2023 v2.20.1 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt change billz api structure for new route
----------------------------------------------------------------------------------------------------
drop table hes_billz_consolidated_sales;
drop table hes_billz_raw_sales;
drop sequence hes_billz_consolidated_sales_sq;

----------------------------------------------------------------------------------------------------
create table hes_billz_consolidated_sales(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  sale_id                         number(20)         not null,
  billz_office_id                 number(20)         not null,
  billz_office_name               varchar2(500 char) not null,
  billz_seller_id                 number(20)         not null,
  billz_seller_name               varchar2(500 char) not null,
  sale_date                       date               not null,
  sale_amount                     number(20, 6),
  constraint hes_billz_consolidated_sales_pk primary key (company_id, filial_id, sale_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

comment on table hes_billz_consolidated_sales is 'consolidated daily sales amount for each user from Billz';

----------------------------------------------------------------------------------------------------    
create global temporary table hes_billz_raw_sales(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  billz_office_id                 number(20)         not null,
  billz_office_name               varchar2(500 char) not null,
  billz_seller_id                 number(20)         not null,
  billz_seller_name               varchar2(500 char) not null,
  sale_date                       date               not null,
  sale_amount                     number(20, 6)
);

comment on table hes_billz_raw_sales is 'raw Billz sales data';

----------------------------------------------------------------------------------------------------
create sequence hes_billz_consolidated_sales_sq;

exec fazo_z.run('hes');
