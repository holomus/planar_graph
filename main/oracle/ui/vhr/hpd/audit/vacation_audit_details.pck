create or replace package Ui_Vhr595 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr595;
/
create or replace package body Ui_Vhr595 is
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
    return b.Translate('UI-VHR595:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacations
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last           x_Hpd_Vacations%rowtype;
    v_Data           Matrix_Varchar2 := Matrix_Varchar2();
    v_Diff_Columns   Array_Varchar2;
    v_Vacation_Tk_Id number := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
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
                from x_Hpd_Vacations q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.t_Context_Id = i_Context_Id
                 and exists (select *
                        from x_Hpd_Journal_Timeoffs w
                       where w.t_Company_Id = i_Company_Id
                         and w.t_Filial_Id = i_Filial_Id
                         and w.Timeoff_Id = q.Timeoff_Id
                         and w.Journal_Id = i_Journal_Id))
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Hpd_Vacations t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Timeoff_Id = r.Timeoff_Id
                     and t.t_Context_Id <> i_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      
        if r_Last.Time_Kind_Id is null then
          r_Last.Time_Kind_Id := v_Vacation_Tk_Id;
        end if;
      
      elsif r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      else
        r_Last := null;
      end if;
    
      v_Diff_Columns := z_x_Hpd_Vacations.Difference(r, r_Last);
    
      Get_Difference(z.Time_Kind_Id,
                     t('time kind name'),
                     z_Htt_Time_Kinds.Take(i_Company_Id => i_Company_Id, i_Time_Kind_Id => r_Last.Time_Kind_Id).Name,
                     z_Htt_Time_Kinds.Take(i_Company_Id => i_Company_Id, i_Time_Kind_Id => r.Time_Kind_Id).Name);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    i_Journal_Id number := p.r_Number('journal_id');
    v_Context_Id number := p.r_Number('context_id');
    result       Hashmap := Hashmap();
  begin
    Result.Put('vacation',
               Fazo.Zip_Matrix(Vacations(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Journal_Id => i_Journal_Id,
                                         i_Context_Id => v_Context_Id)));
  
    return result;
  end;

end Ui_Vhr595;
/
