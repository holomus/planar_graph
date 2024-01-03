create or replace package Ui_Vhr148 is
  ----------------------------------------------------------------------------------------------------  
  Function Telegram_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Latecomers_Today return Array_Varchar2;
end Ui_Vhr148;
/
create or replace package body Ui_Vhr148 is
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
    return b.Translate('UI-VHR148:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Telegram_Model return Hashmap is
  begin
    return Ktb_Util.Build_Model(i_Action => ':latecomers_today', i_Title => t('latecomers today'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Latecomers_Today return Array_Varchar2 is
    v_Date    date := Trunc(sysdate);
    v_Late_Id number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Subordinate_Divisions Array_Number := Array_Number();
    v_Subordinate_Chiefs    Array_Number;
    result                  Array_Varchar2 := Array_Varchar2();
  begin
    if Uit_Hlic.Is_Terminated = 'Y' then
      return Array_Varchar2(t('no license'));
    end if;
  
    Fazo.Push(result, t('latecomers today') || Chr(10));
    Fazo.Push(result, '--------------------' || Chr(10));
  
    v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                  i_Direct             => true,
                                                                  i_Indirect           => true,
                                                                  i_Manual             => true);
  
    for r in (select q.*, Rownum
                from (select (select s.Name
                                from Mr_Natural_Persons s
                               where s.Company_Id = q.Company_Id
                                 and s.Person_Id = q.Employee_Id) name,
                             k.Fact_Value
                        from Href_Staffs q
                        join Htt_Timesheets w
                          on w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Staff_Id = q.Staff_Id
                        join Htt_Timesheet_Facts k
                          on k.Company_Id = w.Company_Id
                         and k.Filial_Id = w.Filial_Id
                         and k.Timesheet_Id = w.Timesheet_Id
                         and k.Time_Kind_Id = v_Late_Id
                       where q.Company_Id = Ui.Company_Id
                         and q.Filial_Id = Ui.Filial_Id
                         and (Uit_Href.User_Access_All_Employees = 'Y' or q.Employee_Id = Ui.User_Id or --
                             q.Org_Unit_Id member of v_Subordinate_Divisions)
                         and q.Hiring_Date <= v_Date
                         and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)
                         and w.Timesheet_Date = v_Date
                         and w.Day_Kind = Htt_Pref.c_Day_Kind_Work
                         and k.Fact_Value > 0
                       order by Lower(name)) q)
    loop
      Fazo.Push(result,
                r.Rownum || '. ' || r.Name || '(' ||
                Htt_Util.To_Time_Seconds_Text(i_Seconds => r.Fact_Value, i_Show_Minutes => true) || ')' ||
                Chr(10));
    end loop;
  
    if Result.Count = 2 then
      Fazo.Push(result, t('latecomers not found'));
    end if;
  
    return result;
  end;

end Ui_Vhr148;
/
