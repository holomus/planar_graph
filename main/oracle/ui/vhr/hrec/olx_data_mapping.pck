create or replace package Ui_Vhr629 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Olx_Regions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Olx_Districts(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Auth_Olx return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Regions(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Sync_Regions return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Cities(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Sync_Cities return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Districts(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Sync_Districts return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Load_Response_Categories(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Sync_Categories return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Attributes(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Sync_Attributes(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Data_Map(p Hashmap);
end Ui_Vhr629;
/
create or replace package body Ui_Vhr629 is
  ----------------------------------------------------------------------------------------------------  
  g_Category_Code number(20);
  ----------------------------------------------------------------------------------------------------  
  Function Query_Olx_Regions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.city_code,
                            q.region_code,
                            (select w.name
                               from hrec_olx_regions w
                              where w.company_id = :company_id
                                and w.region_code = q.region_code) as region_name,
                            q.name,
                            case
                              when exists (select 1
                                      from hrec_olx_districts d
                                     where d.company_id = :company_id 
                                       and d.city_code = q.city_code) then
                               ''Y''
                              else
                               ''N''
                            end as has_district
                       from hrec_olx_cities q
                      where q.company_id = :company_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('city_code', 'region_code');
    q.Varchar2_Field('name', 'region_name', 'has_district');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Olx_Districts(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.district_code,
                            q.name
                       from hrec_olx_districts q
                      where q.company_id = :company_id
                        and q.city_code = :city_code',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'city_code', p.r_Number('city_code')));
  
    q.Number_Field('district_code');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Matrix     Matrix_Varchar2;
    v_Count      number;
    result       Hashmap := Hashmap;
  begin
    select Array_Varchar2(q.Region_Id, q.Name, q.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions q
     where q.Company_Id = v_Company_Id
       and q.State = 'A';
  
    Result.Put('system_regions', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Region_Id,
                          (select w.Name
                             from Md_Regions w
                            where w.Company_Id = q.Company_Id
                              and w.Region_Id = q.Region_Id),
                          q.City_Code,
                          (select w.Name
                             from Hrec_Olx_Cities w
                            where w.Company_Id = q.Company_Id
                              and w.City_Code = q.City_Code),
                          q.District_Code,
                          (select w.Name
                             from Hrec_Olx_Districts w
                            where w.Company_Id = q.Company_Id
                              and w.District_Code = q.District_Code))
      bulk collect
      into v_Matrix
      from Hrec_Olx_Integration_Regions q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_regions', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Category_Code, q.Name)
      bulk collect
      into v_Matrix
      from Hrec_Olx_Job_Categories q
     where q.Company_Id = Ui.Company_Id;
  
    Result.Put('olx_categories', Fazo.Zip_Matrix(v_Matrix));
  
    select count(*)
      into v_Count
      from Hrec_Olx_Cities q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('olx_city_count', v_Count);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Auth_Olx return Hashmap is
  begin
    return Fazo.Zip_Map('auth_url',
                        Uit_Hes.Prepare_Oauth2_Auth_Url(Hes_Pref.c_Provider_Olx_Id, true));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Regions(p Hashmap) is
    v_Regions Arraylist := p.r_Arraylist('data');
    v_Region  Hashmap;
    r_Region  Hrec_Olx_Regions%rowtype;
  begin
    -- clear Old Regions
    Hrec_Api.Olx_Region_Clear(Ui.Company_Id);
  
    for i in 1 .. v_Regions.Count
    loop
      v_Region := Treat(v_Regions.r_Hashmap(i) as Hashmap);
    
      r_Region             := null;
      r_Region.Company_Id  := Ui.Company_Id;
      r_Region.Region_Code := v_Region.r_Number('id');
      r_Region.Name        := v_Region.r_Varchar2('name');
    
      Hrec_Api.Olx_Region_Save(r_Region);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sync_Regions return Runtime_Service is
  begin
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Get_Regions_Url,
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Responce_Procedure => 'Ui_Vhr629.Load_Response_Regions',
                                        i_Action_Out         => null);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Cities(p Hashmap) is
    v_Cities Arraylist := p.r_Arraylist('data');
    v_City   Hashmap;
    r_City   Hrec_Olx_Cities%rowtype;
  begin
    for i in 1 .. v_Cities.Count
    loop
      v_City := Treat(v_Cities.r_Hashmap(i) as Hashmap);
    
      r_City             := null;
      r_City.Company_Id  := Ui.Company_Id;
      r_City.City_Code   := v_City.r_Number('id');
      r_City.Region_Code := v_City.r_Number('region_id');
      r_City.Name        := v_City.r_Varchar2('name');
    
      Hrec_Api.Olx_City_Save(r_City);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sync_Cities return Runtime_Service is
  begin
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Get_Cities_Url,
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Responce_Procedure => 'Ui_Vhr629.Load_Response_Cities',
                                        i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Districts(p Hashmap) is
    v_Districts Arraylist := p.r_Arraylist('data');
    v_District  Hashmap;
    r_District  Hrec_Olx_Districts%rowtype;
  begin
    for i in 1 .. v_Districts.Count
    loop
      v_District := Treat(v_Districts.r_Hashmap(i) as Hashmap);
    
      r_District               := null;
      r_District.Company_Id    := Ui.Company_Id;
      r_District.City_Code     := v_District.r_Number('city_id');
      r_District.District_Code := v_District.r_Number('id');
      r_District.Name          := v_District.r_Varchar2('name');
    
      Hrec_Api.Olx_District_Save(r_District);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sync_Districts return Runtime_Service is
  begin
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Get_Districts_Url,
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Responce_Procedure => 'Ui_Vhr629.Load_Response_Districts',
                                        i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Response_Categories(p Hashmap) return Hashmap is
    v_Categories     Arraylist := p.r_Arraylist('data');
    v_Category       Hashmap;
    v_Category_Codes Array_Number := Array_Number();
    result           Hashmap := Hashmap();
    r_Category       Hrec_Olx_Job_Categories%rowtype;
  begin
    for i in 1 .. v_Categories.Count
    loop
      v_Category := Treat(v_Categories.r_Hashmap(i) as Hashmap);
    
      if v_Category.r_Number('parent_id') = Hrec_Pref.c_Olx_Job_Category_Code then
        r_Category               := null;
        r_Category.Company_Id    := Ui.Company_Id;
        r_Category.Category_Code := v_Category.r_Number('id');
        r_Category.Name          := v_Category.r_Varchar2('name');
      
        Hrec_Api.Olx_Job_Category_Save(r_Category);
      
        v_Category_Codes.Extend;
        v_Category_Codes(v_Category_Codes.Count) := r_Category.Category_Code;
      end if;
    end loop;
  
    Result.Put('category_codes', v_Category_Codes);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sync_Categories return Runtime_Service is
  begin
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Get_Categories_Url,
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Responce_Procedure => 'Ui_Vhr629.Load_Response_Categories');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Attributes(p Hashmap) is
    v_Arrtibutes  Arraylist := p.r_Arraylist('data');
    v_Data        Hashmap;
    v_Validation  Hashmap;
    v_Value       Hashmap;
    v_Values      Arraylist;
    v_Is_Required varchar2(1);
    v_Is_Number   varchar2(1);
    v_Is_Allow    varchar2(1);
    v_Attribute   Hrec_Pref.Olx_Attribute_Rt;
  begin
    for i in 1 .. v_Arrtibutes.Count
    loop
      v_Data        := Treat(v_Arrtibutes.r_Hashmap(i) as Hashmap);
      v_Values      := v_Data.r_Arraylist('values');
      v_Validation  := v_Data.r_Hashmap('validation');
      v_Is_Required := 'N';
      v_Is_Number   := 'N';
      v_Is_Allow    := 'N';
      v_Attribute   := null;
    
      if v_Validation.r_Varchar2('required') = 'true' then
        v_Is_Required := 'Y';
      end if;
    
      if v_Validation.r_Varchar2('numeric') = 'true' then
        v_Is_Number := 'Y';
      end if;
    
      if v_Validation.r_Varchar2('allow_multiple_values') = 'true' then
        v_Is_Allow := 'Y';
      end if;
    
      Hrec_Util.Olx_Attribute_New(o_Attribute                => v_Attribute,
                                  i_Company_Id               => Ui.Company_Id,
                                  i_Category_Code            => g_Category_Code,
                                  i_Attribute_Code           => v_Data.r_Varchar2('code'),
                                  i_Label                    => v_Data.r_Varchar2('label'),
                                  i_Validation_Type          => v_Validation.r_Varchar2('type'),
                                  i_Is_Required              => v_Is_Required,
                                  i_Is_Number                => v_Is_Number,
                                  i_Min_Value                => v_Validation.o_Number('min'),
                                  i_Max_Value                => v_Validation.o_Number('max'),
                                  i_Is_Allow_Multiple_Values => v_Is_Allow);
    
      for j in 1 .. v_Values.Count
      loop
        v_Value := Treat(v_Values.r_Hashmap(j) as Hashmap);
      
        Hrec_Util.Olx_Attribute_Add_Value(o_Attribute => v_Attribute,
                                          i_Code      => v_Value.r_Varchar2('code'),
                                          i_Label     => v_Value.r_Varchar2('label'));
      end loop;
    
      Hrec_Api.Olx_Attribute_Save(v_Attribute);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sync_Attributes(p Hashmap) return Runtime_Service is
  begin
    g_Category_Code := p.r_Number('category_code');
  
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Get_Categories_Url || '/' ||
                                                                g_Category_Code || '/attributes',
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Responce_Procedure => 'Ui_Vhr629.Load_Response_Attributes',
                                        i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Data_Map(p Hashmap) is
    v_Company_Id        number := Ui.Company_Id;
    v_Integrate_Regions Arraylist := p.o_Arraylist('integrate_regions');
    v_Integrate_Region  Hashmap;
    v_Region            Hrec_Pref.Olx_Integration_Region_Rt;
    v_Regions           Hrec_Pref.Olx_Integration_Region_Nt := Hrec_Pref.Olx_Integration_Region_Nt();
  begin
    for i in 1 .. v_Integrate_Regions.Count
    loop
      v_Integrate_Region := Treat(v_Integrate_Regions.r_Hashmap(i) as Hashmap);
    
      v_Region.Region_Id     := v_Integrate_Region.r_Number('system_region_id');
      v_Region.City_Code     := v_Integrate_Region.r_Number('olx_city_code');
      v_Region.District_Code := v_Integrate_Region.o_Number('olx_district_code');
    
      v_Regions.Extend();
      v_Regions(v_Regions.Count) := v_Region;
    end loop;
  
    Hrec_Api.Olx_Integration_Region_Save(i_Company_Id => v_Company_Id, i_Regions => v_Regions);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hrec_Olx_Cities
       set Company_Id  = null,
           City_Code   = null,
           Region_Code = null,
           name        = null;
    update Hrec_Olx_Regions
       set Company_Id  = null,
           Region_Code = null,
           name        = null;
    update Hrec_Olx_Districts
       set Company_Id    = null,
           District_Code = null,
           City_Code     = null,
           name          = null;
  end;

end Ui_Vhr629;
/
