create or replace package Ui_Vhr401 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr401;
/
create or replace package body Ui_Vhr401 is
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
    return b.Translate('UI-VHR401:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employment_Sources
  (
    i_Company_Id number,
    i_Source_Id  number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Href_Employment_Sources%rowtype;
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
                from x_Href_Employment_Sources q
               where q.t_Company_Id = i_Company_Id
                 and q.Source_Id = i_Source_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Href_Employment_Sources t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Source_Id = r.Source_Id
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

      v_Diff_Columns := z_x_Href_Employment_Sources.Difference(r, r_Last);

      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.Order_No, t('order no'), r_Last.Order_No, r.Order_No);
      Get_Difference(z.Kind,
                     t('kind name'),
                     Href_Util.t_Employment_Source(r_Last.Kind),
                     Href_Util.t_Employment_Source(r.Kind));
      Get_Difference(z.State,
                     t('state'),
                     Md_Util.Decode(r_Last.State, 'A', Ui.t_Active, 'P', Ui.t_Passive),
                     Md_Util.Decode(r.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    result       Hashmap := Hashmap();
    v_Source_Id  number := p.r_Number('source_id');
    v_Context_Id number := p.r_Number('context_id');
  begin
    Result.Put('name',
               z_Href_Employment_Sources.Take(i_Company_Id => v_Company_Id, i_Source_Id => v_Source_Id).Name);
    Result.Put('source',
               Fazo.Zip_Matrix(Employment_Sources(i_Company_Id => v_Company_Id,
                                                  i_Source_Id  => v_Source_Id,
                                                  i_Context_Id => v_Context_Id)));

    return result;
  end;

end Ui_Vhr401;
/
