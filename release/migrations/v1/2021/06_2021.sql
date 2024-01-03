prompt migr 10.06.2021
set define off
set serveroutput on

----------------------------------------------------------------------------------------------------                       
-- Wage change
----------------------------------------------------------------------------------------------------                       
create table hpd_wage_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  change_date                     date       not null,
  constraint hpd_wage_changes_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,  
  constraint hpd_wage_changes_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_wage_changes_c1 check (trunc(change_date) = change_date)
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
-- Schedule change
----------------------------------------------------------------------------------------------------        
create table hpd_schedule_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  schedule_id                     number(20) not null,
  begin_date                      date       not null,
  end_date                        date,
  constraint hpd_schedule_changes_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_schedule_changes_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_schedule_changes_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_schedule_changes_f3 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpd_schedule_changes_c1 check (begin_date = trunc(begin_date)),
  constraint hpd_schedule_changes_c2 check (end_date = trunc(end_date)),  
  constraint hpd_schedule_changes_c3 check (begin_date <= end_date)
) tablespace GWS_DATA;

create index hpd_schedule_changes_i1 on hpd_schedule_changes(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_schedule_changes_i2 on hpd_schedule_changes(company_id, filial_id, schedule_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt changes in htt_schedule_dates    
alter table htt_schedule_dates drop constraint htt_schedule_dates_f1;
alter table htt_schedule_dates add constraint htt_schedule_dates_f1 foreign key (company_id, schedule_id) references htt_schedules(company_id, schedule_id) on delete cascade;

declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  --------------------------------------------------
  Procedure Journal_Type
  (
    a varchar2,
    b number,
    c varchar2
  ) is
    v_Journal_Type_Id number;
  begin
    begin
      select Journal_Type_Id
        into v_Journal_Type_Id
        from Hpd_Journal_Types
       where Company_Id = v_Company_Head
         and Pcode = c;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => v_Company_Head,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => a,
                                 i_Order_No        => b,
                                 i_Pcode           => c);
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
  Dbms_Output.Put_Line('==== Journal Types ====');
  Journal_Type('Прием на работу', 1, Hpd_Pref.c_Pcode_Journal_Type_Hiring);
  Journal_Type('Прием на работу списком',
               2,
               Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
  Journal_Type('Кадровый перевод', 3, Hpd_Pref.c_Pcode_Journal_Type_Transfer);
  Journal_Type('Кадровый перевод списком',
               4,
               Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
  Journal_Type('Увольнение', 5, Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
  Journal_Type('Увольнение списком',
               6,
               Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple);
  Journal_Type('Изменение оплаты труда', 7, Hpd_Pref.c_Pcode_Journal_Type_Wage_Change);
  Journal_Type('Изменения графика работы списком',
               8,
               Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translate ====');
  Table_Record_Setting('HPD_JOURNAL_TYPES', 'NAME');
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Easy report templates ====');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Hiring,
                              i_Name     => 'Приказ о приеме на работу',
                              i_Order_No => 1,
                              i_Pcode    => 'vhr:hpd:1');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Hiring_Multiple,
                              i_Name     => 'Приказ о приеме на работу списком',
                              i_Order_No => 2,
                              i_Pcode    => 'vhr:hpd:2');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Transfer,
                              i_Name     => 'Приказ о кадровом переводе',
                              i_Order_No => 3,
                              i_Pcode    => 'vhr:hpd:3');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Transfer_Multiple,
                              i_Name     => 'Приказ о кадровом переводе списком',
                              i_Order_No => 4,
                              i_Pcode    => 'vhr:hpd:4');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Dismissal,
                              i_Name     => 'Приказ об увольнении',
                              i_Order_No => 5,
                              i_Pcode    => 'vhr:hpd:5');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Dismissal_Multiple,
                              i_Name     => 'Приказ об увольнении списком',
                              i_Order_No => 6,
                              i_Pcode    => 'vhr:hpd:6');
  commit;
end;
/
