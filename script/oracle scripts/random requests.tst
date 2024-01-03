PL/SQL Developer Test script 3.0
78
-- Created on 25.12.2021 by SANJAR 
declare
  c_Company_Id number := 0;
  c_Filial_Id  number := 104;

  c_Request_Kind_Id number := 1;

  c_Staff_Id_Start number := 3;
  c_Staff_Id_Stop  number := 3;

  c_Min_Date date := '01.03.2022';
  c_Max_Date date := '01.04.2022';

  r_Request Htt_Requests%rowtype;
  v_Begins  Array_Date;
  v_Ends    Array_Date;
  v_Begin   date;
  v_End     date;
begin
  Ui_Auth.Logon_As_System(c_Company_Id);

  for r in (select *
              from Href_Staffs s
             where s.Company_Id = c_Company_Id
               and s.Filial_Id = c_Filial_Id
               and s.Staff_Id between c_Staff_Id_Start and c_Staff_Id_Stop)
  loop
    with Test as
     (select c_Min_Date Min_Date, c_Max_Date Max_Date
        from Dual)
    select Min_Date + level - 1 + Dbms_Random.Value(0.25, 0.5) New_Date
      bulk collect
      into v_Begins
      from Test
    connect by level <= Max_Date - Min_Date;
  
    with Test as
     (select c_Min_Date Min_Date, c_Max_Date Max_Date
        from Dual)
    select Min_Date + level - 1 + Dbms_Random.Value(0.5, 0.75) New_Date
      bulk collect
      into v_Ends
      from Test
    connect by level <= Max_Date - Min_Date;
  
    for i in 1 .. v_Begins.Count
    loop
      v_Begin := v_Begins(i);
      v_End   := v_Ends(i);
    
      z_Htt_Requests.Init(p_Row             => r_Request,
                          i_Company_Id      => c_Company_Id,
                          i_Filial_Id       => c_Filial_Id,
                          i_Request_Id      => Htt_Next.Request_Id,
                          i_Request_Kind_Id => c_Request_Kind_Id,
                          i_Staff_Id        => r.Staff_Id,
                          i_Begin_Time      => v_Begin,
                          i_End_Time        => v_End,
                          i_Request_Type    => Htt_Pref.c_Request_Type_Part_Of_Day,
                          i_Manager_Note    => null,
                          i_Note            => null,
                          i_Status          => Htt_Pref.c_Request_Status_New);
    
      Htt_Api.Request_Save(r_Request);
    
      Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                              i_Filial_Id    => r_Request.Filial_Id,
                              i_Request_Id   => r_Request.Request_Id,
                              i_Manager_Note => null);
    
      Htt_Api.Request_Complete(i_Company_Id => r_Request.Company_Id,
                               i_Filial_Id  => r_Request.Filial_Id,
                               i_Request_Id => r_Request.Request_Id);
    end loop;
  end loop;

  commit;
end;
0
0
