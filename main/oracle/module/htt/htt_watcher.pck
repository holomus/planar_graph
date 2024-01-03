create or replace package Htt_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure On_Filial_Add(i_Filial Md_Global.Filial_Rt);
end Htt_Watcher;
/
create or replace package body Htt_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number) is
    v_Company_Head number := Md_Pref.c_Company_Head;
    v_Pc_Like      varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query        varchar2(4000);
    r_Time_Kind    Htt_Time_Kinds%rowtype;
    r_Parent       Htt_Time_Kinds%rowtype;
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
    -- add pin lock
    z_Htt_Pin_Locks.Insert_One(i_Company_Id);
  
    -- add default time kinds
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Time_Kinds,
                                                i_Lang_Code => z_Md_Companies.Load(i_Company_Id).Lang_Code);
  
    for r in (select *
                from Htt_Time_Kinds t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pc_Like
               order by t.Time_Kind_Id)
    loop
      r_Time_Kind              := r;
      r_Time_Kind.Company_Id   := i_Company_Id;
      r_Time_Kind.Time_Kind_Id := Htt_Next.Time_Kind_Id;
    
      if r_Time_Kind.Parent_Id is not null then
        r_Parent              := z_Htt_Time_Kinds.Load(i_Company_Id   => r.Company_Id,
                                                       i_Time_Kind_Id => r.Parent_Id);
        r_Time_Kind.Parent_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                       i_Pcode      => r_Parent.Pcode);
      end if;
    
      execute immediate v_Query
        using in r_Time_Kind, out r_Time_Kind;
    
      z_Htt_Time_Kinds.Save_Row(r_Time_Kind);
    end loop;
  
    -- add default request kinds
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Request_Kinds,
                                                i_Lang_Code => z_Md_Companies.Load(i_Company_Id).Lang_Code);
  
    for r in (select t.*
                from Htt_Request_Kinds t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pc_Like)
    loop
      r_Request_Kind                 := r;
      r_Request_Kind.Company_Id      := i_Company_Id;
      r_Request_Kind.Request_Kind_Id := Htt_Next.Request_Kind_Id;
    
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => r.Company_Id,
                                           i_Time_Kind_Id => r.Time_Kind_Id);
    
      r_Request_Kind.Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                           i_Pcode      => r_Time_Kind.Pcode);
    
      execute immediate v_Query
        using in r_Request_Kind, out r_Request_Kind;
    
      z_Htt_Request_Kinds.Save_Row(r_Request_Kind);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure On_Filial_Add(i_Filial Md_Global.Filial_Rt) is
    v_Company_Head number := Md_Pref.c_Company_Head;
    v_Pc_Like      varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query        varchar2(4000);
    v_Lang_Code    Md_Companies.Lang_Code%type := z_Md_Companies.Load(i_Filial.Company_Id).Lang_Code;
    r_Calendar     Htt_Calendars%rowtype;
    r_Schedule     Htt_Schedules%rowtype;
  begin
    -- calendar
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Calendars,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Htt_Calendars c
               where c.Company_Id = v_Company_Head
                 and c.Filial_Id = Md_Pref.Filial_Head(v_Company_Head)
                 and c.Pcode like v_Pc_Like)
    loop
      r_Calendar             := r;
      r_Calendar.Company_Id  := i_Filial.Company_Id;
      r_Calendar.Filial_Id   := i_Filial.Filial_Id;
      r_Calendar.Calendar_Id := Htt_Next.Calendar_Id;
    
      execute immediate v_Query
        using in r_Calendar, out r_Calendar;
    
      z_Htt_Calendars.Save_Row(r_Calendar);
    end loop;
  
    -- schedule
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Schedules,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Htt_Schedules c
               where c.Company_Id = v_Company_Head
                 and c.Filial_Id = Md_Pref.Filial_Head(v_Company_Head)
                 and c.Pcode like v_Pc_Like)
    loop
      r_Schedule             := r;
      r_Schedule.Company_Id  := i_Filial.Company_Id;
      r_Schedule.Filial_Id   := i_Filial.Filial_Id;
      r_Schedule.Schedule_Id := Htt_Next.Schedule_Id;
    
      execute immediate v_Query
        using in r_Schedule, out r_Schedule;
    
      z_Htt_Schedules.Save_Row(r_Schedule);
    end loop;
  end;

end Htt_Watcher;
/
