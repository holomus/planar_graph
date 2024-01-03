prompt migr 10.05.2021
set define off
set serveroutput on

prompt changes in htt_schedules
create unique index htt_schedules_u4 on htt_schedules(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

prompt changes in htt_schedule_dates
alter table htt_schedule_dates drop constraint htt_schedule_dates_c4; 
alter table htt_schedule_dates drop constraint htt_schedule_dates_c5;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c6;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c7;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c8;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c9;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c10;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c11;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c11;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c12;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c13;
alter table htt_schedule_dates drop constraint htt_schedule_dates_c14;

alter table htt_schedule_dates add constraint htt_schedule_dates_c4 check (decode(day_kind, 'W', 3, 0) = nvl2(begin_time, 1, 0) + nvl2(end_time, 1, 0) + nvl2(break_enabled, 1, 0));
alter table htt_schedule_dates add constraint htt_schedule_dates_c5 check (decode(break_enabled, 'Y', 2, 0) = nvl2(break_begin_time, 1, 0) + nvl2(break_end_time, 1, 0));
alter table htt_schedule_dates add constraint htt_schedule_dates_c6 check (plan_time <= full_time and 0 <= plan_time and full_time <= 1440);
alter table htt_schedule_dates add constraint htt_schedule_dates_c7 check (trunc(begin_time) = schedule_date);
alter table htt_schedule_dates add constraint htt_schedule_dates_c8 check (begin_time < end_time);
alter table htt_schedule_dates add constraint htt_schedule_dates_c9 check (break_begin_time < break_end_time) ;
alter table htt_schedule_dates add constraint htt_schedule_dates_c10 check (begin_time <= break_begin_time and break_end_time <= end_time) ;
alter table htt_schedule_dates add constraint htt_schedule_dates_c11 check (shift_begin_time < shift_end_time);
alter table htt_schedule_dates add constraint htt_schedule_dates_c12 check (shift_begin_time <= begin_time and end_time <= shift_end_time);

prompt changes in href_labor_functions
create unique index href_labor_functions_u2 on href_labor_functions(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

alter table hpr_oper_type_templates modify oper_group_id null;
alter table hpr_oper_types modify oper_group_id null;

alter table htt_devices drop constraint htt_devices_u2;
alter table htt_devices add constraint htt_devices_u2 unique (company_id, device_type_id, serial_number) using index tablespace GWS_INDEX;

declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  --------------------------------------------------
  Procedure Document_Type
  (
    a varchar2,
    b varchar2
  ) is
    v_Document_Type_Id number;
  begin
    begin
      select Doc_Type_Id
        into v_Document_Type_Id
        from Href_Document_Types
       where Company_Id = v_Company_Head
         and Pcode = b;
    exception
      when No_Data_Found then
        v_Document_Type_Id := Href_Next.Document_Type_Id;
    end;
  
    z_Href_Document_Types.Save_One(i_Company_Id  => v_Company_Head,
                                   i_Doc_Type_Id => v_Document_Type_Id,
                                   i_Name        => a,
                                   i_State       => 'A',
                                   i_Pcode       => b);
  end;
  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    a varchar2,
    b varchar2,
    c varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => a,
                                                    i_Column_Set  => b,
                                                    i_Extra_Where => c);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Document Types ====');
  Document_Type('Паспорт (по умолчанию)',
                Href_Pref.c_Pcode_Document_Type_Default_Passport);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translate ====');
  Table_Record_Setting('HREF_DOCUMENT_TYPES', 'NAME');
  commit;
end;
/

declare
  v_Company_Head number := Md_Pref.Company_Head;
begin
  -- looping in companies (not company head)
  for r in (select *
              from Md_Companies q
             where q.State = 'A'
               and q.Company_Id <> v_Company_Head)
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;

    Ui_Auth.Logon_As_System(r.Company_Id);

    -- adding href settings this company data
    begin
      Href_Watcher.On_Company_Add(r.Company_Id);
    exception
      when others then
        null;
    end;
  end loop;
  commit;
end;
/
