----------------------------------------------------------------------------------------------------
create table zk_datas(
  data_id    number(20) not null,
  request    varchar2(4000),
  data_text  clob,
  constraint zk_datas_pk primary key (data_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create sequence zk_datas_sq;
----------------------------------------------------------------------------------------------------
create or replace procedure insert_data(i_request varchar2, i_data clob) is
pragma autonomous_transaction;
begin
  insert into Zk_Datas
    (Data_Id, Request, Data_Text)
  values
    (Zk_Datas_Sq.Nextval, i_Request, i_Data);
  commit;

exception
  when others then
    rollback;
end;
/
