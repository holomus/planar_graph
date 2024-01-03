create or replace package Ui_Vhr44 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Experience_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Awards return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Save_Experience(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Experience(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Save_Work_Place(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Work_Place(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Save_Award(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Award(p Hashmap);
end Ui_Vhr44;
/
create or replace package body Ui_Vhr44 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    v_Matrix    Matrix_Varchar2;
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    select Array_Varchar2(q.Person_Experience_Id,
                          q.Experience_Type_Id,
                          (select w.Name
                             from Href_Experience_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Experience_Type_Id = q.Experience_Type_Id),
                          q.Is_Working,
                          q.Start_Date,
                          q.Num_Year,
                          q.Num_Month,
                          q.Num_Day)
      bulk collect
      into v_Matrix
      from Href_Person_Experiences q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('person_experiences', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Person_Work_Place_Id,
                          q.Start_Date,
                          q.End_Date,
                          q.Organization_Name,
                          q.Job_Title,
                          q.Organization_Address)
      bulk collect
      into v_Matrix
      from Href_Person_Work_Places q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('person_work_places', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Person_Award_Id,
                          q.Award_Id,
                          (select w.Name
                             from Href_Awards w
                            where w.Company_Id = q.Company_Id
                              and w.Award_Id = q.Award_Id),
                          q.Doc_Title,
                          q.Doc_Number,
                          q.Doc_Date)
      bulk collect
      into v_Matrix
      from Href_Person_Awards q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('person_awards', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Experience_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_experience_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('experience_type_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Awards return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_awards', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('award_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Experience(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Href_Person_Experiences%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Experiences.Exist_Lock(i_Company_Id           => Ui.Company_Id,
                                                i_Person_Experience_Id => p.o_Number('person_experience_id'),
                                                o_Row                  => r_Data) then
      r_Data.Company_Id           := Ui.Company_Id;
      r_Data.Person_Experience_Id := Href_Next.Person_Experience_Id;
    end if;
  
    z_Href_Person_Experiences.To_Row(r_Data,
                                     p,
                                     z.Experience_Type_Id,
                                     z.Is_Working,
                                     z.Start_Date,
                                     z.Num_Year,
                                     z.Num_Month,
                                     z.Num_Day);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Experience_Save(r_Data);
  
    return z_Href_Person_Experiences.To_Map(r_Data, z.Person_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Experience(p Hashmap) is
    v_Person_Experience_Id number := p.r_Number('person_experience_id');
    v_Person_Id            number;
  begin
    v_Person_Id := z_Href_Person_Experiences.Load(i_Company_Id => Ui.Company_Id, i_Person_Experience_Id => v_Person_Experience_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Experience_Delete(i_Company_Id           => Ui.Company_Id,
                                      i_Person_Experience_Id => v_Person_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Work_Place(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Href_Person_Work_Places%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Work_Places.Exist_Lock(i_Company_Id           => Ui.Company_Id,
                                                i_Person_Work_Place_Id => p.o_Number('person_work_place_id'),
                                                o_Row                  => r_Data) then
      r_Data.Company_Id           := Ui.Company_Id;
      r_Data.Person_Work_Place_Id := Href_Next.Person_Work_Place_Id;
    end if;
  
    z_Href_Person_Work_Places.To_Row(r_Data,
                                     p,
                                     z.Start_Date,
                                     z.End_Date,
                                     z.Organization_Name,
                                     z.Job_Title,
                                     z.Organization_Address);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Work_Place_Save(r_Data);
  
    return z_Href_Person_Work_Places.To_Map(r_Data, z.Person_Work_Place_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Work_Place(p Hashmap) is
    v_Person_Work_Place_Id number := p.r_Number('person_work_place_id');
    v_Person_Id            number;
  begin
    v_Person_Id := z_Href_Person_Work_Places.Lock_Load(i_Company_Id => Ui.Company_Id, i_Person_Work_Place_Id => v_Person_Work_Place_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Work_Place_Delete(i_Company_Id           => Ui.Company_Id,
                                      i_Person_Work_Place_Id => v_Person_Work_Place_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Award(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Href_Person_Awards%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Awards.Exist_Lock(i_Company_Id      => Ui.Company_Id,
                                           i_Person_Award_Id => p.o_Number('person_award_id'),
                                           o_Row             => r_Data) then
      r_Data.Company_Id      := Ui.Company_Id;
      r_Data.Person_Award_Id := Href_Next.Person_Award_Id;
    end if;
  
    z_Href_Person_Awards.To_Row(r_Data, p, z.Award_Id, z.Doc_Title, z.Doc_Number, z.Doc_Date);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Award_Save(r_Data);
  
    return z_Href_Person_Awards.To_Map(r_Data, z.Person_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Award(p Hashmap) is
    v_Person_Award_Id number := p.r_Number('person_award_id');
    v_Person_Id       number;
  begin
    v_Person_Id := z_Href_Person_Awards.Load(i_Company_Id => Ui.Company_Id, i_Person_Award_Id => v_Person_Award_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Award_Delete(i_Company_Id      => Ui.Company_Id,
                                 i_Person_Award_Id => v_Person_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Experience_Types
       set Company_Id         = null,
           Experience_Type_Id = null,
           name               = null,
           State              = null,
           Code               = null;
    update Href_Awards
       set Company_Id = null,
           Award_Id   = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr44;
/
