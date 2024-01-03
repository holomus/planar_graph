create or replace package Uit_Href is
  ----------------------------------------------------------------------------------------------------
  c_Form_Rep_Timesheet constant Md_Forms.Form%type := '/vhr/rep/htt/timesheet';
  ----------------------------------------------------------------------------------------------------
  Function User_Access_All_Employees return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function User_Access_Level_For_Staff
  (
    i_Staff_Id  number,
    i_Filial_Id number := Ui.Filial_Id
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function User_Access_Level_For_Person
  (
    i_Person_Id number,
    i_Filial_Id number := Ui.Filial_Id
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Exist_Subordinate return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Exist_Direct_Employee return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_All_Employees;
  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Employee
  (
    i_Employee_Id number,
    i_Filial_Id   number := Ui.Filial_Id,
    i_All         boolean := true,
    i_Self        boolean := true,
    i_Direct      boolean := true,
    i_Undirect    boolean := true,
    i_Manual      boolean := true
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Employee
  (
    i_Employee_Id number,
    i_Filial_Id   number := Ui.Filial_Id,
    i_All         boolean := true,
    i_Self        boolean := true,
    i_Direct      boolean := true,
    i_Undirect    boolean := true,
    i_Manual      boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Staff
  (
    i_Staff_Id  number,
    i_Filial_Id number := Ui.Filial_Id,
    i_All       boolean := true,
    i_Self      boolean := true,
    i_Direct    boolean := true,
    i_Undirect  boolean := true,
    i_Manual    boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Has_Access_Direct;
  ----------------------------------------------------------------------------------------------------
  Function Make_Subordinated_Query
  (
    i_Query            varchar2,
    i_Include_Self     boolean := true,
    i_Include_Direct   boolean := true,
    i_Include_Undirect boolean := true,
    i_Include_Manual   boolean := false,
    i_Filter_Key       varchar2 := 'employee_id',
    i_Is_Filial        boolean := true
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Person_Refer_Field_Filter_Query
  (
    i_Include_Self     boolean := true,
    i_Include_Direct   boolean := true,
    i_Include_Undirect boolean := true,
    i_Include_Manual   boolean := false
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean := false,
    i_Filial_Id          number := Ui.Filial_Id,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Subordinate_Divisions
  (
    i_Direct           boolean,
    i_Indirect         boolean,
    i_Manual           boolean,
    i_Filial_Id        number := Ui.Filial_Id,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_All_Subordinate_Divisions return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Division(i_Division_Id number);
  ----------------------------------------------------------------------------------------------------  
  Function Get_All_Staff_Ids
  (
    i_Person_Id number,
    i_Filial_Id number := Ui.Filial_Id
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff
  (
    i_Employee_Id number,
    i_Date        date
  ) return Href_Staffs%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Status
  (
    i_Hiring_Date    date,
    i_Dismissal_Date date,
    i_Date           date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Num_To_Char(i_Value number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Fte(i_Fte number) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Age(i_Birthday date) return number;
  ----------------------------------------------------------------------------------------------------
  Function Col_Required_Settings return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Influences
  (
    i_Employee_Id         number,
    i_Dismissal_Reason_Id number := null
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Nls_Language return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Is_Blacklisted
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Is_Pro(i_Company_Id number) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function To_Glist(i_Matrix Matrix_Varchar2) return Glist;
  ----------------------------------------------------------------------------------------------------
  Function Total_Working_Staff_Count
  (
    i_Begin_Date    date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Total_Hired_Staff_Count
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Total_Dismissed_Staff_Count
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Turnovers
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Npin_Is_Valid(i_Npin varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Required_Doc_Type_Ids(i_Employee_Id number) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Required_Doc_Types_Count(i_Employee_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Documents_Count
  (
    i_Employee_Id           number,
    i_Required_Doc_Type_Ids Array_Number := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Document_Owe_Status
  (
    i_Employee_Id            number,
    i_Required_Doc_Type_Ids  Array_Number := null,
    i_Person_Documents_Count number := null
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit
  (
    i_Company_Id  number,
    i_Employee_Id number
  ) return Href_Pref.Employee_Info_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit
  (
    i_Company_Id  number,
    i_Employee_Id number
  ) return Href_Pref.Employee_Info_Nt
    pipelined;
end Uit_Href;
/
create or replace package body Uit_Href is
  ---------------------------------------------------------------------------------------------------- 
  g_User_Access_Level_For_Staff  Fazo.Varchar2_Code_Aat;
  g_User_Access_Level_For_Person Fazo.Varchar2_Code_Aat;
  g_Division_Ids_Inited          boolean := false;
  g_Division_Ids                 Array_Number := Array_Number();

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
    return b.Translate('UIT_HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  -- this function created in order to ignore admin
  ----------------------------------------------------------------------------------------------------
  Function Access_All return varchar2 is
    result varchar2(1);
  begin
    select s.Access_All_Employees
      into result
      from Href_Person_Details s
     where s.Company_Id = Ui.Company_Id
       and s.Person_Id = Ui.User_Id;
  
    return result;
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Access_All_Employees return varchar2 is
  begin
    if Ui.Is_User_Admin then
      return 'Y';
    else
      return Access_All;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Filial_Id        number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
  begin
    return Href_Util.Get_Direct_Divisions(i_Company_Id       => Ui.Company_Id,
                                          i_Filial_Id        => i_Filial_Id,
                                          i_Employee_Id      => Ui.User_Id,
                                          i_Only_Departments => i_Only_Departments);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Parents          Array_Number,
    i_Filial_Id        number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
  begin
    return Href_Util.Get_Child_Divisions(i_Company_Id       => Ui.Company_Id,
                                         i_Filial_Id        => i_Filial_Id,
                                         i_Parents          => i_Parents,
                                         i_Only_Departments => i_Only_Departments);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Filial_Id        number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
  begin
    return Href_Util.Get_Manual_Divisions(i_Company_Id       => Ui.Company_Id,
                                          i_Filial_Id        => i_Filial_Id,
                                          i_Employee_Id      => Ui.User_Id,
                                          i_Only_Departments => i_Only_Departments);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Direct_Divisions Array_Number,
    i_Filial_Id        number
  ) return Array_Number is
  begin
    return Href_Util.Get_Chief_Subordinates(i_Company_Id       => Ui.Company_Id,
                                            i_Filial_Id        => i_Filial_Id,
                                            i_Direct_Divisions => i_Direct_Divisions);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Manager
  (
    i_Robot_Id  number,
    i_Filial_Id number := Ui.Filial_Id
  ) return boolean is
    v_Dummy number;
  begin
    select 1
      into v_Dummy
      from Hrm_Robot_Divisions w
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.Robot_Id = i_Robot_Id
          --and w.Access_Type = Hrm_Pref.c_Access_Type_Structural
       and Rownum = 1;
  
    return true;
  
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Find_Staff_Relation(i_Staff Href_Staffs%rowtype) return varchar2 is
    v_Direct_Divisions   Array_Number;
    v_Chief_Subordinates Array_Number;
    v_Indirect_Divisions Array_Number;
    v_Manual_Divisions   Array_Number;
  begin
    if i_Staff.Employee_Id = Ui.User_Id then
      return Href_Pref.c_User_Access_Level_Personal;
    end if;
  
    v_Direct_Divisions := Get_Direct_Divisions(i_Filial_Id => i_Staff.Filial_Id);
  
    v_Chief_Subordinates := Get_Chief_Subordinates(v_Direct_Divisions,
                                                   i_Filial_Id => i_Staff.Filial_Id);
  
    v_Indirect_Divisions := Get_Child_Divisions(v_Direct_Divisions,
                                                i_Filial_Id => i_Staff.Filial_Id);
  
    v_Manual_Divisions := Get_Manual_Divisions(i_Filial_Id => i_Staff.Filial_Id);
  
    case
      when i_Staff.Org_Unit_Id member of v_Direct_Divisions then
        return Href_Pref.c_User_Access_Level_Direct_Employee;
      when i_Staff.Employee_Id member of v_Chief_Subordinates then
        return Href_Pref.c_User_Access_Level_Direct_Employee;
      when i_Staff.Org_Unit_Id member of v_Indirect_Divisions then
        return Href_Pref.c_User_Access_Level_Undirect_Employee;
      when i_Staff.Org_Unit_Id member of v_Manual_Divisions then
        return Href_Pref.c_User_Access_Level_Manual;
      else
        null;
    end case;
  
    return Href_Pref.c_User_Access_Level_Other;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Prior_Access_Level(i_Access_Levels varchar2) return varchar2 is
    result varchar2(1);
  begin
    if Instr(i_Access_Levels, Href_Pref.c_User_Access_Level_Personal) > 0 then
      result := Href_Pref.c_User_Access_Level_Personal;
    elsif Instr(i_Access_Levels, Href_Pref.c_User_Access_Level_Direct_Employee) > 0 then
      result := Href_Pref.c_User_Access_Level_Direct_Employee;
    elsif Instr(i_Access_Levels, Href_Pref.c_User_Access_Level_Undirect_Employee) > 0 then
      result := Href_Pref.c_User_Access_Level_Undirect_Employee;
    elsif Instr(i_Access_Levels, Href_Pref.c_User_Access_Level_Manual) > 0 then
      result := Href_Pref.c_User_Access_Level_Manual;
    else
      result := Href_Pref.c_User_Access_Level_Other;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Access_Level_For_Person
  (
    i_Person_Id number,
    i_Filial_Id number
  ) return varchar2 is
    v_Access_Level  varchar2(1);
    v_Staff_Ids     Array_Number;
    v_Access_Levels varchar2(20);
  begin
    if Ui.Is_User_Admin then
      return Href_Pref.c_User_Access_Level_Other;
    end if;
  
    return g_User_Access_Level_For_Person(Ui.User_Id || ' ' || i_Person_Id);
  
  exception
    when No_Data_Found then
      v_Staff_Ids := Get_All_Staff_Ids(i_Person_Id, i_Filial_Id => i_Filial_Id);
    
      if v_Staff_Ids.Count > 0 then
        for i in 1 .. v_Staff_Ids.Count
        loop
          v_Access_Levels := v_Access_Levels ||
                             User_Access_Level_For_Staff(v_Staff_Ids(i), i_Filial_Id => i_Filial_Id);
        end loop;
      
        if v_Staff_Ids.Count > 1 then
          v_Access_Level := Get_Prior_Access_Level(v_Access_Levels);
        else
          v_Access_Level := v_Access_Levels;
        end if;
      else
        v_Access_Level := Href_Pref.c_User_Access_Level_Other;
      end if;
    
      g_User_Access_Level_For_Person(Ui.User_Id || ' ' || i_Person_Id) := v_Access_Level;
    
      return v_Access_Level;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Access_Level_For_Staff
  (
    i_Staff_Id  number,
    i_Filial_Id number
  ) return varchar2 is
    v_Access_Level varchar2(1);
    r_Staff        Href_Staffs%rowtype;
  begin
    if Ui.Is_User_Admin then
      return Href_Pref.c_User_Access_Level_Other;
    end if;
  
    return g_User_Access_Level_For_Staff(Ui.User_Id || ' ' || i_Staff_Id);
  
  exception
    when No_Data_Found then
      r_Staff := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id);
    
      v_Access_Level := Find_Staff_Relation(r_Staff);
    
      g_User_Access_Level_For_Staff(Ui.User_Id || ' ' || i_Staff_Id) := v_Access_Level;
    
      return v_Access_Level;
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- function is used for mobile staff.pck(ui_vhr95)
  ----------------------------------------------------------------------------------------------------
  Function Exist_Subordinate return varchar2 is
    r_Staff        Href_Staffs%rowtype;
    v_Dummy        varchar2(1);
    v_Current_Date date := Trunc(sysdate);
  
    v_Subordinate_Divisions Array_Number := Array_Number();
    v_Subordinate_Chiefs    Array_Number := Array_Number();
  begin
    if User_Access_All_Employees = 'Y' then
      return 'Y';
    else
      r_Staff := Get_Primary_Staff(i_Employee_Id => Ui.User_Id, i_Date => Trunc(sysdate));
    end if;
  
    if Is_Manager(r_Staff.Robot_Id) then
      v_Subordinate_Divisions := Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                           i_Direct             => true,
                                                           i_Indirect           => true,
                                                           i_Manual             => true);
      begin
        select 'x'
          into v_Dummy
          from Href_Staffs s
         where s.Company_Id = Ui.Company_Id
           and s.Filial_Id = Ui.Filial_Id
           and s.Staff_Id <> r_Staff.Staff_Id
           and s.State = 'A'
           and v_Current_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date)
           and (s.Org_Unit_Id member of v_Subordinate_Divisions or --
                s.Employee_Id member of v_Subordinate_Chiefs)
           and Rownum = 1;
      
        return 'Y';
      exception
        when No_Data_Found then
          return 'N';
      end;
    else
      return 'N';
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- function is used for mobile staff.pck(ui_vhr95)
  ----------------------------------------------------------------------------------------------------
  Function Exist_Direct_Employee return varchar2 is
    v_Dummy        varchar2(1);
    r_Staff        Href_Staffs%rowtype;
    v_Current_Date date := Trunc(sysdate);
  
    v_Direct_Divisions   Array_Number := Array_Number();
    v_Subordinate_Chiefs Array_Number := Array_Number();
  begin
    if Ui.Is_User_Admin then
      return 'Y';
    else
      r_Staff := Get_Primary_Staff(i_Employee_Id => Ui.User_Id, i_Date => Trunc(sysdate));
    end if;
  
    if Is_Manager(r_Staff.Robot_Id) then
      v_Direct_Divisions := Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                      i_Direct             => true,
                                                      i_Indirect           => false,
                                                      i_Manual             => false);
    
      begin
        select 'x'
          into v_Dummy
          from Href_Staffs s
         where s.Company_Id = Ui.Company_Id
           and s.Filial_Id = Ui.Filial_Id
           and s.Staff_Id <> r_Staff.Staff_Id
           and v_Current_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date)
           and s.State = 'A'
           and (s.Org_Unit_Id member of v_Direct_Divisions or --
                s.Employee_Id member of v_Subordinate_Chiefs)
           and Rownum = 1;
      
        return 'Y';
      exception
        when No_Data_Found then
          return 'N';
      end;
    else
      return 'N';
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_All_Employees is
  begin
    if User_Access_All_Employees = 'N' then
      Href_Error.Raise_025; -- no access to all employee
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Employee
  (
    i_Employee_Id number,
    i_Filial_Id   number := Ui.Filial_Id,
    i_All         boolean := true,
    i_Self        boolean := true,
    i_Direct      boolean := true,
    i_Undirect    boolean := true,
    i_Manual      boolean := true
  ) return varchar2 is
    v_Access_Level varchar2(1) := User_Access_Level_For_Person(i_Employee_Id,
                                                               i_Filial_Id => i_Filial_Id);
  begin
    if i_All and User_Access_All_Employees = 'Y' then
      return 'Y';
    elsif i_Self and v_Access_Level = Href_Pref.c_User_Access_Level_Personal then
      return 'Y';
    elsif i_Direct and v_Access_Level = Href_Pref.c_User_Access_Level_Direct_Employee then
      return 'Y';
    elsif i_Undirect and v_Access_Level = Href_Pref.c_User_Access_Level_Undirect_Employee then
      return 'Y';
    elsif i_Manual and v_Access_Level = Href_Pref.c_User_Access_Level_Manual then
      return 'Y';
    end if;
  
    return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Staff
  (
    i_Filial_Id number,
    i_Staff_Id  number,
    i_All       boolean,
    i_Self      boolean,
    i_Direct    boolean,
    i_Undirect  boolean,
    i_Manual    boolean
  ) return boolean is
    v_Access_Level varchar2(1) := User_Access_Level_For_Staff(i_Staff_Id,
                                                              i_Filial_Id => i_Filial_Id);
  begin
    if i_All and User_Access_All_Employees = 'Y' then
      return true;
    elsif i_Self and v_Access_Level = Href_Pref.c_User_Access_Level_Personal then
      return true;
    elsif i_Direct and v_Access_Level = Href_Pref.c_User_Access_Level_Direct_Employee then
      return true;
    elsif i_Undirect and v_Access_Level = Href_Pref.c_User_Access_Level_Undirect_Employee then
      return true;
    elsif i_Manual and v_Access_Level = Href_Pref.c_User_Access_Level_Manual then
      return true;
    end if;
  
    return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure No_Access_Employee_Error
  (
    i_Filial_Id   number,
    i_All         boolean,
    i_Direct      boolean,
    i_Undirect    boolean,
    i_Manual      boolean,
    i_Employee_Id number := null,
    i_Staff_Id    number := null
  ) is
    v_Staff_Id    number := i_Staff_Id;
    v_Division_Id number;
    r_Division    Mhr_Divisions%rowtype;
  begin
    if i_Employee_Id is null and i_Staff_Id is null then
      b.Raise_Not_Implemented;
    end if;
  
    if v_Staff_Id is null then
      v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                   i_Filial_Id   => i_Filial_Id,
                                                   i_Employee_Id => i_Employee_Id);
    end if;
  
    v_Division_Id := z_Href_Staffs.Take(i_Company_Id => Ui.Company_Id, --
                     i_Filial_Id => i_Filial_Id, --
                     i_Staff_Id => v_Staff_Id).Org_Unit_Id;
  
    r_Division := z_Mhr_Divisions.Take(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Division_Id => v_Division_Id);
  
    Href_Error.Raise_026(i_Employee_Name => Href_Util.Staff_Name(i_Company_Id => Ui.Company_Id,
                                                                 i_Filial_Id  => i_Filial_Id,
                                                                 i_Staff_Id   => v_Staff_Id),
                         i_All           => i_All,
                         i_Direct        => i_Direct,
                         i_Undirect      => i_Undirect,
                         i_Manual        => i_Manual,
                         i_Division_Name => r_Division.Name,
                         i_Parent_Name   => z_Mhr_Divisions.Take(i_Company_Id => r_Division.Company_Id, --
                                            i_Filial_Id => r_Division.Filial_Id, --
                                            i_Division_Id => r_Division.Parent_Id).Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Employee
  (
    i_Employee_Id number,
    i_Filial_Id   number := Ui.Filial_Id,
    i_All         boolean := true,
    i_Self        boolean := true,
    i_Direct      boolean := true,
    i_Undirect    boolean := true,
    i_Manual      boolean := true
  ) is
  begin
    if Has_Access_To_Employee(i_Filial_Id   => i_Filial_Id,
                              i_Employee_Id => i_Employee_Id,
                              i_All         => i_All,
                              i_Self        => i_Self,
                              i_Direct      => i_Direct,
                              i_Undirect    => i_Undirect,
                              i_Manual      => i_Manual) <> 'Y' then
      No_Access_Employee_Error(i_Filial_Id   => i_Filial_Id,
                               i_All         => i_All,
                               i_Direct      => i_Direct,
                               i_Undirect    => i_Undirect,
                               i_Manual      => i_Manual,
                               i_Employee_Id => i_Employee_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Staff
  (
    i_Staff_Id  number,
    i_Filial_Id number := Ui.Filial_Id,
    i_All       boolean := true,
    i_Self      boolean := true,
    i_Direct    boolean := true,
    i_Undirect  boolean := true,
    i_Manual    boolean := true
  ) is
  begin
    if not Has_Access_To_Staff(i_Filial_Id => i_Filial_Id,
                               i_Staff_Id  => i_Staff_Id,
                               i_All       => i_All,
                               i_Self      => i_Self,
                               i_Direct    => i_Direct,
                               i_Undirect  => i_Undirect,
                               i_Manual    => i_Manual) then
      No_Access_Employee_Error(i_Filial_Id => i_Filial_Id,
                               i_All       => i_All,
                               i_Direct    => i_Direct,
                               i_Undirect  => i_Undirect,
                               i_Manual    => i_Manual,
                               i_Staff_Id  => i_Staff_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Has_Access_Direct is
  begin
    if User_Access_All_Employees = 'N' and Exist_Direct_Employee = 'N' then
      Href_Error.Raise_027;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Make_Subordinated_Query
  (
    i_Query            varchar2,
    i_Include_Self     boolean,
    i_Include_Direct   boolean,
    i_Include_Undirect boolean,
    i_Include_Manual   boolean,
    i_Filter_Key       varchar2,
    i_Is_Filial        boolean
  ) return varchar2 is
    v_Al_Personal   varchar2(3) := '''' || Href_Pref.c_User_Access_Level_Personal || '''';
    v_Al_Direct     varchar2(3) := '''' || Href_Pref.c_User_Access_Level_Direct_Employee || '''';
    v_Al_Indirect   varchar2(3) := '''' || Href_Pref.c_User_Access_Level_Undirect_Employee || '''';
    v_Al_Manual     varchar2(3) := '''' || Href_Pref.c_User_Access_Level_Manual || '''';
    v_Al_Other      varchar2(3) := '''' || Href_Pref.c_User_Access_Level_Other || '''';
    v_Access_Levels varchar2(10000);
    v_Separate      boolean := false;
    result          varchar2(32767);
  
    -------------------------------------------------- 
    Function Add_Access_Levels(i_Query varchar2) return varchar2 is
      v_Person_Id_Exp  varchar2(32767) := 'main_query.' || i_Filter_Key;
      v_At_Structural  varchar2(3) := '''' || Hrm_Pref.c_Access_Type_Structural || '''';
      v_At_Manual      varchar2(3) := '''' || Hrm_Pref.c_Access_Type_Manual || '''';
      v_Label_Personal varchar2(4) := '''1' || Href_Pref.c_User_Access_Level_Personal || '''';
      v_Label_Direct   varchar2(4) := '''2' || Href_Pref.c_User_Access_Level_Direct_Employee || '''';
      v_Label_Indirect varchar2(4) := '''3' || Href_Pref.c_User_Access_Level_Undirect_Employee || '''';
      v_Label_Manual   varchar2(4) := '''4' || Href_Pref.c_User_Access_Level_Manual || '''';
      v_Label_Other    varchar2(4) := '''5' || Href_Pref.c_User_Access_Level_Other || '''';
      result           varchar2(32767);
    begin
      result := 'select qr.* 
                   from (select main_query.*, ';
    
      result := result || ' nvl((select substr(min( ';
    
      result := result || ' case ';
    
      if i_Include_Self then
        result := result || ' when ' || v_Person_Id_Exp || ' = r.person_id ';
        result := result || ' then ' || v_Label_Personal;
      end if;
    
      if i_Include_Direct then
        result := result || ' when rd.access_type = ' || v_At_Structural ||
                  ' and rd.division_id = main_query.org_unit_id ';
        result := result || ' then ' || v_Label_Direct;
      
        result := result || ' when rd.access_type = ' || v_At_Structural ||
                  ' and exists
                       (select 1
                          from mhr_parent_divisions pd
                          join mrf_division_managers p
                            on p.company_id = pd.company_id
                           and p.filial_id = pd.filial_id
                           and p.division_id = pd.division_id
                          join mrf_robots rb
                            on rb.company_id = p.company_id
                           and rb.filial_id = p.filial_id
                           and rb.robot_id = p.manager_id
                           and rb.person_id = ' || v_Person_Id_Exp || ' 
                         where pd.company_id = rd.company_id
                           and pd.filial_id = rd.filial_id
                           and pd.parent_id = rd.division_id
                           and pd.division_id = main_query.org_unit_id
                           and pd.lvl = 1) ';
        result := result || ' then ' || v_Label_Direct;
      end if;
    
      if i_Include_Undirect then
        result := result || ' when rd.access_type = ' || v_At_Structural ||
                  ' and exists
                       (select 1
                          from mhr_parent_divisions pd
                         where pd.company_id = rd.company_id
                           and pd.filial_id = rd.filial_id
                           and pd.parent_id = rd.division_id
                           and pd.division_id = main_query.org_unit_id) ';
        result := result || ' then ' || v_Label_Indirect;
      end if;
    
      if i_Include_Manual then
        result := result || ' when rd.access_type = ' || v_At_Manual ||
                  ' and rd.division_id = main_query.org_unit_id ';
        result := result || ' then ' || v_Label_Manual;
      
        result := result || ' when rd.access_type = ' || v_At_Manual ||
                  ' and exists
                       (select 1
                          from mhr_parent_divisions pd
                         where pd.company_id = rd.company_id
                           and pd.filial_id = rd.filial_id
                           and pd.parent_id = rd.division_id
                           and pd.division_id = main_query.org_unit_id) ';
        result := result || ' then ' || v_Label_Manual;
      end if;
    
      result := result || ' else ' || v_Label_Other;
    
      result := result || ' end), -1) ';
    
      if not i_Is_Filial then
        result := result || ' from mrf_robots r
                            join hrm_robot_divisions rd
                              on r.company_id = rd.company_id
                             and r.filial_id = rd.filial_id
                             and r.robot_id = rd.robot_id
                           where r.company_id = :company_id
                             and r.person_id = ' || Ui.User_Id;
      else
        result := result || ' from mrf_robots r
                            join hrm_robot_divisions rd
                              on r.company_id = rd.company_id
                             and r.filial_id = rd.filial_id
                             and r.robot_id = rd.robot_id
                           where r.company_id = :company_id
                             and r.filial_id = :filial_id
                             and r.person_id = ' || Ui.User_Id;
      end if;
    
      result := result || ' ), ';
    
      if i_Include_Self then
        result := result || ' decode( ' || v_Person_Id_Exp || ' , ' || Ui.User_Id || ' , ';
      
        result := result || v_Al_Personal || ' , ' || v_Al_Other || ' ) ';
      else
        result := result || v_Al_Other;
      end if;
    
      result := result || ' ) as access_level ';
    
      result := result || ' from (' || i_Query || ') main_query) qr ';
    
      return result;
    end;
  begin
    if Ui.Is_User_Admin --
       or i_Include_Self = false and i_Include_Direct = false --
       and i_Include_Undirect = false and i_Include_Manual = false then
      return 'select main_query.*, ' || v_Al_Other || ' access_level from (' || i_Query || ') main_query';
    end if;
  
    result := Add_Access_Levels(i_Query);
  
    if User_Access_All_Employees = 'N' then
      v_Access_Levels := ' ( ';
    
      if i_Include_Self then
        v_Access_Levels := v_Access_Levels || v_Al_Personal;
        v_Separate      := true;
      end if;
    
      if i_Include_Direct then
        if v_Separate then
          v_Access_Levels := v_Access_Levels || ' , ';
        end if;
      
        v_Access_Levels := v_Access_Levels || v_Al_Direct;
        v_Separate      := true;
      end if;
    
      if i_Include_Undirect then
        if v_Separate then
          v_Access_Levels := v_Access_Levels || ' , ';
        end if;
      
        v_Access_Levels := v_Access_Levels || v_Al_Indirect;
      end if;
    
      if i_Include_Manual then
        if v_Separate then
          v_Access_Levels := v_Access_Levels || ' , ';
        end if;
      
        v_Access_Levels := v_Access_Levels || v_Al_Manual;
      end if;
    
      v_Access_Levels := v_Access_Levels || ' ) ';
    
      result := result || --
                ' where qr.access_level in ' || v_Access_Levels;
    end if;
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Person_Refer_Field_Filter_Query
  (
    i_Include_Self     boolean := true,
    i_Include_Direct   boolean := true,
    i_Include_Undirect boolean := true,
    i_Include_Manual   boolean := false
  ) return varchar2 is
    v_Query varchar2(32767);
  begin
    v_Query := 'select q.*, 
                       (select st.org_unit_id
                          from href_staffs st
                         where st.company_id = s.company_id
                           and st.filial_id = s.filial_id
                           and st.employee_id = s.employee_id
                           and st.state = ''A''
                           and st.hiring_date <= trunc(sysdate)
                           and trunc(sysdate) <= nvl(st.dismissal_date, trunc(sysdate))
                           and st.staff_kind = ''' || Href_Pref.c_Staff_Kind_Primary ||
               ''') org_unit_id,
                       s.employee_number,
                       s.employee_id
                  from mhr_employees s
                  join mr_natural_persons q
                    on q.company_id = s.company_id
                   and q.person_id = s.employee_id 
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id';
  
    return Make_Subordinated_Query(i_Query            => v_Query,
                                   i_Include_Self     => i_Include_Self,
                                   i_Include_Direct   => i_Include_Direct,
                                   i_Include_Undirect => i_Include_Undirect,
                                   i_Include_Manual   => i_Include_Manual,
                                   i_Filter_Key       => 'person_id');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean := false,
    i_Filial_Id          number := Ui.Filial_Id,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number is
    v_Direct_Divisions Array_Number;
    result             Array_Number := Array_Number();
  begin
    v_Direct_Divisions := Get_Direct_Divisions(i_Filial_Id        => i_Filial_Id,
                                               i_Only_Departments => i_Only_Departments);
  
    o_Subordinate_Chiefs := Array_Number();
  
    if i_Direct then
      result := v_Direct_Divisions;
    
      if i_Gather_Chiefs then
        o_Subordinate_Chiefs := Get_Chief_Subordinates(v_Direct_Divisions,
                                                       i_Filial_Id => i_Filial_Id);
      end if;
    end if;
  
    if i_Indirect then
      result := result multiset union
                Get_Child_Divisions(v_Direct_Divisions,
                                    i_Filial_Id        => i_Filial_Id,
                                    i_Only_Departments => i_Only_Departments);
    end if;
  
    if i_Manual then
      result := result multiset union
                Get_Manual_Divisions(i_Filial_Id        => i_Filial_Id,
                                     i_Only_Departments => i_Only_Departments);
    end if;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    i_Direct           boolean,
    i_Indirect         boolean,
    i_Manual           boolean,
    i_Filial_Id        number := Ui.Filial_Id,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    v_Dummy Array_Number;
  begin
    return Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Dummy,
                                     i_Direct             => i_Direct,
                                     i_Indirect           => i_Indirect,
                                     i_Manual             => i_Manual,
                                     i_Gather_Chiefs      => false,
                                     i_Filial_Id          => i_Filial_Id,
                                     i_Only_Departments   => i_Only_Departments);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Division_Ids is
  begin
    if not g_Division_Ids_Inited then
      g_Division_Ids_Inited := true;
      g_Division_Ids        := Get_Subordinate_Divisions(i_Direct   => true,
                                                         i_Indirect => true,
                                                         i_Manual   => true);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_All_Subordinate_Divisions return Array_Number is
  begin
    Init_Division_Ids;
  
    return g_Division_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Division(i_Division_Id number) is
  begin
    if i_Division_Id is null --
       or User_Access_All_Employees = 'Y' then
      return;
    end if;
  
    Init_Division_Ids;
  
    if i_Division_Id not member of g_Division_Ids then
      Href_Error.Raise_033(i_Division_Name => z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, --
                                              i_Filial_Id => Ui.Filial_Id, --
                                              i_Division_Id => i_Division_Id).Name);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_All_Staff_Ids
  (
    i_Person_Id number,
    i_Filial_Id number := Ui.Filial_Id
  ) return Array_Number is
    v_Current_Date date := Trunc(sysdate);
    result         Array_Number;
  begin
    select s.Staff_Id
      bulk collect
      into result
      from Href_Staffs s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Person_Id
       and s.State = 'A'
       and v_Current_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date);
  
    return result;
  exception
    when No_Data_Found then
      return Array_Number();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff
  (
    i_Employee_Id number,
    i_Date        date
  ) return Href_Staffs%rowtype is
    v_Staff_Id number;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => i_Employee_Id,
                                                 i_Date        => i_Date);
  
    return z_Href_Staffs.Take(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Staff_Id   => v_Staff_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Status
  (
    i_Hiring_Date    date,
    i_Dismissal_Date date,
    i_Date           date
  ) return varchar2 is
  begin
    return case --
    when i_Hiring_Date is null or i_Date < i_Hiring_Date then Href_Pref.c_Staff_Status_Unknown --
    when i_Dismissal_Date < i_Date then Href_Pref.c_Staff_Status_Dismissed --
    else Href_Pref.c_Staff_Status_Working end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Num_To_Char(i_Value number) return varchar2 is
    v_Mask   varchar2(32767) := '999G990D00';
    v_Maxval number := 1000000;
    v_Value  number := i_Value;
  begin
    if v_Value is null then
      return '';
    end if;
  
    if v_Value < 0 then
      v_Value := -v_Value;
    end if;
  
    while v_Maxval <= v_Value
    loop
      v_Mask   := '999G' || v_Mask;
      v_Maxval := v_Maxval * 1000;
    end loop;
  
    return trim(to_char(i_Value, v_Mask));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.fte_id,
                            q.name,
                            q.fte_value,
                            q.order_no
                       from href_ftes q
                      where q.company_id = :company_id
                     union
                     select to_number(:custom_fte_id),
                            :custom_fte_name,
                            null,
                            (select min(q.order_no) - 1
                               from href_ftes q
                              where q.company_id = :company_id)
                       from dual',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'custom_fte_id',
                                 Href_Pref.c_Custom_Fte_Id,
                                 'custom_fte_name',
                                 Href_Util.t_Custom_Fte_Name));
  
    q.Number_Field('fte_id', 'fte_value', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Fte(i_Fte number) return Hashmap is
    r_Fte Href_Ftes%rowtype;
  begin
    begin
      select *
        into r_Fte
        from Href_Ftes q
       where q.Company_Id = Ui.Company_Id
         and q.Fte_Value = i_Fte
       order by q.Pcode, q.Order_No
       fetch first row only;
    exception
      when No_Data_Found then
        null;
    end;
  
    return Fazo.Zip_Map('fte_id',
                        Nvl(r_Fte.Fte_Id, Href_Pref.c_Custom_Fte_Id),
                        'fte_name',
                        Nvl(r_Fte.Name, Href_Util.t_Custom_Fte_Name),
                        'fte',
                        i_Fte);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Calc_Age(i_Birthday date) return number is
  begin
    if i_Birthday >= Current_Date then
      return 0;
    else
      return Trunc(Months_Between(Current_Date, i_Birthday) / 12);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Col_Required_Settings return Hashmap is
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    result                  Hashmap := Hashmap();
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(Ui.Company_Id);
  
    Result.Put('last_name', v_Col_Required_Settings.Last_Name);
    Result.Put('middle_name', v_Col_Required_Settings.Middle_Name);
    Result.Put('birthday', v_Col_Required_Settings.Birthday);
    Result.Put('phone_number', v_Col_Required_Settings.Phone_Number);
    Result.Put('email', v_Col_Required_Settings.Email);
    Result.Put('region', v_Col_Required_Settings.Region);
    Result.Put('address', v_Col_Required_Settings.Address);
    Result.Put('legal_address', v_Col_Required_Settings.Legal_Address);
    Result.Put('passport', v_Col_Required_Settings.Passport);
    Result.Put('npin', v_Col_Required_Settings.Npin);
    Result.Put('iapa', v_Col_Required_Settings.Iapa);
    Result.Put('request_note', v_Col_Required_Settings.Request_Note);
    Result.Put('request_note_limit', v_Col_Required_Settings.Request_Note_Limit);
    Result.Put('plan_change_note', v_Col_Required_Settings.Plan_Change_Note);
    Result.Put('plan_change_note_limit', v_Col_Required_Settings.Plan_Change_Note_Limit);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Influences
  (
    i_Employee_Id         number,
    i_Dismissal_Reason_Id number := null
  ) return Hashmap is
    v_Locations_Count     number;
    v_Division_Names      varchar2(32672);
    v_Blacklisted         varchar2(1) := 'N';
    v_Exist               boolean := false;
    v_Sign_Template_Count number;
    v_Sign_Document_Count number;
    v_Data                Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Sign_Template_Count is
    begin
      select count(*)
        into v_Sign_Template_Count
        from Mdf_Sign_Template_Users q
       where q.Company_Id = Ui.Company_Id
         and q.User_Id = i_Employee_Id
         and exists (select 1
                from Hpd_Sign_Templates w
               where w.Company_Id = Ui.Company_Id
                 and w.Filial_Id = Ui.Filial_Id
                 and w.Template_Id = q.Template_Id);
    
      v_Data.Put('sign_template_count', v_Sign_Template_Count);
    end;
  
    --------------------------------------------------
    Procedure Sign_Document_Count is
    begin
      select count(*)
        into v_Sign_Document_Count
        from Mdf_Sign_Document_Persons q
       where q.Company_Id = Ui.Company_Id
         and q.Person_Id = i_Employee_Id
         and q.State = Mdf_Pref.c_Ss_None;
    
      v_Data.Put('sign_document_count', v_Sign_Document_Count);
    end;
  begin
    v_Locations_Count := Nullif(Uit_Htt.Get_Location_Count_Of_Employee(i_Employee_Id), 0);
    v_Division_Names  := Uit_Hrm.Get_Manager_Division_Names_Of_Employee(i_Employee_Id);
  
    if v_Locations_Count is not null then
      v_Data.Put('locations_count', v_Locations_Count);
      v_Exist := true;
    end if;
  
    if v_Division_Names is not null then
      v_Data.Put('division_names', v_Division_Names);
      v_Exist := true;
    end if;
  
    if z_Href_Dismissal_Reasons.Take(i_Company_Id => Ui.Company_Id, --
     i_Dismissal_Reason_Id => i_Dismissal_Reason_Id).Reason_Type = --
        Href_Pref.c_Dismissal_Reasons_Type_Negative then
      v_Blacklisted := 'Y';
      v_Exist       := true;
    end if;
  
    v_Data.Put('blacklisted', v_Blacklisted);
  
    if z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                               i_User_Id    => i_Employee_Id,
                               i_Filial_Id  => Ui.Filial_Id) then
      v_Data.Put('remove_access', 'Y');
      v_Exist := true;
    else
      v_Data.Put('remove_access', 'N');
    end if;
  
    if v_Exist then
      v_Data.Put('has_influence', 'Y');
    else
      v_Data.Put('has_influence', 'N');
    end if;
  
    Sign_Template_Count;
    Sign_Document_Count;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Nls_Language return varchar2 is
  begin
    return Htt_Util.Get_Nls_Language;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Blacklisted
  (
    i_Company_Id number,
    i_Person_Id  number
  ) return varchar2 is
    x number;
  begin
    with Filial_Blacklists as
     (select (select case
                       when q.Dismissal_Date is not null and q.Dismissal_Reason_Id is not null and
                            exists
                        (select 1
                               from Href_Dismissal_Reasons r
                              where r.Company_Id = q.Company_Id
                                and r.Dismissal_Reason_Id = q.Dismissal_Reason_Id
                                and r.Reason_Type = Href_Pref.c_Dismissal_Reasons_Type_Negative) then
                        'Y'
                       else
                        'N'
                     end
                from Href_Staffs q
               where q.Company_Id = t.Company_Id
                 and q.Filial_Id = t.Filial_Id
                 and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and q.Employee_Id = i_Person_Id
                 and q.State = 'A'
               order by q.Hiring_Date desc
               fetch first 1 row only) Is_Blacklisted
        from Md_Filials t
       where t.Company_Id = i_Company_Id
         and t.State = 'A')
    select 1
      into x
      from Filial_Blacklists f
     where f.Is_Blacklisted = 'Y'
     fetch first 1 row only;
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Pro(i_Company_Id number) return boolean is
  begin
    return z_Md_Company_Modules.Exist(i_Company_Id   => i_Company_Id,
                                      i_Project_Code => Verifix.Project_Code,
                                      i_Module_Code  => 'pro');
  end;

  ----------------------------------------------------------------------------------------------------
  Function To_Glist(i_Matrix Matrix_Varchar2) return Glist is
    result Glist := Glist;
  begin
    if i_Matrix is not null then
      for i in 1 .. i_Matrix.Count
      loop
        Result.Push(i_Matrix(i));
      end loop;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Total_Working_Staff_Count
  (
    i_Begin_Date    date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number is
    v_Total_Staff_Count number;
  begin
    if Ui.Is_Filial_Head then
      select count(*)
        into v_Total_Staff_Count
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Hiring_Date < i_Begin_Date
         and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Begin_Date - 1)
         and q.State = 'A'
         and (i_Ids is null or q.Filial_Id member of i_Ids)
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    else
      select count(*)
        into v_Total_Staff_Count
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Hiring_Date < i_Begin_Date
         and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Begin_Date - 1)
         and q.State = 'A'
         and (i_Ids is null or q.Division_Id member of i_Ids)
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    end if;
  
    return v_Total_Staff_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Total_Hired_Staff_Count
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number is
    v_Hired_Staff_Count number;
  begin
    if Ui.Is_Filial_Head then
      select count(*)
        into v_Hired_Staff_Count
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Hiring_Date between i_Begin_Date and i_End_Date
         and q.State = 'A'
         and (i_Ids is null or q.Filial_Id member of i_Ids)
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    else
      select count(*)
        into v_Hired_Staff_Count
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Hiring_Date between i_Begin_Date and i_End_Date
         and q.State = 'A'
         and (i_Ids is null or q.Division_Id member of i_Ids)
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    end if;
  
    return v_Hired_Staff_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Total_Dismissed_Staff_Count
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number is
    v_Dismissed_Staff_Count number;
  begin
    if Ui.Is_Filial_Head then
      select count(*)
        into v_Dismissed_Staff_Count
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Dismissal_Date between i_Begin_Date and i_End_Date
         and q.State = 'A'
         and (i_Ids is null or q.Filial_Id member of i_Ids)
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    else
      select count(*)
        into v_Dismissed_Staff_Count
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Dismissal_Date between i_Begin_Date and i_End_Date
         and q.State = 'A'
         and (i_Ids is null or q.Division_Id member of i_Ids)
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    end if;
  
    return v_Dismissed_Staff_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Turnovers
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number := null, -- filter column for filial_ids when filial_head or division_ids when not filial_head
    i_Job_Group_Ids Array_Number := null
  ) return number is
    v_Begin_Total number := Total_Working_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                      i_Ids           => i_Ids,
                                                      i_Job_Group_Ids => i_Job_Group_Ids);
    v_Hirings     number := Total_Hired_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                    i_End_Date      => i_End_Date,
                                                    i_Ids           => i_Ids,
                                                    i_Job_Group_Ids => i_Job_Group_Ids);
    v_Dismissals  number := Total_Dismissed_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                        i_End_Date      => i_End_Date,
                                                        i_Ids           => i_Ids,
                                                        i_Job_Group_Ids => i_Job_Group_Ids);
    v_Mean_Total  number;
  begin
    v_Mean_Total := v_Begin_Total + (v_Hirings - v_Dismissals) / 2;
  
    if v_Mean_Total != 0 and v_Dismissals != 0 then
      return Round((v_Dismissals / v_Mean_Total) * 100, 2);
    
    elsif v_Mean_Total = 0 and v_Dismissals != 0 then
      return 100;
    
    else
      return 0;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Npin_Is_Valid(i_Npin varchar2) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Href_Person_Details q
     where q.Company_Id = Ui.Company_Id
       and q.Npin = i_Npin;
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Required_Doc_Type_Ids(i_Employee_Id number) return Array_Number is
    v_Doc_Type_Ids Array_Number;
  begin
    select t.Doc_Type_Id
      bulk collect
      into v_Doc_Type_Ids
      from Href_Document_Types t
     where t.Company_Id = Ui.Company_Id
       and t.Is_Required = 'Y'
       and t.State = 'A'
       and not exists
     (select 1
              from Href_Excluded_Document_Types q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Doc_Type_Id = t.Doc_Type_Id
               and exists (select s.Division_Id, s.Job_Id
                      from Href_Staffs s
                     where s.Company_Id = q.Company_Id
                       and s.Filial_Id = q.Filial_Id
                       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                       and s.Employee_Id = i_Employee_Id
                       and s.Division_Id = q.Division_Id
                       and s.Job_Id = q.Job_Id
                       and s.State = 'A'
                       and s.Hiring_Date <= sysdate
                       and Nvl(s.Dismissal_Date, sysdate) >= sysdate));
  
    return v_Doc_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Required_Doc_Types_Count(i_Employee_Id number) return number is
    v_Required_Doc_Type_Ids Array_Number;
  begin
    v_Required_Doc_Type_Ids := Get_Required_Doc_Type_Ids(i_Employee_Id);
  
    return v_Required_Doc_Type_Ids.Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Documents_Count
  (
    i_Employee_Id           number,
    i_Required_Doc_Type_Ids Array_Number := null
  ) return number is
    v_Required_Doc_Type_Ids  Array_Number;
    v_Person_Documents_Count number;
  begin
    if i_Required_Doc_Type_Ids is null then
      v_Required_Doc_Type_Ids := Get_Required_Doc_Type_Ids(i_Employee_Id);
    else
      v_Required_Doc_Type_Ids := i_Required_Doc_Type_Ids;
    end if;
  
    select count(distinct t.Doc_Type_Id)
      into v_Person_Documents_Count
      from Href_Person_Documents t
     where t.Company_Id = Ui.Company_Id
       and t.Person_Id = i_Employee_Id
       and t.Is_Valid = 'Y'
       and t.Status = Href_Pref.c_Person_Document_Status_Approved
       and t.Doc_Type_Id in (select Column_Value
                               from table(v_Required_Doc_Type_Ids));
  
    return v_Person_Documents_Count;
  exception
    when No_Data_Found then
      return 0;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Document_Owe_Status
  (
    i_Employee_Id            number,
    i_Required_Doc_Type_Ids  Array_Number := null,
    i_Person_Documents_Count number := null
  ) return varchar2 is
    v_Required_Doc_Type_Ids  Array_Number;
    v_Person_Documents_Count number;
  begin
    if i_Required_Doc_Type_Ids is null then
      v_Required_Doc_Type_Ids := Get_Required_Doc_Type_Ids(i_Employee_Id);
    else
      v_Required_Doc_Type_Ids := i_Required_Doc_Type_Ids;
    end if;
  
    if i_Person_Documents_Count is null then
      v_Person_Documents_Count := Get_Person_Documents_Count(i_Employee_Id, v_Required_Doc_Type_Ids);
    else
      v_Person_Documents_Count := i_Person_Documents_Count;
    end if;
  
    if v_Required_Doc_Type_Ids.Count > 0 then
      if v_Person_Documents_Count < v_Required_Doc_Type_Ids.Count then
        return Href_Pref.c_Person_Document_Owe_Status_Partial;
      end if;
    
      return Href_Pref.c_Person_Document_Owe_Status_Complete;
    end if;
  
    return Href_Pref.c_Person_Document_Owe_Status_Exempt;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit
  (
    i_Company_Id  number,
    i_Employee_Id number
  ) return Href_Pref.Employee_Info_Nt
    pipelined is
    v_Employee_Infos      Href_Pref.Employee_Info_Nt := Href_Pref.Employee_Info_Nt();
    r_Last_Natural_Person x_Mr_Natural_Persons%rowtype;
    r_Last_Detail         x_Mr_Person_Details%rowtype;
    r_Last_Person_Detail  x_Href_Person_Details%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Context_Id    number,
      i_Column_Key    varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2,
      i_Timestamp     date,
      i_User_Id       number
    ) is
      v_Event         varchar2(1);
      v_Employee_Info Href_Pref.Employee_Info_Rt;
    begin
      if Fazo.Equal(i_Last_Value, i_Current_Value) then
        return;
      end if;
    
      if i_Current_Value is null then
        v_Event := 'D';
      elsif i_Last_Value is null then
        v_Event := 'I';
      else
        v_Event := 'U';
      end if;
    
      v_Employee_Info.Context_Id := i_Context_Id;
      v_Employee_Info.Column_Key := i_Column_Key;
      v_Employee_Info.Event      := v_Event;
      v_Employee_Info.Value      := i_Current_Value;
      v_Employee_Info.Timestamp  := i_Timestamp;
      v_Employee_Info.User_Id    := i_User_Id;
    
      v_Employee_Infos.Extend();
      v_Employee_Infos(v_Employee_Infos.Count) := v_Employee_Info;
    end;
  begin
    -- mr_natural_persons
    for r in (select q.*
                from x_Mr_Natural_Persons q
               where q.t_Company_Id = i_Company_Id
                 and q.Person_Id = i_Employee_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last_Natural_Person
            from (select *
                    from x_Mr_Natural_Persons t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Person_Id = r.Person_Id
                     and t.t_Context_Id <> r.t_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last_Natural_Person := r;
        r                     := null;
      else
        r_Last_Natural_Person := null;
      end if;
    
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.First_Name,
                     i_Last_Value    => r_Last_Natural_Person.First_Name,
                     i_Current_Value => r.First_Name,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Last_Name,
                     i_Last_Value    => r_Last_Natural_Person.Last_Name,
                     i_Current_Value => r.Last_Name,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Middle_Name,
                     i_Last_Value    => r_Last_Natural_Person.Middle_Name,
                     i_Current_Value => r.Middle_Name,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Gender,
                     i_Last_Value    => Md_Util.t_Person_Gender(r_Last_Natural_Person.Gender),
                     i_Current_Value => Md_Util.t_Person_Gender(r.Gender),
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Birthday,
                     i_Last_Value    => r_Last_Natural_Person.Birthday,
                     i_Current_Value => r.Birthday,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
    end loop;
  
    -- mr_person_details
    for r in (select q.*
                from x_Mr_Person_Details q
               where q.t_Company_Id = i_Company_Id
                 and q.Person_Id = i_Employee_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last_Detail
            from (select *
                    from x_Mr_Person_Details t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Person_Id = r.Person_Id
                     and t.t_Context_Id <> r.t_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last_Detail := r;
        r             := null;
      else
        r_Last_Detail := null;
      end if;
    
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Tin,
                     i_Last_Value    => r_Last_Detail.Tin,
                     i_Current_Value => r.Tin,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Note,
                     i_Last_Value    => r_Last_Detail.Note,
                     i_Current_Value => r.Note,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
    end loop;
  
    -- href_person_details
    for r in (select q.*
                from x_Href_Person_Details q
               where q.t_Company_Id = i_Company_Id
                 and q.Person_Id = i_Employee_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last_Person_Detail
            from (select *
                    from x_Href_Person_Details t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Person_Id = r.Person_Id
                     and t.t_Context_Id <> r.t_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last_Person_Detail := r;
        r                    := null;
      else
        r_Last_Person_Detail := null;
      end if;
    
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Iapa,
                     i_Last_Value    => r_Last_Person_Detail.Iapa,
                     i_Current_Value => r.Iapa,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Npin,
                     i_Last_Value    => r_Last_Person_Detail.Npin,
                     i_Current_Value => r.Npin,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Nationality,
                     i_Last_Value    => z_Href_Nationalities.Take(i_Company_Id => i_Company_Id, --
                                        i_Nationality_Id => r_Last_Person_Detail.Nationality_Id).Name,
                     i_Current_Value => z_Href_Nationalities.Take(i_Company_Id => i_Company_Id, --
                                        i_Nationality_Id => r.Nationality_Id).Name,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
    end loop;
  
    for i in 1 .. v_Employee_Infos.Count
    loop
      pipe row(v_Employee_Infos(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit
  (
    i_Company_Id  number,
    i_Employee_Id number
  ) return Href_Pref.Employee_Info_Nt
    pipelined is
    v_Employee_Infos     Href_Pref.Employee_Info_Nt := Href_Pref.Employee_Info_Nt();
    r_Last_Person        x_Md_Persons%rowtype;
    r_Last_Detail        x_Mr_Person_Details%rowtype;
    r_Last_Person_Detail x_Href_Person_Details%rowtype;
  
    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Context_Id    number,
      i_Column_Key    varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2,
      i_Timestamp     date,
      i_User_Id       number
    ) is
      v_Event         varchar2(1);
      v_Employee_Info Href_Pref.Employee_Info_Rt;
    begin
      if Fazo.Equal(i_Last_Value, i_Current_Value) then
        return;
      end if;
    
      if i_Current_Value is null then
        v_Event := 'D';
      elsif i_Last_Value is null then
        v_Event := 'I';
      else
        v_Event := 'U';
      end if;
    
      v_Employee_Info.Context_Id := i_Context_Id;
      v_Employee_Info.Column_Key := i_Column_Key;
      v_Employee_Info.Event      := v_Event;
      v_Employee_Info.Value      := i_Current_Value;
      v_Employee_Info.Timestamp  := i_Timestamp;
      v_Employee_Info.User_Id    := i_User_Id;
    
      v_Employee_Infos.Extend();
      v_Employee_Infos(v_Employee_Infos.Count) := v_Employee_Info;
    end;
  begin
    -- md_persons
    for r in (select q.*
                from x_Md_Persons q
               where q.t_Company_Id = i_Company_Id
                 and q.Person_Id = i_Employee_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last_Person
            from (select *
                    from x_Md_Persons t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Person_Id = r.Person_Id
                     and t.t_Context_Id <> r.t_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last_Person := r;
        r             := null;
      else
        r_Last_Person := null;
      end if;
    
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Email,
                     i_Last_Value    => r_Last_Person.Email,
                     i_Current_Value => r.Email,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
    end loop;
  
    -- mr_person_details
    for r in (select q.*
                from x_Mr_Person_Details q
               where q.t_Company_Id = i_Company_Id
                 and q.Person_Id = i_Employee_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last_Detail
            from (select *
                    from x_Mr_Person_Details t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Person_Id = r.Person_Id
                     and t.t_Context_Id <> r.t_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last_Detail := r;
        r             := null;
      else
        r_Last_Detail := null;
      end if;
    
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Address,
                     i_Last_Value    => r_Last_Detail.Address,
                     i_Current_Value => r.Address,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Legal_Address,
                     i_Last_Value    => r_Last_Detail.Legal_Address,
                     i_Current_Value => r.Legal_Address,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Main_Phone,
                     i_Last_Value    => r_Last_Detail.Main_Phone,
                     i_Current_Value => r.Main_Phone,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Region,
                     i_Last_Value    => z_Md_Regions.Take(i_Company_Id => i_Company_Id, i_Region_Id => r_Last_Detail.Region_Id).Name,
                     i_Current_Value => z_Md_Regions.Take(i_Company_Id => i_Company_Id, i_Region_Id => r.Region_Id).Name,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
    end loop;
  
    -- href_person_details
    for r in (select q.*
                from x_Href_Person_Details q
               where q.t_Company_Id = i_Company_Id
                 and q.Person_Id = i_Employee_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last_Person_Detail
            from (select *
                    from x_Href_Person_Details t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Person_Id = r.Person_Id
                     and t.t_Context_Id <> r.t_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;
        
        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last_Person_Detail := r;
        r                    := null;
      else
        r_Last_Person_Detail := null;
      end if;
    
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Extra_Phone,
                     i_Last_Value    => r_Last_Person_Detail.Extra_Phone,
                     i_Current_Value => r.Extra_Phone,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
      Get_Difference(i_Context_Id    => r.t_Context_Id,
                     i_Column_Key    => z.Corporate_Email,
                     i_Last_Value    => r_Last_Person_Detail.Corporate_Email,
                     i_Current_Value => r.Corporate_Email,
                     i_Timestamp     => r.t_Timestamp,
                     i_User_Id       => r.t_User_Id);
    end loop;
  
    for i in 1 .. v_Employee_Infos.Count
    loop
      pipe row(v_Employee_Infos(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Person_Id   = null,
           Division_Id = null;
    update Mhr_Parent_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Parent_Id   = null;
    update Hrm_Robot_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           Access_Type = null;
    update Href_Ftes q
       set q.Company_Id = null,
           q.Fte_Id     = null,
           q.Name       = null,
           q.Fte_Value  = null,
           q.Order_No   = null;
  end;

end Uit_Href;
/
