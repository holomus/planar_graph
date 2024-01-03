create or replace package Ui_Vhr331 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Cached_Names return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Fact_Save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Fact_Complete(p Hashmap);
end Ui_Vhr331;
/
create or replace package body Ui_Vhr331 is
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
    return b.Translate('UI-VHR331:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Cached_Names return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_cached_contract_item_names',
                    Fazo.Zip_Map('company_id', Ui.Company_Id),
                    true);
  
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Contract Hpd_Cv_Contracts%rowtype;
    r_Fact     Hpr_Cv_Contract_Facts%rowtype;
    v_Item     Matrix_Varchar2;
    result     Hashmap;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Fact_Id    => p.r_Number('fact_id'));
  
    if r_Fact.Status = Hpr_Pref.c_Cv_Contract_Fact_Status_Accept then
      b.Raise_Error(t('this fact is already accepted, fact_id=$1', p.r_Number('fact_id')));
    end if;
  
    r_Contract := z_Hpd_Cv_Contracts.Load(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Contract_Id => r_Fact.Contract_Id);
  
    Uit_Href.Assert_Access_To_Division(i_Division_Id => r_Contract.Division_Id);
  
    result := z_Hpd_Cv_Contracts.To_Map(r_Contract,
                                        z.Contract_Id,
                                        z.Contract_Number,
                                        z.Begin_Date,
                                        z.End_Date,
                                        z.Access_To_Add_Item,
                                        z.Early_Closed_Date,
                                        z.Early_Closed_Note,
                                        z.Note);
  
    Result.Put('fact_id', r_Fact.Fact_Id);
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Contract.Company_Id, --
               i_Filial_Id => r_Contract.Filial_Id, --
               i_Division_Id => r_Contract.Division_Id).Name);
    Result.Put('person_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Contract.Company_Id, --
               i_Person_Id => r_Contract.Person_Id).Name);
    Result.Put('contract_kind_name', Hpd_Util.t_Cv_Contract_Kind(r_Contract.Contract_Kind));
  
    select Array_Varchar2(q.Fact_Item_Id,
                          q.Contract_Item_Id,
                          q.Plan_Quantity,
                          q.Plan_Amount,
                          q.Fact_Quantity,
                          q.Fact_Amount,
                          q.Name)
      bulk collect
      into v_Item
      from Hpr_Cv_Contract_Fact_Items q
     where q.Company_Id = r_Contract.Company_Id
       and q.Filial_Id = r_Contract.Filial_Id
       and q.Fact_Id = r_Fact.Fact_Id
     order by q.Contract_Item_Id nulls last;
  
    Result.Put('items', Fazo.Zip_Matrix(v_Item));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fact_Save(p Hashmap) is
    v_Fact_Item_Ids Array_Number := p.r_Array_Number('fact_item_ids');
    v_Names         Array_Varchar2 := p.r_Array_Varchar2('names');
    v_Quants        Array_Number := p.r_Array_Number('quantities');
    v_Amounts       Array_Number := p.r_Array_Number('amounts');
  
    v_Contract_Fact Hpr_Pref.Cv_Contract_Fact_Rt;
    v_Fact_Item_Id  number;
    v_Fact_Id       number := p.r_Number('fact_id');
    r_Fact          Hpr_Cv_Contract_Facts%rowtype;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Fact_Id    => v_Fact_Id);
  
    Uit_Href.Assert_Access_To_Division(z_Hpd_Cv_Contracts.Load(i_Company_Id => r_Fact.Company_Id, --
                                       i_Filial_Id => r_Fact.Filial_Id, --
                                       i_Contract_Id => r_Fact.Contract_Id).Division_Id);
  
    Hpr_Util.Cv_Contract_Fact_New(o_Contract_Fact => v_Contract_Fact,
                                  i_Company_Id    => r_Fact.Company_Id,
                                  i_Filial_Id     => r_Fact.Filial_Id,
                                  i_Fact_Id       => v_Fact_Id);
  
    for i in 1 .. v_Fact_Item_Ids.Count
    loop
      v_Fact_Item_Id := v_Fact_Item_Ids(i);
    
      if v_Fact_Item_Id is null then
        v_Fact_Item_Id := Hpr_Next.Cv_Contract_Fact_Item_Id;
      end if;
    
      Hpr_Util.Cv_Contract_Fact_Add_Item(o_Contract_Fact => v_Contract_Fact,
                                         i_Fact_Item_Id  => v_Fact_Item_Id,
                                         i_Fact_Quantity => v_Quants(i),
                                         i_Fact_Amount   => v_Amounts(i),
                                         i_Name          => v_Names(i));
    end loop;
  
    Hpr_Api.Cv_Contract_Fact_Save(v_Contract_Fact);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fact_Complete(p Hashmap) is
  begin
    Fact_Save(p);
  
    Hpr_Api.Cv_Contract_Fact_To_Complete(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Fact_Id    => p.r_Number('fact_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Cached_Contract_Item_Names
       set Company_Id = null,
           name       = null;
  end;

end Ui_Vhr331;
/
