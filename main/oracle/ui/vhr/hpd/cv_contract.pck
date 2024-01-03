create or replace package Ui_Vhr327 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Service_Names return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr327;
/
create or replace package body Ui_Vhr327 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Service_Names return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_cached_contract_item_names',
                    Fazo.Zip_Map('company_id', Ui.Company_Id),
                    true);
  
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.name, 
                            q.person_id
                       from mr_natural_persons q
                      where q.company_id = :company_id
                        and exists (select 1
                               from mrf_persons w
                              where w.company_id = :company_id
                                and w.filial_id = :filial_id
                                and w.person_id = q.person_id
                                and w.state = ''A'')',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('contract_kind', Hpd_Pref.c_Cv_Contract_Kind_Simple);
    Result.Put('access_to_add_item', 'Y');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Contract Hpd_Cv_Contracts%rowtype;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Load(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Contract_Id => p.r_Number('contract_id'));
  
    Uit_Href.Assert_Access_To_Division(i_Division_Id => r_Contract.Division_Id);
  
    if r_Contract.Contract_Employment_Kind = Hpd_Pref.c_Contract_Employment_Staff_Member then
      b.Raise_Not_Implemented;
    end if;
  
    result := z_Hpd_Cv_Contracts.To_Map(r_Contract,
                                        z.Contract_Id,
                                        z.Contract_Number,
                                        z.Division_Id,
                                        z.Person_Id,
                                        z.Begin_Date,
                                        z.End_Date,
                                        z.Contract_Kind,
                                        z.Access_To_Add_Item,
                                        z.Posted,
                                        z.Note);
  
    Result.Put('person_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Contract.Company_Id, i_Person_Id => r_Contract.Person_Id).Name);
  
    select Array_Varchar2(q.Contract_Item_Id, q.Name, q.Quantity, q.Amount)
      bulk collect
      into v_Matrix
      from Hpd_Cv_Contract_Items q
     where q.Company_Id = r_Contract.Company_Id
       and q.Filial_Id = r_Contract.Filial_Id
       and q.Contract_Id = r_Contract.Contract_Id;
  
    Result.Put('services', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.File_Sha,
                          (select s.File_Name
                             from Biruni_Files s
                            where s.Sha = q.File_Sha),
                          q.Note)
      bulk collect
      into v_Matrix
      from Hpd_Cv_Contract_Files q
     where q.Company_Id = r_Contract.Company_Id
       and q.Filial_Id = r_Contract.Filial_Id
       and q.Contract_Id = r_Contract.Contract_Id;
  
    Result.Put('files', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('references', References(r_Contract.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p             Hashmap,
    i_Contract_Id number
  ) is
    v_Contract          Hpd_Pref.Cv_Contract_Rt;
    v_Contract_Services Arraylist := p.o_Arraylist('services');
    v_Item              Hashmap;
    v_Item_Id           number;
    v_Contract_Files    Arraylist := p.o_Arraylist('files');
    v_File              Hashmap;
    v_Division_Id       number := p.r_Number('division_id');
  begin
    Uit_Href.Assert_Access_To_Division(i_Division_Id => v_Division_Id);
  
    Hpd_Util.Cv_Contract_New(o_Contract                 => v_Contract,
                             i_Company_Id               => Ui.Company_Id,
                             i_Filial_Id                => Ui.Filial_Id,
                             i_Contract_Id              => i_Contract_Id,
                             i_Contract_Number          => p.o_Varchar2('contract_number'),
                             i_Division_Id              => v_Division_Id,
                             i_Person_Id                => p.r_Number('person_id'),
                             i_Begin_Date               => p.r_Date('begin_date'),
                             i_End_Date                 => p.r_Date('end_date'),
                             i_Contract_Kind            => p.r_Varchar2('contract_kind'),
                             i_Contract_Employment_Kind => Hpd_Pref.c_Contract_Employment_Freelancer,
                             i_Access_To_Add_Item       => p.r_Varchar2('access_to_add_item'),
                             i_Early_Closed_Date        => null,
                             i_Early_Closed_Note        => null,
                             i_Note                     => p.o_Varchar2('note'));
  
    for i in 1 .. v_Contract_Services.Count
    loop
      v_Item    := Treat(v_Contract_Services.r_Hashmap(i) as Hashmap);
      v_Item_Id := v_Item.o_Number('contract_item_id');
    
      if v_Item_Id is null then
        v_Item_Id := Hpd_Next.Cv_Contract_Item_Id;
      end if;
    
      Hpd_Util.Cv_Contract_Add_Item(o_Contract         => v_Contract,
                                    i_Contract_Item_Id => v_Item_Id,
                                    i_Name             => v_Item.r_Varchar2('name'),
                                    i_Quantity         => v_Item.o_Number('quantity'),
                                    i_Amount           => v_Item.o_Number('amount'));
    end loop;
  
    for i in 1 .. v_Contract_Files.Count
    loop
      v_File := Treat(v_Contract_Files.r_Hashmap(i) as Hashmap);
    
      Hpd_Util.Cv_Contract_Add_File(o_Contract => v_Contract,
                                    i_File_Sha => v_File.r_Varchar2('file_sha'),
                                    i_Note     => v_File.o_Varchar2('note'));
    end loop;
  
    Hpd_Api.Cv_Contract_Save(v_Contract);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Cv_Contract_Post(i_Company_Id  => v_Contract.Company_Id,
                               i_Filial_Id   => v_Contract.Filial_Id,
                               i_Contract_Id => v_Contract.Contract_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(p, Hpd_Next.Cv_Contract_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Contract Hpd_Cv_Contracts%rowtype;
  begin
    r_Contract := z_Hpd_Cv_Contracts.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                               i_Filial_Id   => Ui.Filial_Id,
                                               i_Contract_Id => p.r_Number('contract_id'));
  
    if r_Contract.Posted = 'Y' then
      Hpd_Api.Cv_Contract_Unpost(i_Company_Id  => r_Contract.Company_Id,
                                 i_Filial_Id   => r_Contract.Filial_Id,
                                 i_Contract_Id => r_Contract.Contract_Id);
    end if;
  
    save(p, r_Contract.Contract_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Cached_Contract_Item_Names
       set Company_Id = null,
           name       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null,
           State      = null;
  end;

end Ui_Vhr327;
/
