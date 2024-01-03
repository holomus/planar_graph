create or replace package Ui_Vhr328 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Accept(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Return_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap);
end Ui_Vhr328;
/
create or replace package body Ui_Vhr328 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select w.*, 
                       q.fact_id, 
                       q.month, 
                       q.status, 
                       q.total_amount
                  from hpr_cv_contract_facts q
                  join hpd_cv_contracts w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.contract_id = q.contract_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and w.division_id member of :division_ids';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('fact_id', 'contract_id', 'total_amount', 'division_id', 'person_id');
    q.Varchar2_Field('status', 'contract_number', 'contract_kind');
    q.Date_Field('month');
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
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
  
    v_Matrix := Hpr_Util.Cv_Fact_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_To_Division
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  ) is
    r_Fact Hpr_Cv_Contract_Facts%rowtype;
  begin
    r_Fact := z_Hpr_Cv_Contract_Facts.Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Fact_Id    => i_Fact_Id);
  
    Uit_Href.Assert_Access_To_Division(z_Hpd_Cv_Contracts.Load(i_Company_Id => i_Company_Id, --
                                       i_Filial_Id => i_Filial_Id, --
                                       i_Contract_Id => r_Fact.Contract_Id).Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Accept(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('fact_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Assert_Access_To_Division(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Fact_Id    => v_Ids(i));
    
      Hpr_Api.Cv_Contract_Fact_Accept(i_Company_Id => v_Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Fact_Id    => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Return_Complete(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('fact_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Assert_Access_To_Division(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Fact_Id    => v_Ids(i));
    
      Hpr_Api.Cv_Contract_Fact_Return_Complete(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id,
                                               i_Fact_Id    => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('fact_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Assert_Access_To_Division(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Fact_Id    => v_Ids(i));
    
      Hpr_Api.Cv_Contract_Fact_New(i_Company_Id => v_Company_Id,
                                   i_Filial_Id  => v_Filial_Id,
                                   i_Fact_Id    => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transactions(p Hashmap) is
    v_Fact_Id number := p.r_Number('fact_id');
  begin
    Ui.Grant_Check('transactions');
  
    Assert_Access_To_Division(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Fact_Id    => v_Fact_Id);
  
    Uit_Mkr.Journal_Transactions_Run(i_Company_Id   => Ui.Company_Id,
                                     i_Filial_Id    => Ui.Filial_Id,
                                     i_Journal_Code => Hpr_Util.Jcode_Cv_Contract_Fact(v_Fact_Id),
                                     i_Report_Type  => p.r_Varchar2('rt'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpr_Cv_Contract_Facts
       set Company_Id   = null,
           Filial_Id    = null,
           Fact_Id      = null,
           Contract_Id  = null,
           month        = null,
           Total_Amount = null,
           Status       = null;
    update Hpd_Cv_Contracts
       set Company_Id         = null,
           Filial_Id          = null,
           Contract_Id        = null,
           Contract_Number    = null,
           Division_Id        = null,
           Person_Id          = null,
           Begin_Date         = null,
           End_Date           = null,
           Contract_Kind      = null,
           Access_To_Add_Item = null,
           Posted             = null,
           Early_Closed_Date  = null,
           Early_Closed_Note  = null,
           Note               = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           Parent_Id   = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr328;
/
