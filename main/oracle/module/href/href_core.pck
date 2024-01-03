create or replace package Href_Core is
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissed_Candidate_Save
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Staff_Id             number,
    i_Employment_Source_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Estimation_Formula_Update
  (
    i_Company_Id     number,
    i_Indicator_Id   number,
    i_Old_Identifier varchar2,
    i_New_Identifier varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Send_Notification
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Title      varchar2,
    i_Uri        varchar2 := null,
    i_Uri_Param  Hashmap := Hashmap(),
    i_Person_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Send_Notification
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Title         varchar2,
    i_Uri           varchar2 := null,
    i_Uri_Param     Hashmap := Hashmap(),
    i_Check_Setting boolean := false,
    i_User_Id       number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Send_Application_Notification
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Title              varchar2,
    i_Form               varchar2,
    i_Action_Keys        Array_Varchar2,
    i_Uri                varchar2,
    i_Uri_Param          Hashmap,
    i_Except_User_Id     number,
    i_Additional_User_Id number := null
  );
end Href_Core;
/
create or replace package body Href_Core is
  ---------------------------------------------------------------------------------------------------- 
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissed_Candidate_Save
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Staff_Id             number,
    i_Employment_Source_Id number
  ) is
    r_Staff     Href_Staffs%rowtype;
    r_Candidate Href_Candidates%rowtype;
    v_Exists    boolean;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.Dismissal_Date is null then
      return;
    end if;
  
    if z_Href_Candidates.Exist(i_Company_Id   => r_Staff.Company_Id,
                               i_Filial_Id    => r_Staff.Filial_Id,
                               i_Candidate_Id => r_Staff.Employee_Id,
                               o_Row          => r_Candidate) then
      v_Exists := true;
    else
      r_Candidate.Company_Id     := r_Staff.Company_Id;
      r_Candidate.Filial_Id      := r_Staff.Filial_Id;
      r_Candidate.Candidate_Id   := r_Staff.Employee_Id;
      r_Candidate.Candidate_Kind := Href_Pref.c_Candidate_Kind_New;
    end if;
  
    r_Candidate.Source_Id := i_Employment_Source_Id;
  
    if v_Exists then
      z_Href_Candidates.Update_Row(r_Candidate);
    else
      z_Href_Candidates.Insert_Row(r_Candidate);
    end if;
  
    insert into Href_Candidate_Jobs
      (Company_Id, Filial_Id, Candidate_Id, Job_Id)
      select i_Company_Id, i_Filial_Id, r_Staff.Employee_Id, p.Job_Id
        from Hpd_Transactions q
        join Hpd_Trans_Robots p
          on p.Company_Id = q.Company_Id
         and p.Filial_Id = q.Filial_Id
         and p.Trans_Id = q.Trans_Id
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
         and not exists (select 1
                from Href_Candidate_Jobs Cj
               where Cj.Company_Id = i_Company_Id
                 and Cj.Filial_Id = i_Filial_Id
                 and Cj.Candidate_Id = r_Staff.Employee_Id
                 and Cj.Job_Id = p.Job_Id)
       group by p.Job_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Estimation_Formula_Update
  (
    i_Company_Id     number,
    i_Indicator_Id   number,
    i_Old_Identifier varchar2,
    i_New_Identifier varchar2
  ) is
    v_Oper_Types Hpr_Oper_Types%rowtype;
    v_Variables  Array_Varchar2;
    v_Formula    varchar2(500);
  begin
    for r in (select *
                from Hpr_Oper_Type_Indicators t
               where t.Company_Id = i_Company_Id
                 and t.Indicator_Id = i_Indicator_Id)
    loop
      v_Oper_Types := z_Hpr_Oper_Types.Lock_Load(i_Company_Id   => r.Company_Id,
                                                 i_Oper_Type_Id => r.Oper_Type_Id);
    
      v_Formula   := v_Oper_Types.Estimation_Formula;
      v_Variables := Hide_Util.Get_Global_Variables(v_Formula);
    
      Fazo.Sort_Desc(v_Variables);
    
      for i in 1 .. v_Variables.Count
      loop
        if v_Variables(i) = i_Old_Identifier then
          v_Formula := Regexp_Replace(v_Formula,
                                      '(\W|^)' || i_Old_Identifier || '(\W|$)',
                                      '\1' || i_New_Identifier || '\2');
          exit;
        end if;
      end loop;
    
      z_Hpr_Oper_Type_Indicators.Update_One(i_Company_Id   => r.Company_Id,
                                            i_Oper_Type_Id => r.Oper_Type_Id,
                                            i_Indicator_Id => r.Indicator_Id,
                                            i_Identifier   => Option_Varchar2(i_New_Identifier));
      z_Hpr_Oper_Types.Update_One(i_Company_Id         => r.Company_Id,
                                  i_Oper_Type_Id       => r.Oper_Type_Id,
                                  i_Estimation_Formula => Option_Varchar2(v_Formula));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype) is
    r_Indicator          Href_Indicators%rowtype;
    v_Used               Href_Indicators.Used%type := Href_Pref.c_Indicator_Used_Constantly;
    v_Indicator_Group_Id Href_Indicators.Indicator_Group_Id%type := i_Indicator.Indicator_Group_Id;
    v_Pcode              Href_Indicators.Pcode%type;
  begin
    if z_Href_Indicators.Exist_Lock(i_Company_Id   => i_Indicator.Company_Id,
                                    i_Indicator_Id => i_Indicator.Indicator_Id,
                                    o_Row          => r_Indicator) then
      if r_Indicator.Identifier <> i_Indicator.Identifier then
        Estimation_Formula_Update(i_Company_Id     => r_Indicator.Company_Id,
                                  i_Indicator_Id   => r_Indicator.Indicator_Id,
                                  i_Old_Identifier => r_Indicator.Identifier,
                                  i_New_Identifier => i_Indicator.Identifier);
      end if;
    
      v_Indicator_Group_Id := r_Indicator.Indicator_Group_Id;
      v_Used               := r_Indicator.Used;
      v_Pcode              := r_Indicator.Pcode;
    end if;
  
    r_Indicator                    := i_Indicator;
    r_Indicator.Indicator_Group_Id := v_Indicator_Group_Id;
    r_Indicator.Used               := v_Used;
    r_Indicator.Pcode              := v_Pcode;
  
    z_Href_Indicators.Save_Row(r_Indicator);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Send_Notification
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Title      varchar2,
    i_Uri        varchar2 := null,
    i_Uri_Param  Hashmap := Hashmap(),
    i_Person_Ids Array_Number
  ) is
    r_Data Ms_Notifications%rowtype;
  begin
    r_Data.Company_Id        := i_Company_Id;
    r_Data.Filial_Id         := i_Filial_Id;
    r_Data.Notification_Kind := Ms_Pref.c_Nk_Primary;
    r_Data.Viewed            := 'N';
    r_Data.Title             := i_Title;
    r_Data.Uri               := i_Uri;
    r_Data.Uri_Param         := i_Uri_Param.Json();
  
    for i in 1 .. i_Person_Ids.Count()
    loop
      r_Data.Notification_Id := Ms_Next.Notification_Id;
      r_Data.Person_Id       := i_Person_Ids(i);
    
      Ms_Api.Notification_Save(r_Data);
    end loop;
  
    if i_Person_Ids.Count > 0 then
      b.Broadcast_Notification(i_User_Ids => i_Person_Ids);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Send_Notification
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Title         varchar2,
    i_Uri           varchar2 := null,
    i_Uri_Param     Hashmap := Hashmap(),
    i_Check_Setting boolean := false,
    i_User_Id       number
  ) is
    v_Role_Id    varchar(100);
    v_Person_Ids Array_Number;
  begin
    if i_Check_Setting and Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Notification_Enable = 'N' then
      return;
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => i_Company_Id, i_Pcode => Href_Pref.c_Pcode_Role_Hr);
  
    select q.User_Id
      bulk collect
      into v_Person_Ids
      from Md_User_Roles q
     where q.Company_Id = i_Company_Id
       and q.User_Id <> i_User_Id
       and q.Filial_Id = i_Filial_Id
       and q.Role_Id = v_Role_Id;
  
    Send_Notification(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Title      => i_Title,
                      i_Uri        => i_Uri,
                      i_Uri_Param  => i_Uri_Param,
                      i_Person_Ids => v_Person_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Send_Application_Notification
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Title              varchar2,
    i_Form               varchar2,
    i_Action_Keys        Array_Varchar2,
    i_Uri                varchar2,
    i_Uri_Param          Hashmap,
    i_Except_User_Id     number,
    i_Additional_User_Id number := null
  ) is
    v_Person_Ids Array_Number;
  begin
    select u.User_Id
      bulk collect
      into v_Person_Ids
      from Md_Users u
     where u.Company_Id = i_Company_Id
       and u.User_Id <> i_Except_User_Id
       and (i_Additional_User_Id is null or u.User_Id <> i_Additional_User_Id)
       and exists (select *
              from Md_User_Form_Actions q
             where q.Company_Id = i_Company_Id
               and q.User_Id = u.User_Id
               and q.Filial_Id = i_Filial_Id
               and q.Form = i_Form
               and q.Action_Key in (select Column_Value
                                      from table(i_Action_Keys)));
  
    if i_Additional_User_Id <> i_Except_User_Id then
      v_Person_Ids.Extend;
      v_Person_Ids(v_Person_Ids.Count) := i_Additional_User_Id;
    end if;
  
    Send_Notification(i_Company_Id => i_Company_Id,
                      i_Filial_Id  => i_Filial_Id,
                      i_Title      => i_Title,
                      i_Uri        => i_Uri,
                      i_Uri_Param  => i_Uri_Param,
                      i_Person_Ids => v_Person_Ids);
  end;

end Href_Core;
/
