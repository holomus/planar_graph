prompt migr from 01.02.2022 dml
----------------------------------------------------------------------------------------------------
prompt vacation settings
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id         number;
  v_Estimation_Formula varchar2(300 char);
  v_Identifier         Href_Indicators.Identifier%type;

  --------------------------------------------------
  Procedure Indicator
  (
    i_Name       varchar2,
    i_Short_Name varchar2,
    i_Identifier varchar2,
    i_Used       varchar2,
    i_Pcode      varchar2
  ) is
    v_Indicator_Id number;
  begin
    begin
      select Indicator_Id
        into v_Indicator_Id
        from Href_Indicators
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Id := Href_Next.Indicator_Id;
    end;
  
    z_Href_Indicators.Save_One(i_Company_Id   => v_Company_Id,
                               i_Indicator_Id => v_Indicator_Id,
                               i_Name         => i_Name,
                               i_Short_Name   => i_Short_Name,
                               i_Identifier   => i_Identifier,
                               i_Used         => i_Used,
                               i_State        => 'A',
                               i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Operation_Group
  (
    i_Operation_Kind     varchar2,
    i_Name               varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Pcode              varchar2
  ) is
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Group_Id
        into v_Oper_Group_Id
        from Hpr_Oper_Groups
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    end;
  
    z_Hpr_Oper_Groups.Save_One(i_Company_Id         => v_Company_Id,
                               i_Oper_Group_Id      => v_Oper_Group_Id,
                               i_Operation_Kind     => i_Operation_Kind,
                               i_Name               => i_Name,
                               i_Estimation_Type    => i_Estimation_Type,
                               i_Estimation_Formula => i_Estimation_Formula,
                               i_Pcode              => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Oper_Type
  (
    i_Name               varchar2,
    i_Short_Name         varchar2,
    i_Oper_Group_Pcode   varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Operation_Kind     varchar2,
    i_Oper_Type_Pcode    varchar2
  ) is
    v_Oper_Type     Hpr_Pref.Oper_Type_Rt;
    v_Oper_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Type_Id
        into v_Oper_Type_Id
        from Hpr_Oper_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Oper_Type_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Type_Id := Mpr_Next.Oper_Type_Id;
    end;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                           i_Company_Id             => v_Company_Id,
                           i_Oper_Type_Id           => v_Oper_Type_Id,
                           i_Oper_Group_Id          => v_Oper_Group_Id,
                           i_Estimation_Type        => i_Estimation_Type,
                           i_Estimation_Formula     => i_Estimation_Formula,
                           i_Operation_Kind         => i_Operation_Kind,
                           i_Name                   => i_Name,
                           i_Short_Name             => i_Short_Name,
                           i_Accounting_Type        => Mpr_Pref.c_At_Employee,
                           i_Corr_Coa_Id            => null,
                           i_Corr_Ref_Set           => null,
                           i_Income_Tax_Exists      => 'N',
                           i_Income_Tax_Rate        => null,
                           i_Pension_Payment_Exists => 'N',
                           i_Pension_Payment_Rate   => null,
                           i_Social_Payment_Exists  => 'N',
                           i_Social_Payment_Rate    => null,
                           i_Note                   => null,
                           i_State                  => 'A',
                           i_Code                   => null);
  
    Hpr_Api.Oper_Type_Save(v_Oper_Type);
  
    update Hpr_Oper_Types q
       set q.Pcode = i_Oper_Type_Pcode
     where q.Company_Id = v_Company_Id
       and q.Oper_Type_Id = v_Oper_Type_Id;
  end;

  --------------------------------------------------
  Procedure Book_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Book_Type_Id number;
  begin
    begin
      select Book_Type_Id
        into v_Book_Type_Id
        from Hpr_Book_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Book_Type_Id := Hpr_Next.Book_Type_Id;
    end;
  
    z_Hpr_Book_Types.Save_One(i_Company_Id   => v_Company_Id,
                              i_Book_Type_Id => v_Book_Type_Id,
                              i_Name         => i_Name,
                              i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Book_Type_Bind
  (
    i_Book_Type_Pcode  varchar2,
    i_Oper_Group_Pcode varchar2
  ) is
    v_Book_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    select Book_Type_Id
      into v_Book_Type_Id
      from Hpr_Book_Types
     where Company_Id = v_Company_Id
       and Pcode = i_Book_Type_Pcode;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => v_Company_Id,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
  end;

  --------------------------------------------------
  Function Identifier(i_Pcode varchar2) return varchar2 is
    result Href_Indicators.Identifier%type;
  begin
    select Identifier
      into result
      from Href_Indicators
     where Company_Id = v_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Journal_Type_Id number;
  begin
    begin
      select Journal_Type_Id
        into v_Journal_Type_Id
        from Hpd_Journal_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => v_Company_Id,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => i_Name,
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  Dbms_Output.Put_Line('==== Indicators, Journal Types, Operation groups, Oper types, Book types, Book type binds ====');
  ----------------------------------------------------------------------------------------------------
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- indicators
    Indicator('Количество отпускных дней',
              'Кол-во от. дней',
              'КоличествоДнейОтпуска',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Vacation_Days);
    Indicator('Среднемесячное количество рабочих дней',
              'Среднемес. кол-во раб. дней',
              'СреднемесячноеКоличествоРабочихДней',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Mean_Working_Days);
  
    -- journal types
    Journal_Type('Отпуск', 11, Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  
    -- Estimation Formula
    -- '(Оклад / СреднемесячноеКоличествоРабочихДней) * КоличествоДнейОтпуска'
    v_Estimation_Formula := '(' || Identifier(Href_Pref.c_Pcode_Indicator_Wage) || ' / ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Mean_Working_Days) || ') * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Vacation_Days);
  
    -- Operation group
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Отпуск',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    v_Estimation_Formula,
                    Hpr_Pref.c_Pcode_Operation_Group_Vacation);
  
    -- Oper type
    Oper_Type('Отпуск',
              'Отпуск',
              Hpr_Pref.c_Pcode_Operation_Group_Vacation,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Vacation);
  
    -- book types
    Book_Type('Начисление отпуск', Hpr_Pref.c_Pcode_Book_Type_Vacation);
  
    -- book type binds
    Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Vacation, Hpr_Pref.c_Pcode_Operation_Group_Vacation);
  end loop;

  commit;
end;
/

---------------------------------------------------------------------------------------------------- 
prompt updating Htt_Schedule tables, changing minute to second
---------------------------------------------------------------------------------------------------- 
update Htt_Schedule_Origin_Days Od
   set Od.Shift_End_Time = Od.Shift_End_Time + Numtodsinterval(60, 'second'),
       Od.Output_Border  = Od.Output_Border + Numtodsinterval(60, 'second');

update Htt_Schedule_Days Sd
   set Sd.Shift_End_Time = Sd.Shift_End_Time + Numtodsinterval(60, 'second'),
       Sd.Output_Border  = Sd.Output_Border + Numtodsinterval(60, 'second');

update Htt_Timesheets t
   set t.Plan_Time      = t.Plan_Time * 60,
       t.Full_Time      = t.Full_Time * 60,
       t.Track_Duration = t.Track_Duration * 60,
       t.Shift_End_Time = t.Shift_End_Time + Numtodsinterval(60, 'second'),
       t.Output_Border  = t.Output_Border + Numtodsinterval(60, 'second');
commit;

update Htt_Timesheet_Facts Tf
   set Tf.Fact_Value = Tf.Fact_Value * 60;
commit; 

update Htt_Timesheet_Helpers Th
   set Th.Shift_End_Time = Th.Shift_End_Time + Numtodsinterval(60, 'second'),
       Th.Output_Border  = Th.Output_Border + Numtodsinterval(60, 'second');
commit;

----------------------------------------------------------------------------------------------------
prompt 'Книга начисления заработной платы' easy report added to head
----------------------------------------------------------------------------------------------------
declare
begin
  Dbms_Output.Put_Line('==== Easy report templates ====');
  Ui_Auth.Logon_As_System(0);
  Ker_Core.Head_Template_Save(i_Form     => Hpr_Pref.c_Easy_Report_Form_Payroll_Book,
                              i_Name     => 'Книга начисления заработной платы',
                              i_Order_No => 2,
                              i_Pcode    => 'vhr:hpr:2');
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt new Terminal Models
----------------------------------------------------------------------------------------------------
set define off
set serveroutput on
declare
  --------------------------------------------------
  Procedure Terminal_Model
  (
    i_Name                     varchar2,
    i_Support_Face_Recognation varchar2,
    i_Support_Fprint           varchar2,
    i_Support_Rfid_Card        varchar2,
    i_Pcode                    varchar2
  ) is
    r_Model Htt_Terminal_Models%rowtype;
  begin
    begin
      select *
        into r_Model
        from Htt_Terminal_Models
       where Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Model.Model_Id := Htt_Next.Terminal_Model_Id;
        r_Model.State    := 'A';
        r_Model.Pcode    := i_Pcode;
    end;
    
    r_Model.Name                     := i_Name;
    r_Model.Support_Face_Recognation := i_Support_Face_Recognation;
    r_Model.Support_Fprint           := i_Support_Fprint;
    r_Model.Support_Rfid_Card        := i_Support_Rfid_Card;
  
    z_Htt_Terminal_Models.Save_Row(r_Model);
  end;
begin
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Terminal Models ====');
  Terminal_Model('ZKTeco F18', 'N', 'Y', 'N', 'VHR:1');
  Terminal_Model('ZKTeco EFace10', 'Y', 'N', 'Y', 'VHR:2');
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt htt_devices dml
----------------------------------------------------------------------------------------------------
declare
begin
  update Htt_Devices q
     set q.Model_Id =
         (select w.Model_Id
            from Htt_Terminal_Models w
           where w.Pcode = 'VHR:1')
   where exists (select *
            from Htt_Device_Types Dt
           where Dt.Device_Type_Id = q.Device_Type_Id
             and Dt.Pcode = Htt_Pref.c_Pcode_Device_Type_Terminal);
  commit;
end;
/
