prompt migr from 17.06.2022 dml
----------------------------------------------------------------------------------------------------
declare
  v_Latlng   Array_Varchar2;
  v_Tot_Dist number;
  v_Track_Id number;
  v_Blob     blob;

  -------------------------------------------------- 
  Procedure Writeappend(i_Text varchar2) is
  begin
    Dbms_Lob.Writeappend(v_Blob, Length(i_Text), Utl_Raw.Cast_To_Raw(i_Text));
  end;
begin
  for Gps_d in (select q.Company_Id, q.Filial_Id, q.Person_Id, q.Track_Date
                  from Htt_Gps_Tracks_Old q
                 where not exists (select 1
                          from Htt_Gps_Tracks w
                         where w.Company_Id = q.Company_Id
                           and w.Filial_Id = q.Filial_Id
                           and w.Person_Id = q.Person_Id
                           and w.Track_Date = q.Track_Date)
                 group by q.Company_Id, q.Filial_Id, q.Person_Id, q.Track_Date)
  loop
    -- track_id
    select w.Track_Id
      into v_Track_Id
      from Htt_Gps_Tracks_Old w
     where w.Company_Id = Gps_d.Company_Id
       and w.Filial_Id = Gps_d.Filial_Id
       and w.Person_Id = Gps_d.Person_Id
       and w.Track_Date = Gps_d.Track_Date
       and w.Track_Time = (select max(Gt.Track_Time)
                             from Htt_Gps_Tracks_Old Gt
                            where Gt.Company_Id = Gps_d.Company_Id
                              and Gt.Filial_Id = Gps_d.Filial_Id
                              and Gt.Person_Id = Gps_d.Person_Id
                              and Gt.Track_Date = Gps_d.Track_Date);
  
    -- total_distance
    select Nvl(Trunc(sum(Power(Power(69.1 * (Lat2 - Lat1), 2) + Power(53.0 * (Lng2 - Lng1), 2), 0.5)) /
                     0.00062137),
               0)
      into v_Tot_Dist
      from (select Track_Date Track_Date1,
                   Lat Lat1,
                   Lng Lng1,
                   Lag(Track_Date) Over(order by Rownum) Track_Date2,
                   Lag(Lat) Over(order by Rownum) Lat2,
                   Lag(Lng) Over(order by Rownum) Lng2
              from (select q.Track_Date,
                           Regexp_Substr(q.Latlng, '^[0-9\.]+') Lat,
                           Regexp_Substr(q.Latlng, '[0-9\.]+$') Lng
                      from Htt_Gps_Tracks_Old q
                     where q.Company_Id = Ui.Company_Id
                       and q.Filial_Id = Ui.Filial_Id
                       and q.Track_Date = Gps_d.Track_Date
                       and q.Person_Id = Gps_d.Person_Id
                       and q.Accuracy <= 50
                     order by q.Track_Time))
     where Lat2 is not null
       and Track_Date1 = Track_Date2;
  
    insert into Htt_Gps_Tracks
      (Company_Id,
       Filial_Id,
       Track_Id,
       Person_Id,
       Track_Date,
       Total_Distance,
       Calculated,
       Created_By,
       Created_On,
       Modified_By,
       Modified_On)
      select w.Company_Id,
             w.Filial_Id,
             w.Track_Id,
             w.Person_Id,
             w.Track_Date,
             v_Tot_Dist as Total_Distance,
             'Y' as Calculated,
             w.Created_By,
             w.Created_On,
             w.Modified_By,
             w.Modified_On
        from Htt_Gps_Tracks_Old w
       where w.Company_Id = Gps_d.Company_Id
         and w.Filial_Id = Gps_d.Filial_Id
         and w.Track_Id = v_Track_Id;
  
    Dbms_Lob.Createtemporary(v_Blob, false);
    Dbms_Lob.Open(v_Blob, Dbms_Lob.Lob_Readwrite);
  
    for Track in (select *
                    from Htt_Gps_Tracks_Old w
                   where w.Company_Id = Gps_d.Company_Id
                     and w.Filial_Id = Gps_d.Filial_Id
                     and w.Person_Id = Gps_d.Person_Id
                     and w.Track_Date = Gps_d.Track_Date
                   order by w.Track_Time)
    loop
      v_Latlng := Fazo.Split(Track.Latlng, ',');
    
      Writeappend(to_char(Track.Track_Time, 'hh24:mi:ss') || Chr(9) || v_Latlng(1) || Chr(9) ||
                  v_Latlng(2) || Chr(9) || Track.Accuracy || Chr(9) || Track.Provider || Chr(10));
    end loop;
  
    Dbms_Lob.Close(v_Blob);
  
    insert into Htt_Gps_Track_Datas
      (Company_Id, Filial_Id, Track_Id, Data)
    values
      (Gps_d.Company_Id, Gps_d.Filial_Id, v_Track_Id, v_Blob);
  
    commit;
  end loop;
end;
/

