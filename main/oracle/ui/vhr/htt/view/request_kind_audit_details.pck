create or replace package Ui_Vhr431 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr431;
/
create or replace package body Ui_Vhr431 is
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
    return b.Translate('UI-VHR431:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Kinds
  (
    i_Company_Id      number,
    i_Request_Kind_Id number,
    i_Context_Id      number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Request_Kinds%rowtype;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    v_Diff_Columns Array_Varchar2;

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
    for r in (select q.*
                from x_Htt_Request_Kinds q
               where q.t_Company_Id = i_Company_Id
                 and q.Request_Kind_Id = i_Request_Kind_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Htt_Request_Kinds t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Request_Kind_Id = r.Request_Kind_Id
                     and t.t_Context_Id <> i_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;

        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      else
        r_Last := null;
      end if;

      v_Diff_Columns := z_x_Htt_Request_Kinds.Difference(r, r_Last);

      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.Time_Kind_Id,
                     t('time kind name'),
                     z_Htt_Request_Kinds.Take(i_Company_Id => i_Company_Id, i_Request_Kind_Id => r_Last.Request_Kind_Id).Name,
                     z_Htt_Request_Kinds.Take(i_Company_Id => i_Company_Id, i_Request_Kind_Id => r.Request_Kind_Id).Name);
      Get_Difference(z.Annually_Limited,
                     t('annually limited'),
                     Md_Util.Decode(r_Last.Annually_Limited, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                     Md_Util.Decode(r.Annually_Limited, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      Get_Difference(z.Day_Count_Type,
                     t('day count type'),
                     Htt_Util.t_Day_Count_Type(r_Last.Day_Count_Type),
                     Htt_Util.t_Day_Count_Type(r.Day_Count_Type));
      Get_Difference(z.Annual_Day_Limit,
                     t('annual day limit'),
                     r_Last.Annual_Day_Limit,
                     r.Annual_Day_Limit);
      Get_Difference(z.User_Permitted,
                     t('user permitted'),
                     Md_Util.Decode(r_Last.User_Permitted, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                     Md_Util.Decode(r.User_Permitted, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      Get_Difference(z.Allow_Unused_Time,
                     t('allow unused time'),
                     Md_Util.Decode(r_Last.Allow_Unused_Time, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                     Md_Util.Decode(r.Allow_Unused_Time, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      Get_Difference(z.Request_Restriction_Days,
                     t('request restriction days'),
                     r_Last.Request_Restriction_Days,
                     r.Request_Restriction_Days);
      Get_Difference(z.Carryover_Policy,
                     'carryover policy name',
                     Htt_Util.t_Carryover_Policy(r_Last.Carryover_Policy),
                     Htt_Util.t_Carryover_Policy(r.Carryover_Policy));
      Get_Difference(z.Carryover_Cap_Days,
                     'carryover cap days',
                     r_Last.Carryover_Cap_Days,
                     r.Carryover_Cap_Days);
      Get_Difference(z.Carryover_Expires_Days,
                     'carryover expires days',
                     r_Last.Carryover_Expires_Days,
                     r.Carryover_Expires_Days);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id      number := Ui.Company_Id;
    result            Hashmap := Hashmap();
    v_Request_Kind_Id number := p.r_Number('request_kind_id');
    v_Context_Id      number := p.r_Number('context_id');
  begin
    Result.Put('name',
               z_Htt_Request_Kinds.Take(i_Company_Id => v_Company_Id, i_Request_Kind_Id => v_Request_Kind_Id).Name);
    Result.Put('request_kind',
               Fazo.Zip_Matrix(Request_Kinds(i_Company_Id      => v_Company_Id,
                                             i_Request_Kind_Id => v_Request_Kind_Id,
                                             i_Context_Id      => v_Context_Id)));

    return result;
  end;

end Ui_Vhr431;
/
