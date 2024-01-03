PL/SQL Developer Test script 3.0
267
-- Yapona mama:
-- Add hourly oper type for hiring
declare
  v_Company_Id   number := 0;
  v_Indicator    Href_Pref.Indicator_Rt;
  v_Indicators   Href_Pref.Indicator_Nt;
  v_Oper_Type_Id number;
  v_Oper_Types   Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
  v_Count        number;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Operation_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Page_Id     number,
    i_Job_Id      number,
    i_Currency_Id number,
    i_User_Id     number,
    i_Indicators  Href_Pref.Indicator_Nt,
    i_Oper_Types  Href_Pref.Oper_Type_Nt
  ) is
    v_Oper_Type     Href_Pref.Oper_Type_Rt;
    v_Indicator     Href_Pref.Indicator_Rt;
    v_Oper_Type_Ids Array_Number;
  
    --------------------------------------------------
    Procedure Page_Currency_Save
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Page_Id     number,
      i_Currency_Id number
    ) is
      v_Allowed_Currency_Ids Array_Number := Hpr_Util.Load_Currency_Settings(i_Company_Id => i_Company_Id,
                                                                             i_Filial_Id  => i_Filial_Id);
    begin
      if i_Oper_Types.Count = 0 then
        z_Hpd_Page_Currencies.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => i_Page_Id);
        return;
      end if;
    
      if v_Allowed_Currency_Ids.Count > 0 and
         (i_Currency_Id is null or i_Currency_Id not member of v_Allowed_Currency_Ids) then
        Hpd_Error.Raise_072;
      end if;
    
      if i_Currency_Id is not null then
        z_Hpd_Page_Currencies.Save_One(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Page_Id     => i_Page_Id,
                                       i_Currency_Id => i_Currency_Id);
      end if;
    end;
  
  begin
    if z_Hpd_Journal_Pages.Lock_Load(i_Company_Id => i_Company_Id, --
     i_Filial_Id => i_Filial_Id, --
     i_Page_Id => i_Page_Id).Employee_Id <> i_User_Id and not
         Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => i_Company_Id,
                                                                               i_Filial_Id  => i_Filial_Id,
                                                                               i_Job_Id     => i_Job_Id,
                                                                               i_User_Id    => i_User_Id) then
      return;
    end if;
  
    v_Oper_Type_Ids := Array_Number();
    v_Oper_Type_Ids.Extend(i_Oper_Types.Count);
  
    for i in 1 .. i_Indicators.Count
    loop
      v_Indicator := i_Indicators(i);
    
      z_Hpd_Page_Indicators.Save_One(i_Company_Id      => i_Company_Id,
                                     i_Filial_Id       => i_Filial_Id,
                                     i_Page_Id         => i_Page_Id,
                                     i_Indicator_Id    => v_Indicator.Indicator_Id,
                                     i_Indicator_Value => v_Indicator.Indicator_Value);
    end loop;
  
    for i in 1 .. i_Oper_Types.Count
    loop
      v_Oper_Type := i_Oper_Types(i);
      v_Oper_Type_Ids(i) := v_Oper_Type.Oper_Type_Id;
    
      z_Hpd_Page_Oper_Types.Insert_Try(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Page_Id      => i_Page_Id,
                                       i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id);
    
      for j in 1 .. v_Oper_Type.Indicator_Ids.Count
      loop
        z_Hpd_Oper_Type_Indicators.Insert_Try(i_Company_Id   => i_Company_Id,
                                              i_Filial_Id    => i_Filial_Id,
                                              i_Page_Id      => i_Page_Id,
                                              i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id,
                                              i_Indicator_Id => v_Oper_Type.Indicator_Ids(j));
      end loop;
    
      for r in (select *
                  from Hpd_Oper_Type_Indicators t
                 where t.Company_Id = i_Company_Id
                   and t.Filial_Id = i_Filial_Id
                   and t.Page_Id = i_Page_Id
                   and t.Oper_Type_Id = v_Oper_Type.Oper_Type_Id
                   and t.Indicator_Id not member of v_Oper_Type.Indicator_Ids)
      loop
        z_Hpd_Oper_Type_Indicators.Delete_One(i_Company_Id   => r.Company_Id,
                                              i_Filial_Id    => r.Filial_Id,
                                              i_Page_Id      => r.Page_Id,
                                              i_Oper_Type_Id => r.Oper_Type_Id,
                                              i_Indicator_Id => r.Indicator_Id);
      end loop;
    end loop;
  
    Page_Currency_Save(i_Company_Id  => i_Company_Id,
                       i_Filial_Id   => i_Filial_Id,
                       i_Page_Id     => i_Page_Id,
                       i_Currency_Id => i_Currency_Id);
  
    for r in (select *
                from Hpd_Page_Oper_Types t
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and t.Page_Id = i_Page_Id
                 and t.Oper_Type_Id not member of v_Oper_Type_Ids)
    loop
      z_Hpd_Page_Oper_Types.Delete_One(i_Company_Id   => r.Company_Id,
                                       i_Filial_Id    => r.Filial_Id,
                                       i_Page_Id      => r.Page_Id,
                                       i_Oper_Type_Id => r.Oper_Type_Id);
    end loop;
  
    for r in (select q.Indicator_Id
                from Hpd_Page_Indicators q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id
                 and not exists (select 1
                        from Hpd_Oper_Type_Indicators w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Page_Id = q.Page_Id
                         and w.Indicator_Id = q.Indicator_Id))
    loop
      z_Hpd_Page_Indicators.Delete_One(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Page_Id      => i_Page_Id,
                                       i_Indicator_Id => r.Indicator_Id);
    end loop;
  end;

begin
  Ui_Auth.Logon_As_System(v_Company_Id);
  Biruni_Route.Context_Begin;

  v_Indicator.Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);

  v_Oper_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly);

  Hpd_Util.Oper_Type_Add(p_Oper_Type     => v_Oper_Types,
                         i_Oper_Type_Id  => v_Oper_Type_Id,
                         i_Indicator_Ids => Array_Number(v_Indicator.Indicator_Id));

  select count(*)
    into v_Count
    from Hpd_Journals q
    join Hpd_Journal_Pages p
      on p.Company_Id = q.Company_Id
     and p.Filial_Id = q.Filial_Id
     and p.Journal_Id = q.Journal_Id
    join Hpd_Page_Robots Rb
      on Rb.Company_Id = p.Company_Id
     and Rb.Filial_Id = p.Filial_Id
     and Rb.Page_Id = p.Page_Id
    join Hrm_Robots Hr
      on Hr.Company_Id = Rb.Company_Id
     and Hr.Filial_Id = Rb.Filial_Id
     and Hr.Robot_Id = Rb.Robot_Id
     and Hr.Wage_Scale_Id is not null
   where q.Company_Id = v_Company_Id
     and not exists (select 1
            from Hpd_Page_Oper_Types Po
           where Po.Company_Id = p.Company_Id
             and Po.Filial_Id = p.Filial_Id
             and Po.Page_Id = p.Page_Id);

  for r in (select q.Filial_Id,
                   q.Journal_Id, --
                   p.Page_Id,
                   q.Posted,
                   Rb.Robot_Id,
                   Rb.Job_Id,
                   Rb.Rank_Id,
                   Hr.Wage_Scale_Id,
                   (select c.Currency_Id
                      from Hpd_Page_Currencies c
                     where c.Company_Id = p.Company_Id
                       and c.Filial_Id = p.Filial_Id
                       and c.Page_Id = p.Page_Id) Currency_Id,
                   Rownum Rn
              from Hpd_Journals q
              join Hpd_Journal_Pages p
                on p.Company_Id = q.Company_Id
               and p.Filial_Id = q.Filial_Id
               and p.Journal_Id = q.Journal_Id
              join Hpd_Page_Robots Rb
                on Rb.Company_Id = p.Company_Id
               and Rb.Filial_Id = p.Filial_Id
               and Rb.Page_Id = p.Page_Id
              join Hrm_Robots Hr
                on Hr.Company_Id = Rb.Company_Id
               and Hr.Filial_Id = Rb.Filial_Id
               and Hr.Robot_Id = Rb.Robot_Id
               and Hr.Wage_Scale_Id is not null
             where q.Company_Id = v_Company_Id
               and not exists (select 1
                      from Hpd_Page_Oper_Types Po
                     where Po.Company_Id = p.Company_Id
                       and Po.Filial_Id = p.Filial_Id
                       and Po.Page_Id = p.Page_Id))
  loop
    Dbms_Application_Info.Set_Module('migr progress', r.Rn || '/' || v_Count);
  
    if r.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => r.Filial_Id,
                             i_Journal_Id => r.Journal_Id,
                             i_Repost     => true);
    end if;
  
    v_Indicator.Indicator_Value := Nvl(Hrm_Util.Get_Robot_Wage(i_Company_Id       => v_Company_Id,
                                                               i_Filial_Id        => r.Filial_Id,
                                                               i_Robot_Id         => r.Robot_Id,
                                                               i_Contractual_Wage => 'N',
                                                               i_Wage_Scale_Id    => r.Wage_Scale_Id,
                                                               i_Rank_Id          => r.Rank_Id),
                                       0);
  
    v_Indicators := Href_Pref.Indicator_Nt();
  
    Href_Util.Indicator_Add(p_Indicators      => v_Indicators,
                            i_Indicator_Id    => v_Indicator.Indicator_Id,
                            i_Indicator_Value => v_Indicator.Indicator_Value);
  
    Page_Operation_Save(i_Company_Id  => v_Company_Id,
                        i_Filial_Id   => r.Filial_Id,
                        i_Page_Id     => r.Page_Id,
                        i_Job_Id      => r.Job_Id,
                        i_Currency_Id => r.Currency_Id,
                        i_User_Id     => Ui.User_Id,
                        i_Indicators  => v_Indicators,
                        i_Oper_Types  => v_Oper_Types);
  
    if r.Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => r.Filial_Id,
                           i_Journal_Id => r.Journal_Id);
    end if;
  end loop;

  Biruni_Route.Context_End;
end;
1
s
1
4
-5
0
