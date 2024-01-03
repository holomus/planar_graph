create or replace package Ui_Vhr163 is
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr163;
/
create or replace package body Ui_Vhr163 is
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
    return b.Translate('UI-VHR163:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Filial_Id number) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Time_Kind_Id, t.Name)
      bulk collect
      into v_Matrix
      from Htt_Time_Kinds t
     where t.Company_Id = Ui.Company_Id
       and t.Pcode is not null
     order by t.Pcode;
  
    Result.Put('time_kinds', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('period_kind_full_month', Hpr_Pref.c_Period_Full_Month);
    Result.Put('settings',
               Hpr_Util.Load_Timebook_Fill_Settings(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => i_Filial_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_User_Id     number := Ui.User_Id;
    v_Timebook_Id number := p.r_Number('timebook_id');
  begin
    Hpr_Api.Timebook_Post(i_Company_Id  => v_Company_Id,
                          i_Filial_Id   => v_Filial_Id,
                          i_Timebook_Id => v_Timebook_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpr_Util.t_Notification_Title_Timebook_Post(i_Company_Id      => v_Company_Id,
                                                                                               i_User_Id         => v_User_Id,
                                                                                               i_Timebook_Number => p.r_Varchar2('timebook_number'),
                                                                                               i_Month           => p.r_Date('month',
                                                                                                                             'month yyyy')),
                                i_Uri           => Hpr_Pref.c_Form_Timebook_View,
                                i_Uri_Param     => Fazo.Zip_Map('timebook_id', v_Timebook_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_User_Id     number := Ui.User_Id;
    v_Timebook_Id number := p.r_Number('timebook_id');
  begin
    Hpr_Api.Timebook_Unpost(i_Company_Id  => v_Company_Id,
                            i_Filial_Id   => v_Filial_Id,
                            i_Timebook_Id => v_Timebook_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpr_Util.t_Notification_Title_Timebook_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                 i_User_Id         => v_User_Id,
                                                                                                 i_Timebook_Number => p.r_Varchar2('timebook_number'),
                                                                                                 i_Month           => p.r_Date('month',
                                                                                                                               'month yyyy')),
                                i_Uri           => Hpr_Pref.c_Form_Timebook_View,
                                i_Uri_Param     => Fazo.Zip_Map('timebook_id', v_Timebook_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Timebook      Hpr_Timebooks%rowtype;
    v_Staff_Ids     Array_Number;
    v_Facts_Changed varchar2(1);
    v_Filial_Id     number := Ui.Filial_Id;
    v_Totals        Matrix_Varchar2;
    v_Fact_Totals   Matrix_Varchar2;
    v_Staffs        Hashmap := Hashmap();
    result          Hashmap;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Timebook_Id => p.r_Number('timebook_id'));
  
    for r in (select t.Staff_Id
                from Hpr_Timebook_Staffs t
               where t.Company_Id = r_Timebook.Company_Id
                 and t.Filial_Id = r_Timebook.Filial_Id
                 and t.Timebook_Id = r_Timebook.Timebook_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(r.Staff_Id);
    end loop;
  
    result := z_Hpr_Timebooks.To_Map(r_Timebook,
                                     z.Timebook_Id,
                                     z.Timebook_Number,
                                     z.Timebook_Date,
                                     z.Period_Kind,
                                     z.Posted,
                                     z.Note,
                                     z.Created_On,
                                     z.Modified_On);
  
    Result.Put('month', to_char(r_Timebook.Month, 'Month yyyy'));
    Result.Put('period_begin', to_char(r_Timebook.Period_Begin, Href_Pref.c_Date_Format_Day));
    Result.Put('period_end', to_char(r_Timebook.Period_End, Href_Pref.c_Date_Format_Day));
    Result.Put('posted_name',
               Md_Util.Decode(r_Timebook.Posted, --
                              'Y',
                              t('posted'), --
                              'N',
                              t('unposted')));
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Timebook.Company_Id, --
               i_Filial_Id => r_Timebook.Filial_Id, --
               i_Division_Id => r_Timebook.Division_Id).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Timebook.Company_Id, --
               i_User_Id => r_Timebook.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Timebook.Company_Id, --
               i_User_Id => r_Timebook.Modified_By).Name);
  
    begin
      select 'Y'
        into v_Facts_Changed
        from Hpr_Timesheet_Locks w
        join Htt_Timesheet_Locks s
          on s.Company_Id = w.Company_Id
         and s.Filial_Id = w.Filial_Id
         and s.Staff_Id = w.Staff_Id
         and s.Timesheet_Date = w.Timesheet_Date
         and s.Facts_Changed = 'Y'
       where w.Company_Id = r_Timebook.Company_Id
         and w.Filial_Id = r_Timebook.Filial_Id
         and w.Timebook_Id = r_Timebook.Timebook_Id
         and Rownum = 1;
    exception
      when No_Data_Found then
        v_Facts_Changed := 'N';
    end;
  
    Result.Put('facts_changed', v_Facts_Changed);
  
    select Array_Varchar2(Ts.Staff_Id,
                          q.Staff_Number,
                          (select Np.Name
                             from Mr_Natural_Persons Np
                            where Np.Company_Id = q.Company_Id
                              and Np.Person_Id = q.Employee_Id),
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = Ts.Company_Id
                              and j.Filial_Id = Ts.Filial_Id
                              and j.Job_Id = Ts.Job_Id),
                          (select m.Name
                             from Mhr_Divisions m
                            where m.Company_Id = Ts.Company_Id
                              and m.Filial_Id = Ts.Filial_Id
                              and m.Division_Id = Ts.Division_Id),
                          (select s.Name
                             from Htt_Schedules s
                            where s.Company_Id = Ts.Company_Id
                              and s.Filial_Id = Ts.Filial_Id
                              and s.Schedule_Id = Ts.Schedule_Id),
                          Ts.Plan_Days,
                          Ts.Plan_Hours,
                          Ts.Fact_Days,
                          Ts.Fact_Hours),
           Ts.Staff_Id
      bulk collect
      into v_Totals, v_Staff_Ids
      from Hpr_Timebook_Staffs Ts
      join Href_Staffs q
        on q.Company_Id = Ts.Company_Id
       and q.Filial_Id = Ts.Filial_Id
       and q.Staff_Id = Ts.Staff_Id
     where Ts.Company_Id = r_Timebook.Company_Id
       and Ts.Filial_Id = r_Timebook.Filial_Id
       and Ts.Timebook_Id = r_Timebook.Timebook_Id;
  
    select Array_Varchar2(Tf.Staff_Id, Tf.Time_Kind_Id, Tf.Fact_Hours)
      bulk collect
      into v_Fact_Totals
      from Hpr_Timebook_Facts Tf
     where Tf.Company_Id = r_Timebook.Company_Id
       and Tf.Filial_Id = r_Timebook.Filial_Id
       and Tf.Timebook_Id = r_Timebook.Timebook_Id;
  
    v_Staffs.Put('totals', Fazo.Zip_Matrix(v_Totals));
    v_Staffs.Put('fact_totals', Fazo.Zip_Matrix(v_Fact_Totals));
    v_Staffs.Put('facts',
                 Uit_Hpr.Get_Staff_Facts(i_Staff_Ids    => v_Staff_Ids,
                                         i_Period_Begin => r_Timebook.Period_Begin,
                                         i_Period_End   => r_Timebook.Period_End));
  
    Result.Put('staffs', v_Staffs);
  
    if v_Filial_Id is not null then
      Result.Put('filial_name',
                 z_Md_Filials.Load(i_Company_Id => r_Timebook.Company_Id, i_Filial_Id => v_Filial_Id).Name);
    end if;
  
    Result.Put('references', References(v_Filial_Id));
  
    return result;
  end;

end Ui_Vhr163;
/
