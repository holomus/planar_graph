create or replace package Ui_Vhr681 is
  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr681;
/
create or replace package body Ui_Vhr681 is
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
    return b.Translate('UI-VHR681:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist is
    v_Operation_List Arraylist := Arraylist;
    result           Arraylist := Arraylist;
  
    --------------------------------------------------
    Procedure Put
    (
      p_List       in out nocopy Arraylist,
      i_Key        varchar2,
      i_Definition varchar2,
      i_Items      Arraylist := null
    ) is
      v_Map Hashmap;
    begin
      v_Map := Fazo.Zip_Map('key', i_Key, 'definition', i_Definition);
    
      if i_Items is not null then
        v_Map.Put('items', i_Items);
      end if;
    
      p_List.Push(v_Map);
    end;
  begin
    Put(v_Operation_List, 'employee_name', t('employee name'));
    Put(v_Operation_List, 'oper_type_name', t('oper type name'));
    Put(v_Operation_List, 'amount', t('amount'));
    Put(v_Operation_List, 'note', t('note'));
  
    Put(result, 'filial_name', t('filial name'));
    Put(result, 'director_name', t('director name'));
    Put(result, 'director_job_name', t('director job name'));
    Put(result, 'document_date', t('document date'));
    Put(result, 'document_number', t('document number'));
    Put(result, 'document_name', t('document name'));
    Put(result, 'division_name', t('division name'));
    Put(result, 'month', t('month'));
    Put(result, 'currency_name', t('currency name'));
    Put(result, 'oper_type_name', t('oper type name'));
    Put(result, 'operation_list', t('operation list'), v_Operation_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Report(p Hashmap) return Gmap is
    r_Document       Hpr_Charge_Documents%rowtype;
    r_Legal_Person   Mr_Legal_Persons%rowtype;
    r_Staff          Href_Staffs%rowtype;
    v_Operayion      Gmap;
    v_Operayion_List Glist := Glist;
    result           Gmap := Gmap;
    --------------------------------------------------
    Procedure Put
    (
      p_Map in out Gmap,
      i_Key varchar2,
      i_Val varchar2
    ) is
    begin
      p_Map.Put(i_Key, Nvl(i_Val, ''));
    end;
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Posted <> 'Y' then
      b.Raise_Not_Implemented;
    end if;
  
    Put(result,
        'filial_name',
        z_Md_Filials.Load(i_Company_Id => r_Document.Company_Id, i_Filial_Id => r_Document.Filial_Id).Name);
    Put(result, 'document_date', r_Document.Document_Date);
    Put(result, 'document_number', r_Document.Document_Number);
    Put(result, 'document_name', r_Document.Document_Name);
    Put(result,
        'division_name',
        z_Mhr_Divisions.Take(i_Company_Id => r_Document.Company_Id, --
        i_Filial_Id => r_Document.Filial_Id, --
        i_Division_Id => r_Document.Division_Id).Name);
    Put(result, 'month', r_Document.Month);
    Put(result,
        'currency_name',
        z_Mk_Currencies.Load(i_Company_Id => r_Document.Company_Id, i_Currency_Id => r_Document.Currency_Id).Name);
    Put(result,
        'oper_type_name',
        z_Mpr_Oper_Types.Take(i_Company_Id => r_Document.Company_Id, --
        i_Oper_Type_Id => r_Document.Oper_Type_Id).Name);
  
    r_Legal_Person := z_Mr_Legal_Persons.Load(i_Company_Id => r_Document.Company_Id,
                                              i_Person_Id  => r_Document.Filial_Id);
    r_Staff        := z_Href_Staffs.Take(i_Company_Id => r_Document.Company_Id,
                                         i_Filial_Id  => r_Document.Filial_Id,
                                         i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => r_Document.Company_Id,
                                                                                        i_Filial_Id   => r_Document.Filial_Id,
                                                                                        i_Employee_Id => r_Legal_Person.Primary_Person_Id,
                                                                                        i_Date        => Trunc(sysdate)));
  
    Put(result,
        'director_name',
        z_Mr_Natural_Persons.Take(i_Company_Id => r_Document.Company_Id, --
        i_Person_Id => r_Legal_Person.Primary_Person_Id).Name);
    Put(result,
        'director_job_name',
        z_Mhr_Jobs.Take(i_Company_Id => r_Document.Company_Id, --
        i_Filial_Id => r_Document.Filial_Id, --
        i_Job_Id => r_Staff.Job_Id).Name);
  
    for r in (select (select w.Name -- staff name
                        from Mr_Natural_Persons w
                       where w.Company_Id = r_Document.Company_Id
                         and w.Person_Id = (select St.Employee_Id
                                              from Href_Staffs St
                                             where St.Company_Id = r_Document.Company_Id
                                               and St.Filial_Id = r_Document.Filial_Id
                                               and St.Staff_Id = q.Staff_Id)) Employee_Name,
                     (select Ot.Name
                        from Mpr_Oper_Types Ot
                       where Ot.Company_Id = q.Company_Id
                         and Ot.Oper_Type_Id = Ch.Oper_Type_Id) Oper_Type_Name,
                     q.Amount,
                     q.Note
                from Hpr_Charge_Document_Operations q
                join Hpr_Charges Ch
                  on Ch.Company_Id = q.Company_Id
                 and Ch.Filial_Id = q.Filial_Id
                 and Ch.Doc_Oper_Id = q.Operation_Id
               where q.Company_Id = r_Document.Company_Id
                 and q.Filial_Id = r_Document.Filial_Id
                 and q.Document_Id = r_Document.Document_Id)
    loop
      v_Operayion := Gmap;
    
      Put(v_Operayion, 'employee_name', r.Employee_Name);
      Put(v_Operayion, 'oper_type_name', r.Oper_Type_Name);
      Put(v_Operayion, 'amount', r.Amount);
      Put(v_Operayion, 'note', r.Note);
    
      v_Operayion_List.Push(v_Operayion.Val);
    end loop;
  
    Result.Put('operation_list', v_Operayion_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr681;
/
