create or replace package Ui_Vhr230 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr230;
/
create or replace package body Ui_Vhr230 is
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
    return b.Translate('UI-VHR230:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Plan_Changes%rowtype;
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
                from x_Htt_Plan_Changes t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Change_Id = i_Change_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Htt_Plan_Changes t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Change_Id = i_Change_Id
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

      v_Diff_Columns := z_x_Htt_Plan_Changes.Difference(r, r_Last);

      Get_Difference(z.Change_Kind,
                     t('change kind name'),
                     Htt_Util.t_Change_Kind(r_Last.Change_Kind),
                     Htt_Util.t_Change_Kind(r.Change_Kind));
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
      Get_Difference(z.Manager_Note, t('manager note'), r_Last.Manager_Note, r.Manager_Note);
      Get_Difference(z.Status,
                     t('status'),
                     Htt_Util.t_Change_Status(r_Last.Status),
                     Htt_Util.t_Change_Status(r.Status));
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Change_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Change_Id  number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Change_Days%rowtype;
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
                from x_Htt_Change_Days t
               where t.t_Company_Id = i_Company_Id
                 and t.t_Filial_Id = i_Filial_Id
                 and t.Change_Id = Change_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Htt_Change_Days t
                 where t.t_Company_Id = i_Company_Id
                   and t.t_Filial_Id = i_Filial_Id
                   and t.Change_Id = i_Change_Id
                   and t.Change_Date = r.Change_Date
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

      v_Diff_Columns := z_x_Htt_Change_Days.Difference(r, r_Last);

      Get_Difference(z.Change_Date, t('change date'), r_Last.Change_Date, r.Change_Date);
      Get_Difference(z.Swapped_Date, t('swapped date'), r_Last.Swapped_Date, r.Swapped_Date);
      Get_Difference(z.Day_Kind,
                     t('day kind name'),
                     Htt_Util.t_Day_Kind(r_Last.Day_Kind),
                     Htt_Util.t_Day_Kind(r.Day_Kind));
      Get_Difference(z.Begin_Time,
                     t('begin time'),
                     to_char(r_Last.Begin_Time, Href_Pref.c_Date_Format_Minute),
                     to_char(r.Begin_Time, Href_Pref.c_Date_Format_Minute));
      Get_Difference(z.End_Time,
                     t('end time'),
                     to_char(r_Last.End_Time, Href_Pref.c_Date_Format_Minute),
                     to_char(r.End_Time, Href_Pref.c_Date_Format_Minute));
      Get_Difference(z.Break_Enabled,
                     t('break enabled'),
                     Md_Util.Decode(i_Kind        => r_Last.Break_Enabled,
                                    i_First_Kind  => 'Y',
                                    i_First_Name  => Ui.t_Yes,
                                    i_Second_Kind => 'N',
                                    i_Second_Name => Ui.t_No),
                     Md_Util.Decode(i_Kind        => r.Break_Enabled,
                                    i_First_Kind  => 'Y',
                                    i_First_Name  => Ui.t_Yes,
                                    i_Second_Kind => 'N',
                                    i_Second_Name => Ui.t_No));
      Get_Difference(z.Break_Begin_Time,
                     t('break begin time'),
                     to_char(r_Last.Break_Begin_Time, Href_Pref.c_Date_Format_Minute),
                     to_char(r.Break_Begin_Time, Href_Pref.c_Date_Format_Minute));
      Get_Difference(z.Break_End_Time,
                     t('break end time'),
                     to_char(r_Last.Break_End_Time, Href_Pref.c_Date_Format_Minute),
                     to_char(r.Break_End_Time, Href_Pref.c_Date_Format_Minute));
      Get_Difference(z.Plan_Time,
                     t('plan time'),
                     Htt_Util.To_Time_Seconds_Text(r_Last.Plan_Time, true),
                     Htt_Util.To_Time_Seconds_Text(r.Plan_Time, true));
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Change_Id  number := p.r_Number('change_id');
    v_Context_Id number := p.r_Number('context_id');
    result       Hashmap := Hashmap();
  begin
    Result.Put('changes',
               Fazo.Zip_Matrix(Changes(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Change_Id  => v_Change_Id,
                                       i_Context_Id => v_Context_Id)));
    Result.Put('change_days',
               Fazo.Zip_Matrix(Change_Days(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Change_Id  => v_Change_Id,
                                           i_Context_Id => v_Context_Id)));

    return result;
  end;

end Ui_Vhr230;
/
