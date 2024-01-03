prompt migr from 27.03.2023 v2.21.1 (1.dml)
----------------------------------------------------------------------------------------------------
prompt moved trash tracks to tracks
----------------------------------------------------------------------------------------------------
declare
  r_Track Htt_Tracks%rowtype;
begin
  for Fil in (select f.Company_Id,
                     f.Filial_Id,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = f.Company_Id) as User_System
                from Md_Filials f
               where exists (select *
                        from Htt_Trash_Tracks Tt
                       where Tt.Company_Id = f.Company_Id
                         and Tt.Filial_Id = f.Filial_Id))
  loop
    Biruni_Route.Context_Begin;
    Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                         i_Filial_Id    => Fil.Filial_Id,
                         i_User_Id      => Fil.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    for r in (select *
                from Htt_Trash_Tracks Tt
               where Tt.Company_Id = Fil.Company_Id
                 and Tt.Filial_Id = Fil.Filial_Id
                 and not exists
               (select *
                        from Htt_Tracks t
                       where t.Company_Id = Tt.Company_Id
                         and t.Filial_Id = Tt.Filial_Id
                         and t.Track_Time = Tt.Track_Time
                         and t.Person_Id = Tt.Person_Id
                         and Nvl(t.Device_Id, -1) = Nvl(Tt.Device_Id, -1)
                         and t.Original_Type = Tt.Track_Type))
    loop
      z_Htt_Tracks.Init(p_Row            => r_Track,
                        i_Company_Id     => r.Company_Id,
                        i_Filial_Id      => r.Filial_Id,
                        i_Track_Id       => r.Track_Id,
                        i_Track_Date     => r.Track_Date,
                        i_Track_Time     => r.Track_Time,
                        i_Track_Datetime => r.Track_Datetime,
                        i_Person_Id      => r.Person_Id,
                        i_Track_Type     => r.Track_Type,
                        i_Mark_Type      => r.Mark_Type,
                        i_Device_Id      => r.Device_Id,
                        i_Location_Id    => r.Location_Id,
                        i_Latlng         => r.Latlng,
                        i_Accuracy       => r.Accuracy,
                        i_Photo_Sha      => r.Photo_Sha,
                        i_Note           => r.Note,
                        i_Original_Type  => r.Track_Type,
                        i_Is_Valid       => r.Is_Valid,
                        i_Status         => null,
                        i_Bssid          => r.Bssid,
                        i_Trans_Input    => null,
                        i_Trans_Output   => null);
    
      Htt_Api.Track_Add(r_Track);
    end loop;
  
    Biruni_Route.Context_End;
    commit;
  end loop;
end;
/
