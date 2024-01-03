create or replace package Ui_Vhr472 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Modal(p Hashmap) return Hashmap;
end Ui_Vhr472;
/
create or replace package body Ui_Vhr472 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Companies(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap := Fazo.Zip_Map('server_id', p.r_Number('server_id'));
    q        Fazo_Query;
  begin
    Ui.Assert_Is_Company_Head;
  
    v_Query := 'select *
                  from md_companies q
                 where';
  
    if p.o_Varchar2('mode') = 'detach' then
      v_Query := v_Query || ' not';
    end if;
  
    v_Query := v_Query || ' exists (select 1
                               from htt_company_acms_servers w
                              where w.server_id = :server_id
                                and w.company_id = q.company_id)';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
    v_Server_Id   number := p.r_Number('server_id');
  begin
    Ui.Assert_Is_Company_Head;
  
    for i in 1 .. v_Company_Ids.Count
    loop
      Htt_Api.Acms_Server_Attach(i_Company_Id => v_Company_Ids(i), i_Server_Id => v_Server_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Company_Ids Array_Number := Fazo.Sort(p.r_Array_Number('company_id'));
  begin
    Ui.Assert_Is_Company_Head;
  
    for i in 1 .. v_Company_Ids.Count
    loop
      Htt_Api.Acms_Server_Detach(v_Company_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Modal(p Hashmap) return Hashmap is
    r_Data Htt_Acms_Servers%rowtype;
  begin
    Ui.Assert_Is_Company_Head;
  
    r_Data := z_Htt_Acms_Servers.Load(i_Server_Id => p.r_Number('server_id'));
  
    return z_Htt_Acms_Servers.To_Map(r_Data, z.Server_Id, z.Secret_Code, z.Name, z.Url, z.Order_No);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null;
  
    update Htt_Company_Acms_Servers
       set Company_Id = null,
           Server_Id  = null;
  end;

end Ui_Vhr472;
/
