create or replace package Ui_Vhr183 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr183;
/
create or replace package body Ui_Vhr183 is
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
    return b.Translate('UI-VHR183:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journals
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Journals%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Journals t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Journals t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Journal_Id = i_Journal_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Journals.Difference(r, r_Last);
    
      Get_Difference(z.Journal_Type_Id,
                     t('journal type name'),
                     z_Hpd_Journal_Types.Take(i_Company_Id => r_Last.t_Company_Id, i_Journal_Type_Id => r_Last.Journal_Type_Id).Name,
                     z_Hpd_Journal_Types.Take(i_Company_Id => r.t_Company_Id, i_Journal_Type_Id => r.Journal_Type_Id).Name);
      Get_Difference(z.Journal_Number,
                     t('journal number'),
                     r_Last.Journal_Number,
                     r.Journal_Number);
      Get_Difference(z.Journal_Date, t('journal date'), r_Last.Journal_Date, r.Journal_Date);
      Get_Difference(z.Posted,
                     t('posted'),
                     Md_Util.Decode(i_Kind        => r_Last.Posted,
                                    i_First_Kind  => 'Y',
                                    i_First_Name  => Ui.t_Yes,
                                    i_Second_Kind => 'N',
                                    i_Second_Name => Ui.t_No),
                     Md_Util.Decode(i_Kind        => r.Posted,
                                    i_First_Kind  => 'Y',
                                    i_First_Name  => Ui.t_Yes,
                                    i_Second_Kind => 'N',
                                    i_Second_Name => Ui.t_No));
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Pages
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Journal_Pages%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Journal_Pages t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Journal_Pages t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Journal_Id = i_Journal_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Context_Id <> i_Context_Id
                   and t.t_Timestamp <= r.t_Timestamp
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Journal_Pages.Difference(r, r_Last);
    
      Get_Difference(z.Staff_Id,
                     t('staff name'),
                     Href_Util.Staff_Name(i_Company_Id => r_Last.t_Company_Id,
                                          i_Filial_Id  => r_Last.t_Filial_Id,
                                          i_Staff_Id   => r_Last.Staff_Id),
                     Href_Util.Staff_Name(i_Company_Id => r.t_Company_Id,
                                          i_Filial_Id  => r.t_Filial_Id,
                                          i_Staff_Id   => r.Staff_Id));
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hirings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Hirings%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Hirings t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from x_Hpd_Journal_Pages s
                       where s.t_Company_Id = t.t_Company_Id
                         and s.t_Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Hirings t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Hirings.Difference(r, r_Last);
    
      Get_Difference(z.Hiring_Date, t('hiring date'), r_Last.Hiring_Date, r.Hiring_Date);
      Get_Difference(z.Trial_Period, t('trial period'), r_Last.Trial_Period, r.Trial_Period);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissals
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Dismissals%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Dismissals t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Dismissals t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Dismissals.Difference(r, r_Last);
    
      Get_Difference(z.Dismissal_Date,
                     t('dismissal date'),
                     r_Last.Dismissal_Date,
                     r.Dismissal_Date);
      Get_Difference(z.Dismissal_Reason_Id,
                     t('dismissal reason name'),
                     z_Href_Dismissal_Reasons.Take(i_Company_Id => r_Last.t_Company_Id, i_Dismissal_Reason_Id => r_Last.Dismissal_Reason_Id).Name,
                     z_Href_Dismissal_Reasons.Take(i_Company_Id => r.t_Company_Id, i_Dismissal_Reason_Id => r.Dismissal_Reason_Id).Name);
      Get_Difference(z.Employment_Source_Id,
                     t('employment source name'),
                     z_Href_Employment_Sources.Take(i_Company_Id => r_Last.t_Company_Id, i_Source_Id => r_Last.Employment_Source_Id).Name,
                     z_Href_Employment_Sources.Take(i_Company_Id => r.t_Company_Id, i_Source_Id => r.Employment_Source_Id).Name);
      Get_Difference(z.Based_On_Doc, t('based on doc'), r_Last.Based_On_Doc, r.Based_On_Doc);
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Transfers
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Transfers%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Transfers t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Transfers t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Transfers.Difference(r, r_Last);
    
      Get_Difference(z.Transfer_Begin,
                     t('transfer begin'),
                     r_Last.Transfer_Begin,
                     r.Transfer_Begin);
      Get_Difference(z.Transfer_End, t('transfer end'), r_Last.Transfer_End, r.Transfer_End);
      Get_Difference(z.Transfer_Reason,
                     t('transfer reason'),
                     r_Last.Transfer_Reason,
                     r.Transfer_Reason);
      Get_Difference(z.Transfer_Base, t('transfer base'), r_Last.Transfer_Base, r.Transfer_Base);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robots
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Robots%rowtype;
    r_Last_Robot   Mrf_Robots%rowtype;
    r_Robot        Mrf_Robots%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Robots t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Robots t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Robots.Difference(r, r_Last);
    
      if z.Robot_Id member of v_Diff_Columns then
        r_Last_Robot := z_Mrf_Robots.Take(i_Company_Id => r_Last.t_Company_Id,
                                          i_Filial_Id  => r_Last.t_Filial_Id,
                                          i_Robot_Id   => r_Last.Robot_Id);
      
        r_Robot := z_Mrf_Robots.Take(i_Company_Id => r.t_Company_Id,
                                     i_Filial_Id  => r.t_Filial_Id,
                                     i_Robot_Id   => r.Robot_Id);
      
        Fazo.Push(v_Data, t('robot name'), r_Last_Robot.Name, r_Robot.Name);
        Fazo.Push(v_Data,
                  t('division name'),
                  z_Mhr_Divisions.Take(i_Company_Id => r_Last_Robot.Company_Id, i_Filial_Id => r_Last_Robot.Filial_Id, i_Division_Id => r_Last_Robot.Division_Id).Name,
                  z_Mhr_Divisions.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Division_Id => r_Robot.Division_Id).Name);
        Fazo.Push(v_Data,
                  t('job name'),
                  z_Mhr_Jobs.Take(i_Company_Id => r_Last_Robot.Company_Id, i_Filial_Id => r_Last_Robot.Filial_Id, i_Job_Id => r_Last_Robot.Job_Id).Name,
                  z_Mhr_Jobs.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Job_Id => r_Robot.Job_Id).Name);
      end if;
    
      Get_Difference(z.Rank_Id,
                     t('rank name'),
                     z_Mhr_Ranks.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Rank_Id => r_Last.Rank_Id).Name,
                     z_Mhr_Ranks.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Rank_Id => r_Last.Rank_Id).Name);
      Get_Difference(z.Employment_Type,
                     t('employment type name'),
                     Hpd_Util.t_Employment_Type(r_Last.Employment_Type),
                     Hpd_Util.t_Employment_Type(r.Employment_Type));
      Get_Difference(z.Fte, t('fte'), r_Last.Fte, r.Fte);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Contratcs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Contracts%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Contracts t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Contracts t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = t.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Contracts.Difference(r, r_Last);
    
      Get_Difference(z.Contract_Number,
                     t('contract number'),
                     r_Last.Contract_Number,
                     r.Contract_Number);
      Get_Difference(z.Contract_Date, t('contract date'), r_Last.Contract_Date, r.Contract_Date);
      Get_Difference(z.Fixed_Term, t('fixed term'), r_Last.Fixed_Term, r.Fixed_Term);
      Get_Difference(z.Fixed_Term_Base_Id,
                     t('fixed term base name'),
                     z_Href_Fixed_Term_Bases.Take(i_Company_Id => r_Last.t_Company_Id, i_Fixed_Term_Base_Id => r_Last.Fixed_Term_Base_Id).Name,
                     z_Href_Fixed_Term_Bases.Take(i_Company_Id => r.t_Company_Id, i_Fixed_Term_Base_Id => r.Fixed_Term_Base_Id).Name);
      Get_Difference(z.Concluding_Term,
                     t('concluding term'),
                     r_Last.Concluding_Term,
                     r.Concluding_Term);
      Get_Difference(z.Hiring_Conditions,
                     t('hiring conditions'),
                     r_Last.Hiring_Conditions,
                     r.Hiring_Conditions);
      Get_Difference(z.Other_Conditions,
                     t('other conditions'),
                     r_Last.Other_Conditions,
                     r.Other_Conditions);
      Get_Difference(z.Workplace_Equipment,
                     t('workplace equipment'),
                     r_Last.Workplace_Equipment,
                     r.Workplace_Equipment);
      Get_Difference(z.Representative_Basis,
                     t('representative basis'),
                     r_Last.Representative_Basis,
                     r.Representative_Basis);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedules
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Schedules%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Schedules t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Schedules t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Schedules.Difference(r, r_Last);
    
      Get_Difference(z.Schedule_Id,
                     t('schedule name'),
                     z_Htt_Schedules.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Schedule_Id => r_Last.Schedule_Id).Name,
                     z_Htt_Schedules.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Schedule_Id => r.Schedule_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Schedule_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Schedule_Changes%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Schedule_Changes t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Schedule_Changes t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Journal_Id = r.Journal_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Schedule_Changes.Difference(r, r_Last);
    
      Get_Difference(z.Division_Id,
                     t('division name'),
                     z_Mhr_Divisions.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Division_Id => r_Last.Division_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Division_Id => r.Division_Id).Name);
      Get_Difference(z.Begin_Date, t('begin date'), r_Last.Begin_Date, r.Begin_Date);
      Get_Difference(z.End_Date, t('end date'), r_Last.End_Date, r.End_Date);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacation_Limit_Change
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Vacation_Limit_Changes%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Vacation_Limit_Changes t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Vacation_Limit_Changes t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Journal_Id = r.Journal_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Vacation_Limit_Changes.Difference(r, r_Last);
    
      Get_Difference(z.Change_Date, t('change data'), r_Last.Change_Date, r.Change_Date);
      Get_Difference(z.Days_Limit, t('days limit'), r_Last.Days_Limit, r.Days_Limit);
      Get_Difference(z.Division_Id,
                     t('division name'),
                     z_Mhr_Divisions.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Division_Id => r_Last.Division_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Division_Id => r.Division_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Wage_Changes%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Wage_Changes t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from x_Hpd_Journal_Pages s
                       where s.t_Company_Id = t.t_Company_Id
                         and s.t_Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Wage_Changes t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Wage_Changes.Difference(r, r_Last);
    
      Get_Difference(z.Change_Date, t('change date'), r_Last.Change_Date, r.Change_Date);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Rank_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Rank_Changes%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Rank_Changes t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from x_Hpd_Journal_Pages s
                       where s.t_Company_Id = t.t_Company_Id
                         and s.t_Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Rank_Changes t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Rank_Changes.Difference(r, r_Last);
    
      Get_Difference(z.Change_Date, t('change data'), r_Last.Change_Date, r.Change_Date);
      Get_Difference(z.Rank_Id,
                     t('rank name'),
                     z_Mhr_Ranks.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Rank_Id => r_Last.Rank_Id).Name,
                     z_Mhr_Ranks.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Rank_Id => r.Rank_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Indicators
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Oper_Type_Id number,
    i_Context_Id   number
  ) return varchar2 is
    v_Data Array_Varchar2 := Array_Varchar2();
  begin
    select (select w.Name
              from Href_Indicators w
             where w.Company_Id = q.t_Company_Id
               and w.Indicator_Id = q.Indicator_Id)
      bulk collect
      into v_Data
      from x_Hpd_Oper_Type_Indicators q
     where q.t_Company_Id = i_Company_Id
       and q.t_Filial_Id = i_Filial_Id
       and q.Oper_Type_Id = i_Oper_Type_Id
       and q.t_Context_Id = i_Context_Id;
  
    return Fazo.Gather(i_Val => v_Data, i_Delimiter => ', ');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Oper_Types
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Oper_Types%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Oper_Types t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Oper_Types t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.Oper_Type_Id = r.Oper_Type_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Oper_Types.Difference(r, r_Last);
    
      Get_Difference(z.Oper_Type_Id,
                     t('oper type name'),
                     z_Mpr_Oper_Types.Take(i_Company_Id => r_Last.t_Company_Id, i_Oper_Type_Id => r_Last.Oper_Type_Id).Name,
                     z_Mpr_Oper_Types.Take(i_Company_Id => r.t_Company_Id, i_Oper_Type_Id => r.Oper_Type_Id).Name);
      Fazo.Push(v_Data,
                t('indicator names'),
                Get_Indicators(i_Company_Id   => r_Last.t_Company_Id,
                               i_Filial_Id    => r_Last.t_Filial_Id,
                               i_Oper_Type_Id => r_Last.Oper_Type_Id,
                               i_Context_Id   => r_Last.t_Context_Id),
                Get_Indicators(i_Company_Id   => r.t_Company_Id,
                               i_Filial_Id    => r.t_Filial_Id,
                               i_Oper_Type_Id => r.Oper_Type_Id,
                               i_Context_Id   => r.t_Context_Id));
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicators
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Indicators%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Indicators t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Indicators t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.Indicator_Id = r.Indicator_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Indicators.Difference(r, r_Last);
    
      Get_Difference(z.Indicator_Id,
                     t('indicator name'),
                     z_Href_Indicators.Take(i_Company_Id => r_Last.t_Company_Id, i_Indicator_Id => r_Last.Indicator_Id).Name,
                     z_Href_Indicators.Take(i_Company_Id => r.t_Company_Id, i_Indicator_Id => r.Indicator_Id).Name);
      Get_Difference(z.Indicator_Value,
                     t('indicator value'),
                     r_Last.Indicator_Value,
                     r.Indicator_Value);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Currencies
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Currencies%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Currencies t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Currencies t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Currencies.Difference(r, r_Last);
    
      Get_Difference(z.Currency_Id,
                     t('currency name'),
                     z_Mk_Currencies.Take(i_Company_Id => r_Last.t_Company_Id, i_Currency_Id => r_Last.Currency_Id).Name,
                     z_Mk_Currencies.Take(i_Company_Id => r.t_Company_Id, i_Currency_Id => r.Currency_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timeoffs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Journal_Timeoffs%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Journal_Timeoffs t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Journal_Timeoffs t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Journal_Id = i_Journal_Id
                   and t.Timeoff_Id = r.Timeoff_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Journal_Timeoffs.Difference(r, r_Last);
    
      Get_Difference(z.Staff_Id,
                     t('staff name'),
                     Href_Util.Staff_Name(i_Company_Id => r_Last.t_Company_Id,
                                          i_Filial_Id  => r_Last.t_Filial_Id,
                                          i_Staff_Id   => r_Last.Staff_Id),
                     Href_Util.Staff_Name(i_Company_Id => r.t_Company_Id,
                                          i_Filial_Id  => r.t_Filial_Id,
                                          i_Staff_Id   => r.Staff_Id));
      Get_Difference(z.Begin_Date, t('begin date'), r_Last.Begin_Date, r.Begin_Date);
      Get_Difference(z.End_Date, t('end date'), r_Last.End_Date, r.End_Date);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sick_Leaves
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Sick_Leaves%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Sick_Leaves t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Timeoffs s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Timeoff_Id = t.Timeoff_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Sick_Leaves t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Timeoff_Id = r.Timeoff_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Sick_Leaves.Difference(r, r_Last);
    
      Get_Difference(z.Reason_Id,
                     t('reason name'),
                     z_Href_Sick_Leave_Reasons.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Reason_Id => r_Last.Reason_Id).Name,
                     z_Href_Sick_Leave_Reasons.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Reason_Id => r.Reason_Id).Name);
      Get_Difference(z.Sick_Leave_Number,
                     t('sick leave number'),
                     r_Last.Sick_Leave_Number,
                     r.Sick_Leave_Number);
      Get_Difference(z.Coefficient, t('coefficient'), r_Last.Coefficient, r.Coefficient);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Business_Trips
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Business_Trips%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Business_Trips t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Timeoffs s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Timeoff_Id = t.Timeoff_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Business_Trips t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Timeoff_Id = r.Timeoff_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Business_Trips.Difference(r, r_Last);
    
      Get_Difference(z.Reason_Id,
                     t('reason name'),
                     z_Href_Business_Trip_Reasons.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Reason_Id => r_Last.Reason_Id).Name,
                     z_Href_Business_Trip_Reasons.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Reason_Id => r.Reason_Id).Name);
      Get_Difference(z.Person_Id,
                     t('person name'),
                     z_Md_Persons.Take(i_Company_Id => r_Last.t_Company_Id, i_Person_Id => r_Last.Person_Id).Name,
                     z_Md_Persons.Take(i_Company_Id => r.t_Company_Id, i_Person_Id => r.Person_Id).Name);
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Business_Trip_Regions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Business_Trip_Regions%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Business_Trip_Regions t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Timeoffs s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Timeoff_Id = t.Timeoff_Id))
    loop
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      else
        r_Last := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Business_Trip_Regions.Difference(r, r_Last);
    
      Get_Difference(z.Region_Id,
                     t('region name'),
                     z_Md_Regions.Take(i_Company_Id => r_Last.t_Company_Id, i_Region_Id => r_Last.Region_Id).Name,
                     z_Md_Regions.Take(i_Company_Id => r.t_Company_Id, i_Region_Id => r.Region_Id).Name);
      Get_Difference(z.Order_No, t('order no'), r_Last.Order_No, r.Order_No);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Overtimes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Journal_Overtimes%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Journal_Overtimes t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Journal_Overtimes t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Journal_Id = i_Journal_Id
                   and t.Overtime_Id = r.Overtime_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Journal_Overtimes.Difference(r, r_Last);
    
      Get_Difference(z.Employee_Id,
                     t('staff name'),
                     z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => r_Last.Employee_Id).Name,
                     z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => r.Employee_Id).Name);
      Get_Difference(z.Begin_Date, t('begin date'), r_Last.Begin_Date, r.Begin_Date);
      Get_Difference(z.End_Date, t('end date'), r_Last.End_Date, r.End_Date);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Overtime_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Overtime_Days%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Overtime_Days t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from x_Hpd_Journal_Overtimes w
                       where w.t_Company_Id = i_Company_Id
                         and w.t_Filial_Id = i_Filial_Id
                         and w.Journal_Id = i_Journal_Id
                         and w.Overtime_Id = t.Overtime_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Overtime_Days t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Overtime_Id = r.Overtime_Id
                   and t.Overtime_Date = r.Overtime_Date
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Overtime_Days.Difference(r, r_Last);
    
      Get_Difference(z.Overtime_Date, t('overtime date'), r_Last.Overtime_Date, r.Overtime_Date);
      Get_Difference(z.Overtime_Seconds,
                     t('overtime total'),
                     Htt_Util.To_Time(r_Last.Overtime_Seconds / 60),
                     Htt_Util.To_Time(r.Overtime_Seconds / 60));
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timebook_Adjustments
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Page_Adjustments%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Page_Adjustments t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Pages s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Page_Id = t.Page_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Page_Adjustments t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Page_Id = r.Page_Id
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Page_Adjustments.Difference(r, r_Last);
    
      Get_Difference(z.Free_Time,
                     t('free time'),
                     Htt_Util.To_Time(r_Last.Free_Time),
                     Htt_Util.To_Time(r.Free_Time));
      Get_Difference(z.Overtime,
                     t('overtime'),
                     Htt_Util.To_Time(r_Last.Overtime),
                     Htt_Util.To_Time(r.Overtime));
      Get_Difference(z.Turnout_Time,
                     t('turnout time'),
                     Htt_Util.To_Time(r_Last.Turnout_Time),
                     Htt_Util.To_Time(r.Turnout_Time));
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Timeoff_Files
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Hpd_Timeoff_Files%rowtype;
    v_Diff_Columns Array_Varchar2;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select *
                from x_Hpd_Timeoff_Files t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.t_Context_Id = i_Context_Id
                 and exists (select 1
                        from Hpd_Journal_Timeoffs s
                       where s.Company_Id = t.t_Company_Id
                         and s.Filial_Id = t.t_Filial_Id
                         and s.Journal_Id = i_Journal_Id
                         and s.Timeoff_Id = t.Timeoff_Id))
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hpd_Timeoff_Files t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Timeoff_Id = r.Timeoff_Id
                   and t.Sha = r.Sha
                   and t.t_Timestamp <= r.t_Timestamp
                   and t.t_Context_Id <> i_Context_Id
                 order by t.t_Timestamp desc) t
         where Rownum = 1;
      
      exception
        when others then
          null;
      end;
    
      if r.t_Event = 'D' then
        if r_Last.t_Event is null then
          r_Last := r;
        end if;
      
        r := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Timeoff_Files.Difference(r, r_Last);
    
      Get_Difference(z.Sha,
                     t('file name'),
                     z_Biruni_Files.Take(i_Sha => r_Last.Sha).File_Name,
                     z_Biruni_Files.Take(i_Sha => r.Sha).File_Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Journal_Id number := p.r_Number('journal_id');
    v_Context_Id number := p.r_Number('context_id');
    result       Hashmap := Hashmap();
  begin
    Result.Put('journals',
               Fazo.Zip_Matrix(Journals(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Journal_Id => v_Journal_Id,
                                        i_Context_Id => v_Context_Id)));
    Result.Put('pages',
               Fazo.Zip_Matrix(Pages(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => v_Journal_Id,
                                     i_Context_Id => v_Context_Id)));
    Result.Put('hirings',
               Fazo.Zip_Matrix(Hirings(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Journal_Id => v_Journal_Id,
                                       i_Context_Id => v_Context_Id)));
    Result.Put('dismissals',
               Fazo.Zip_Matrix(Dismissals(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => v_Journal_Id,
                                          i_Context_Id => v_Context_Id)));
    Result.Put('transfers',
               Fazo.Zip_Matrix(Transfers(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Journal_Id => v_Journal_Id,
                                         i_Context_Id => v_Context_Id)));
    Result.Put('robots',
               Fazo.Zip_Matrix(Robots(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Journal_Id => v_Journal_Id,
                                      i_Context_Id => v_Context_Id)));
    Result.Put('contracts',
               Fazo.Zip_Matrix(Contratcs(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Journal_Id => v_Journal_Id,
                                         i_Context_Id => v_Context_Id)));
    Result.Put('schedules',
               Fazo.Zip_Matrix(Schedules(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Journal_Id => v_Journal_Id,
                                         i_Context_Id => v_Context_Id)));
    Result.Put('schedule_changes',
               Fazo.Zip_Matrix(Schedule_Changes(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Journal_Id => v_Journal_Id,
                                                i_Context_Id => v_Context_Id)));
    Result.Put('vacation_limit_changes',
               Fazo.Zip_Matrix(Vacation_Limit_Change(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Journal_Id => v_Journal_Id,
                                                     i_Context_Id => v_Context_Id)));
    Result.Put('wage_changes',
               Fazo.Zip_Matrix(Wage_Changes(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Journal_Id => v_Journal_Id,
                                            i_Context_Id => v_Context_Id)));
    Result.Put('rank_changes',
               Fazo.Zip_Matrix(Rank_Changes(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Journal_Id => v_Journal_Id,
                                            i_Context_Id => v_Context_Id)));
    Result.Put('oper_types',
               Fazo.Zip_Matrix(Oper_Types(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => v_Journal_Id,
                                          i_Context_Id => v_Context_Id)));
    Result.Put('indicators',
               Fazo.Zip_Matrix(Indicators(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => v_Journal_Id,
                                          i_Context_Id => v_Context_Id)));
    Result.Put('currencies',
               Fazo.Zip_Matrix(Currencies(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => v_Journal_Id,
                                          i_Context_Id => v_Context_Id)));
    Result.Put('timeoffs',
               Fazo.Zip_Matrix(Timeoffs(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Journal_Id => v_Journal_Id,
                                        i_Context_Id => v_Context_Id)));
    Result.Put('sick_leaves',
               Fazo.Zip_Matrix(Sick_Leaves(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Journal_Id => v_Journal_Id,
                                           i_Context_Id => v_Context_Id)));
    Result.Put('business_trips',
               Fazo.Zip_Matrix(Business_Trips(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Journal_Id => v_Journal_Id,
                                              i_Context_Id => v_Context_Id)));
    Result.Put('business_trip_regions',
               Fazo.Zip_Matrix(Business_Trip_Regions(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Journal_Id => v_Journal_Id,
                                                     i_Context_Id => v_Context_Id)));
    Result.Put('overtimes',
               Fazo.Zip_Matrix(Overtimes(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Journal_Id => v_Journal_Id,
                                         i_Context_Id => v_Context_Id)));
    Result.Put('overtime_days',
               Fazo.Zip_Matrix(Overtime_Days(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Journal_Id => v_Journal_Id,
                                             i_Context_Id => v_Context_Id)));
    Result.Put('timebook_adjustments',
               Fazo.Zip_Matrix(Timebook_Adjustments(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Journal_Id => v_Journal_Id,
                                                    i_Context_Id => v_Context_Id)));
    Result.Put('timeoff_files',
               Fazo.Zip_Matrix(Timeoff_Files(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Journal_Id => v_Journal_Id,
                                             i_Context_Id => v_Context_Id)));
  
    return result;
  end;

end Ui_Vhr183;
/
