create or replace package Ui_Vhr497 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Data(P1 Json_Object_t) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(P1 Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(P1 Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Add(P1 Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(P1 Json_Object_t) return Json_Object_t;
end Ui_Vhr497;
/
create or replace package body Ui_Vhr497 is
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
    return b.Translate('UI-VHR497:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select *
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.state = ''A''';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id', 'org_unit_id', 'division_id');
    q.Varchar2_Field('staff_number', 'staff_kind', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Data(P1 Json_Object_t) return Json_Array_t is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    Tsht              Htt_Timesheets%rowtype;
    p                 Gmap := Gmap;
    v_Staff_Ids       Array_Number;
    v_Adjustment_Date date;
    v_Begin_Date      date;
    v_End_Date        date;
    v_Journal_Id      number;
    v_Timesheet_Id    number;
    v_Division_Id     number;
    v_Org_Unit_Id     number;
    v_Free_Tk         number;
    v_Turnout_Tk      number;
    v_Free_Time       number;
    v_Plan_Time       number;
    v_Intime          number;
    v_Dummy_Days      number;
    v_Kind            varchar2(1);
    v_Adjustment      Glist;
    result            Glist := Glist;
  
    v_Access_All_Employee varchar2(1);
    v_Division_Ids        Array_Number;
  begin
    p.Val             := P1;
    v_Journal_Id      := p.o_Number('journal_id');
    v_Staff_Ids       := p.o_Array_Number('staff_id');
    v_Adjustment_Date := p.r_Date('adjustment_date');
    v_Kind            := p.r_Varchar2('kind');
    v_Begin_Date      := Trunc(v_Adjustment_Date, 'mon');
    v_End_Date        := Last_Day(v_Adjustment_Date);
  
    v_Access_All_Employee := Uit_Href.User_Access_All_Employees;
  
    if v_Access_All_Employee <> 'Y' then
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                           i_Indirect => true,
                                                           i_Manual   => true);
    else
      v_Division_Ids := Array_Number();
    end if;
  
    if v_Staff_Ids is null then
      v_Division_Id := p.o_Number('division_id');
      v_Org_Unit_Id := p.o_Number('org_unit_id');
    
      select s.Staff_Id
        bulk collect
        into v_Staff_Ids
        from Href_Staffs s
       where s.Company_Id = v_Company_Id
         and s.Filial_Id = v_Filial_Id
         and s.State = 'A'
         and s.Hiring_Date <= v_Adjustment_Date
         and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Adjustment_Date)
         and (v_Division_Id is null or s.Division_Id = v_Division_Id)
         and (v_Org_Unit_Id is null or s.Org_Unit_Id = v_Org_Unit_Id)
         and (v_Access_All_Employee = 'Y' or
             s.Org_Unit_Id in (select *
                                  from table(v_Division_Ids)))
         and s.Staff_Id not in
             (select q.Staff_Id
                from Hpd_Lock_Adjustments q
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.Adjustment_Date = v_Adjustment_Date
                 and q.Kind = v_Kind
                 and (v_Journal_Id is null or q.Journal_Id <> v_Journal_Id))
         and not exists (select 1
                from Hpd_Timeoff_Days Td
               where Td.Company_Id = s.Company_Id
                 and Td.Filial_Id = s.Filial_Id
                 and Td.Staff_Id = s.Staff_Id
                 and Td.Timeoff_Date = v_Adjustment_Date);
    end if;
  
    v_Free_Tk := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    v_Turnout_Tk := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Timesheet_Id := Htt_Util.Timesheet(i_Company_Id => v_Company_Id, --
                        i_Filial_Id => v_Filial_Id, --
                        i_Staff_Id => v_Staff_Ids(i), --
                        i_Timesheet_Date => v_Adjustment_Date).Timesheet_Id;
    
      continue when z_Hpd_Timeoff_Days.Exist(i_Company_Id   => v_Company_Id,
                                             i_Filial_Id    => v_Filial_Id,
                                             i_Staff_Id     => v_Staff_Ids(i),
                                             i_Timeoff_Date => v_Adjustment_Date);
    
      continue when v_Timesheet_Id is null;
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Free_Time,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Staff_Id     => v_Staff_Ids(i),
                                    i_Time_Kind_Id => v_Free_Tk,
                                    i_Begin_Date   => v_Adjustment_Date,
                                    i_End_Date     => v_Adjustment_Date);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Intime,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Staff_Id     => v_Staff_Ids(i),
                                    i_Time_Kind_Id => v_Turnout_Tk,
                                    i_Begin_Date   => v_Adjustment_Date,
                                    i_End_Date     => v_Adjustment_Date);
    
      if v_Kind = Hpd_Pref.c_Adjustment_Kind_Full then
        continue when v_Free_Time = 0;
      else
        continue when v_Free_Time <> 0;
      
        continue when v_Intime <> 0;
      end if;
    
      continue when Hpd_Util.Staff_Timebook_Adjustment_Calced(i_Company_Id      => v_Company_Id,
                                                              i_Filial_Id       => v_Filial_Id,
                                                              i_Staff_Id        => v_Staff_Ids(i),
                                                              i_Adjustment_Date => v_Adjustment_Date,
                                                              i_Kind            => v_Kind,
                                                              i_Journal_Id      => v_Journal_Id) = 'Y';
    
      Tsht := Htt_Util.Timesheet(i_Company_Id     => v_Company_Id,
                                 i_Filial_Id      => v_Filial_Id,
                                 i_Staff_Id       => v_Staff_Ids(i),
                                 i_Timesheet_Date => v_Adjustment_Date);
    
      -- temporarily disabled because MAKRO can't decide what they want
      --       continue when Tsht.Day_Kind = Htt_Pref.c_Day_Kind_Rest and v_Kind = Hpd_Pref.c_Adjustment_Kind_Incomplete;
    
      v_Adjustment := Glist;
    
      v_Adjustment.Push(v_Staff_Ids(i));
      v_Adjustment.Push(Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                             i_Filial_Id  => v_Filial_Id,
                                             i_Staff_Id   => v_Staff_Ids(i)));
      v_Adjustment.Push(v_Kind); -- kind
    
      -- plan begin and end time
      case Tsht.Day_Kind
        when Htt_Pref.c_Day_Kind_Work then
          v_Adjustment.Push(to_char(Tsht.Begin_Time, Href_Pref.c_Time_Format_Minute) || '-' ||
                            to_char(Tsht.End_Time, Href_Pref.c_Time_Format_Minute));
        when Htt_Pref.c_Day_Kind_Rest then
          v_Adjustment.Push(t('rest day'));
        when Htt_Pref.c_Day_Kind_Holiday then
          v_Adjustment.Push(t('holiday'));
        when Htt_Pref.c_Day_Kind_Additional_Rest then
          v_Adjustment.Push(t('additional rest day'));
        when Htt_Pref.c_Day_Kind_Nonworking then
          v_Adjustment.Push(t('nonworking day'));
        else
          v_Adjustment.Push('');
      end case;
    
      v_Adjustment.Push(Trunc(Tsht.Plan_Time / 60)); -- plan time
    
      -- fact begin and end time
      v_Adjustment.Push(Nvl(to_char(Tsht.Input_Time, Href_Pref.c_Time_Format_Minute), t('no data')) || '-' ||
                        Nvl(to_char(Tsht.Output_Time, Href_Pref.c_Time_Format_Minute),
                            t('no data')));
      v_Adjustment.Push(Trunc(v_Intime / 60));
    
      v_Adjustment.Push(Trunc(v_Free_Time / 60)); -- in minutes
      v_Adjustment.Push(0); -- overtime
      v_Adjustment.Push(0); -- turnout time
    
      v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => v_Company_Id,
                                                   i_Filial_Id  => v_Filial_Id,
                                                   i_Staff_Id   => v_Staff_Ids(i),
                                                   i_Begin_Date => v_Begin_Date,
                                                   i_End_Date   => v_End_Date);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Intime,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Staff_Id     => v_Staff_Ids(i),
                                    i_Time_Kind_Id => v_Turnout_Tk,
                                    i_Begin_Date   => v_Begin_Date,
                                    i_End_Date     => v_End_Date);
    
      v_Adjustment.Push(Trunc(Greatest(v_Plan_Time - v_Intime, 0) / 60)); -- not worked time
    
      Result.Push(v_Adjustment);
    end loop;
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Adjustments
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Posted          varchar2,
    i_Adjustment_Date date
  ) return Glist is
    v_Begin_Date      date;
    v_End_Date        date;
    v_Turnout_Tk      number;
    v_Plan_Time       number;
    v_Intime          number;
    v_Not_Worked_Time number;
    v_Dummy_Days      number;
    v_Adjustment      Glist;
    result            Glist := Glist;
  begin
    v_Begin_Date := Trunc(i_Adjustment_Date, 'mon');
    v_End_Date   := Last_Day(i_Adjustment_Date);
    v_Turnout_Tk := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    for r in (select q.Staff_Id,
                     (select k.Name
                        from Mr_Natural_Persons k
                       where k.Company_Id = q.Company_Id
                         and k.Person_Id = q.Employee_Id) as Staff_Name,
                     a.Kind,
                     a.Free_Time,
                     a.Overtime,
                     a.Turnout_Time,
                     q.Page_Id,
                     t.Begin_Time,
                     t.End_Time,
                     t.Day_Kind,
                     t.Input_Time,
                     t.Output_Time,
                     t.Plan_Time
                from Hpd_Journal_Pages q
                join Hpd_Page_Adjustments a
                  on a.Company_Id = i_Company_Id
                 and a.Filial_Id = i_Filial_Id
                 and a.Page_Id = q.Page_Id
                left join Htt_Timesheets t
                  on t.Company_Id = q.Company_Id
                 and t.Filial_Id = q.Filial_Id
                 and t.Staff_Id = q.Staff_Id
                 and t.Timesheet_Date = i_Adjustment_Date
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Journal_Id = i_Journal_Id)
    loop
      v_Adjustment := Glist;
    
      v_Adjustment.Push(r.Staff_Id);
      v_Adjustment.Push(r.Staff_Name);
      v_Adjustment.Push(r.Kind);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Intime,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Staff_Id     => r.Staff_Id,
                                    i_Time_Kind_Id => v_Turnout_Tk,
                                    i_Begin_Date   => i_Adjustment_Date,
                                    i_End_Date     => i_Adjustment_Date);
    
      -- plan begin and end time
      case r.Day_Kind
        when Htt_Pref.c_Day_Kind_Work then
          v_Adjustment.Push(to_char(r.Begin_Time, Href_Pref.c_Time_Format_Minute) || '-' ||
                            to_char(r.End_Time, Href_Pref.c_Time_Format_Minute));
        when Htt_Pref.c_Day_Kind_Rest then
          v_Adjustment.Push(t('rest day'));
        when Htt_Pref.c_Day_Kind_Holiday then
          v_Adjustment.Push(t('holiday'));
        when Htt_Pref.c_Day_Kind_Additional_Rest then
          v_Adjustment.Push(t('additional rest day'));
        when Htt_Pref.c_Day_Kind_Nonworking then
          v_Adjustment.Push(t('nonworking day'));
        else
          v_Adjustment.Push('');
      end case;
      v_Adjustment.Push(Trunc(r.Plan_Time / 60)); -- plan time
    
      -- fact begin and end time
      v_Adjustment.Push(Nvl(to_char(r.Input_Time, Href_Pref.c_Time_Format_Minute), t('no data')) || '-' ||
                        Nvl(to_char(r.Output_Time, Href_Pref.c_Time_Format_Minute), t('no data')));
      v_Adjustment.Push(Trunc(v_Intime / 60));
    
      v_Adjustment.Push(r.Free_Time);
      v_Adjustment.Push(r.Overtime);
      v_Adjustment.Push(r.Turnout_Time);
    
      v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id,
                                                   i_Staff_Id   => r.Staff_Id,
                                                   i_Begin_Date => v_Begin_Date,
                                                   i_End_Date   => v_End_Date);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Intime,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => i_Company_Id,
                                    i_Filial_Id    => i_Filial_Id,
                                    i_Staff_Id     => r.Staff_Id,
                                    i_Time_Kind_Id => v_Turnout_Tk,
                                    i_Begin_Date   => v_Begin_Date,
                                    i_End_Date     => v_End_Date);
    
      v_Not_Worked_Time := Trunc(Greatest(v_Plan_Time - v_Intime, 0) / 60);
    
      if i_Posted = 'Y' then
        v_Not_Worked_Time := v_Not_Worked_Time + r.Turnout_Time;
      end if;
    
      v_Adjustment.Push(v_Not_Worked_Time); -- not worked time
      v_Adjustment.Push(r.Page_Id);
    
      Result.Push(v_Adjustment);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Gmap is
    result Gmap := Gmap;
  begin
    Result.Put('divisions', Uit_Href.To_Glist(Uit_Hrm.Divisions(i_Division_Id => i_Division_Id)));
    Result.Put('org_units',
               Uit_Href.To_Glist(Uit_Hrm.Divisions(i_Division_Id   => i_Division_Id,
                                                   i_Is_Department => 'N')));
    Result.Put('adjustment_kinds', Uit_Href.To_Glist(Hpd_Util.Adjustment_Kinds));
    Result.Put('ak_full', Hpd_Pref.c_Adjustment_Kind_Full);
    Result.Put('ak_incomplete', Hpd_Pref.c_Adjustment_Kind_Incomplete);
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(P1 Json_Object_t) return Json_Object_t is
    v_Journal_Type_Id   number;
    v_Has_Sign_Template varchar2(1) := 'N';
    p                   Gmap := Gmap;
    result              Gmap := Gmap;
  begin
    p.Val := P1;
  
    v_Journal_Type_Id := p.r_Number('journal_type_id');
  
    if not Hpd_Util.Is_Timebook_Adjustment_Journal(i_Company_Id      => Ui.Company_Id,
                                                   i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('journal_date', Trunc(sysdate));
    Result.Put('adjustment_date', Trunc(sysdate) - 1);
    Result.Put('references', References);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(P1 Json_Object_t) return Json_Object_t is
    r_Journal              Hpd_Journals%rowtype;
    r_Timebook_Adjustment  Hpd_Journal_Timebook_Adjustments%rowtype;
    r_Division             Hrm_Divisions%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    p                      Gmap := Gmap;
    result                 Gmap := Gmap;
  begin
    p.Val := P1;
  
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not
        Hpd_Util.Is_Timebook_Adjustment_Journal(i_Company_Id      => Ui.Company_Id,
                                                i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null then
      Uit_Hpd.Check_Access_To_Edit_Journal(i_Document_Status => v_Sign_Document_Status,
                                           i_Posted          => r_Journal.Posted,
                                           i_Journal_Number  => r_Journal.Journal_Number);
      v_Has_Sign_Document := 'Y';
    end if;
  
    for r in (select s.Staff_Id
                from Hpd_Journal_Staffs s
               where s.Company_Id = r_Journal.Company_Id
                 and s.Filial_Id = r_Journal.Filial_Id
                 and s.Journal_Id = r_Journal.Journal_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(r.Staff_Id);
    end loop;
  
    Result.Put('journal_id', r_Journal.Journal_Id);
    Result.Put('journal_number', r_Journal.Journal_Number);
    Result.Put('journal_date', to_char(r_Journal.Journal_Date, Href_Pref.c_Date_Format_Day));
    Result.Put('journal_name', r_Journal.Journal_Name);
    Result.Put('posted', r_Journal.Posted);
  
    r_Timebook_Adjustment := z_Hpd_Journal_Timebook_Adjustments.Load(i_Company_Id => r_Journal.Company_Id,
                                                                     i_Filial_Id  => r_Journal.Filial_Id,
                                                                     i_Journal_Id => r_Journal.Journal_Id);
    r_Division            := z_Hrm_Divisions.Take(i_Company_Id  => r_Journal.Company_Id,
                                                  i_Filial_Id   => r_Journal.Filial_Id,
                                                  i_Division_Id => r_Timebook_Adjustment.Division_Id);
  
    Result.Put('division_id', r_Timebook_Adjustment.Division_Id);
    Result.Put('departments_filter', Nvl(r_Division.Is_Department, 'Y'));
    Result.Put('adjustment_date', r_Timebook_Adjustment.Adjustment_Date);
    Result.Put('adjustments',
               Get_Adjustments(i_Company_Id      => r_Journal.Company_Id,
                               i_Filial_Id       => r_Journal.Filial_Id,
                               i_Journal_Id      => r_Journal.Journal_Id,
                               i_Posted          => r_Journal.Posted,
                               i_Adjustment_Date => r_Timebook_Adjustment.Adjustment_Date));
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References(r_Timebook_Adjustment.Division_Id));
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Journal_Id number,
    P1           Json_Object_t
  ) return Json_Object_t is
    p              Gmap := Gmap;
    p_Journal      Hpd_Pref.Timebook_Adjustment_Journal_Rt;
    p_Adjustment   Hpd_Pref.Adjustment_Rt;
    v_Adjustments  Glist;
    v_Kinds        Glist;
    v_Adjustment   Gmap;
    v_Kind         Gmap;
    v_Turnout_Time number;
    v_Overtime     number;
    v_Page_Id      number;
    v_Staff_Id     number;
    result         Gmap := Gmap;
  begin
    p.Val         := P1;
    v_Adjustments := p.r_Glist('adjustments');
  
    Hpd_Util.Timebook_Adjustment_Journal_New(o_Journal         => p_Journal,
                                             i_Company_Id      => Ui.Company_Id,
                                             i_Filial_Id       => Ui.Filial_Id,
                                             i_Journal_Id      => i_Journal_Id,
                                             i_Journal_Number  => p.o_Varchar2('journal_number'),
                                             i_Journal_Date    => p.r_Date('journal_date'),
                                             i_Journal_Name    => p.o_Varchar2('journal_name'),
                                             i_Division_Id     => p.r_Number('division_id'),
                                             i_Adjustment_Date => p.r_Date('adjustment_date'),
                                             i_Lang_Code       => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Adjustments.Count
    loop
      v_Adjustment     := Gmap;
      v_Adjustment.Val := v_Adjustments.r_Gmap(i);
    
      v_Staff_Id := v_Adjustment.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(v_Staff_Id);
    
      v_Page_Id := v_Adjustment.o_Number('page_id');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      Hpd_Util.Adjustment_New(o_Adjustment => p_Adjustment,
                              i_Page_Id    => v_Page_Id,
                              i_Staff_Id   => v_Staff_Id);
    
      v_Kinds := v_Adjustment.r_Glist('kinds');
    
      for j in 1 .. v_Kinds.Count
      loop
        v_Kind     := Gmap;
        v_Kind.Val := v_Kinds.r_Gmap(j);
      
        v_Turnout_Time := v_Kind.r_Number('turnout_time');
        v_Overtime     := v_Kind.r_Number('overtime');
      
        continue when v_Turnout_Time = 0 and v_Overtime = 0;
      
        Hpd_Util.Adjustment_Add_Kind(p_Adjustment   => p_Adjustment,
                                     i_Kind         => v_Kind.r_Varchar2('kind'),
                                     i_Free_Time    => v_Kind.r_Number('free_time'),
                                     i_Overtime     => v_Overtime,
                                     i_Turnout_Time => v_Turnout_Time);
      end loop;
    
      continue when p_Adjustment.Kinds.Count = 0;
    
      Hpd_Util.Timebook_Adjustment_Add_Adjustment(p_Journal    => p_Journal,
                                                  i_Adjustment => p_Adjustment);
    end loop;
  
    Hpd_Api.Timebook_Adjustment_Journal_Save(p_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  
    Result.Put('journal_id', i_Journal_Id);
    Result.Put('journal_name', p_Journal.Journal_Name);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(P1 Json_Object_t) return Json_Object_t is
  begin
    return save(Hpd_Next.Journal_Id, P1);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(P1 Json_Object_t) return Json_Object_t is
    r_Journal Hpd_Journals%rowtype;
    v_Repost  boolean;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => P1.Get_Number('journal_id'));
  
    v_Repost := r_Journal.Posted = 'Y' and P1.Get_String('posted') = 'Y';
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => v_Repost);
    end if;
  
    return save(r_Journal.Journal_Id, P1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Employee_Id     = null,
           Org_Unit_Id     = null,
           Hiring_Date     = null,
           Dismissal_Date  = null,
           Employment_Type = null,
           Division_Id     = null,
           Staff_Kind      = null,
           State           = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr497;
/
