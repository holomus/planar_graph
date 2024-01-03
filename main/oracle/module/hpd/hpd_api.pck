create or replace package Hpd_Api is
  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Journal_Sign_Document
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Journal_Id  number,
    i_Document_Id number := null,
    i_Lang_Code   varchar2,
    i_Is_Draft    boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Save
  (
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Journal_Id               number,
    i_Journal_Type_Id          number,
    i_Journal_Number           varchar2,
    i_Journal_Date             date,
    i_Journal_Name             varchar2,
    i_Source_Table             varchar2 := null,
    i_Source_Id                number := null,
    i_Lang_Code                varchar2 := null,
    i_Acceptable_Journal_Types Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Repairing
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Journal_Save
  (
    i_Journal         Hpd_Pref.Hiring_Journal_Rt,
    i_Delay_Repairing boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Transfer_Journal_Save
  (
    i_Journal         Hpd_Pref.Transfer_Journal_Rt,
    i_Delay_Repairing boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Journal_Save(i_Journal Hpd_Pref.Dismissal_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Change_Journal_Save(i_Journal Hpd_Pref.Wage_Change_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Change_Journal_Save(i_Journal Hpd_Pref.Rank_Change_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Limit_Change_Journal_Save(i_Journal Hpd_Pref.Limit_Change_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Change_Journal_Save(i_Journal Hpd_Pref.Schedule_Change_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Journal_Save(i_Journal Hpd_Pref.Sick_Leave_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Journal_Save(i_Journal Hpd_Pref.Business_Trip_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Journal_Save(i_Journal Hpd_Pref.Vacation_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Journal_Save(i_Journal Hpd_Pref.Overtime_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Journal_Save(i_Journal Hpd_Pref.Timebook_Adjustment_Journal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Post
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Unpost
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null,
    i_Repost       boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Lock_Interval_Insert
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Perf_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Operation_Id  number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Interval_Kind varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Interval_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Interval_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Save(i_Contract Hpd_Pref.Cv_Contract_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Contract_Id       number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Journal_Id        number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Create_Robot_Save(i_Create_Robot Hpd_Pref.Application_Create_Robot_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Hiring_Save(i_Hiring Hpd_Pref.Application_Hiring_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Transfer_Save
  (
    i_Application_Type varchar2,
    i_Transfer         Hpd_Pref.Application_Transfer_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Dismissal_Save(i_Dismissal Hpd_Pref.Application_Dismissal_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_New
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Waiting
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Approved
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_In_Progress
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Completed
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Canceled
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Closing_Note   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Robot
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Robot_Id       number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Employee
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Employee_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Journal
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Journal_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sign_Template_Save(i_Sign_Template Hpd_Pref.Sign_Template_Rt);
end Hpd_Api;
/
create or replace package body Hpd_Api is
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
    return b.Translate('HPD:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Next_Staff_Number
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
    c_Max_Loop_Iterations constant number := 100;
    v_Current_Iteration number := 0;
  
    v_Staff_Number Href_Staffs.Staff_Number%type;
  
    --------------------------------------------------
    Function Staff_Number_Exists
    (
      i_Company_Id   number,
      i_Filial_Id    number,
      i_Staff_Number varchar2
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Href_Staffs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and Upper(q.Staff_Number) = Upper(i_Staff_Number);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    while v_Current_Iteration <= c_Max_Loop_Iterations
    loop
      v_Staff_Number := Mkr_Core.Gen_Document_Number(i_Company_Id => i_Company_Id,
                                                     i_Filial_Id  => i_Filial_Id,
                                                     i_Table      => Zt.Href_Staffs,
                                                     i_Column     => z.Staff_Number);
    
      if not Staff_Number_Exists(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Staff_Number => v_Staff_Number) then
        return v_Staff_Number;
      end if;
    
      v_Current_Iteration := v_Current_Iteration + 1;
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Create_By_Hiring
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Hiring     Hpd_Pref.Hiring_Rt,
    i_Setting    Hrm_Settings%rowtype
  ) return number is
    r_Page  Hpd_Journal_Pages%rowtype;
    r_Staff Href_Staffs%rowtype;
  begin
    r_Page := z_Hpd_Journal_Pages.Take(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Page_Id    => i_Hiring.Page_Id);
  
    if z_Hpd_Journal_Pages.Exist_Lock(i_Company_Id => i_Company_Id, --
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Page_Id    => i_Hiring.Page_Id,
                                      o_Row        => r_Page) then
      if not Fazo.Equal(r_Page.Employee_Id, i_Hiring.Employee_Id) then
        z_Href_Staffs.Update_One(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Staff_Id     => r_Page.Staff_Id,
                                 i_Staff_Number => Option_Varchar2(null));
      
        r_Staff            := null;
        r_Staff.Company_Id := i_Company_Id;
        r_Staff.Filial_Id  := i_Filial_Id;
        r_Staff.Staff_Id   := Href_Next.Staff_Id;
      else
        r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Staff_Id   => r_Page.Staff_Id);
      end if;
    else
      r_Staff            := null;
      r_Staff.Company_Id := i_Company_Id;
      r_Staff.Filial_Id  := i_Filial_Id;
      r_Staff.Staff_Id   := Href_Next.Staff_Id;
    end if;
  
    r_Staff.Staff_Number        := i_Hiring.Staff_Number;
    r_Staff.Staff_Kind          := Hpd_Util.Cast_Staff_Kind_By_Emp_Type(i_Hiring.Robot.Employment_Type);
    r_Staff.Employee_Id         := i_Hiring.Employee_Id;
    r_Staff.Hiring_Date         := i_Hiring.Hiring_Date;
    r_Staff.Dismissal_Date      := i_Hiring.Dismissal_Date;
    r_Staff.Robot_Id            := i_Hiring.Robot.Robot_Id;
    r_Staff.Division_Id         := i_Hiring.Robot.Division_Id;
    r_Staff.Job_Id              := i_Hiring.Robot.Job_Id;
    r_Staff.Org_Unit_Id         := Nvl(i_Hiring.Robot.Org_Unit_Id, i_Hiring.Robot.Division_Id);
    r_Staff.Fte                 := Nvl(i_Hiring.Robot.Fte, 1);
    r_Staff.Fte_Id              := i_Hiring.Robot.Fte_Id;
    r_Staff.Rank_Id             := i_Hiring.Robot.Rank_Id;
    r_Staff.Schedule_Id         := i_Hiring.Schedule_Id;
    r_Staff.Employment_Type     := i_Hiring.Robot.Employment_Type;
    r_Staff.Dismissal_Date      := null;
    r_Staff.Dismissal_Note      := null;
    r_Staff.Dismissal_Reason_Id := null;
    r_Staff.State               := 'P';
  
    if i_Setting.Autogen_Staff_Number = 'Y' and i_Hiring.Staff_Number is null then
      r_Staff.Staff_Number := Next_Staff_Number(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id);
    end if;
  
    z_Href_Staffs.Save_Row(r_Staff);
  
    Hpd_Core.Update_Insert_Valid_Auto_Staff(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => r_Staff.Staff_Id,
                                            i_Journal_Id => i_Journal_Id,
                                            i_Page_Id    => i_Hiring.Page_Id);
  
    return r_Staff.Staff_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Staff Href_Staffs%rowtype;
  begin
    r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.State = 'A' then
      Hpd_Error.Raise_033(Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Staff_Id   => i_Staff_Id));
    end if;
  
    z_Href_Staffs.Delete_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Staff_Id   => i_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Name
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return Hpd_Util.Journal_Type_Name(i_Company_Id      => i_Company_Id,
                                      i_Journal_Type_Id => i_Journal_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Take_Table_Translate_Record
  (
    i_Company_Id      number,
    i_Journal_Type_Id number,
    i_Lang_Code       varchar2
  ) return varchar2 is
  begin
    return z_Md_Table_Record_Translates.Take(i_Table_Name  => Zt.Hpd_Journal_Types.Name,
                                             i_Pcode       => z_Hpd_Journal_Types.Load(i_Company_Id => i_Company_Id, --
                                                              i_Journal_Type_Id => i_Journal_Type_Id).Pcode,
                                             i_Column_Name => z.Name,
                                             i_Lang_Code   => i_Lang_Code).Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Create_Sign_Document
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Journal_Type_Id  number,
    i_Journal_Number   varchar2,
    i_Journal_Date     date,
    i_Template_Id      number,
    i_Sign_Document_Id number,
    i_Lang_Code        varchar2,
    i_Is_Draft         boolean := false
  ) is
    r_Mdf_Template Mdf_Sign_Templates%rowtype;
    v_Signer_Ids   Array_Number;
    v_Title        varchar2(200);
    v_Document     Mdf_Pref.Sign_Rt;
    v_Lang_Code    varchar2(5) := Nvl(i_Lang_Code, z_Md_Companies.Load(i_Company_Id).Lang_Code);
    v_Name         varchar2(50);
  begin
    v_Name := Take_Table_Translate_Record(i_Company_Id      => i_Company_Id,
                                          i_Journal_Type_Id => i_Journal_Type_Id,
                                          i_Lang_Code       => v_Lang_Code);
  
    if v_Name is null then
      v_Name := Hpd_Util.Journal_Type_Name(i_Company_Id      => i_Company_Id,
                                           i_Journal_Type_Id => i_Journal_Type_Id);
    end if;
  
    v_Title := t('Document Flow for $1{document_type_name} №$2{journal_number} with date of $3{journal_date}',
                 v_Name,
                 i_Journal_Number,
                 i_Journal_Date);
  
    r_Mdf_Template := z_Mdf_Sign_Templates.Load(i_Company_Id  => i_Company_Id,
                                                i_Template_Id => i_Template_Id);
  
    Mdf_Util.New_Sign(o_Sign         => v_Document,
                      i_Company_Id   => r_Mdf_Template.Company_Id,
                      i_Sign_Id      => i_Sign_Document_Id,
                      i_Filial_Id    => i_Filial_Id,
                      i_Sign_Kind    => r_Mdf_Template.Sign_Kind,
                      i_Title        => v_Title,
                      i_Process_Id   => r_Mdf_Template.Process_Id,
                      i_Source_Table => Zt.Hpd_Journals.Name,
                      i_Source_Id    => i_Journal_Id,
                      i_State        => Mdf_Pref.c_Ds_Draft);
  
    for Lev in (select *
                  from Mdf_Sign_Template_Levels q
                 where q.Company_Id = r_Mdf_Template.Company_Id
                   and q.Template_Id = r_Mdf_Template.Template_Id
                 order by q.Level_No)
    loop
      Mdf_Util.Sign_Add_Level(p_Sign => v_Document, i_Sign_Kind => Lev.Sign_Kind);
    
      for Gr in (select *
                   from Mdf_Sign_Template_Groups w
                  where w.Company_Id = r_Mdf_Template.Company_Id
                    and w.Template_Id = r_Mdf_Template.Template_Id
                    and w.Level_No = Lev.Level_No
                  order by w.Group_No)
      loop
        select t.User_Id
          bulk collect
          into v_Signer_Ids
          from Mdf_Sign_Template_Users t
         where t.Company_Id = Gr.Company_Id
           and t.Template_Id = Gr.Template_Id
           and t.Level_No = Gr.Level_No
           and t.Group_No = Gr.Group_No;
      
        Mdf_Util.Sign_Add_Group(p_Level          => v_Document.Levels(Lev.Level_No),
                                i_Sign_Min_Count => Gr.Sign_Min_Count,
                                i_Signer_Ids     => v_Signer_Ids);
      end loop;
    end loop;
  
    Mdf_Api.Document_Save(v_Document);
  
    if not i_Is_Draft then
      Mdf_Api.Document_Process(i_Company_Id => i_Company_Id, i_Document_Id => v_Document.Sign_Id);
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Journal_Sign_Document
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Journal_Id  number,
    i_Document_Id number := null,
    i_Lang_Code   varchar2,
    i_Is_Draft    boolean := false
  ) is
    r_Journal     Hpd_Journals%rowtype;
    v_Template_Id number;
    v_Document_Id number;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Journal_Id => i_Journal_Id);
  
    v_Document_Id := Coalesce(r_Journal.Sign_Document_Id, i_Document_Id, Mdf_Next.Document_Id);
    v_Template_Id := Hpd_Util.Journal_Type_Sign_Template_Id(i_Company_Id      => r_Journal.Company_Id,
                                                            i_Filial_Id       => r_Journal.Filial_Id,
                                                            i_Journal_Type_Id => r_Journal.Journal_Type_Id);
  
    if v_Template_Id is null then
      Hpd_Error.Raise_088(Hpd_Util.Journal_Type_Name(i_Company_Id      => r_Journal.Company_Id,
                                                     i_Journal_Type_Id => r_Journal.Journal_Type_Id));
    end if;
  
    if r_Journal.Posted = 'Y' then
      Hpd_Error.Raise_089(r_Journal.Journal_Number);
    end if;
  
    Create_Sign_Document(i_Company_Id       => r_Journal.Company_Id,
                         i_Filial_Id        => r_Journal.Filial_Id,
                         i_Journal_Id       => r_Journal.Journal_Id,
                         i_Journal_Type_Id  => r_Journal.Journal_Type_Id,
                         i_Journal_Number   => r_Journal.Journal_Number,
                         i_Journal_Date     => r_Journal.Journal_Date,
                         i_Template_Id      => v_Template_Id,
                         i_Sign_Document_Id => v_Document_Id,
                         i_Lang_Code        => i_Lang_Code,
                         i_Is_Draft         => i_Is_Draft);
  
    z_Hpd_Journals.Update_One(i_Company_Id       => i_Company_Id,
                              i_Filial_Id        => i_Filial_Id,
                              i_Journal_Id       => i_Journal_Id,
                              i_Sign_Document_Id => Option_Number(v_Document_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Save
  (
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Journal_Id               number,
    i_Journal_Type_Id          number,
    i_Journal_Number           varchar2,
    i_Journal_Date             date,
    i_Journal_Name             varchar2,
    i_Source_Table             varchar2 := null,
    i_Source_Id                number := null,
    i_Lang_Code                varchar2 := null,
    i_Acceptable_Journal_Types Array_Varchar2
  ) is
    r_Journal         Hpd_Journals%rowtype;
    v_Type_Ids        Array_Number := Array_Number();
    v_Document_Status varchar2(1);
    v_Template_Id     number;
    v_Exists          boolean;
    v_Expected_Types  Array_Varchar2 := Array_Varchar2();
  begin
    for i in 1 .. i_Acceptable_Journal_Types.Count
    loop
      Fazo.Push(v_Type_Ids,
                Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                         i_Pcode      => i_Acceptable_Journal_Types(i)));
    end loop;
  
    if i_Journal_Type_Id not member of v_Type_Ids then
      for i in 1 .. v_Type_Ids.Count
      loop
        Fazo.Push(v_Expected_Types, Journal_Type_Name(i_Company_Id, v_Type_Ids(i)));
      end loop;
    
      Hpd_Error.Raise_034(i_Journal_Type   => Journal_Type_Name(i_Company_Id, i_Journal_Type_Id),
                          i_Expected_Types => v_Expected_Types);
    end if;
  
    if z_Hpd_Journals.Exist_Lock(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Journal_Id => i_Journal_Id,
                                 o_Row        => r_Journal) then
      if r_Journal.Posted = 'Y' then
        Hpd_Error.Raise_035(r_Journal.Journal_Number);
      end if;
    
      if r_Journal.Journal_Type_Id not member of v_Type_Ids then
        for i in 1 .. v_Type_Ids.Count
        loop
          Fazo.Push(v_Expected_Types, Journal_Type_Name(i_Company_Id, v_Type_Ids(i)));
        end loop;
      
        Hpd_Error.Raise_036(i_Journal_Type   => Journal_Type_Name(i_Company_Id, i_Journal_Type_Id),
                            i_Expected_Types => v_Expected_Types);
      end if;
    
      if r_Journal.Journal_Type_Id <> i_Journal_Type_Id then
        Hpd_Error.Raise_046(Journal_Type_Name(i_Company_Id, r_Journal.Journal_Type_Id));
      end if;
    
      if not Fazo.Equal(r_Journal.Source_Table, i_Source_Table) or
         not Fazo.Equal(r_Journal.Source_Id, i_Source_Id) then
        Hpd_Error.Raise_068(i_Jounal_Id         => r_Journal.Journal_Id,
                            i_Journal_Number    => r_Journal.Journal_Number,
                            i_Journal_Type_Name => Journal_Type_Name(i_Company_Id,
                                                                     r_Journal.Journal_Type_Id),
                            i_Source_Table      => r_Journal.Source_Table,
                            i_Source_Id         => r_Journal.Source_Id);
      end if;
    
      v_Exists := true;
    else
      r_Journal.Company_Id      := i_Company_Id;
      r_Journal.Filial_Id       := i_Filial_Id;
      r_Journal.Journal_Id      := i_Journal_Id;
      r_Journal.Journal_Type_Id := i_Journal_Type_Id;
      r_Journal.Source_Table    := i_Source_Table;
      r_Journal.Source_Id       := i_Source_Id;
    
      v_Exists := false;
    end if;
  
    r_Journal.Journal_Number := i_Journal_Number;
    r_Journal.Journal_Date   := i_Journal_Date;
    r_Journal.Journal_Name   := i_Journal_Name;
    r_Journal.Posted         := 'N';
  
    -- Save Sign Document
    v_Template_Id := Hpd_Util.Journal_Type_Sign_Template_Id(i_Company_Id      => r_Journal.Company_Id,
                                                            i_Filial_Id       => r_Journal.Filial_Id,
                                                            i_Journal_Type_Id => r_Journal.Journal_Type_Id);
  
    v_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                            i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Exists then
      if v_Document_Status is not null and v_Document_Status <> Mdf_Pref.c_Ds_Draft then
        Hpd_Error.Raise_086(i_Document_Status => Mdf_Pref.t_Document_Status(v_Document_Status),
                            i_Journal_Number  => r_Journal.Journal_Number);
      end if;
    
      z_Hpd_Journals.Update_Row(r_Journal);
    else
      if r_Journal.Journal_Number is null then
        r_Journal.Journal_Number := Md_Core.Gen_Number(i_Company_Id => r_Journal.Company_Id,
                                                       i_Filial_Id  => r_Journal.Filial_Id,
                                                       i_Table      => Zt.Hpd_Journals,
                                                       i_Column     => z.Journal_Number);
      end if;
    
      if v_Template_Id is not null then
        r_Journal.Sign_Document_Id := Mdf_Next.Document_Id;
      
        Create_Sign_Document(i_Company_Id       => r_Journal.Company_Id,
                             i_Filial_Id        => r_Journal.Filial_Id,
                             i_Journal_Id       => r_Journal.Journal_Id,
                             i_Journal_Type_Id  => r_Journal.Journal_Type_Id,
                             i_Journal_Number   => r_Journal.Journal_Number,
                             i_Journal_Date     => r_Journal.Journal_Date,
                             i_Template_Id      => v_Template_Id,
                             i_Sign_Document_Id => r_Journal.Sign_Document_Id,
                             i_Lang_Code        => i_Lang_Code);
      
      end if;
    
      z_Hpd_Journals.Insert_Row(r_Journal);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Page_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Page_Id    number,
    i_Staff_Id   number
  ) is
    v_Page        Hpd_Journal_Pages%rowtype;
    v_Employee_Id number := z_Href_Staffs.Take(i_Company_Id => i_Company_Id, --
                            i_Filial_Id => i_Filial_Id, --
                            i_Staff_Id => i_Staff_Id).Employee_Id;
  begin
    z_Hpd_Journal_Pages.Init(p_Row         => v_Page,
                             i_Company_Id  => i_Company_Id,
                             i_Filial_Id   => i_Filial_Id,
                             i_Journal_Id  => i_Journal_Id,
                             i_Page_Id     => i_Page_Id,
                             i_Staff_Id    => i_Staff_Id,
                             i_Employee_Id => v_Employee_Id);
  
    z_Hpd_Journal_Pages.Save_Row(v_Page);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Contract_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number,
    i_Contract   Hpd_Pref.Contract_Rt
  ) is
  begin
    if i_Contract.Contract_Number is null and i_Contract.Contract_Date is null and
       i_Contract.Fixed_Term is null and i_Contract.Expiry_Date is null and
       i_Contract.Fixed_Term_Base_Id is null and i_Contract.Concluding_Term is null and
       i_Contract.Hiring_Conditions is null and i_Contract.Other_Conditions is null and
       i_Contract.Workplace_Equipment is null and i_Contract.Representative_Basis is null then
      return;
    end if;
  
    z_Hpd_Page_Contracts.Save_One(i_Company_Id           => i_Company_Id,
                                  i_Filial_Id            => i_Filial_Id,
                                  i_Page_Id              => i_Page_Id,
                                  i_Contract_Number      => i_Contract.Contract_Number,
                                  i_Contract_Date        => i_Contract.Contract_Date,
                                  i_Fixed_Term           => i_Contract.Fixed_Term,
                                  i_Expiry_Date          => i_Contract.Expiry_Date,
                                  i_Fixed_Term_Base_Id   => i_Contract.Fixed_Term_Base_Id,
                                  i_Concluding_Term      => i_Contract.Concluding_Term,
                                  i_Hiring_Conditions    => i_Contract.Hiring_Conditions,
                                  i_Other_Conditions     => i_Contract.Other_Conditions,
                                  i_Workplace_Equipment  => i_Contract.Workplace_Equipment,
                                  i_Representative_Basis => i_Contract.Representative_Basis);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Page_Robot_Is_Null
  (
    i_Robot           Hpd_Pref.Robot_Rt,
    i_Position_Enable varchar2
  ) return boolean is
  begin
    if i_Position_Enable = 'N' and (i_Robot.Division_Id is null or i_Robot.Job_Id is null) and
       i_Robot.Fte_Id is null and i_Robot.Fte is null then
      return true;
    end if;
  
    if i_Robot.Robot_Id is null and i_Robot.Rank_Id is null and i_Robot.Fte_Id is null and
       i_Robot.Fte is null then
      return true;
    end if;
  
    return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Robot_Save
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Journal_Id          number,
    i_Page_Id             number,
    i_Staff_Id            number,
    i_Open_Date           date,
    i_Close_Date          date := null,
    i_Schedule_Id         number,
    i_Days_Limit          number,
    i_Currency_Id         number,
    i_Is_Booked           varchar2,
    i_Robot               Hpd_Pref.Robot_Rt,
    i_Indicators          Href_Pref.Indicator_Nt,
    i_Oper_Types          Href_Pref.Oper_Type_Nt,
    i_Settings            Hrm_Settings%rowtype,
    i_Delay_Repairing     boolean,
    i_Override_Rank_Allow boolean := true
  ) is
    v_Robot    Hpd_Pref.Robot_Rt;
    r_Robot    Mrf_Robots%rowtype;
    v_Trans_Id number;
    v_Fte      number := v_Robot.Fte;
  begin
    v_Robot := i_Robot;
  
    if i_Settings.Parttime_Enable = 'N' or v_Robot.Fte_Id is null and Nvl(v_Robot.Fte, 1) = 1 then
      v_Robot.Fte_Id := Href_Util.Fte_Id(i_Company_Id => i_Company_Id,
                                         i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time);
      v_Robot.Fte    := 1;
    end if;
  
    if i_Override_Rank_Allow or v_Robot.Rank_Id is not null then
      v_Robot.Allow_Rank := 'Y';
    end if;
  
    if i_Settings.Position_Enable = 'N' then
      if i_Settings.Wage_Scale_Enable = 'N' or -- 
         (v_Robot.Allow_Rank = 'Y' and v_Robot.Rank_Id is null) or --         
         (v_Robot.Allow_Rank = 'N' and
         Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Period     => i_Open_Date) is null) then
        v_Robot.Wage_Scale_Id := null;
      end if;
    
      Hpd_Core.Implicit_Robot_Save(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Journal_Id  => i_Journal_Id,
                                   i_Page_Id     => i_Page_Id,
                                   i_Open_Date   => i_Open_Date,
                                   i_Close_Date  => i_Close_Date,
                                   i_Schedule_Id => i_Schedule_Id,
                                   i_Days_Limit  => i_Days_Limit,
                                   i_Currency_Id => i_Currency_Id,
                                   i_Robot       => v_Robot,
                                   i_Indicators  => i_Indicators,
                                   i_Oper_Types  => i_Oper_Types);
    end if;
  
    r_Robot := z_Mrf_Robots.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Robot_Id   => v_Robot.Robot_Id);
  
    z_Hpd_Page_Robots.Save_One(i_Company_Id      => i_Company_Id,
                               i_Filial_Id       => i_Filial_Id,
                               i_Page_Id         => i_Page_Id,
                               i_Robot_Id        => v_Robot.Robot_Id,
                               i_Division_Id     => r_Robot.Division_Id,
                               i_Job_Id          => r_Robot.Job_Id,
                               i_Rank_Id         => v_Robot.Rank_Id,
                               i_Allow_Rank      => v_Robot.Allow_Rank,
                               i_Employment_Type => v_Robot.Employment_Type,
                               i_Fte_Id          => v_Robot.Fte_Id,
                               i_Fte             => v_Robot.Fte,
                               i_Is_Booked       => i_Is_Booked);
  
    -- delete all old transactions
    for r in (select *
                from Hpd_Robot_Trans_Pages q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id)
    loop
      z_Hpd_Robot_Trans_Staffs.Delete_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => r.Trans_Id);
    
      z_Hpd_Robot_Trans_Pages.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => r.Page_Id,
                                         i_Trans_Id   => r.Trans_Id);
      Hrm_Core.Robot_Transaction_Delete(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => r.Trans_Id);
    end loop;
  
    if not i_Delay_Repairing and i_Is_Booked = 'Y' and i_Settings.Position_Booking = 'Y' then
      if v_Robot.Fte_Id is not null then
        v_Fte := z_Href_Ftes.Load(i_Company_Id => i_Company_Id, i_Fte_Id => v_Robot.Fte_Id).Fte_Value;
      end if;
    
      v_Trans_Id := Hrm_Core.Robot_Occupy(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Robot_Id    => i_Robot.Robot_Id,
                                          i_Occupy_Date => i_Open_Date,
                                          i_Fte         => v_Fte,
                                          i_Is_Booked   => true,
                                          i_Tag         => i_Page_Id);
    
      z_Hpd_Robot_Trans_Pages.Insert_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => i_Page_Id,
                                         i_Trans_Id   => v_Trans_Id);
    
      z_Hpd_Robot_Trans_Staffs.Save_One(i_Company_Id     => i_Company_Id,
                                        i_Filial_Id      => i_Filial_Id,
                                        i_Robot_Trans_Id => v_Trans_Id,
                                        i_Staff_Id       => i_Staff_Id);
    
      if i_Close_Date is not null then
        v_Trans_Id := Hrm_Core.Robot_Unoccupy(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Robot_Id    => i_Robot.Robot_Id,
                                              i_Occupy_Date => i_Close_Date + 1,
                                              i_Fte         => v_Fte,
                                              i_Is_Booked   => true,
                                              i_Tag         => i_Page_Id);
      
        z_Hpd_Robot_Trans_Pages.Insert_One(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Page_Id    => i_Page_Id,
                                           i_Trans_Id   => v_Trans_Id);
      
        z_Hpd_Robot_Trans_Staffs.Save_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Robot_Trans_Id => v_Trans_Id,
                                          i_Staff_Id       => i_Staff_Id);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Schedule_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Page_Id     number,
    i_Schedule_Id number
  ) is
  begin
    if i_Schedule_Id is not null then
      z_Hpd_Page_Schedules.Save_One(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Page_Id     => i_Page_Id,
                                    i_Schedule_Id => i_Schedule_Id);
    else
      z_Hpd_Page_Schedules.Delete_One(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Page_Id    => i_Page_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Vacation_Limit_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number,
    i_Days_Limit number
  ) is
  begin
    z_Hpd_Page_Vacation_Limits.Save_One(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Page_Id    => i_Page_Id,
                                        i_Days_Limit => i_Days_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Operation_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Page_Id     number,
    i_Job_Id      number,
    i_Currency_Id number,
    i_User_Id     number,
    i_Indicators  Href_Pref.Indicator_Nt,
    i_Oper_Types  Href_Pref.Oper_Type_Nt
  ) is
    v_Oper_Type     Href_Pref.Oper_Type_Rt;
    v_Indicator     Href_Pref.Indicator_Rt;
    v_Oper_Type_Ids Array_Number;
  
    --------------------------------------------------
    Procedure Page_Currency_Save
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Page_Id     number,
      i_Currency_Id number
    ) is
      v_Allowed_Currency_Ids Array_Number := Hpr_Util.Load_Currency_Settings(i_Company_Id => i_Company_Id,
                                                                             i_Filial_Id  => i_Filial_Id);
    begin
      if i_Oper_Types.Count = 0 then
        z_Hpd_Page_Currencies.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => i_Page_Id);
        return;
      end if;
    
      if v_Allowed_Currency_Ids.Count > 0 and
         (i_Currency_Id is null or i_Currency_Id not member of v_Allowed_Currency_Ids) then
        Hpd_Error.Raise_072;
      end if;
    
      if i_Currency_Id is not null then
        z_Hpd_Page_Currencies.Save_One(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Page_Id     => i_Page_Id,
                                       i_Currency_Id => i_Currency_Id);
      end if;
    end;
  
  begin
    if z_Hpd_Journal_Pages.Lock_Load(i_Company_Id => i_Company_Id, --
     i_Filial_Id => i_Filial_Id, --
     i_Page_Id => i_Page_Id).Employee_Id <> i_User_Id and not
         Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => i_Company_Id,
                                                                               i_Filial_Id  => i_Filial_Id,
                                                                               i_Job_Id     => i_Job_Id,
                                                                               i_User_Id    => i_User_Id) then
      return;
    end if;
  
    v_Oper_Type_Ids := Array_Number();
    v_Oper_Type_Ids.Extend(i_Oper_Types.Count);
  
    for i in 1 .. i_Indicators.Count
    loop
      v_Indicator := i_Indicators(i);
    
      z_Hpd_Page_Indicators.Save_One(i_Company_Id      => i_Company_Id,
                                     i_Filial_Id       => i_Filial_Id,
                                     i_Page_Id         => i_Page_Id,
                                     i_Indicator_Id    => v_Indicator.Indicator_Id,
                                     i_Indicator_Value => v_Indicator.Indicator_Value);
    end loop;
  
    for i in 1 .. i_Oper_Types.Count
    loop
      v_Oper_Type := i_Oper_Types(i);
      v_Oper_Type_Ids(i) := v_Oper_Type.Oper_Type_Id;
    
      z_Hpd_Page_Oper_Types.Insert_Try(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Page_Id      => i_Page_Id,
                                       i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id);
    
      for j in 1 .. v_Oper_Type.Indicator_Ids.Count
      loop
        z_Hpd_Oper_Type_Indicators.Insert_Try(i_Company_Id   => i_Company_Id,
                                              i_Filial_Id    => i_Filial_Id,
                                              i_Page_Id      => i_Page_Id,
                                              i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id,
                                              i_Indicator_Id => v_Oper_Type.Indicator_Ids(j));
      end loop;
    
      for r in (select *
                  from Hpd_Oper_Type_Indicators t
                 where t.Company_Id = i_Company_Id
                   and t.Filial_Id = i_Filial_Id
                   and t.Page_Id = i_Page_Id
                   and t.Oper_Type_Id = v_Oper_Type.Oper_Type_Id
                   and t.Indicator_Id not member of v_Oper_Type.Indicator_Ids)
      loop
        z_Hpd_Oper_Type_Indicators.Delete_One(i_Company_Id   => r.Company_Id,
                                              i_Filial_Id    => r.Filial_Id,
                                              i_Page_Id      => r.Page_Id,
                                              i_Oper_Type_Id => r.Oper_Type_Id,
                                              i_Indicator_Id => r.Indicator_Id);
      end loop;
    end loop;
  
    Page_Currency_Save(i_Company_Id  => i_Company_Id,
                       i_Filial_Id   => i_Filial_Id,
                       i_Page_Id     => i_Page_Id,
                       i_Currency_Id => i_Currency_Id);
  
    for r in (select *
                from Hpd_Page_Oper_Types t
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and t.Page_Id = i_Page_Id
                 and t.Oper_Type_Id not member of v_Oper_Type_Ids)
    loop
      z_Hpd_Page_Oper_Types.Delete_One(i_Company_Id   => r.Company_Id,
                                       i_Filial_Id    => r.Filial_Id,
                                       i_Page_Id      => r.Page_Id,
                                       i_Oper_Type_Id => r.Oper_Type_Id);
    end loop;
  
    for r in (select q.Indicator_Id
                from Hpd_Page_Indicators q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Page_Id = i_Page_Id
                 and not exists (select 1
                        from Hpd_Oper_Type_Indicators w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Page_Id = q.Page_Id
                         and w.Indicator_Id = q.Indicator_Id))
    loop
      z_Hpd_Page_Indicators.Delete_One(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Page_Id      => i_Page_Id,
                                       i_Indicator_Id => r.Indicator_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Page_Remove_Vacation_Limits
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number
  ) is
  begin
    z_Hpd_Page_Vacation_Limits.Delete_One(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Page_Id    => i_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Employees_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
  begin
    -- deleting divisions from journal
    delete from Hpd_Journal_Divisions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    -- deleting employees from journal
    delete from Hpd_Journal_Employees q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    -- deleting staffs from journal
    delete from Hpd_Journal_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    -- inserting divisions into journal
    insert into Hpd_Journal_Divisions
      (Company_Id, Filial_Id, Journal_Id, Division_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Division_Id
        from Hpd_Journal_Timebook_Adjustments q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id
         and q.Division_Id is not null;
  
    -- inserting employees into journal
    insert into Hpd_Journal_Employees
      (Company_Id, Filial_Id, Journal_Id, Employee_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Employee_Id
        from Hpd_Journal_Pages q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id
       group by q.Employee_Id;
  
    insert into Hpd_Journal_Employees
      (Company_Id, Filial_Id, Journal_Id, Employee_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Employee_Id
        from Hpd_Journal_Timeoffs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id
       group by q.Employee_Id;
  
    insert into Hpd_Journal_Employees
      (Company_Id, Filial_Id, Journal_Id, Employee_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Employee_Id
        from Hpd_Journal_Overtimes q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id
       group by q.Employee_Id;
  
    -- inserting staffs into journal
    insert into Hpd_Journal_Staffs
      (Company_Id, Filial_Id, Journal_Id, Staff_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Staff_Id
        from Hpd_Journal_Pages q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id;
  
    insert into Hpd_Journal_Staffs
      (Company_Id, Filial_Id, Journal_Id, Staff_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Staff_Id
        from Hpd_Journal_Timeoffs q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id;
  
    insert into Hpd_Journal_Staffs
      (Company_Id, Filial_Id, Journal_Id, Staff_Id)
      select i_Company_Id, i_Filial_Id, i_Journal_Id, q.Staff_Id
        from Hpd_Journal_Overtimes q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unnecessary_Pages_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Page_Ids   Array_Number
  ) is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Journal_Id => i_Journal_Id);
  
    if Hpd_Util.Is_Contractor_Journal(i_Company_Id      => r_Journal.Company_Id,
                                      i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hpd_Core.Hiring_Cv_Contract_Delete(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Journal_Id => i_Journal_Id,
                                         i_Page_Ids   => i_Page_Ids);
    end if;
  
    for r in (select t.Page_Id, p.Trans_Id
                from Hpd_Journal_Pages t
                left join Hpd_Robot_Trans_Pages p
                  on p.Company_Id = t.Company_Id
                 and p.Filial_Id = t.Filial_Id
                 and p.Page_Id = t.Page_Id
               where t.Company_Id = i_Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and t.Journal_Id = i_Journal_Id
                 and t.Page_Id not member of i_Page_Ids)
    loop
      if r.Trans_Id is not null then
        z_Hpd_Robot_Trans_Staffs.Delete_One(i_Company_Id     => i_Company_Id,
                                            i_Filial_Id      => i_Filial_Id,
                                            i_Robot_Trans_Id => r.Trans_Id);
      
        z_Hpd_Robot_Trans_Pages.Delete_One(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Page_Id    => r.Page_Id,
                                           i_Trans_Id   => r.Trans_Id);
      
        Hrm_Core.Robot_Transaction_Delete(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Trans_Id   => r.Trans_Id);
      end if;
    
      z_Hpd_Journal_Pages.Delete_One(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Page_Id    => r.Page_Id);
    end loop;
  
    Journal_Employees_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Journal_Id => i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Staffs_Invalid
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
  begin
    insert into Hpd_Auto_Created_Staffs p
      (p.Company_Id, p.Filial_Id, p.Staff_Id, p.Journal_Id, p.Page_Id, p.Valid)
      select q.Company_Id, q.Filial_Id, q.Staff_Id, q.Journal_Id, q.Page_Id, 'N'
        from Hpd_Journal_Pages q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Journal_Id = i_Journal_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Auto_Robots_Invalid
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'Y' then
      return;
    end if;
  
    insert into Hpd_Auto_Created_Robots p
      (p.Company_Id, p.Filial_Id, p.Robot_Id, p.Journal_Id, p.Page_Id, p.Valid)
      select i_Company_Id, i_Filial_Id, q.Robot_Id, i_Journal_Id, q.Page_Id, 'N'
        from Hpd_Page_Robots q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and exists (select *
                from Hpd_Journal_Pages Jp
               where Jp.Company_Id = q.Company_Id
                 and Jp.Filial_Id = q.Filial_Id
                 and Jp.Page_Id = q.Page_Id
                 and Jp.Journal_Id = i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Unnecessary_Staffs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
    v_Linked_Journal_Id number;
  
    --------------------------------------------------
    Function Staff_Linked_Other_Journal(i_Staff_Id number) return number is
      result number;
    begin
      select q.Journal_Id
        into result
        from Hpd_Journal_Pages q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Journal_Id != i_Journal_Id
         and Rownum = 1;
    
      return result;
    exception
      when No_Data_Found then
        return result;
    end;
  begin
    for r in (select *
                from Hpd_Auto_Created_Staffs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Journal_Id = i_Journal_Id
                 and q.Valid = 'N')
    loop
      v_Linked_Journal_Id := Staff_Linked_Other_Journal(r.Staff_Id);
    
      if v_Linked_Journal_Id is not null then
        Hpd_Error.Raise_037(i_Staff_Name     => Href_Util.Staff_Name(i_Company_Id => r.Company_Id,
                                                                     i_Filial_Id  => r.Filial_Id,
                                                                     i_Staff_Id   => r.Staff_Id),
                            i_Journal_Number => z_Hpd_Journals.Load(i_Company_Id => i_Company_Id, --
                                                i_Filial_Id => i_Filial_Id, --
                                                i_Journal_Id => v_Linked_Journal_Id).Journal_Number);
      end if;
    
      Staff_Delete(i_Company_Id => i_Company_Id,
                   i_Filial_Id  => i_Filial_Id,
                   i_Staff_Id   => r.Staff_Id);
    end loop;
  
    delete Hpd_Auto_Created_Staffs;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Repairing
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) is
  begin
    Delete_Unnecessary_Staffs(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Journal_Id => i_Journal_Id);
  
    Hpd_Core.Delete_Unnecessary_Robots(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Journal_Id => i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Journal_Save
  (
    i_Journal         Hpd_Pref.Hiring_Journal_Rt,
    i_Delay_Repairing boolean
  ) is
    v_Staff_Id           number;
    r_Setting            Hrm_Settings%rowtype;
    v_Hiring             Hpd_Pref.Hiring_Rt;
    v_Page_Ids           Array_Number;
    v_User_Id            number;
    v_Contractor_Type_Id number;
    v_Postion_Booking    varchar2(1) := Hrm_Util.Load_Setting(i_Company_Id => i_Journal.Company_Id, --
                                        i_Filial_Id => i_Journal.Filial_Id).Position_Booking;
  begin
    v_Contractor_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                     i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor);
  
    Hpd_Util.Assert_Singular_Journal(i_Company_Id       => i_Journal.Company_Id,
                                     i_Filial_Id        => i_Journal.Filial_Id,
                                     i_Journal_Id       => i_Journal.Journal_Id,
                                     i_Page_Id          => case
                                                             when i_Journal.Hirings.Count = 0 then
                                                              null
                                                             else
                                                              i_Journal.Hirings(1).Page_Id
                                                           end,
                                     i_Journal_Type_Id  => i_Journal.Journal_Type_Id,
                                     i_Singular_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                     i_Pages_Cnt        => i_Journal.Hirings.Count);
  
    Hpd_Util.Assert_Singular_Journal(i_Company_Id       => i_Journal.Company_Id,
                                     i_Filial_Id        => i_Journal.Filial_Id,
                                     i_Journal_Id       => i_Journal.Journal_Id,
                                     i_Page_Id          => case
                                                             when i_Journal.Hirings.Count = 0 then
                                                              null
                                                             else
                                                              i_Journal.Hirings(1).Page_Id
                                                           end,
                                     i_Journal_Type_Id  => i_Journal.Journal_Type_Id,
                                     i_Singular_Type_Id => v_Contractor_Type_Id,
                                     i_Pages_Cnt        => i_Journal.Hirings.Count);
  
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor));
  
    -- temporarily done to avoid taking user_id as a param
    v_User_Id := z_Hpd_Journals.Load(i_Company_Id => i_Journal.Company_Id, i_Filial_Id => i_Journal.Filial_Id, i_Journal_Id => i_Journal.Journal_Id).Modified_By;
  
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Journal.Company_Id,
                                       i_Filial_Id  => i_Journal.Filial_Id);
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Hirings.Count);
  
    Hiring_Staffs_Invalid(i_Company_Id => i_Journal.Company_Id,
                          i_Filial_Id  => i_Journal.Filial_Id,
                          i_Journal_Id => i_Journal.Journal_Id);
  
    Auto_Robots_Invalid(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id);
  
    for i in 1 .. i_Journal.Hirings.Count
    loop
      v_Hiring := i_Journal.Hirings(i);
    
      v_Page_Ids(i) := v_Hiring.Page_Id;
    
      v_Staff_Id := Staff_Create_By_Hiring(i_Company_Id => i_Journal.Company_Id,
                                           i_Filial_Id  => i_Journal.Filial_Id,
                                           i_Journal_Id => i_Journal.Journal_Id,
                                           i_Hiring     => v_Hiring,
                                           i_Setting    => r_Setting);
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Hiring.Page_Id,
                        i_Staff_Id   => v_Staff_Id);
    
      if v_Contractor_Type_Id = i_Journal.Journal_Type_Id and v_Hiring.Dismissal_Date is null then
        Hpd_Error.Raise_081;
      end if;
    
      z_Hpd_Hirings.Save_One(i_Company_Id           => i_Journal.Company_Id,
                             i_Filial_Id            => i_Journal.Filial_Id,
                             i_Page_Id              => v_Hiring.Page_Id,
                             i_Staff_Id             => v_Staff_Id,
                             i_Hiring_Date          => v_Hiring.Hiring_Date,
                             i_Dismissal_Date       => v_Hiring.Dismissal_Date,
                             i_Trial_Period         => v_Hiring.Trial_Period,
                             i_Employment_Source_Id => v_Hiring.Employment_Source_Id);
    
      Page_Robot_Save(i_Company_Id      => i_Journal.Company_Id,
                      i_Filial_Id       => i_Journal.Filial_Id,
                      i_Journal_Id      => i_Journal.Journal_Id,
                      i_Page_Id         => v_Hiring.Page_Id,
                      i_Staff_Id        => v_Staff_Id,
                      i_Open_Date       => v_Hiring.Hiring_Date,
                      i_Schedule_Id     => v_Hiring.Schedule_Id,
                      i_Days_Limit      => v_Hiring.Vacation_Days_Limit,
                      i_Currency_Id     => v_Hiring.Currency_Id,
                      i_Is_Booked       => v_Hiring.Is_Booked,
                      i_Robot           => v_Hiring.Robot,
                      i_Indicators      => v_Hiring.Indicators,
                      i_Oper_Types      => v_Hiring.Oper_Types,
                      i_Settings        => r_Setting,
                      i_Delay_Repairing => i_Delay_Repairing);
    
      Page_Schedule_Save(i_Company_Id  => i_Journal.Company_Id,
                         i_Filial_Id   => i_Journal.Filial_Id,
                         i_Page_Id     => v_Hiring.Page_Id,
                         i_Schedule_Id => v_Hiring.Schedule_Id);
    
      if i_Journal.Journal_Type_Id <> v_Contractor_Type_Id then
        if v_Hiring.Vacation_Days_Limit is not null then
          Page_Vacation_Limit_Save(i_Company_Id => i_Journal.Company_Id,
                                   i_Filial_Id  => i_Journal.Filial_Id,
                                   i_Page_Id    => v_Hiring.Page_Id,
                                   i_Days_Limit => v_Hiring.Vacation_Days_Limit);
        else
          Page_Remove_Vacation_Limits(i_Company_Id => i_Journal.Company_Id,
                                      i_Filial_Id  => i_Journal.Filial_Id,
                                      i_Page_Id    => v_Hiring.Page_Id);
        end if;
      
        Page_Contract_Save(i_Company_Id => i_Journal.Company_Id,
                           i_Filial_Id  => i_Journal.Filial_Id,
                           i_Page_Id    => v_Hiring.Page_Id,
                           i_Contract   => v_Hiring.Contract);
      else
        Cv_Contract_Save(v_Hiring.Cv_Contract);
      end if;
    
      Page_Operation_Save(i_Company_Id  => i_Journal.Company_Id,
                          i_Filial_Id   => i_Journal.Filial_Id,
                          i_Page_Id     => v_Hiring.Page_Id,
                          i_Job_Id      => v_Hiring.Robot.Job_Id,
                          i_Currency_Id => v_Hiring.Currency_Id,
                          i_User_Id     => v_User_Id,
                          i_Indicators  => v_Hiring.Indicators,
                          i_Oper_Types  => v_Hiring.Oper_Types);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  
    if not i_Delay_Repairing then
      Journal_Repairing(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id);
    end if;
  
    if v_Postion_Booking = 'Y' then
      Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Journal.Company_Id,
                                   i_Filial_Id  => i_Journal.Filial_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transfer_Journal_Save
  (
    i_Journal         Hpd_Pref.Transfer_Journal_Rt,
    i_Delay_Repairing boolean
  ) is
    r_Setting         Hrm_Settings%rowtype;
    r_Staff           Href_Staffs%rowtype;
    v_Transfer        Hpd_Pref.Transfer_Rt;
    v_Page_Ids        Array_Number;
    v_Job_Id          number;
    v_User_Id         number;
    v_Postion_Booking varchar2(1) := Hrm_Util.Load_Setting(i_Company_Id => i_Journal.Company_Id, --
                                     i_Filial_Id => i_Journal.Filial_Id).Position_Booking;
  begin
    Hpd_Util.Assert_Singular_Journal(i_Company_Id       => i_Journal.Company_Id,
                                     i_Filial_Id        => i_Journal.Filial_Id,
                                     i_Journal_Id       => i_Journal.Journal_Id,
                                     i_Page_Id          => case
                                                             when i_Journal.Transfers.Count = 0 then
                                                              null
                                                             else
                                                              i_Journal.Transfers(1).Page_Id
                                                           end,
                                     i_Journal_Type_Id  => i_Journal.Journal_Type_Id,
                                     i_Singular_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                     i_Pages_Cnt        => i_Journal.Transfers.Count);
  
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple));
  
    -- temporarily done to avoid taking user_id as a param
    v_User_Id := z_Hpd_Journals.Load(i_Company_Id => i_Journal.Company_Id, i_Filial_Id => i_Journal.Filial_Id, i_Journal_Id => i_Journal.Journal_Id).Modified_By;
  
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Journal.Company_Id,
                                       i_Filial_Id  => i_Journal.Filial_Id);
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Transfers.Count);
  
    Auto_Robots_Invalid(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id);
  
    for i in 1 .. i_Journal.Transfers.Count
    loop
      v_Transfer := i_Journal.Transfers(i);
      v_Page_Ids(i) := v_Transfer.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Transfer.Page_Id,
                        i_Staff_Id   => v_Transfer.Staff_Id);
    
      z_Hpd_Transfers.Save_One(i_Company_Id      => i_Journal.Company_Id,
                               i_Filial_Id       => i_Journal.Filial_Id,
                               i_Page_Id         => v_Transfer.Page_Id,
                               i_Transfer_Begin  => v_Transfer.Transfer_Begin,
                               i_Transfer_End    => v_Transfer.Transfer_End,
                               i_Transfer_Reason => v_Transfer.Transfer_Reason,
                               i_Transfer_Base   => v_Transfer.Transfer_Base);
    
      Page_Contract_Save(i_Company_Id => i_Journal.Company_Id,
                         i_Filial_Id  => i_Journal.Filial_Id,
                         i_Page_Id    => v_Transfer.Page_Id,
                         i_Contract   => v_Transfer.Contract);
    
      if not Page_Robot_Is_Null(v_Transfer.Robot, r_Setting.Position_Enable) then
        if v_Transfer.Robot.Employment_Type = Hpd_Pref.c_Employment_Type_Contractor then
          Hpd_Error.Raise_082(Href_Util.Staff_Name(i_Company_Id => i_Journal.Company_Id,
                                                   i_Filial_Id  => i_Journal.Filial_Id,
                                                   i_Staff_Id   => v_Transfer.Staff_Id));
        end if;
      
        r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Journal.Company_Id,
                                      i_Filial_Id  => i_Journal.Filial_Id,
                                      i_Staff_Id   => v_Transfer.Staff_Id);
      
        if r_Staff.Employment_Type = Hpd_Pref.c_Employment_Type_Contractor then
          Hpd_Error.Raise_083(Href_Util.Staff_Name(i_Company_Id => i_Journal.Company_Id,
                                                   i_Filial_Id  => i_Journal.Filial_Id,
                                                   i_Staff_Id   => v_Transfer.Staff_Id));
        end if;
      
        Page_Robot_Save(i_Company_Id          => i_Journal.Company_Id,
                        i_Filial_Id           => i_Journal.Filial_Id,
                        i_Journal_Id          => i_Journal.Journal_Id,
                        i_Page_Id             => v_Transfer.Page_Id,
                        i_Staff_Id            => v_Transfer.Staff_Id,
                        i_Open_Date           => v_Transfer.Transfer_Begin,
                        i_Close_Date          => v_Transfer.Transfer_End,
                        i_Schedule_Id         => v_Transfer.Schedule_Id,
                        i_Days_Limit          => v_Transfer.Vacation_Days_Limit,
                        i_Currency_Id         => v_Transfer.Currency_Id,
                        i_Is_Booked           => v_Transfer.Is_Booked,
                        i_Robot               => v_Transfer.Robot,
                        i_Indicators          => v_Transfer.Indicators,
                        i_Oper_Types          => v_Transfer.Oper_Types,
                        i_Settings            => r_Setting,
                        i_Delay_Repairing     => i_Delay_Repairing,
                        i_Override_Rank_Allow => false);
      
        v_Job_Id := v_Transfer.Robot.Job_Id;
      else
        v_Job_Id := Hpd_Util.Get_Closest_Job_Id(i_Company_Id => i_Journal.Company_Id,
                                                i_Filial_Id  => i_Journal.Filial_Id,
                                                i_Staff_Id   => v_Transfer.Staff_Id,
                                                i_Period     => v_Transfer.Transfer_Begin);
      end if;
    
      Page_Schedule_Save(i_Company_Id  => i_Journal.Company_Id,
                         i_Filial_Id   => i_Journal.Filial_Id,
                         i_Page_Id     => v_Transfer.Page_Id,
                         i_Schedule_Id => v_Transfer.Schedule_Id);
    
      if v_Transfer.Vacation_Days_Limit is not null then
        Page_Vacation_Limit_Save(i_Company_Id => i_Journal.Company_Id,
                                 i_Filial_Id  => i_Journal.Filial_Id,
                                 i_Page_Id    => v_Transfer.Page_Id,
                                 i_Days_Limit => v_Transfer.Vacation_Days_Limit);
      else
        Page_Remove_Vacation_Limits(i_Company_Id => i_Journal.Company_Id,
                                    i_Filial_Id  => i_Journal.Filial_Id,
                                    i_Page_Id    => v_Transfer.Page_Id);
      end if;
    
      Page_Operation_Save(i_Company_Id  => i_Journal.Company_Id,
                          i_Filial_Id   => i_Journal.Filial_Id,
                          i_Page_Id     => v_Transfer.Page_Id,
                          i_Job_Id      => v_Job_Id,
                          i_Currency_Id => v_Transfer.Currency_Id,
                          i_User_Id     => v_User_Id,
                          i_Indicators  => v_Transfer.Indicators,
                          i_Oper_Types  => v_Transfer.Oper_Types);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  
    if not i_Delay_Repairing then
      Journal_Repairing(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id);
    end if;
  
    if v_Postion_Booking = 'Y' then
      Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Journal.Company_Id,
                                   i_Filial_Id  => i_Journal.Filial_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Journal_Save(i_Journal Hpd_Pref.Dismissal_Journal_Rt) is
    v_Dismissal Hpd_Pref.Dismissal_Rt;
    v_Page_Ids  Array_Number;
  begin
    Hpd_Util.Assert_Singular_Journal(i_Company_Id       => i_Journal.Company_Id,
                                     i_Filial_Id        => i_Journal.Filial_Id,
                                     i_Journal_Id       => i_Journal.Journal_Id,
                                     i_Page_Id          => case
                                                             when i_Journal.Dismissals.Count = 0 then
                                                              null
                                                             else
                                                              i_Journal.Dismissals(1).Page_Id
                                                           end,
                                     i_Journal_Type_Id  => i_Journal.Journal_Type_Id,
                                     i_Singular_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                                    i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                     i_Pages_Cnt        => i_Journal.Dismissals.Count);
  
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple));
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Dismissals.Count);
  
    for i in 1 .. i_Journal.Dismissals.Count
    loop
      v_Dismissal := i_Journal.Dismissals(i);
      v_Page_Ids(i) := v_Dismissal.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Dismissal.Page_Id,
                        i_Staff_Id   => v_Dismissal.Staff_Id);
    
      z_Hpd_Dismissals.Save_One(i_Company_Id           => i_Journal.Company_Id,
                                i_Filial_Id            => i_Journal.Filial_Id,
                                i_Page_Id              => v_Dismissal.Page_Id,
                                i_Dismissal_Date       => v_Dismissal.Dismissal_Date,
                                i_Dismissal_Reason_Id  => v_Dismissal.Dismissal_Reason_Id,
                                i_Employment_Source_Id => v_Dismissal.Employment_Source_Id,
                                i_Based_On_Doc         => v_Dismissal.Based_On_Doc,
                                i_Note                 => v_Dismissal.Note);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Change_Journal_Save(i_Journal Hpd_Pref.Wage_Change_Journal_Rt) is
    v_Wage_Change Hpd_Pref.Wage_Change_Rt;
    v_Page_Ids    Array_Number;
    v_User_Id     number;
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple));
  
    -- temporarily done to avoid taking user_id as a param
    v_User_Id := z_Hpd_Journals.Load(i_Company_Id => i_Journal.Company_Id, i_Filial_Id => i_Journal.Filial_Id, i_Journal_Id => i_Journal.Journal_Id).Modified_By;
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Wage_Changes.Count);
  
    for i in 1 .. i_Journal.Wage_Changes.Count
    loop
      v_Wage_Change := i_Journal.Wage_Changes(i);
      v_Page_Ids(i) := v_Wage_Change.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Wage_Change.Page_Id,
                        i_Staff_Id   => v_Wage_Change.Staff_Id);
    
      z_Hpd_Wage_Changes.Save_One(i_Company_Id  => i_Journal.Company_Id,
                                  i_Filial_Id   => i_Journal.Filial_Id,
                                  i_Page_Id     => v_Wage_Change.Page_Id,
                                  i_Change_Date => v_Wage_Change.Change_Date);
    
      Page_Operation_Save(i_Company_Id  => i_Journal.Company_Id,
                          i_Filial_Id   => i_Journal.Filial_Id,
                          i_Page_Id     => v_Wage_Change.Page_Id,
                          i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => i_Journal.Company_Id,
                                                                       i_Filial_Id  => i_Journal.Filial_Id,
                                                                       i_Staff_Id   => v_Wage_Change.Staff_Id,
                                                                       i_Period     => v_Wage_Change.Change_Date),
                          i_Currency_Id => v_Wage_Change.Currency_Id,
                          i_User_Id     => v_User_Id,
                          i_Indicators  => v_Wage_Change.Indicators,
                          i_Oper_Types  => v_Wage_Change.Oper_Types);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Change_Journal_Save(i_Journal Hpd_Pref.Rank_Change_Journal_Rt) is
    v_Rank_Change Hpd_Pref.Rank_Change_Rt;
    v_Page_Ids    Array_Number;
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Source_Table             => i_Journal.Source_Table,
                 i_Source_Id                => i_Journal.Source_Id,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Rank_Change,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple));
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Rank_Changes.Count);
  
    for i in 1 .. i_Journal.Rank_Changes.Count
    loop
      v_Rank_Change := i_Journal.Rank_Changes(i);
      v_Page_Ids(i) := v_Rank_Change.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Rank_Change.Page_Id,
                        i_Staff_Id   => v_Rank_Change.Staff_Id);
    
      z_Hpd_Rank_Changes.Save_One(i_Company_Id  => i_Journal.Company_Id,
                                  i_Filial_Id   => i_Journal.Filial_Id,
                                  i_Page_Id     => v_Rank_Change.Page_Id,
                                  i_Change_Date => v_Rank_Change.Change_Date,
                                  i_Rank_Id     => v_Rank_Change.Rank_Id);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Limit_Change_Journal_Save(i_Journal Hpd_Pref.Limit_Change_Journal_Rt) is
    r_Limit_Change Hpd_Vacation_Limit_Changes%rowtype;
    v_Page         Hpd_Pref.Page_Rt;
    v_Page_Ids     Array_Number;
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Limit_Change),
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Limit_Change));
  
    r_Limit_Change.Company_Id  := i_Journal.Company_Id;
    r_Limit_Change.Filial_Id   := i_Journal.Filial_Id;
    r_Limit_Change.Journal_Id  := i_Journal.Journal_Id;
    r_Limit_Change.Division_Id := i_Journal.Division_Id;
    r_Limit_Change.Days_Limit  := i_Journal.Days_Limit;
    r_Limit_Change.Change_Date := i_Journal.Change_Date;
  
    z_Hpd_Vacation_Limit_Changes.Save_Row(r_Limit_Change);
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Pages.Count);
  
    for i in 1 .. i_Journal.Pages.Count
    loop
      v_Page := i_Journal.Pages(i);
      v_Page_Ids(i) := v_Page.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Page.Page_Id,
                        i_Staff_Id   => v_Page.Staff_Id);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Change_Journal_Save(i_Journal Hpd_Pref.Schedule_Change_Journal_Rt) is
    r_Schedule_Change Hpd_Schedule_Changes%rowtype;
    v_Schedule_Change Hpd_Pref.Schedule_Change_Rt;
    v_Page_Ids        Array_Number;
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change),
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change));
  
    r_Schedule_Change.Company_Id  := i_Journal.Company_Id;
    r_Schedule_Change.Filial_Id   := i_Journal.Filial_Id;
    r_Schedule_Change.Journal_Id  := i_Journal.Journal_Id;
    r_Schedule_Change.Division_Id := i_Journal.Division_Id;
    r_Schedule_Change.Begin_Date  := i_Journal.Begin_Date;
    r_Schedule_Change.End_Date    := i_Journal.End_Date;
  
    z_Hpd_Schedule_Changes.Save_Row(r_Schedule_Change);
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Schedule_Changes.Count);
  
    for i in 1 .. i_Journal.Schedule_Changes.Count
    loop
      v_Schedule_Change := i_Journal.Schedule_Changes(i);
      v_Page_Ids(i) := v_Schedule_Change.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Schedule_Change.Page_Id,
                        i_Staff_Id   => v_Schedule_Change.Staff_Id);
    
      if v_Schedule_Change.Schedule_Id is null then
        Hpd_Error.Raise_049(Href_Util.Staff_Name(i_Company_Id => i_Journal.Company_Id,
                                                 i_Filial_Id  => i_Journal.Filial_Id,
                                                 i_Staff_Id   => v_Schedule_Change.Staff_Id));
      end if;
    
      Page_Schedule_Save(i_Company_Id  => i_Journal.Company_Id,
                         i_Filial_Id   => i_Journal.Filial_Id,
                         i_Page_Id     => v_Schedule_Change.Page_Id,
                         i_Schedule_Id => v_Schedule_Change.Schedule_Id);
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  -- timeoff
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Timeoff_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Timeoff_Id number,
    i_Journal_Id number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Shas       Array_Varchar2
  ) is
    r_Timeoff Hpd_Journal_Timeoffs%rowtype;
    v_Exists  boolean := false;
  begin
    if z_Hpd_Journal_Timeoffs.Exist_Lock(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Timeoff_Id => i_Timeoff_Id,
                                         o_Row        => r_Timeoff) then
      if r_Timeoff.Journal_Id <> i_Journal_Id then
        Hpd_Error.Raise_032(i_Timeoff_Id => i_Timeoff_Id, i_Journal_Id => r_Timeoff.Journal_Id);
      end if;
    
      v_Exists := true;
    end if;
  
    r_Timeoff.Employee_Id := z_Href_Staffs.Load(i_Company_Id => i_Company_Id, --
                             i_Filial_Id => i_Filial_Id, --
                             i_Staff_Id => i_Staff_Id).Employee_Id;
    r_Timeoff.Staff_Id    := i_Staff_Id;
    r_Timeoff.Begin_Date  := i_Begin_Date;
    r_Timeoff.End_Date    := i_End_Date;
  
    if v_Exists then
      z_Hpd_Journal_Timeoffs.Update_Row(r_Timeoff);
    
      delete Hpd_Timeoff_Files q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Timeoff_Id = i_Timeoff_Id
         and q.Sha not member of i_Shas;
    else
      r_Timeoff.Company_Id := i_Company_Id;
      r_Timeoff.Filial_Id  := i_Filial_Id;
      r_Timeoff.Timeoff_Id := i_Timeoff_Id;
      r_Timeoff.Journal_Id := i_Journal_Id;
    
      z_Hpd_Journal_Timeoffs.Insert_Row(r_Timeoff);
    end if;
  
    for i in 1 .. i_Shas.Count
    loop
      z_Hpd_Timeoff_Files.Insert_Try(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Timeoff_Id => i_Timeoff_Id,
                                     i_Sha        => i_Shas(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unnecessary_Timeoffs_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Journal_Id  number,
    i_Timeoff_Ids Array_Number
  ) is
  begin
    delete Hpd_Journal_Timeoffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id
       and q.Timeoff_Id not member of i_Timeoff_Ids;
  
    Journal_Employees_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Journal_Id => i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  -- overtime
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Overtime_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Overtime_Id number,
    i_Journal_Id  number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
    r_Overtime Hpd_Journal_Overtimes%rowtype;
    v_Exists   boolean := false;
  begin
    if z_Hpd_Journal_Overtimes.Exist_Lock(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Overtime_Id => i_Overtime_Id,
                                          o_Row         => r_Overtime) then
      if r_Overtime.Journal_Id <> i_Journal_Id then
        Hpd_Error.Raise_042(i_Overtime_Id => i_Overtime_Id, i_Journal_Id => i_Journal_Id);
      end if;
    
      v_Exists := true;
    end if;
  
    r_Overtime.Employee_Id := z_Href_Staffs.Load(i_Company_Id => i_Company_Id, --
                              i_Filial_Id => i_Filial_Id, --
                              i_Staff_Id => i_Staff_Id).Employee_Id;
    r_Overtime.Staff_Id    := i_Staff_Id;
    r_Overtime.Begin_Date  := i_Begin_Date;
    r_Overtime.End_Date    := i_End_Date;
  
    if v_Exists then
      z_Hpd_Journal_Overtimes.Update_Row(r_Overtime);
    else
      r_Overtime.Company_Id  := i_Company_Id;
      r_Overtime.Filial_Id   := i_Filial_Id;
      r_Overtime.Overtime_Id := i_Overtime_Id;
      r_Overtime.Journal_Id  := i_Journal_Id;
    
      z_Hpd_Journal_Overtimes.Insert_Row(r_Overtime);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unnecessary_Overtimes_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Overtime_Ids Array_Number
  ) is
  begin
    delete Hpd_Journal_Overtimes q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id
       and q.Overtime_Id not member of i_Overtime_Ids;
  
    Journal_Employees_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Journal_Id => i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Journal_Save(i_Journal Hpd_Pref.Sick_Leave_Journal_Rt) is
    v_Sick_Leave  Hpd_Pref.Sick_Leave_Rt;
    v_Timeoff_Ids Array_Number := Array_Number();
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple));
  
    for i in 1 .. i_Journal.Sick_Leaves.Count
    loop
      v_Sick_Leave := i_Journal.Sick_Leaves(i);
    
      Journal_Timeoff_Save(i_Company_Id => i_Journal.Company_Id,
                           i_Filial_Id  => i_Journal.Filial_Id,
                           i_Journal_Id => i_Journal.Journal_Id,
                           i_Timeoff_Id => v_Sick_Leave.Timeoff_Id,
                           i_Staff_Id   => v_Sick_Leave.Staff_Id,
                           i_Begin_Date => v_Sick_Leave.Begin_Date,
                           i_End_Date   => v_Sick_Leave.End_Date,
                           i_Shas       => v_Sick_Leave.Shas);
    
      z_Hpd_Sick_Leaves.Save_One(i_Company_Id        => i_Journal.Company_Id,
                                 i_Filial_Id         => i_Journal.Filial_Id,
                                 i_Timeoff_Id        => v_Sick_Leave.Timeoff_Id,
                                 i_Reason_Id         => v_Sick_Leave.Reason_Id,
                                 i_Coefficient       => v_Sick_Leave.Coefficient,
                                 i_Sick_Leave_Number => v_Sick_Leave.Sick_Leave_Number);
    
      Fazo.Push(v_Timeoff_Ids, v_Sick_Leave.Timeoff_Id);
    end loop;
  
    Unnecessary_Timeoffs_Delete(i_Company_Id  => i_Journal.Company_Id,
                                i_Filial_Id   => i_Journal.Filial_Id,
                                i_Journal_Id  => i_Journal.Journal_Id,
                                i_Timeoff_Ids => v_Timeoff_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Journal_Save(i_Journal Hpd_Pref.Business_Trip_Journal_Rt) is
    v_Trip        Hpd_Pref.Business_Trip_Rt;
    v_Timeoff_Ids Array_Number := Array_Number();
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Business_Trip,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Business_Trip_Multiple));
  
    for i in 1 .. i_Journal.Business_Trips.Count
    loop
      v_Trip := i_Journal.Business_Trips(i);
    
      Journal_Timeoff_Save(i_Company_Id => i_Journal.Company_Id,
                           i_Filial_Id  => i_Journal.Filial_Id,
                           i_Journal_Id => i_Journal.Journal_Id,
                           i_Timeoff_Id => v_Trip.Timeoff_Id,
                           i_Staff_Id   => v_Trip.Staff_Id,
                           i_Begin_Date => v_Trip.Begin_Date,
                           i_End_Date   => v_Trip.End_Date,
                           i_Shas       => v_Trip.Shas);
    
      z_Hpd_Business_Trips.Save_One(i_Company_Id => i_Journal.Company_Id,
                                    i_Filial_Id  => i_Journal.Filial_Id,
                                    i_Timeoff_Id => v_Trip.Timeoff_Id,
                                    i_Person_Id  => v_Trip.Person_Id,
                                    i_Reason_Id  => v_Trip.Reason_Id,
                                    i_Note       => v_Trip.Note);
    
      if v_Trip.Region_Ids.Count = 0 then
        Hpd_Error.Raise_077;
      end if;
    
      delete from Hpd_Business_Trip_Regions q
       where q.Company_Id = i_Journal.Company_Id
         and q.Filial_Id = i_Journal.Filial_Id
         and q.Timeoff_Id = v_Trip.Timeoff_Id;
    
      for i in 1 .. v_Trip.Region_Ids.Count
      loop
        z_Hpd_Business_Trip_Regions.Insert_Try(i_Company_Id => i_Journal.Company_Id,
                                               i_Filial_Id  => i_Journal.Filial_Id,
                                               i_Timeoff_Id => v_Trip.Timeoff_Id,
                                               i_Region_Id  => v_Trip.Region_Ids(i),
                                               i_Order_No   => i);
      end loop;
    
      Fazo.Push(v_Timeoff_Ids, v_Trip.Timeoff_Id);
    end loop;
  
    Unnecessary_Timeoffs_Delete(i_Company_Id  => i_Journal.Company_Id,
                                i_Filial_Id   => i_Journal.Filial_Id,
                                i_Journal_Id  => i_Journal.Journal_Id,
                                i_Timeoff_Ids => v_Timeoff_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Journal_Save(i_Journal Hpd_Pref.Vacation_Journal_Rt) is
    v_Vacation_Tk_Id number;
    v_Vacation       Hpd_Pref.Vacation_Rt;
    v_Timeoff_Ids    Array_Number := Array_Number();
  
    --------------------------------------------------
    Procedure Assert_Vacation_Time_Kind
    (
      i_Company_Id   number,
      i_Time_Kind_Id number
    ) is
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      if i_Time_Kind_Id = v_Vacation_Tk_Id then
        return;
      end if;
    
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Company_Id,
                                           i_Time_Kind_Id => i_Time_Kind_Id);
    
      if not Fazo.Equal(r_Time_Kind.Parent_Id, v_Vacation_Tk_Id) then
        Hpd_Error.Raise_052(r_Time_Kind.Name);
      end if;
    end;
  begin
    v_Vacation_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Journal.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => i_Journal.Journal_Type_Id,
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Vacation,
                                                              Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple));
  
    for i in 1 .. i_Journal.Vacations.Count
    loop
      v_Vacation := i_Journal.Vacations(i);
    
      v_Vacation.Time_Kind_Id := Nvl(v_Vacation.Time_Kind_Id, v_Vacation_Tk_Id);
    
      Journal_Timeoff_Save(i_Company_Id => i_Journal.Company_Id,
                           i_Filial_Id  => i_Journal.Filial_Id,
                           i_Journal_Id => i_Journal.Journal_Id,
                           i_Timeoff_Id => v_Vacation.Timeoff_Id,
                           i_Staff_Id   => v_Vacation.Staff_Id,
                           i_Begin_Date => v_Vacation.Begin_Date,
                           i_End_Date   => v_Vacation.End_Date,
                           i_Shas       => v_Vacation.Shas);
    
      Assert_Vacation_Time_Kind(i_Company_Id   => i_Journal.Company_Id,
                                i_Time_Kind_Id => v_Vacation.Time_Kind_Id);
    
      z_Hpd_Vacations.Save_One(i_Company_Id   => i_Journal.Company_Id,
                               i_Filial_Id    => i_Journal.Filial_Id,
                               i_Timeoff_Id   => v_Vacation.Timeoff_Id,
                               i_Time_Kind_Id => v_Vacation.Time_Kind_Id);
    
      Fazo.Push(v_Timeoff_Ids, v_Vacation.Timeoff_Id);
    end loop;
  
    Unnecessary_Timeoffs_Delete(i_Company_Id  => i_Journal.Company_Id,
                                i_Filial_Id   => i_Journal.Filial_Id,
                                i_Journal_Id  => i_Journal.Journal_Id,
                                i_Timeoff_Ids => v_Timeoff_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Journal_Save(i_Journal Hpd_Pref.Overtime_Journal_Rt) is
    v_Overtime       Hpd_Pref.Overtime_Rt;
    v_Overtime_Staff Hpd_Pref.Overtime_Staff_Rt;
    v_Overtime_Ids   Array_Number := Array_Number();
    v_Month          date;
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Overtime),
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Overtime));
  
    -- save division to journal
    if i_Journal.Division_Id is not null then
      z_Hpd_Overtime_Journal_Divisions.Save_One(i_Company_Id  => i_Journal.Company_Id,
                                                i_Filial_Id   => i_Journal.Filial_Id,
                                                i_Journal_Id  => i_Journal.Journal_Id,
                                                i_Division_Id => i_Journal.Division_Id);
    elsif z_Hpd_Overtime_Journal_Divisions.Exist_Lock(i_Company_Id => i_Journal.Company_Id,
                                                      i_Filial_Id  => i_Journal.Filial_Id,
                                                      i_Journal_Id => i_Journal.Journal_Id) then
      z_Hpd_Overtime_Journal_Divisions.Delete_One(i_Company_Id => i_Journal.Company_Id,
                                                  i_Filial_Id  => i_Journal.Filial_Id,
                                                  i_Journal_Id => i_Journal.Journal_Id);
    end if;
  
    for i in 1 .. i_Journal.Overtime_Staffs.Count
    loop
      v_Overtime_Staff := i_Journal.Overtime_Staffs(i);
      v_Month          := Trunc(v_Overtime_Staff.Month, 'mm');
    
      Journal_Overtime_Save(i_Company_Id  => i_Journal.Company_Id,
                            i_Filial_Id   => i_Journal.Filial_Id,
                            i_Journal_Id  => i_Journal.Journal_Id,
                            i_Overtime_Id => v_Overtime_Staff.Overtime_Id,
                            i_Staff_Id    => v_Overtime_Staff.Staff_Id,
                            i_Begin_Date  => v_Month,
                            i_End_Date    => Last_Day(v_Overtime_Staff.Month));
    
      delete from Hpd_Overtime_Days q
       where q.Company_Id = i_Journal.Company_Id
         and q.Filial_Id = i_Journal.Filial_Id
         and q.Overtime_Id = v_Overtime_Staff.Overtime_Id;
    
      for j in 1 .. v_Overtime_Staff.Overtimes.Count
      loop
        v_Overtime := v_Overtime_Staff.Overtimes(j);
      
        if Trunc(v_Overtime.Overtime_Date, 'MON') <> v_Month then
          Hpd_Error.Raise_050(i_Date  => v_Overtime.Overtime_Date,
                              i_Month => v_Overtime_Staff.Month);
        end if;
      
        z_Hpd_Overtime_Days.Insert_One(i_Company_Id       => i_Journal.Company_Id,
                                       i_Filial_Id        => i_Journal.Filial_Id,
                                       i_Staff_Id         => v_Overtime_Staff.Staff_Id,
                                       i_Overtime_Date    => v_Overtime.Overtime_Date,
                                       i_Overtime_Seconds => v_Overtime.Overtime_Seconds,
                                       i_Overtime_Id      => v_Overtime_Staff.Overtime_Id);
      end loop;
    
      Fazo.Push(v_Overtime_Ids, v_Overtime_Staff.Overtime_Id);
    end loop;
  
    Unnecessary_Overtimes_Delete(i_Company_Id   => i_Journal.Company_Id,
                                 i_Filial_Id    => i_Journal.Filial_Id,
                                 i_Journal_Id   => i_Journal.Journal_Id,
                                 i_Overtime_Ids => v_Overtime_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Journal_Save(i_Journal Hpd_Pref.Timebook_Adjustment_Journal_Rt) is
    r_Timebook_Adjustment Hpd_Journal_Timebook_Adjustments%rowtype;
    v_Adjustment          Hpd_Pref.Adjustment_Rt;
    v_Page_Ids            Array_Number;
  begin
    Journal_Save(i_Company_Id               => i_Journal.Company_Id,
                 i_Filial_Id                => i_Journal.Filial_Id,
                 i_Journal_Id               => i_Journal.Journal_Id,
                 i_Journal_Type_Id          => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment),
                 i_Journal_Number           => i_Journal.Journal_Number,
                 i_Journal_Date             => i_Journal.Journal_Date,
                 i_Journal_Name             => i_Journal.Journal_Name,
                 i_Lang_Code                => i_Journal.Lang_Code,
                 i_Acceptable_Journal_Types => Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment));
  
    r_Timebook_Adjustment.Company_Id      := i_Journal.Company_Id;
    r_Timebook_Adjustment.Filial_Id       := i_Journal.Filial_Id;
    r_Timebook_Adjustment.Journal_Id      := i_Journal.Journal_Id;
    r_Timebook_Adjustment.Division_Id     := i_Journal.Division_Id;
    r_Timebook_Adjustment.Adjustment_Date := i_Journal.Adjustment_Date;
  
    z_Hpd_Journal_Timebook_Adjustments.Save_Row(r_Timebook_Adjustment);
  
    v_Page_Ids := Array_Number();
    v_Page_Ids.Extend(i_Journal.Adjustments.Count);
  
    for i in 1 .. i_Journal.Adjustments.Count
    loop
      v_Adjustment := i_Journal.Adjustments(i);
    
      continue when v_Adjustment.Kinds.Count = 0;
    
      v_Page_Ids(i) := v_Adjustment.Page_Id;
    
      Journal_Page_Save(i_Company_Id => i_Journal.Company_Id,
                        i_Filial_Id  => i_Journal.Filial_Id,
                        i_Journal_Id => i_Journal.Journal_Id,
                        i_Page_Id    => v_Adjustment.Page_Id,
                        i_Staff_Id   => v_Adjustment.Staff_Id);
    
      delete from Hpd_Page_Adjustments q
       where q.Company_Id = i_Journal.Company_Id
         and q.Filial_Id = i_Journal.Filial_Id
         and q.Page_Id = v_Adjustment.Page_Id;
    
      for j in 1 .. v_Adjustment.Kinds.Count
      loop
        z_Hpd_Page_Adjustments.Save_One(i_Company_Id   => i_Journal.Company_Id,
                                        i_Filial_Id    => i_Journal.Filial_Id,
                                        i_Page_Id      => v_Adjustment.Page_Id,
                                        i_Kind         => v_Adjustment.Kinds(j).Kind,
                                        i_Free_Time    => v_Adjustment.Kinds(j).Free_Time,
                                        i_Overtime     => v_Adjustment.Kinds(j).Overtime,
                                        i_Turnout_Time => v_Adjustment.Kinds(j).Turnout_Time);
      end loop;
    end loop;
  
    Unnecessary_Pages_Delete(i_Company_Id => i_Journal.Company_Id,
                             i_Filial_Id  => i_Journal.Filial_Id,
                             i_Journal_Id => i_Journal.Journal_Id,
                             i_Page_Ids   => v_Page_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null
  ) is
    r_Journal         Hpd_Journals%rowtype;
    v_Document_Status varchar2(1);
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Journal_Id => i_Journal_Id);
  
    if r_Journal.Posted = 'Y' then
      Hpd_Error.Raise_038(r_Journal.Journal_Number);
    end if;
  
    -- Check Sign Document     
    v_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                            i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Document_Status is not null then
      if v_Document_Status <> Mdf_Pref.c_Ds_Draft then
        Hpd_Error.Raise_085(i_Document_Status => Mdf_Pref.t_Document_Status(v_Document_Status),
                            i_Journal_Number  => r_Journal.Journal_Number);
      end if;
    end if;
  
    if Hpd_Util.Is_Hiring_Journal(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hiring_Staffs_Invalid(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Journal_Id => i_Journal_Id);
    end if;
  
    if Hpd_Util.Is_Hiring_Journal(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) or
       Hpd_Util.Is_Transfer_Journal(i_Company_Id      => r_Journal.Company_Id,
                                    i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Auto_Robots_Invalid(i_Company_Id => r_Journal.Company_Id,
                          i_Filial_Id  => r_Journal.Filial_Id,
                          i_Journal_Id => r_Journal.Journal_Id);
    
      Hpd_Core.Delete_Robot_Book_Transactions(i_Company_Id => r_Journal.Company_Id,
                                              i_Filial_Id  => r_Journal.Filial_Id,
                                              i_Journal_Id => r_Journal.Journal_Id);
    end if;
  
    if Hpd_Util.Is_Contractor_Journal(i_Company_Id      => r_Journal.Company_Id,
                                      i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Hpd_Core.Hiring_Cv_Contract_Delete(i_Company_Id => r_Journal.Company_Id,
                                         i_Filial_Id  => r_Journal.Filial_Id,
                                         i_Journal_Id => r_Journal.Journal_Id);
    end if;
  
    if not Fazo.Equal(r_Journal.Source_Table, i_Source_Table) or
       not Fazo.Equal(r_Journal.Source_Id, i_Source_Id) then
      Hpd_Error.Raise_070(i_Jounal_Id         => r_Journal.Journal_Id,
                          i_Journal_Number    => r_Journal.Journal_Number,
                          i_Journal_Type_Name => Journal_Type_Name(i_Company_Id,
                                                                   r_Journal.Journal_Type_Id),
                          i_Source_Table      => r_Journal.Source_Table,
                          i_Source_Id         => r_Journal.Source_Id);
    end if;
  
    z_Hpd_Journals.Delete_One(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Journal_Id => i_Journal_Id);
  
    if v_Document_Status is not null then
      Mdf_Api.Document_Delete(i_Company_Id  => r_Journal.Company_Id,
                              i_Document_Id => r_Journal.Sign_Document_Id);
    end if;
  
    if Hpd_Util.Is_Hiring_Journal(i_Company_Id      => r_Journal.Company_Id,
                                  i_Journal_Type_Id => r_Journal.Journal_Type_Id) or
       Hpd_Util.Is_Transfer_Journal(i_Company_Id      => r_Journal.Company_Id,
                                    i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      Journal_Repairing(i_Company_Id => i_Company_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Journal_Id => i_Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Post
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null
  ) is
  begin
    Hpd_Core.Journal_Post(i_Company_Id   => i_Company_Id,
                          i_Filial_Id    => i_Filial_Id,
                          i_Journal_Id   => i_Journal_Id,
                          i_Source_Table => i_Source_Table,
                          i_Source_Id    => i_Source_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Unpost
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Journal_Id   number,
    i_Source_Table varchar2 := null,
    i_Source_Id    number := null,
    i_Repost       boolean := false
  ) is
  begin
    Hpd_Core.Journal_Unpost(i_Company_Id   => i_Company_Id,
                            i_Filial_Id    => i_Filial_Id,
                            i_Journal_Id   => i_Journal_Id,
                            i_Source_Table => i_Source_Table,
                            i_Source_Id    => i_Source_Id,
                            i_Repost       => i_Repost);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Lock_Interval_Insert
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Timebook_Id number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date
  ) is
  begin
    Hpd_Core.Timebook_Lock_Interval_Insert(i_Company_Id  => i_Company_Id,
                                           i_Filial_Id   => i_Filial_Id,
                                           i_Timebook_Id => i_Timebook_Id,
                                           i_Staff_Id    => i_Staff_Id,
                                           i_Begin_Date  => i_Begin_Date,
                                           i_End_Date    => i_End_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Perf_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date
  ) is
  begin
    Hpd_Core.Perf_Lock_Interval_Insert(i_Company_Id    => i_Company_Id,
                                       i_Filial_Id     => i_Filial_Id,
                                       i_Staff_Plan_Id => i_Staff_Plan_Id,
                                       i_Staff_Id      => i_Staff_Id,
                                       i_Begin_Date    => i_Begin_Date,
                                       i_End_Date      => i_End_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sales_Bonus_Payment_Lock_Interval_Insert
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Operation_Id  number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Interval_Kind varchar2
  ) is
  begin
    Hpd_Core.Sales_Bonus_Payment_Lock_Interval_Insert(i_Company_Id    => i_Company_Id,
                                                      i_Filial_Id     => i_Filial_Id,
                                                      i_Operation_Id  => i_Operation_Id,
                                                      i_Staff_Id      => i_Staff_Id,
                                                      i_Begin_Date    => i_Begin_Date,
                                                      i_End_Date      => i_End_Date,
                                                      i_Interval_Kind => i_Interval_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lock_Interval_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Interval_Id number
  ) is
  begin
    Hpd_Core.Lock_Interval_Delete(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Interval_Id => i_Interval_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Save(i_Contract Hpd_Pref.Cv_Contract_Rt) is
    r_Contract           Hpd_Cv_Contracts%rowtype;
    v_Contract_Item_Ids  Array_Number := Array_Number();
    v_Contract_File_Shas Array_Varchar2 := Array_Varchar2();
    v_Contract_Item      Hpd_Pref.Cv_Contract_Item_Rt;
    v_Contract_File      Hpd_Pref.Cv_Contract_File_Rt;
    v_Exists             boolean;
  begin
    if i_Contract.Access_To_Add_Item = 'N' and i_Contract.Items.Count = 0 then
      Hpd_Error.Raise_039(i_Contract.Contract_Id);
    end if;
  
    if z_Hpd_Cv_Contracts.Exist(i_Company_Id  => i_Contract.Company_Id,
                                i_Filial_Id   => i_Contract.Filial_Id,
                                i_Contract_Id => i_Contract.Contract_Id,
                                o_Row         => r_Contract) then
      if r_Contract.Posted = 'Y' then
        Hpd_Error.Raise_040(r_Contract.Contract_Id);
      end if;
    
      v_Exists := true;
    else
      r_Contract.Company_Id               := i_Contract.Company_Id;
      r_Contract.Filial_Id                := i_Contract.Filial_Id;
      r_Contract.Contract_Id              := i_Contract.Contract_Id;
      r_Contract.Contract_Employment_Kind := i_Contract.Contract_Employment_Kind;
    
      if r_Contract.Contract_Employment_Kind = Hpd_Pref.c_Contract_Employment_Staff_Member then
        r_Contract.Page_Id := i_Contract.Page_Id;
      end if;
    
      v_Exists := false;
    end if;
  
    r_Contract.Contract_Number    := i_Contract.Contract_Number;
    r_Contract.Division_Id        := i_Contract.Division_Id;
    r_Contract.Person_Id          := i_Contract.Person_Id;
    r_Contract.Begin_Date         := i_Contract.Begin_Date;
    r_Contract.End_Date           := i_Contract.End_Date;
    r_Contract.Contract_Kind      := i_Contract.Contract_Kind;
    r_Contract.Access_To_Add_Item := i_Contract.Access_To_Add_Item;
    r_Contract.Early_Closed_Date  := null;
    r_Contract.Early_Closed_Note  := null;
    r_Contract.Note               := i_Contract.Note;
    r_Contract.Posted             := 'N';
  
    if v_Exists then
      z_Hpd_Cv_Contracts.Update_Row(r_Contract);
    else
      if r_Contract.Contract_Number is null then
        r_Contract.Contract_Number := Md_Core.Gen_Number(i_Company_Id => i_Contract.Company_Id,
                                                         i_Filial_Id  => i_Contract.Filial_Id,
                                                         i_Table      => Zt.Hpd_Cv_Contracts,
                                                         i_Column     => z.Contract_Number);
      end if;
    
      z_Hpd_Cv_Contracts.Insert_Row(r_Contract);
    end if;
  
    v_Contract_Item_Ids.Extend(i_Contract.Items.Count);
  
    for i in 1 .. i_Contract.Items.Count
    loop
      v_Contract_Item := i_Contract.Items(i);
      v_Contract_Item_Ids(i) := v_Contract_Item.Contract_Item_Id;
    
      z_Hpd_Cv_Contract_Items.Save_One(i_Company_Id       => i_Contract.Company_Id,
                                       i_Filial_Id        => i_Contract.Filial_Id,
                                       i_Contract_Item_Id => v_Contract_Item.Contract_Item_Id,
                                       i_Contract_Id      => i_Contract.Contract_Id,
                                       i_Name             => v_Contract_Item.Name,
                                       i_Quantity         => v_Contract_Item.Quantity,
                                       i_Amount           => v_Contract_Item.Amount);
    
      z_Href_Cached_Contract_Item_Names.Insert_Try(i_Company_Id => i_Contract.Company_Id,
                                                   i_Name       => Lower(v_Contract_Item.Name));
    end loop;
  
    -- delete items
    delete from Hpd_Cv_Contract_Items q
     where q.Company_Id = i_Contract.Company_Id
       and q.Filial_Id = i_Contract.Filial_Id
       and q.Contract_Id = i_Contract.Contract_Id
       and q.Contract_Item_Id not member of v_Contract_Item_Ids;
  
    v_Contract_File_Shas.Extend(i_Contract.Files.Count);
  
    for i in 1 .. i_Contract.Files.Count
    loop
      v_Contract_File := i_Contract.Files(i);
      v_Contract_File_Shas(i) := v_Contract_File.File_Sha;
    
      z_Hpd_Cv_Contract_Files.Save_One(i_Company_Id  => i_Contract.Company_Id,
                                       i_Filial_Id   => i_Contract.Filial_Id,
                                       i_Contract_Id => i_Contract.Contract_Id,
                                       i_File_Sha    => v_Contract_File.File_Sha,
                                       i_Note        => v_Contract_File.Note);
    end loop;
  
    -- delete files
    delete from Hpd_Cv_Contract_Files q
     where q.Company_Id = i_Contract.Company_Id
       and q.Filial_Id = i_Contract.Filial_Id
       and q.Contract_Id = i_Contract.Contract_Id
       and q.File_Sha not member of v_Contract_File_Shas;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
    r_Page     Hpd_Journal_Pages%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Load(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Contract_Employment_Kind = Hpd_Pref.c_Contract_Employment_Freelancer then
      Hpd_Core.Cv_Contract_Post(i_Company_Id  => i_Company_Id,
                                i_Filial_Id   => i_Filial_Id,
                                i_Contract_Id => i_Contract_Id);
    else
      r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => r_Contract.Page_Id);
    
      Hpd_Core.Journal_Post(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Journal_Id => r_Page.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
    r_Page     Hpd_Journal_Pages%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Load(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Contract_Employment_Kind = Hpd_Pref.c_Contract_Employment_Freelancer then
      Hpd_Core.Cv_Contract_Unpost(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Contract_Id => i_Contract_Id);
    else
      r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => r_Contract.Page_Id);
    
      Hpd_Core.Journal_Unpost(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Journal_Id => r_Page.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Contract_Id       number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
    r_Page     Hpd_Journal_Pages%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Load(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Contract_Employment_Kind = Hpd_Pref.c_Contract_Employment_Freelancer then
      Hpd_Core.Cv_Contract_Close(i_Company_Id        => i_Company_Id,
                                 i_Filial_Id         => i_Filial_Id,
                                 i_Contract_Id       => i_Contract_Id,
                                 i_Early_Closed_Date => i_Early_Closed_Date,
                                 i_Early_Closed_Note => i_Early_Closed_Note);
    else
      r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => r_Contract.Page_Id);
    
      Hpd_Core.Hiring_Cv_Contract_Close(i_Company_Id        => i_Company_Id,
                                        i_Filial_Id         => i_Filial_Id,
                                        i_Journal_Id        => r_Page.Journal_Id,
                                        i_Early_Closed_Date => i_Early_Closed_Date,
                                        i_Early_Closed_Note => i_Early_Closed_Note);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Contract_Id number
  ) is
    r_Contract Hpd_Cv_Contracts%rowtype;
    r_Page     Hpd_Journal_Pages%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Contract_Id => i_Contract_Id);
  
    if r_Contract.Contract_Employment_Kind = Hpd_Pref.c_Contract_Employment_Freelancer then
      Hpd_Core.Cv_Contract_Delete(i_Company_Id  => i_Company_Id,
                                  i_Filial_Id   => i_Filial_Id,
                                  i_Contract_Id => i_Contract_Id);
    else
      r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => r_Contract.Page_Id);
    
      Journal_Delete(i_Company_Id => i_Company_Id,
                     i_Filial_Id  => i_Filial_Id,
                     i_Journal_Id => r_Page.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Cv_Contract_Close
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Journal_Id        number,
    i_Early_Closed_Date date,
    i_Early_Closed_Note varchar2
  ) is
  begin
    Hpd_Core.Hiring_Cv_Contract_Close(i_Company_Id        => i_Company_Id,
                                      i_Filial_Id         => i_Filial_Id,
                                      i_Journal_Id        => i_Journal_Id,
                                      i_Early_Closed_Date => i_Early_Closed_Date,
                                      i_Early_Closed_Note => i_Early_Closed_Note);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Save
  (
    i_Company_Id             number,
    i_Filial_Id              number,
    i_Application_Id         number,
    i_Application_Type_Pcode varchar2
  ) is
    r_Row                 Hpd_Applications%rowtype;
    v_Application_Type_Id number;
  begin
    v_Application_Type_Id := Hpd_Util.Application_Type_Id(i_Company_Id => i_Company_Id,
                                                          i_Pcode      => i_Application_Type_Pcode);
  
    if z_Hpd_Applications.Exist_Lock(i_Company_Id     => i_Company_Id,
                                     i_Filial_Id      => i_Filial_Id,
                                     i_Application_Id => i_Application_Id,
                                     o_Row            => r_Row) then
      if r_Row.Status <> Hpd_Pref.c_Application_Status_New then
        Hpd_Error.Raise_056(i_Application_Number => r_Row.Application_Number,
                            i_Status             => r_Row.Status);
      end if;
    
      if r_Row.Application_Type_Id <> v_Application_Type_Id then
        Hpd_Error.Raise_071(i_Wrong_Application_Type    => Hpd_Util.Application_Type_Name(i_Company_Id          => i_Company_Id,
                                                                                          i_Application_Type_Id => v_Application_Type_Id),
                            i_Expected_Application_Type => Hpd_Util.Application_Type_Name(i_Company_Id          => i_Company_Id,
                                                                                          i_Application_Type_Id => r_Row.Application_Type_Id));
      end if;
    
      z_Hpd_Applications.Update_Row(r_Row);
    
      return;
    end if;
  
    r_Row.Company_Id          := i_Company_Id;
    r_Row.Filial_Id           := i_Filial_Id;
    r_Row.Application_Id      := i_Application_Id;
    r_Row.Application_Type_Id := v_Application_Type_Id;
    r_Row.Application_Number  := Md_Core.Gen_Number(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Table      => Zt.Hpd_Applications,
                                                    i_Column     => z.Application_Number);
    r_Row.Application_Date    := Trunc(sysdate);
    r_Row.Status              := Hpd_Pref.c_Application_Status_New;
  
    z_Hpd_Applications.Insert_Row(r_Row);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Create_Robot_Save(i_Create_Robot Hpd_Pref.Application_Create_Robot_Rt) is
  begin
    Application_Save(i_Company_Id             => i_Create_Robot.Company_Id,
                     i_Filial_Id              => i_Create_Robot.Filial_Id,
                     i_Application_Id         => i_Create_Robot.Application_Id,
                     i_Application_Type_Pcode => Hpd_Pref.c_Pcode_Application_Type_Create_Robot);
  
    z_Hpd_Application_Create_Robots.Save_One(i_Company_Id     => i_Create_Robot.Company_Id,
                                             i_Filial_Id      => i_Create_Robot.Filial_Id,
                                             i_Application_Id => i_Create_Robot.Application_Id,
                                             i_Name           => i_Create_Robot.Name,
                                             i_Opened_Date    => i_Create_Robot.Opened_Date,
                                             i_Division_Id    => i_Create_Robot.Division_Id,
                                             i_Job_Id         => i_Create_Robot.Job_Id,
                                             i_Quantity       => i_Create_Robot.Quantity,
                                             i_Note           => i_Create_Robot.Note);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Hiring_Save(i_Hiring Hpd_Pref.Application_Hiring_Rt) is
  begin
    Application_Save(i_Company_Id             => i_Hiring.Company_Id,
                     i_Filial_Id              => i_Hiring.Filial_Id,
                     i_Application_Id         => i_Hiring.Application_Id,
                     i_Application_Type_Pcode => Hpd_Pref.c_Pcode_Application_Type_Hiring);
  
    z_Hpd_Application_Hirings.Save_One(i_Company_Id      => i_Hiring.Company_Id,
                                       i_Filial_Id       => i_Hiring.Filial_Id,
                                       i_Application_Id  => i_Hiring.Application_Id,
                                       i_Hiring_Date     => i_Hiring.Hiring_Date,
                                       i_Robot_Id        => i_Hiring.Robot_Id,
                                       i_Note            => i_Hiring.Note,
                                       i_First_Name      => i_Hiring.First_Name,
                                       i_Last_Name       => i_Hiring.Last_Name,
                                       i_Middle_Name     => i_Hiring.Middle_Name,
                                       i_Birthday        => i_Hiring.Birthday,
                                       i_Gender          => i_Hiring.Gender,
                                       i_Phone           => i_Hiring.Phone,
                                       i_Email           => i_Hiring.Email,
                                       i_Photo_Sha       => i_Hiring.Photo_Sha,
                                       i_Address         => i_Hiring.Address,
                                       i_Legal_Address   => i_Hiring.Legal_Address,
                                       i_Region_Id       => i_Hiring.Region_Id,
                                       i_Passport_Series => i_Hiring.Passport_Series,
                                       i_Passport_Number => i_Hiring.Passport_Number,
                                       i_Npin            => i_Hiring.Npin,
                                       i_Iapa            => i_Hiring.Iapa,
                                       i_Employment_Type => i_Hiring.Employment_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Transfer_Save
  (
    i_Application_Type varchar2,
    i_Transfer         Hpd_Pref.Application_Transfer_Rt
  ) is
    v_Transfer             Hpd_Pref.Application_Transfer_Unit_Rt;
    v_Application_Unit_Ids Array_Number := Array_Number();
  begin
    Application_Save(i_Company_Id             => i_Transfer.Company_Id,
                     i_Filial_Id              => i_Transfer.Filial_Id,
                     i_Application_Id         => i_Transfer.Application_Id,
                     i_Application_Type_Pcode => i_Application_Type);
  
    if i_Application_Type = Hpd_Pref.c_Pcode_Application_Type_Transfer and
       i_Transfer.Transfer_Units.Count <> 1 then
      Hpd_Error.Raise_080(Hpd_Util.Application_Type_Name(i_Company_Id          => i_Transfer.Company_Id,
                                                         i_Application_Type_Id => i_Application_Type));
    end if;
  
    v_Application_Unit_Ids.Extend(i_Transfer.Transfer_Units.Count);
  
    for i in 1 .. i_Transfer.Transfer_Units.Count
    loop
      v_Transfer := i_Transfer.Transfer_Units(i);
    
      z_Hpd_Application_Transfers.Save_One(i_Company_Id          => i_Transfer.Company_Id,
                                           i_Filial_Id           => i_Transfer.Filial_Id,
                                           i_Application_Unit_Id => v_Transfer.Application_Unit_Id,
                                           i_Application_Id      => i_Transfer.Application_Id,
                                           i_Staff_Id            => v_Transfer.Staff_Id,
                                           i_Transfer_Begin      => v_Transfer.Transfer_Begin,
                                           i_Robot_Id            => v_Transfer.Robot_Id,
                                           i_Note                => v_Transfer.Note);
    
      v_Application_Unit_Ids(i) := v_Transfer.Application_Unit_Id;
    end loop;
  
    delete from Hpd_Application_Transfers t
     where t.Company_Id = i_Transfer.Company_Id
       and t.Filial_Id = i_Transfer.Filial_Id
       and t.Application_Id = i_Transfer.Application_Id
       and t.Application_Unit_Id not member of v_Application_Unit_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Dismissal_Save(i_Dismissal Hpd_Pref.Application_Dismissal_Rt) is
  begin
    Application_Save(i_Company_Id             => i_Dismissal.Company_Id,
                     i_Filial_Id              => i_Dismissal.Filial_Id,
                     i_Application_Id         => i_Dismissal.Application_Id,
                     i_Application_Type_Pcode => Hpd_Pref.c_Pcode_Application_Type_Dismissal);
  
    z_Hpd_Application_Dismissals.Save_One(i_Company_Id          => i_Dismissal.Company_Id,
                                          i_Filial_Id           => i_Dismissal.Filial_Id,
                                          i_Application_Id      => i_Dismissal.Application_Id,
                                          i_Staff_Id            => i_Dismissal.Staff_Id,
                                          i_Dismissal_Date      => i_Dismissal.Dismissal_Date,
                                          i_Dismissal_Reason_Id => i_Dismissal.Dismissal_Reason_Id,
                                          i_Note                => i_Dismissal.Note);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hpd_Applications%rowtype;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_New then
      Hpd_Error.Raise_055(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Applications.Delete_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_New
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hpd_Applications%rowtype;
    v_Grants      Array_Varchar2;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_Waiting then
      Hpd_Error.Raise_058(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Applications.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id,
                                  i_Status         => Option_Varchar2(Hpd_Pref.c_Application_Status_New));
  
    -- notification send application status change
    v_Grant_Part := Hpd_Util.Application_Grant_Part(i_Company_Id          => r_Application.Company_Id,
                                                    i_Application_Type_Id => r_Application.Application_Type_Id);
    v_Grants     := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager,
                                   v_Grant_Part || Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Application.Company_Id,
                                           i_Filial_Id      => r_Application.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Status_Changed(i_Company_Id          => r_Application.Company_Id,
                                                                                                                        i_User_Id             => v_User_Id,
                                                                                                                        i_Application_Type_Id => r_Application.Application_Type_Id,
                                                                                                                        i_Application_Number  => r_Application.Application_Number,
                                                                                                                        i_Old_Status          => r_Application.Status,
                                                                                                                        i_New_Status          => Hpd_Pref.c_Application_Status_New),
                                           i_Grants         => v_Grants,
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Application.Application_Id),
                                           i_Except_User_Id => v_User_Id,
                                           i_Created_By     => r_Application.Created_By);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Waiting
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hpd_Applications%rowtype;
    v_Grants      Array_Varchar2;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
    if r_Application.Status not in
       (Hpd_Pref.c_Application_Status_New,
        Hpd_Pref.c_Application_Status_Approved,
        Hpd_Pref.c_Application_Status_Canceled) then
      Hpd_Error.Raise_059(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    if r_Application.Application_Type_Id =
       Hpd_Util.Application_Type_Id(i_Company_Id => i_Company_Id,
                                    i_Pcode      => Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple) then
      declare
        v_Count number;
      begin
        select count(1)
          into v_Count
          from Hpd_Application_Transfers t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Application_Id = i_Application_Id;
      
        if v_Count < 1 then
          Hpd_Error.Raise_079(i_Application_Number => r_Application.Application_Number);
        end if;
      end;
    end if;
  
    z_Hpd_Applications.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id,
                                  i_Status         => Option_Varchar2(Hpd_Pref.c_Application_Status_Waiting));
  
    -- notification send application status change
    v_Grant_Part := Hpd_Util.Application_Grant_Part(i_Company_Id          => r_Application.Company_Id,
                                                    i_Application_Type_Id => r_Application.Application_Type_Id);
  
    if r_Application.Status in
       (Hpd_Pref.c_Application_Status_New, Hpd_Pref.c_Application_Status_Canceled) then
      v_Grants := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Applicant,
                                 v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager);
    else
      v_Grants                 := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Hr,
                                                 v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager);
      r_Application.Created_By := null;
    end if;
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Application.Company_Id,
                                           i_Filial_Id      => r_Application.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Status_Changed(i_Company_Id          => r_Application.Company_Id,
                                                                                                                        i_User_Id             => v_User_Id,
                                                                                                                        i_Application_Type_Id => r_Application.Application_Type_Id,
                                                                                                                        i_Application_Number  => r_Application.Application_Number,
                                                                                                                        i_Old_Status          => r_Application.Status,
                                                                                                                        i_New_Status          => Hpd_Pref.c_Application_Status_Waiting),
                                           i_Grants         => v_Grants,
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Application.Application_Id),
                                           i_Except_User_Id => v_User_Id,
                                           i_Created_By     => r_Application.Created_By);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Approved
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hpd_Applications%rowtype;
    v_Grants      Array_Varchar2;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
    if r_Application.Status not in
       (Hpd_Pref.c_Application_Status_Waiting, Hpd_Pref.c_Application_Status_In_Progress) then
      Hpd_Error.Raise_060(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Applications.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id,
                                  i_Status         => Option_Varchar2(Hpd_Pref.c_Application_Status_Approved));
  
    -- notification send application status change
    v_Grant_Part := Hpd_Util.Application_Grant_Part(i_Company_Id          => r_Application.Company_Id,
                                                    i_Application_Type_Id => r_Application.Application_Type_Id);
  
    v_Grants := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Hr);
  
    if r_Application.Status = Hpd_Pref.c_Application_Status_Waiting then
      Fazo.Push(v_Grants, v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager);
    end if;
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Application.Company_Id,
                                           i_Filial_Id      => r_Application.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Status_Changed(i_Company_Id          => r_Application.Company_Id,
                                                                                                                        i_User_Id             => v_User_Id,
                                                                                                                        i_Application_Type_Id => r_Application.Application_Type_Id,
                                                                                                                        i_Application_Number  => r_Application.Application_Number,
                                                                                                                        i_Old_Status          => r_Application.Status,
                                                                                                                        i_New_Status          => Hpd_Pref.c_Application_Status_Approved),
                                           i_Grants         => v_Grants,
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Application.Application_Id),
                                           i_Except_User_Id => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_In_Progress
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hpd_Applications%rowtype;
    v_Grants      Array_Varchar2;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
    if r_Application.Status not in
       (Hpd_Pref.c_Application_Status_Approved, Hpd_Pref.c_Application_Status_Completed) then
      Hpd_Error.Raise_061(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Applications.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id,
                                  i_Status         => Option_Varchar2(Hpd_Pref.c_Application_Status_In_Progress));
  
    -- notification send application status change
    v_Grant_Part := Hpd_Util.Application_Grant_Part(i_Company_Id          => r_Application.Company_Id,
                                                    i_Application_Type_Id => r_Application.Application_Type_Id);
  
    if r_Application.Status = Hpd_Pref.c_Application_Status_Approved then
      v_Grants                 := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Hr);
      r_Application.Created_By := null;
    else
      v_Grants := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Hr,
                                 v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager,
                                 v_Grant_Part || Hpd_Pref.c_App_Grantee_Applicant);
    end if;
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Application.Company_Id,
                                           i_Filial_Id      => r_Application.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Status_Changed(i_Company_Id          => r_Application.Company_Id,
                                                                                                                        i_User_Id             => v_User_Id,
                                                                                                                        i_Application_Type_Id => r_Application.Application_Type_Id,
                                                                                                                        i_Application_Number  => r_Application.Application_Number,
                                                                                                                        i_Old_Status          => r_Application.Status,
                                                                                                                        i_New_Status          => Hpd_Pref.c_Application_Status_In_Progress),
                                           i_Grants         => v_Grants,
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Application.Application_Id),
                                           i_Except_User_Id => v_User_Id,
                                           i_Created_By     => r_Application.Created_By);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Completed
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
    r_Application Hpd_Applications%rowtype;
    v_Grants      Array_Varchar2;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_In_Progress then
      Hpd_Error.Raise_062(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    if Hpd_Util.Application_Has_Result(i_Company_Id     => i_Company_Id,
                                       i_Filial_Id      => i_Filial_Id,
                                       i_Application_Id => i_Application_Id) <> 'Y' then
      Hpd_Error.Raise_065(r_Application.Application_Number);
    end if;
  
    z_Hpd_Applications.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id,
                                  i_Status         => Option_Varchar2(Hpd_Pref.c_Application_Status_Completed));
  
    -- notification send application status change
    v_Grant_Part := Hpd_Util.Application_Grant_Part(i_Company_Id          => r_Application.Company_Id,
                                                    i_Application_Type_Id => r_Application.Application_Type_Id);
    v_Grants     := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Hr,
                                   v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager,
                                   v_Grant_Part || Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Application.Company_Id,
                                           i_Filial_Id      => r_Application.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Status_Changed(i_Company_Id          => r_Application.Company_Id,
                                                                                                                        i_User_Id             => v_User_Id,
                                                                                                                        i_Application_Type_Id => r_Application.Application_Type_Id,
                                                                                                                        i_Application_Number  => r_Application.Application_Number,
                                                                                                                        i_Old_Status          => r_Application.Status,
                                                                                                                        i_New_Status          => Hpd_Pref.c_Application_Status_Completed),
                                           i_Grants         => v_Grants,
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Application.Application_Id),
                                           i_Except_User_Id => v_User_Id,
                                           i_Created_By     => r_Application.Created_By);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Status_Canceled
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Closing_Note   varchar2
  ) is
    r_Application Hpd_Applications%rowtype;
    v_Grants      Array_Varchar2;
    v_Grant_Part  varchar2(200);
    v_User_Id     number := Md_Env.User_Id;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_Waiting then
      Hpd_Error.Raise_063(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Applications.Update_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Application_Id => i_Application_Id,
                                  i_Status         => Option_Varchar2(Hpd_Pref.c_Application_Status_Canceled),
                                  i_Closing_Note   => Option_Varchar2(i_Closing_Note));
  
    -- notification send application status change
    v_Grant_Part := Hpd_Util.Application_Grant_Part(i_Company_Id          => r_Application.Company_Id,
                                                    i_Application_Type_Id => r_Application.Application_Type_Id);
    v_Grants     := Array_Varchar2(v_Grant_Part || Hpd_Pref.c_App_Grantee_Manager,
                                   v_Grant_Part || Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Core.Send_Application_Notification(i_Company_Id     => r_Application.Company_Id,
                                           i_Filial_Id      => r_Application.Filial_Id,
                                           i_Title          => Hpd_Util.t_Notification_Title_Application_Status_Changed(i_Company_Id          => r_Application.Company_Id,
                                                                                                                        i_User_Id             => v_User_Id,
                                                                                                                        i_Application_Type_Id => r_Application.Application_Type_Id,
                                                                                                                        i_Application_Number  => r_Application.Application_Number,
                                                                                                                        i_Old_Status          => r_Application.Status,
                                                                                                                        i_New_Status          => Hpd_Pref.c_Application_Status_Canceled),
                                           i_Grants         => v_Grants,
                                           i_Uri            => Hpd_Pref.c_Uri_Application_Part ||
                                                               v_Grant_Part ||
                                                               Hpd_Pref.c_App_Form_Action_View,
                                           i_Uri_Param      => Fazo.Zip_Map(Lower(z.Application_Id),
                                                                            r_Application.Application_Id),
                                           i_Except_User_Id => v_User_Id,
                                           i_Created_By     => r_Application.Created_By);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Robot
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Robot_Id       number
  ) is
    r_Application Hpd_Applications%rowtype;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_In_Progress then
      Hpd_Error.Raise_064(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Application_Robots.Insert_One(i_Company_Id     => i_Company_Id,
                                        i_Filial_Id      => i_Filial_Id,
                                        i_Application_Id => i_Application_Id,
                                        i_Robot_Id       => i_Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Employee
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Employee_Id    number
  ) is
    r_Application Hpd_Applications%rowtype;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_In_Progress then
      Hpd_Error.Raise_064(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    z_Hpd_Application_Hirings.Update_One(i_Company_Id     => i_Company_Id,
                                         i_Filial_Id      => i_Filial_Id,
                                         i_Application_Id => i_Application_Id,
                                         i_Employee_Id    => Option_Number(i_Employee_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Bind_Journal
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Journal_Id     number
  ) is
    r_Application       Hpd_Applications%rowtype;
    r_Journal           Hpd_Journals%rowtype;
    v_Application_Pcode varchar2(50);
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Application_Id => i_Application_Id);
  
    if r_Application.Status <> Hpd_Pref.c_Application_Status_In_Progress then
      Hpd_Error.Raise_064(i_Application_Number => r_Application.Application_Number,
                          i_Status             => r_Application.Status);
    end if;
  
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Journal_Id => i_Journal_Id);
  
    if z_Hpd_Application_Journals.Exist_Lock(i_Company_Id     => i_Company_Id,
                                             i_Filial_Id      => i_Filial_Id,
                                             i_Application_Id => i_Application_Id) then
      Hpd_Error.Raise_067(i_Application_Number => r_Application.Application_Number,
                          i_Journal_Number     => r_Journal.Journal_Number);
    end if;
  
    v_Application_Pcode := z_Hpd_Application_Types.Load(i_Company_Id => i_Company_Id, --
                           i_Application_Type_Id => r_Application.Application_Type_Id).Pcode;
  
    -- TODO: assert: journal_type matches application_type
  
    if v_Application_Pcode = Hpd_Pref.c_Pcode_Application_Type_Hiring then
      declare
        v_Application_Employee_Name varchar2(1000);
        v_Journal_Employee_Name     varchar2(1000);
        v_Dummy                     number;
      begin
        select 1
          into v_Dummy
          from Hpd_Journal_Employees t
          join Hpd_Application_Hirings q
            on q.Company_Id = t.Company_Id
           and q.Filial_Id = t.Filial_Id
           and q.Application_Id = i_Application_Id
           and q.Employee_Id = t.Employee_Id
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Journal_Id = i_Journal_Id
           and exists
         (select 1
                  from Hpd_Journals k
                 where k.Company_Id = t.Company_Id
                   and k.Filial_Id = t.Filial_Id
                   and k.Journal_Id = t.Journal_Id
                   and exists (select 1
                          from Hpd_Journal_Types h
                         where h.Company_Id = k.Company_Id
                           and h.Journal_Type_Id = k.Journal_Type_Id
                           and h.Pcode = Hpd_Pref.c_Pcode_Journal_Type_Hiring))
           and Rownum = 1;
      exception
        when No_Data_Found then
          select (select q.Name
                    from Mr_Natural_Persons q
                   where q.Company_Id = t.Company_Id
                     and q.Person_Id = t.Employee_Id)
            into v_Application_Employee_Name
            from Hpd_Application_Hirings t
           where t.Company_Id = i_Company_Id
             and t.Filial_Id = i_Filial_Id
             and t.Application_Id = i_Application_Id;
        
          select (select q.Name
                    from Mr_Natural_Persons q
                   where q.Company_Id = t.Company_Id
                     and q.Person_Id = t.Employee_Id)
            into v_Journal_Employee_Name
            from Hpd_Journal_Employees t
           where t.Company_Id = i_Company_Id
             and t.Filial_Id = i_Filial_Id
             and t.Journal_Id = r_Journal.Journal_Id
             and Rownum = 1;
        
          Hpd_Error.Raise_066(i_Application_Number        => r_Application.Application_Number,
                              i_Journal_Number            => r_Journal.Journal_Number,
                              i_Journal_Employee_Name     => v_Journal_Employee_Name,
                              i_Application_Employee_Name => v_Application_Employee_Name);
      end;
    end if;
  
    z_Hpd_Application_Journals.Insert_One(i_Company_Id     => i_Company_Id,
                                          i_Filial_Id      => i_Filial_Id,
                                          i_Application_Id => i_Application_Id,
                                          i_Journal_Id     => i_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sign_Template_Save(i_Sign_Template Hpd_Pref.Sign_Template_Rt) is
  begin
    Mdf_Api.Template_Save(i_Sign_Template.Template);
  
    z_Hpd_Sign_Templates.Save_One(i_Company_Id      => i_Sign_Template.Template.Company_Id,
                                  i_Filial_Id       => i_Sign_Template.Template.Filial_Id,
                                  i_Template_Id     => i_Sign_Template.Template.Sign_Id,
                                  i_Journal_Type_Id => i_Sign_Template.Journal_Type_Id);
  end;

end Hpd_Api;
/
