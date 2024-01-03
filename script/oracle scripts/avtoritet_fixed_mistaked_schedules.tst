update Htt_Schedules Tt
   set Tt.Code              = 'chp' || Tt.Schedule_Id,
       Tt.Input_Acceptance  = 0,
       Tt.Output_Acceptance = 0,
       Tt.Track_Duration    = 1440
 where Tt.Company_Id = 181
   and Tt.Schedule_Id in (select q.Schedule_Id
                            from Htt_Schedules q
                            join Migr_Keys_Store_Two w
                              on w.Key_Name = 'schedule_id'
                             and w.Company_Id = 181
                             and w.New_Id = q.Schedule_Id
                            join Old_Vx_Ref_Schedules k
                              on k.Company_Id = 840
                             and k.Schedule_Id = w.Old_Id
                           where q.Company_Id = 181
                             and k.Daily_Shift_Time = q.Shift
                             and (q.Input_Acceptance != 0 or q.Output_Acceptance != 0)
                             and exists (select *
                                    from Md_Filials e
                                   where e.Filial_Id = q.Filial_Id
                                     and e.State = 'A'));
