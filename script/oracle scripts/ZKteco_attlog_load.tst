PL/SQL Developer Test script 3.0
15
-- Created on 6/8/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  for r in (select *
              from Hzk_Devices q
             where q.Device_Id = 4)
  loop
    Hzk_External.Send_Command(i_Company_Id => r.Company_Id,
                              i_Device_Id  => r.Device_Id,
                              i_Command    => 'DATA QUERY ATTLOG StartTime=2023-08-01 00:00:00 EndTime=2023-08-31 17:47:54');
  end loop;
end;
0
0
