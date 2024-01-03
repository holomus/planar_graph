create or replace package Ui_Vhr565 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr565;
/
create or replace package body Ui_Vhr565 is
  ----------------------------------------------------------------------------------------------------
  g_Column_Total Fazo.Varchar2_Code_Aat;

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
    return b.Translate('UI-VHR565:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Is_Department => 'Y')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Adjustment_Count
  (
    i_Division_Id number,
    i_Day         date
  ) return number is
    v_Count number;
  begin
    select count(1)
      into v_Count
      from Hpd_Lock_Adjustments t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Adjustment_Date = i_Day
       and exists (select 1
              from Href_Staffs q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = t.Filial_Id
               and q.Staff_Id = t.Staff_Id
               and q.Division_Id = i_Division_Id);
  
    return v_Count;
  exception
    when No_Data_Found then
      return 0;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Table
  (
    a            in out nocopy b_Table,
    i_Col_Length number
  ) is
  begin
    b_Report.New_Style(i_Style_Name       => 'rotate',
                       i_Text_Rotate      => -90,
                       i_Horizontal_Align => b_Report.a_Left,
                       i_Vertical_Align   => b_Report.a_Middle);
  
    a.Column_Width(1, 200);
    a.Column_Width(2, 200);
  
    for i in 3 .. i_Col_Length - 1
    loop
      a.Column_Width(i, 40);
    end loop;
  
    a.Column_Width(i_Col_Length, 100);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Info
  (
    a            in out nocopy b_Table,
    i_Begin_Date date,
    i_End_Date   date,
    i_Col_Length number
  ) is
  begin
    a.Current_Style('root bold');
  
    a.New_Row;
    a.New_Row;
    a.Data(t('begin date: $1', i_Begin_Date), i_Colspan => i_Col_Length);
  
    a.New_Row;
    a.Data(t('end date: $1', i_End_Date), i_Colspan => i_Col_Length);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Header
  (
    a            in out nocopy b_Table,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    a.Current_Style('header');
  
    a.New_Row;
    a.New_Row(100);
    a.Data(t('divisions'));
    a.Data(t('division codes'));
  
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      a.Data(i_Begin_Date + i, 'header rotate');
    end loop;
  
    a.Data(t('total'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Body
  (
    a              in out nocopy b_Table,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number
  ) is
    v_Filter_Division_Ids Array_Number := i_Division_Ids;
    v_Has_Division_Ids    varchar2(1) := 'N';
    v_Row_Total           number;
    v_Adjustment_Count    number;
  begin
    a.Current_Style('body');
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                                  i_Indirect         => true,
                                                                  i_Manual           => true,
                                                                  i_Only_Departments => 'Y');
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    if v_Filter_Division_Ids is not null and v_Filter_Division_Ids.Count > 0 then
      v_Has_Division_Ids := 'Y';
    end if;
  
    for r in (select t.*
                from Mhr_Divisions t
                join Hrm_Divisions Dv
                  on Dv.Company_Id = t.Company_Id
                 and Dv.Filial_Id = t.Filial_Id
                 and Dv.Division_Id = t.Division_Id
                 and Dv.Is_Department = 'Y'
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id = Ui.Filial_Id
                 and t.State = 'A'
                 and t.Division_Group_Id is not null
                 and (v_Has_Division_Ids = 'N' or
                     t.Division_Id in (select Column_Value
                                          from table(v_Filter_Division_Ids)))
               order by Lower(t.Name))
    loop
      a.New_Row;
      a.Data(r.Name);
      a.Data(r.Code);
    
      v_Row_Total := 0;
    
      for d in 0 ..(i_End_Date - i_Begin_Date)
      loop
        v_Adjustment_Count := Get_Adjustment_Count(r.Division_Id, i_Begin_Date + d);
      
        if v_Adjustment_Count > 0 then
          a.Data(v_Adjustment_Count, 'body center');
        else
          a.Data('', 'danger');
        end if;
      
        v_Row_Total := v_Row_Total + v_Adjustment_Count;
        g_Column_Total(d) := g_Column_Total(d) + v_Adjustment_Count;
      end loop;
    
      if v_Row_Total > 0 then
        a.Data(v_Row_Total, 'body center');
      else
        a.Data();
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Footer
  (
    a            in out nocopy b_Table,
    i_Begin_Date date,
    i_End_Date   date
  ) is
    v_Total number := 0;
  begin
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('total'), i_Colspan => 2);
  
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      begin
        if g_Column_Total(i) > 0 then
          a.Data(g_Column_Total(i));
        else
          a.Data();
        end if;
      
        v_Total := v_Total + g_Column_Total(i);
      exception
        when No_Data_Found then
          a.Data;
      end;
    end loop;
  
    if v_Total > 0 then
      a.Data(v_Total);
    else
      a.Data();
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Cache_Column_Total
  (
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      g_Column_Total(i) := 0;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run
  (
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number
  ) is
    a            b_Table := b_Report.New_Table();
    v_Col_Length number;
  begin
    v_Col_Length := (i_End_Date - i_Begin_Date) + 4;
  
    Cache_Column_Total(i_Begin_Date, i_End_Date);
  
    Set_Table(a, v_Col_Length);
    Print_Info(a, i_Begin_Date, i_End_Date, v_Col_Length);
    Print_Header(a, i_Begin_Date, i_End_Date);
    Print_Body(a, i_Begin_Date, i_End_Date, i_Division_Ids);
    Print_Footer(a, i_Begin_Date, i_End_Date);
  
    b_Report.Add_Sheet(i_Name => t('timebook adjustment by division'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.r_Varchar2('rt'),
                                   i_File_Name   => t('timebook adjustment by division'));
  
    -- danger
    b_Report.New_Style(i_Style_Name        => 'danger',
                       i_Parent_Style_Name => 'body',
                       i_Background_Color  => '#ffc7ce',
                       i_Font_Color        => '#9c0006');
  
    Run(p.r_Date('begin_date'),
        p.r_Date('end_date'),
        Nvl(p.o_Array_Number('division_ids'), Array_Number()));
  
    b_Report.Close_Book();
  end;

end Ui_Vhr565;
/
