PL/SQL Developer Test script 3.0
110
-- Created on 6/21/2022 by ADHAM 
declare
  -- Local variables here
  i            integer;
  v_Row        Array_Varchar2;
  v_Filial_Ids Array_Number;
  r_Track      Htt_Tracks%rowtype;
  r_Device     Htt_Devices%rowtype;
  r_Location   Htt_Locations%rowtype;
  v_Company_Id number := 420;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select *
              from Hzk_Attlog_Errors q
             where q.Company_Id = v_Company_Id
               and not exists (select *
                      from Hzk_Migred_Errors w
                     where w.Error_Id = q.Error_Id))
  loop
    r_Device := z_Htt_Devices.Load(i_Company_Id => r.Company_Id, i_Device_Id => r.Device_Id);
  
    r_Location := z_Htt_Locations.Load(i_Company_Id  => r.Company_Id,
                                       i_Location_Id => r_Device.Location_Id);
  
    r_Track.Company_Id  := r.Company_Id;
    r_Track.Device_Id   := r.Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
    begin
      v_Row := Fazo.Split(r.Command, Chr(9));
    
      r_Track.Person_Id := Htt_Util.Person_Id(i_Company_Id => r.Company_Id, i_Pin => v_Row(1));
    
      if v_Row(3) = '0' then
        r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
      elsif v_Row(3) = '1' then
        r_Track.Track_Type := Htt_Pref.c_Track_Type_Output;
      else
        continue;
      end if;
    
      if r_Location.Timezone_Code is not null then
        r_Track.Track_Time := Htt_Util.Convert_Timestamp(to_date(v_Row(2), 'yyyy-mm-dd hh24:mi:ss'),
                                                         r_Location.Timezone_Code);
      else
        r_Track.Track_Time := to_date(v_Row(2), 'yyyy-mm-dd hh24:mi:ss');
      end if;
    
      r_Track.Track_Date := Trunc(r_Track.Track_Time);
    
      case v_Row(4)
        when 0 then
          r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Password;
        when 1 then
          r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Touch;
        when 2 then
          r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Rfid_Card;
        when 15 then
          r_Track.Mark_Type := Htt_Pref.c_Mark_Type_Face;
        else
          b.Raise_Fatal('eval_attlog: mark_type not found, mark_type=' || v_Row(4));
      end case;
    
      if r_Track.Person_Id is not null then
        v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                                i_Location_Id => r_Track.Location_Id,
                                                i_Person_Id   => r_Track.Person_Id);
      
        for i in 1 .. v_Filial_Ids.Count
        loop
          r_Track.Track_Datetime := Htt_Util.Timestamp_To_Date(i_Timestamp => r_Track.Track_Time,
                                                               i_Timezone  => Htt_Util.Load_Timezone(r_Track.Company_Id,
                                                                                                     v_Filial_Ids(i)));
        
          r_Track.Filial_Id := v_Filial_Ids(i);
        
          if not Htt_Util.Exist_Track(i_Company_Id     => r_Track.Company_Id,
                                      i_Filial_Id      => v_Filial_Ids(i),
                                      i_Person_Id      => r_Track.Person_Id,
                                      i_Track_Type     => r_Track.Track_Type,
                                      i_Track_Datetime => r_Track.Track_Datetime,
                                      i_Device_Id      => r_Track.Device_Id) then
          
            r_Track.Track_Id := Htt_Next.Track_Id;
          
            Htt_Api.Track_Add(r_Track);
          end if;
        end loop;
      else
        z_Hzk_Migr_Tracks.Save_One(i_Company_Id    => r.Company_Id,
                                   i_Migr_Track_Id => Hzk_Next.Migr_Track_Id,
                                   i_Pin           => v_Row(1),
                                   i_Device_Id     => r_Track.Device_Id,
                                   i_Location_Id   => r_Track.Location_Id,
                                   i_Track_Type    => r_Track.Track_Type,
                                   i_Track_Time    => r_Track.Track_Time,
                                   i_Track_Date    => r_Track.Track_Date,
                                   i_Mark_Type     => r_Track.Mark_Type);
      end if;
    end;
  
    insert into Hzk_Migred_Errors
      (Error_Id)
    values
      (r.Error_Id);
  end loop;
  Biruni_Route.Context_End;
end;
0
0
