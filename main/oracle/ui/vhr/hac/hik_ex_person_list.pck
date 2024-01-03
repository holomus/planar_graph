create or replace package Ui_Vhr590 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Hik_Persons(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Persons(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Person_Photo_Response(i_Photo_Sha varchar2);
  ----------------------------------------------------------------------------------------------------
  Function Load_Person_Photo(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Match_Person(p Hashmap);
end Ui_Vhr590;
/
create or replace package body Ui_Vhr590 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id         number;
  g_Organization_Code varchar2(300 char);
  g_Person_Code       varchar2(300 char);

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals
  (
    i_Server_Id         number := null,
    i_Organization_Code varchar2 := null,
    i_Person_Code       varchar2 := null
  ) is
  begin
    g_Server_Id         := i_Server_Id;
    g_Organization_Code := i_Organization_Code;
    g_Person_Code       := i_Person_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Hik_Persons(p Hashmap) return Fazo_Query is
    r_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Load(p.r_Number('company_id'));
    q         Fazo_Query;
  begin
    if r_Company.Organization_Code is null then
      Hac_Error.Raise_005;
    end if;
  
    q := Fazo_Query('select dp.*, sp.person_id
                       from hac_hik_ex_persons dp
                       left join hac_server_persons sp
                         on sp.server_id = :server_id
                        and sp.company_id = :company_id
                        and sp.person_code = dp.person_code
                      where dp.server_id = :server_id
                        and dp.organization_code = :organization_code',
                    Fazo.Zip_Map('server_id',
                                 r_Company.Server_Id,
                                 'company_id',
                                 r_Company.Company_Id,
                                 'organization_code',
                                 r_Company.Organization_Code));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('person_code',
                     'external_code',
                     'photo_sha',
                     'extra_info',
                     'photo_url',
                     'first_name',
                     'last_name',
                     'rfid_code');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Persons(p Hashmap) return Fazo_Query is
    r_Company Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Load(p.r_Number('company_id'));
    q         Fazo_Query;
  begin
    q := Fazo_Query('select k.person_id, 
                            k.name, 
                            k.first_name, 
                            k.last_name, 
                            q.photo_sha,
                            p.person_code
                       from mr_natural_persons k
                       join md_persons q
                         on q.company_id = k.company_id
                        and q.person_id = k.person_id
                       left join hac_server_persons p
                         on p.company_id = :company_id
                        and p.server_id = :server_id
                        and p.person_id = k.person_id
                      where k.company_id = :company_id
                        and k.state = ''A''',
                    Fazo.Zip_Map('company_id',
                                 r_Company.Company_Id,
                                 'server_id',
                                 r_Company.Server_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name', 'last_name', 'first_name', 'person_code', 'photo_sha');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    r_Company      Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Load(p.r_Number('company_id'));
    v_Person_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('person_code'));
  begin
    for i in 1 .. v_Person_Codes.Count
    loop
      z_Hac_Hik_Ex_Persons.Delete_One(i_Server_Id         => r_Company.Server_Id,
                                      i_Organization_Code => r_Company.Organization_Code,
                                      i_Person_Code       => v_Person_Codes(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Person_Photo_Response(i_Photo_Sha varchar2) is
  begin
    z_Hac_Hik_Ex_Persons.Update_One(i_Server_Id         => g_Server_Id,
                                    i_Organization_Code => g_Organization_Code,
                                    i_Person_Code       => g_Person_Code,
                                    i_Photo_Sha         => Option_Varchar2(i_Photo_Sha));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Person_Photo(p Hashmap) return Runtime_Service is
    r_Company    Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Load(p.r_Number('company_id'));
    v_Host_Url   Hac_Servers.Host_Url%type;
    r_Hik_Server Hac_Hik_Servers%rowtype;
    v_Data       Json_Object_t := Json_Object_t();
  begin
    if r_Company.Organization_Code is null then
      Hac_Error.Raise_005;
    end if;
  
    Init_Globals(i_Server_Id         => r_Company.Server_Id,
                 i_Organization_Code => r_Company.Organization_Code,
                 i_Person_Code       => p.r_Varchar2('person_code'));
  
    v_Host_Url   := z_Hac_Servers.Load(i_Server_Id => g_Server_Id).Host_Url;
    r_Hik_Server := z_Hac_Hik_Servers.Load(i_Server_Id => g_Server_Id);
  
    v_Data.Put('personId', g_Person_Code);
    v_Data.Put('picUri', p.r_Varchar2('photo_url'));
  
    return Hac_Core.Build_Hik_Runtime_Service(i_Host_Url           => v_Host_Url,
                                              i_Partner_Key        => r_Hik_Server.Partner_Key,
                                              i_Partner_Secret     => r_Hik_Server.Partner_Secret,
                                              i_Request_Path       => Hac_Pref.c_Hik_Request_Path_Get_Person_Photo,
                                              i_Data               => v_Data,
                                              i_Response_Procedure => 'ui_vhr590.load_person_photo_response',
                                              i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Varchar2,
                                              i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Match_Person(p Hashmap) is
    r_Company   Hac_Hik_Company_Servers%rowtype := z_Hac_Hik_Company_Servers.Load(p.r_Number('company_id'));
    v_Photo_Sha varchar2(64) := p.o_Varchar2('photo_sha');
    v_Rfid_Code varchar2(20) := p.o_Varchar2('rfid_code');
    v_Person_Id number := p.r_Number('person_id');
  begin
    Ui_Context.Init_Migr(i_Company_Id   => r_Company.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r_Company.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r_Company.Company_Id),
                         i_Project_Code => Verifix.Project_Code);
  
    Hac_Api.Person_Save(i_Server_Id     => r_Company.Server_Id,
                        i_Company_Id    => r_Company.Company_Id,
                        i_Person_Id     => v_Person_Id,
                        i_Person_Code   => p.r_Varchar2('person_code'),
                        i_External_Code => p.r_Varchar2('external_code'));
  
    if v_Photo_Sha is not null then
      Htt_Api.Person_Save_Photo(i_Company_Id => r_Company.Company_Id,
                                i_Person_Id  => v_Person_Id,
                                i_Photo_Sha  => v_Photo_Sha,
                                i_Is_Main    => 'N');
    end if;
  
    if v_Rfid_Code is not null then
      if z_Htt_Persons.Exist(i_Company_Id => r_Company.Company_Id, i_Person_Id => v_Person_Id) then
        z_Htt_Persons.Update_One(i_Company_Id => r_Company.Company_Id,
                                 i_Person_Id  => v_Person_Id,
                                 i_Rfid_Code  => Option_Varchar2(v_Rfid_Code));
      else
        z_Htt_Persons.Insert_One(i_Company_Id => r_Company.Company_Id,
                                 i_Person_Id  => v_Person_Id,
                                 i_Rfid_Code  => v_Rfid_Code);
      end if;
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           First_Name = null,
           Last_Name  = null,
           State      = null;
  
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           Photo_Sha  = null;
  
    update Hac_Hik_Ex_Persons
       set Server_Id         = null,
           Organization_Code = null,
           Person_Code       = null,
           First_Name        = null,
           Last_Name         = null,
           Photo_Url         = null,
           Photo_Sha         = null,
           Rfid_Code         = null,
           Extra_Info        = null,
           Created_On        = null,
           Modified_On       = null;
  
    update Hac_Server_Persons
       set Server_Id   = null,
           Company_Id  = null,
           Person_Id   = null,
           Person_Code = null;
  end;

end Ui_Vhr590;
/
