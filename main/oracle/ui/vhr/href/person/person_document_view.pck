create or replace package Ui_Vhr152 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Download_Files(p Hashmap) return Fazo_File;
end Ui_Vhr152;
/
create or replace package body Ui_Vhr152 is
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
    return b.Translate('UI-VHR152:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2(q.Document_Id,
                          (select w.Name
                             from Href_Document_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Doc_Type_Id = q.Doc_Type_Id),
                          q.Doc_Series,
                          q.Doc_Number,
                          q.Issued_By,
                          q.Issued_Date,
                          q.Begin_Date,
                          q.Expiry_Date,
                          q.Note,
                          (select Listagg(w.File_Name, ', ') Within group(order by w.File_Name)
                             from Href_Person_Document_Files k
                             join Biruni_Files w
                               on w.Sha = k.Sha
                            where k.Company_Id = q.Company_Id
                              and k.Document_Id = q.Document_Id))
      bulk collect
      into v_Matrix
      from Href_Person_Documents q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('person_documents', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Download_Files(p Hashmap) return Fazo_File is
    v_File_Shas   Array_Varchar2;
    v_Document_Id number := p.r_Number('document_id');
    v_Doc_Type_Id number;
  begin
    select w.Sha
      bulk collect
      into v_File_Shas
      from Href_Person_Document_Files w
     where w.Company_Id = Ui.Company_Id
       and w.Document_Id = v_Document_Id;
  
    v_Doc_Type_Id := z_Href_Person_Documents.Load(i_Company_Id => Ui.Company_Id, --
                     i_Document_Id => v_Document_Id).Doc_Type_Id;
  
    return Ui_Kernel.Download_Files(i_Shas            => v_File_Shas, --
                                    i_Attachment_Name => t('person documents, document_type=$1',
                                                           z_Href_Document_Types.Load(i_Company_Id => Ui.Company_Id, --
                                                           i_Doc_Type_Id => v_Doc_Type_Id).Name));
  end;

end Ui_Vhr152;
/
