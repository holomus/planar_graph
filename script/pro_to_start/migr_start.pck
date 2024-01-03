create or replace package Migr_Start is
  ----------------------------------------------------------------------------------------------------
  Procedure Init
  (
    i_Company_Id number,
    i_Filial_Id  number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Isolate_Journals;
  ----------------------------------------------------------------------------------------------------  
  Procedure Divide_Transfers;
  ----------------------------------------------------------------------------------------------------  
  Procedure Timeoff_To_Request;
end Migr_Start;
/
create or replace package body Migr_Start is
  ----------------------------------------------------------------------------------------------------  `
  g_Company_Id            number;
  g_Filial_Id             number;
  g_Wage_Oper_Group_Id    number;
  g_Wage_Indicator_Id     number;
  g_Jt_Hiring             number;
  g_Jt_Hiring_Multiple    number;
  g_Jt_Transfer           number;
  g_Jt_Transfer_Multiple  number;
  g_Jt_Dismissal          number;
  g_Jt_Dismissal_Multiple number;
  g_Jt_Schedule_Change    number;
  g_Jt_Overtime           number;
  g_Jt_Business_Trip      number;
  g_Jt_Sick_Leave         number;
  g_Jt_Vacation           number;
  ----------------------------------------------------------------------------------------------------  
  Procedure Init
  (
    i_Company_Id number,
    i_Filial_Id  number := null
  ) is
  begin
    Hpd_Pref.g_Migration_Active := true;
  
    g_Company_Id := i_Company_Id;
  
    if i_Filial_Id is not null then
      g_Filial_Id := i_Filial_Id;
    else
      g_Filial_Id := null;
    end if;
  
    g_Wage_Oper_Group_Id := Hpr_Util.Oper_Group_Id(i_Company_Id => i_Company_Id,
                                                   i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    g_Wage_Indicator_Id  := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                   i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    g_Jt_Hiring             := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    g_Jt_Hiring_Multiple    := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
    g_Jt_Transfer           := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    g_Jt_Transfer_Multiple  := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
    g_Jt_Dismissal          := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    g_Jt_Dismissal_Multiple := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple);
    g_Jt_Schedule_Change    := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
    g_Jt_Overtime           := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Overtime);
  
    g_Jt_Business_Trip := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
    g_Jt_Sick_Leave    := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
    g_Jt_Vacation      := Hpd_Util.Journal_Type_Id(i_Company_Id => g_Company_Id,
                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Evaluate
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number
  ) is
  begin
    Hpd_Core.Dirty_Staffs_Evaluate(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    Hpd_Core.Agreements_Evaluate(i_Company_Id);
  
    Hrm_Core.Dirty_Robots_Revise;
  
    Hpd_Core.Evaluate_Journal_Page_Cache(i_Company_Id      => i_Company_Id,
                                         i_Journal_Type_Id => i_Journal_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Insert_Journal
  (
    i_Filial_Id       number,
    i_Base_Journal_Id number,
    i_Journal_Type_Id number,
    o_Journal_Id      out number
  ) is
  begin
    o_Journal_Id := Hpd_Next.Journal_Id;
  
    insert into Hpd_Journals
      (Company_Id,
       Filial_Id,
       Journal_Id,
       Journal_Type_Id,
       Journal_Number,
       Journal_Date,
       Journal_Name,
       Posted,
       Posted_Order_No,
       Created_By,
       Created_On,
       Modified_By,
       Modified_On,
       Modified_Id)
      select k.Company_Id,
             k.Filial_Id,
             o_Journal_Id,
             i_Journal_Type_Id,
             k.Journal_Number,
             k.Journal_Date,
             k.Journal_Name,
             'Y',
             Md_Core.Gen_Number(i_Company_Id => g_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Table      => Zt.Hpd_Journals,
                                i_Column     => z.Posted_Order_No),
             k.Created_By,
             k.Created_On,
             k.Modified_By,
             k.Modified_On,
             Biruni_Modified_Sq.Nextval
        from Hpd_Journals k
       where k.Company_Id = g_Company_Id
         and k.Filial_Id = i_Filial_Id
         and k.Journal_Id = i_Base_Journal_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Isolate_Journals is
    v_Journal_Id number;
  begin
    for r in (select *
                from Hpd_Journals j
               where j.Company_Id = g_Company_Id
                 and (g_Filial_Id is null or j.Filial_Id = g_Filial_Id)
                 and j.Journal_Type_Id in (g_Jt_Hiring_Multiple,
                                           g_Jt_Transfer_Multiple,
                                           g_Jt_Dismissal_Multiple,
                                           g_Jt_Schedule_Change,
                                           g_Jt_Overtime)
                 and j.Posted = 'Y')
    loop
      for Pg in (select *
                   from Hpd_Journal_Pages p
                  where p.Company_Id = r.Company_Id
                    and p.Filial_Id = r.Filial_Id
                    and p.Journal_Id = r.Journal_Id --
                  Offset 1 row)
      loop
        Insert_Journal(i_Filial_Id       => r.Filial_Id,
                       i_Base_Journal_Id => r.Journal_Id,
                       i_Journal_Type_Id => case r.Journal_Type_Id
                                              when g_Jt_Hiring_Multiple then
                                               g_Jt_Hiring
                                              when g_Jt_Transfer_Multiple then
                                               g_Jt_Transfer
                                              when g_Jt_Dismissal_Multiple then
                                               g_Jt_Dismissal
                                              else
                                               r.Journal_Type_Id
                                            end,
                       o_Journal_Id      => v_Journal_Id);
      
        update Hpd_Journal_Employees s
           set s.Journal_Id = v_Journal_Id
         where s.Company_Id = r.Company_Id
           and s.Filial_Id = r.Filial_Id
           and s.Journal_Id = r.Journal_Id
           and s.Employee_Id = Pg.Employee_Id;
      
        update Hpd_Journal_Pages s
           set s.Journal_Id = v_Journal_Id
         where s.Company_Id = r.Company_Id
           and s.Filial_Id = r.Filial_Id
           and s.Page_Id = Pg.Page_Id;
      
        update Hpd_Transactions t
           set t.Journal_Id = v_Journal_Id
         where t.Company_Id = r.Company_Id
           and t.Filial_Id = r.Filial_Id
           and t.Page_Id = Pg.Page_Id;
      
        if r.Journal_Type_Id = g_Jt_Schedule_Change then
          insert into Hpd_Schedule_Changes
            (Company_Id, Filial_Id, Journal_Id, Division_Id, Begin_Date, End_Date)
            select s.Company_Id, s.Filial_Id, v_Journal_Id, s.Division_Id, s.Begin_Date, s.End_Date
              from Hpd_Schedule_Changes s
             where s.Company_Id = r.Company_Id
               and s.Filial_Id = r.Filial_Id
               and s.Journal_Id = r.Journal_Id;
        end if;
      
        if r.Journal_Type_Id = g_Jt_Dismissal_Multiple then
          update Hpd_Dismissal_Transactions d
             set d.Journal_Id = v_Journal_Id
           where d.Company_Id = r.Company_Id
             and d.Filial_Id = r.Filial_Id
             and d.Journal_Id = r.Journal_Id
             and d.Page_Id = Pg.Page_Id;
        end if;
      end loop;
    
      if r.Journal_Type_Id = g_Jt_Overtime then
        for Ot in (select p.*
                     from Hpd_Journal_Overtimes p
                    where p.Company_Id = r.Company_Id
                      and p.Filial_Id = r.Filial_Id
                      and p.Journal_Id = r.Journal_Id --
                    Offset 1 row)
        loop
          Insert_Journal(i_Filial_Id       => r.Filial_Id,
                         i_Base_Journal_Id => r.Journal_Id,
                         i_Journal_Type_Id => g_Jt_Overtime,
                         o_Journal_Id      => v_Journal_Id);
        
          update Hpd_Journal_Employees s
             set s.Journal_Id = v_Journal_Id
           where s.Company_Id = r.Company_Id
             and s.Filial_Id = r.Filial_Id
             and s.Journal_Id = r.Journal_Id
             and s.Employee_Id = Ot.Employee_Id;
        
          update Hpd_Journal_Overtimes s
             set s.Journal_Id = v_Journal_Id
           where s.Company_Id = r.Company_Id
             and s.Filial_Id = r.Filial_Id
             and s.Journal_Id = r.Journal_Id
             and s.Overtime_Id = Ot.Overtime_Id;
        end loop;
      end if;
    
      update Hpd_Journals j
         set j.Journal_Type_Id = case j.Journal_Type_Id
                                   when g_Jt_Hiring_Multiple then
                                    g_Jt_Hiring
                                   when g_Jt_Transfer_Multiple then
                                    g_Jt_Transfer
                                   when g_Jt_Dismissal_Multiple then
                                    g_Jt_Dismissal
                                   else
                                    j.Journal_Type_Id
                                 end
       where j.Company_Id = r.Company_Id
         and j.Filial_Id = r.Filial_Id
         and j.Journal_Id = r.Journal_Id;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Divide_Transfers is
    v_Transfer_Journal Hpd_Pref.Transfer_Journal_Rt;
    v_Schedule_Change  Hpd_Pref.Schedule_Change_Journal_Rt;
    v_Wage_Change      Hpd_Pref.Wage_Change_Journal_Rt;
    v_Robot            Hpd_Pref.Robot_Rt;
    v_Contract         Hpd_Pref.Contract_Rt;
    v_Indicator        Href_Pref.Indicator_Nt;
    v_Oper_Type        Href_Pref.Oper_Type_Nt;
  begin
    Biruni_Route.Context_Begin;
  
    for r in (select *
                from Hpd_Journals j
               where j.Company_Id = g_Company_Id
                 and (g_Filial_Id is null or j.Filial_Id = g_Filial_Id)
                 and j.Journal_Type_Id = g_Jt_Transfer
                 and j.Posted = 'Y')
    loop
      Hpd_Api.Journal_Unpost(i_Company_Id => r.Company_Id,
                             i_Filial_Id  => r.Filial_Id,
                             i_Journal_Id => r.Journal_Id,
                             i_Repost     => true);
      -- pages
      for Pg in (select w.*,
                        t.Transfer_Begin,
                        t.Transfer_End,
                        t.Transfer_Reason,
                        t.Transfer_Base,
                        p.Staff_Id,
                        c.Contract_Number,
                        c.Contract_Date,
                        c.Fixed_Term,
                        c.Expiry_Date,
                        c.Fixed_Term_Base_Id,
                        c.Concluding_Term,
                        c.Hiring_Conditions,
                        c.Other_Conditions,
                        c.Workplace_Equipment,
                        c.Representative_Basis,
                        (select s.Schedule_Id
                           from Hpd_Page_Schedules s
                          where s.Company_Id = p.Company_Id
                            and s.Filial_Id = p.Filial_Id
                            and s.Page_Id = p.Page_Id) Schedule_Id,
                        case
                           when exists (select 1
                                   from Hpd_Page_Oper_Types k
                                  where k.Company_Id = p.Company_Id
                                    and k.Filial_Id = p.Filial_Id
                                    and k.Page_Id = p.Page_Id) then
                            'Y'
                           else
                            'N'
                         end as Exist_Oper_Type
                   from Hpd_Journal_Pages p
                   join Hpd_Transfers t
                     on t.Company_Id = p.Company_Id
                    and t.Filial_Id = p.Filial_Id
                    and t.Page_Id = p.Page_Id
                   join Hpd_Page_Robots w
                     on w.Company_Id = p.Company_Id
                    and w.Filial_Id = p.Filial_Id
                    and w.Page_Id = p.Page_Id
                   left join Hpd_Page_Contracts c
                     on c.Company_Id = p.Company_Id
                    and c.Filial_Id = p.Filial_Id
                    and c.Page_Id = p.Page_Id
                  where p.Company_Id = r.Company_Id
                    and p.Filial_Id = r.Filial_Id
                    and p.Journal_Id = r.Journal_Id
                    and w.Employment_Type = Hpd_Pref.c_Employment_Type_Main_Job)
      loop
        -- schedule change
        if Pg.Schedule_Id is not null then
          Hpd_Util.Schedule_Change_Journal_New(o_Journal        => v_Schedule_Change,
                                               i_Company_Id     => r.Company_Id,
                                               i_Filial_Id      => r.Filial_Id,
                                               i_Journal_Id     => Hpd_Next.Journal_Id,
                                               i_Journal_Number => null,
                                               i_Journal_Date   => r.Journal_Date,
                                               i_Journal_Name   => r.Journal_Name,
                                               i_Division_Id    => null,
                                               i_Begin_Date     => Pg.Transfer_Begin,
                                               i_End_Date       => Pg.Transfer_End);
        
          Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => v_Schedule_Change,
                                               i_Page_Id     => Hpd_Next.Page_Id,
                                               i_Staff_Id    => Pg.Staff_Id,
                                               i_Schedule_Id => Pg.Schedule_Id);
        
          Hpd_Api.Schedule_Change_Journal_Save(v_Schedule_Change);
        
          Hpd_Api.Journal_Post(i_Company_Id => v_Schedule_Change.Company_Id,
                               i_Filial_Id  => v_Schedule_Change.Filial_Id,
                               i_Journal_Id => v_Schedule_Change.Journal_Id);
        
          Evaluate(i_Company_Id      => r.Company_Id,
                   i_Filial_Id       => r.Filial_Id,
                   i_Journal_Type_Id => g_Jt_Schedule_Change);
        end if;
      
        -- wage change
        if Pg.Exist_Oper_Type = 'Y' then
          Hpd_Util.Wage_Change_Journal_New(o_Journal         => v_Wage_Change,
                                           i_Company_Id      => r.Company_Id,
                                           i_Filial_Id       => r.Filial_Id,
                                           i_Journal_Id      => Hpd_Next.Journal_Id,
                                           i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r.Company_Id,
                                                                                         i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change),
                                           i_Journal_Number  => null,
                                           i_Journal_Date    => r.Journal_Date,
                                           i_Journal_Name    => r.Journal_Name);
        
          select i.Indicator_Id, i.Indicator_Value
            bulk collect
            into v_Indicator
            from Hpd_Page_Indicators i
           where i.Company_Id = r.Company_Id
             and i.Filial_Id = r.Filial_Id
             and i.Page_Id = Pg.Page_Id
             and i.Indicator_Id = g_Wage_Indicator_Id;
        
          v_Oper_Type := Href_Pref.Oper_Type_Nt();
        
          for Oper in (select o.Oper_Type_Id, Listagg(Oi.Indicator_Id, ',') as Indicator_Ids
                         from Hpd_Page_Oper_Types o
                         join Hpd_Oper_Type_Indicators Oi
                           on Oi.Company_Id = o.Company_Id
                          and Oi.Filial_Id = o.Filial_Id
                          and Oi.Page_Id = o.Page_Id
                          and Oi.Oper_Type_Id = o.Oper_Type_Id
                         join Hpr_Oper_Types h
                           on h.Company_Id = o.Company_Id
                          and h.Oper_Type_Id = o.Oper_Type_Id
                        where o.Company_Id = r.Company_Id
                          and o.Filial_Id = r.Filial_Id
                          and o.Page_Id = Pg.Page_Id
                          and Oi.Indicator_Id = g_Wage_Indicator_Id
                          and h.Oper_Group_Id = g_Wage_Oper_Group_Id
                        group by o.Oper_Type_Id
                        fetch first row only)
          loop
            Hpd_Util.Oper_Type_Add(p_Oper_Type     => v_Oper_Type,
                                   i_Oper_Type_Id  => Oper.Oper_Type_Id,
                                   i_Indicator_Ids => Fazo.To_Array_Number(Fazo.Split(Oper.Indicator_Ids,
                                                                                      ',')));
          end loop;
        
          Hpd_Util.Journal_Add_Wage_Change(p_Journal     => v_Wage_Change,
                                           i_Page_Id     => Hpd_Next.Page_Id,
                                           i_Staff_Id    => Pg.Staff_Id,
                                           i_Change_Date => Pg.Transfer_Begin,
                                           i_Indicators  => v_Indicator,
                                           i_Oper_Types  => v_Oper_Type);
        
          Hpd_Api.Wage_Change_Journal_Save(v_Wage_Change);
        
          Hpd_Api.Journal_Post(i_Company_Id => v_Wage_Change.Company_Id,
                               i_Filial_Id  => v_Wage_Change.Filial_Id,
                               i_Journal_Id => v_Wage_Change.Journal_Id);
        
          Evaluate(i_Company_Id      => r.Company_Id,
                   i_Filial_Id       => r.Filial_Id,
                   i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r.Company_Id,
                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change));
        end if;
      
        -- fix transfer
        Hpd_Util.Transfer_Journal_New(o_Journal         => v_Transfer_Journal,
                                      i_Company_Id      => r.Company_Id,
                                      i_Filial_Id       => r.Filial_Id,
                                      i_Journal_Id      => r.Journal_Id,
                                      i_Journal_Type_Id => r.Journal_Type_Id,
                                      i_Journal_Number  => r.Journal_Number,
                                      i_Journal_Date    => r.Journal_Date,
                                      i_Journal_Name    => r.Journal_Name);
      
        Hpd_Util.Robot_New(o_Robot           => v_Robot,
                           i_Robot_Id        => Pg.Robot_Id,
                           i_Division_Id     => Pg.Division_Id,
                           i_Job_Id          => Pg.Job_Id,
                           i_Rank_Id         => Pg.Rank_Id,
                           i_Wage_Scale_Id   => null,
                           i_Employment_Type => Pg.Employment_Type,
                           i_Fte_Id          => Pg.Fte_Id,
                           i_Fte             => Pg.Fte);
      
        Hpd_Util.Contract_New(o_Contract             => v_Contract,
                              i_Contract_Number      => Pg.Contract_Number,
                              i_Contract_Date        => Pg.Contract_Date,
                              i_Fixed_Term           => Pg.Fixed_Term,
                              i_Expiry_Date          => Pg.Expiry_Date,
                              i_Fixed_Term_Base_Id   => Pg.Fixed_Term_Base_Id,
                              i_Concluding_Term      => Pg.Concluding_Term,
                              i_Hiring_Conditions    => Pg.Hiring_Conditions,
                              i_Other_Conditions     => Pg.Other_Conditions,
                              i_Workplace_Equipment  => Pg.Workplace_Equipment,
                              i_Representative_Basis => Pg.Representative_Basis);
      
        Hpd_Util.Journal_Add_Transfer(p_Journal             => v_Transfer_Journal,
                                      i_Page_Id             => Pg.Page_Id,
                                      i_Transfer_Begin      => Pg.Transfer_Begin,
                                      i_Transfer_End        => Pg.Transfer_End,
                                      i_Staff_Id            => Pg.Staff_Id,
                                      i_Schedule_Id         => null,
                                      i_Vacation_Days_Limit => null,
                                      i_Transfer_Reason     => Pg.Transfer_Reason,
                                      i_Transfer_Base       => Pg.Transfer_Base,
                                      i_Robot               => v_Robot,
                                      i_Contract            => v_Contract,
                                      i_Indicators          => Href_Pref.Indicator_Nt(),
                                      i_Oper_Types          => Href_Pref.Oper_Type_Nt());
      
        Hpd_Api.Transfer_Journal_Save(v_Transfer_Journal);
      end loop;
    
      Hpd_Api.Journal_Post(i_Company_Id => r.Company_Id,
                           i_Filial_Id  => r.Filial_Id,
                           i_Journal_Id => r.Journal_Id);
    
      Evaluate(i_Company_Id      => r.Company_Id,
               i_Filial_Id       => r.Filial_Id,
               i_Journal_Type_Id => r.Journal_Type_Id);
    end loop;
  
    Biruni_Route.Context_End;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timeoff_To_Request is
    r_Request           Htt_Requests%rowtype;
    v_Request_Id        number;
    v_Request_Kind_Id   number;
    v_Rk_Businesss_Trip number;
    v_Rk_Sick_Leave     number;
    v_Rk_Vacation       number;
  begin
    Biruni_Route.Context_Begin;
  
    /*    v_Rk_Businesss_Trip := Htt_Util.Request_Kind_Id(i_Company_Id => r.Company_Id,
                                                    i_Pcode      => Htt_Pref.c_Pcode_Request_Kind_Trip);
    v_Rk_Sick_Leave     := Htt_Util.Request_Kind_Id(i_Company_Id => r.Company_Id,
                                                    i_Pcode      => Htt_Pref.c_Pcode_Request_Kind_Sick_Leave);
    v_Rk_Vacation       := Htt_Util.Request_Kind_Id(i_Company_Id => r.Company_Id,
                                                    i_Pcode      => Htt_Pref.c_Pcode_Request_Kind_Vacation);*/
  
    for r in (select t.*, j.Journal_Type_Id, j.Posted
                from Hpd_Journals j
                join Hpd_Journal_Timeoffs t
                  on j.Company_Id = t.Company_Id
                 and j.Filial_Id = t.Filial_Id
                 and j.Journal_Id = t.Journal_Id
               where j.Company_Id = g_Company_Id
                 and (g_Filial_Id is null or j.Filial_Id = g_Filial_Id)
                 and j.Journal_Type_Id in (g_Jt_Business_Trip, g_Jt_Sick_Leave, g_Jt_Vacation))
    loop
      if r.Posted = 'Y' then
        Hpd_Api.Journal_Unpost(i_Company_Id => r.Company_Id,
                               i_Filial_Id  => r.Filial_Id,
                               i_Journal_Id => r.Journal_Id);
      end if;
    
      v_Request_Id      := Htt_Next.Request_Id;
      v_Request_Kind_Id := case r.Journal_Type_Id
                             when g_Jt_Business_Trip then
                              v_Rk_Businesss_Trip
                             when g_Jt_Sick_Leave then
                              v_Rk_Sick_Leave
                             when g_Jt_Vacation then
                              v_Rk_Vacation
                           end;
    
      r_Request.Company_Id      := r.Company_Id;
      r_Request.Filial_Id       := r.Filial_Id;
      r_Request.Request_Id      := v_Request_Id;
      r_Request.Request_Kind_Id := v_Request_Kind_Id;
      r_Request.Staff_Id        := r.Staff_Id;
      r_Request.Begin_Time      := r.Begin_Date;
      r_Request.End_Time        := r.End_Date;
      r_Request.Request_Type    := Htt_Pref.c_Request_Type_Multiple_Days;
    
      Htt_Api.Request_Save(r_Request);
    
      if r.Posted = 'Y' then
        update Htt_Requests t
           set t.Status = Htt_Pref.c_Request_Status_Completed
         where t.Company_Id = r.Company_Id
           and t.Filial_Id = r.Filial_Id
           and t.Request_Id = v_Request_Id;
      end if;
    
      Hpd_Api.Journal_Delete(i_Company_Id => r.Company_Id,
                             i_Filial_Id  => r.Filial_Id,
                             i_Journal_Id => r.Journal_Id);
    
      Evaluate(i_Company_Id      => r.Company_Id,
               i_Filial_Id       => r.Filial_Id,
               i_Journal_Type_Id => r.Journal_Type_Id);
    end loop;
  
    Biruni_Route.Context_End;
  end;

end Migr_Start;
/
