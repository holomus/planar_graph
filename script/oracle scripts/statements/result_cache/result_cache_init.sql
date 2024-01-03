prompt result_cache testing
----------------------------------------------------------------------------------------------------
drop table rs_data;

----------------------------------------------------------------------------------------------------
create table rs_data(
 id1          number(20)         not null,
 id2          number(20)         not null,
 id3          number(20)         not null,
 name         varchar2(100 char) not null,
 code         varchar2(50),
 constraint rs_data_pk primary key (id1, id2, id3)
);

----------------------------------------------------------------------------------------------------
insert into rs_data
values (0, 100, 1, 'data1', 'code1');

insert into rs_data
values (0, 100, 2, 'data2', null);

insert into rs_data
values (0, 100, 3, 'data3', 'code3');

insert into rs_data
values (100, 200, 4, 'data4', 'code1');

insert into rs_data
values (100, 300, 5, 'data5', 'code1');

commit;
----------------------------------------------------------------------------------------------------
create or replace package Rs_Pk1 is
  ----------------------------------------------------------------------------------------------------
  Function Rs_Data_Name
  (
    i_Id1 number,
    i_Id2 number,
    i_Id3 number
  ) return varchar2 Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Rs_Data_Name_Relies
  (
    i_Id1 number,
    i_Id2 number,
    i_Id3 number
  ) return varchar2 Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Rs_Data_Row
  (
    i_Id3  number,
    i_Code varchar2 := null
  ) return Rs_Data%rowtype Result_Cache;
end Rs_Pk1;
/

create or replace package body Rs_Pk1 is
  ----------------------------------------------------------------------------------------------------
  Function Rs_Data_Name
  (
    i_Id1 number,
    i_Id2 number,
    i_Id3 number
  ) return varchar2 Result_Cache is
    v_Name Rs_Data.Name%type;
  begin
    Dbms_Output.Put_Line(b.Message('taking name for id1=$1, id2=$2, id3=$3',
                                   Array_Varchar2(i_Id1, i_Id2, i_Id3)));
  
    select d.Name
      into v_Name
      from Rs_Data d
     where d.Id1 = i_Id1
       and d.Id2 = i_Id2
       and d.Id3 = i_Id3;
  
    return v_Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Rs_Data_Name_Relies
  (
    i_Id1 number,
    i_Id2 number,
    i_Id3 number
  ) return varchar2 Result_Cache Relies_On(Rs_Data) is
    v_Name Rs_Data.Name%type;
  begin
    Dbms_Output.Put_Line(b.Message('taking name for id1=$1, id2=$2, id3=$3',
                                   Array_Varchar2(i_Id1, i_Id2, i_Id3)));
  
    select d.Name
      into v_Name
      from Rs_Data d
     where d.Id1 = i_Id1
       and d.Id2 = i_Id2
       and d.Id3 = i_Id3;
  
    return v_Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Rs_Data_Row
  (
    i_Id3  number,
    i_Code varchar2 := null
  ) return Rs_Data%rowtype Result_Cache is
    r Rs_Data%rowtype;
  begin
    Dbms_Output.Put_Line(b.Message('taking row for id3=$1, code=$2',
                                   Array_Varchar2(i_Id3, i_Code)));
  
    select d.*
      into r
      from Rs_Data d
     where d.Id3 = i_Id3
       and (i_Code is null or d.Code = i_Code);
  
    return r;
  end;

end Rs_Pk1;
/
