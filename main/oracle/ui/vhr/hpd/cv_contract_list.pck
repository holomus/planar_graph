create or replace package Ui_Vhr326 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Close(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Delete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Unpost(p Hashmap);
end Ui_Vhr326;
/
create or replace package body Ui_Vhr326 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(4000);
    v_Matrix Matrix_Varchar2;
    v_Params Hashmap;
  begin
    v_Query := 'select *
                  from hpd_cv_contracts q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || --
                 ' and q.division_id member of :division_ids';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Varchar2_Field('contract_number',
                     'contract_kind',
                     'access_to_add_item',
                     'posted',
                     'early_closed_note',
                     'contract_employment_kind',
                     'note');
    q.Number_Field('contract_id', 'division_id', 'person_id', 'page_id');
    q.Date_Field('begin_date', 'end_date', 'early_closed_date');
  
    q.Multi_Number_Field('service_names',
                         'select q.contract_id,
                                 q.name
                            from hpd_cv_contract_items q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id',
                         '@contract_id = $contract_id',
                         'name');
  
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
  
    q.Refer_Field('person_name',
                  'person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons q
                    where q.company_id = :company_id');
  
    q.Refer_Field(i_Name       => 'journal_id',
                  i_For        => 'page_id',
                  i_Table_Name => 'select t.*
                                     from hpd_journal_pages t
                                    where t.company_id = :company_id
                                      and t.filial_id = :filial_id',
                  i_Code_Field => 'page_id',
                  i_Name_Field => 'journal_id');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('access_to_add_item_name',
                   'access_to_add_item',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Hpd_Util.Contract_Employments;
  
    q.Option_Field('contract_employment_kind_name',
                   'contract_employment_kind',
                   v_Matrix(1),
                   v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('references',
               Fazo.Zip_Map('cek_freelancer',
                            Hpd_Pref.c_Contract_Employment_Freelancer,
                            'cek_staff_member',
                            Hpd_Pref.c_Contract_Employment_Staff_Member,
                            'contract_type_id',
                            Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                     i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Division
  (
    i_Company_Id  number,
    i_Filail_Id   number,
    i_Contract_Id number
  ) is
  begin
    Uit_Href.Assert_Access_To_Division(z_Hpd_Cv_Contracts.Load(i_Company_Id => i_Company_Id, -- 
                                       i_Filial_Id => i_Filail_Id, --
                                       i_Contract_Id => i_Contract_Id).Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Close(p Hashmap) is
    v_Contract_Id number := p.r_Number('contract_id');
  begin
    Assert_Access_To_Division(i_Company_Id  => Ui.Company_Id,
                              i_Filail_Id   => Ui.Filial_Id,
                              i_Contract_Id => v_Contract_Id);
  
    Hpd_Api.Cv_Contract_Close(i_Company_Id        => Ui.Company_Id,
                              i_Filial_Id         => Ui.Filial_Id,
                              i_Contract_Id       => v_Contract_Id,
                              i_Early_Closed_Date => p.r_Date('early_closed_date'),
                              i_Early_Closed_Note => p.o_Varchar2('early_closed_note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Delete(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Contract_Ids Array_Number := Fazo.Sort(p.r_Array_Number('contract_id'));
  begin
    for i in 1 .. v_Contract_Ids.Count
    loop
      Assert_Access_To_Division(i_Company_Id  => v_Company_Id,
                                i_Filail_Id   => v_Filial_Id,
                                i_Contract_Id => v_Contract_Ids(i));
    
      Hpd_Api.Cv_Contract_Delete(i_Company_Id  => v_Company_Id,
                                 i_Filial_Id   => v_Filial_Id,
                                 i_Contract_Id => v_Contract_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Post(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Contract_Ids Array_Number := Fazo.Sort(p.r_Array_Number('contract_id'));
  begin
    for i in 1 .. v_Contract_Ids.Count
    loop
      Assert_Access_To_Division(i_Company_Id  => v_Company_Id,
                                i_Filail_Id   => v_Filial_Id,
                                i_Contract_Id => v_Contract_Ids(i));
    
      Hpd_Api.Cv_Contract_Post(i_Company_Id  => v_Company_Id,
                               i_Filial_Id   => v_Filial_Id,
                               i_Contract_Id => v_Contract_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Contract_Unpost(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Contract_Ids Array_Number := Fazo.Sort(p.r_Array_Number('contract_id'));
  begin
    for i in 1 .. v_Contract_Ids.Count
    loop
      Assert_Access_To_Division(i_Company_Id  => v_Company_Id,
                                i_Filail_Id   => v_Filial_Id,
                                i_Contract_Id => v_Contract_Ids(i));
    
      Hpd_Api.Cv_Contract_Unpost(i_Company_Id  => v_Company_Id,
                                 i_Filial_Id   => v_Filial_Id,
                                 i_Contract_Id => v_Contract_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Cv_Contracts
       set Company_Id               = null,
           Filial_Id                = null,
           Contract_Id              = null,
           Contract_Number          = null,
           Page_Id                  = null,
           Division_Id              = null,
           Person_Id                = null,
           Begin_Date               = null,
           End_Date                 = null,
           Contract_Kind            = null,
           Contract_Employment_Kind = null,
           Access_To_Add_Item       = null,
           Posted                   = null,
           Early_Closed_Date        = null,
           Early_Closed_Note        = null,
           Note                     = null;
  
    update Hpd_Cv_Contract_Items
       set Company_Id  = null,
           Filial_Id   = null,
           Contract_Id = null,
           name        = null;
  
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  
    update Hpd_Journal_Pages
       set Company_Id = null,
           Filial_Id  = null,
           Page_Id    = null,
           Journal_Id = null;
  end;

end Ui_Vhr326;
/
