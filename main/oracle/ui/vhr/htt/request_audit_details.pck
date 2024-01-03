create or replace package Ui_Vhr175 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr175;
/
create or replace package body Ui_Vhr175 is
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
    return b.Translate('UI-VHR175:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Requests
  (
    i_Company_Id number,
    i_Request_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Requests%rowtype;
    v_Last_Format  varchar2(20);
    v_Format       varchar(20);
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
                from x_Htt_Requests t
               where t.t_Company_Id = i_Company_Id
                 and t.Request_Id = i_Request_Id
                 and t.t_Context_Id = i_Context_Id)
    loop
      begin
        select *
          into r_Last
          from (select *
                  from x_Htt_Requests t
                 where t.t_Company_Id = i_Company_Id
                   and t.Request_Id = i_Request_Id
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

      v_Diff_Columns := z_x_Htt_Requests.Difference(r, r_Last);

      v_Format      := Href_Pref.c_Date_Format_Day;
      v_Last_Format := Href_Pref.c_Date_Format_Day;

      if r.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
        v_Format := Href_Pref.c_Date_Format_Minute;
      end if;

      if r_Last.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
        v_Last_Format := Href_Pref.c_Date_Format_Minute;
      end if;

      Get_Difference(z.Request_Kind_Id,
                     t('request kind name'),
                     z_Htt_Request_Kinds.Take(i_Company_Id => i_Company_Id, i_Request_Kind_Id => r_Last.Request_Kind_Id).Name,
                     z_Htt_Request_Kinds.Take(i_Company_Id => i_Company_Id, i_Request_Kind_Id => r.Request_Kind_Id).Name);
      Get_Difference(z.Begin_Time,
                     t('begin time'),
                     to_char(r_Last.Begin_Time, v_Last_Format),
                     to_char(r.Begin_Time, v_Format));
      Get_Difference(z.End_Time,
                     t('end time'),
                     to_char(r_Last.End_Time, v_Last_Format),
                     to_char(r.End_Time, v_Format));
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);

      if z.Status member of v_Diff_Columns then
        Fazo.Push(v_Data,
                  t('status'),
                  Htt_Util.t_Request_Status(r_Last.Status),
                  Htt_Util.t_Request_Status(r.Status));
      end if;
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('request_name', Htt_Util.Tname_Request(i_Request_Id => p.r_Number('request_id')));
    Result.Put('requests',
               Fazo.Zip_Matrix(Requests(i_Company_Id => Ui.Company_Id,
                                        i_Request_Id => p.r_Number('request_id'),
                                        i_Context_Id => p.r_Number('context_id'))));

    return result;
  end;

end Ui_Vhr175;
/
