drop sequence dummy_test_sq;
drop table dummy_test;
drop procedure insert_dummy;
create sequence dummy_test_sq;
create table dummy_test(
  id      number(20) not null,
  user_id number(20) not null,
  created_on timestamp with local time zone not null,
  kind       varchar2(1) not null,
  data       clob,
  constraint dummy_test_pk primary key (id) using index tablespace SMARTUP_INDEX
) tablespace SMARTUP_DATA;
create or replace Procedure Insert_Dummy
(
  i_User_Id number,
  i_Kind    varchar2,
  i_Data    array_varchar2
) is
  pragma autonomous_transaction;
  v_clob clob;
begin
  v_clob := fazo.Make_Clob(i_data);
  insert into dummy_test
    (Id, User_Id, Created_On, Kind, Data)
  values
    (Dummy_Test_Sq.Nextval, i_User_Id, Current_Timestamp, i_Kind, v_clob);
  commit;
exception
  when others then
    rollback;
end;
/
