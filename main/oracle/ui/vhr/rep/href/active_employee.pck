create or replace package Ui_Vhr485 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Company return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr485;
/
create or replace package body Ui_Vhr485 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Massage varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('Ui-VHR485:' || i_Massage, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Company return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_companies', Fazo.Zip_Map('state', 'A'), true);
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('date', to_char(sysdate, Href_Pref.c_Date_Format_Month));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Top
  (
    a             in out nocopy b_Table,
    i_Company_Ids Array_Number,
    i_Begin_Date  date,
    i_End_Date    date,
    i_Colspan     number
  ) is
    v_Limit number := 5;
    v_Names Array_Varchar2 := Array_Varchar2();
  begin
    a.New_Row;
    a.Current_Style('root bold');
    a.New_Row;
    a.Data(t('report by active employee from $1{begin_date} to $2{end_date}',
             i_Begin_Date,
             i_End_Date),
           i_Colspan => i_Colspan);
    a.New_Row;
  
    v_Limit := Least(v_Limit, i_Company_Ids.Count);
    v_Names.Extend(v_Limit);
  
    for i in 1 .. v_Limit
    loop
      v_Names(i) := z_Md_Companies.Load(i_Company_Id => i_Company_Ids(i)).Name;
    end loop;
  
    if v_Limit < i_Company_Ids.Count then
      Fazo.Push(v_Names, t('... others'));
    end if;
  
    if v_Names.Count > 0 then
      a.Data(t('Companies: $1', Fazo.Gather(v_Names, ', ')), i_Colspan => i_Colspan);
      a.New_Row;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Detail
  (
    i_Company_Ids Array_Number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    v_Date        date;
    v_Min         number;
    v_Max         number;
    v_Avg         number;
    v_Count       number;
    v_Summa       number;
    v_Company_Ids Array_Number := i_Company_Ids;
    v_Cols        Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('company name'), 250),
                                                     Array_Varchar2(t('min'), 250),
                                                     Array_Varchar2(t('max'), 250),
                                                     Array_Varchar2(t('avarage'), 250));
    a             b_Table := b_Report.New_Table;
  begin
    if v_Company_Ids.Count = 0 then
      select q.Company_Id
        bulk collect
        into v_Company_Ids
        from Md_Companies q
       where q.State = 'A';
    end if;
  
    ------------ info --------------
    Print_Top(a, i_Company_Ids, i_Begin_Date, i_End_Date, 11);
  
    ------------ header --------------
    a.Current_Style('header');
    a.New_Row;
  
    for i in 1 .. v_Cols.Count
    loop
      a.Data(v_Cols(i) (1));
      a.Column_Width(i, v_Cols(i) (2));
    end loop;
  
    ------------ body --------------
    a.Current_Style('body');
  
    for i in 1 .. v_Company_Ids.Count
    loop
      v_Summa := 0;
      v_Max   := null;
      v_Min   := null;
    
      a.New_Row;
      a.Data(z_Md_Companies.Load(i_Company_Id => v_Company_Ids(i)).Name);
    
      for w in 0 .. i_End_Date - i_Begin_Date
      loop
        v_Date := i_Begin_Date + w;
      
        select count(*)
          into v_Count
          from (select q.Employee_Id
                  from Href_Staffs q
                 where q.Company_Id = v_Company_Ids(i)
                   and q.Hiring_Date <= v_Date
                   and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)
                   and q.State = 'A'
                 group by q.Employee_Id) p;
      
        v_Max   := Greatest(Nvl(v_Max, v_Count), v_Count);
        v_Min   := Least(Nvl(v_Min, v_Count), v_Count);
        v_Summa := v_Summa + v_Count;
      end loop;
    
      v_Avg := v_Summa / (i_End_Date - i_Begin_Date + 1);
    
      a.Data(v_Min);
      a.Data(v_Max);
      a.Data(Round(v_Avg, 2));
    end loop;
  
    b_Report.Add_Sheet('report_detail', a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Begin_Date  date := p.r_Date('begin_date');
    v_End_Date    date := Add_Months(v_Begin_Date, 1) - 1;
    v_Company_Ids Array_Number := Nvl(p.o_Array_Number('company_id'), Array_Number());
  begin
    b_Report.Open_Book_With_Styles(p.o_Varchar2('rt'));
  
    Run_Detail(v_Company_Ids, v_Begin_Date, v_End_Date);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr485;
/
