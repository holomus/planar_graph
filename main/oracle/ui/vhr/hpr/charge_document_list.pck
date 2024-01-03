create or replace package Ui_Vhr613 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Accrual_Documents return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Deduction_Documents return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr613;
/
create or replace package body Ui_Vhr613 is
  ----------------------------------------------------------------------------------------------------
  Function Query(i_Document_Kind varchar2) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hpr_charge_documents',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'document_kind',
                                 i_Document_Kind),
                    true);
  
    q.Number_Field('document_id', 'division_id', 'currency_id', 'created_by', 'modified_by');
    q.Varchar2_Field('document_number', 'document_name', 'posted');
    q.Date_Field('document_date', 'month', 'created_on', 'modified_on');
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false));
    q.Refer_Field('currency_name',
                  'currency_id',
                  'mk_currencies',
                  'currency_id',
                  'name',
                  'select *
                     from mk_currencies w
                    where w.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Accrual_Documents return Fazo_Query is
  begin
    return Query('A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Deduction_Documents return Fazo_Query is
  begin
    return Query('D');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result      Hashmap := Hashmap();
    v_Templates Matrix_Varchar2 := Matrix_Varchar2();
    v_Form      varchar2(100) := Hpr_Pref.c_Easy_Report_Form_Charge_Document;
  begin
    if Md_Util.Grant_Has_Form(i_Company_Id   => Ui.Company_Id,
                              i_Project_Code => Ui.Project_Code,
                              i_Filial_Id    => Ui.Filial_Id,
                              i_User_Id      => Ui.User_Id,
                              i_Form         => v_Form) then
      v_Templates := Uit_Ker.Templates(i_Form => v_Form);
    end if;
  
    Result.Put('templates', Fazo.Zip_Matrix(v_Templates));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Hpr_Api.Charge_Document_Post(i_Company_Id   => v_Company_Id,
                                   i_Filial_Id    => v_Filial_Id,
                                   i_Documentr_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Hpr_Api.Charge_Document_Unpost(i_Company_Id   => v_Company_Id,
                                     i_Filial_Id    => v_Filial_Id,
                                     i_Documentr_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Hpr_Api.Charge_Document_Delete(i_Company_Id   => v_Company_Id,
                                     i_Filial_Id    => v_Filial_Id,
                                     i_Documentr_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpr_Charge_Documents
       set Company_Id      = null,
           Filial_Id       = null,
           Document_Id     = null,
           Document_Number = null,
           Document_Date   = null,
           Document_Name   = null,
           Posted          = null,
           Document_Kind   = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr613;
/
