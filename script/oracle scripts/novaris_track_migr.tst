PL/SQL Developer Test script 3.0
61
-- Created on 10/25/2022 by ADHAM 
declare
  -- Local variables here
  i       integer;
  r_Track Htt_Tracks%rowtype;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(2000);
  for r in (with Back_Up as
               (select q.Person_Id,
                      Trunc(sysdate) + min(q.Track_Datetime - q.Track_Date) Min_Time,
                      Trunc(sysdate) + max(q.Track_Datetime - q.Track_Date) Max_Time,
                      Trunc(sysdate) + avg(q.Track_Datetime - q.Track_Date) Avg_Time,
                      min(q.Device_Id) Device_Id,
                      min(q.Location_Id) Location_Id,
                      min(q.Latlng) Latlng,
                      min(q.Accuracy) Accuracy,
                      min(q.Photo_Sha) Photo_Sha,
                      (select k.Begin_Time
                         from Htt_Timesheets k
                        where k.Employee_Id = q.Person_Id
                          and k.Timesheet_Date = Trunc(sysdate)) Today_Time
                 from Htt_Tracks q
                where q.Company_Id = 2000
                  and q.Track_Date in (to_date('24.10.2022', 'dd.mm.yyyy'),
                                       to_date('17.10.2022', 'dd.mm.yyyy'),
                                       to_date('18.10.2022', 'dd.mm.yyyy'),
                                       to_date('21.10.2022', 'dd.mm.yyyy'),
                                       to_date('20.10.2022', 'dd.mm.yyyy'))
                  and q.Track_Datetime <= q.Track_Date + 480 / 1440
                  and q.Track_Type = 'I'
                group by q.Person_Id
               --having max(q.Track_Datetime - q.Track_Date) - min(q.Track_Datetime - q.Track_Date) < 20 / 1440;
               )
              select *
                from Back_Up q
               )
  loop
    --    r_Track.Company_Id := 2000;
    z_Htt_Tracks.Init(p_Row            => r_Track,
                      i_Company_Id     => 2000,
                      i_Filial_Id      => 731416,
                      i_Track_Id       => Htt_Next.Track_Id,
                      i_Track_Date     => Trunc(sysdate),
                      i_Track_Time     => r.Avg_Time,
                      i_Track_Datetime => r.Avg_Time,
                      i_Person_Id      => r.Person_Id,
                      i_Track_Type     => 'I',
                      i_Mark_Type      => 'M',
                      i_Device_Id      => r.Device_Id,
                      i_Location_Id    => r.Location_Id,
                      i_Latlng         => r.Latlng,
                      i_Accuracy       => r.Accuracy,
                      i_Photo_Sha      => r.Photo_Sha,
                      i_Note           => 'Verifix dasturi tomonidan qayta tiklanib berilgan ma''lumotlar',
                      i_Is_Valid       => 'N');
    Htt_Api.Track_Add(r_Track);
  end loop;
  Biruni_Route.Context_End;
end;
0
0
