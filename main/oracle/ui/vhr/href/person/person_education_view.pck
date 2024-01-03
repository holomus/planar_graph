create or replace package Ui_Vhr154 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Download_Edu_Stage_Files(p Hashmap) return Fazo_File;
end Ui_Vhr154;
/
create or replace package body Ui_Vhr154 is
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
    return b.Translate('UI-VHR154:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Langs(i_Person_Id number) return Arraylist is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2((select w.Name
                            from Href_Langs w
                           where w.Company_Id = q.Company_Id
                             and w.Lang_Id = q.Lang_Id),
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
  Function Get_Person_Edu_Stages(i_Person_Id number) return Arraylist is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Person_Edu_Stage_Id,
                          (select w.Name
                             from Href_Edu_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Edu_Stage_Id = q.Edu_Stage_Id),
                          (select w.Name
                             from Href_Institutions w
                            where w.Company_Id = q.Company_Id
                              and w.Institution_Id = q.Institution_Id),
                          q.Begin_Date,
                          q.End_Date,
                          (select w.Name
                             from Href_Specialties w
                            where w.Company_Id = q.Company_Id
                              and w.Specialty_Id = q.Specialty_Id),
                          q.Qualification,
                          q.Course,
                          q.Hour_Amount,
                          q.Base,
                          (select Listagg(w.File_Name, ', ') Within group(order by w.File_Name)
                             from Biruni_Files w
                             join Href_Person_Edu_Stage_Files k
                               on k.Company_Id = q.Company_Id
                              and k.Person_Edu_Stage_Id = q.Person_Edu_Stage_Id
                              and w.Sha = k.Sha))
      bulk collect
      into v_Matrix
      from Href_Person_Edu_Stages q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = i_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    Result.Put('person_langs', Get_Person_Langs(v_Person_Id));
    Result.Put('person_edu_stages', Get_Person_Edu_Stages(v_Person_Id));
    Result.Put('person_id', v_Person_Id);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Download_Edu_Stage_Files(p Hashmap) return Fazo_File is
    v_Person_Edu_Stage_Id number := p.r_Varchar2('person_edu_stage_id');
    v_Edu_Stage_Name      varchar2(100 char);
    v_Shas                Array_Varchar2;
  begin
    select q.Sha
      bulk collect
      into v_Shas
      from Href_Person_Edu_Stage_Files q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Edu_Stage_Id = v_Person_Edu_Stage_Id;
  
    v_Edu_Stage_Name := z_Href_Edu_Stages.Take(i_Company_Id => Ui.Company_Id, i_Edu_Stage_Id => z_Href_Person_Edu_Stages.Take --
                        (i_Company_Id => Ui.Company_Id, --
                        i_Person_Edu_Stage_Id => v_Person_Edu_Stage_Id --
                        ).Edu_Stage_Id).Name;
  
    return Ui_Kernel.Download_Files(i_Shas            => v_Shas,
                                    i_Attachment_Name => t('person edu stage files, edu_stage_name=$1',
                                                           v_Edu_Stage_Name));
  end;

end Ui_Vhr154;
/
