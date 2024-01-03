create or replace package Ui_Vhr309 is
  ----------------------------------------------------------------------------------------------------  
  Procedure Template;
  ---------------------------------------------------------------------------------------------------- 
  Function Model return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Setting(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Import_File(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Import_Data(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Fte return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Salary_Types return Fazo_Query;
end Ui_Vhr309;
/
create or replace package body Ui_Vhr309 is
  ----------------------------------------------------------------------------------------------------  
  type Employee_Rt is record(
    Staff_Number     varchar2(50 char),
    First_Name       varchar2(250 char),
    Last_Name        varchar2(250 char),
    Middle_Name      varchar2(250 char),
    Birthday         date,
    Gender           varchar2(1),
    Nationality_Name varchar2(100 char),
    Nationality_Id   number,
    Email            varchar2(300 char),
    Main_Phone       varchar2(100 char),
    Region           varchar2(100 char),
    Region_Id        number,
    Address          varchar2(1000 char),
    Legal_Address    varchar2(1000 char),
    Npin             varchar2(14),
    Iapa             varchar2(14),
    Hiring_Date      date,
    Location         varchar2(100 char),
    Location_Id      number,
    Division         varchar2(200 char),
    Division_Id      number,
    Job              varchar2(200 char),
    Job_Id           number,
    Fte_Name         varchar2(100 char),
    Fte_Id           number,
    Schedule         varchar2(100 char),
    Schedule_Id      number,
    Salary_Type      varchar2(100 char),
    Salary_Type_Id   number,
    Salary_Amount    number,
    Login            varchar2(50 char));
  ----------------------------------------------------------------------------------------------------  
  -- template global variables
  ----------------------------------------------------------------------------------------------------  
  g_Setting             Hashmap;
  g_Starting_Row        number;
  g_Nationality_Count   number;
  g_Region_Count        number;
  g_Division_Count      number;
  g_Job_Count           number;
  g_Schedule_Count      number;
  g_Location_Count      number;
  g_Parent_Region_Id    number;
  g_Location_Identifier varchar2(20);
  g_Division_Identifier varchar2(20);
  g_Job_Identifier      varchar2(20);
  g_Schedule_Identifier varchar2(20);
  g_Region_Identifier   varchar2(20);
  g_Error_Messages      Arraylist;
  g_Errors              Arraylist;
  g_Employee            Employee_Rt;
  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row          constant varchar2(50) := 'UI-VHR309:STARTING_ROW';
  c_Pc_Column_Items          constant varchar2(50) := 'UI-VHR309:COLUMN_ITEMS';
  c_Pref_Location_Identifier constant varchar2(50) := 'UI-VHR309:LOCATION_IDENTIFIER';
  c_Pref_Region_Identifier   constant varchar2(50) := 'UI-VHR309:REGION_IDENTIFIER';
  c_Pref_Division_Identifier constant varchar2(50) := 'UI-VHR309:DIVISION_IDENTIFIER';
  c_Pref_Job_Identifier      constant varchar2(50) := 'UI-VHR309:JOB_IDENTIFIER';
  c_Pref_Schedule_Identifier constant varchar2(50) := 'UI-VHR309:SCHEDULE_IDENTIFIER';
  c_Pref_Parent_Region_Id    constant varchar2(50) := 'UI-VHR309:PARENT_REGION_ID';

  c_Staff_Number     constant varchar2(50) := 'staff_number';
  c_First_Name       constant varchar2(50) := 'first_name';
  c_Last_Name        constant varchar2(50) := 'last_name';
  c_Middle_Name      constant varchar2(50) := 'middle_name';
  c_Birthday         constant varchar2(50) := 'birthday';
  c_Gender           constant varchar2(50) := 'gender';
  c_Nationality_Name constant varchar2(50) := 'nationality_name';
  c_Email            constant varchar2(50) := 'email';
  c_Main_Phone       constant varchar2(50) := 'main_phone';
  c_Region           constant varchar2(50) := 'region';
  c_Address          constant varchar2(50) := 'address';
  c_Legal_Address    constant varchar2(50) := 'legal_address';
  c_Npin             constant varchar2(50) := 'npin';
  c_Iapa             constant varchar2(50) := 'iapa';
  c_Hiring_Date      constant varchar2(50) := 'hiring_date';
  c_Location         constant varchar2(50) := 'location';
  c_Division         constant varchar2(50) := 'division';
  c_Job              constant varchar2(50) := 'job';
  c_Fte_Name         constant varchar2(50) := 'fte_name';
  c_Schedule         constant varchar2(50) := 'schedule';
  c_Salary_Type      constant varchar2(50) := 'salary_type';
  c_Salary_Amount    constant varchar2(50) := 'salary_amount';
  c_Login            constant varchar2(50) := 'login';

  c_Identifier_Name constant varchar2(1) := 'N';
  c_Identifier_Code constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------  
  g_Columns Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(c_Staff_Number, 1),
                                               Array_Varchar2(c_First_Name, 2),
                                               Array_Varchar2(c_Last_Name, 3),
                                               Array_Varchar2(c_Middle_Name, 4),
                                               Array_Varchar2(c_Birthday, 5),
                                               Array_Varchar2(c_Gender, 6),
                                               Array_Varchar2(c_Nationality_Name, 7),
                                               Array_Varchar2(c_Email, 8),
                                               Array_Varchar2(c_Main_Phone, 9),
                                               Array_Varchar2(c_Region, 10),
                                               Array_Varchar2(c_Address, 12),
                                               Array_Varchar2(c_Legal_Address, 13),
                                               Array_Varchar2(c_Npin, 14),
                                               Array_Varchar2(c_Iapa, 15),
                                               Array_Varchar2(c_Hiring_Date, 16),
                                               Array_Varchar2(c_Location, 17),
                                               Array_Varchar2(c_Division, 18),
                                               Array_Varchar2(c_Job, 19),
                                               Array_Varchar2(c_Fte_Name, 20),
                                               Array_Varchar2(c_Schedule, 21),
                                               Array_Varchar2(c_Salary_Type, 22),
                                               Array_Varchar2(c_Salary_Amount, 23),
                                               Array_Varchar2(c_Login, 24));

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
    return b.Translate('UI-VHR309:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Identifiers return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(c_Identifier_Name, t('identifier:name')),
                           Array_Varchar2(c_Identifier_Code, t('identifier:code')));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Default_Column_Number(i_Key varchar2) return varchar2 is
  begin
    for i in 1 .. g_Columns.Count
    loop
      if g_Columns(i) (1) = i_Key then
        return g_Columns(i)(2);
      end if;
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Columns_All return Matrix_Varchar2 is
    v_Setting Hashmap;
    v_Matrix1 Matrix_Varchar2;
    v_Matrix2 Matrix_Varchar2;
    --------------------------------------------------    
    Function Column_Number(i_Key varchar2) return varchar2 is
    begin
      if v_Setting.Count = 0 then
        return Default_Column_Number(i_Key);
      end if;
    
      return v_Setting.o_Varchar2(i_Key);
    end;
  begin
    v_Setting := Nvl(Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Code       => c_Pc_Column_Items)),
                     Hashmap());
  
    v_Matrix1 := Matrix_Varchar2(Array_Varchar2(c_Staff_Number,
                                                t('staff_number'),
                                                Column_Number(c_Staff_Number)),
                                 Array_Varchar2(c_First_Name,
                                                t('first_name'),
                                                Column_Number(c_First_Name)),
                                 Array_Varchar2(c_Last_Name,
                                                t('last_name'),
                                                Column_Number(c_Last_Name)),
                                 Array_Varchar2(c_Middle_Name,
                                                t('middle_name'),
                                                Column_Number(c_Middle_Name)),
                                 Array_Varchar2(c_Birthday, t('birthday'), Column_Number(c_Birthday)),
                                 Array_Varchar2(c_Gender, t('gender'), Column_Number(c_Gender)),
                                 Array_Varchar2(c_Nationality_Name,
                                                t('nationality_name'),
                                                Column_Number(c_Nationality_Name)),
                                 Array_Varchar2(c_Email, t('email'), Column_Number(c_Email)),
                                 Array_Varchar2(c_Main_Phone,
                                                t('main_phone'),
                                                Column_Number(c_Main_Phone)),
                                 Array_Varchar2(c_Region, t('region'), Column_Number(c_Region)),
                                 Array_Varchar2(c_Address, t('address'), Column_Number(c_Address)),
                                 Array_Varchar2(c_Legal_Address,
                                                t('legal_address'),
                                                Column_Number(c_Legal_Address)),
                                 Array_Varchar2(c_Iapa, t('iapa'), Column_Number(c_Iapa)),
                                 Array_Varchar2(c_Npin, t('npin'), Column_Number(c_Npin)),
                                 Array_Varchar2(c_Hiring_Date,
                                                t('hiring_date'),
                                                Column_Number(c_Hiring_Date)),
                                 Array_Varchar2(c_Location, t('location'), Column_Number(c_Location)),
                                 Array_Varchar2(c_Division, t('division'), Column_Number(c_Division)),
                                 Array_Varchar2(c_Job, t('job'), Column_Number(c_Job)),
                                 Array_Varchar2(c_Fte_Name, t('fte_name'), Column_Number(c_Fte_Name)),
                                 Array_Varchar2(c_Schedule, t('schedule'), Column_Number(c_Schedule)),
                                 Array_Varchar2(c_Salary_Type,
                                                t('salary_type'),
                                                Column_Number(c_Salary_Type)),
                                 Array_Varchar2(c_Salary_Amount,
                                                t('salary_amount'),
                                                Column_Number(c_Salary_Amount)),
                                 Array_Varchar2(c_Login, t('login'), Column_Number(c_Login)));
  
    select *
      bulk collect
      into v_Matrix2
      from table(v_Matrix1)
     order by to_number(Fazo.Column_Varchar2(Column_Value, 3));
  
    return v_Matrix2;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Identifier(i_Code varchar2) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => i_Code),
               c_Identifier_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Starting_Row return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pc_Starting_Row),
               2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap) is
    v_Keys           Array_Varchar2 := p.o_Array_Varchar2('keys');
    v_Column_Numbers Array_Varchar2 := p.o_Array_Varchar2('column_number');
    v_Setting        Hashmap := Hashmap();
  begin
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Starting_Row,
                           i_Value      => p.o_Number('starting_row'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Parent_Region_Id,
                           i_Value      => p.o_Varchar2('parent_region_id'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Division_Identifier,
                           i_Value      => p.r_Varchar2('division_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Job_Identifier,
                           i_Value      => p.r_Varchar2('job_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Schedule_Identifier,
                           i_Value      => p.r_Varchar2('schedule_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Location_Identifier,
                           i_Value      => p.r_Varchar2('location_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Region_Identifier,
                           i_Value      => p.r_Varchar2('region_identifier'));
  
    for i in 1 .. v_Keys.Count
    loop
      v_Setting.Put(v_Keys(i), v_Column_Numbers(i));
    end loop;
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Column_Items,
                           i_Value      => v_Setting.Json);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Region_Id, t.Name, t.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Name;
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
  
    Result.Put('starting_row', Starting_Row);
    Result.Put('region_id',
               Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Code       => c_Pref_Parent_Region_Id),
                   1));
    Result.Put('identifiers', Fazo.Zip_Matrix(Identifiers));
    Result.Put('location_identifier', Load_Identifier(c_Pref_Location_Identifier));
    Result.Put('region_identifier', Load_Identifier(c_Pref_Region_Identifier));
    Result.Put('division_identifier', Load_Identifier(c_Pref_Division_Identifier));
    Result.Put('job_identifier', Load_Identifier(c_Pref_Job_Identifier));
    Result.Put('schedule_identifier', Load_Identifier(c_Pref_Schedule_Identifier));
    Result.Put('items', Fazo.Zip_Matrix(Columns_All));
    Result.Put('crs', Uit_Href.Col_Required_Settings);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    g_Starting_Row        := Starting_Row;
    g_Location_Identifier := Load_Identifier(c_Pref_Location_Identifier);
    g_Region_Identifier   := Load_Identifier(c_Pref_Region_Identifier);
    g_Division_Identifier := Load_Identifier(c_Pref_Division_Identifier);
    g_Job_Identifier      := Load_Identifier(c_Pref_Job_Identifier);
    g_Schedule_Identifier := Load_Identifier(c_Pref_Schedule_Identifier);
    g_Parent_Region_Id    := Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Code       => c_Pref_Parent_Region_Id);
    g_Setting             := Nvl(Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Code       => c_Pc_Column_Items)),
                                 Hashmap());
  
    g_Errors := Arraylist();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table return b_Table is
    v_Access_All_Employees varchar2(1);
    v_Division_Ids         Array_Number;
  
    a b_Table;
    c b_Table;
  begin
    a := b_Report.New_Table;
    a.New_Row;
  
    -- gender: column - 1
    c := b_Report.New_Table;
    c.New_Row;
    c.Data('M');
    c.New_Row;
    c.Data('F');
    a.Data(c);
  
    -- nationality: column - 2
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Nationality_Count := 0;
    for r in (select q.Name
                from Href_Nationalities q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Nationality_Count := g_Nationality_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- region: column - 3 
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Region_Count := 0;
    for r in (select d.Name
                from Md_Regions d
               where d.Company_Id = Ui.Company_Id
                 and d.Parent_Id = g_Parent_Region_Id
                 and d.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Region_Count := g_Region_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- location: column - 4
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Location_Count := 0;
    for r in (select q.Name
                from Htt_Locations q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A'
                 and exists (select *
                        from Htt_Location_Filials Lf
                       where Lf.Company_Id = Ui.Company_Id
                         and Lf.Filial_Id = Ui.Filial_Id
                         and Lf.Location_Id = q.Location_Id)
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Location_Count := g_Location_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- division: column - 5
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Division_Count := 0;
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
    v_Division_Ids         := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                                 i_Indirect         => true,
                                                                 i_Manual           => true,
                                                                 i_Only_Departments => 'Y');
  
    for r in (select w.Name
                from Mhr_Divisions w
                join Hrm_Divisions Dv
                  on Dv.Company_Id = w.Company_Id
                 and Dv.Filial_Id = w.Filial_Id
                 and Dv.Division_Id = w.Division_Id
                 and Dv.Is_Department = 'Y'
               where w.Company_Id = Ui.Company_Id
                 and w.Filial_Id = Ui.Filial_Id
                 and (v_Access_All_Employees = 'Y' or w.Division_Id member of v_Division_Ids)
               order by w.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Division_Count := g_Division_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- job: column - 6
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Job_Count := 0;
    for r in (select q.Name
                from Mhr_Jobs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Job_Count := g_Job_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- fte: column - 7
    c := b_Report.New_Table;
    c.New_Row;
  
    for r in (select q.Name
                from Href_Ftes q
               where q.Company_Id = Ui.Company_Id
                 and q.Pcode in (Href_Pref.c_Pcode_Fte_Full_Time,
                                 Href_Pref.c_Pcode_Fte_Part_Time,
                                 Href_Pref.c_Pcode_Fte_Quarter_Time)
               order by q.Order_No)
    loop
      c.Data(r.Name);
      c.New_Row;
    end loop;
  
    a.Data(c);
  
    -- schedule: column - 8
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Schedule_Count := 0;
    for r in (select q.Name
                from Htt_Schedules q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Schedule_Count := g_Schedule_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- salary type: column - 9   
    c := b_Report.New_Table;
    c.New_Row;
    for r in (select m.Name
                from Mpr_Oper_Types m
               where m.Company_Id = Ui.Company_Id
                 and m.Pcode in (Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                                 Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                                 Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                                 Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized)
                 and m.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
    end loop;
  
    a.Data(c);
  
    return a;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    a              b_Table;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Columns_All  Matrix_Varchar2;
    v_Begin_Index  number;
    v_Source_Name  varchar2(10) := 'data';
    v_Source_Table b_Table;
  
    --------------------------------------------------     
    Function Column_Order(i_Key varchar2) return number is
      v_Column_Order number;
    begin
      for i in 1 .. v_Columns_All.Count
      loop
        if v_Columns_All(i) (1) = i_Key then
          v_Column_Order := v_Columns_All(i) (3);
          exit;
        end if;
      end loop;
    
      return v_Column_Order;
    end;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null
    ) is
      v_Column_Order number := Column_Order(i_Column_Key);
    begin
      if v_Column_Order is null then
        v_Left_Matrix.Extend;
        v_Left_Matrix(v_Left_Matrix.Count) := Array_Varchar2(i_Column_Data, i_Column_Width);
      else
        if v_Column_Order > v_Begin_Index then
          for i in v_Begin_Index + 1 .. v_Column_Order
          loop
            v_Data_Matrix.Extend;
            v_Data_Matrix(v_Data_Matrix.Count) := Array_Varchar2(null, null);
          end loop;
        
          v_Begin_Index := v_Column_Order;
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        else
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        end if;
      end if;
    end;
  
    --------------------------------------------------                   
    Procedure Push_Left_Data is
    begin
      for i in 1 .. v_Left_Matrix.Count
      loop
        v_Data_Matrix.Extend;
        v_Data_Matrix(v_Data_Matrix.Count) := v_Left_Matrix(i);
      end loop;
    end;
  begin
    v_Columns_All := Columns_All;
    v_Data_Matrix := Matrix_Varchar2();
    v_Left_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    Set_Global_Variables;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    v_Source_Table := Source_Table;
  
    a := b_Report.New_Table;
    a.Current_Style('header');
    a.New_Row;
  
    Set_Column(c_Staff_Number, t('staff_number'), 150);
    Set_Column(c_First_Name, t('first_name'), 100);
    Set_Column(c_Last_Name, t('last_name'), 100);
    Set_Column(c_Middle_Name, t('middle_name'), 100);
    Set_Column(c_Birthday, t('birthday'), 100);
    Set_Column(c_Gender, t('gender'), 50);
    Set_Column(c_Nationality_Name, t('nationality_name'), 100);
    Set_Column(c_Email, t('email'), 200);
    Set_Column(c_Main_Phone, t('main_phone'), 150);
    Set_Column(c_Region, t('region'), 200);
    Set_Column(c_Address, t('address'), 200);
    Set_Column(c_Legal_Address, t('legal_address'), 200);
    Set_Column(c_Iapa, t('iapa'), 150);
    Set_Column(c_Npin, t('npin'), 150);
    Set_Column(c_Hiring_Date, t('hiring_date'), 100);
    Set_Column(c_Location, t('location'), 200);
    Set_Column(c_Division, t('division'), 150);
    Set_Column(c_Job, t('job'), 150);
    Set_Column(c_Fte_Name, t('fte_name'), 75);
    Set_Column(c_Schedule, t('schedule'), 150);
    Set_Column(c_Salary_Type, t('salary_type'), 150);
    Set_Column(c_Salary_Amount, t('salary_amount'), 100);
    Set_Column(c_Login, t('login'), 100);
    Push_Left_Data;
  
    -- column_data_source: column_index, first_row, last_row, source_sheet, source_column, source_count
    if Column_Order(c_Gender) is not null then
      a.Column_Data_Source(Column_Order(c_Gender), 1, 102, v_Source_Name, 1, 2); -- gender
    end if;
  
    if Column_Order(c_Nationality_Name) is not null then
      a.Column_Data_Source(Column_Order(c_Nationality_Name),
                           1,
                           102,
                           v_Source_Name,
                           2,
                           g_Nationality_Count); -- nationality
    end if;
  
    if g_Region_Count > 0 and Column_Order(c_Region) is not null and
       g_Region_Identifier = c_Identifier_Name then
      a.Column_Data_Source(Column_Order(c_Region), 1, 102, v_Source_Name, 3, g_Region_Count); -- region
    end if;
  
    if g_Location_Count > 0 and Column_Order(c_Location) is not null and
       g_Location_Identifier = c_Identifier_Name then
      a.Column_Data_Source(Column_Order(c_Location), 1, 102, v_Source_Name, 4, g_Location_Count); -- location
    end if;
  
    if g_Division_Count > 0 and Column_Order(c_Division) is not null and
       g_Division_Identifier = c_Identifier_Name then
      a.Column_Data_Source(Column_Order(c_Division), 1, 102, v_Source_Name, 5, g_Division_Count); -- division
    end if;
  
    if g_Job_Count > 0 and Column_Order(c_Job) is not null and g_Job_Identifier = c_Identifier_Name then
      a.Column_Data_Source(Column_Order(c_Job), 1, 102, v_Source_Name, 6, g_Job_Count); -- job
    end if;
  
    if Column_Order(c_Fte_Name) is not null then
      a.Column_Data_Source(Column_Order(c_Fte_Name), 1, 102, v_Source_Name, 7, 3); -- fte
    end if;
  
    if g_Schedule_Count > 0 and Column_Order(c_Schedule) is not null and
       g_Schedule_Identifier = c_Identifier_Name then
      a.Column_Data_Source(Column_Order(c_Schedule), 1, 102, v_Source_Name, 8, g_Schedule_Count); -- schedule
    end if;
  
    if Column_Order(c_Salary_Type) is not null then
      a.Column_Data_Source(Column_Order(c_Salary_Type), 1, 102, v_Source_Name, 9, 3); -- salary type
    end if;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      a.Column_Width(i, v_Data_Matrix(i) (2));
      a.Data(v_Data_Matrix(i) (1));
    end loop;
  
    b_Report.Add_Sheet(t('employees'), a);
  
    -- template data  
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Staff_Number(i_Value varchar2) is
  begin
    g_Employee.Staff_Number := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with staff_number $2{employee number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_First_Name(i_Value varchar2) is
  begin
    g_Employee.First_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with natural person first name $2{natural person}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Last_Name(i_Value varchar2) is
  begin
    g_Employee.Last_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with natural person last name $2{natural person}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Middle_Name(i_Value varchar2) is
  begin
    g_Employee.Middle_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with natural person middle name $2{natural person}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Birthday(i_Value varchar2) is
  begin
    g_Employee.Birthday := Mr_Util.Convert_To_Date(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with birthday $2{birthday}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Gender(i_Value varchar2) is
  begin
    g_Employee.Gender := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with gender $2{gender}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Nationality(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Nationality_Name := i_Value;
  
    g_Employee.Nationality_Id := Href_Util.Nationality_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                                  i_Name       => i_Value);
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with nationality $2{nationality}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Email(i_Value varchar2) is
  begin
    g_Employee.Email := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with email $2{email}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Main_Phone(i_Value varchar2) is
  begin
    g_Employee.Main_Phone := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with main phone $2{main phone}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Region(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Region_Identifier = c_Identifier_Code then
      g_Employee.Region_Id := Md_Util.Region_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                        i_Code       => i_Value);
    else
      g_Employee.Region_Id := Md_Util.Region_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Parent_Id  => g_Parent_Region_Id,
                                                        i_Name       => i_Value);
    end if;
  
    g_Employee.Region := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with region $2{region}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Address(i_Value varchar2) is
  begin
    g_Employee.Address := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with address $2{address}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Legal_Address(i_Value varchar2) is
  begin
    g_Employee.Legal_Address := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with legal address $2{legal_address}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Npin(i_Value varchar2) is
  begin
    g_Employee.Npin := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with npin $2{npin}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Iapa(i_Value varchar2) is
  begin
    g_Employee.Iapa := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with iapa $2{iapa}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Hiring_Date(i_Value varchar2) is
  begin
    g_Employee.Hiring_Date := Mr_Util.Convert_To_Date(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with hiring_date $2{hiring_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division(i_Value varchar2) is
  begin
    if i_Value is null or g_Employee.Hiring_Date is null then
      return;
    end if;
  
    if g_Division_Identifier = c_Identifier_Code then
      g_Employee.Division_Id := Mhr_Util.Division_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Code       => i_Value);
    else
      g_Employee.Division_Id := Mhr_Util.Division_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Name       => i_Value);
    end if;
  
    g_Employee.Division := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division $2{division}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Job(i_Value varchar2) is
    v_Dummy varchar2(1);
  begin
    if i_Value is null or g_Employee.Division_Id is null then
      return;
    end if;
  
    if g_Job_Identifier = c_Identifier_Code then
      g_Employee.Job_Id := Mhr_Util.Job_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Code       => i_Value);
    else
      g_Employee.Job_Id := Mhr_Util.Job_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Name       => i_Value);
    end if;
  
    begin
      select 'x'
        into v_Dummy
        from Mhr_Jobs q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Job_Id = g_Employee.Job_Id
         and (q.c_Divisions_Exist = 'N' or exists
              (select 1
                 from Mhr_Job_Divisions w
                where w.Company_Id = q.Company_Id
                  and w.Filial_Id = q.Filial_Id
                  and w.Job_Id = q.Job_Id
                  and w.Division_Id = g_Employee.Division_Id));
    
    exception
      when No_Data_Found then
        b.Raise_Error(t('chosen job is not belongs to chosen division, job_id=$1, division_id=$2',
                        g_Employee.Job_Id,
                        g_Employee.Division_Id));
    end;
  
    g_Employee.Job := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job $2{job}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fte(i_Value varchar2) is
  begin
    if i_Value is null or g_Employee.Job_Id is null then
      return;
    end if;
  
    g_Employee.Fte_Id   := Href_Util.Fte_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                    i_Name       => i_Value);
    g_Employee.Fte_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fte $2{fte}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Schedule(i_Value varchar2) is
  begin
    if i_Value is null or g_Employee.Job_Id is null then
      return;
    end if;
  
    if g_Schedule_Identifier = c_Identifier_Code then
      g_Employee.Schedule_Id := Htt_Util.Schedule_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Code       => i_Value);
    else
      g_Employee.Schedule_Id := Htt_Util.Schedule_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Name       => i_Value);
    end if;
  
    g_Employee.Schedule := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with schedule $2{schedule}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Location(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Location_Identifier = c_Identifier_Code then
      g_Employee.Location_Id := Htt_Util.Location_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                             i_Code       => i_Value);
    else
      g_Employee.Location_Id := Htt_Util.Location_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                             i_Name       => i_Value);
    end if;
  
    g_Employee.Location := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with location $2{location}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Salary_Type(i_Value varchar2) is
  begin
    if i_Value is null or g_Employee.Job_Id is null then
      return;
    end if;
  
    g_Employee.Salary_Type_Id := Mpr_Util.Oper_Type_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                               i_Name       => i_Value);
  
    g_Employee.Salary_Type := i_Value;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with salary_type $2{salary_type}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Salary_Amount(i_Value varchar2) is
  begin
    if i_Value is null or g_Employee.Job_Id is null then
      return;
    end if;
  
    g_Employee.Salary_Amount := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with salary_amount $2{salary_amount}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Login(i_Value varchar2) is
    v_Dummy varchar2(1);
    v_Login varchar2(50 char) := Lower(trim(i_Value));
  begin
    if i_Value is null then
      return;
    end if;
  
    begin
      select 'X'
        into v_Dummy
        from Md_Users u
       where u.Company_Id = Ui.Company_Id
         and Lower(u.Login) = v_Login;
    
      b.Raise_Error(t('login is used, $1=login', v_Login));
    exception
      when No_Data_Found then
        null;
    end;
  
    g_Employee.Login := v_Login;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with login $2{login}',
                              b.Trim_Ora_Error(sqlerrm),
                              v_Login));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Row
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    v_Column_Number number;
    v_Cell_Value    varchar2(300);
  
    --------------------------------------------------                   
    Function Cell_Value(i_Column_Name varchar2) return varchar2 is
    begin
      if g_Setting.Count = 0 then
        v_Column_Number := Default_Column_Number(i_Column_Name);
      else
        v_Column_Number := g_Setting.o_Varchar2(i_Column_Name);
      end if;
    
      v_Cell_Value := i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
    
      return v_Cell_Value;
    end;
  begin
    Set_Staff_Number(Cell_Value(c_Staff_Number));
    Set_First_Name(Cell_Value(c_First_Name));
    Set_Last_Name(Cell_Value(c_Last_Name));
    Set_Middle_Name(Cell_Value(c_Middle_Name));
    Set_Birthday(Cell_Value(c_Birthday));
    Set_Gender(Cell_Value(c_Gender));
    Set_Nationality(Cell_Value(c_Nationality_Name));
    Set_Email(Cell_Value(c_Email));
    Set_Main_Phone(Cell_Value(c_Main_Phone));
    Set_Region(Cell_Value(c_Region));
    Set_Address(Cell_Value(c_Address));
    Set_Legal_Address(Cell_Value(c_Legal_Address));
    Set_Npin(Cell_Value(c_Npin));
    Set_Iapa(Cell_Value(c_Iapa));
    Set_Hiring_Date(Cell_Value(c_Hiring_Date));
    Set_Division(Cell_Value(c_Division));
    Set_Job(Cell_Value(c_Job));
    Set_Fte(Cell_Value(c_Fte_Name));
    Set_Schedule(Cell_Value(c_Schedule));
    Set_Location(Cell_Value(c_Location));
    Set_Salary_Type(Cell_Value(c_Salary_Type));
    Set_Salary_Amount(Cell_Value(c_Salary_Amount));
    Set_Login(Cell_Value(c_Login));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Employee_To_Array return Array_Varchar2 is
  begin
    return Array_Varchar2(g_Employee.Staff_Number,
                          g_Employee.First_Name,
                          g_Employee.Last_Name,
                          g_Employee.Middle_Name,
                          g_Employee.Birthday,
                          g_Employee.Gender,
                          g_Employee.Nationality_Name,
                          g_Employee.Nationality_Id,
                          g_Employee.Email,
                          g_Employee.Main_Phone,
                          g_Employee.Region,
                          g_Employee.Region_Id,
                          g_Employee.Address,
                          g_Employee.Legal_Address,
                          g_Employee.Npin,
                          g_Employee.Iapa,
                          g_Employee.Hiring_Date,
                          g_Employee.Location,
                          g_Employee.Location_Id,
                          g_Employee.Division,
                          g_Employee.Division_Id,
                          g_Employee.Job,
                          g_Employee.Job_Id,
                          g_Employee.Fte_Name,
                          g_Employee.Fte_Id,
                          g_Employee.Schedule,
                          g_Employee.Schedule_Id,
                          g_Employee.Salary_Type,
                          g_Employee.Salary_Type_Id,
                          g_Employee.Salary_Amount,
                          g_Employee.Login);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Error_Messages.Count = 0 then
      o_Items.Extend;
      o_Items(o_Items.Count) := Employee_To_Array;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Error(i_Row_Index number) is
    v_Error Hashmap;
  begin
    if g_Error_Messages.Count > 0 then
      v_Error := Hashmap();
    
      v_Error.Put('row_id', i_Row_Index);
      v_Error.Put('items', g_Error_Messages);
    
      g_Errors.Push(v_Error);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap is
    v_Sheets Arraylist;
    v_Sheet  Excel_Sheet;
    v_Items  Matrix_Varchar2 := Matrix_Varchar2();
    result   Hashmap := Hashmap();
  begin
    v_Sheets := p.r_Arraylist('template');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Employee       := null;
      g_Error_Messages := Arraylist();
    
      Parse_Row(v_Sheet, i);
      Push_Row(v_Items);
    
      Push_Error(i);
    end loop;
  
    Result.Put('items', Fazo.Zip_Matrix(v_Items));
    Result.Put('errors', g_Errors);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Add(p Hashmap) is
    r_User              Md_Users%rowtype;
    v_Person            Href_Pref.Person_Rt;
    v_Htt_Person        Htt_Pref.Person_Rt;
    v_Employee          Href_Pref.Employee_Rt;
    v_Journal           Hpd_Pref.Hiring_Journal_Rt;
    v_Robot             Hpd_Pref.Robot_Rt;
    v_Indicator         Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    v_Oper_Type         Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Wage_Indicator_Id number;
    v_Employee_Id       number := p.o_Number('employee_id');
    v_Division_Id       number := p.o_Number('division_id');
    v_Job_Id            number := p.o_Number('job_id');
    v_Schedule_Id       number := p.o_Number('schedule_id');
    v_Location_Id       number := p.o_Number('location_id');
    v_Salary_Type_Id    number := p.o_Varchar2('salary_type_id');
    v_Salary_Amount     number := p.o_Number('salary_amount');
    v_Hiring_Date       date := p.o_Date('hiring_date');
    v_Role_Id           number;
  begin
    -- check
    if v_Division_Id is not null and v_Job_Id is not null and v_Hiring_Date is not null then
      Uit_Href.Assert_Access_To_Division(v_Division_Id);
    else
      Uit_Href.Assert_Access_All_Employees;
    end if;
  
    v_Employee_Id := Md_Next.Person_Id;
  
    Href_Util.Person_New(o_Person         => v_Person,
                         i_Company_Id     => Ui.Company_Id,
                         i_Person_Id      => v_Employee_Id,
                         i_First_Name     => p.r_Varchar2('first_name'),
                         i_Last_Name      => p.o_Varchar2('last_name'),
                         i_Middle_Name    => p.o_Varchar2('middle_name'),
                         i_Gender         => Nvl(p.o_Varchar2('gender'), 'M'),
                         i_Birthday       => p.o_Varchar2('birthday'),
                         i_Nationality_Id => p.o_Number('nationality_id'),
                         i_Photo_Sha      => null,
                         i_Tin            => null,
                         i_Iapa           => p.o_Varchar2('iapa'),
                         i_Npin           => p.o_Varchar2('npin'),
                         i_Region_Id      => p.o_Number('region_id'),
                         i_Main_Phone     => p.o_Varchar2('main_phone'),
                         i_Email          => p.o_Varchar2('email'),
                         i_Address        => p.o_Varchar2('address'),
                         i_Legal_Address  => p.o_Varchar2('legal_address'),
                         i_Key_Person     => 'N',
                         i_State          => 'A',
                         i_Code           => null);
  
    -- employee save
    v_Employee.Person    := v_Person;
    v_Employee.Filial_Id := Ui.Filial_Id;
    v_Employee.State     := v_Person.State;
  
    Href_Api.Employee_Save(v_Employee);
  
    -- htt person save
    Htt_Util.Person_New(o_Person     => v_Htt_Person,
                        i_Company_Id => Ui.Company_Id,
                        i_Person_Id  => v_Employee_Id,
                        i_Pin        => null,
                        i_Pin_Code   => null,
                        i_Rfid_Code  => null,
                        i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Employee_Id));
  
    if Htt_Util.Pin_Autogenerate(v_Htt_Person.Company_Id) = 'Y' then
      v_Htt_Person.Pin := Htt_Core.Next_Pin(v_Htt_Person.Company_Id);
    end if;
  
    Htt_Api.Person_Save(v_Htt_Person);
  
    -- attach to location
    if v_Location_Id is not null then
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id,
                                  i_Person_Id   => v_Employee_Id);
    end if;
  
    -- user save
    r_User.Company_Id := Ui.Company_Id;
    r_User.User_Id    := v_Employee_Id;
    r_User.Name       := Mr_Util.Gen_Name(i_First_Name  => v_Person.First_Name,
                                          i_Last_Name   => v_Person.Last_Name,
                                          i_Middle_Name => v_Person.Middle_Name);
    r_User.State      := 'A';
    r_User.User_Kind  := Md_Pref.c_Uk_Normal;
    r_User.Gender     := v_Person.Gender;
    r_User.Login      := p.o_Varchar2('login');
  
    if r_User.Login is not null then
      r_User.Password                 := Fazo.Hash_Sha1(v_Employee_Id);
      r_User.Password_Changed_On      := sysdate;
      r_User.Password_Change_Required := 'Y';
    end if;
  
    Md_Api.User_Save(r_User);
  
    if v_Person.State = 'A' then
      Md_Api.User_Add_Filial(i_Company_Id => r_User.Company_Id,
                             i_User_Id    => r_User.User_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    else
      Md_Api.User_Remove_Filial(i_Company_Id   => r_User.Company_Id,
                                i_User_Id      => r_User.User_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Remove_Roles => false);
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    Md_Api.Role_Grant(i_Company_Id => Ui.Company_Id,
                      i_Filial_Id  => Ui.Filial_Id,
                      i_User_Id    => r_User.User_Id,
                      i_Role_Id    => v_Role_Id);
  
    -- hiring person
    if v_Division_Id is not null and v_Job_Id is not null and v_Hiring_Date is not null then
      Hpd_Util.Hiring_Journal_New(o_Journal         => v_Journal,
                                  i_Company_Id      => Ui.Company_Id,
                                  i_Filial_Id       => Ui.Filial_Id,
                                  i_Journal_Id      => Hpd_Next.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                  i_Journal_Number  => null,
                                  i_Journal_Date    => v_Hiring_Date,
                                  i_Journal_Name    => null);
    
      Hpd_Util.Robot_New(o_Robot           => v_Robot,
                         i_Robot_Id        => Mrf_Next.Robot_Id,
                         i_Division_Id     => v_Division_Id,
                         i_Job_Id          => v_Job_Id,
                         i_Rank_Id         => null,
                         i_Wage_Scale_Id   => null,
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte_Id          => p.o_Number('fte_id'),
                         i_Fte             => null);
    
      -- wage info
      if v_Salary_Amount is not null and v_Salary_Type_Id is not null then
        v_Wage_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
      
        Hpd_Util.Indicator_Add(p_Indicator       => v_Indicator,
                               i_Indicator_Id    => v_Wage_Indicator_Id,
                               i_Indicator_Value => v_Salary_Amount);
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => v_Oper_Type,
                               i_Oper_Type_Id  => v_Salary_Type_Id,
                               i_Indicator_Ids => Array_Number(v_Wage_Indicator_Id));
      end if;
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => v_Journal,
                                  i_Page_Id              => Hpd_Next.Page_Id,
                                  i_Employee_Id          => v_Employee_Id,
                                  i_Staff_Number         => p.o_Number('staff_number'),
                                  i_Hiring_Date          => v_Hiring_Date,
                                  i_Trial_Period         => 0,
                                  i_Employment_Source_Id => null,
                                  i_Schedule_Id          => v_Schedule_Id,
                                  i_Vacation_Days_Limit  => null,
                                  i_Is_Booked            => 'N',
                                  i_Robot                => v_Robot,
                                  i_Contract             => null,
                                  i_Indicators           => v_Indicator,
                                  i_Oper_Types           => v_Oper_Type);
    
      Hpd_Api.Hiring_Journal_Save(v_Journal);
    
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
    v_Item Hashmap;
  begin
    for i in 1 .. v_List.Count
    loop
      v_Item := Treat(v_List.r_Hashmap(i) as Hashmap);
      Employee_Add(v_Item);
    
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_nationalities',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('nationality_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.job_id, 
                            q.name as job
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('job');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Fte return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.fte_id, 
                            q.name as fte, 
                            q.fte_value
                       from href_ftes q
                      where q.company_id = :company_id
                      order by q.order_no',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('fte_id', 'fte_value');
    q.Varchar2_Field('fte');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.schedule_id, 
                            q.name as schedule
                       from htt_schedules q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('schedule');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.location_id, 
                            q.name as location
                       from htt_locations q
                      where q.company_id = :company_id
                        and q.state = :state',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'));
  
    q.Varchar2_Field('location');
    q.Number_Field('location_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Salary_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select m.oper_type_id as salary_type_id,
                            q.name as salary_type
                       from hpr_oper_types m 
                       join mpr_oper_types q
                         on q.company_id = m.company_id
                        and q.oper_type_id = m.oper_type_id
                      where m.company_id = :company_id
                        and m.oper_group_id = :oper_group_id
                        and q.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'state',
                                 'A',
                                 'oper_group_id',
                                 Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                        i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage)));
  
    q.Number_Field('salary_type_id');
    q.Varchar2_Field('salary_type');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Nationalities
       set Company_Id     = null,
           Nationality_Id = null,
           name           = null,
           State          = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null,
           Fte_Value  = null,
           Order_No   = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           State       = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
    update Hpr_Oper_Types
       set Company_Id    = null,
           Oper_Type_Id  = null,
           Oper_Group_Id = null;
  end;

end Ui_Vhr309;
/
