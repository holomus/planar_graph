create or replace package Ui_Vhr79 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Location_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Timezones return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr79;
/
create or replace package body Ui_Vhr79 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_location_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('location_type_id');
    q.Varchar2_Field('name', 'color');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Timezones return Fazo_Query is
    q      Fazo_Query;
    v_Lang varchar2(2) := 'ru';
  begin
    if Ui_Context.Lang_Code = 'en' then
      v_Lang := 'en';
    end if;
  
    q := Fazo_Query('select q.timezone_code,
                            q.name_' || v_Lang ||
                    ' name,
                            q.order_no
                       from md_timezones q 
                      where q.state = ''A''');
  
    q.Number_Field('order_no');
    q.Varchar2_Field('timezone_code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Region_Id, q.Name, q.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions q
     where q.Company_Id = Ui.Company_Id
       and q.State = 'A';
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    v_Data Hashmap;
    result Hashmap := Hashmap();
  begin
    v_Data := Fazo.Zip_Map('latlng',
                           Md_Pref.Filial_Default_Location(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id),
                           'accuracy',
                           500,
                           'prohibited',
                           'N',
                           'state',
                           'A');
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data     Htt_Locations%rowtype;
    v_Data     Hashmap;
    v_Vertices Array_Varchar2;
    result     Hashmap := Hashmap();
  begin
    r_Data := z_Htt_Locations.Load(i_Company_Id  => Ui.Company_Id,
                                   i_Location_Id => p.r_Number('location_id'));
  
    v_Data := z_Htt_Locations.To_Map(r_Data,
                                     z.Location_Id,
                                     z.Name,
                                     z.Location_Type_Id,
                                     z.Timezone_Code,
                                     z.Region_Id,
                                     z.Address,
                                     z.Latlng,
                                     z.Accuracy,
                                     z.Bssids,
                                     z.Prohibited,
                                     z.State,
                                     z.Code);
  
    v_Data.Put('location_type_name',
               z_Htt_Location_Types.Take(i_Company_Id => r_Data.Company_Id, --
               i_Location_Type_Id => r_Data.Location_Type_Id).Name);
    v_Data.Put('timezone_name', z_Md_Timezones.Take(r_Data.Timezone_Code).Name_Ru);
  
    select t.Latlng
      bulk collect
      into v_Vertices
      from Htt_Location_Polygon_Vertices t
     where t.Company_Id = Ui.Company_Id
       and t.Location_Id = r_Data.Location_Id
     order by t.Order_No;
  
    v_Data.Put('polygon_vertices', v_Vertices);
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Location_Id number,
    p             Hashmap
  ) return Hashmap is
    r_Location Htt_Locations%rowtype;
  begin
    r_Location := z_Htt_Locations.To_Row(p,
                                         z.Name,
                                         z.Location_Type_Id,
                                         z.Timezone_Code,
                                         z.Region_Id,
                                         z.Address,
                                         z.Latlng,
                                         z.Accuracy,
                                         z.Bssids,
                                         z.Prohibited,
                                         z.State,
                                         z.Code);
  
    r_Location.Company_Id  := Ui.Company_Id;
    r_Location.Location_Id := i_Location_Id;
  
    Htt_Api.Location_Save(r_Location,
                          Nvl(p.o_Array_Varchar2('polygon_vertices'), Array_Varchar2()));
  
    if not Ui.Is_Filial_Head then
      Htt_Api.Location_Add_Filial(i_Company_Id  => r_Location.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => r_Location.Location_Id);
    end if;
  
    return z_Htt_Locations.To_Map(r_Location, z.Location_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Location_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Location_Id number := p.r_Number('location_id');
  begin
    z_Htt_Locations.Lock_Only(i_Company_Id => Ui.Company_Id, i_Location_Id => v_Location_Id);
  
    return save(v_Location_Id, p);
  end;

  -----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null,
           Color            = null,
           State            = null;
    update Md_Timezones
       set Timezone_Code = null,
           Name_Ru       = null,
           Name_En       = null,
           Order_No      = null,
           State         = null;
  end;

end Ui_Vhr79;
/
