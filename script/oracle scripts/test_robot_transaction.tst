PL/SQL Developer Test script 3.0
45
-- Created on 4/13/2022 by ADHAM 
declare
  -- Local variables here
  i            integer;
  v_Company_Id number := 1;
  v_Filial_Id  number := 2;
  v_Robot_Id   number := 3;
begin
  -- open robot;

  Hpd_Demo.Robot_Open(i_Company_Id => v_Company_Id,
                      i_Filial_Id  => v_Filial_Id,
                      i_Robot_Id   => v_Robot_Id,
                      i_Open_Date  => '01.01.2022');

  Hpd_Demo.Robot_Occupy(i_Company_Id  => v_Company_Id,
                        i_Filial_Id   => v_Filial_Id,
                        i_Robot_Id    => v_Robot_Id,
                        i_Occupy_Date => '10.01.2022',
                        i_Fte         => 0.5);

  Hpd_Demo.Robot_Occupy(i_Company_Id  => v_Company_Id,
                        i_Filial_Id   => v_Filial_Id,
                        i_Robot_Id    => v_Robot_Id,
                        i_Occupy_Date => '15.01.2022',
                        i_Fte         => 0.5);

  Hpd_Demo.Robot_Unoccupy(i_Company_Id  => v_Company_Id,
                          i_Filial_Id   => v_Filial_Id,
                          i_Robot_Id    => v_Robot_Id,
                          i_Occupy_Date => '20.01.2022',
                          i_Fte         => 0.5);

  Hpd_Demo.Robot_Unoccupy(i_Company_Id  => v_Company_Id,
                          i_Filial_Id   => v_Filial_Id,
                          i_Robot_Id    => v_Robot_Id,
                          i_Occupy_Date => '31.01.2022',
                          i_Fte         => 0.5);

  Hpd_Demo.Robot_Close(i_Company_Id => v_Company_Id,
                       i_Filial_Id  => v_Filial_Id,
                       i_Robot_Id   => v_Robot_Id,
                       i_Close_Date => '01.02.2022');

end;
0
0
