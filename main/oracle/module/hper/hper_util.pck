create or replace package Hper_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_New
  (
    o_Plan_Type            out Hper_Pref.Plan_Type_Rt,
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Plan_Type_Id         number,
    i_Name                 varchar2,
    i_Plan_Group_Id        number := null,
    i_Calc_Kind            varchar2,
    i_With_Part            varchar2,
    i_Extra_Amount_Enabled varchar2,
    i_Sale_Kind            varchar2,
    i_State                varchar2,
    i_Code                 varchar2 := null,
    i_Order_No             number := null,
    i_Division_Ids         Array_Number := null,
    i_Task_Type_Ids        Array_Number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Add_Rule
  (
    p_Plan_Type    in out nocopy Hper_Pref.Plan_Type_Rt,
    i_From_Percent number,
    i_To_Percent   number,
    i_Plan_Percent number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_New
  (
    o_Plan            out Hper_Pref.Plan_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Plan_Id         number,
    i_Plan_Date       date := null,
    i_Main_Calc_Type  varchar2,
    i_Extra_Calc_Type varchar2,
    i_Journal_Page_Id number := null,
    i_Division_Id     number := null,
    i_Job_Id          number := null,
    i_Rank_Id         number := null,
    i_Employment_Type varchar2 := null,
    i_Note            varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Add_Item
  (
    p_Plan         in out nocopy Hper_Pref.Plan_Rt,
    i_Plan_Type_Id number,
    i_Plan_Type    varchar2,
    i_Plan_Value   number,
    i_Plan_Amount  number,
    i_Note         varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Add_Rule
  (
    p_Item         in out nocopy Hper_Pref.Plan_Item_Rt,
    i_From_Percent number,
    i_To_Percent   number,
    i_Fact_Amount  number
  );
  ----------------------------------------------------------------------------------------------------  
  Function Month_End
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Month_End_Date
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date       date
  ) return date;
  ----------------------------------------------------------------------------------------------------  
  Function Month_Begin_Date
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date       date
  ) return date;
  ----------------------------------------------------------------------------------------------------
  Function Job_Plan
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Page_Id number,
    i_Plan_Date       date
  ) return Hper_Plans%rowtype;
  ---------------------------------------------------------------------------------------------------- 
  Function Staff_Plan
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number,
    i_Plan_Date  date
  ) return Hper_Staff_Plans%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Plan_Tasks
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Staff_Plans(i_Staff_Plan_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Kind(i_Plan_Kind varchar2) return varchar2;
  Function Plan_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Calc_Type(i_Type varchar2) return varchar2;
  Function Plan_Calc_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Type(i_Plan_Type varchar2) return varchar2;
  Function Plan_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Calc_Kind(i_Calc_Kind varchar2) return varchar2;
  Function Calc_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Sale_Kind(i_Sale_Kind varchar2) return varchar2;
  Function Sale_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Plan_Status(i_Status varchar2) return varchar2;
  Function Staff_Plan_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Task_Group_Plan(i_Company_Id number) return number;
end Hper_Util;
/
create or replace package body Hper_Util is
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
    return b.Translate('HPER:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  -- Plan Type
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_New
  (
    o_Plan_Type            out Hper_Pref.Plan_Type_Rt,
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Plan_Type_Id         number,
    i_Name                 varchar2,
    i_Plan_Group_Id        number := null,
    i_Calc_Kind            varchar2,
    i_With_Part            varchar2,
    i_Extra_Amount_Enabled varchar2,
    i_Sale_Kind            varchar2,
    i_State                varchar2,
    i_Code                 varchar2 := null,
    i_Order_No             number := null,
    i_Division_Ids         Array_Number := null,
    i_Task_Type_Ids        Array_Number := null
  ) is
  begin
    o_Plan_Type.Company_Id           := i_Company_Id;
    o_Plan_Type.Filial_Id            := i_Filial_Id;
    o_Plan_Type.Plan_Type_Id         := i_Plan_Type_Id;
    o_Plan_Type.Name                 := i_Name;
    o_Plan_Type.Plan_Group_Id        := i_Plan_Group_Id;
    o_Plan_Type.Calc_Kind            := i_Calc_Kind;
    o_Plan_Type.With_Part            := i_With_Part;
    o_Plan_Type.Extra_Amount_Enabled := i_Extra_Amount_Enabled;
    o_Plan_Type.Sale_Kind            := i_Sale_Kind;
    o_Plan_Type.State                := i_State;
    o_Plan_Type.Code                 := i_Code;
    o_Plan_Type.Order_No             := i_Order_No;
  
    o_Plan_Type.Division_Ids  := Nvl(i_Division_Ids, Array_Number());
    o_Plan_Type.Task_Type_Ids := Nvl(i_Task_Type_Ids, Array_Number());
    o_Plan_Type.Rules         := Hper_Pref.Rule_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Add_Rule
  (
    p_Plan_Type    in out nocopy Hper_Pref.Plan_Type_Rt,
    i_From_Percent number,
    i_To_Percent   number,
    i_Plan_Percent number
  ) is
    v_Rule Hper_Pref.Rule_Rt;
  begin
    v_Rule.From_Percent := Nvl(i_From_Percent, 0);
    v_Rule.To_Percent   := i_To_Percent;
    v_Rule.Amount       := i_Plan_Percent;
  
    p_Plan_Type.Rules.Extend;
    p_Plan_Type.Rules(p_Plan_Type.Rules.Count) := v_Rule;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Plan
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_New
  (
    o_Plan            out Hper_Pref.Plan_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Plan_Id         number,
    i_Plan_Date       date := null,
    i_Main_Calc_Type  varchar2,
    i_Extra_Calc_Type varchar2,
    i_Journal_Page_Id number := null,
    i_Division_Id     number := null,
    i_Job_Id          number := null,
    i_Rank_Id         number := null,
    i_Employment_Type varchar2 := null,
    i_Note            varchar2
  ) is
  begin
    o_Plan.Company_Id      := i_Company_Id;
    o_Plan.Filial_Id       := i_Filial_Id;
    o_Plan.Plan_Id         := i_Plan_Id;
    o_Plan.Plan_Date       := i_Plan_Date;
    o_Plan.Main_Calc_Type  := i_Main_Calc_Type;
    o_Plan.Extra_Calc_Type := i_Extra_Calc_Type;
    o_Plan.Journal_Page_Id := i_Journal_Page_Id;
    o_Plan.Division_Id     := i_Division_Id;
    o_Plan.Job_Id          := i_Job_Id;
    o_Plan.Rank_Id         := i_Rank_Id;
    o_Plan.Employment_Type := i_Employment_Type;
    o_Plan.Note            := i_Note;
  
    o_Plan.Items := Hper_Pref.Plan_Item_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Add_Item
  (
    p_Plan         in out nocopy Hper_Pref.Plan_Rt,
    i_Plan_Type_Id number,
    i_Plan_Type    varchar2,
    i_Plan_Value   number,
    i_Plan_Amount  number,
    i_Note         varchar2
  ) is
    v_Item Hper_Pref.Plan_Item_Rt;
  begin
    v_Item.Plan_Type_Id := i_Plan_Type_Id;
    v_Item.Plan_Type    := i_Plan_Type;
    v_Item.Plan_Value   := i_Plan_Value;
    v_Item.Plan_Amount  := i_Plan_Amount;
    v_Item.Note         := i_Note;
  
    v_Item.Rules := Hper_Pref.Rule_Nt();
  
    p_Plan.Items.Extend;
    p_Plan.Items(p_Plan.Items.Count) := v_Item;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Add_Rule
  (
    p_Item         in out nocopy Hper_Pref.Plan_Item_Rt,
    i_From_Percent number,
    i_To_Percent   number,
    i_Fact_Amount  number
  ) is
    v_Rule Hper_Pref.Rule_Rt;
  begin
    v_Rule.From_Percent := Nvl(i_From_Percent, 0);
    v_Rule.To_Percent   := i_To_Percent;
    v_Rule.Amount       := i_Fact_Amount;
  
    p_Item.Rules.Extend;
    p_Item.Rules(p_Item.Rules.Count) := v_Rule;
  end;

  ----------------------------------------------------------------------------------------------------
  -- month
  ----------------------------------------------------------------------------------------------------
  Function Month_End
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number is
  begin
    return to_number(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Code       => Hper_Pref.c_Pref_Month_End));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Month_End_Date
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date       date
  ) return date is
    v_Month_End number := Month_End(i_Company_Id => i_Company_Id, --
                                    i_Filial_Id  => i_Filial_Id);
  begin
    if v_Month_End is null then
      return Last_Day(i_Date);
    end if;
  
    if v_Month_End > 28 or v_Month_End < 1 then
      Hper_Error.Raise_017(i_Month_End => v_Month_End);
    end if;
  
    return Trunc(i_Date, 'MON') + v_Month_End - 1;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Month_Begin_Date
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Date       date
  ) return date is
  begin
    return Add_Months(Month_End_Date(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Date       => i_Date),
                      -1) + 1;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Job_Plan
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Page_Id number,
    i_Plan_Date       date
  ) return Hper_Plans%rowtype is
    r_Page  Hpd_Page_Robots%rowtype;
    r_Robot Mrf_Robots%rowtype;
    result  Hper_Plans%rowtype;
  begin
    select q.*
      into result
      from Hper_Plans q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Plan_Kind = Hper_Pref.c_Plan_Kind_Contract
       and q.Journal_Page_Id = i_Journal_Page_Id
       and q.Plan_Date = (select max(w.Plan_Date)
                            from Hper_Plans w
                           where w.Company_Id = i_Company_Id
                             and w.Filial_Id = i_Filial_Id
                             and w.Plan_Kind = Hper_Pref.c_Plan_Kind_Contract
                             and w.Journal_Page_Id = i_Journal_Page_Id
                             and w.Plan_Date <= i_Plan_Date)
       and Rownum = 1;
  
    return result;
  exception
    when No_Data_Found then
      begin
        r_Page := z_Hpd_Page_Robots.Load(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Page_Id    => i_Journal_Page_Id);
      
        r_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Page.Company_Id,
                                     i_Filial_Id  => r_Page.Filial_Id,
                                     i_Robot_Id   => r_Page.Robot_Id);
      
        select *
          into result
          from Hper_Plans q
         where q.Company_Id = r_Page.Company_Id
           and q.Plan_Kind = Hper_Pref.c_Plan_Kind_Standard
           and q.Division_Id = r_Robot.Division_Id
           and q.Job_Id = r_Robot.Job_Id
           and q.Employment_Type = r_Page.Employment_Type
           and Decode(q.Rank_Id, r_Page.Rank_Id, 1, 0) = 1
           and q.Plan_Date = (select max(w.Plan_Date)
                                from Hper_Plans w
                               where w.Company_Id = r_Page.Company_Id
                                 and w.Plan_Kind = Hper_Pref.c_Plan_Kind_Standard
                                 and w.Division_Id = r_Robot.Division_Id
                                 and w.Job_Id = r_Robot.Job_Id
                                 and w.Employment_Type = r_Page.Employment_Type
                                 and Decode(w.Rank_Id, r_Page.Rank_Id, 1, 0) = 1
                                 and w.Plan_Date <= i_Plan_Date)
           and Rownum = 1;
      
        return result;
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Page_Id    number,
    i_Plan_Date  date
  ) return Hper_Staff_Plans%rowtype is
    result Hper_Staff_Plans%rowtype;
  begin
    select *
      into result
      from Hper_Staff_Plans m
     where m.Company_Id = i_Company_Id
       and m.Filial_Id = i_Filial_Id
       and m.Journal_Page_Id = i_Page_Id
       and m.Plan_Date = i_Plan_Date;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Tasks
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number
  ) return Array_Number is
    r_Staff_Plan    Hper_Staff_Plans%rowtype;
    v_Task_Type_Ids Array_Number;
    result          Array_Number;
  begin
    r_Staff_Plan := z_Hper_Staff_Plans.Load(i_Company_Id    => i_Company_Id,
                                            i_Filial_Id     => i_Filial_Id,
                                            i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    select q.Task_Type_Id
      bulk collect
      into v_Task_Type_Ids
      from Hper_Staff_Plan_Task_Types q
     where q.Company_Id = r_Staff_Plan.Company_Id
       and q.Filial_Id = r_Staff_Plan.Filial_Id
       and q.Staff_Plan_Id = r_Staff_Plan.Staff_Plan_Id
       and q.Plan_Type_Id = i_Plan_Type_Id;
  
    select q.Task_Id
      bulk collect
      into result
      from Ms_Tasks q
     where q.Company_Id = r_Staff_Plan.Company_Id
       and Trunc(q.Begin_Time) <= r_Staff_Plan.End_Date
       and Trunc(q.End_Time) >= r_Staff_Plan.Begin_Date
       and exists (select 1
              from Ms_Task_Type_Binds s
             where s.Company_Id = q.Company_Id
               and s.Task_Id = q.Task_Id
               and s.Task_Type_Id member of v_Task_Type_Ids)
       and exists
     (select 1
              from Ms_Task_Persons s
             where s.Company_Id = q.Company_Id
               and s.Task_Id = q.Task_Id
               and s.Person_Id = (select k.Employee_Id
                                    from Href_Staffs k
                                   where k.Company_Id = r_Staff_Plan.Company_Id
                                     and k.Filial_Id = r_Staff_Plan.Filial_Id
                                     and k.Staff_Id = r_Staff_Plan.Staff_Id)
               and s.Involve_Kind = Ms_Pref.c_Ik_Executor);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Staff_Plans(i_Staff_Plan_Id number) return varchar2 is
    r_Staff_Plan Hper_Staff_Plans%rowtype;
    result       varchar2(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Hper_Staff_Plans.Name)));
  
    if i_Staff_Plan_Id is null then
      return result;
    end if;
  
    r_Staff_Plan := z_Hper_Staff_Plans.Take(i_Company_Id    => Md_Env.Company_Id,
                                            i_Filial_Id     => Md_Env.Filial_Id,
                                            i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    return result || ': ' || t('# $1{staff_name}',
                               Href_Util.Staff_Name(i_Company_Id => r_Staff_Plan.Company_Id,
                                                    i_Filial_Id  => r_Staff_Plan.Filial_Id,
                                                    i_Staff_Id   => r_Staff_Plan.Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  -- plan kind
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Kind_Standard return varchar2 is
  begin
    return t('plan_kind:standard');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Kind_Contract return varchar2 is
  begin
    return t('plan_kind:contract');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Kind(i_Plan_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Plan_Kind --
    when Hper_Pref.c_Plan_Kind_Standard then t_Plan_Kind_Standard --
    when Hper_Pref.c_Plan_Kind_Contract then t_Plan_Kind_Contract --
    else null --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hper_Pref.c_Plan_Kind_Standard,
                                          Hper_Pref.c_Plan_Kind_Contract),
                           Array_Varchar2(t_Plan_Kind_Standard, t_Plan_Kind_Contract));
  end;

  ----------------------------------------------------------------------------------------------------
  -- plan calc type
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Calc_Type_Weight return varchar2 is
  begin
    return t('plan_calc_type:weight');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Calc_Type_Unit return varchar2 is
  begin
    return t('plan_calc_type:unit');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Calc_Type(i_Type varchar2) return varchar2 is
  begin
    return --
    case i_Type --
    when Hper_Pref.c_Plan_Calc_Type_Weight then t_Plan_Calc_Type_Weight --
    when Hper_Pref.c_Plan_Calc_Type_Unit then t_Plan_Calc_Type_Unit --
    else null --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Calc_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hper_Pref.c_Plan_Calc_Type_Weight,
                                          Hper_Pref.c_Plan_Calc_Type_Unit),
                           Array_Varchar2(t_Plan_Calc_Type_Weight, t_Plan_Calc_Type_Unit));
  end;

  ----------------------------------------------------------------------------------------------------
  -- plan type
  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Type_Main return varchar2 is
  begin
    return t('plan_type:main');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Type_Extra return varchar2 is
  begin
    return t('plan_type:extra');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Plan_Type(i_Plan_Type varchar2) return varchar2 is
  begin
    return --
    case i_Plan_Type --
    when Hper_Pref.c_Plan_Type_Main then t_Plan_Type_Main --
    when Hper_Pref.c_Plan_Type_Extra then t_Plan_Type_Extra --
    else null --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hper_Pref.c_Plan_Type_Main, Hper_Pref.c_Plan_Type_Extra),
                           Array_Varchar2(t_Plan_Type_Main, t_Plan_Type_Extra));
  end;

  ----------------------------------------------------------------------------------------------------
  -- calc kind
  ----------------------------------------------------------------------------------------------------
  Function t_Calc_Kind_Manual return varchar2 is
  begin
    return t('calc_kind:maual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Calc_Kind_Task return varchar2 is
  begin
    return t('calc_kind:task');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Calc_Kind_Attendance return varchar2 is
  begin
    return t('calc_kind:attendance');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Calc_Kind_External return varchar2 is
  begin
    return t('calc_kind:external');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Calc_Kind(i_Calc_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Calc_Kind --
    when Hper_Pref.c_Calc_Kind_Manual then t_Calc_Kind_Manual --
    when Hper_Pref.c_Calc_Kind_Task then t_Calc_Kind_Task --
    when Hper_Pref.c_Calc_Kind_Attendance then t_Calc_Kind_Attendance --
    when Hper_Pref.c_Calc_Kind_External then t_Calc_Kind_External --
    else null --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hper_Pref.c_Calc_Kind_Manual,
                                          Hper_Pref.c_Calc_Kind_Task,
                                          Hper_Pref.c_Calc_Kind_Attendance,
                                          Hper_Pref.c_Calc_Kind_External),
                           Array_Varchar2(t_Calc_Kind_Manual,
                                          t_Calc_Kind_Task,
                                          t_Calc_Kind_Attendance,
                                          t_Calc_Kind_External));
  end;

  ----------------------------------------------------------------------------------------------------
  -- sale kind
  ----------------------------------------------------------------------------------------------------
  Function t_Sale_Kind_Personal return varchar2 is
  begin
    return t('sale_kind: personal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Sale_Kind_Department return varchar2 is
  begin
    return t('sale_kind: department');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Sale_Kind(i_Sale_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Sale_Kind --
    when Hper_Pref.c_Sale_Kind_Personal then t_Sale_Kind_Personal --
    when Hper_Pref.c_Sale_Kind_Department then t_Sale_Kind_Department --
    else null --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sale_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hper_Pref.c_Sale_Kind_Personal,
                                          Hper_Pref.c_Sale_Kind_Department),
                           Array_Varchar2(t_Sale_Kind_Personal, t_Sale_Kind_Department));
  end;

  ----------------------------------------------------------------------------------------------------
  -- staff plan status
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Plan_Status_Draft return varchar2 is
  begin
    return t('staff_plan_status:draft');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Plan_Status_New return varchar2 is
  begin
    return t('staff_plan_status:new');
  end;

  ----------------------------------------------------------------------------------------------------      
  Function t_Staff_Plan_Status_Waiting return varchar2 is
  begin
    return t('staff_plan_status:waiting');
  end;

  ----------------------------------------------------------------------------------------------------      
  Function t_Staff_Plan_Status_Completed return varchar2 is
  begin
    return t('staff_plan_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Plan_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hper_Pref.c_Staff_Plan_Status_Draft then t_Staff_Plan_Status_Draft --
    when Hper_Pref.c_Staff_Plan_Status_New then t_Staff_Plan_Status_New --
    when Hper_Pref.c_Staff_Plan_Status_Waiting then t_Staff_Plan_Status_Waiting --
    when Hper_Pref.c_Staff_Plan_Status_Completed then t_Staff_Plan_Status_Completed --
    else null --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hper_Pref.c_Staff_Plan_Status_Draft,
                                          Hper_Pref.c_Staff_Plan_Status_New,
                                          Hper_Pref.c_Staff_Plan_Status_Waiting,
                                          Hper_Pref.c_Staff_Plan_Status_Completed),
                           Array_Varchar2(t_Staff_Plan_Status_Draft,
                                          t_Staff_Plan_Status_New,
                                          t_Staff_Plan_Status_Waiting,
                                          t_Staff_Plan_Status_Completed));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Task_Group_Plan(i_Company_Id number) return number is
  begin
    return Ms_Pref.Task_Group_Id(i_Company_Id => i_Company_Id, --
                                 i_Pcode      => Hper_Pref.c_Pcode_Task_Group_Plan);
  end;
end Hper_Util;
/
