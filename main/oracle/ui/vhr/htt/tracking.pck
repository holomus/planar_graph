create or replace package Ui_Vhr245 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Calculate_All;
end Ui_Vhr245;
/
create or replace package body Ui_Vhr245 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR245:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query is
    v_Query varchar2(32767);
    q       Fazo_Query;
  begin
    v_Query := 'select q.employee_id,
                       q.division_id,
                       s.org_unit_id,
                       (select w.name
                          from mr_natural_persons w
                         where w.company_id = q.company_id
                           and w.person_id = q.employee_id) name
                  from mhr_employees q
                  join href_staffs s
                    on s.company_id = q.company_id
                   and s.filial_id = q.filial_id
                   and s.employee_id = q.employee_id
                   and s.hiring_date <= :end_date
                   and (s.dismissal_date is null 
                    or s.dismissal_date >= :begin_date)
                   and s.state = ''A''
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and (:division_id is null or s.division_id = :division_id)';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.o_Number('division_id'),
                                 'begin_date',
                                 Trunc(Nvl(p.o_Date('begin_date'), sysdate)),
                                 'end_date',
                                 Trunc(Nvl(p.o_Date('end_date'), sysdate))));
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_location_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('location_type_id');
    q.Varchar2_Field('name', 'color', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Need_Calculate return varchar2 is
    result varchar2(1);
  begin
    select 'Y'
      into result
      from Htt_Gps_Tracks q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Calculated = 'N'
       and Rownum = 1;
  
    return result;
  
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('begin_date',
                           Trunc(sysdate),
                           'end_date',
                           Trunc(sysdate),
                           'show_locations',
                           'Y',
                           'show_gps_tracking',
                           'Y',
                           'default_latlng',
                           Md_Pref.Filial_Default_Location(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    Result.Put('providers', Fazo.Zip_Matrix_Transposed(Htt_Util.Providers));
    Result.Put('is_need_calculate', Is_Need_Calculate);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load(p Hashmap) return Json_Object_t is
    v_Begin_Date        date := Trunc(p.r_Date('begin_date'));
    v_End_Date          date := Trunc(p.r_Date('end_date'));
    v_Employee_Id       number := p.r_Number('employee_id');
    v_Location_Type_Ids Array_Number := Nvl(p.o_Array_Number('location_type_ids'), Array_Number());
    v_Array             Array_Varchar2;
    v_Tracks            Glist := Glist;
    v_Track             Gmap;
    result              Gmap := Gmap;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id);
  
    if v_Location_Type_Ids.Count = 0 then
      v_Location_Type_Ids := null;
    end if;
  
    select Json_Array(q.Track_Id,
                      to_char(q.Track_Time, Href_Pref.c_Time_Format_Minute),
                      q.Track_Type,
                      Htt_Util.t_Track_Type(q.Track_Type),
                      (select w.Name
                         from Htt_Locations w
                        where w.Company_Id = q.Company_Id
                          and w.Location_Id = q.Location_Id),
                      q.Accuracy,
                      q.Photo_Sha,
                      q.Latlng,
                      q.Note,
                      q.Is_Valid --
                      null on null)
      bulk collect
      into v_Array
      from Htt_Tracks q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Track_Date between v_Begin_Date and v_End_Date
       and q.Person_Id = v_Employee_Id
     order by q.Track_Datetime desc;
  
    Result.Put('tracks', v_Array);
  
    for r in (select q.*,
                     (select w.Data
                        from Htt_Gps_Track_Datas w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Track_Id = q.Track_Id) as Data
                from Htt_Gps_Tracks q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Person_Id = v_Employee_Id
                 and q.Track_Date between v_Begin_Date and v_End_Date
               order by q.Track_Date)
    loop
      v_Track := Gmap;
    
      v_Track.Put('track_date', r.Track_Date);
      v_Track.Val.Put('data', r.Data);
    
      v_Tracks.Push(v_Track.Val);
    end loop;
  
    Result.Put('gps_tracks', v_Tracks);
    Result.Put('total_distance',
               Htt_Util.Gps_Track_Distance(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Person_Id  => v_Employee_Id,
                                           i_Begin_Date => v_Begin_Date,
                                           i_End_Date   => v_End_Date));
  
    select Json_Array(q.Location_Id,
                      q.Name,
                      (select s.Name
                         from Md_Regions s
                        where s.Region_Id = q.Region_Id),
                      q.Address,
                      q.Latlng,
                      (select w.Color
                         from Htt_Location_Types w
                        where w.Company_Id = q.Company_Id
                          and w.Location_Type_Id = q.Location_Type_Id) --
                      null on null)
      bulk collect
      into v_Array
      from Htt_Locations q
     where q.Company_Id = Ui.Company_Id
       and exists
     (select 1
              from Htt_Location_Persons s
             where s.Company_Id = Ui.Company_Id
               and s.Filial_Id = Ui.Filial_Id
               and s.Location_Id = q.Location_Id
               and s.Person_Id = v_Employee_Id
               and not exists (select 1
                      from Htt_Blocked_Person_Tracking Bp
                     where Bp.Company_Id = s.Company_Id
                       and Bp.Filial_Id = s.Filial_Id
                       and Bp.Employee_Id = s.Person_Id))
       and (v_Location_Type_Ids is null or q.Location_Type_Id member of v_Location_Type_Ids);
  
    Result.Put('locations', v_Array);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Begin_Date     date := p.r_Date('begin_date');
    v_End_Date       date := p.r_Date('end_date');
    v_Employee_Id    number := p.r_Number('employee_id');
    v_Time_Format    varchar2(100);
    v_Total_Distance number;
    v_Table          b_Table;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id);
  
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    if v_Begin_Date = v_End_Date then
      v_Time_Format := Href_Pref.c_Time_Format_Minute;
    else
      v_Time_Format := Href_Pref.c_Date_Format_Minute;
    end if;
  
    v_Table := b_Report.New_Table();
  
    v_Table.Column_Width(1, 100);
    v_Table.Column_Width(2, 100);
    v_Table.Column_Width(3, 200);
    v_Table.Column_Width(4, 100);
    v_Table.Column_Width(5, 100);
  
    v_Table.Current_Style('root');
  
    v_Table.New_Row;
    v_Table.Data(t('track date: $1',
                   case --
                   when v_Begin_Date = v_End_Date then
                   to_char(v_Begin_Date, Href_Pref.c_Date_Format_Day) --
                   else to_char(v_Begin_Date, Href_Pref.c_Date_Format_Day) || '-' ||
                   to_char(v_End_Date, Href_Pref.c_Date_Format_Day) --
                   end),
                 i_Colspan => 5);
  
    v_Table.New_Row;
    v_Table.Data(t('employee: $1',
                   z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => v_Employee_Id).Name),
                 i_Colspan => 5);
  
    v_Total_Distance := Htt_Util.Gps_Track_Distance(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Person_Id  => v_Employee_Id,
                                                    i_Begin_Date => v_Begin_Date,
                                                    i_End_Date   => v_End_Date);
  
    v_Table.New_Row;
  
    if v_Total_Distance >= 1000 then
      v_Table.Data(t('total distance: $1 km $2 m',
                     Trunc(v_Total_Distance / 1000),
                     mod(v_Total_Distance, 1000)),
                   i_Colspan => 5);
    else
      v_Table.Data(t('total distance: $1 m', v_Total_Distance), i_Colspan => 5);
    end if;
  
    v_Table.Current_Style('header');
  
    v_Table.New_Row;
    v_Table.New_Row;
    v_Table.Data(t('track_id'));
    v_Table.Data(t('track_time'));
    v_Table.Data(t('latlng'));
    v_Table.Data(t('accuracy'));
    v_Table.Data(t('provider'));
  
    v_Table.Current_Style('body');
  
    for r in (select *
                from Htt_Util.Gps_Track_Datas(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Person_Id  => v_Employee_Id,
                                              i_Begin_Date => v_Begin_Date,
                                              i_End_Date   => v_End_Date) q
               order by q.Track_Time)
    loop
      v_Table.New_Row;
      v_Table.Data(r.Track_Id);
      v_Table.Data(to_char(r.Track_Time, v_Time_Format));
      v_Table.Data(r.Lat || ',' || r.Lng);
      v_Table.Data(r.Accuracy);
      v_Table.Data(Htt_Util.t_Provider(r.Provider));
    end loop;
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name, --
                       p_Table => v_Table);
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Calculate_All is
  begin
    Htt_Api.Calc_Gps_Track_Distances(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Org_Unit_Id    = null;
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null,
           State            = null,
           Code             = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr245;
/
