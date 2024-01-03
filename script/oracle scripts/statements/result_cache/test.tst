PL/SQL Developer Test script 3.0
139
declare
  r_Data Rs_Data%rowtype;
  v_Name Rs_Data.Name%type;
begin
  Dbms_Output.Put_Line('----------------------------------------------------------------------------------------------------');
  Dbms_Output.Put_Line('rs test 1');
  Dbms_Output.Put_Line('----------------------------------------------------------------------------------------------------');

  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);
  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);

  Dbms_Output.Put_Line('Name for 0 100 2');
  v_Name := Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2);

  Dbms_Output.Put_Line('Name for 0 100 2');
  select Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2)
    into v_Name
    from Dual;

  Dbms_Output.Put_Line('Name for 0 100 2');
  select Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2)
    into v_Name
    from Dual;

  Dbms_Output.Put_Line('update code of 0 100 1 ');

  update Rs_Data
     set Code = 'code11'
   where Id1 = 0
     and Id2 = 100
     and Id3 = 1;
  commit;

  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);

  Dbms_Output.Put_Line('Name for 0 100 2');
  v_Name := Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2);

  Dbms_Output.Put_Line('Name for 0 100 1');
  select Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1)
    into v_Name
    from Dual;

  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);

  Dbms_Output.Put_Line('Name for 0 100 1');
  select Rs_Pk1.Rs_Data_Name(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1)
    into v_Name
    from Dual;

  --------------------------------------------------
  Dbms_Output.Put_Line('----------------------------------------------------------------------------------------------------');
  Dbms_Output.Put_Line('rs test 2');
  Dbms_Output.Put_Line('----------------------------------------------------------------------------------------------------');

  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);
  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);

  Dbms_Output.Put_Line('Name for 0 100 2');
  v_Name := Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2);

  Dbms_Output.Put_Line('Name for 0 100 2');
  select Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2)
    into v_Name
    from Dual;

  Dbms_Output.Put_Line('Name for 0 100 2');
  select Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2)
    into v_Name
    from Dual;

  Dbms_Output.Put_Line('update code of 0 100 1 ');

  update Rs_Data
     set Code = 'code1'
   where Id1 = 0
     and Id2 = 100
     and Id3 = 1;
  commit;

  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);

  Dbms_Output.Put_Line('Name for 0 100 2');
  v_Name := Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 2);

  Dbms_Output.Put_Line('Name for 0 100 1');
  select Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1)
    into v_Name
    from Dual;

  Dbms_Output.Put_Line('Name for 0 100 1');
  v_Name := Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1);

  Dbms_Output.Put_Line('Name for 0 100 1');
  select Rs_Pk1.Rs_Data_Name_Relies(i_Id1 => 0, i_Id2 => 100, i_Id3 => 1)
    into v_Name
    from Dual;

  --------------------------------------------------
  Dbms_Output.Put_Line('----------------------------------------------------------------------------------------------------');
  Dbms_Output.Put_Line('rs test 3 with row');
  Dbms_Output.Put_Line('----------------------------------------------------------------------------------------------------');

  Dbms_Output.Put_Line('Row for 1 code1');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 1, i_Code => 'code1');
  Dbms_Output.Put_Line('Row for 1 code1');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 1, i_Code => 'code1');

  Dbms_Output.Put_Line('Row for 2 null');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 2, i_Code => null);

  Dbms_Output.Put_Line('Row for 2 null');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 2, i_Code => null);

  Dbms_Output.Put_Line('update code of 1 code1 ');

  update Rs_Data
     set Code = 'code11'
   where Id1 = 0
     and Id2 = 100
     and Id3 = 1;
  commit;

  Dbms_Output.Put_Line('Row for 1 code11');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 1, i_Code => 'code11');

  Dbms_Output.Put_Line('Row for 2 null');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 2, i_Code => null);

  Dbms_Output.Put_Line('Row for 1 code11');
  r_Data := Rs_Pk1.Rs_Data_Row(i_Id3 => 1, i_Code => 'code11');
end;
0
0
