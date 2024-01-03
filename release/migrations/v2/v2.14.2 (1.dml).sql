prompt allowing vacation, trip, sick leave
----------------------------------------------------------------------------------------------------
declare
begin
  update Htt_Time_Kinds Tk
     set Tk.Requestable = 'Y'
   where Tk.Pcode in (Htt_Pref.c_Pcode_Time_Kind_Vacation,
                      Htt_Pref.c_Pcode_Time_Kind_Trip,
                      Htt_Pref.c_Pcode_Time_Kind_Sick);
  commit;
end;
/
