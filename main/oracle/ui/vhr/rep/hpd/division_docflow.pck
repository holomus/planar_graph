create or replace package Ui_Vhr295 is
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr295;
/
create or replace package body Ui_Vhr295 is
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
    return b.Translate('UI-VHR295:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate)));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run_All
  (
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number := null
  ) is
    a            b_Table := b_Report.New_Table();
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Column              number := 1;
    v_Hiring_Count        number;
    v_Dismissal_Count     number;
    v_Transfer_To_Count   number;
    v_Transfer_From_Count number;
  
    v_Hiring_Values        Fazo.Number_Code_Aat;
    v_Dismissal_Values     Fazo.Number_Code_Aat;
    v_Transfer_To_Values   Fazo.Number_Code_Aat;
    v_Transfer_From_Values Fazo.Number_Code_Aat;
  
    v_Max_Hiring_Count        number;
    v_Max_Dismissal_Count     number;
    v_Max_Transfer_To_Count   number;
    v_Max_Transfer_From_Count number;
  
    v_Min_Hiring_Count        number;
    v_Min_Dismissal_Count     number;
    v_Min_Transfer_To_Count   number;
    v_Min_Transfer_From_Count number;
  
    v_Division_Ids Array_Number;
    v_Style        varchar2(100);
    v_Calc         Calc := Calc();
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  begin
    a.Current_Style('root bold');
    a.New_Row;
    a.New_Row;
    a.Data(t('period: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 5);
  
    -- header  
    a.Current_Style('header middle primary');
  
    a.New_Row;
    a.New_Row;
    Print_Header(t('division_name'), 1, 2, 300);
    Print_Header(t('hirings'), 2, 1, 100);
    Print_Header(t('dismissals'), 2, 1, 100);
    Print_Header(t('transfer to'), 2, 1, 100);
    Print_Header(t('transfer from'), 2, 1, 100);
  
    a.New_Row;
    for i in 1 .. 4
    loop
      a.Data(t('Quantity'), 'header success');
      a.Data(t('Quantity %'), 'header danger');
    end loop;
  
    if Uit_Href.User_Access_All_Employees = 'Y' then
      select q.Division_Id
        bulk collect
        into v_Division_Ids
        from Mhr_Divisions q
        join Hrm_Divisions p
          on p.Company_Id = q.Company_Id
         and p.Filial_Id = q.Filial_Id
         and p.Division_Id = q.Division_Id
         and p.Is_Department = 'Y'
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.State = 'A'
       order by Lower(q.Name);
    else
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                           i_Indirect         => true,
                                                           i_Manual           => true,
                                                           i_Only_Departments => 'Y');
    end if;
  
    if i_Division_Ids.Count > 0 then
      v_Division_Ids := v_Division_Ids multiset intersect i_Division_Ids;
    end if;
  
    v_Max_Hiring_Count        := -1;
    v_Max_Dismissal_Count     := -1;
    v_Max_Transfer_To_Count   := -1;
    v_Max_Transfer_From_Count := -1;
    v_Min_Hiring_Count        := 999999;
    v_Min_Dismissal_Count     := 999999;
    v_Min_Transfer_To_Count   := 999999;
    v_Min_Transfer_From_Count := 999999;
  
    for i in 1 .. v_Division_Ids.Count
    loop
      -- calc hirings
      select count(t.Journal_Id)
        into v_Hiring_Count
        from Hpd_Transactions t
        join Hpd_Page_Robots r
          on t.Company_Id = r.Company_Id
         and t.Filial_Id = r.Filial_Id
         and t.Page_Id = r.Page_Id
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
         and t.Tag = Zt.Hpd_Hirings.Name
         and t.Begin_Date between i_Begin_Date and i_End_Date
         and r.Division_Id = v_Division_Ids(i);
    
      v_Calc.Plus('total_hiring', v_Hiring_Count);
      v_Hiring_Values(v_Division_Ids(i)) := v_Hiring_Count;
    
      v_Max_Hiring_Count := Greatest(v_Max_Hiring_Count, v_Hiring_Count);
      v_Min_Hiring_Count := Least(v_Min_Hiring_Count, v_Hiring_Count);
    
      -- calc dismissal
      select count(d.Journal_Id)
        into v_Dismissal_Count
        from Hpd_Dismissal_Transactions d
        join Hpd_Dismissals p
          on p.Company_Id = d.Company_Id
         and p.Filial_Id = d.Filial_Id
         and p.Page_Id = d.Page_Id
        join Href_Staffs s
          on d.Company_Id = s.Company_Id
         and d.Filial_Id = s.Filial_Id
         and d.Staff_Id = s.Staff_Id
       where d.Company_Id = v_Company_Id
         and d.Filial_Id = v_Filial_Id
         and d.Dismissal_Date - 1 between i_Begin_Date and i_End_Date
         and s.Division_Id = v_Division_Ids(i);
    
      v_Calc.Plus('total_dismissal', v_Dismissal_Count);
      v_Dismissal_Values(v_Division_Ids(i)) := v_Dismissal_Count;
    
      v_Max_Dismissal_Count := Greatest(v_Max_Dismissal_Count, v_Dismissal_Count);
      v_Min_Dismissal_Count := Least(v_Min_Dismissal_Count, v_Dismissal_Count);
    
      -- calc transfer to
      select count(t.Journal_Id)
        into v_Transfer_To_Count
        from Hpd_Transactions t
        join Hpd_Page_Robots r
          on t.Company_Id = r.Company_Id
         and t.Filial_Id = r.Filial_Id
         and t.Page_Id = r.Page_Id
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
         and t.Tag = Zt.Hpd_Transfers.Name
         and t.Begin_Date between i_Begin_Date and i_End_Date
         and r.Division_Id = v_Division_Ids(i);
    
      v_Calc.Plus('total_transfer_to', v_Transfer_To_Count);
      v_Transfer_To_Values(v_Division_Ids(i)) := v_Transfer_To_Count;
    
      v_Max_Transfer_To_Count := Greatest(v_Max_Transfer_To_Count, v_Transfer_To_Count);
      v_Min_Transfer_To_Count := Least(v_Min_Transfer_To_Count, v_Transfer_To_Count);
    
      -- calc transfer from
      select count(t.Journal_Id)
        into v_Transfer_From_Count
        from Hpd_Transactions t
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
         and t.Tag = Zt.Hpd_Transfers.Name
         and t.Begin_Date between i_Begin_Date and i_End_Date
         and exists (select q.Trans_Id
                from Hpd_Agreements q
                join Hpd_Trans_Robots r
                  on q.Company_Id = r.Company_Id
                 and q.Filial_Id = r.Filial_Id
                 and q.Trans_Id = r.Trans_Id
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.Staff_Id = t.Staff_Id
                 and q.Trans_Type = t.Trans_Type
                 and r.Division_Id = v_Division_Ids(i)
                 and q.Action = Hpd_Pref.c_Transaction_Action_Continue
                 and q.Period = (select max(w.Period)
                                   from Hpd_Agreements w
                                  where w.Company_Id = v_Company_Id
                                    and w.Filial_Id = v_Filial_Id
                                    and w.Staff_Id = t.Staff_Id
                                    and w.Trans_Type = t.Trans_Type
                                    and w.Period <= t.Begin_Date - 1));
    
      v_Calc.Plus('total_transfer_from', v_Transfer_From_Count);
      v_Transfer_From_Values(v_Division_Ids(i)) := v_Transfer_From_Count;
    
      v_Max_Transfer_From_Count := Greatest(v_Max_Transfer_From_Count, v_Transfer_From_Count);
      v_Min_Transfer_From_Count := Least(v_Min_Transfer_From_Count, v_Transfer_From_Count);
    end loop;
  
    for i in 1 .. v_Division_Ids.Count
    loop
      -- body
      a.Current_Style('body_centralized');
    
      a.New_Row;
    
      a.Data(z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, --
             i_Filial_Id => v_Filial_Id, --             
             i_Division_Id => v_Division_Ids(i)).Name);
    
      -- hiring
      if v_Hiring_Values(v_Division_Ids(i)) = v_Max_Hiring_Count then
        v_Style := 'body number lightdanger';
      elsif v_Hiring_Values(v_Division_Ids(i)) = v_Min_Hiring_Count then
        v_Style := 'body number info';
      else
        v_Style := 'body number';
      end if;
    
      a.Data(v_Hiring_Values(v_Division_Ids(i)), v_Style);
    
      if v_Max_Hiring_Count > 0 then
        a.Data(Round(v_Hiring_Values(v_Division_Ids(i)) / v_Calc.Get_Value('total_hiring') * 100,
                     2),
               'body number lightgreen');
      else
        a.Data();
      end if;
    
      -- dismissal
      if v_Dismissal_Values(v_Division_Ids(i)) = v_Max_Dismissal_Count then
        v_Style := 'body number lightdanger';
      elsif v_Dismissal_Values(v_Division_Ids(i)) = v_Min_Dismissal_Count then
        v_Style := 'body number info';
      else
        v_Style := 'body number';
      end if;
    
      a.Data(v_Dismissal_Values(v_Division_Ids(i)), v_Style);
    
      if v_Max_Dismissal_Count > 0 then
        a.Data(Round(v_Dismissal_Values(v_Division_Ids(i)) / v_Calc.Get_Value('total_dismissal') * 100,
                     2),
               'body number lightgreen');
      else
        a.Data();
      end if;
    
      -- transfer to
      if v_Transfer_To_Values(v_Division_Ids(i)) = v_Max_Transfer_To_Count then
        v_Style := 'body number lightdanger';
      elsif v_Transfer_To_Values(v_Division_Ids(i)) = v_Min_Transfer_To_Count then
        v_Style := 'body number info';
      else
        v_Style := null;
      end if;
    
      a.Data(v_Transfer_To_Values(v_Division_Ids(i)), v_Style);
    
      if v_Max_Transfer_To_Count > 0 then
        a.Data(Round(v_Transfer_To_Values(v_Division_Ids(i)) /
                     v_Calc.Get_Value('total_transfer_to') * 100,
                     2),
               'body number lightgreen');
      else
        a.Data();
      end if;
    
      -- transfer from
      if v_Transfer_From_Values(v_Division_Ids(i)) = v_Max_Transfer_From_Count then
        v_Style := 'body number lightdanger';
      elsif v_Transfer_From_Values(v_Division_Ids(i)) = v_Min_Transfer_From_Count then
        v_Style := 'body number info';
      else
        v_Style := null;
      end if;
    
      a.Data(v_Transfer_From_Values(v_Division_Ids(i)), v_Style);
    
      if v_Max_Transfer_From_Count > 0 then
        a.Data(Round(v_Transfer_From_Values(v_Division_Ids(i)) /
                     v_Calc.Get_Value('total_transfer_from') * 100,
                     2),
               'body number lightgreen');
      else
        a.Data();
      end if;
    end loop;
  
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('Total'), 'footer');
  
    a.Data(v_Calc.Get_Value('total_hiring'));
    if v_Calc.Get_Value('total_hiring') > 0 then
      a.Data(100);
    else
      a.Data();
    end if;
  
    a.Data(v_Calc.Get_Value('total_dismissal'));
    if v_Calc.Get_Value('total_dismissal') > 0 then
      a.Data(100);
    else
      a.Data();
    end if;
  
    a.Data(v_Calc.Get_Value('total_transfer_to'));
    if v_Calc.Get_Value('total_transfer_to') > 0 then
      a.Data(100);
    else
      a.Data();
    end if;
  
    a.Data(v_Calc.Get_Value('total_transfer_from'));
    if v_Calc.Get_Value('total_transfer_from') > 0 then
      a.Data(100);
    else
      a.Data();
    end if;
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    b_Report.New_Style(i_Style_Name       => 'primary',
                       i_Background_Color => '#0070C0',
                       i_Font_Color       => '#FFFFFF');
    b_Report.New_Style(i_Style_Name => 'success', i_Background_Color => '#92D050');
    b_Report.New_Style(i_Style_Name => 'danger', i_Background_Color => '#FABF8F');
    b_Report.New_Style(i_Style_Name => 'yellow', i_Background_Color => '#FFFF00');
    b_Report.New_Style(i_Style_Name => 'info', i_Background_Color => '#D9EDF7');
    b_Report.New_Style(i_Style_Name => 'lightgreen', i_Background_Color => '#D8E4BC');
    b_Report.New_Style(i_Style_Name => 'lightdanger', i_Background_Color => '#f9d6bb');
  
    Run_All(i_Begin_Date   => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
            i_End_Date     => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
            i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()));
  
    b_Report.Close_Book();
  end;

end Ui_Vhr295;
/
