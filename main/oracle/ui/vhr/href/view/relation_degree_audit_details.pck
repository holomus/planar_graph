create or replace package Ui_Vhr380 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr380;
/
create or replace package body Ui_Vhr380 is
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
    return b.Translate('UI-VHR380:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Relation_Degrees
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number,
    i_Context_Id         number
  ) return Matrix_Varchar2 is
    r_Last         x_Href_Relation_Degrees%rowtype;
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
                from x_Href_Relation_Degrees q
               where q.t_Company_Id = i_Company_Id
                 and q.Relation_Degree_Id = i_Relation_Degree_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Href_Relation_Degrees t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Relation_Degree_Id = r.Relation_Degree_Id
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

      v_Diff_Columns := z_x_Href_Relation_Degrees.Difference(r, r_Last);

      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.Code, t('code'), r_Last.Code, r.Code);
      Get_Difference(z.State,
                     t('state'),
                     Md_Util.Decode(r_Last.State, 'A', Ui.t_Active, 'P', Ui.t_Passive),
                     Md_Util.Decode(r.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id         number := Ui.Company_Id;
    v_Context_Id         number := p.r_Number('context_id');
    v_Relation_Degree_Id number := p.r_Number('relation_degree_id');
    result               Hashmap := Hashmap();
  begin
    Result.Put('name',
               z_Href_Relation_Degrees.Take(i_Company_Id => v_Company_Id, i_Relation_Degree_Id => v_Relation_Degree_Id).Name);
    Result.Put('relation_degree',
               Fazo.Zip_Matrix(Relation_Degrees(i_Company_Id         => v_Company_Id,
                                                i_Relation_Degree_Id => v_Relation_Degree_Id,
                                                i_Context_Id         => v_Context_Id)));

    return result;
  end;

end Ui_Vhr380;
/
