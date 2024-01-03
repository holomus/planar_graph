drop table data_log;
create table data_log(
  id number not null,
  kind_text varchar2(1) not null,
  vpath varchar2(4000),
  vquery varchar2(4000),
  val clob,
  created_on date
);
drop sequence data_log_sq;
create sequence data_log_sq;
drop procedure insert_data;
create or replace Procedure Insert_Data
(
  i_Kind   varchar2,
  i_Vpath  varchar2,
  i_Vquery varchar2,
  Val      clob
) is
  pragma autonomous_transaction;
begin
  insert into Data_Log
    (Id, Kind_Text, Vpath, Vquery, Val, Created_On)
  values
    (Data_Log_Sq.Nextval, i_Kind, i_Vpath, i_Vquery, Val, sysdate);

  commit;
end;
/
