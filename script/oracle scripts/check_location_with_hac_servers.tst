PL/SQL Developer Test script 3.0
47
-- Created on 9/8/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  i             integer;
  v_Arr         Json_Array_t;
  v_Obj         Json_Object_t;
  v_Company_Id  number := 1700;
  v_Location_Id number := 43588;
  v_Filial_Id   number := 72983;
  v_Cnt         number := 0;
  v_Person_Id   number;
  v_Person_Code varchar2(100);
begin
  -- Test statements here
  v_Arr := Json_Array_t(:Office);
  for i in 0 .. v_Arr.Get_Size - 1
  loop
    v_Obj         := Treat(v_Arr.Get(i) as Json_Object_t);
    v_Person_Code := v_Obj.Get_String('id');
  
    begin
      select q.Person_Id
        into v_Person_Id
        from Hac_Server_Persons q
       where q.Company_Id = v_Company_Id
         and q.Server_Id = 21
         and q.Person_Code = v_Person_Code;
    
      if not z_Htt_Location_Persons.Exist(i_Company_Id  => v_Company_Id,
                                          i_Filial_Id   => v_Filial_Id,
                                          i_Location_Id => v_Location_Id,
                                          i_Person_Id   => v_Person_Id) then
        v_Cnt := v_Cnt + 1;
        z_Htt_Location_Persons.Insert_Try(i_Company_Id  => v_Company_Id,
                                          i_Filial_Id   => v_Filial_Id,
                                          i_Location_Id => v_Location_Id,
                                          i_Person_Id   => v_Person_Id,
                                          i_Attach_Type => 'M');
      end if;
    exception
      when No_Data_Found then
        Dbms_Output.Put_Line(v_Person_Code);
    end;
  end loop;
  :Res := v_Cnt;

end;
2
Office
1
<CLOB>
4208
Res
1
1
5
0
