create or replace package Ui_Vhr398 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr398;
/
create or replace package body Ui_Vhr398 is
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
    return b.Translate('UI-VHR398:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wages
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Href_Wages%rowtype;
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
                from x_Href_Wages q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Wage_Id = i_Wage_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Href_Wages t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.t_Filial_Id = r.t_Filial_Id
                     and t.Wage_Id = r.Wage_Id
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

      v_Diff_Columns := z_x_Href_Wages.Difference(r, r_Last);

      Get_Difference(z.Job_Id,
                     t('job name'),
                     z_Mhr_Jobs.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Job_Id => r_Last.Job_Id).Name,
                     z_Mhr_Jobs.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Job_Id => r.Job_Id).Name);
      Get_Difference(z.Rank_Id,
                     t('rank name'),
                     z_Mhr_Ranks.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Rank_Id => r_Last.Rank_Id).Name,
                     z_Mhr_Ranks.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Rank_Id => r.Rank_Id).Name);
      Get_Difference(z.Wage_Begin, t('wage begin'), r_Last.Wage_Begin, r.Wage_Begin);
      Get_Difference(z.Wage_End, t('wage end'), r_Last.Wage_End, r.Wage_End);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Data       Href_Wages%rowtype;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Wage_Id    number := p.r_Number('wage_id');
    v_Context_Id number := p.r_Number('context_id');
    result       Hashmap := Hashmap();
  begin
    r_Data := z_Href_Wages.Take(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Wage_Id    => v_Wage_Id);

    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Job_Id => r_Data.Job_Id).Name);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Rank_Id => r_Data.Rank_Id).Name);
    Result.Put('wage',
               Fazo.Zip_Matrix(Wages(i_Company_Id => v_Company_Id,
                                     i_Filial_Id  => v_Filial_Id,
                                     i_Wage_Id    => v_Wage_Id,
                                     i_Context_Id => v_Context_Id)));

    return result;
  end;

end Ui_Vhr398;
/
