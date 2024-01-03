create or replace package Ui_Vhr303 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr303;
/
create or replace package body Ui_Vhr303 is
  ----------------------------------------------------------------------------------------------------
  g_Division_Total Fazo.Varchar2_Code_Aat;
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
    return b.Translate('UI-VHR303:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Table
  (
    a       in out nocopy b_Table,
    i_Count number
  ) is
  begin
    b_Report.New_Style(i_Style_Name       => 'rotate',
                       i_Text_Rotate      => -90,
                       i_Horizontal_Align => b_Report.a_Left);
  
    a.Column_Width(1, 300);
  
    for i in 2 .. i_Count + 1
    loop
      a.Column_Width(i, 20);
    end loop;
  
    a.Column_Width(i_Count + 2, 70);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Info
  (
    a            in out nocopy b_Table,
    i_Begin_Date date,
    i_End_Date   date
  ) is
  begin
    a.Current_Style('root bold');
  
    a.New_Row;
    a.New_Row;
    a.Data(t('begin date: $1', i_Begin_Date), i_Colspan => 10);
  
    a.New_Row;
    a.Data(t('end date: $1', i_End_Date), i_Colspan => 10);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Header
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Count        number
  ) is
  begin
    a.Current_Style('header');
  
    a.New_Row;
    a.New_Row(150);
    a.Data(t('divisions / jobs'));
  
    for i in 1 .. i_Count
    loop
      a.Data(z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => i_Division_Ids(i)).Name,
             'header rotate');
    end loop;
  
    a.Data(t('total'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Body
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Values       Fazo.Varchar2_Code_Aat,
    i_Count        number
  ) is
    v_Total number;
    v_Value number;
  begin
    a.Current_Style('body');
  
    for k in (select *
                from Mhr_Jobs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A'
               order by Lower(q.Name))
    loop
      a.New_Row;
      a.Data(k.Name);
      v_Total := 0;
    
      for i in 1 .. i_Count
      loop
        begin
          v_Value := i_Values(i_Division_Ids(i) || ':' || k.Job_Id);
        
          a.Data(v_Value, 'body center');
        
          g_Division_Total(i_Division_Ids(i)) := g_Division_Total(i_Division_Ids(i)) + v_Value;
        
          v_Total := v_Total + v_Value;
        exception
          when No_Data_Found then
            a.Data;
        end;
      end loop;
    
      a.Data(v_Total, 'body center');
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Footer
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Count        number
  ) is
    v_Total number := 0;
  begin
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('total'));
  
    for i in 1 .. i_Count
    loop
      begin
        a.Data(g_Division_Total(i_Division_Ids(i)));
        v_Total := v_Total + g_Division_Total(i_Division_Ids(i));
      exception
        when No_Data_Found then
          a.Data;
      end;
    end loop;
  
    a.Data(v_Total);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Division_Ids
  (
    i_Begin_Date date,
    i_End_Date   date
  ) return Array_Number is
    v_Division_Id          Array_Number;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    result                 Array_Number;
  begin
    if v_Access_All_Employees = 'N' then
      v_Division_Id := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                          i_Indirect         => true,
                                                          i_Manual           => true,
                                                          i_Only_Departments => 'Y');
    end if;
  
    select q.Division_Id
      bulk collect
      into result
      from Mhr_Divisions q
      join Hrm_Divisions Dv
        on Dv.Company_Id = q.Company_Id
       and Dv.Filial_Id = q.Filial_Id
       and Dv.Division_Id = q.Division_Id
       and Dv.Is_Department = 'Y'
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and (v_Access_All_Employees = 'Y' or
           q.Division_Id in (select Column_Value
                                from table(v_Division_Id)))
       and q.Opened_Date <= i_Begin_Date
       and (q.Closed_Date is null or q.Closed_Date >= i_End_Date)
       and q.State = 'A'
     order by Lower(q.Name);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Cache_Total(i_Division_Ids Array_Number) is
  begin
    for i in 1 .. i_Division_Ids.Count
    loop
      g_Division_Total(i_Division_Ids(i)) := 0;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run
  (
    i_Begin_Date date,
    i_End_Date   date
  ) is
    a              b_Table := b_Report.New_Table();
    v_Division_Ids Array_Number;
    v_Values       Fazo.Varchar2_Code_Aat;
    v_Count        number;
  begin
    v_Division_Ids := Get_Division_Ids(i_Begin_Date => i_Begin_Date, i_End_Date => i_End_Date);
    v_Count        := v_Division_Ids.Count;
  
    Cache_Total(v_Division_Ids);
  
    for r in (select q.Division_Id, q.Job_Id, count(q.Dismissal_Date) count
                from Href_Staffs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Dismissal_Date between i_Begin_Date and i_End_Date
               group by q.Division_Id, q.Job_Id)
    loop
      v_Values(r.Division_Id || ':' || r.Job_Id) := r.Count;
    end loop;
  
    Set_Table(a, v_Count);
    Print_Info(a, i_Begin_Date, i_End_Date);
    Print_Header(a, v_Division_Ids, v_Count);
    Print_Body(a, v_Division_Ids, v_Values, v_Count);
    Print_Footer(a, v_Division_Ids, v_Count);
  
    b_Report.Add_Sheet(i_Name => t('dismiss by division'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.r_Varchar2('rt'),
                                   i_File_Name   => t('dismiss by division'));
  
    Run(p.r_Date('begin_date'), p.r_Date('end_date'));
  
    b_Report.Close_Book();
  end;

end Ui_Vhr303;
/
