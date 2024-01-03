PL/SQL Developer Test script 3.0
58
-- Created on 11.12.2021 by SANJAR 
declare
  -- Local variables here
  c_Company_Id number := 121;
  c_Filial_Id  number := 2769;
  c_First_Name varchar2(100) := 'Template Name';

  v_Employee        Href_Pref.Employee_Rt;
  v_Person          Href_Pref.Person_Rt;
  r_User            Md_Users%rowtype;
  v_Person_Identity Htt_Pref.Person_Rt;
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(c_Company_Id);
  for i in 1 .. 10000
  loop
    Href_Util.Person_New(o_Person        => v_Person,
                         i_Company_Id    => c_Company_Id,
                         i_Person_Id     => Md_Next.Person_Id,
                         i_First_Name    => c_First_Name,
                         i_Last_Name     => '#' || i,
                         i_Middle_Name   => null,
                         i_Gender        => Md_Pref.c_Pg_Male,
                         i_Birthday      => Trunc(sysdate),
                         i_Photo_Sha     => null,
                         i_Tin           => null,
                         i_Iapa          => null,
                         i_Npin          => null,
                         i_Region_Id     => null,
                         i_Main_Phone    => null,
                         i_Email         => null,
                         i_Address       => null,
                         i_Legal_Address => null,
                         i_Key_Person    => 'N',
                         i_State         => 'A',
                         i_Code          => null);
  
    v_Employee.Person    := v_Person;
    v_Employee.Filial_Id := c_Filial_Id;
    v_Employee.State     := 'A';
  
    Href_Api.Employee_Save(v_Employee);
  
    r_User.Company_Id := c_Company_Id;
    r_User.User_Id    := v_Person.Person_Id;
    r_User.Name       := v_Person.First_Name;
    r_User.User_Kind  := Md_Pref.c_Uk_Normal;
    r_User.Gender     := v_Person.Gender;
    r_User.State      := v_Person.State;
  
    Md_Api.User_Save(r_User);
  
    Dbms_Application_Info.Set_Module('inserting persons', i || '/' || 10000 || ' persons');
  
  end loop;
  Biruni_Route.Context_End;
  commit;
end;
0
0
