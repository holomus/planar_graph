PL/SQL Developer Test script 3.0
238
-- Created on 7/19/2022 by ADHAM 
declare
  v_Company_Id number := 181;
begin
  insert into Htt_Location_Filials
    (Company_Id, Filial_Id, Location_Id, Created_By, Created_On)
    select Lf.Company_Id, Lf.Filial_Id, w.New_Location_Id, min(Lf.Created_By), min(Lf.Created_On)
      from Htt_Location_Filials Lf
      join (select q.Location_Id Old_Location_Id, Qr.Location_Id New_Location_Id, q.Name
              from Htt_Locations q
              join (select p.Company_Id, p.Location_Id, p.Name
                     from Htt_Locations p
                    where p.Company_Id = v_Company_Id
                      and p.Location_Id in (281,
                                            285,
                                            289,
                                            293,
                                            297,
                                            301,
                                            305,
                                            313,
                                            317,
                                            321,
                                            325,
                                            329,
                                            333,
                                            337,
                                            341,
                                            345,
                                            352,
                                            2983,
                                            28821)) Qr
                on q.Name = Qr.Name
               and q.Location_Id <> Qr.Location_Id
             where q.Company_Id = v_Company_Id) w
        on w.Old_Location_Id = Lf.Location_Id
     where Lf.Company_Id = v_Company_Id
       and not exists (select 1
              from Htt_Location_Filials Fl
             where Fl.Company_Id = Lf.Company_Id
               and Fl.Filial_Id = Lf.Filial_Id
               and Fl.Location_Id = w.New_Location_Id)
     group by Lf.Company_Id, Lf.Filial_Id, w.New_Location_Id;

  insert into Htt_Location_Persons
    (Company_Id, Filial_Id, Location_Id, Person_Id, Attach_Type, Created_By, Created_On)
    select Lp.Company_Id,
           Lp.Filial_Id,
           w.New_Location_Id,
           Lp.Person_Id,
           Htt_Pref.c_Attach_Type_Manual,
           min(Lp.Created_By),
           min(Lp.Created_On)
      from Htt_Location_Persons Lp
      join (select q.Location_Id Old_Location_Id, Qr.Location_Id New_Location_Id, q.Name
              from Htt_Locations q
              join (select p.Company_Id, p.Location_Id, p.Name
                     from Htt_Locations p
                    where p.Company_Id = v_Company_Id
                      and p.Location_Id in (281,
                                            285,
                                            289,
                                            293,
                                            297,
                                            301,
                                            305,
                                            313,
                                            317,
                                            321,
                                            325,
                                            329,
                                            333,
                                            337,
                                            341,
                                            345,
                                            352,
                                            2983,
                                            28821)) Qr
                on q.Name = Qr.Name
               and q.Location_Id <> Qr.Location_Id
             where q.Company_Id = v_Company_Id) w
        on w.Old_Location_Id = Lp.Location_Id
     where Lp.Company_Id = v_Company_Id
       and not exists (select 1
              from Htt_Location_Persons Pl
             where Pl.Company_Id = Lp.Company_Id
               and Pl.Filial_Id = Lp.Filial_Id
               and Pl.Location_Id = w.New_Location_Id)
     group by Lp.Company_Id, Lp.Filial_Id, w.New_Location_Id, Lp.Person_Id;

  update Htt_Devices p
     set p.Location_Id =
         (select Qr.Location_Id
            from Htt_Locations q
            join (select p.Company_Id, p.Location_Id, p.Name
                   from Htt_Locations p
                  where p.Company_Id = 181
                    and p.Location_Id in (281,
                                          285,
                                          289,
                                          293,
                                          297,
                                          301,
                                          305,
                                          313,
                                          317,
                                          321,
                                          325,
                                          329,
                                          333,
                                          337,
                                          341,
                                          345,
                                          352,
                                          2983,
                                          28821)) Qr
              on q.Name = Qr.Name
             and q.Location_Id <> Qr.Location_Id
           where q.Company_Id = v_Company_Id
             and q.Location_Id = p.Location_Id)
   where p.Company_Id = v_Company_Id
     and p.Location_Id in (select q.Location_Id
                             from Htt_Locations q
                             join (select p.Company_Id, p.Location_Id, p.Name
                                    from Htt_Locations p
                                   where p.Company_Id = v_Company_Id
                                     and p.Location_Id in (281,
                                                           285,
                                                           289,
                                                           293,
                                                           297,
                                                           301,
                                                           305,
                                                           313,
                                                           317,
                                                           321,
                                                           325,
                                                           329,
                                                           333,
                                                           337,
                                                           341,
                                                           345,
                                                           352,
                                                           2983,
                                                           28821)) Qr
                               on q.Name = Qr.Name
                              and q.Location_Id <> Qr.Location_Id
                            where q.Company_Id = v_Company_Id);

  update Htt_Tracks p
     set p.Location_Id =
         (select Qr.Location_Id
            from Htt_Locations q
            join (select p.Company_Id, p.Location_Id, p.Name
                   from Htt_Locations p
                  where p.Company_Id = 181
                    and p.Location_Id in (281,
                                          285,
                                          289,
                                          293,
                                          297,
                                          301,
                                          305,
                                          313,
                                          317,
                                          321,
                                          325,
                                          329,
                                          333,
                                          337,
                                          341,
                                          345,
                                          352,
                                          2983,
                                          28821)) Qr
              on q.Name = Qr.Name
             and q.Location_Id <> Qr.Location_Id
           where q.Company_Id = v_Company_Id
             and q.Location_Id = p.Location_Id)
   where p.Company_Id = v_Company_Id
     and p.Location_Id in (select q.Location_Id
                             from Htt_Locations q
                             join (select p.Company_Id, p.Location_Id, p.Name
                                    from Htt_Locations p
                                   where p.Company_Id = v_Company_Id
                                     and p.Location_Id in (281,
                                                           285,
                                                           289,
                                                           293,
                                                           297,
                                                           301,
                                                           305,
                                                           313,
                                                           317,
                                                           321,
                                                           325,
                                                           329,
                                                           333,
                                                           337,
                                                           341,
                                                           345,
                                                           352,
                                                           2983,
                                                           28821)) Qr
                               on q.Name = Qr.Name
                              and q.Location_Id <> Qr.Location_Id
                            where q.Company_Id = v_Company_Id);

  delete Htt_Locations p
   where p.Company_Id = v_Company_Id
     and p.Location_Id in (select q.Location_Id
                             from Htt_Locations q
                             join (select p.Company_Id, p.Location_Id, p.Name
                                    from Htt_Locations p
                                   where p.Company_Id = v_Company_Id
                                     and p.Location_Id in (281,
                                                           285,
                                                           289,
                                                           293,
                                                           297,
                                                           301,
                                                           305,
                                                           313,
                                                           317,
                                                           321,
                                                           325,
                                                           329,
                                                           333,
                                                           337,
                                                           341,
                                                           345,
                                                           352,
                                                           2983,
                                                           28821)) Qr
                               on q.Name = Qr.Name
                              and q.Location_Id <> Qr.Location_Id
                            where q.Company_Id = v_Company_Id);
end;
0
0
