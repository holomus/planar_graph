create or replace package Ui_Vhr298 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Languages return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure save(p Hashmap);
end Ui_Vhr298;
/
create or replace package body Ui_Vhr298 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Languages return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_langs', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('lang_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_edu_stages',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('edu_stage_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    r_Setting          Href_Candidate_Ref_Settings%rowtype;
    v_Matrix_Lang      Matrix_Varchar2;
    v_Matrix_Edu_Stage Matrix_Varchar2;
    result             Hashmap := Hashmap();
  begin
    r_Setting := Href_Util.Load_Candidate_Form_Settings(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id);
  
    result := z_Href_Candidate_Ref_Settings.To_Map(r_Setting,
                                                   z.Company_Id,
                                                   z.Region,
                                                   z.Address,
                                                   z.Experience,
                                                   z.Source,
                                                   z.Recommendation,
                                                   z.Cv);
  
    select Array_Varchar2(q.Lang_Id,
                          (select w.Name
                             from Href_Langs w
                            where w.Company_Id = Ui.Company_Id
                              and w.Lang_Id = q.Lang_Id))
      bulk collect
      into v_Matrix_Lang
      from Href_Candidate_Langs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
     order by q.Order_No;
  
    select Array_Varchar2(q.Edu_Stage_Id,
                          (select w.Name
                             from Href_Edu_Stages w
                            where w.Company_Id = Ui.Company_Id
                              and w.Edu_Stage_Id = q.Edu_Stage_Id))
      bulk collect
      into v_Matrix_Edu_Stage
      from Href_Candidate_Edu_Stages q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
     order by q.Order_No;
  
    Result.Put('langs', Fazo.Zip_Matrix(v_Matrix_Lang));
    Result.Put('edu_stages', Fazo.Zip_Matrix(v_Matrix_Edu_Stage));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Settings      Href_Candidate_Ref_Settings%rowtype;
    v_Lang_Ids      Array_Number := p.r_Array_Number('lang_ids');
    v_Edu_Stage_Ids Array_Number := p.r_Array_Number('edu_stage_ids');
  begin
    r_Settings            := z_Href_Candidate_Ref_Settings.To_Row(p,
                                                                  z.Region,
                                                                  z.Address,
                                                                  z.Experience,
                                                                  z.Source,
                                                                  z.Recommendation,
                                                                  z.Cv);
    r_Settings.Company_Id := Ui.Company_Id;
    r_Settings.Filial_Id  := Ui.Filial_Id;
  
    Href_Api.Candidate_Setting_Save(r_Settings);
  
    Href_Api.Candidate_Langs_Save(i_Company_Id => Ui.Company_Id,
                                  i_Fillial_Id => Ui.Filial_Id,
                                  i_Lang_Ids   => v_Lang_Ids);
  
    Href_Api.Candidate_Edu_Stages_Save(i_Company_Id    => Ui.Company_Id,
                                       i_Fillial_Id    => Ui.Filial_Id,
                                       i_Edu_Stage_Ids => v_Edu_Stage_Ids);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Langs
       set Company_Id = null,
           Lang_Id    = null,
           name       = null,
           State      = null;
    update Href_Edu_Stages
       set Company_Id   = null,
           Edu_Stage_Id = null,
           name         = null,
           State        = null;
  end;

end Ui_Vhr298;
/
