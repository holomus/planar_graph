create or replace package Ui_Vhr435 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr435;
/
create or replace package body Ui_Vhr435 is
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
    return b.Translate('UI-VHR435:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Groups
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Plan_Group_Id number,
    i_Context_Id    number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Plan_Groups%rowtype;
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
                from x_Hper_Plan_Groups q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Plan_Group_Id = i_Plan_Group_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Hper_Plan_Groups t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.t_Filial_Id = r.t_Filial_Id
                     and t.Plan_Group_Id = r.Plan_Group_Id
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

      v_Diff_Columns := z_x_Hper_Plan_Groups.Difference(r, r_Last);

      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.State,
                     t('state'),
                     Md_Util.Decode(r_Last.State, 'A', Ui.t_Active, 'P', Ui.t_Passive),
                     Md_Util.Decode(r.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
      Get_Difference(z.Order_No, t('order no'), r_Last.Order_No, r.Order_No);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Context_Id    number := p.r_Number('context_id');
    v_Plan_Group_Id number := p.r_Number('plan_group_id');
    result          Hashmap := Hashmap();
  begin
    Result.Put('name',
               z_Hper_Plan_Groups.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Plan_Group_Id => v_Plan_Group_Id).Name);
    Result.Put('plan_group',
               Fazo.Zip_Matrix(Plan_Groups(i_Company_Id    => v_Company_Id,
                                           i_Filial_Id     => v_Filial_Id,
                                           i_Plan_Group_Id => v_Plan_Group_Id,
                                           i_Context_Id    => v_Context_Id)));

    return result;
  end;

end Ui_Vhr435;
/
