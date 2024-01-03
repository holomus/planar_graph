PL/SQL Developer Test script 3.0
36
-- Created on 6/24/2022 by ADHAM 
declare
  -- Local variables here
  i       integer;
  r_Track Htt_Tracks%rowtype;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(420);
  for r in (select *
              from Mhr_Employees q
             where q.Company_Id = 420
               and q.Filial_Id in (12087, 12088, 33212, 33193, 33214))
  loop
    for t in (select *
                from Htt_Tracks q
               where q.Company_Id = 420
                 and q.Person_Id = r.Employee_Id
                 and not exists (select *
                        from Htt_Tracks w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = r.Filial_Id
                         and w.Track_Time = q.Track_Time
                         and w.Person_Id = q.Person_Id
                         and w.Track_Type = q.Track_Type))
    --COMPANY_ID, FILIAL_ID, TRACK_TIME, PERSON_ID, TRACK_TYPE
    loop
      r_Track           := t;
      r_Track.Filial_Id := r.Filial_Id;
      r_Track.Track_Id  := Htt_Next.Track_Id;
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  end loop;
  Biruni_Route.Context_End;
end;
0
0
