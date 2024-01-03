create or replace package Ui_Vhr203 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr203;
/
create or replace package body Ui_Vhr203 is
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
    return b.Translate('UI-VHR203:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plans
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Context_Id    number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Staff_Plans%rowtype;
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
                from x_Hper_Staff_Plans t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Staff_Plan_Id = i_Staff_Plan_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hper_Staff_Plans t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Staff_Plan_Id = i_Staff_Plan_Id
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

      v_Diff_Columns := z_x_Hper_Staff_Plans.Difference(r, r_Last);

      Get_Difference(z.Staff_Id,
                     t('staff name'),
                     Href_Util.Staff_Name(i_Company_Id => r_Last.t_Company_Id,
                                          i_Filial_Id  => r_Last.t_Filial_Id,
                                          i_Staff_Id   => r_Last.Staff_Id),
                     Href_Util.Staff_Name(i_Company_Id => r.t_Company_Id,
                                          i_Filial_Id  => r.t_Filial_Id,
                                          i_Staff_Id   => r.Staff_Id));
      Get_Difference(z.Plan_Date, t('plan date'), r_Last.Plan_Date, r.Plan_Date);
      Get_Difference(z.Main_Calc_Type,
                     t('main calc type name'),
                     Hper_Util.t_Plan_Calc_Type(r_Last.Main_Calc_Type),
                     Hper_Util.t_Plan_Calc_Type(r.Main_Calc_Type));
      Get_Difference(z.Main_Calc_Type,
                     t('extra calc type name'),
                     Hper_Util.t_Plan_Calc_Type(r_Last.Extra_Calc_Type),
                     Hper_Util.t_Plan_Calc_Type(r.Extra_Calc_Type));
      Get_Difference(z.Month_Begin_Date,
                     t('month begin date'),
                     r_Last.Month_Begin_Date,
                     r.Month_Begin_Date);
      Get_Difference(z.Month_End_Date,
                     t('month end date'),
                     r_Last.Month_End_Date,
                     r.Month_End_Date);
      Get_Difference(z.Division_Id,
                     t('division name'),
                     z_Mhr_Divisions.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Division_Id => r_Last.Division_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Division_Id => r.Division_Id).Name);
      Get_Difference(z.Job_Id,
                     t('job name'),
                     z_Mhr_Jobs.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Job_Id => r_Last.Job_Id).Name,
                     z_Mhr_Jobs.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Job_Id => r.Job_Id).Name);
      Get_Difference(z.Rank_Id,
                     t('rank name'),
                     z_Mhr_Ranks.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Rank_Id => r_Last.Rank_Id).Name,
                     z_Mhr_Ranks.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Rank_Id => r.Rank_Id).Name);
      Get_Difference(z.Employment_Type,
                     t('employment type name'),
                     Hpd_Util.t_Employment_Type(r_Last.Employment_Type),
                     Hpd_Util.t_Employment_Type(r.Employment_Type));
      Get_Difference(z.Begin_Date, t('begin date'), r_Last.Begin_Date, r.Begin_Date);
      Get_Difference(z.End_Date, t('end date'), r_Last.End_Date, r.End_Date);
      Get_Difference(z.Main_Plan_Amount,
                     t('main plan amount'),
                     r_Last.Main_Plan_Amount,
                     r.Main_Plan_Amount);
      Get_Difference(z.Extra_Plan_Amount,
                     t('extra plan amount'),
                     r_Last.Extra_Plan_Amount,
                     r.Extra_Plan_Amount);
      Get_Difference(z.Main_Fact_Amount,
                     t('main fact amount'),
                     r_Last.Main_Fact_Amount,
                     r.Main_Fact_Amount);
      Get_Difference(z.Extra_Fact_Amount,
                     t('extra fact amount'),
                     r_Last.Extra_Fact_Amount,
                     r.Extra_Fact_Amount);
      Get_Difference(z.Main_Fact_Percent,
                     t('main fact percent'),
                     r_Last.Main_Fact_Percent,
                     r.Main_Fact_Percent);
      Get_Difference(z.Extra_Fact_Percent,
                     t('extra fact percent'),
                     r_Last.Extra_Fact_Percent,
                     r.Extra_Fact_Percent);
      Get_Difference(z.c_Main_Fact_Percent,
                     t('c_main fact percent'),
                     r_Last.c_Main_Fact_Percent,
                     r.c_Main_Fact_Percent);
      Get_Difference(z.c_Extra_Fact_Percent,
                     t('c_extra fact percent'),
                     r_Last.c_Extra_Fact_Percent,
                     r.c_Extra_Fact_Percent);
      Get_Difference(z.Status,
                     t('status name'),
                     Hper_Util.t_Staff_Plan_Status(r_Last.Status),
                     Hper_Util.t_Staff_Plan_Status(r.Status));
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Items
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Context_Id    number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Staff_Plan_Items%rowtype;
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
                from x_Hper_Staff_Plan_Items t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Staff_Plan_Id = i_Staff_Plan_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hper_Staff_Plan_Items t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Staff_Plan_Id = i_Staff_Plan_Id
                   and t.Plan_Type_Id = r.Plan_Type_Id
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

      v_Diff_Columns := z_x_Hper_Staff_Plan_Items.Difference(r, r_Last);

      Get_Difference(z.Plan_Type_Id,
                     t('plan type name'),
                     z_Hper_Plan_Types.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Plan_Type_Id => r_Last.Plan_Type_Id).Name,
                     z_Hper_Plan_Types.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Plan_Type_Id => r.Plan_Type_Id).Name);
      Get_Difference(z.Plan_Type,
                     t('plan type'),
                     Hper_Util.t_Plan_Type(r_Last.Plan_Type),
                     Hper_Util.t_Plan_Type(r.Plan_Type));
      Get_Difference(z.Plan_Value, t('plan value'), r_Last.Plan_Value, r.Plan_Value);
      Get_Difference(z.Plan_Amount, t('plan amount'), r_Last.Plan_Amount, r.Plan_Amount);
      Get_Difference(z.Fact_Value, t('fact value'), r_Last.Fact_Value, r.Fact_Value);
      Get_Difference(z.Fact_Percent, t('fact percent'), r_Last.Fact_Percent, r.Fact_Percent);
      Get_Difference(z.Fact_Amount, t('fact amount'), r_Last.Fact_Amount, r.Fact_Amount);
      Get_Difference(z.Calc_Kind,
                     t('calc kind name'),
                     Hper_Util.t_Calc_Kind(r_Last.Calc_Kind),
                     Hper_Util.t_Calc_Kind(r.Calc_Kind));
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
      Get_Difference(z.Fact_Note, t('fact note'), r_Last.Fact_Note, r.Fact_Note);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Parts
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Context_Id    number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Staff_Plan_Parts%rowtype;
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
                from x_Hper_Staff_Plan_Parts t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Staff_Plan_Id = i_Staff_Plan_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hper_Staff_Plan_Parts t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Part_Id = r.Part_Id
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

      v_Diff_Columns := z_x_Hper_Staff_Plan_Parts.Difference(r, r_Last);

      Get_Difference(z.Plan_Type_Id,
                     t('plan type name'),
                     z_Hper_Plan_Types.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Plan_Type_Id => r_Last.Plan_Type_Id).Name,
                     z_Hper_Plan_Types.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Plan_Type_Id => r.Plan_Type_Id).Name);
      Get_Difference(z.Part_Date, t('part date'), r_Last.Part_Date, r.Part_Date);
      Get_Difference(z.Amount, t('amount'), r_Last.Amount, r.Amount);
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Rules
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Context_Id    number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Staff_Plan_Rules%rowtype;
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
                from x_Hper_Staff_Plan_Rules t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Staff_Plan_Id = i_Staff_Plan_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Hper_Staff_Plan_Rules t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Staff_Plan_Id = i_Staff_Plan_Id
                   and t.Plan_Type_Id = r.Plan_Type_Id
                   and t.From_Percent = r.From_Percent
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

      v_Diff_Columns := z_x_Hper_Staff_Plan_Rules.Difference(r, r_Last);

      Get_Difference(z.Plan_Type_Id,
                     t('plan type name'),
                     z_Hper_Plan_Types.Take(i_Company_Id => r_Last.t_Company_Id, i_Filial_Id => r_Last.t_Filial_Id, i_Plan_Type_Id => r_Last.Plan_Type_Id).Name,
                     z_Hper_Plan_Types.Take(i_Company_Id => r.t_Company_Id, i_Filial_Id => r.t_Filial_Id, i_Plan_Type_Id => r.Plan_Type_Id).Name);
      Get_Difference(z.From_Percent, t('from percent'), r_Last.From_Percent, r.From_Percent);
      Get_Difference(z.To_Percent, t('to percent'), r_Last.To_Percent, r.To_Percent);
      Get_Difference(z.Fact_Amount, t('fact amount'), r_Last.Fact_Amount, r.Fact_Amount);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Staff_Plan_Id number := p.r_Number('staff_plan_id');
    v_Context_Id    number := p.r_Number('context_id');
    result          Hashmap := Hashmap();
  begin
    Result.Put('staff_plans',
               Fazo.Zip_Matrix(Staff_Plans(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Staff_Plan_Id => v_Staff_Plan_Id,
                                           i_Context_Id    => v_Context_Id)));
    Result.Put('staff_plan_items',
               Fazo.Zip_Matrix(Staff_Plan_Items(i_Company_Id    => Ui.Company_Id,
                                                i_Filial_Id     => Ui.Filial_Id,
                                                i_Staff_Plan_Id => v_Staff_Plan_Id,
                                                i_Context_Id    => v_Context_Id)));
    Result.Put('staff_plan_parts',
               Fazo.Zip_Matrix(Staff_Plan_Parts(i_Company_Id    => Ui.Company_Id,
                                                i_Filial_Id     => Ui.Filial_Id,
                                                i_Staff_Plan_Id => v_Staff_Plan_Id,
                                                i_Context_Id    => v_Context_Id)));
    Result.Put('staff_plan_rules',
               Fazo.Zip_Matrix(Staff_Plan_Rules(i_Company_Id    => Ui.Company_Id,
                                                i_Filial_Id     => Ui.Filial_Id,
                                                i_Staff_Plan_Id => v_Staff_Plan_Id,
                                                i_Context_Id    => v_Context_Id)));

    return result;
  end;

end Ui_Vhr203;
/
