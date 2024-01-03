PL/SQL Developer Test script 3.0
53
-- Created on 1/6/2023 by ADHAM 
declare
  -- Local variables here
  v_Company_Id number := 580;
  v_Filial_Id  number := 16176;
  v_Person_Id  number;
  r_Track      Htt_Tracks%rowtype;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);

  insert into Biruni_Files
    (Sha, Created_On, File_Size, File_Name, Content_Type)
    select q.Photo_Sha, q.Created_On, 1, null, null
      from Htt_Trash_Tracks_Reserve q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Person_Id in (24944, 24958, 24959)
       and q.Track_Date between to_date('01.12.2022', 'dd.mm.yyyy') and Trunc(sysdate)
       and q.Photo_Sha is not null
       and not exists (select 1
              from Biruni_Files Bf
             where Bf.Sha = q.Photo_Sha);

  for r in (select *
              from Htt_Trash_Tracks_Reserve q
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and q.Person_Id in (24944, 24958, 24959)
               and q.Track_Date between to_date('01.12.2022', 'dd.mm.yyyy') and Trunc(sysdate))
  loop
    r_Track.Company_Id  := r.Company_Id;
    r_Track.Filial_Id   := 16164;
    r_Track.Track_Id    := r.Track_Id;
    r_Track.Track_Date  := r.Track_Date;
    r_Track.Track_Time  := r.Track_Time;
    r_Track.Person_Id   := r.Person_Id;
    r_Track.Track_Type  := r.Track_Type;
    r_Track.Mark_Type   := r.Mark_Type;
    r_Track.Device_Id   := r.Device_Id;
    r_Track.Location_Id := r.Location_Id;
    r_Track.Latlng      := r.Latlng;
    r_Track.Accuracy    := r.Accuracy;
    r_Track.Photo_Sha   := r.Photo_Sha;
    r_Track.Note        := r.Note;
    r_Track.Is_Valid    := r.Is_Valid;
  
    Htt_Api.Track_Add(r_Track);
  end loop;

  Biruni_Route.Context_End;
end;
0
0
