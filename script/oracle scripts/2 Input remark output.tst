PL/SQL Developer Test script 3.0
42
-- Created on 10/14/2022 by ADHAM 
declare
  -- Local variables here
  i       integer;
  r_Track Htt_Tracks%rowtype;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(i_Company_Id => 220);

  for r in (select q.Company_Id, q.Filial_Id, q.Timesheet_Id, q.Track_Type, max(q.Track_Id) Track_Id
              from Htt_Timesheet_Tracks q
             where q.Company_Id = 220
               and exists (select *
                      from Htt_Timesheets w
                     where w.Company_Id = 220
                       and w.Timesheet_Id = q.Timesheet_Id
                       and w.Timesheet_Date > to_date('12.10.2022', 'dd.mm.yyyy'))
               and q.Track_Type = 'I'
             group by q.Company_Id, q.Filial_Id, q.Timesheet_Id, q.Track_Type
            having count(1) > 1)
  loop
    z_Htt_Timesheet_Tracks.Delete_One(i_Company_Id   => r.Company_Id,
                                      i_Filial_Id    => r.Filial_Id,
                                      i_Timesheet_Id => r.Timesheet_Id,
                                      i_Track_Id     => r.Track_Id);
  
    r_Track := z_Htt_Tracks.Load(i_Company_Id => r.Company_Id,
                                 i_Filial_Id  => r.Filial_Id,
                                 i_Track_Id   => r.Track_Id);
  
    z_Htt_Tracks.Delete_One(i_Company_Id => r.Company_Id,
                            i_Filial_Id  => r.Filial_Id,
                            i_Track_Id   => r.Track_Id);
  
    r_Track.Track_Type := 'O';
  
    Htt_Api.Track_Add(r_Track);
  end loop;

  Biruni_Route.Context_End;
end;
0
0
