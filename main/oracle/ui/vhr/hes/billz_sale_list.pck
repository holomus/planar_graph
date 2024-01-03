create or replace package Ui_Vhr480 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Sales(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Credentials(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr480;
/
create or replace package body Ui_Vhr480 is
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
    return b.Translate('UI-VHR480:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select t.billz_office_id,
                            t.billz_office_name,
                            t.billz_seller_id,
                            t.billz_seller_name,
                            t.sale_date,
                            t.sale_amount
                       from hes_billz_consolidated_sales t
                      where t.company_id = :company_id
                        and t.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('billz_office_id', 'billz_seller_id', 'sale_amount');
    q.Varchar2_Field('billz_office_name', 'billz_seller_name');
    q.Date_Field('sale_date');
  
    q.Refer_Field('division_name',
                  'billz_office_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'code',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('employee_name',
                  'billz_seller_id',
                  'select * 
                     from mr_natural_persons s
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees w
                            where w.company_id = s.company_id
                              and w.filial_id = :filial_id
                              and w.employee_id = s.person_id)',
                  'code',
                  'name',
                  'select * 
                     from mr_natural_persons s
                    where s.company_id = :company_id
                      and exists (select 1
                             from mhr_employees w
                            where w.company_id = s.company_id
                              and w.filial_id = :filial_id
                              and w.employee_id = s.person_id)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Sales(p Hashmap) return Runtime_Service is
  begin
    return Hes_Api.Build_Billz_Runtime_Service(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Date_Begin => p.r_Date('date_begin'),
                                               i_Date_End   => Nvl(p.o_Date('date_end'), sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Credentials(p Hashmap) is
  begin
    Hes_Api.Billz_Credential_Save(i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Subject_Name => p.r_Varchar2('subject_name'),
                                  i_Secret_Key   => p.r_Varchar2('secret_key'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Credential Hes_Billz_Credentials%rowtype;
    result       Hashmap := Hashmap();
  begin
    if Ui.Grant_Has('save_credentials') then
      r_Credential := z_Hes_Billz_Credentials.Take(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id);
    
      result := z_Hes_Billz_Credentials.To_Map(r_Credential, z.Subject_Name, z.Secret_Key);
    end if;
  
    Result.Put('date_begin', Trunc(sysdate, 'mm'));
    Result.Put('date_end', Trunc(sysdate));
  
    return result;
  end;

end Ui_Vhr480;
/
