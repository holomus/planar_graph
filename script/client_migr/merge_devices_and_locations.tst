PL/SQL Developer Test script 3.0
168
declare
  v_Company_Id number := -1;
  v_Filial_Id  number := -1;
begin
  for r in (select St.Old_Id,
                   max((select Lf.Location_Id
                         from Htt_Location_Filials Lf
                        where Lf.Company_Id = p.Company_Id
                          and Lf.Filial_Id = v_Filial_Id
                          and Lf.Location_Id = p.Location_Id)) Location_Id
              from Htt_Locations p
              join Migr_Keys_Store_Two St
                on St.Company_Id = p.Company_Id
               and St.Key_Name = 'location_id'
               and St.New_Id = p.Location_Id
             where p.Company_Id = v_Company_Id
             group by St.Old_Id)
  loop
    insert into Htt_Location_Filials
      (Company_Id, Filial_Id, Location_Id, Created_By, Created_On)
      select Lf.Company_Id, Lf.Filial_Id, r.Location_Id, Lf.Created_By, Lf.Created_On
        from Htt_Location_Filials Lf
        join Migr_Keys_Store_Two St
          on St.Company_Id = Lf.Company_Id
         and St.Key_Name = 'location_id'
         and St.New_Id = Lf.Location_Id
       where Lf.Company_Id = v_Company_Id
         and St.Old_Id = r.Old_Id
         and Lf.Location_Id <> r.Location_Id
         and not exists (select 1
                from Htt_Location_Filials Fl
               where Fl.Company_Id = Lf.Company_Id
                 and Fl.Filial_Id = Lf.Filial_Id
                 and Fl.Location_Id = r.Location_Id);
  
    insert into Htt_Location_Persons
      (Company_Id, Filial_Id, Location_Id, Person_Id, Attach_Type, Created_By, Created_On)
      select Lp.Company_Id,
             Lp.Filial_Id,
             r.Location_Id,
             Lp.Person_Id,
             Lp.Attach_Type,
             Lp.Created_By,
             Lp.Created_On
        from Htt_Location_Persons Lp
        join Migr_Keys_Store_Two St
          on St.Company_Id = Lp.Company_Id
         and St.Key_Name = 'location_id'
         and St.New_Id = Lp.Location_Id
       where Lp.Company_Id = v_Company_Id
         and St.Old_Id = r.Old_Id
         and Lp.Location_Id <> r.Location_Id
         and not exists (select 1
                from Htt_Location_Persons Pl
               where Pl.Company_Id = Lp.Company_Id
                 and Pl.Filial_Id = Lp.Filial_Id
                 and Pl.Location_Id = r.Location_Id
                 and Pl.Person_Id = Lp.Person_Id);
  
    insert into Htt_Location_Divisions
      (Company_Id, Filial_Id, Location_Id, Division_Id, Created_By, Created_On)
      select Ld.Company_Id,
             Ld.Filial_Id,
             r.Location_Id,
             Ld.Division_Id,
             Ld.Created_By,
             Ld.Created_On
        from Htt_Location_Divisions Ld
        join Migr_Keys_Store_Two St
          on St.Company_Id = Ld.Company_Id
         and St.Key_Name = 'location_id'
         and St.New_Id = Ld.Location_Id
       where Ld.Company_Id = v_Company_Id
         and St.Old_Id = r.Old_Id
         and Ld.Location_Id <> r.Location_Id
         and not exists (select 1
                from Htt_Location_Divisions Dl
               where Dl.Company_Id = Ld.Company_Id
                 and Dl.Filial_Id = Ld.Filial_Id
                 and Dl.Location_Id = r.Location_Id
                 and Dl.Division_Id = Ld.Division_Id);
  
    update Htt_Tracks t
       set t.Location_Id = r.Location_Id
     where t.Company_Id = v_Company_Id
       and t.Location_Id <> r.Location_Id
       and exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = t.Company_Id
               and St.Key_Name = 'location_id'
               and St.New_Id = t.Location_Id);
  
    insert into Migr_Keys_Store_One
      (Company_Id, Key_Name, Old_Id, New_Id)
    values
      (v_Company_Id, 'location_id', r.Old_Id, r.Location_Id);
  
    delete Htt_Locations Lc
     where Lc.Company_Id = v_Company_Id
       and Lc.Location_Id <> r.Location_Id
       and exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = Lc.Company_Id
               and St.Key_Name = 'location_id'
               and St.New_Id = Lc.Location_Id);
  end loop;

  for r in (select St.Old_Id,
                   max(case
                          when exists (select 1
                                  from Htt_Location_Filials Lf
                                 where Lf.Company_Id = p.Company_Id
                                   and Lf.Filial_Id = v_Filial_Id
                                   and Lf.Location_Id = p.Location_Id) then
                           p.Device_Id
                          else
                           null
                        end) Device_Id
              from Htt_Devices p
              join Migr_Keys_Store_Two St
                on St.Company_Id = p.Company_Id
               and St.Key_Name = 'device_id'
               and St.New_Id = p.Device_Id
             where p.Company_Id = v_Company_Id
             group by St.Old_Id)
  loop
    insert into Htt_Device_Admins
      (Company_Id, Device_Id, Person_Id, Created_By, Created_On)
      select Da.Company_Id, r.Device_Id, Da.Person_Id, Da.Created_By, Da.Created_On
        from Htt_Device_Admins Da
        join Migr_Keys_Store_Two St
          on St.Company_Id = Da.Company_Id
         and St.Key_Name = 'device_id'
         and St.New_Id = Da.Device_Id
       where Da.Company_Id = v_Company_Id
         and St.Old_Id = r.Old_Id
         and Da.Device_Id <> r.Device_Id
         and not exists (select 1
                from Htt_Device_Admins Ad
               where Ad.Company_Id = Da.Company_Id
                 and Ad.Device_Id = r.Device_Id
                 and Ad.Person_Id = Da.Person_Id);
  
    update Htt_Tracks t
       set t.Device_Id = r.Device_Id
     where t.Company_Id = v_Company_Id
       and t.Device_Id <> r.Device_Id
       and exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = t.Company_Id
               and St.Key_Name = 'device_id'
               and St.New_Id = t.Device_Id);
  
    insert into Migr_Keys_Store_One
      (Company_Id, Key_Name, Old_Id, New_Id)
    values
      (v_Company_Id, 'device_id', r.Old_Id, r.Device_Id);
  
    delete Htt_Devices Dv
     where Dv.Company_Id = v_Company_Id
       and Dv.Device_Id <> r.Device_Id
       and exists (select 1
              from Migr_Keys_Store_Two St
             where St.Company_Id = Dv.Company_Id
               and St.Key_Name = 'device_id'
               and St.New_Id = Dv.Device_Id);
  end loop;
end;
0
0
