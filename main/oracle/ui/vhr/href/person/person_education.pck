create or replace package Ui_Vhr41 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Specialties return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Lang_Levels return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Institutions return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Lang(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Lang(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Save_Edu_Stage(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Edu_Stage(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Download_Edu_Stage_Files(p Hashmap) return Fazo_File;
end Ui_Vhr41;
/
create or replace package body Ui_Vhr41 is
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
    return b.Translate('UI-VHR41:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Specialties return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_specialties',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('specialty_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_langs', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('lang_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Lang_Levels return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_lang_levels',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('lang_level_id');
    q.Varchar2_Field('name', 'order_no');
  
    return q;
  end;

  --------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_edu_stages',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('edu_stage_id');
    q.Varchar2_Field('name', 'order_no');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Institutions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_institutions',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('institution_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Langs(i_Person_Id number) return Arraylist is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Lang_Id,
                          (select w.Name
                             from Href_Langs w
                            where w.Company_Id = q.Company_Id
                              and w.Lang_Id = q.Lang_Id),
                          q.Lang_Level_Id,
                          (select w.Name
                             from Href_Lang_Levels w
                            where w.Company_Id = q.Company_Id
                              and w.Lang_Level_Id = q.Lang_Level_Id))
      bulk collect
      into v_Matrix
      from Href_Person_Langs q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = i_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Edu_Stages(i_Person_Id number) return Hashmap is
    v_Matrix Matrix_Varchar2;
    v_Array  Array_Number;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Person_Edu_Stage_Id,
                          q.Edu_Stage_Id,
                          (select w.Name
                             from Href_Edu_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Edu_Stage_Id = q.Edu_Stage_Id),
                          q.Institution_Id,
                          (select w.Name
                             from Href_Institutions w
                            where w.Company_Id = q.Company_Id
                              and w.Institution_Id = q.Institution_Id),
                          q.Begin_Date,
                          q.End_Date,
                          q.Specialty_Id,
                          (select w.Name
                             from Href_Specialties w
                            where w.Company_Id = q.Company_Id
                              and w.Specialty_Id = q.Specialty_Id),
                          q.Qualification,
                          q.Course,
                          q.Hour_Amount,
                          q.Base)
      bulk collect
      into v_Matrix
      from Href_Person_Edu_Stages q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = i_Person_Id;
  
    Result.Put('edu_stages', Fazo.Zip_Matrix(v_Matrix));
  
    if v_Matrix.Count > 0 then
      v_Array := Fazo.To_Array_Number(Fazo.Column(v_Matrix, 1));
    else
      v_Array := Array_Number();
    end if;
  
    select Array_Varchar2(q.Person_Edu_Stage_Id,
                          q.Sha,
                          (select w.File_Name
                             from Biruni_Files w
                            where w.Sha = q.Sha))
      bulk collect
      into v_Matrix
      from Href_Person_Edu_Stage_Files q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Edu_Stage_Id member of v_Array;
  
    Result.Put('edu_stage_files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Result.Put('person_langs', Get_Person_Langs(v_Person_Id));
    Result.Put('person_edu_stages', Get_Person_Edu_Stages(v_Person_Id));
    Result.Put('person_id', v_Person_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Lang(p Hashmap) is
    r_Data           Href_Person_Langs%rowtype;
    v_Person_Id      number := p.r_Number('person_id');
    v_Lang_Ids       Array_Number := p.r_Array_Number('lang_ids');
    v_Lang_Level_Ids Array_Number := p.r_Array_Number('lang_level_ids');
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Person_Id  := v_Person_Id;
  
    for r in (select q.Lang_Id
                from Href_Person_Langs q
               where q.Company_Id = Ui.Company_Id
                 and q.Person_Id = v_Person_Id)
    loop
      Href_Api.Person_Lang_Delete(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => v_Person_Id,
                                  i_Lang_Id    => r.Lang_Id);
    end loop;
  
    for i in 1 .. v_Lang_Ids.Count
    loop
      r_Data.Lang_Id       := v_Lang_Ids(i);
      r_Data.Lang_Level_Id := v_Lang_Level_Ids(i);
    
      Href_Api.Person_Lang_Save(r_Data);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Lang(p Hashmap) is
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Lang_Delete(i_Company_Id => Ui.Company_Id,
                                i_Person_Id  => v_Person_Id,
                                i_Lang_Id    => p.r_Number('lang_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Edu_Stage(p Hashmap) return Hashmap is
    r_Data      Href_Person_Edu_Stages%rowtype;
    v_Shas      Array_Varchar2 := p.r_Array_Varchar2('shas');
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Edu_Stages.Exist_Lock(i_Company_Id          => Ui.Company_Id,
                                               i_Person_Edu_Stage_Id => p.o_Number('person_edu_stage_id'),
                                               o_Row                 => r_Data) then
      r_Data.Company_Id          := Ui.Company_Id;
      r_Data.Person_Edu_Stage_Id := Href_Next.Person_Edu_Stage_Id;
    end if;
  
    z_Href_Person_Edu_Stages.To_Row(r_Data,
                                    p,
                                    z.Edu_Stage_Id,
                                    z.Institution_Id,
                                    z.Begin_Date,
                                    z.End_Date,
                                    z.Specialty_Id,
                                    z.Qualification,
                                    z.Course,
                                    z.Hour_Amount,
                                    z.Base);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Edu_Stage_Save(r_Data);
  
    for i in 1 .. v_Shas.Count
    loop
      Href_Api.Person_Edu_Stage_File_Save(i_Company_Id          => r_Data.Company_Id,
                                          i_Person_Edu_Stage_Id => r_Data.Person_Edu_Stage_Id,
                                          i_Sha                 => v_Shas(i));
    end loop;
  
    for r in (select *
                from Href_Person_Edu_Stage_Files q
               where q.Company_Id = r_Data.Company_Id
                 and q.Person_Edu_Stage_Id = r_Data.Person_Edu_Stage_Id
                 and q.Sha not member of v_Shas)
    loop
      Href_Api.Person_Edu_Stage_File_Delete(i_Company_Id          => r.Company_Id,
                                            i_Person_Edu_Stage_Id => r.Person_Edu_Stage_Id,
                                            i_Sha                 => r.Sha);
    end loop;
  
    result := z_Href_Person_Edu_Stages.To_Map(r_Data, z.Person_Edu_Stage_Id);
  
    select Array_Varchar2(q.Sha,
                          (select s.File_Name
                             from Biruni_Files s
                            where s.Sha = q.Sha))
      bulk collect
      into v_Matrix
      from Href_Person_Edu_Stage_Files q
     where q.Company_Id = r_Data.Company_Id
       and q.Person_Edu_Stage_Id = r_Data.Person_Edu_Stage_Id;
  
    Result.Put('files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Edu_Stage(p Hashmap) is
    v_Person_Edu_Stage_Id number := p.r_Varchar2('person_edu_stage_id');
    v_Person_Id           number;
  begin
    v_Person_Id := z_Href_Person_Edu_Stages.Lock_Load(i_Company_Id => Ui.Company_Id, --
                   i_Person_Edu_Stage_Id => v_Person_Edu_Stage_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Edu_Stage_Delete(i_Company_Id          => Ui.Company_Id,
                                     i_Person_Edu_Stage_Id => v_Person_Edu_Stage_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Download_Edu_Stage_Files(p Hashmap) return Fazo_File is
    r_Data Href_Person_Edu_Stages%rowtype;
    v_Shas Array_Varchar2;
  begin
    r_Data := z_Href_Person_Edu_Stages.Take(i_Company_Id          => Ui.Company_Id,
                                            i_Person_Edu_Stage_Id => p.r_Varchar2('person_edu_stage_id'));
  
    Uit_Href.Assert_Access_To_Employee(r_Data.Person_Id);
  
    select q.Sha
      bulk collect
      into v_Shas
      from Href_Person_Edu_Stage_Files q
     where q.Company_Id = r_Data.Company_Id
       and q.Person_Edu_Stage_Id = r_Data.Person_Edu_Stage_Id;
  
    return Ui_Kernel.Download_Files(i_Shas            => v_Shas,
                                    i_Attachment_Name => t('person edu stage files, edu_stage_name=$1',
                                                           z_Href_Edu_Stages.Take(i_Company_Id => Ui.Company_Id, --
                                                           i_Edu_Stage_Id => r_Data.Edu_Stage_Id).Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Specialties
       set Company_Id   = null,
           Specialty_Id = null,
           name         = null,
           State        = null;
    update Href_Langs
       set Company_Id = null,
           Lang_Id    = null,
           name       = null,
           State      = null;
    update Href_Lang_Levels
       set Company_Id    = null,
           Lang_Level_Id = null,
           name          = null,
           State         = null,
           Order_No      = null;
    update Href_Edu_Stages
       set Company_Id   = null,
           Edu_Stage_Id = null,
           name         = null,
           State        = null,
           Order_No     = null;
    update Href_Institutions
       set Company_Id     = null,
           Institution_Id = null,
           name           = null,
           State          = null;
  end;

end Ui_Vhr41;
/
