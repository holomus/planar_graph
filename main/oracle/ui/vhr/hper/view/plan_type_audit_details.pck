create or replace package Ui_Vhr437 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr437;
/
create or replace package body Ui_Vhr437 is
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
    return b.Translate('UI-VHR437:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Types
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Context_Id   number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Plan_Types%rowtype;
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
                from x_Hper_Plan_Types q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Plan_Type_Id = i_Plan_Type_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Hper_Plan_Types t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.t_Filial_Id = r.t_Filial_Id
                     and t.Plan_Type_Id = r.Plan_Type_Id
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

      v_Diff_Columns := z_x_Hper_Plan_Types.Difference(r, r_Last);

      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.Code, t('code'), r_Last.Code, r.Code);
      Get_Difference(z.Order_No, t('order no'), r_Last.Order_No, r.Order_No);
      Get_Difference(z.Calc_Kind,
                     t('calc kind name'),
                     Hper_Util.t_Calc_Kind(r_Last.Calc_Kind),
                     Hper_Util.t_Calc_Kind(r.Calc_Kind));
      Get_Difference(z.With_Part,
                     t('with part'),
                     Md_Util.Decode(r_Last.With_Part, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                     Md_Util.Decode(r.With_Part, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      Get_Difference(z.State,
                     t('state'),
                     Md_Util.Decode(r_Last.State, 'A', Ui.t_Active, 'P', Ui.t_Passive),
                     Md_Util.Decode(r.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
      Get_Difference(z.Plan_Group_Id,
                     t('plan group name'),
                     z_Hper_Plan_Groups.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Plan_Group_Id => r_Last.Plan_Group_Id).Name,
                     z_Hper_Plan_Groups.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Plan_Group_Id => r.Plan_Group_Id).Name);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Divisions
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Context_Id   number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Plan_Type_Divisions%rowtype;
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
                from x_Hper_Plan_Type_Divisions q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Plan_Type_Id = i_Plan_Type_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      end if;

      if r.t_Event = 'I' then
        r_Last := null;
      end if;

      v_Diff_Columns := z_x_Hper_Plan_Type_Divisions.Difference(r, r_Last);

      Get_Difference(z.Division_Id,
                     t('division name'),
                     z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => r_Last.Division_Id).Name,
                     z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => r.Division_Id).Name);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Task_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Context_Id   number
  ) return Matrix_Varchar2 is
    r_Last         x_Hper_Plan_Type_Task_Types%rowtype;
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
                from x_Hper_Plan_Type_Task_Types q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Plan_Type_Id = i_Plan_Type_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      end if;

      if r.t_Event = 'I' then
        r_Last := null;
      end if;

      v_Diff_Columns := z_x_Hper_Plan_Type_Task_Types.Difference(r, r_Last);

      Get_Difference(z.Task_Type_Id,
                     t('task type name'),
                     z_Ms_Task_Types.Take(i_Company_Id => i_Company_Id, i_Task_Type_Id => r_Last.Task_Type_Id).Name,
                     z_Ms_Task_Types.Take(i_Company_Id => i_Company_Id, i_Task_Type_Id => r.Task_Type_Id).Name);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    result         Hashmap := Hashmap();
    v_Plan_Type_Id number := p.r_Number('plan_type_id');
    v_Context_Id   number := p.r_Number('context_id');
  begin
    Result.Put('name',
               z_Hper_Plan_Types.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Plan_Type_Id => v_Plan_Type_Id).Name);
    Result.Put('plan_type',
               Fazo.Zip_Matrix(Plan_Types(i_Company_Id   => v_Company_Id,
                                          i_Filial_Id    => v_Filial_Id,
                                          i_Plan_Type_Id => v_Plan_Type_Id,
                                          i_Context_Id   => v_Context_Id)));
    Result.Put('division',
               Fazo.Zip_Matrix(Divisions(i_Company_Id   => v_Company_Id,
                                         i_Filial_Id    => v_Filial_Id,
                                         i_Plan_Type_Id => v_Plan_Type_Id,
                                         i_Context_Id   => v_Context_Id)));
    Result.Put('task_type',
               Fazo.Zip_Matrix(Task_Type(i_Company_Id   => v_Company_Id,
                                         i_Filial_Id    => v_Filial_Id,
                                         i_Plan_Type_Id => v_Plan_Type_Id,
                                         i_Context_Id   => v_Context_Id)));

    return result;
  end;

end Ui_Vhr437;
/
