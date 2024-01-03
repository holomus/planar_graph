create or replace package Ui_Vhr505 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Companies(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Departments(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Groups(p Hashmap) return Runtime_Service;
end Ui_Vhr505;
/
create or replace package body Ui_Vhr505 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap := Fazo.Zip_Map('server_id', p.r_Number('server_id'));
    q        Fazo_Query;
  begin
    v_Query := 'select q.*,
                       w.department_code,
                       w.person_group_code
                  from md_companies q
                  left join hac_dss_company_servers w
                    on w.server_id = :server_id
                   and w.company_id = q.company_id
                 where ';
  
    if p.o_Varchar2('mode') = 'detach' then
      v_Query := v_Query || ' q.state = ''A'' and not';
    end if;
  
    v_Query := v_Query || ' exists (select 1
                               from hac_dss_company_servers w
                              where ';
  
    if p.o_Varchar2('mode') <> 'detach' then
      v_Query := v_Query || ' w.server_id = :server_id and ';
    end if;
  
    v_Query := v_Query || ' w.company_id = q.company_id)';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name', 'code', 'department_code', 'person_group_code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
    v_Server_Id   number := p.r_Number('server_id');
  begin
    for i in 1 .. v_Company_Ids.Count
    loop
      Hac_Api.Dss_Server_Attach(i_Company_Id => v_Company_Ids(i), i_Server_Id => v_Server_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
  begin
    for i in 1 .. v_Company_Ids.Count
    loop
      Hac_Api.Dss_Server_Detach(i_Company_Id => v_Company_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Server     Hac_Servers%rowtype;
    r_Dss_Server Hac_Dss_Servers%rowtype;
    result       Hashmap;
  begin
    r_Server     := z_Hac_Servers.Load(i_Server_Id => p.r_Number('server_id'));
    r_Dss_Server := z_Hac_Dss_Servers.Load(i_Server_Id => p.r_Number('server_id'));
  
    result := z_Hac_Servers.To_Map(r_Server, z.Server_Id, z.Name, z.Host_Url, z.Order_No);
  
    Result.Put_All(z_Hac_Dss_Servers.To_Map(r_Dss_Server, z.Username, z.Password));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Company
  (
    i_Server_Id  number,
    i_Company_Id number
  ) is
    v_Company_Code Md_Companies.Code%type := z_Md_Companies.Load(i_Company_Id).Code;
    r_Company      Hac_Dss_Company_Servers%rowtype := z_Hac_Dss_Company_Servers.Load(i_Company_Id);
  
    --------------------------------------------------
    Function Get_Department_Code
    (
      i_Server_Id    number,
      i_Company_Code varchar2
    ) return Option_Varchar2 is
      result Hac_Dss_Company_Servers.Department_Code%type;
    begin
      select q.Department_Code
        into result
        from Hac_Dss_Ex_Departments q
       where q.Server_Id = i_Server_Id
         and q.Department_Name = i_Company_Code;
    
      return Option_Varchar2(result);
    exception
      when No_Data_Found then
        return null;
    end;
  
    --------------------------------------------------
    Function Get_Person_Group_Code
    (
      i_Server_Id    number,
      i_Company_Code varchar2
    ) return Option_Varchar2 is
      result Hac_Dss_Company_Servers.Person_Group_Code%type;
    begin
      select q.Person_Group_Code
        into result
        from Hac_Dss_Ex_Person_Groups q
       where q.Server_Id = i_Server_Id
         and q.Person_Group_Name = i_Company_Code;
    
      return Option_Varchar2(result);
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    if r_Company.Server_Id <> i_Server_Id then
      Hac_Error.Raise_004;
    end if;
  
    Hac_Api.Dss_Company_Server_Update(i_Company_Id        => i_Company_Id,
                                      i_Department_Code   => Get_Department_Code(i_Server_Id    => i_Server_Id,
                                                                                 i_Company_Code => v_Company_Code),
                                      i_Person_Group_Code => Get_Person_Group_Code(i_Server_Id    => i_Server_Id,
                                                                                   i_Company_Code => v_Company_Code));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Companies(p Hashmap) is
    v_Server_Id   number := p.r_Number('server_id');
    v_Company_Ids Array_Number := p.o_Array_Number('company_id');
  begin
    if v_Company_Ids is null then
      select q.Company_Id
        bulk collect
        into v_Company_Ids
        from Hac_Dss_Company_Servers q
       where q.Server_Id = v_Server_Id
         and (q.Person_Group_Code is null or q.Department_Code is null);
    end if;
  
    for i in 1 .. v_Company_Ids.Count
    loop
      Sync_Company(i_Server_Id => v_Server_Id, i_Company_Id => v_Company_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Departments(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hac.Get_Departments(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Groups(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hac.Get_Person_Groups(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null,
           State      = null;
  
    update Hac_Dss_Company_Servers
       set Company_Id        = null,
           Server_Id         = null,
           Department_Code   = null,
           Person_Group_Code = null;
  end;

end Ui_Vhr505;
/
