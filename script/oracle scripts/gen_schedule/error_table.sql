prompt create errors table
---------------------------------------------------------------------------------------------------- 
create table gen_year_errors(
  company_id    number(20)     not null,
  error_message varchar2(4000) not null
) tablespace GWS_DATA;
