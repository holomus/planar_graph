create or replace package Uit_Hrec is
  ----------------------------------------------------------------------------------------------------  
  Function Get_Hh_Job_Code(i_Job_Id number) return number;
  ----------------------------------------------------------------------------------------------------        
  Function Get_Hh_Region_Code(i_Region_Id number) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Schedule_Code(i_Schedule_Id number) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Lang_Code(i_Lang_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hh_Lang_Level_Code(i_Lang_Level_Id number) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Experience_Code(i_Vacancy_Type_Id number) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Employment_Code(i_Vacancy_Type_Id number) return varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Driver_Licence_Code(i_Vacancy_Type_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Prepare_Publish_Hh_Data
  (
    i_Vacancy_Id   number,
    i_Billing_Type varchar2,
    i_Vacancy_Type varchar2
  ) return Gmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Olx_Attributes(i_Category_Code number) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Olx_City_Code(i_Region_Id number) return Gmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Check_Responce_Error(p Hashmap);
end Uit_Hrec;
/
create or replace package body Uit_Hrec is
  ----------------------------------------------------------------------------------------------------  
  Function Get_Hh_Job_Code(i_Job_Id number) return number is
    v_Job_Code number(20);
  begin
    select q.Job_Code
      into v_Job_Code
      from Hrec_Hh_Integration_Jobs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Job_Id = i_Job_Id
       and Rownum = 1;
  
    return v_Job_Code;
  exception
    when No_Data_Found then
      Hrec_Error.Raise_020(z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => i_Job_Id).Name);
  end;

  ----------------------------------------------------------------------------------------------------        
  Function Get_Hh_Region_Code(i_Region_Id number) return number is
    v_Region_Code number(20);
  begin
    v_Region_Code := z_Hrec_Hh_Integration_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => i_Region_Id).Region_Code;
  
    if v_Region_Code is null then
      Hrec_Error.Raise_021(z_Md_Regions.Load(i_Company_Id => Ui.Company_Id, i_Region_Id => i_Region_Id).Name);
    end if;
  
    return v_Region_Code;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Schedule_Code(i_Schedule_Id number) return varchar2 is
  begin
    return z_Hrec_Hh_Integration_Schedules.Take(i_Company_Id  => Ui.Company_Id,
                                                i_Filial_Id   => Ui.Filial_Id,
                                                i_Schedule_Id => i_Schedule_Id).Schedule_Code;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Lang_Code(i_Lang_Id number) return varchar2 is
  begin
    return z_Hrec_Hh_Integration_Langs.Take(i_Company_Id => Ui.Company_Id, i_Lang_Id => i_Lang_Id).Lang_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hh_Lang_Level_Code(i_Lang_Level_Id number) return varchar2 is
  begin
    return z_Hrec_Hh_Integration_Lang_Levels.Take(i_Company_Id    => Ui.Company_Id,
                                                  i_Lang_Level_Id => i_Lang_Level_Id).Lang_Level_Code;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Experience_Code(i_Vacancy_Type_Id number) return varchar2 is
  begin
    return z_Hrec_Hh_Integration_Experiences.Take(i_Company_Id      => Ui.Company_Id,
                                                  i_Vacancy_Type_Id => i_Vacancy_Type_Id).Experience_Code;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Employment_Code(i_Vacancy_Type_Id number) return varchar2 is
  begin
    return z_Hrec_Hh_Integration_Employments.Take(i_Company_Id      => Ui.Company_Id,
                                                  i_Vacancy_Type_Id => i_Vacancy_Type_Id).Employment_Code;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Hh_Driver_Licence_Code(i_Vacancy_Type_Id number) return varchar2 is
  begin
    return z_Hrec_Hh_Integration_Driver_Licences.Take(i_Company_Id      => Ui.Company_Id,
                                                      i_Vacancy_Type_Id => i_Vacancy_Type_Id).Licence_Code;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Prepare_Publish_Hh_Data
  (
    i_Vacancy_Id   number,
    i_Billing_Type varchar2,
    i_Vacancy_Type varchar2
  ) return Gmap is
    v_Data            Gmap := Gmap();
    v_Dummy           Gmap;
    v_Level           Gmap;
    v_Arraylist       Glist := Glist();
    v_Schedule_Code   varchar2(50);
    v_Lang_Code       varchar2(50);
    v_Lang_Level_Code varchar2(50);
    v_Type_Code       varchar2(50);
    v_Vacancy_Type_Id number;
    r_Vacancy         Hrec_Vacancies%rowtype;
  begin
    r_Vacancy := z_Hrec_Vacancies.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Vacancy_Id => i_Vacancy_Id);
  
    if z_Hrec_Hh_Published_Vacancies.Exist(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Vacancy_Id => i_Vacancy_Id) then
      Hrec_Error.Raise_025(r_Vacancy.Name);
    end if;
  
    -- Area, Region
    v_Dummy := Gmap();
    v_Dummy.Put('id', Uit_Hrec.Get_Hh_Region_Code(r_Vacancy.Region_Id));
    v_Data.Put('area', v_Dummy);
  
    -- Billing Type
    v_Dummy := Gmap();
    v_Dummy.Put('id', i_Billing_Type);
    v_Data.Put('billing_type', v_Dummy);
  
    -- Vacancy Type
    v_Dummy := Gmap();
    v_Dummy.Put('id', i_Vacancy_Type);
    v_Data.Put('type', v_Dummy);
  
    -- Professional Roles, Job
    v_Dummy := Gmap();
    v_Dummy.Put('id', Uit_Hrec.Get_Hh_Job_Code(r_Vacancy.Job_Id));
    v_Arraylist.Push(v_Dummy.Val);
    v_Data.Put('professional_roles', v_Arraylist);
  
    -- Schedule
    v_Schedule_Code := Uit_Hrec.Get_Hh_Schedule_Code(r_Vacancy.Schedule_Id);
  
    if v_Schedule_Code is not null then
      v_Dummy := Gmap();
      v_Dummy.Put('id', v_Schedule_Code);
      v_Data.Put('schedule', v_Dummy);
    end if;
  
    -- Salary
    v_Dummy := Gmap();
    v_Dummy.Put('currency', 'UZS');
    v_Dummy.Val.Put('from', r_Vacancy.Wage_From);
    v_Dummy.Val.Put('to', r_Vacancy.Wage_To);
  
    v_Data.Put('salary', v_Dummy);
  
    v_Data.Put('description', r_Vacancy.Description_In_Html);
    v_Data.Put('name', r_Vacancy.Name);
  
    -- Languages
    v_Arraylist := Glist();
    for r in (select *
                from Hrec_Vacancy_Langs q
               where q.Company_Id = r_Vacancy.Company_Id
                 and q.Filial_Id = r_Vacancy.Filial_Id
                 and q.Vacancy_Id = r_Vacancy.Vacancy_Id)
    loop
      v_Lang_Code       := Uit_Hrec.Get_Hh_Lang_Code(r.Lang_Id);
      v_Lang_Level_Code := Uit_Hrec.Get_Hh_Lang_Level_Code(r.Lang_Level_Id);
    
      if v_Lang_Code is not null and v_Lang_Level_Code is not null then
        v_Dummy := Gmap();
        v_Dummy.Put('id', v_Lang_Code);
      
        v_Level := Gmap();
        v_Level.Put('id', v_Lang_Level_Code);
      
        v_Dummy.Put('level', v_Level);
        v_Arraylist.Push(v_Dummy.Val);
      end if;
    end loop;
  
    if v_Arraylist.Count > 0 then
      v_Data.Put('languages', v_Arraylist);
    end if;
  
    -- Experience 
    select q.Vacancy_Type_Id
      into v_Vacancy_Type_Id
      from Hrec_Vacancy_Type_Binds q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
       and exists (select 1
              from Hrec_Vacancy_Groups w
             where w.Company_Id = q.Company_Id
               and w.Vacancy_Group_Id = q.Vacancy_Group_Id
               and w.Pcode = Hrec_Pref.c_Pcode_Vacancy_Group_Experience)
       and Rownum = 1;
  
    v_Type_Code := Uit_Hrec.Get_Hh_Experience_Code(v_Vacancy_Type_Id);
  
    if v_Type_Code is not null then
      v_Dummy := Gmap();
      v_Dummy.Put('id', v_Type_Code);
      v_Data.Put('experience', v_Dummy);
    end if;
  
    -- Employment
    select q.Vacancy_Type_Id
      into v_Vacancy_Type_Id
      from Hrec_Vacancy_Type_Binds q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
       and exists (select 1
              from Hrec_Vacancy_Groups w
             where w.Company_Id = q.Company_Id
               and w.Vacancy_Group_Id = q.Vacancy_Group_Id
               and w.Pcode = Hrec_Pref.c_Pcode_Vacancy_Group_Employments)
       and Rownum = 1;
  
    v_Type_Code := Uit_Hrec.Get_Hh_Employment_Code(v_Vacancy_Type_Id);
  
    if v_Type_Code is not null then
      v_Dummy := Gmap();
      v_Dummy.Put('id', v_Type_Code);
      v_Data.Put('employment', v_Dummy);
    end if;
  
    -- Key Skills
    v_Arraylist := Glist();
    for r in (select (select t.Name
                        from Hrec_Vacancy_Types t
                       where t.Company_Id = q.Company_Id
                         and t.Vacancy_Type_Id = q.Vacancy_Type_Id) as Type_Name
                from Hrec_Vacancy_Type_Binds q
               where q.Company_Id = r_Vacancy.Company_Id
                 and q.Filial_Id = r_Vacancy.Filial_Id
                 and q.Vacancy_Id = r_Vacancy.Vacancy_Id
                 and exists
               (select 1
                        from Hrec_Vacancy_Groups w
                       where w.Company_Id = q.Company_Id
                         and w.Vacancy_Group_Id = q.Vacancy_Group_Id
                         and w.Pcode = Hrec_Pref.c_Pcode_Vacancy_Group_Key_Skills))
    loop
      v_Dummy := Gmap();
      v_Dummy.Put('name', r.Type_Name);
      v_Arraylist.Push(v_Dummy.Val);
    end loop;
  
    if v_Arraylist.Count > 0 then
      v_Data.Put('key_skills', v_Arraylist);
    end if;
  
    -- Driver Licences
    v_Arraylist := Glist();
    for r in (select q.Vacancy_Type_Id
                from Hrec_Vacancy_Type_Binds q
               where q.Company_Id = r_Vacancy.Company_Id
                 and q.Filial_Id = r_Vacancy.Filial_Id
                 and q.Vacancy_Id = r_Vacancy.Vacancy_Id
                 and exists
               (select 1
                        from Hrec_Vacancy_Groups w
                       where w.Company_Id = q.Company_Id
                         and w.Vacancy_Group_Id = q.Vacancy_Group_Id
                         and w.Pcode = Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences))
    loop
      v_Type_Code := Uit_Hrec.Get_Hh_Driver_Licence_Code(r.Vacancy_Type_Id);
    
      if v_Type_Code is not null then
        v_Dummy := Gmap();
        v_Dummy.Put('id', v_Type_Code);
        v_Arraylist.Push(v_Dummy.Val);
      end if;
    end loop;
  
    if v_Arraylist.Count > 0 then
      v_Data.Put('driver_license_types', v_Arraylist);
    end if;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Olx_Attributes(i_Category_Code number) return Hashmap is
    v_Data   Hashmap;
    v_Matrix Matrix_Varchar2;
    v_Array  Arraylist := Arraylist();
    result   Hashmap := Hashmap();
  begin
    for r in (select *
                from Hrec_Olx_Attributes q
               where q.Company_Id = Ui.Company_Id
                 and q.Category_Code = i_Category_Code)
    loop
      v_Data := Hashmap();
    
      v_Data.Put('attribute_code', r.Attribute_Code);
      v_Data.Put('label', r.Label);
      v_Data.Put('is_require', r.Is_Require);
      v_Data.Put('is_number', r.Is_Number);
    
      select Array_Varchar2(w.Code, w.Label)
        bulk collect
        into v_Matrix
        from Hrec_Olx_Attribute_Values w
       where w.Company_Id = r.Company_Id
         and w.Category_Code = r.Category_Code
         and w.Attribute_Code = r.Attribute_Code;
    
      v_Data.Put('values', Fazo.Zip_Matrix(v_Matrix));
    
      v_Array.Push(v_Data);
    end loop;
  
    Result.Put('attributes', v_Array);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Olx_City_Code(i_Region_Id number) return Gmap is
    v_City_Code     number;
    v_District_Code number;
    result          Gmap := Gmap();
  begin
    select q.City_Code, q.District_Code
      into v_City_Code, v_District_Code
      from Hrec_Olx_Integration_Regions q
     where q.Company_Id = Ui.Company_Id
       and q.Region_Id = i_Region_Id;
  
    Result.Put('city_id', v_City_Code);
    Result.Put('district_id', v_District_Code);
  
    return result;
  exception
    when No_Data_Found then
      Hrec_Error.Raise_028(z_Md_Regions.Load(i_Company_Id => Ui.Company_Id, i_Region_Id => i_Region_Id).Name);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Check_Responce_Error(p Hashmap) is
    v_Error     Hashmap;
    v_Arraylist Arraylist;
    v_Data      Hashmap;
  begin
    if (p.o_Hashmap('error')) is not null then
      v_Error := p.o_Hashmap('error');
    
      if v_Error.o_Varchar2('error_human_title') is not null then
        Hrec_Error.Raise_030(v_Error.o_Varchar2('error_human_title'));
      end if;
    
      v_Arraylist := v_Error.o_Arraylist('validation');
    
      if v_Arraylist is not null and v_Arraylist.Count > 0 then
        v_Data := Treat(v_Arraylist.r_Hashmap(1) as Hashmap);
      
        Hrec_Error.Raise_030(v_Data.o_Varchar2('title'));
      end if;
    end if;
  end;

end Uit_Hrec;
/
