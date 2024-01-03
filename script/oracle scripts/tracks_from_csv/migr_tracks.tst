PL/SQL Developer Test script 3.0
134
-- Created on 03.01.2024 by SANJAR.AXMEDOV 
declare
  v_Company_Id number := 100;
  v_Filial_Id  number := 143;

  r_Track Htt_Tracks%rowtype;

  --------------------------------------------------
  Function Person_Id(i_Staff_Name varchar2) return number is
    result number;
  begin
    select q.Person_Id
      into result
      from Mr_Natural_Persons q
     where q.Company_Id = v_Company_Id
       and Upper(q.Name) = Upper(i_Staff_Name);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  --------------------------------------------------
  Procedure Migr_Tracks_Csv(i_Tracks clob) is
    v_Track_Arr Array_Varchar2;
  
    v_Len       number;
    v_Pos       pls_integer;
    v_Last_Pos  pls_integer;
    v_Part_Data varchar2(32767);
  
    v_Offset           number;
    v_Character_Amount number := 10000;
  
    c_Row_Delimiter    varchar(1) := Chr(10);
    c_Column_Delimiter varchar2(1) := ',';
  
    v_Commit_Threshold number := 10000;
    v_Uncommit_Tracks  number := 0;
  begin
  
    v_Offset := 1;
    v_Len    := Dbms_Lob.Getlength(i_Tracks);
  
    while v_Offset < v_Len
    loop
      v_Part_Data := v_Part_Data || Dbms_Lob.Substr(Lob_Loc => i_Tracks,
                                                    Amount  => v_Character_Amount,
                                                    Offset  => v_Offset);
    
      v_Pos      := 1;
      v_Last_Pos := 1;
    
      loop
        v_Pos := Instr(v_Part_Data, c_Row_Delimiter, v_Last_Pos);
      
        Dbms_Application_Info.Set_Module(Module_Name => 'migr_tracks: ' || v_Offset || '/' || v_Len,
                                         Action_Name => 'part: ' || v_Pos || '/' ||
                                                        Length(v_Part_Data));
      
        if v_Pos > 0 then
          v_Track_Arr := Fazo.Split(Substr(v_Part_Data, v_Last_Pos, v_Pos - v_Last_Pos),
                                    c_Column_Delimiter);
        
          if v_Track_Arr.Count < 5 then
            continue;
          end if;
        
          insert into Migr_Csv_Tracks
            (Track_Date,
             Full_Name,
             Track_Type,
             Track_Time,
             Location_Name,
             Pin,
             Person_Id,
             Track_Id)
          values
            (v_Track_Arr(1),
             v_Track_Arr(2),
             v_Track_Arr(3),
             v_Track_Arr(4),
             v_Track_Arr(5),
             null,
             null,
             Migr_Csv_Tracks_Sq.Nextval);
        
          v_Uncommit_Tracks := v_Uncommit_Tracks + 1;
        
          if v_Uncommit_Tracks > v_Commit_Threshold then
            commit;
            v_Uncommit_Tracks := 0;
          end if;
        else
          v_Part_Data := Substr(v_Part_Data, v_Last_Pos);
          exit;
        end if;
      
        v_Last_Pos := v_Pos + Length(c_Row_Delimiter);
      end loop;
    
      v_Offset := v_Offset + v_Character_Amount;
    end loop;
  
    if v_Part_Data is not null then
      v_Track_Arr := Fazo.Split(Substr(v_Part_Data, v_Last_Pos, v_Pos - v_Last_Pos),
                                c_Column_Delimiter);
    
      if v_Track_Arr.Count >= 5 then
        insert into Migr_Csv_Tracks
          (Track_Date, Full_Name, Track_Type, Track_Time, Location_Name, Pin, Person_Id, Track_Id)
        values
          (v_Track_Arr(1),
           v_Track_Arr(2),
           v_Track_Arr(3),
           v_Track_Arr(4),
           v_Track_Arr(5),
           null,
           null,
           Migr_Csv_Tracks_Sq.Nextval);
      end if;
    end if;
  
    commit;
  end;

begin
  for r in (select *
              from Migr_Csv_Data q)
  loop
    Migr_Tracks_Csv(r.Data);
  end loop;
end;
0
0
