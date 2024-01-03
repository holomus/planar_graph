create or replace package Ui_Vhr653 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr653;
/
create or replace package body Ui_Vhr653 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Document Mdf_Sign_Documents%rowtype;
    r_Process  Mdf_Sign_Processes%rowtype;
    result     Hashmap;
  begin
    r_Document := z_Mdf_Sign_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                            i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Filial_Id <> Ui.Filial_Id then
      b.Raise_Unauthorized;
    end if;
  
    r_Process := z_Mdf_Sign_Processes.Load(i_Company_Id => r_Document.Company_Id,
                                           i_Process_Id => r_Document.Process_Id);
  
    if r_Process.Project_Code <> Ui.Project_Code then
      b.Raise_Unauthorized;
    end if;
  
    result := z_Mdf_Sign_Documents.To_Map(r_Document, --
                                          z.Document_Id,
                                          z.Status,
                                          z.Uri,
                                          z.Title,
                                          z.Note,
                                          z.Source_Id,
                                          z.Created_On);
  
    Result.Put('status_name', Mdf_Pref.t_Document_Status(r_Document.Status));
    Result.Put('process_name',
               z_Mdf_Sign_Processes.Load(i_Company_Id => r_Document.Company_Id, i_Process_Id => r_Document.Process_Id).Name);
    Result.Put('created_by_name',
               z_Md_Persons.Load(i_Company_Id => r_Document.Company_Id, i_Person_Id => r_Document.Created_By).Name);
  
    return result;
  end;

end Ui_Vhr653;
/
