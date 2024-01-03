PL/SQL Developer Test script 3.0
141
-- Created on 7/19/2022 by ADHAM 
declare
  v_Company_Id number := 181;
begin
  insert into Htt_Device_Admins
    (Company_Id, Device_Id, Person_Id, Created_By, Created_On)
    select q.Company_Id, w.New_Device_Id, q.Person_Id, q.Created_By, q.Created_On
      from Htt_Device_Admins q
      join (select p.Device_Id Old_Device_Id, Qr.Device_Id New_Device_Id
              from Htt_Devices p
              join (select q.Device_Id, q.Location_Id
                     from Htt_Devices q
                    where q.Company_Id = 181
                      and q.Device_Id in
                          (8444, 8447, 8467, 8469, 8502, 8559, 9001, 9541, 9581, 9643, 10102, 11761)) Qr
                on Qr.Location_Id = p.Location_Id
               and Qr.Device_Id <> p.Device_Id
             where p.Company_Id = 181
               and p.Device_Type_Id = 2
               and p.Location_Id in (333)
               and p.Device_Id not in (8444,
                                       8447,
                                       8467,
                                       8469,
                                       8502,
                                       8559,
                                       9001,
                                       9541,
                                       9581,
                                       9643,
                                       10102,
                                       11761,
                                       931,
                                       11741,
                                       10101,
                                       9686,
                                       8616)) w
        on w.Old_Device_Id = q.Device_Id
     where q.Company_Id = v_Company_Id
       and not exists (select *
              from Htt_Device_Admins Da
             where Da.Company_Id = q.Company_Id
               and Da.Device_Id = w.New_Device_Id
               and Da.Person_Id = q.Person_Id);

  update Htt_Tracks w
     set w.Device_Id =
         (select Qr.Device_Id
            from Htt_Devices p
            join (select q.Device_Id, q.Location_Id
                   from Htt_Devices q
                  where q.Company_Id = 181
                    and q.Device_Id in
                        (8444, 8447, 8467, 8469, 8502, 8559, 9001, 9541, 9581, 9643, 10102, 11761)) Qr
              on Qr.Location_Id = p.Location_Id
             and Qr.Device_Id <> p.Device_Id
           where p.Company_Id = 181
             and p.Device_Type_Id = 2
             and p.Device_Id = w.Device_Id
             and p.Location_Id in (333)
             and p.Device_Id not in (8444,
                                     8447,
                                     8467,
                                     8469,
                                     8502,
                                     8559,
                                     9001,
                                     9541,
                                     9581,
                                     9643,
                                     10102,
                                     11761,
                                     931,
                                     11741,
                                     10101,
                                     9686,
                                     8616))
   where w.Company_Id = v_Company_Id
     and w.Device_Id in
         (select p.Device_Id
            from Htt_Devices p
            join (select q.Device_Id, q.Location_Id
                   from Htt_Devices q
                  where q.Company_Id = 181
                    and q.Device_Id in
                        (8444, 8447, 8467, 8469, 8502, 8559, 9001, 9541, 9581, 9643, 10102, 11761)) Qr
              on Qr.Location_Id = p.Location_Id
             and Qr.Device_Id <> p.Device_Id
           where p.Company_Id = 181
             and p.Device_Type_Id = 2
             and p.Location_Id in (333)
             and p.Device_Id not in (8444,
                                     8447,
                                     8467,
                                     8469,
                                     8502,
                                     8559,
                                     9001,
                                     9541,
                                     9581,
                                     9643,
                                     10102,
                                     11761,
                                     931,
                                     11741,
                                     10101,
                                     9686,
                                     8616));

  delete Htt_Devices p
   where p.Company_Id = v_Company_Id
     and p.Device_Id in
         (select p.Device_Id
            from Htt_Devices p
            join (select q.Device_Id, q.Location_Id
                   from Htt_Devices q
                  where q.Company_Id = 181
                    and q.Device_Id in
                        (8444, 8447, 8467, 8469, 8502, 8559, 9001, 9541, 9581, 9643, 10102, 11761)) Qr
              on Qr.Location_Id = p.Location_Id
             and Qr.Device_Id <> p.Device_Id
           where p.Company_Id = 181
             and p.Device_Type_Id = 2
             and p.Location_Id in (333)
             and p.Device_Id not in (8444,
                                     8447,
                                     8467,
                                     8469,
                                     8502,
                                     9001,
                                     9541,
                                     9581,
                                     9643,
                                     10102,
                                     11761,
                                     931,
                                     11741,
                                     10101,
                                     9686,
                                     8616));
end;
0
0
