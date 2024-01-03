prompt change timebook adjustments
----------------------------------------------------------------------------------------------------
declare
begin
  update Htt_Timesheet_Locks Tl
     set Tl.Facts_Changed = 'Y'
   where (Tl.Company_Id, Tl.Filial_Id, Tl.Staff_Id, Tl.Timesheet_Date) in
         (select La.Company_Id, La.Filial_Id, La.Staff_Id, La.Adjustment_Date
            from Hpd_Lock_Adjustments La);

  insert into Hpd_Adjustment_Deleted_Facts
    (Company_Id, Filial_Id, Staff_Id, Adjustment_Date, Time_Kind_Id, Fact_Value)
    select Tf.Company_Id,
           Tf.Filial_Id,
           Tm.Staff_Id,
           Tm.Timesheet_Date,
           Tf.Time_Kind_Id,
           Tf.Fact_Value
      from Htt_Timesheets Tm
      join Hpd_Lock_Adjustments La
        on La.Company_Id = Tm.Company_Id
       and La.Filial_Id = Tm.Filial_Id
       and La.Staff_Id = Tm.Staff_Id
       and La.Adjustment_Date = Tm.Timesheet_Date
       and La.Kind = Hpd_Pref.c_Adjustment_Kind_Incomplete
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = Tm.Company_Id
       and Tf.Filial_Id = Tm.Filial_Id
       and Tf.Timesheet_Id = Tm.Timesheet_Id
       and Tf.Time_Kind_Id = (select Tk.Time_Kind_Id
                                from Htt_Time_Kinds Tk
                               where Tk.Company_Id = Tm.Company_Id
                                 and Tk.Pcode = Htt_Pref.c_Pcode_Time_Kind_Lack)
     where not exists (select 1
              from Htt_Timesheet_Locks Tl
             where Tl.Company_Id = Tm.Company_Id
               and Tl.Filial_Id = Tm.Filial_Id
               and Tl.Staff_Id = Tm.Staff_Id
               and Tl.Timesheet_Date = Tm.Timesheet_Date);

  update (select Tf.Fact_Value,
                 (select Pa.Turnout_Time * 60
                    from Hpd_Page_Adjustments Pa
                   where Pa.Company_Id = La.Company_Id
                     and Pa.Filial_Id = La.Filial_Id
                     and Pa.Page_Id = La.Page_Id) Turnout_Time
            from Htt_Timesheets Tm
            join Hpd_Lock_Adjustments La
              on La.Company_Id = Tm.Company_Id
             and La.Filial_Id = Tm.Filial_Id
             and La.Staff_Id = Tm.Staff_Id
             and La.Adjustment_Date = Tm.Timesheet_Date
             and La.Kind = Hpd_Pref.c_Adjustment_Kind_Incomplete
            join Htt_Timesheet_Facts Tf
              on Tf.Company_Id = Tm.Company_Id
             and Tf.Filial_Id = Tm.Filial_Id
             and Tf.Timesheet_Id = Tm.Timesheet_Id
             and Tf.Time_Kind_Id =
                 (select Tk.Time_Kind_Id
                    from Htt_Time_Kinds Tk
                   where Tk.Company_Id = Tm.Company_Id
                     and Tk.Pcode = Htt_Pref.c_Pcode_Time_Kind_Lack)
           where not exists (select 1
                    from Htt_Timesheet_Locks Tl
                   where Tl.Company_Id = Tm.Company_Id
                     and Tl.Filial_Id = Tm.Filial_Id
                     and Tl.Staff_Id = Tm.Staff_Id
                     and Tl.Timesheet_Date = Tm.Timesheet_Date)) q
     set q.Fact_Value = Greatest(q.Fact_Value - Nvl(q.Turnout_Time, 0), 0);

  commit;
end;
/
