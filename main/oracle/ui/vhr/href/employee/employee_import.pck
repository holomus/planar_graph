create or replace package Ui_Vhr265 is
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
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------               
  Function Query_Wage_Scales return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Fte return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Robots(p Hashmap) return Fazo_Query;
end Ui_Vhr265;
/
create or replace package body Ui_Vhr265 is
  ----------------------------------------------------------------------------------------------------
  c_Pref_Location_Identifier constant varchar2(50) := 'UI-VHR265:LOCATION_IDENTIFIER';
  c_Pref_Region_Identifier   constant varchar2(50) := 'UI-VHR265:REGION_IDENTIFIER';
  c_Pref_Division_Identifier constant varchar2(50) := 'UI-VHR265:DIVISION_IDENTIFIER';
  c_Pref_Org_Unit_Identifier constant varchar2(50) := 'UI-VHR265:ORG_UNIT_IDENTIFIER';
  c_Pref_Job_Identifier      constant varchar2(50) := 'UI-VHR265:JOB_IDENTIFIER';
  c_Pref_Schedule_Identifier constant varchar2(50) := 'UI-VHR265:SCHEDULE_IDENTIFIER';
  c_Pref_Parent_Region_Id    constant varchar2(50) := 'UI-VHR265:PARENT_REGION_ID';
  c_Pref_Login_Auto_Generate constant varchar2(50) := 'UI-VHR265:LOGIN_AUTOGENERATE';
  c_Pref_Login_Template      constant varchar2(50) := 'UI-VHR265:LOGIN_TEMPLATE';
  c_Pref_Template_Goal       constant varchar2(50) := 'UI-VHR265:TEMPLATE_GOAL';

  c_Pref_Template_Goal_Insert constant varchar2(1) := 'I';
  c_Pref_Template_Goal_Update constant varchar2(1) := 'U';

  c_Text_Usage constant varchar2(20) := '_usage';

  ----------------------------------------------------------------------------------------------------  
  type Employee_Rt is record(
    -- Personal Info
    Employee_Id        number,
    Employee_Number    varchar2(50 char),
    First_Name         varchar2(250 char),
    Last_Name          varchar2(250 char),
    Middle_Name        varchar2(250 char),
    Gender             varchar2(1),
    Birthday           date,
    Nationality        varchar2(100 char),
    Nationality_Id     number,
    Npin               varchar2(14 char),
    Tin                varchar2(18),
    Iapa               varchar2(20 char),
    Login              varchar2(50 char),
    Address            varchar2(300 char),
    Legal_Address      varchar2(500 char),
    Region_Id          number,
    Main_Phone         varchar2(25),
    Email              varchar2(300),
    Corporate_Email    varchar2(300 char),
    Extra_Phone_Number varchar2(100 char),
    Note               varchar2(500 char),
    -- Passport Info 
    Passport_Series      varchar2(50 char),
    Passport_Number      varchar2(50 char),
    Passport_Issued_Date date,
    Passport_Issued_By   varchar2(150 char),
    Passport_Begin_Date  date,
    Passport_Expiry_Date date,
    -- Identification  
    Pin         varchar2(15),
    Pin_Code    number,
    Rfid_Code   number,
    Location    varchar2(100 char),
    Location_Id number,
    -- Quick Hiring
    Hiring_Date   date,
    Division      varchar2(200 char),
    Division_Id   number,
    Org_Unit      varchar2(200 char),
    Org_Unit_Id   number,
    Job           varchar2(200 char),
    Job_Id        number,
    Rank          varchar2(200 char),
    Rank_Id       number,
    Wage_Scale    varchar2(200 char),
    Wage_Scale_Id number,
    Fte           varchar2(100 char),
    Fte_Id        number,
    Robot         varchar2(700 char),
    Robot_Id      number,
    Oper_Type     varchar2(100 char),
    Oper_Type_Id  number,
    Wage          number,
    Schedule      varchar2(100 char),
    Schedule_Id   number);

  ----------------------------------------------------------------------------------------------------  
  -- template global variables
  ----------------------------------------------------------------------------------------------------  
  g_Starting_Row           number;
  g_Ending_Row             number;
  g_Nationality_Count      number;
  g_Location_Count         number;
  g_Region_Count           number;
  g_Division_Count         number;
  g_Org_Unit_Count         number;
  g_Job_Count              number;
  g_Rank_Count             number;
  g_Wage_Scale_Count       number;
  g_Fte_Count              number;
  g_Robot_Count            number;
  g_Oper_Type_Count        number;
  g_Schedule_Count         number;
  g_Parent_Region_Id       number;
  g_Location_Identifier    varchar2(20);
  g_Region_Identifier      varchar2(20);
  g_Division_Identifier    varchar2(20);
  g_Org_Unit_Identifier    varchar2(20);
  g_Job_Identifier         varchar2(20);
  g_Schedule_Identifier    varchar2(20);
  g_Login_Template         varchar2(50);
  g_Login_Autogenerate     varchar2(1);
  g_Advanced_Org_Structure varchar2(1);
  g_Setting                Hashmap;
  g_Error_Messages         Arraylist;
  g_Errors                 Arraylist;
  g_Employee               Employee_Rt;
  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR265:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR265:COLUMN_ITEMS';

  -- Personal Info
  c_Employee_Id     constant varchar2(50) := 'employee_id';
  c_Employee_Number constant varchar2(50) := 'employee_number';
  c_First_Name      constant varchar2(50) := 'first_name';
  c_Last_Name       constant varchar2(50) := 'last_name';
  c_Middle_Name     constant varchar2(50) := 'middle_name';
  c_Gender          constant varchar2(50) := 'gender';
  c_Birthday        constant varchar2(50) := 'birthday';
  c_Nationality     constant varchar2(50) := 'nationality';
  c_Npin            constant varchar2(50) := 'npin'; -- ПНФЛ
  c_Tin             constant varchar2(50) := 'tin'; -- ИНН
  c_Iapa            constant varchar2(50) := 'iapa'; -- ИНПС
  c_Login           constant varchar2(50) := 'login';
  c_Note            constant varchar2(50) := 'note';

  -- Contact And Adress
  c_Address            constant varchar2(50) := 'address';
  c_Legal_Address      constant varchar2(50) := 'legal_address';
  c_Region             constant varchar2(50) := 'region';
  c_Main_Phone         constant varchar2(50) := 'main_phone';
  c_Email              constant varchar2(50) := 'email';
  c_Corporate_Email    constant varchar2(50) := 'corporate_email';
  c_Extra_Phone_Number constant varchar2(50) := 'extra_phone_number';

  -- Passpor Information
  c_Passport_Series      constant varchar2(50) := 'passport_series';
  c_Passport_Number      constant varchar2(50) := 'passport_number';
  c_Passport_Begin_Date  constant varchar2(50) := 'passport_begin_date';
  c_Passport_Expiry_Date constant varchar2(50) := 'passport_expiry_date';
  c_Passport_Issued_By   constant varchar2(50) := 'passport_issued_by';
  c_Passport_Issued_Date constant varchar2(50) := 'passport_issued_date';

  -- Identification
  c_Pin       constant varchar2(50) := 'pin';
  c_Pin_Code  constant varchar2(50) := 'pin_code';
  c_Rfid_Code constant varchar2(50) := 'rfid_code';
  c_Location  constant varchar2(50) := 'location';

  -- Quick Hiring 
  c_Hiring_Date constant varchar2(50) := 'hiring_date';
  c_Division    constant varchar2(50) := 'division';
  c_Org_Unit    constant varchar2(50) := 'org_unit';
  c_Job         constant varchar2(50) := 'job';
  c_Rank        constant varchar2(50) := 'rank';
  c_Wage_Scale  constant varchar2(50) := 'wage_scale';
  c_Fte         constant varchar2(50) := 'fte';
  c_Robot       constant varchar2(50) := 'robot';
  c_Oper_Type   constant varchar2(50) := 'oper_type';
  c_Wage        constant varchar2(50) := 'wage';
  c_Schedule    constant varchar2(50) := 'schedule';

  c_Identifier_Name constant varchar2(1) := 'N';
  c_Identifier_Code constant varchar2(1) := 'C';

  ----------------------------------------------------------------------------------------------------  
  -- login tempaltes
  c_Template_First  constant varchar2(100) := 'first_name.last_name';
  c_Template_Second constant varchar2(100) := 'last_name.first_name';
  c_Template_Third  constant varchar2(100) := 'first_name_last_name';
  c_Template_Fourth constant varchar2(100) := 'last_name_first_name';

  ----------------------------------------------------------------------------------------------------  
  g_Columns Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(c_Employee_Id, 1, 'Y'),
                                               Array_Varchar2(c_Employee_Number, 2, 'Y'),
                                               Array_Varchar2(c_First_Name, 3, 'Y'),
                                               Array_Varchar2(c_Last_Name, 4, 'Y'),
                                               Array_Varchar2(c_Middle_Name, 5, 'Y'),
                                               Array_Varchar2(c_Gender, 6, 'Y'),
                                               Array_Varchar2(c_Birthday, 7, 'Y'),
                                               Array_Varchar2(c_Nationality, 8, 'Y'),
                                               Array_Varchar2(c_Npin, 9, 'Y'),
                                               Array_Varchar2(c_Tin, 10, 'Y'),
                                               Array_Varchar2(c_Iapa, 11, 'Y'),
                                               Array_Varchar2(c_Login, 12, 'Y'),
                                               Array_Varchar2(c_Address, 13, 'Y'),
                                               Array_Varchar2(c_Legal_Address, 14, 'Y'),
                                               Array_Varchar2(c_Region, 15, 'Y'),
                                               Array_Varchar2(c_Main_Phone, 16, 'Y'),
                                               Array_Varchar2(c_Email, 17, 'Y'),
                                               Array_Varchar2(c_Corporate_Email, 18, 'Y'),
                                               Array_Varchar2(c_Extra_Phone_Number, 19, 'Y'),
                                               Array_Varchar2(c_Passport_Series, 20, 'Y'),
                                               Array_Varchar2(c_Passport_Number, 21, 'Y'),
                                               Array_Varchar2(c_Passport_Begin_Date, 22, 'Y'),
                                               Array_Varchar2(c_Passport_Expiry_Date, 23, 'Y'),
                                               Array_Varchar2(c_Passport_Issued_By, 24, 'Y'),
                                               Array_Varchar2(c_Passport_Issued_Date, 25, 'Y'),
                                               Array_Varchar2(c_Pin, 26, 'Y'),
                                               Array_Varchar2(c_Pin_Code, 27, 'Y'),
                                               Array_Varchar2(c_Rfid_Code, 28, 'Y'),
                                               Array_Varchar2(c_Location, 29, 'Y'),
                                               Array_Varchar2(c_Hiring_Date, 30, 'Y'),
                                               Array_Varchar2(c_Division, 31, 'Y'),
                                               Array_Varchar2(c_Job, 32, 'Y'),
                                               Array_Varchar2(c_Rank, 33, 'Y'),
                                               Array_Varchar2(c_Wage_Scale, 34, 'Y'),
                                               Array_Varchar2(c_Fte, 35, 'Y'),
                                               Array_Varchar2(c_Robot, 36, 'Y'),
                                               Array_Varchar2(c_Oper_Type, 37, 'Y'),
                                               Array_Varchar2(c_Wage, 38, 'Y'),
                                               Array_Varchar2(c_Schedule, 39, 'Y'),
                                               Array_Varchar2(c_Note, 40, 'Y'),
                                               Array_Varchar2(c_Org_Unit, 41, 'Y'));

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
    return b.Translate('UI-VHR265:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Identifier(i_Identifier varchar2) return varchar2 is
  begin
    return case i_Identifier --
    when c_Identifier_Name then t('identifier: name') --
    when c_Identifier_Code then t('identifier: code') --
    end;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Login_Template(i_Login_Template varchar2) return varchar2 is
  begin
    return case i_Login_Template --
    when c_Template_First then t('login_template: first_name.last_name') --
    when c_Template_Second then t('login_template: last_name.first_name') --
    when c_Template_Third then t('login_template: first_name_last_name') --
    when c_Template_Fourth then t('login_template: last_name_first_name') --
    end;
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
  Function Default_Column_Usage(i_Key varchar2) return varchar2 is
  begin
    for i in 1 .. g_Columns.Count
    loop
      if g_Columns(i) (1) = i_Key then
        return g_Columns(i)(3);
      end if;
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Columns_All return Matrix_Varchar2 is
    r_Hrm_Setting Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                i_Filial_Id  => Ui.Filial_Id);
    v_Setting     Hashmap;
    v_Matrix1     Matrix_Varchar2;
    v_Matrix2     Matrix_Varchar2;
    --------------------------------------------------    
    Function Column_Number(i_Key varchar2) return varchar2 is
    begin
      if v_Setting.Count = 0 then
        return Default_Column_Number(i_Key);
      end if;
    
      return v_Setting.o_Varchar2(i_Key);
    end;
    -------------------------------------------------- 
    Function Column_Usage(i_Key varchar2) return varchar2 is
    begin
      if v_Setting.Count = 0 then
        return Default_Column_Usage(i_Key);
      end if;
    
      return Nvl(v_Setting.o_Varchar2(i_Key || c_Text_Usage), 'Y');
    end;
  begin
    v_Setting := Nvl(Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Code       => c_Pc_Column_Items)),
                     Hashmap());
  
    v_Matrix1 := Matrix_Varchar2(Array_Varchar2(c_Employee_Id,
                                                t('employee_id'),
                                                Column_Number(c_Employee_Id),
                                                Column_Usage(c_Employee_Id)),
                                 Array_Varchar2(c_Employee_Number,
                                                t('employee_number'),
                                                Column_Number(c_Employee_Number),
                                                Column_Usage(c_Employee_Number)),
                                 Array_Varchar2(c_First_Name,
                                                t('first name'),
                                                Column_Number(c_First_Name),
                                                Column_Usage(c_First_Name)),
                                 Array_Varchar2(c_Last_Name,
                                                t('last name'),
                                                Column_Number(c_Last_Name),
                                                Column_Usage(c_Last_Name)),
                                 Array_Varchar2(c_Middle_Name,
                                                t('middle name'),
                                                Column_Number(c_Middle_Name),
                                                Column_Usage(c_Middle_Name)),
                                 Array_Varchar2(c_Gender,
                                                t('gender'),
                                                Column_Number(c_Gender),
                                                Column_Usage(c_Gender)),
                                 Array_Varchar2(c_Birthday,
                                                t('birthday'),
                                                Column_Number(c_Birthday),
                                                Column_Usage(c_Birthday)),
                                 Array_Varchar2(c_Nationality,
                                                t('nationality'),
                                                Column_Number(c_Nationality),
                                                Column_Usage(c_Nationality)),
                                 Array_Varchar2(c_Npin,
                                                t('npin'),
                                                Column_Number(c_Npin),
                                                Column_Usage(c_Npin)),
                                 Array_Varchar2(c_Tin,
                                                t('tin'),
                                                Column_Number(c_Tin),
                                                Column_Usage(c_Tin)),
                                 Array_Varchar2(c_Iapa,
                                                t('iapa'),
                                                Column_Number(c_Iapa),
                                                Column_Usage(c_Iapa)),
                                 Array_Varchar2(c_Login,
                                                t('login'),
                                                Column_Number(c_Login),
                                                Column_Usage(c_Login)),
                                 Array_Varchar2(c_Address,
                                                t('address'),
                                                Column_Number(c_Address),
                                                Column_Usage(c_Address)),
                                 Array_Varchar2(c_Legal_Address,
                                                t('legal_address'),
                                                Column_Number(c_Legal_Address),
                                                Column_Usage(c_Legal_Address)),
                                 Array_Varchar2(c_Region,
                                                t('region'),
                                                Column_Number(c_Region),
                                                Column_Usage(c_Region)),
                                 Array_Varchar2(c_Main_Phone,
                                                t('main phone'),
                                                Column_Number(c_Main_Phone),
                                                Column_Usage(c_Main_Phone)),
                                 Array_Varchar2(c_Email,
                                                t('email'),
                                                Column_Number(c_Email),
                                                Column_Usage(c_Email)),
                                 Array_Varchar2(c_Corporate_Email,
                                                t('corporate_email'),
                                                Column_Number(c_Corporate_Email),
                                                Column_Usage(c_Corporate_Email)),
                                 Array_Varchar2(c_Extra_Phone_Number,
                                                t('extra_phone_number'),
                                                Column_Number(c_Extra_Phone_Number),
                                                Column_Usage(c_Extra_Phone_Number)),
                                 Array_Varchar2(c_Passport_Series,
                                                t('passport_series'),
                                                Column_Number(c_Passport_Series),
                                                Column_Usage(c_Passport_Series)),
                                 Array_Varchar2(c_Passport_Number,
                                                t('passport_number'),
                                                Column_Number(c_Passport_Number),
                                                Column_Usage(c_Passport_Number)),
                                 Array_Varchar2(c_Passport_Begin_Date,
                                                t('passport_begin_date'),
                                                Column_Number(c_Passport_Begin_Date),
                                                Column_Usage(c_Passport_Begin_Date)),
                                 Array_Varchar2(c_Passport_Expiry_Date,
                                                t('passport_expiry_date'),
                                                Column_Number(c_Passport_Expiry_Date),
                                                Column_Usage(c_Passport_Expiry_Date)),
                                 Array_Varchar2(c_Passport_Issued_By,
                                                t('passport_issued_by'),
                                                Column_Number(c_Passport_Issued_By),
                                                Column_Usage(c_Passport_Issued_By)),
                                 Array_Varchar2(c_Passport_Issued_Date,
                                                t('passport_issued_date'),
                                                Column_Number(c_Passport_Issued_Date),
                                                Column_Usage(c_Passport_Issued_Date)),
                                 Array_Varchar2(c_Pin,
                                                t('pin'),
                                                Column_Number(c_Pin),
                                                Column_Usage(c_Pin)),
                                 Array_Varchar2(c_Pin_Code,
                                                t('pin_code'),
                                                Column_Number(c_Pin_Code),
                                                Column_Usage(c_Pin_Code)),
                                 Array_Varchar2(c_Rfid_Code,
                                                t('rfid_code'),
                                                Column_Number(c_Rfid_Code),
                                                Column_Usage(c_Rfid_Code)),
                                 Array_Varchar2(c_Location,
                                                t('location'),
                                                Column_Number(c_Location),
                                                Column_Usage(c_Location)),
                                 Array_Varchar2(c_Hiring_Date,
                                                t('hiring_date'),
                                                Column_Number(c_Hiring_Date),
                                                Column_Usage(c_Hiring_Date)),
                                 Array_Varchar2(c_Fte,
                                                t('fte'),
                                                Column_Number(c_Fte),
                                                Column_Usage(c_Fte)),
                                 Array_Varchar2(c_Oper_Type,
                                                t('oper_type'),
                                                Column_Number(c_Oper_Type),
                                                Column_Usage(c_Oper_Type)),
                                 Array_Varchar2(c_Wage,
                                                t('wage'),
                                                Column_Number(c_Wage),
                                                Column_Usage(c_Wage)),
                                 Array_Varchar2(c_Schedule,
                                                t('schedule'),
                                                Column_Number(c_Schedule),
                                                Column_Usage(c_Schedule)),
                                 Array_Varchar2(c_Note,
                                                t('note'),
                                                Column_Number(c_Note),
                                                Column_Usage(c_Note)));
  
    if r_Hrm_Setting.Position_Enable = 'N' then
      v_Matrix1.Extend;
      v_Matrix1(v_Matrix1.Count) := Array_Varchar2(c_Division,
                                                   t('division'),
                                                   Column_Number(c_Division),
                                                   Column_Usage(c_Division));
    
      if r_Hrm_Setting.Advanced_Org_Structure = 'Y' then
        v_Matrix1.Extend;
        v_Matrix1(v_Matrix1.Count) := Array_Varchar2(c_Org_Unit,
                                                     t('org unit'),
                                                     Column_Number(c_Org_Unit),
                                                     Column_Usage(c_Org_Unit));
      end if;
    
      v_Matrix1.Extend;
      v_Matrix1(v_Matrix1.Count) := Array_Varchar2(c_Job,
                                                   t('job'),
                                                   Column_Number(c_Job),
                                                   Column_Usage(c_Job));
    
      if r_Hrm_Setting.Rank_Enable = 'Y' then
        v_Matrix1.Extend;
        v_Matrix1(v_Matrix1.Count) := Array_Varchar2(c_Rank,
                                                     t('rank'),
                                                     Column_Number(c_Rank),
                                                     Column_Usage(c_Rank));
      
        if r_Hrm_Setting.Wage_Scale_Enable = 'Y' then
          v_Matrix1.Extend;
          v_Matrix1(v_Matrix1.Count) := Array_Varchar2(c_Wage_Scale,
                                                       t('wage_scale'),
                                                       Column_Number(c_Wage_Scale),
                                                       Column_Usage(c_Wage_Scale));
        end if;
      end if;
    else
      v_Matrix1.Extend;
      v_Matrix1(v_Matrix1.Count) := Array_Varchar2(c_Robot,
                                                   t('robot'),
                                                   Column_Number(c_Robot),
                                                   Column_Usage(c_Robot));
    end if;
  
    select *
      bulk collect
      into v_Matrix2
      from table(v_Matrix1)
     order by to_number(Fazo.Column_Varchar2(Column_Value, 3));
  
    return v_Matrix2;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Preference(i_Code varchar2) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => i_Code),
               c_Identifier_Name);
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Load_Login_Autogenerate return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pref_Login_Auto_Generate),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Template(i_Code varchar2) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => i_Code),
               c_Template_First);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Template_Goal return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pref_Template_Goal),
               c_Pref_Template_Goal_Insert);
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
    v_Column_Items Arraylist := p.o_Arraylist('column_items');
    v_Item         Hashmap;
    v_Setting      Hashmap := Hashmap();
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
                           i_Code       => c_Pref_Region_Identifier,
                           i_Value      => p.r_Varchar2('region_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Location_Identifier,
                           i_Value      => p.o_Varchar2('location_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Division_Identifier,
                           i_Value      => p.o_Varchar2('division_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Org_Unit_Identifier,
                           i_Value      => p.o_Varchar2('org_unit_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Job_Identifier,
                           i_Value      => p.o_Varchar2('job_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Schedule_Identifier,
                           i_Value      => p.o_Varchar2('schedule_identifier'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Login_Template,
                           i_Value      => p.o_Varchar2('login_template'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Login_Auto_Generate,
                           i_Value      => p.o_Varchar2('login_autogenerate'));
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Template_Goal,
                           i_Value      => p.o_Varchar2('goal'));
  
    for i in 1 .. v_Column_Items.Count
    loop
      v_Item := Treat(v_Column_Items.r_Hashmap(i) as Hashmap);
    
      v_Setting.Put(v_Item.r_Varchar2('key'), i);
      v_Setting.Put(v_Item.r_Varchar2('key') || c_Text_Usage, v_Item.r_Varchar2('usage'));
    end loop;
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Column_Items,
                           i_Value      => v_Setting.Json);
  end;

  ----------------------------------------------------------------------------------------------------   
  Function References return Hashmap is
    v_Matrix       Matrix_Varchar2;
    r_Hrm_Settings Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                 i_Filial_Id  => Ui.Filial_Id);
    result         Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Region_Id, t.Name, t.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Name;
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
  
    v_Matrix := Matrix_Varchar2();
    Fazo.Push(v_Matrix, c_Identifier_Name, t_Identifier(c_Identifier_Name));
    Fazo.Push(v_Matrix, c_Identifier_Code, t_Identifier(c_Identifier_Code));
  
    Result.Put('identifiers', Fazo.Zip_Matrix(v_Matrix));
  
    v_Matrix := Matrix_Varchar2();
    Fazo.Push(v_Matrix, c_Template_First, t_Login_Template(c_Template_First));
    Fazo.Push(v_Matrix, c_Template_Second, t_Login_Template(c_Template_Second));
    Fazo.Push(v_Matrix, c_Template_Third, t_Login_Template(c_Template_Third));
    Fazo.Push(v_Matrix, c_Template_Fourth, t_Login_Template(c_Template_Fourth));
  
    Result.Put('login_templates', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('org_units', Fazo.Zip_Matrix(Uit_Hrm.Org_Units));
    Result.Put('pek_staff', Hrm_Pref.c_Position_Employment_Staff);
    Result.Put('position_enable', r_Hrm_Settings.Position_Enable);
    Result.Put('rank_enable', r_Hrm_Settings.Rank_Enable);
    Result.Put('wage_scale_enable', r_Hrm_Settings.Wage_Scale_Enable);
    Result.Put('advanced_org_structure', r_Hrm_Settings.Advanced_Org_Structure);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    v_Login_Template Md_Users.Login%type;
    result           Hashmap := Hashmap();
  begin
    Result.Put('starting_row', Starting_Row);
    Result.Put('goal', Template_Goal);
  
    Result.Put('location_identifier', Load_Preference(c_Pref_Location_Identifier));
    Result.Put('region_identifier', Load_Preference(c_Pref_Region_Identifier));
    Result.Put('division_identifier', Load_Preference(c_Pref_Division_Identifier));
    Result.Put('org_unit_identifier', Load_Preference(c_Pref_Org_Unit_Identifier));
    Result.Put('job_identifier', Load_Preference(c_Pref_Job_Identifier));
    Result.Put('schedule_identifier', Load_Preference(c_Pref_Schedule_Identifier));
    Result.Put('login_autogenerate', Load_Login_Autogenerate);
  
    Result.Put('parent_region_id',
               Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pref_Parent_Region_Id));
  
    v_Login_Template := Load_Template(c_Pref_Login_Template);
    Result.Put('login_template',
               Fazo.Zip_Map('key', --
                            v_Login_Template,
                            'name',
                            t_Login_Template(v_Login_Template)));
  
    Result.Put('items', Fazo.Zip_Matrix(Columns_All));
    Result.Put('crs', Uit_Href.Col_Required_Settings);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    g_Starting_Row           := Starting_Row;
    g_Setting                := Nvl(Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                                i_Filial_Id  => Ui.Filial_Id,
                                                                i_Code       => c_Pc_Column_Items)),
                                    Hashmap());
    g_Location_Identifier    := Load_Preference(c_Pref_Location_Identifier);
    g_Region_Identifier      := Load_Preference(c_Pref_Region_Identifier);
    g_Division_Identifier    := Load_Preference(c_Pref_Division_Identifier);
    g_Org_Unit_Identifier    := Load_Preference(c_Pref_Org_Unit_Identifier);
    g_Job_Identifier         := Load_Preference(c_Pref_Job_Identifier);
    g_Schedule_Identifier    := Load_Preference(c_Pref_Schedule_Identifier);
    g_Login_Autogenerate     := Load_Login_Autogenerate;
    g_Parent_Region_Id       := Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Code       => c_Pref_Parent_Region_Id);
    g_Advanced_Org_Structure := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Advanced_Org_Structure;
  
    g_Errors := Arraylist();
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Person_Document_Id(i_Person_Id number) return number is
    v_Document_Id number;
    v_Doc_Type_Id number;
  begin
    v_Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => Ui.Company_Id,
                                           i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
  
    select d.Document_Id
      into v_Document_Id
      from Href_Person_Documents d
     where d.Company_Id = Ui.Company_Id
       and d.Person_Id = i_Person_Id
       and d.Doc_Type_Id = v_Doc_Type_Id
       and Rownum = 1;
  
    return v_Document_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return b_Table is
    v_Oper_Group_Id number := Hpr_Util.Oper_Group_Id(i_Company_Id => Ui.Company_Id,
                                                     i_Pcode      => Hpr_Pref.c_Pcode_Operation_Group_Wage);
    v_Template_Goal varchar2(1) := Template_Goal;
    v_Date          date := Trunc(sysdate);
    r_Hrm_Setting   Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                  i_Filial_Id  => Ui.Filial_Id);
  
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
               where q.Company_Id = i_Company_Id
                 and q.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Nationality_Count := g_Nationality_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- location: column - 3
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Location_Count := 0;
    for r in (select q.Name
                from Htt_Locations q
               where q.Company_Id = i_Company_Id
                 and q.State = 'A'
                 and exists (select *
                        from Htt_Location_Filials Lf
                       where Lf.Company_Id = i_Company_Id
                         and Lf.Filial_Id = i_Filial_Id
                         and Lf.Location_Id = q.Location_Id)
               order by q.Name)
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Location_Count := g_Location_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- region: column - 4 
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Region_Count := 0;
    for r in (select d.Name
                from Md_Regions d
               where d.Company_Id = Ui.Company_Id
                 and (g_Parent_Region_Id is null or d.Parent_Id = g_Parent_Region_Id)
                 and d.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Region_Count := g_Region_Count + 1;
    end loop;
  
    a.Data(c);
  
    if v_Template_Goal = c_Pref_Template_Goal_Insert then
      -- fte: column - 5
      c := b_Report.New_Table;
      c.New_Row;
    
      g_Fte_Count := 0;
      for r in (select d.Name
                  from Href_Ftes d
                 where d.Company_Id = Ui.Company_Id)
      loop
        c.Data(r.Name);
        c.New_Row;
        g_Fte_Count := g_Fte_Count + 1;
      end loop;
    
      a.Data(c);
    
      -- oper type: column - 6
      c := b_Report.New_Table;
      c.New_Row;
    
      g_Oper_Type_Count := 0;
      for r in (select d.Name
                  from Mpr_Oper_Types d
                 where d.Company_Id = Ui.Company_Id
                   and d.State = 'A'
                   and exists (select 1
                          from Hpr_Oper_Types q
                         where q.Company_Id = d.Company_Id
                           and q.Oper_Type_Id = d.Oper_Type_Id
                           and q.Oper_Group_Id = v_Oper_Group_Id))
      loop
        c.Data(r.Name);
        c.New_Row;
        g_Oper_Type_Count := g_Oper_Type_Count + 1;
      end loop;
    
      a.Data(c);
    
      -- schedule: column - 7
      c := b_Report.New_Table;
      c.New_Row;
    
      g_Schedule_Count := 0;
      for r in (select d.Name
                  from Htt_Schedules d
                 where d.Company_Id = Ui.Company_Id
                   and d.Filial_Id = Ui.Filial_Id
                   and d.State = 'A')
      loop
        c.Data(r.Name);
        c.New_Row;
        g_Schedule_Count := g_Schedule_Count + 1;
      end loop;
    
      a.Data(c);
    
      if r_Hrm_Setting.Position_Enable = 'N' then
        -- division: column - 8
        c := b_Report.New_Table;
        c.New_Row;
        g_Division_Count := 0;
      
        if r_Hrm_Setting.Advanced_Org_Structure = 'Y' then
          for r in (select p.Name
                      from Hrm_Divisions q
                      join Mhr_Divisions p
                        on p.Company_Id = q.Company_Id
                       and p.Filial_Id = q.Filial_Id
                       and p.Division_Id = q.Division_Id
                       and p.State = 'A'
                     where q.Company_Id = Ui.Company_Id
                       and q.Filial_Id = Ui.Filial_Id
                       and q.Is_Department = 'Y')
          loop
            c.Data(r.Name);
            c.New_Row;
            g_Division_Count := g_Division_Count + 1;
          end loop;
        else
          for r in (select d.Name
                      from Mhr_Divisions d
                     where d.Company_Id = Ui.Company_Id
                       and d.Filial_Id = Ui.Filial_Id
                       and d.State = 'A')
          loop
            c.Data(r.Name);
            c.New_Row;
            g_Division_Count := g_Division_Count + 1;
          end loop;
        end if;
      
        a.Data(c);
      
        if r_Hrm_Setting.Advanced_Org_Structure = 'Y' then
          -- org unit: column - 9
          c := b_Report.New_Table;
          c.New_Row;
        
          g_Org_Unit_Count := 0;
          for r in (select p.Name
                      from Hrm_Divisions q
                      join Mhr_Divisions p
                        on p.Company_Id = q.Company_Id
                       and p.Filial_Id = q.Filial_Id
                       and p.Division_Id = q.Division_Id
                       and p.State = 'A'
                     where q.Company_Id = Ui.Company_Id
                       and q.Filial_Id = Ui.Filial_Id
                       and q.Is_Department = 'N')
          loop
            c.Data(r.Name);
            c.New_Row;
            g_Org_Unit_Count := g_Org_Unit_Count + 1;
          end loop;
        
          a.Data(c);
        end if;
      
        -- job: column - 10
        c := b_Report.New_Table;
        c.New_Row;
      
        g_Job_Count := 0;
        for r in (select d.Name
                    from Mhr_Jobs d
                   where d.Company_Id = Ui.Company_Id
                     and d.Filial_Id = Ui.Filial_Id
                     and d.State = 'A')
        loop
          c.Data(r.Name);
          c.New_Row;
          g_Job_Count := g_Job_Count + 1;
        end loop;
      
        a.Data(c);
      
        if r_Hrm_Setting.Rank_Enable = 'Y' then
          -- rank: column - 11
          c := b_Report.New_Table;
          c.New_Row;
        
          g_Rank_Count := 0;
          for r in (select d.Name
                      from Mhr_Ranks d
                     where d.Company_Id = Ui.Company_Id
                       and d.Filial_Id = Ui.Filial_Id)
          loop
            c.Data(r.Name);
            c.New_Row;
            g_Rank_Count := g_Rank_Count + 1;
          end loop;
        
          a.Data(c);
        
          if r_Hrm_Setting.Wage_Scale_Enable = 'Y' then
            -- wage scale: column - 12
            c := b_Report.New_Table;
            c.New_Row;
          
            g_Wage_Scale_Count := 0;
            for r in (select d.Name
                        from Hrm_Wage_Scales d
                       where d.Company_Id = Ui.Company_Id
                         and d.Filial_Id = Ui.Filial_Id
                         and d.State = 'A')
            loop
              c.Data(r.Name);
              c.New_Row;
              g_Wage_Scale_Count := g_Wage_Scale_Count + 1;
            end loop;
          
            a.Data(c);
          end if;
        end if;
      else
        -- robot: column - 8
        c := b_Report.New_Table;
        c.New_Row;
      
        g_Robot_Count := 0;
        for r in (select d.Name
                    from Mrf_Robots d
                   where d.Company_Id = Ui.Company_Id
                     and d.Filial_Id = Ui.Filial_Id
                     and d.State = 'A'
                     and exists
                   (select 1
                            from Hrm_Robots q
                           where q.Company_Id = d.Company_Id
                             and q.Filial_Id = d.Filial_Id
                             and q.Robot_Id = d.Robot_Id)
                     and (select min(Fte)
                            from Hrm_Robot_Turnover Rob
                           where Rob.Company_Id = d.Company_Id
                             and Rob.Filial_Id = d.Filial_Id
                             and Rob.Robot_Id = d.Robot_Id
                             and (Rob.Period >= v_Date or
                                 Rob.Period = (select max(Rt.Period)
                                                  from Hrm_Robot_Turnover Rt
                                                 where Rt.Company_Id = Rob.Company_Id
                                                   and Rt.Filial_Id = Rob.Filial_Id
                                                   and Rt.Robot_Id = Rob.Robot_Id
                                                   and Rt.Period <= v_Date))) > 0)
        loop
          c.Data(r.Name);
          c.New_Row;
          g_Robot_Count := g_Robot_Count + 1;
        end loop;
      
        a.Data(c);
      end if;
    end if;
  
    return a;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    a               b_Table;
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Data_Matrix   Matrix_Varchar2;
    v_Columns_All   Matrix_Varchar2;
    v_Begin_Index   number;
    v_Source_Name   varchar2(10) := 'data';
    v_Template_Goal varchar2(1) := Template_Goal;
    v_Source_Table  b_Table;
    r_Document      Href_Person_Documents%rowtype;
  
    v_Date                 date := Trunc(sysdate);
    v_Access_All_Employees varchar2(1);
    v_User_Id              number := Ui.User_Id;
    r_Hrm_Settings         Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                         i_Filial_Id  => Ui.Filial_Id);
    v_Division_Ids         Array_Number;
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
    Function Column_Usage(i_Key varchar2) return varchar2 is
      v_Column_Usage varchar2(1);
    begin
      for i in 1 .. v_Columns_All.Count
      loop
        if v_Columns_All(i) (1) = i_Key then
          v_Column_Usage := v_Columns_All(i) (4);
          exit;
        end if;
      end loop;
    
      return v_Column_Usage;
    end;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null
    ) is
      v_Column_Order number := Column_Order(i_Column_Key);
      v_Column_Usage varchar2(1) := Column_Usage(i_Column_Key);
    begin
      if v_Column_Usage = 'Y' then
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
  begin
    v_Columns_All := Columns_All;
    v_Data_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    Set_Global_Variables;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    v_Source_Table := Source_Table(v_Company_Id, v_Filial_Id);
  
    a := b_Report.New_Table;
  
    a.Current_Style('header');
    a.New_Row;
    -- Personal Info
    Set_Column(c_Employee_Id, t('employee_id'), 150);
    Set_Column(c_Employee_Number, t('employee_number'), 150);
    Set_Column(c_First_Name, t('first_name'), 100);
    Set_Column(c_Last_Name, t('last_name'), 100);
    Set_Column(c_Middle_Name, t('middle_name'), 100);
    Set_Column(c_Gender, t('gender'), 100);
    Set_Column(c_Birthday, t('birthday'), 100);
    Set_Column(c_Nationality, t('nationality'), 100);
    Set_Column(c_Npin, t('npin'), 150);
    Set_Column(c_Tin, t('tin'), 100);
    Set_Column(c_Iapa, t('iapa'), 100);
    Set_Column(c_Login, t('login'), 100);
    Set_Column(c_Note, t('note'), 100);
    -- Contact And Address          
    Set_Column(c_Address, t('address'), 200);
    Set_Column(c_Legal_Address, t('legal_address'), 200);
    Set_Column(c_Region, t('region'), 200);
    Set_Column(c_Main_Phone, t('main_phone'), 150);
    Set_Column(c_Email, t('email'), 200);
    Set_Column(c_Corporate_Email, t('corporate_email'), 200);
    Set_Column(c_Extra_Phone_Number, t('extra_phone_number'), 100);
    --Passport Info
    Set_Column(c_Passport_Series, t('passport_series'), 100);
    Set_Column(c_Passport_Number, t('passport_number'), 100);
    Set_Column(c_Passport_Begin_Date, t('passport_begin_date'), 100);
    Set_Column(c_Passport_Expiry_Date, t('passport_expiry_date'), 100);
    Set_Column(c_Passport_Issued_By, t('passport_issued_by'), 200);
    Set_Column(c_Passport_Issued_Date, t('passport_issued_date'), 100);
    -- Identification
    Set_Column(c_Pin, t('pin'), 100);
    Set_Column(c_Pin_Code, t('pin_code'), 100);
    Set_Column(c_Rfid_Code, t('rfid_code'), 100);
  
    if g_Location_Identifier = c_Identifier_Code then
      Set_Column(c_Location, t('location (code)'), 150);
    else
      Set_Column(c_Location, t('location'), 150);
    end if;
  
    --Quick Hiring 
    if v_Template_Goal = c_Pref_Template_Goal_Insert then
      Set_Column(c_Hiring_Date, t('hiring_date'), 100);
    
      if r_Hrm_Settings.Position_Enable = 'N' then
        if g_Division_Identifier = c_Identifier_Code then
          Set_Column(c_Division, t('division (code)'), 100);
        else
          Set_Column(c_Division, t('division'), 100);
        end if;
      
        if r_Hrm_Settings.Advanced_Org_Structure = 'Y' then
          if g_Org_Unit_Identifier = c_Identifier_Code then
            Set_Column(c_Org_Unit, t('org unit (code)'), 100);
          else
            Set_Column(c_Org_Unit, t('org unit'), 100);
          end if;
        end if;
      
        if g_Job_Identifier = c_Identifier_Code then
          Set_Column(c_Job, t('job (code)'), 100);
        else
          Set_Column(c_Job, t('job'), 100);
        end if;
      
        if r_Hrm_Settings.Rank_Enable = 'Y' then
          Set_Column(c_Rank, t('rank'), 100);
        
          if r_Hrm_Settings.Wage_Scale_Enable = 'Y' then
            Set_Column(c_Wage_Scale, t('wage scale'), 100);
          end if;
        end if;
      else
        Set_Column(c_Robot, t('robot'), 100);
      end if;
    
      Set_Column(c_Fte, t('fte'), 100);
      Set_Column(c_Oper_Type, t('oper_type'), 100);
      Set_Column(c_Wage, t('wage'), 100);
    
      if g_Schedule_Identifier = c_Identifier_Code then
        Set_Column(c_Schedule, t('schedule (code)'), 100);
      else
        Set_Column(c_Schedule, t('schedule'), 100);
      end if;
    end if;
  
    if Column_Order(c_Gender) is not null then
      a.Column_Data_Source(Column_Order(c_Gender), 1, 102, v_Source_Name, 1, g_Nationality_Count); -- gender
    end if;
  
    if Column_Order(c_Nationality) is not null then
      a.Column_Data_Source(Column_Order(c_Nationality), 1, 102, v_Source_Name, 2, 2); -- nationality
    end if;
  
    if g_Location_Count > 0 and g_Location_Identifier <> c_Identifier_Code and
       Column_Order(c_Location) is not null then
      a.Column_Data_Source(Column_Order(c_Location), 1, 102, v_Source_Name, 3, g_Location_Count); -- location
    end if;
  
    if g_Region_Count > 0 and Column_Order(c_Region) is not null and
       g_Region_Identifier = c_Identifier_Name then
      a.Column_Data_Source(Column_Order(c_Region), 1, 102, v_Source_Name, 4, g_Region_Count); -- region
    end if;
  
    if v_Template_Goal = c_Pref_Template_Goal_Insert then
      if g_Fte_Count > 0 and Column_Order(c_Fte) is not null then
        a.Column_Data_Source(Column_Order(c_Fte), 1, 102, v_Source_Name, 5, g_Fte_Count); -- fte
      end if;
    
      if g_Oper_Type_Count > 0 and Column_Order(c_Oper_Type) is not null then
        a.Column_Data_Source(Column_Order(c_Oper_Type),
                             1,
                             102,
                             v_Source_Name,
                             6,
                             g_Oper_Type_Count); --oper type
      end if;
    
      if g_Schedule_Count > 0 and Column_Order(c_Schedule) is not null and
         g_Schedule_Identifier = c_Identifier_Name then
        a.Column_Data_Source(Column_Order(c_Schedule), 1, 102, v_Source_Name, 7, g_Schedule_Count); -- schedule
      end if;
    
      if r_Hrm_Settings.Position_Enable = 'N' then
        if g_Division_Count > 0 and Column_Order(c_Division) is not null and
           g_Division_Identifier = c_Identifier_Name then
          a.Column_Data_Source(Column_Order(c_Division),
                               1,
                               102,
                               v_Source_Name,
                               8,
                               g_Division_Count); -- division
        end if;
      
        if g_Org_Unit_Count > 0 and Column_Order(c_Org_Unit) is not null and
           g_Org_Unit_Identifier = c_Identifier_Name and
           r_Hrm_Settings.Advanced_Org_Structure = 'Y' then
          a.Column_Data_Source(Column_Order(c_Org_Unit),
                               1,
                               102,
                               v_Source_Name,
                               9,
                               g_Org_Unit_Count); -- org unit        
        end if;
      
        if g_Job_Count > 0 and Column_Order(c_Job) is not null and
           g_Job_Identifier = c_Identifier_Name then
          a.Column_Data_Source(Column_Order(c_Job), 1, 102, v_Source_Name, 10, g_Job_Count); -- job
        end if;
      
        if r_Hrm_Settings.Rank_Enable = 'Y' then
          if g_Rank_Count > 0 and Column_Order(c_Rank) is not null then
            a.Column_Data_Source(Column_Order(c_Rank), 1, 102, v_Source_Name, 11, g_Rank_Count); -- rank
          end if;
        
          if r_Hrm_Settings.Wage_Scale_Enable = 'Y' and g_Wage_Scale_Count > 0 and
             Column_Order(c_Wage_Scale) is not null then
            a.Column_Data_Source(Column_Order(c_Wage_Scale),
                                 1,
                                 102,
                                 v_Source_Name,
                                 12,
                                 g_Wage_Scale_Count); -- wage scale
          end if;
        end if;
      else
        if g_Robot_Count > 0 and Column_Order(c_Robot) is not null then
          a.Column_Data_Source(Column_Order(c_Robot), 1, 102, v_Source_Name, 8, g_Robot_Count); -- robot
        end if;
      end if;
    end if;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      a.Column_Width(i, v_Data_Matrix(i) (2));
      a.Data(v_Data_Matrix(i) (1));
    end loop;
  
    a.Current_Style('root');
  
    if v_Template_Goal = c_Pref_Template_Goal_Update then
      v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
    
      if v_Access_All_Employees = 'N' then
        v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                             i_Indirect => true,
                                                             i_Manual   => true);
      end if;
    
      for r in (select s.Employee_Id,
                       s.Employee_Number,
                       t.First_Name,
                       t.Last_Name,
                       t.Middle_Name,
                       t.Birthday,
                       t.Gender,
                       d.Address,
                       d.Tin,
                       Hd.Iapa,
                       Hd.Npin,
                       Hd.Corporate_Email,
                       Hd.Extra_Phone,
                       (select Us.Login
                          from Md_Users Us
                         where Us.Company_Id = s.Company_Id
                           and Us.User_Id = s.Employee_Id) as Login,
                       (select Nat.Name
                          from Href_Nationalities Nat
                         where Nat.Company_Id = t.Company_Id
                           and Nat.Nationality_Id = Hd.Nationality_Id) as Nationality,
                       (select Listagg((select Decode(g_Location_Identifier,
                                                     c_Identifier_Code,
                                                     g.Code,
                                                     c_Identifier_Name,
                                                     g.Name)
                                         from Htt_Locations g
                                        where g.Company_Id = t.Company_Id
                                          and g.Location_Id = m.Location_Id),
                                       ',') Within group(order by m.Location_Id)
                          from Htt_Location_Persons m
                         where m.Company_Id = t.Company_Id
                           and m.Filial_Id = s.Filial_Id
                           and m.Person_Id = t.Person_Id
                           and not exists (select 1
                                  from Htt_Blocked_Person_Tracking Bp
                                 where Bp.Company_Id = m.Company_Id
                                   and Bp.Filial_Id = m.Filial_Id
                                   and Bp.Employee_Id = m.Person_Id)) as Location,
                       j.Pin,
                       j.Rfid_Code,
                       j.Pin_Code,
                       d.Main_Phone,
                       d.Legal_Address,
                       d.Note,
                       (select Decode(g_Region_Identifier,
                                      c_Identifier_Code,
                                      Reg.Code,
                                      c_Identifier_Name,
                                      Reg.Name)
                          from Md_Regions Reg
                         where Reg.Company_Id = s.Company_Id
                           and Reg.Region_Id = d.Region_Id) Region,
                       (select w.Email
                          from Md_Persons w
                         where w.Company_Id = t.Company_Id
                           and w.Person_Id = t.Person_Id) Email,
                       t.Code
                  from Mhr_Employees s
                  join Mr_Natural_Persons t
                    on s.Company_Id = t.Company_Id
                   and s.Employee_Id = t.Person_Id
                  left join Mr_Person_Details d
                    on d.Company_Id = t.Company_Id
                   and d.Person_Id = t.Person_Id
                  left join Htt_Persons j
                    on j.Company_Id = t.Company_Id
                   and j.Person_Id = t.Person_Id
                  left join Href_Person_Details Hd
                    on Hd.Company_Id = t.Company_Id
                   and Hd.Person_Id = t.Person_Id
                 where t.Company_Id = v_Company_Id
                   and s.Filial_Id = v_Filial_Id
                   and (v_Access_All_Employees = 'Y' or v_User_Id <> s.Employee_Id and exists
                        (select *
                           from Href_Staffs St
                          where St.Company_Id = v_Company_Id
                            and St.Filial_Id = v_Filial_Id
                            and St.Employee_Id = s.Employee_Id
                            and St.State = 'A'
                            and St.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                            and St.Hiring_Date <= v_Date
                            and (St.Dismissal_Date is null or St.Dismissal_Date >= v_Date)
                            and St.Org_Unit_Id member of v_Division_Ids)))
      loop
        v_Data_Matrix := Matrix_Varchar2();
        v_Begin_Index := 0;
      
        r_Document := z_Href_Person_Documents.Take(i_Company_Id  => Ui.Company_Id,
                                                   i_Document_Id => Person_Document_Id(r.Employee_Id));
      
        a.New_Row;
        Set_Column(c_Employee_Id, to_char(r.Employee_Id));
        Set_Column(c_Employee_Number, r.Employee_Number);
        Set_Column(c_First_Name, r.First_Name);
        Set_Column(c_Last_Name, r.Last_Name);
        Set_Column(c_Middle_Name, r.Middle_Name);
        Set_Column(c_Gender, r.Gender);
        Set_Column(c_Birthday, r.Birthday);
        Set_Column(c_Nationality, r.Nationality);
        Set_Column(c_Tin, r.Tin);
        Set_Column(c_Iapa, r.Iapa);
        Set_Column(c_Npin, r.Npin);
        Set_Column(c_Login, r.Login);
        Set_Column(c_Address, r.Address);
        Set_Column(c_Legal_Address, r.Legal_Address);
        Set_Column(c_Region, r.Region);
        Set_Column(c_Main_Phone, r.Main_Phone);
        Set_Column(c_Email, r.Email);
        Set_Column(c_Corporate_Email, r.Corporate_Email);
        Set_Column(c_Extra_Phone_Number, r.Extra_Phone);
        Set_Column(c_Passport_Series, r_Document.Doc_Series);
        Set_Column(c_Passport_Number, r_Document.Doc_Number);
        Set_Column(c_Passport_Issued_Date, r_Document.Issued_Date);
        Set_Column(c_Passport_Issued_By, r_Document.Issued_By);
        Set_Column(c_Passport_Begin_Date, r_Document.Begin_Date);
        Set_Column(c_Passport_Expiry_Date, r_Document.Expiry_Date);
        Set_Column(c_Pin, r.Pin);
        Set_Column(c_Pin_Code, r.Pin_Code);
        Set_Column(c_Rfid_Code, r.Rfid_Code);
        Set_Column(c_Location, r.Location);
        Set_Column(c_Note, r.Note);
      
        for i in 1 .. v_Data_Matrix.Count
        loop
          a.Data(v_Data_Matrix(i) (1));
        end loop;
      end loop;
    end if;
  
    b_Report.Add_Sheet(t('employees'), a);
    b_Report.Add_Sheet(i_Name  => v_Source_Name, --
                       p_Table => v_Source_Table);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Employee_Id(i_Employee_Id varchar2) is
  begin
    if i_Employee_Id is not null then
      select t.Employee_Id
        into g_Employee.Employee_Id
        from Mhr_Employees t
       where t.Company_Id = Ui.Company_Id
         and t.Filial_Id = Ui.Filial_Id
         and t.Employee_Id = to_number(i_Employee_Id);
    
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => g_Employee.Employee_Id, i_Self => false);
    end if;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with employee id $2{employee id}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Employee_Id));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Employee_Number(i_Employee_Number varchar2) is
  begin
    if i_Employee_Number is null then
      return;
    end if;
  
    g_Employee.Employee_Number := i_Employee_Number;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with employee number $2{employee number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Employee_Number));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_First_Name(i_First_Name varchar2) is
  begin
    if i_First_Name is null then
      return;
    end if;
  
    g_Employee.First_Name := i_First_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with natural person first name $2{natural person}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_First_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Last_Name(i_Last_Name varchar2) is
  begin
    if i_Last_Name is null then
      return;
    end if;
  
    g_Employee.Last_Name := i_Last_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with natural person last name $2{natural person}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Last_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Middle_Name(i_Middle_Name varchar2) is
  begin
    if i_Middle_Name is null then
      return;
    end if;
  
    g_Employee.Middle_Name := i_Middle_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with natural person middle name $2{natural person}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Middle_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Birthday(i_Birthday varchar2) is
  begin
    if i_Birthday is null then
      return;
    end if;
  
    g_Employee.Birthday := Mr_Util.Convert_To_Date(i_Birthday);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with birthday $2{birthday}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Birthday));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Gender(i_Gender varchar2) is
  begin
    if i_Gender is null then
      return;
    end if;
  
    g_Employee.Gender := i_Gender;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with gender $2{gender}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Gender));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Nationality(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Nationality    := i_Value;
    g_Employee.Nationality_Id := Href_Util.Nationality_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                                  i_Name       => i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with nationality $2{nationality}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Npin(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Npin := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with npin $2{npin}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Tin(i_Tin varchar2) is
  begin
    if i_Tin is null then
      return;
    end if;
  
    g_Employee.Tin := i_Tin;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with tin $2{tin}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Tin));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Iapa(i_Iapa varchar2) is
  begin
    if i_Iapa is null then
      return;
    end if;
  
    g_Employee.Iapa := i_Iapa;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with iapa $2{iapa}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Iapa));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Login
  (
    i_First_Name  varchar2,
    i_Last_Name   varchar2,
    i_Login       varchar2,
    i_Employee_Id number
  ) is
    v_Login varchar2(100) := trim(i_Login);
    v_Dummy varchar2(1);
  begin
    if g_Login_Autogenerate = 'Y' then
      g_Login_Template := Load_Template(c_Pref_Login_Template);
    
      v_Login := Regexp_Replace(g_Login_Template, 'first_name', i_First_Name);
      v_Login := Regexp_Replace(v_Login, 'last_name', i_Last_Name);
      v_Login := Md_Util.Login_Fixer(v_Login);
    
      v_Login := Regexp_Replace(v_Login, '@', '');
    end if;
  
    select 'x'
      into v_Dummy
      from Md_Users k
     where k.Company_Id = Ui.Company_Id
       and k.User_Id <> i_Employee_Id
       and Lower(k.Login) = Lower(v_Login);
  
    g_Error_Messages.Push(t('error with first name=$1{first name}, last name=$2{last_name}, login=$3{login} already used by another user',
                            i_First_Name,
                            i_Last_Name,
                            i_Login));
  exception
    when No_Data_Found then
      g_Employee.Login := i_Login;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Address(i_Address varchar2) is
  begin
    if i_Address is null then
      return;
    end if;
  
    g_Employee.Address := i_Address;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with address $2{address}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Address));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Legal_Address(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Legal_Address := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with legal address $2{legal_address}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Region(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    if g_Region_Identifier = c_Identifier_Name then
      g_Employee.Region_Id := Md_Util.Region_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Name       => i_Value);
    else
      g_Employee.Region_Id := Md_Util.Region_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                        i_Code       => i_Value);
    end if;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with region $2{region}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Main_Phone(i_Main_Phone varchar2) is
  begin
    if i_Main_Phone is null then
      return;
    end if;
  
    g_Employee.Main_Phone := i_Main_Phone;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with main phone $2{main phone}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Main_Phone));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Email(i_Email varchar2) is
  begin
    if i_Email is null then
      return;
    end if;
  
    g_Employee.Email := i_Email;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with email $2{email}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Email));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Corporate_Email(i_Corporate_Email varchar2) is
  begin
    if i_Corporate_Email is null then
      return;
    end if;
  
    g_Employee.Corporate_Email := i_Corporate_Email;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with corporate email $2{corporate_email}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Corporate_Email));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Extra_Phone_Number(i_Extra_Phone varchar2) is
  begin
    if i_Extra_Phone is null then
      return;
    end if;
  
    g_Employee.Extra_Phone_Number := i_Extra_Phone;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with extra phone number $2{extra phone number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Extra_Phone));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Note(i_Note varchar2) is
  begin
    if i_Note is null then
      return;
    end if;
  
    g_Employee.Note := i_Note;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with extra phone number $2{extra phone number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Note));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Passport_Series(i_Passport_Series varchar2) is
  begin
    if i_Passport_Series is null then
      return;
    end if;
  
    g_Employee.Passport_Series := i_Passport_Series;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with passport_series $2{passport_series}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Passport_Series));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Passport_Number(i_Passport_Number varchar2) is
  begin
    if i_Passport_Number is null then
      return;
    end if;
  
    g_Employee.Passport_Number := i_Passport_Number;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with passport_number $2{passport_number}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Passport_Number));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Passport_Issued_Date(i_Passport_Issued_Date varchar2) is
  begin
    if i_Passport_Issued_Date is null then
      return;
    end if;
  
    g_Employee.Passport_Issued_Date := Mr_Util.Convert_To_Date(i_Passport_Issued_Date);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with passport_issued_date $2{passport_issued_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Passport_Issued_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Passport_Issued_By(i_Passport_Issued_By varchar2) is
  begin
    if i_Passport_Issued_By is null then
      return;
    end if;
  
    g_Employee.Passport_Issued_By := i_Passport_Issued_By;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with passport_issued_by $2{passport_issued_by}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Passport_Issued_By));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Passport_Begin_Date(i_Passport_Begin_Date varchar2) is
  begin
    if i_Passport_Begin_Date is null then
      return;
    end if;
  
    g_Employee.Passport_Begin_Date := Mr_Util.Convert_To_Date(i_Passport_Begin_Date);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with passport_begin_date $2{passport_begin_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Passport_Begin_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Passport_Expiry_Date(i_Passport_Expiry_Date varchar2) is
  begin
    if i_Passport_Expiry_Date is null then
      return;
    end if;
  
    g_Employee.Passport_Expiry_Date := Mr_Util.Convert_To_Date(i_Passport_Expiry_Date);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with passport_expiry_date $2{passport_expiry_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Passport_Expiry_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Pin(i_Pin varchar2) is
  begin
    if i_Pin is null then
      return;
    end if;
  
    g_Employee.Pin := i_Pin;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with pin $2{pin}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Pin));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Pin_Code(i_Pin_Code varchar2) is
  begin
    if i_Pin_Code is null then
      return;
    end if;
  
    g_Employee.Pin_Code := i_Pin_Code;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with pin_code $2{pin_code}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Pin_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Rfid_Code(i_Rfid_Code varchar2) is
  begin
    if i_Rfid_Code is null then
      return;
    end if;
  
    g_Employee.Rfid_Code := i_Rfid_Code;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with rfid_code $2{rfid_code}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Rfid_Code));
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
  Procedure Set_Hiring_Date(i_Hiring_Date varchar2) is
  begin
    if i_Hiring_Date is null then
      return;
    end if;
  
    g_Employee.Hiring_Date := i_Hiring_Date;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with hiring date $2{hiring_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Hiring_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division(i_Division varchar2) is
    v_Dummy varchar2(1);
  begin
    if i_Division is null or g_Employee.Hiring_Date is null then
      return;
    end if;
  
    if g_Division_Identifier = c_Identifier_Code then
      g_Employee.Division_Id := Mhr_Util.Division_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Code       => i_Division);
    else
      g_Employee.Division_Id := Mhr_Util.Division_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Name       => i_Division);
    end if;
  
    g_Employee.Division := i_Division;
  
    if g_Advanced_Org_Structure = 'Y' then
      select 'x'
        into v_Dummy
        from Hrm_Divisions q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Division_Id = g_Employee.Division_Id
         and q.Is_Department = 'Y';
    end if;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division $2{division}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Division));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Org_Unit(i_Org_Unit varchar2) is
  begin
    if i_Org_Unit is null or g_Employee.Hiring_Date is null then
      return;
    end if;
  
    if g_Org_Unit_Identifier = c_Identifier_Code then
      g_Employee.Org_Unit_Id := Mhr_Util.Division_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Code       => i_Org_Unit);
    else
      g_Employee.Org_Unit_Id := Mhr_Util.Division_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Name       => i_Org_Unit);
    end if;
  
    g_Employee.Org_Unit := i_Org_Unit;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with org unit $2{org unit}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Org_Unit));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Job(i_Job varchar2) is
    v_Dummy varchar2(1);
  begin
    if i_Job is null or g_Employee.Division_Id is null then
      return;
    end if;
  
    if g_Job_Identifier = c_Identifier_Code then
      g_Employee.Job_Id := Mhr_Util.Job_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Code       => i_Job);
    else
      g_Employee.Job_Id := Mhr_Util.Job_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Name       => i_Job);
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
  
    g_Employee.Job := i_Job;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job $2{job}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Job));
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Set_Rank(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Rank    := i_Value;
    g_Employee.Rank_Id := Mhr_Util.Rank_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Name       => i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with rank $2{rank}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Set_Wage_Scale(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Wage_Scale    := i_Value;
    g_Employee.Wage_Scale_Id := Hrm_Util.Wage_Scale_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                               i_Filial_Id  => Ui.Filial_Id,
                                                               i_Name       => i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with wage scale $2{wage scale}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fte(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Fte_Id := Href_Util.Fte_Id_By_Name(i_Company_Id => Ui.Company_Id, i_Name => i_Value);
    g_Employee.Fte    := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fte $2{fte}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------        
  Procedure Set_Robot(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Robot    := i_Value;
    g_Employee.Robot_Id := Hrm_Util.Robot_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Name       => i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with robot $2{robot}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------        
  Procedure Set_Oper_Type(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Oper_Type    := i_Value;
    g_Employee.Oper_Type_Id := Hpr_Util.Oper_Type_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                             i_Name       => i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with oper type $2{oper_type}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------        
  Procedure Set_Wage(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Employee.Wage := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with wage $2{wage}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Schedule(i_Value varchar2) is
  begin
    if i_Value is null then
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
      if g_Setting.o_Varchar2(i_Column_Name || c_Text_Usage) is null or
         g_Setting.o_Varchar2(i_Column_Name || c_Text_Usage) = 'N' then
        return null;
      end if;
    
      if g_Setting.Count = 0 then
        v_Column_Number := Default_Column_Number(i_Column_Name);
      else
        v_Column_Number := g_Setting.o_Varchar2(i_Column_Name);
      end if;
    
      v_Cell_Value := i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
    
      return v_Cell_Value;
    end;
  begin
    -- Personal Info
    Set_Employee_Id(Cell_Value(c_Employee_Id));
    Set_Employee_Number(Cell_Value(c_Employee_Number));
    Set_First_Name(Cell_Value(c_First_Name));
    Set_Last_Name(Cell_Value(c_Last_Name));
    Set_Middle_Name(Cell_Value(c_Middle_Name));
    Set_Gender(Cell_Value(c_Gender));
    Set_Birthday(Cell_Value(c_Birthday));
    Set_Nationality(Cell_Value(c_Nationality));
    Set_Npin(Cell_Value(c_Npin));
    Set_Tin(Cell_Value(c_Tin));
    Set_Iapa(Cell_Value(c_Iapa));
    Set_Login(i_First_Name  => Cell_Value(c_First_Name),
              i_Last_Name   => Cell_Value(c_Last_Name),
              i_Login       => Cell_Value(c_Login),
              i_Employee_Id => Cell_Value(c_Employee_Id));
    Set_Note(Cell_Value(c_Note));
    -- Contact And Address
    Set_Address(Cell_Value(c_Address));
    Set_Legal_Address(Cell_Value(c_Legal_Address));
    Set_Region(Cell_Value(c_Region));
    Set_Main_Phone(Cell_Value(c_Main_Phone));
    Set_Email(Cell_Value(c_Email));
    Set_Corporate_Email(Cell_Value(c_Corporate_Email));
    Set_Extra_Phone_Number(Cell_Value(c_Extra_Phone_Number));
    -- Passport Info
    Set_Passport_Series(Cell_Value(c_Passport_Series));
    Set_Passport_Number(Cell_Value(c_Passport_Number));
    Set_Passport_Begin_Date(Cell_Value(c_Passport_Begin_Date));
    Set_Passport_Expiry_Date(Cell_Value(c_Passport_Expiry_Date));
    Set_Passport_Issued_By(Cell_Value(c_Passport_Issued_By));
    Set_Passport_Issued_Date(Cell_Value(c_Passport_Issued_Date));
    -- Identification
    Set_Pin(Cell_Value(c_Pin));
    Set_Pin_Code(Cell_Value(c_Pin_Code));
    Set_Rfid_Code(Cell_Value(c_Rfid_Code));
    Set_Location(Cell_Value(c_Location));
    -- Quick Hiring 
    Set_Hiring_Date(Cell_Value(c_Hiring_Date));
    Set_Division(Cell_Value(c_Division));
    Set_Org_Unit(Cell_Value(c_Org_Unit));
    Set_Job(Cell_Value(c_Job));
    Set_Rank(Cell_Value(c_Rank));
    Set_Wage_Scale(Cell_Value(c_Wage_Scale));
    Set_Fte(Cell_Value(c_Fte));
    Set_Robot(Cell_Value(c_Robot));
    Set_Oper_Type(Cell_Value(c_Oper_Type));
    Set_Wage(Cell_Value(c_Wage));
    Set_Schedule(Cell_Value(c_Schedule));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Employee_To_Array return Array_Varchar2 is
  begin
    return Array_Varchar2(g_Employee.Employee_Id,
                          g_Employee.Employee_Number,
                          g_Employee.First_Name,
                          g_Employee.Last_Name,
                          g_Employee.Middle_Name,
                          g_Employee.Gender,
                          g_Employee.Birthday,
                          g_Employee.Nationality,
                          g_Employee.Nationality_Id,
                          g_Employee.Npin,
                          g_Employee.Tin,
                          g_Employee.Iapa,
                          g_Employee.Login,
                          g_Employee.Address,
                          g_Employee.Legal_Address,
                          g_Employee.Region_Id,
                          g_Employee.Main_Phone,
                          g_Employee.Email,
                          g_Employee.Corporate_Email,
                          g_Employee.Extra_Phone_Number,
                          g_Employee.Note,
                          g_Employee.Passport_Series,
                          g_Employee.Passport_Number,
                          g_Employee.Passport_Issued_Date,
                          g_Employee.Passport_Issued_By,
                          g_Employee.Passport_Begin_Date,
                          g_Employee.Passport_Expiry_Date,
                          g_Employee.Pin,
                          g_Employee.Pin_Code,
                          g_Employee.Rfid_Code,
                          g_Employee.Location,
                          g_Employee.Location_Id,
                          g_Employee.Hiring_Date,
                          g_Employee.Division,
                          g_Employee.Division_Id,
                          g_Employee.Org_Unit,
                          g_Employee.Org_Unit_Id,
                          g_Employee.Job,
                          g_Employee.Job_Id,
                          g_Employee.Rank,
                          g_Employee.Rank_Id,
                          g_Employee.Wage_Scale,
                          g_Employee.Wage_Scale_Id,
                          g_Employee.Fte,
                          g_Employee.Fte_Id,
                          g_Employee.Robot,
                          g_Employee.Robot_Id,
                          g_Employee.Oper_Type,
                          g_Employee.Oper_Type_Id,
                          g_Employee.Wage,
                          g_Employee.Schedule,
                          g_Employee.Schedule_Id);
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
  
    for i in g_Starting_Row .. Nvl(g_Ending_Row, v_Sheet.Count_Row)
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
  Function Employee_Id(p Hashmap) return number is
    v_Person        Href_Pref.Person_Rt;
    v_Htt_Person    Htt_Pref.Person_Rt;
    v_Employee      Href_Pref.Employee_Rt;
    r_Person        Mr_Natural_Persons%rowtype;
    r_Htt_Person    Htt_Persons%rowtype;
    r_Md_Person     Md_Persons%rowtype;
    r_Person_Detail Mr_Person_Details%rowtype;
    r_Href_Detail   Href_Person_Details%rowtype;
    v_Template_Goal varchar2(1) := Template_Goal;
    v_Employee_Id   number;
    v_Location_Id   number := p.o_Number('location_id');
  begin
    if v_Template_Goal = c_Pref_Template_Goal_Insert then
      v_Employee_Id := Md_Next.Person_Id;
    else
      if z_Mhr_Employees.Exist(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Employee_Id => p.o_Varchar2('employee_id')) then
        v_Employee_Id := p.o_Varchar2('employee_id');
        Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id, i_Self => false);
      
        z_Mhr_Employees.Lock_Only(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Employee_Id => v_Employee_Id);
      else
        v_Employee_Id := Md_Next.Person_Id;
      end if;
    end if;
  
    if not z_Md_Persons.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                   i_Person_Id  => v_Employee_Id,
                                   o_Row        => r_Md_Person) then
      r_Md_Person.Company_Id := Ui.Company_Id;
      r_Md_Person.Person_Id  := v_Employee_Id;
    end if;
  
    if not z_Mr_Natural_Persons.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                           i_Person_Id  => v_Employee_Id,
                                           o_Row        => r_Person) then
      r_Person.State := 'A';
    end if;
  
    if not z_Mr_Person_Details.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                          i_Person_Id  => v_Employee_Id,
                                          o_Row        => r_Person_Detail) then
      r_Person_Detail.Company_Id := Ui.Company_Id;
      r_Person_Detail.Person_Id  := v_Employee_Id;
    end if;
  
    if not z_Href_Person_Details.Exist(i_Company_Id => Ui.Company_Id,
                                       i_Person_Id  => v_Employee_Id,
                                       o_Row        => r_Href_Detail) then
      r_Href_Detail.Company_Id := Ui.Company_Id;
      r_Href_Detail.Person_Id  := v_Employee_Id;
    end if;
  
    Href_Util.Person_New(o_Person          => v_Person,
                         i_Company_Id      => Ui.Company_Id,
                         i_Person_Id       => v_Employee_Id,
                         i_First_Name      => p.r_Varchar2('first_name'),
                         i_Last_Name       => p.o_Varchar2('last_name'),
                         i_Middle_Name     => p.o_Varchar2('middle_name'),
                         i_Gender          => Nvl(p.o_Varchar2('gender'), 'M'),
                         i_Nationality_Id  => p.o_Number('nationality_id'),
                         i_Birthday        => p.o_Varchar2('birthday'),
                         i_Photo_Sha       => r_Md_Person.Photo_Sha,
                         i_Tin             => p.o_Varchar2('tin'),
                         i_Iapa            => p.o_Varchar2('iapa'),
                         i_Npin            => p.o_Varchar2('npin'),
                         i_Region_Id       => p.o_Number('region_id'),
                         i_Main_Phone      => p.o_Varchar2('main_phone'),
                         i_Email           => p.o_Varchar2('email'),
                         i_Address         => p.o_Varchar2('address'),
                         i_Legal_Address   => p.o_Varchar2('legal_address'),
                         i_Key_Person      => Nvl(r_Href_Detail.Key_Person, 'N'),
                         i_Extra_Phone     => p.o_Varchar2('extra_phone_number'),
                         i_Corporate_Email => p.o_Varchar2('corporate_email'),
                         i_State           => r_Person.State,
                         i_Code            => r_Person.Code,
                         i_Note            => p.o_Varchar2('note'));
  
    --employee save
    v_Employee.Person    := v_Person;
    v_Employee.Filial_Id := Ui.Filial_Id;
    v_Employee.State     := v_Person.State;
  
    Href_Api.Employee_Save(v_Employee);
  
    --htt persons_save
    Htt_Util.Person_New(o_Person     => v_Htt_Person,
                        i_Company_Id => Ui.Company_Id,
                        i_Person_Id  => v_Employee_Id,
                        i_Pin        => p.o_Varchar2('pin'),
                        i_Pin_Code   => p.o_Varchar2('pin_code'),
                        i_Rfid_Code  => p.o_Varchar2('rfid_code'),
                        i_Qr_Code    => null);
  
    for r in (select q.Photo_Sha, q.Is_Main
                from Htt_Person_Photos q
               where q.Company_Id = Ui.Company_Id
                 and q.Person_Id = v_Employee_Id)
    loop
      Htt_Util.Person_Add_Photo(p_Person    => v_Htt_Person,
                                i_Photo_Sha => r.Photo_Sha,
                                i_Is_Main   => r.Is_Main);
    end loop;
  
    if z_Htt_Persons.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                i_Person_Id  => v_Employee_Id,
                                o_Row        => r_Htt_Person) then
      v_Htt_Person.Qr_Code := r_Htt_Person.Qr_Code;
    else
      v_Htt_Person.Qr_Code := Htt_Util.Qr_Code_Gen(v_Employee_Id);
    
      if v_Htt_Person.Pin is null and Htt_Util.Pin_Autogenerate(v_Htt_Person.Company_Id) = 'Y' then
        v_Htt_Person.Pin := Htt_Core.Next_Pin(v_Htt_Person.Company_Id);
      end if;
    end if;
  
    Htt_Api.Person_Save(v_Htt_Person);
  
    -- Person Add Location
    if v_Location_Id is not null then
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id,
                                  i_Person_Id   => v_Person.Person_Id);
    end if;
  
    return v_Employee_Id;
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Person_Document_Save
  (
    i_Person_Id number,
    p           Hashmap
  ) is
    r_Document    Href_Person_Documents%rowtype;
    v_Doc_Type_Id number;
    v_Document_Id number;
  begin
    v_Document_Id := Person_Document_Id(i_Person_Id);
    v_Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => Ui.Company_Id,
                                           i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
  
    if v_Document_Id is null then
      r_Document.Company_Id  := Ui.Company_Id;
      r_Document.Document_Id := Href_Next.Person_Document_Id;
      r_Document.Is_Valid    := 'Y';
      r_Document.Status      := Href_Pref.c_Person_Document_Status_New;
    else
      r_Document := z_Href_Person_Documents.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                                      i_Document_Id => v_Document_Id);
    end if;
  
    r_Document.Person_Id   := i_Person_Id;
    r_Document.Doc_Type_Id := v_Doc_Type_Id;
    r_Document.Doc_Series  := p.o_Varchar2('passport_series');
    r_Document.Doc_Number  := p.o_Varchar2('passport_number');
    r_Document.Issued_By   := p.o_Varchar2('passport_issued_by');
    r_Document.Issued_Date := p.o_Date('passport_issued_date');
    r_Document.Begin_Date  := p.o_Date('passport_begin_date');
    r_Document.Expiry_Date := p.o_Date('passport_expiry_date');
  
    Href_Api.Person_Document_Save(r_Document);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure User_Save
  (
    i_Person_Id number,
    i_Login     varchar2
  ) is
    r_User    Md_Users%rowtype;
    r_Person  Mr_Natural_Persons%rowtype;
    v_Role_Id number;
  begin
    if g_Login_Autogenerate = 'Y' then
      g_Login_Template := Load_Template(c_Pref_Login_Template);
    
    end if;
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                          i_Person_Id  => i_Person_Id);
  
    if not z_Md_Users.Exist(i_Company_Id => Ui.Company_Id, --
                            i_User_Id    => i_Person_Id,
                            o_Row        => r_User) then
      r_User.Company_Id := r_Person.Company_Id;
      r_User.User_Id    := r_Person.Person_Id;
      r_User.Name       := r_Person.Name;
      r_User.State      := 'A';
      r_User.User_Kind  := Md_Pref.c_Uk_Normal;
      r_User.Gender     := r_Person.Gender;
    end if;
  
    if g_Login_Autogenerate = 'Y' then
      g_Login_Template := Load_Template(c_Pref_Login_Template);
      r_User.Login     := Href_Util.Default_User_Login(i_Company_Id => Ui.Company_Id,
                                                       i_Person_Id  => r_Person.Person_Id,
                                                       i_Template   => g_Login_Template);
    else
      r_User.Login := i_Login;
    end if;
  
    if r_User.Login is not null then
      r_User.Password                 := Fazo.Hash_Sha1(i_Person_Id);
      r_User.Password_Changed_On      := sysdate;
      r_User.Password_Change_Required := 'Y';
    end if;
  
    Md_Api.User_Save(r_User);
  
    if r_Person.State = 'A' then
      Md_Api.User_Add_Filial(i_Company_Id => Ui.Company_Id,
                             i_User_Id    => i_Person_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    else
      Md_Api.User_Remove_Filial(i_Company_Id   => Ui.Company_Id,
                                i_User_Id      => i_Person_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Remove_Roles => false);
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if not z_Md_User_Roles.Exist(i_Company_Id => r_Person.Company_Id,
                                 i_User_Id    => r_Person.Person_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Role_Id    => v_Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => r_Person.Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Hiring_Employee
  (
    i_Person_Id number,
    p           Hashmap
  ) is
    v_Robot_Id          number := p.o_Number('robot_id');
    v_Division_Id       number := p.o_Number('division_id');
    v_Org_Unit_Id       number := p.o_Number('org_unit_id');
    v_Job_Id            number := p.o_Number('job_id');
    v_Rank_Id           number;
    v_Wage_Scale_Id     number;
    v_Schedule_Id       number := p.o_Number('schedule_id');
    v_Oper_Type_Id      number := p.o_Varchar2('oper_type_id');
    v_Salary_Amount     number := p.o_Number('wage');
    v_Hiring_Date       date := p.o_Date('hiring_date');
    v_Journal           Hpd_Pref.Hiring_Journal_Rt;
    v_Robot             Hpd_Pref.Robot_Rt;
    v_Indicator         Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    v_Oper_Type         Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Wage_Indicator_Id number := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    r_Robot       Mrf_Robots%rowtype;
    r_Hrm_Robot   Hrm_Robots%rowtype;
    r_Hrm_Setting Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                i_Filial_Id  => Ui.Filial_Id);
  
    -------------------------------------------------- 
    Procedure Load_Wage_Scale_Salary
    (
      i_Wage_Scale_Id number,
      i_Hiring_Date   date,
      i_Rank_Id       number
    ) is
      v_Register_Id number := Hrm_Util.Closest_Register_Id(i_Company_Id    => Ui.Company_Id,
                                                           i_Filial_Id     => Ui.Filial_Id,
                                                           i_Wage_Scale_Id => i_Wage_Scale_Id,
                                                           i_Period        => i_Hiring_Date);
    begin
      select q.Indicator_Value
        into v_Salary_Amount
        from Hrm_Register_Rank_Indicators q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Register_Id = v_Register_Id
         and q.Rank_Id = i_Rank_Id
         and q.Indicator_Id = v_Wage_Indicator_Id;
    
    exception
      when No_Data_Found then
        v_Salary_Amount := p.o_Number('wage');
    end;
  begin
    if r_Hrm_Setting.Position_Enable = 'Y' then
      if v_Robot_Id is null then
        return;
      end if;
    
      r_Robot := z_Mrf_Robots.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Robot_Id   => v_Robot_Id);
    
      r_Hrm_Robot := z_Hrm_Robots.Lock_Load(i_Company_Id => r_Robot.Company_Id,
                                            i_Filial_Id  => r_Robot.Filial_Id,
                                            i_Robot_Id   => r_Robot.Robot_Id);
    
      v_Division_Id   := r_Robot.Division_Id;
      v_Job_Id        := r_Robot.Job_Id;
      v_Rank_Id       := r_Hrm_Robot.Rank_Id;
      v_Wage_Scale_Id := r_Hrm_Robot.Wage_Scale_Id;
    end if;
  
    if r_Hrm_Setting.Rank_Enable = 'Y' then
      v_Rank_Id := p.o_Number('rank_id');
    
      if r_Hrm_Setting.Wage_Scale_Enable = 'Y' then
        v_Wage_Scale_Id := p.o_Number('wage_scale_id');
      end if;
    end if;
  
    if v_Division_Id is null or v_Job_Id is null or v_Hiring_Date is null then
      return;
    end if;
  
    Hpd_Util.Hiring_Journal_New(o_Journal         => v_Journal,
                                i_Company_Id      => Ui.Company_Id,
                                i_Filial_Id       => Ui.Filial_Id,
                                i_Journal_Id      => Hpd_Next.Journal_Id,
                                i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                              i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                i_Journal_Number  => null,
                                i_Journal_Date    => v_Hiring_Date,
                                i_Journal_Name    => null);
  
    if v_Division_Id is not null and v_Job_Id is not null and v_Hiring_Date is not null then
      Hpd_Util.Robot_New(o_Robot           => v_Robot,
                         i_Robot_Id        => Coalesce(r_Robot.Robot_Id, Mrf_Next.Robot_Id),
                         i_Division_Id     => v_Division_Id,
                         i_Org_Unit_Id     => v_Org_Unit_Id,
                         i_Job_Id          => v_Job_Id,
                         i_Rank_Id         => v_Rank_Id,
                         i_Wage_Scale_Id   => v_Wage_Scale_Id,
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte_Id          => p.o_Number('fte_id'),
                         i_Fte             => null);
    
      -- wage info
      if r_Hrm_Setting.Rank_Enable = 'Y' and r_Hrm_Setting.Wage_Scale_Enable = 'Y' and
         v_Rank_Id is not null and v_Wage_Scale_Id is not null and v_Oper_Type_Id is not null then
        Load_Wage_Scale_Salary(i_Wage_Scale_Id => v_Wage_Scale_Id,
                               i_Hiring_Date   => v_Hiring_Date,
                               i_Rank_Id       => v_Rank_Id);
      end if;
    
      if v_Salary_Amount is not null and v_Oper_Type_Id is not null then
        Hpd_Util.Indicator_Add(p_Indicator       => v_Indicator,
                               i_Indicator_Id    => v_Wage_Indicator_Id,
                               i_Indicator_Value => v_Salary_Amount);
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => v_Oper_Type,
                               i_Oper_Type_Id  => v_Oper_Type_Id,
                               i_Indicator_Ids => Array_Number(v_Wage_Indicator_Id));
      end if;
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => v_Journal,
                                  i_Page_Id              => Hpd_Next.Page_Id,
                                  i_Employee_Id          => i_Person_Id,
                                  i_Staff_Number         => p.o_Number('staff_number'),
                                  i_Hiring_Date          => v_Hiring_Date,
                                  i_Trial_Period         => 0,
                                  i_Employment_Source_Id => null,
                                  i_Schedule_Id          => v_Schedule_Id,
                                  i_Vacation_Days_Limit  => null,
                                  i_Is_Booked            => 'N',
                                  i_Currency_Id          => z_Mk_Base_Currencies.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Currency_Id,
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
    v_List          Arraylist := p.r_Arraylist('items');
    v_Item          Hashmap;
    v_Employee_Id   number;
    v_Template_Goal varchar2(1) := Template_Goal;
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      v_Item        := Treat(v_List.r_Hashmap(i) as Hashmap);
      v_Employee_Id := Employee_Id(v_Item);
    
      User_Save(i_Person_Id => v_Employee_Id, i_Login => v_Item.o_Varchar2('login'));
      Person_Document_Save(v_Employee_Id, v_Item);
    
      if v_Template_Goal = c_Pref_Template_Goal_Insert then
        Hiring_Employee(v_Employee_Id, v_Item);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select w.nationality_id, 
                            w.name as nationality
                       from href_nationalities w
                      where w.company_id = :company_id
                        and w.state = :state',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'));
  
    q.Number_Field('nationality_id');
    q.Varchar2_Field('nationality');
  
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
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.rank_id, 
                            q.name as rank
                       from mhr_ranks q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('rank_id');
    q.Varchar2_Field('rank');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------               
  Function Query_Wage_Scales return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.wage_scale_id , 
                            q.name as wage_scale
                       from hrm_wage_scales q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('wage_scale_id');
    q.Varchar2_Field('wage_scale');
  
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
  Function Query_Oper_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select m.oper_type_id,
                            q.name as oper_type
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
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('oper_type');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Robots(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(3000);
    v_Params Hashmap;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'hiring_date',
                             p.r_Date('hiring_date'));
  
    v_Query := 'select p.*,
                       q.division_id,
                       q.job_id,
                       q.name as robot,
                       (select min(fte)
                          from hrm_robot_turnover rob
                         where rob.company_id = p.company_id
                           and rob.filial_id = p.filial_id
                           and rob.robot_id = p.robot_id
                           and (rob.period >= :hiring_date or
                               rob.period = (select max(rt.period)
                                             from hrm_robot_turnover rt
                                            where rt.company_id = rob.company_id
                                              and rt.filial_id = rob.filial_id
                                              and rt.robot_id = rob.robot_id
                                              and rt.period <= :hiring_date))) fte
                  from hrm_robots p
                  join mrf_robots q
                    on q.company_Id = p.company_id
                   and q.filial_Id = p.filial_id
                   and q.robot_Id = p.robot_id
                 where p.company_Id = :company_id
                   and p.filial_Id = :filial_id';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and p.org_unit_id in (select column_value from table(:division_ids))';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('robot_id', 'division_id', 'org_unit_id', 'job_id', 'rank_id', 'fte');
    q.Date_Field('opened_date', 'closed_date');
    q.Varchar2_Field('robot', 'position_employment_kind');
  
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
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null,
           State         = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null;
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
    update Hpr_Oper_Types
       set Company_Id    = null,
           Oper_Type_Id  = null,
           Oper_Group_Id = null;
    update Mpr_Oper_Types
       set Company_Id   = null,
           Oper_Type_Id = null,
           name         = null,
           State        = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null,
           State      = null;
    update Hrm_Robot_Turnover
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Period     = null,
           Planed_Fte = null;
  end;

end Ui_Vhr265;
/
