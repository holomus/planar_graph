create or replace package Ui_Vhr147 is
  ----------------------------------------------------------------------------------------------------  
  Function Telegram_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Absences_Today return Array_Varchar2;
end Ui_Vhr147;
/
create or replace package body Ui_Vhr147 is
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
    return b.Translate('UI-VHR147:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Telegram_Model return Hashmap is
  begin
    return Ktb_Util.Build_Model(i_Action => ':absences_today', i_Title => t('absences today'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Absences_Today return Array_Varchar2 is
    v_Date    date := Trunc(sysdate);
    v_Lack_Id number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    v_Subordinate_Divisions Array_Number;
    v_Subordinate_Chiefs    Array_Number;
    result                  Array_Varchar2 := Array_Varchar2();
  begin
    if Uit_Hlic.Is_Terminated = 'Y' then
      return Array_Varchar2(t('no license'));
    end if;
  
    Fazo.Push(result, t('absences today') || Chr(10));
    Fazo.Push(result, '--------------------' || Chr(10));
  
    v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                  i_Direct             => true,
                                                                  i_Indirect           => true,
                                                                  i_Manual             => true);
  
    for r in (select q.*, Rownum
                from (select (select s.Name
                                from Mr_Natural_Persons s
                               where s.Company_Id = q.Company_Id
                                 and s.Person_Id = q.Employee_Id) name
                        from Href_Staffs q
                       where q.Company_Id = Ui.Company_Id
                         and q.Filial_Id = Ui.Filial_Id
                         and (Uit_Href.User_Access_All_Employees = 'Y' or q.Employee_Id = Ui.User_Id or --
                             q.Org_Unit_Id member of v_Subordinate_Divisions)
                         and q.Hiring_Date <= v_Date
                         and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)
                         and exists (select 1
                                from Htt_Timesheets s
                                join Htt_Timesheet_Facts k
                                  on k.Company_Id = s.Company_Id
                                 and k.Filial_Id = s.Filial_Id
                                 and k.Timesheet_Id = s.Timesheet_Id
                               where s.Company_Id = q.Company_Id
                                 and s.Filial_Id = q.Filial_Id
                                 and s.Staff_Id = q.Staff_Id
                                 and s.Timesheet_Date = v_Date
                                 and s.Input_Time is null
                                 and s.Day_Kind = Htt_Pref.c_Day_Kind_Work
                                 and k.Time_Kind_Id = v_Lack_Id
                                 and k.Fact_Value = s.Plan_Time)
                       order by Lower(name)) q)
    loop
      Fazo.Push(result, r.Rownum || '. ' || r.Name || Chr(10));
    end loop;
  
    if Result.Count = 2 then
      Fazo.Push(result, t('absences not found'));
    end if;
  
    return result;
  end;

end Ui_Vhr147;
/
