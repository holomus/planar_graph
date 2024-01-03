create or replace package Ui_Vhr218 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Timesheet(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Monthly_Limit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model_Personal return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr218;
/
create or replace package body Ui_Vhr218 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.employee_id <> :user_id
                   and q.hiring_date <= :current_date
                   and (q.dismissal_date is null or q.dismissal_date >= :current_date)
                   and q.state = ''A''';
  
    v_Query := Uit_Href.Make_Subordinated_Query(v_Query, i_Include_Manual => true);
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'user_id',
                             Ui.User_Id,
                             'current_date',
                             Trunc(sysdate));
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
    q.Map_Field('name',
                'select p.name
                   from mr_natural_persons p
                  where p.company_id = $company_id
                    and p.person_id = $employee_id');
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Assert_Access(i_Staff_Id number) is
    v_Personal boolean := Ui.Request_Mode like '%_personal';
  begin
    if v_Personal then
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => i_Staff_Id,
                                      i_All      => false,
                                      i_Self     => true,
                                      i_Direct   => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    else
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => i_Staff_Id, --
                                      i_Self     => false);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheet(p Hashmap) return Hashmap is
    r_Timesheet Htt_Timesheets%rowtype;
    v_Staff_Id  number := p.r_Number('staff_id');
    result      Hashmap;
  begin
    r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Staff_Id       => v_Staff_Id,
                                      i_Timesheet_Date => p.r_Date('timesheet_date'));
  
    Assert_Access(v_Staff_Id);
  
    result := z_Htt_Timesheets.To_Map(r_Timesheet,
                                      z.Timesheet_Date,
                                      z.Timesheet_Date,
                                      z.Day_Kind,
                                      z.Break_Enabled,
                                      z.Plan_Time);
  
    Result.Put('begin_time', to_char(r_Timesheet.Begin_Time, Href_Pref.c_Time_Format_Minute));
  
    Result.Put('end_time', to_char(r_Timesheet.End_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('break_begin_time',
               to_char(r_Timesheet.Break_Begin_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('break_end_time',
               to_char(r_Timesheet.Break_End_Time, Href_Pref.c_Time_Format_Minute));
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Monthly_Limit(p Hashmap) return Hashmap is
    v_Staff_Id         number := p.r_Number('staff_id');
    v_Month            date := p.r_Date('change_date');
    v_Employee_Id      number;
    v_Change_Day_Limit Hes_Pref.Change_Day_Limit_Rt;
    result             Hashmap := Hashmap();
  begin
    v_Employee_Id := Href_Util.Get_Employee_Id(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Staff_Id   => v_Staff_Id);
  
    v_Change_Day_Limit := Hes_Util.Staff_Change_Day_Limit_Settings(i_Company_Id => Ui.Company_Id,
                                                                   i_Filial_Id  => Ui.Filial_Id,
                                                                   i_User_Id    => v_Employee_Id);
    Result.Put('change_with_monthly_limit', v_Change_Day_Limit.Change_With_Monthly_Limit);
    Result.Put('change_monthly_limit', v_Change_Day_Limit.Change_Monthly_Limit);
    Result.Put('staff_change_monthly_count',
               Htt_Util.Get_Staff_Change_Monthly_Count(i_Company_Id => Ui.Company_Id,
                                                       i_Filial_Id  => Ui.Filial_Id,
                                                       i_Staff_Id   => v_Staff_Id,
                                                       i_Month      => v_Month));
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Personal_Mode    varchar2(1);
    v_Note_Is_Required varchar2(1) := Href_Util.Plan_Change_Note_Is_Required(Ui.Company_Id);
    result             Hashmap;
  begin
    v_Personal_Mode := case
                         when Ui.Request_Mode like '%_personal' then
                          'Y'
                         else
                          'N'
                       end;
  
    result := Fazo.Zip_Map('current_date',
                           Trunc(sysdate),
                           'personal_mode',
                           v_Personal_Mode,
                           'personal_staff_id',
                           Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                          i_Filial_Id   => Ui.Filial_Id,
                                                          i_Employee_Id => Ui.User_Id,
                                                          i_Date        => Trunc(sysdate)),
                           'note_is_required',
                           v_Note_Is_Required);
  
    if v_Note_Is_Required = 'Y' then
      Result.Put('note_limit', Href_Util.Load_Plan_Change_Note_Limit(Ui.Company_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('change_kind', Htt_Pref.c_Change_Kind_Swap);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model_Personal return Hashmap is
    v_Staff_Id number;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => Ui.User_Id,
                                                 i_Date        => Trunc(sysdate));
  
    Assert_Access(v_Staff_Id);
  
    return Add_Model;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data        Htt_Plan_Changes%rowtype;
    v_Matrix      Matrix_Varchar2;
    v_Change_Date varchar2(10);
    result        Hashmap;
  begin
    r_Data := z_Htt_Plan_Changes.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Change_Id  => p.r_Number('change_id'));
  
    Assert_Access(r_Data.Staff_Id);
  
    result := z_Htt_Plan_Changes.To_Map(r_Data,
                                        z.Change_Id,
                                        z.Change_Kind,
                                        z.Staff_Id,
                                        z.Status,
                                        z.Note,
                                        z.Created_On);
  
    Result.Put('staff_name',
               Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                    i_Filial_Id  => r_Data.Filial_Id,
                                    i_Staff_Id   => r_Data.Staff_Id));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
  
    select Array_Varchar2(to_char(q.Change_Date, Href_Pref.c_Date_Format_Day),
                          to_char(q.Swapped_Date, Href_Pref.c_Date_Format_Day),
                          q.Day_Kind,
                          to_char(q.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(q.End_Time, Href_Pref.c_Time_Format_Minute),
                          q.Break_Enabled,
                          to_char(q.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(q.Break_End_Time, Href_Pref.c_Time_Format_Minute),
                          q.Plan_Time)
      bulk collect
      into v_Matrix
      from Htt_Change_Days q
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Change_Id = r_Data.Change_Id;
  
    if r_Data.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
      v_Change_Date := v_Matrix(1) (1);
      v_Matrix(1)(1) := v_Matrix(2) (1);
      v_Matrix(2)(1) := v_Change_Date;
    end if;
  
    Result.Put('change_dates', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Change_Id number,
    p           Hashmap
  ) is
    v_Change           Htt_Pref.Change_Rt;
    v_Staff_Id         number;
    v_Break_Enabled    varchar2(1);
    v_Day_Kind         varchar2(1);
    v_Begin_Time       date;
    v_End_Time         date;
    v_Break_Begin_Time date;
    v_Break_End_Time   date;
    v_Plan_Time        number;
    v_Item             Hashmap;
    v_Items            Arraylist := p.r_Arraylist('change_dates');
  begin
    v_Staff_Id := z_Htt_Plan_Changes.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Change_Id => i_Change_Id).Staff_Id;
  
    if v_Staff_Id is null then
      v_Staff_Id := p.r_Number('staff_id');
    end if;
  
    Assert_Access(v_Staff_Id);
  
    Htt_Util.Change_New(o_Change      => v_Change,
                        i_Company_Id  => Ui.Company_Id,
                        i_Filial_Id   => Ui.Filial_Id,
                        i_Change_Id   => i_Change_Id,
                        i_Staff_Id    => v_Staff_Id,
                        i_Change_Kind => p.r_Varchar2('change_kind'),
                        i_Note        => p.o_Varchar2('note'));
  
    for i in 1 .. v_Items.Count
    loop
      v_Item             := Treat(v_Items.r_Hashmap(i) as Hashmap);
      v_Day_Kind         := v_Item.r_Varchar2('day_kind');
      v_Begin_Time       := to_date(v_Item.r_Varchar2('change_date') || ' ' ||
                                    v_Item.r_Varchar2('begin_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_End_Time         := to_date(v_Item.r_Varchar2('change_date') || ' ' ||
                                    v_Item.r_Varchar2('end_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_Break_Enabled    := v_Item.o_Varchar2('break_enabled');
      v_Break_Begin_Time := to_date(v_Item.r_Varchar2('change_date') || ' ' ||
                                    v_Item.r_Varchar2('break_begin_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_Break_End_Time   := to_date(v_Item.r_Varchar2('change_date') || ' ' ||
                                    v_Item.r_Varchar2('break_end_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_Plan_Time        := v_Item.r_Number('plan_time');
    
      if v_Day_Kind in (Htt_Pref.c_Day_Kind_Rest,
                        Htt_Pref.c_Day_Kind_Holiday,
                        Htt_Pref.c_Day_Kind_Additional_Rest) or v_Day_Kind is null then
        v_Begin_Time       := null;
        v_End_Time         := null;
        v_Break_Enabled    := null;
        v_Break_Begin_Time := null;
        v_Break_End_Time   := null;
        v_Plan_Time        := null;
      
        if v_Day_Kind is not null then
          v_Plan_Time := 0;
        end if;
      else
        v_Break_Enabled := Nvl(v_Break_Enabled, 'N');
      
        if v_End_Time <= v_Begin_Time then
          v_End_Time := v_End_Time + 1;
        end if;
      
        if v_Break_Enabled = 'Y' then
          if v_Break_Begin_Time <= v_Begin_Time then
            v_Break_Begin_Time := v_Break_Begin_Time + 1;
          end if;
        
          if v_Break_End_Time <= v_Break_Begin_Time then
            v_Break_End_Time := v_Break_End_Time + 1;
          end if;
        
        else
          v_Break_Begin_Time := null;
          v_Break_End_Time   := null;
        end if;
      end if;
    
      Htt_Util.Change_Day_Add(o_Change           => v_Change,
                              i_Change_Date      => v_Item.r_Date('change_date'),
                              i_Swapped_Date     => v_Item.o_Date('swapped_date'),
                              i_Day_Kind         => v_Day_Kind,
                              i_Begin_Time       => v_Begin_Time,
                              i_End_Time         => v_End_Time,
                              i_Break_Enabled    => v_Break_Enabled,
                              i_Break_Begin_Time => v_Break_Begin_Time,
                              i_Break_End_Time   => v_Break_End_Time,
                              i_Plan_Time        => v_Plan_Time);
    end loop;
  
    Htt_Api.Change_Save(v_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Htt_Next.Change_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------

  Procedure Edit(p Hashmap) is
  begin
    save(p.r_Number('change_id'), p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Staff_Kind     = null,
           State          = null;
    update Htt_Plan_Changes
       set Company_Id  = null,
           Filial_Id   = null,
           Change_Id   = null,
           Staff_Id    = null,
           Change_Kind = null,
           Note        = null,
           Status      = null,
           Created_By  = null,
           Created_On  = null;
    update Htt_Change_Days
       set Company_Id       = null,
           Filial_Id        = null,
           Change_Id        = null,
           Change_Date      = null,
           Swapped_Date     = null,
           Staff_Id         = null,
           Day_Kind         = null,
           Begin_Time       = null,
           End_Time         = null,
           Break_Enabled    = null,
           Break_Begin_Time = null,
           Break_End_Time   = null,
           Plan_Time        = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr218;
/
