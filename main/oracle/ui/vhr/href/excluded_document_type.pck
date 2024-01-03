create or replace package Ui_Vhr598 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Document_Types(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
end Ui_Vhr598;
/
create or replace package body Ui_Vhr598 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_divisions',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('division_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Document_Types
  (
    i_Division_Id number := null,
    i_Job_Id      number := null
  ) return Arraylist is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(t.Doc_Type_Id,
                           t.Name,
                           case
                             when q.Doc_Type_Id is not null then
                              'N'
                             else
                              'Y'
                           end)
      bulk collect
      into v_Matrix
      from Href_Document_Types t
      left join Href_Excluded_Document_Types q
        on q.Company_Id = t.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Division_Id = i_Division_Id
       and q.Job_Id = i_Job_Id
       and q.Doc_Type_Id = t.Doc_Type_Id
     where t.Company_Id = Ui.Company_Id
       and t.Is_Required = 'Y'
       and t.State = 'A';
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Document_Types(p Hashmap) return Arraylist is
  begin
    return Get_Document_Types(p.r_Number('division_id'), p.r_Number('job_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap;
  begin
    Result.Put('document_types', Get_Document_Types);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    v_Division_Id number := p.r_Number('division_id');
    v_Job_Id      number := p.r_Number('job_id');
    result        Hashmap;
  begin
    result := Fazo.Zip_Map('division_id', v_Division_Id, 'job_id', v_Job_Id);
  
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => v_Division_Id).Name);
  
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => v_Job_Id).Name);
  
    Result.Put('document_types', Get_Document_Types(v_Division_Id, v_Job_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
  begin
    Href_Api.Excluded_Document_Type_Save(i_Company_Id   => Ui.Company_Id,
                                         i_Filial_Id    => Ui.Filial_Id,
                                         i_Division_Id  => p.r_Number('division_id'),
                                         i_Job_Id       => p.r_Number('job_id'),
                                         i_Doc_Type_Ids => p.r_Array_Number('excluded_doc_type_ids'));
  end;

end Ui_Vhr598;
/
