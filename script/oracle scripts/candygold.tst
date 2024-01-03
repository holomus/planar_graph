PL/SQL Developer Test script 3.0
122
-- Created on 8/18/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  i                 integer;
  v_Company_Id      number := 1600;
  v_Filial_Id       number := 67307;
  v_Employee        Href_Pref.Employee_Rt;
  v_Person          Href_Pref.Person_Rt;
  v_Person_Identity Htt_Pref.Person_Rt;
  r_Person          Mr_Natural_Persons%rowtype;
  v_Location_Id     number := 42122;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_User(i_Person Mr_Natural_Persons%rowtype) is
    r_Data    Md_Users%rowtype;
    v_Role_Id number;
  begin
    r_Data.Company_Id := i_Person.Company_Id;
    r_Data.User_Id    := i_Person.Person_Id;
    r_Data.User_Kind  := Md_Pref.c_Uk_Normal;
    r_Data.State      := 'A';
    r_Data.Name       := i_Person.Name;
    r_Data.Gender     := i_Person.Gender;
  
    Md_Api.User_Save(r_Data);
  
    Md_Api.User_Add_Filial(i_Company_Id => r_Data.Company_Id,
                           i_User_Id    => r_Data.User_Id,
                           i_Filial_Id  => v_Filial_Id);
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if v_Role_Id is not null then
      Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                        i_User_Id    => r_Data.User_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);
  -- Test statements here
  for r in (select *
              from Hac_Hik_Ex_Persons q
             where q.Organization_Code = 7
               and not exists (select *
                      from Hac_Server_Persons w
                     where w.Person_Code = q.Person_Code
                       and w.Company_Id = 1600))
  loop
  
    Href_Util.Person_New(o_Person               => v_Person,
                         i_Company_Id           => v_Company_Id,
                         i_Person_Id            => Md_Next.Person_Id,
                         i_First_Name           => 'Guest ' || r.Rfid_Code,
                         i_Last_Name            => null,
                         i_Middle_Name          => null,
                         i_Gender               => 'M',
                         i_Birthday             => null,
                         i_Nationality_Id       => null,
                         i_Photo_Sha            => null,
                         i_Tin                  => null,
                         i_Iapa                 => null,
                         i_Npin                 => null,
                         i_Region_Id            => null,
                         i_Main_Phone           => null,
                         i_Email                => null,
                         i_Address              => null,
                         i_Legal_Address        => null,
                         i_Key_Person           => 'N',
                         i_Access_All_Employees => 'N',
                         i_Access_Hidden_Salary => 'N',
                         i_State                => 'A',
                         i_Code                 => null);
  
    v_Employee.Person    := v_Person;
    v_Employee.Filial_Id := v_Filial_Id;
    v_Employee.State     := v_Person.State;
  
    Href_Api.Employee_Save(v_Employee);
  
    insert into Hac_Server_Persons
      (Server_Id, Company_Id, Person_Id, Person_Code, First_Name, External_Code, Rfid_Code)
    values
      (21,
       v_Company_Id,
       v_Person.Person_Id,
       r.Person_Code,
       v_Person.First_Name,
       r.External_Code,
       r.Rfid_Code);
  
    Htt_Util.Person_New(o_Person     => v_Person_Identity,
                        i_Company_Id => v_Person.Company_Id,
                        i_Person_Id  => v_Person.Person_Id,
                        i_Pin        => null,
                        i_Pin_Code   => null,
                        i_Rfid_Code  => '',
                        i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Person.Person_Id));
  
    if Htt_Util.Pin_Autogenerate(v_Person.Company_Id) = 'Y' then
      v_Person_Identity.Pin := Htt_Core.Next_Pin(v_Person.Company_Id);
    end if;
  
    Htt_Api.Person_Save(v_Person_Identity);
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => v_Person.Company_Id,
                                          i_Person_Id  => v_Person.Person_Id);
  
    Save_User(r_Person);
  
    if v_Location_Id is not null then
      Htt_Api.Location_Add_Person(i_Company_Id  => v_Company_Id,
                                  i_Filial_Id   => v_Filial_Id,
                                  i_Location_Id => v_Location_Id,
                                  i_Person_Id   => v_Person.Person_Id);
    end if;
  end loop;

  Biruni_Route.Context_End;
end;
0
0
