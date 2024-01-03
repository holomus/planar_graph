create or replace package Ui_Vhr112 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Document_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Doc_Is_Valid(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Save_Person_Document(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Status_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Status_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Status_Rejected(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del_Document(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Download_Files(p Hashmap) return Fazo_File;
end Ui_Vhr112;
/
create or replace package body Ui_Vhr112 is
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
    return b.Translate('UI-VHR112:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Document_Types(p Hashmap) return Fazo_Query is
    v_Person_Id number := p.r_Number('person_id');
    v_Param     Hashmap;
    q           Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A');
    v_Param.Put('required_doc_type_ids', Uit_Href.Get_Required_Doc_Type_Ids(v_Person_Id));
  
    q := Fazo_Query('select t.doc_type_id,
                            t.name,
                            case
                               when t.doc_type_id member of :required_doc_type_ids then
                                ''Y''
                               else
                                ''N''
                             end is_required
                       from href_document_types t
                      where t.company_id = :company_id
                        and t.state = ''A''',
                    v_Param);
  
    q.Number_Field('doc_type_id');
    q.Varchar2_Field('name', 'is_required');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Doc_Is_Valid(p Hashmap) return varchar2 is
    v_Doc_Series  varchar2(50) := p.o_Varchar2('doc_series');
    v_Doc_Number  varchar2(50) := p.o_Varchar2('doc_number');
    v_Document_Id number := p.o_Number('document_id');
    v_Doc_Type_Id number := p.o_Number('doc_type_id');
    v_Dummy       varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Href_Person_Documents q
     where q.Company_Id = Ui.Company_Id
       and (v_Document_Id is null or q.Document_Id <> v_Document_Id)
       and q.Doc_Type_Id = v_Doc_Type_Id
       and q.Doc_Series = v_Doc_Series
       and q.Doc_Number = v_Doc_Number
       and Rownum = 1;
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Documents(i_Person_Id number) return Hashmap is
    v_Matrix                Matrix_Varchar2;
    v_Array                 Array_Number;
    v_Required_Doc_Type_Ids Array_Number;
    result                  Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(i_Person_Id);
    v_Required_Doc_Type_Ids := Uit_Href.Get_Required_Doc_Type_Ids(i_Person_Id);
  
    select Array_Varchar2(q.Document_Id,
                           q.Doc_Type_Id,
                           (select w.Name
                              from Href_Document_Types w
                             where w.Company_Id = q.Company_Id
                               and w.Doc_Type_Id = q.Doc_Type_Id),
                           case
                             when q.Doc_Type_Id member of v_Required_Doc_Type_Ids then
                              'Y'
                             else
                              'N'
                           end,
                           q.Doc_Series,
                           q.Doc_Number,
                           q.Issued_By,
                           q.Issued_Date,
                           q.Begin_Date,
                           q.Expiry_Date,
                           (q.Expiry_Date - Trunc(sysdate)),
                           q.Is_Valid,
                           q.Status,
                           q.Note,
                           q.Rejected_Note,
                           Nvl2((select Df.Sha
                                  from Href_Person_Document_Files Df
                                 where Df.Company_Id = Ui.Company_Id
                                   and Df.Document_Id = q.Document_Id
                                   and Rownum = 1),
                                'Y',
                                'N'))
      bulk collect
      into v_Matrix
      from Href_Person_Documents q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = i_Person_Id;
  
    Result.Put('person_documents', Fazo.Zip_Matrix(v_Matrix));
  
    if v_Matrix.Count > 0 then
      v_Array := Fazo.To_Array_Number(Fazo.Column(v_Matrix, 1));
    else
      v_Array := Array_Number();
    end if;
  
    select Array_Varchar2(q.Document_Id,
                          q.Sha,
                          (select w.File_Name
                             from Biruni_Files w
                            where w.Sha = q.Sha))
      bulk collect
      into v_Matrix
      from Href_Person_Document_Files q
     where q.Company_Id = Ui.Company_Id
       and q.Document_Id member of v_Array;
  
    Result.Put('person_document_files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Reference return Hashmap is
  begin
    return Fazo.Zip_Map('status_new',
                        Href_Pref.c_Person_Document_Status_New,
                        't_status_new',
                        Href_Util.t_Person_Document_Status(Href_Pref.c_Person_Document_Status_New),
                        'status_approved',
                        Href_Pref.c_Person_Document_Status_Approved,
                        't_status_approved',
                        Href_Util.t_Person_Document_Status(Href_Pref.c_Person_Document_Status_Approved),
                        'status_rejected',
                        Href_Pref.c_Person_Document_Status_Rejected,
                        't_status_rejected',
                        Href_Util.t_Person_Document_Status(Href_Pref.c_Person_Document_Status_Rejected));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id                  number := p.r_Number('person_id');
    v_Required_Doc_Type_Ids      Array_Number;
    v_Person_Documents_Count     number;
    v_Person_Document_Owe_Status varchar2(1);
    result                       Hashmap;
  begin
    v_Required_Doc_Type_Ids      := Uit_Href.Get_Required_Doc_Type_Ids(v_Person_Id);
    v_Person_Documents_Count     := Uit_Href.Get_Person_Documents_Count(v_Person_Id,
                                                                        v_Required_Doc_Type_Ids);
    v_Person_Document_Owe_Status := Uit_Href.Get_Person_Document_Owe_Status(v_Person_Id,
                                                                            v_Required_Doc_Type_Ids,
                                                                            v_Person_Documents_Count);
  
    result := Fazo.Zip_Map('required_doc_types_count',
                           v_Required_Doc_Type_Ids.Count,
                           'person_documents_count',
                           v_Person_Documents_Count,
                           'person_document_owe_status',
                           v_Person_Document_Owe_Status,
                           'person_document_owe_status_name',
                           Href_Util.t_Person_Document_Owe_Status(v_Person_Document_Owe_Status));
  
    Result.Put_All(Get_Person_Documents(v_Person_Id));
    Result.Put('reference', Reference);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Person_Document(p Hashmap) return Hashmap is
    r_Data      Href_Person_Documents%rowtype;
    v_Shas      Array_Varchar2 := p.o_Array_Varchar2('shas');
    v_Person_Id number := p.r_Number('person_id');
    v_Matrix    Matrix_Varchar2;
    result      Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Documents.Exist_Lock(i_Company_Id  => Ui.Company_Id,
                                              i_Document_Id => p.o_Number('document_id'),
                                              o_Row         => r_Data) then
      r_Data.Company_Id  := Ui.Company_Id;
      r_Data.Document_Id := Href_Next.Person_Document_Id;
      r_Data.Status      := Href_Pref.c_Person_Document_Status_New;
    end if;
  
    z_Href_Person_Documents.To_Row(r_Data,
                                   p,
                                   z.Doc_Type_Id,
                                   z.Doc_Series,
                                   z.Doc_Number,
                                   z.Issued_By,
                                   z.Issued_Date,
                                   z.Begin_Date,
                                   z.Expiry_Date,
                                   z.Is_Valid,
                                   z.Note);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Document_Save(r_Data);
  
    for i in 1 .. v_Shas.Count
    loop
      Href_Api.Person_Document_File_Save(i_Company_Id  => r_Data.Company_Id,
                                         i_Document_Id => r_Data.Document_Id,
                                         i_Sha         => v_Shas(i));
    end loop;
  
    for r in (select *
                from Href_Person_Document_Files q
               where q.Company_Id = r_Data.Company_Id
                 and q.Document_Id = r_Data.Document_Id
                 and q.Sha not member of v_Shas)
    loop
      Href_Api.Person_Document_File_Delete(i_Company_Id  => r.Company_Id,
                                           i_Document_Id => r.Document_Id,
                                           i_Sha         => r.Sha);
    end loop;
  
    result := z_Href_Person_Documents.To_Map(r_Data, z.Document_Id);
  
    select Array_Varchar2(q.Sha,
                          (select s.File_Name
                             from Biruni_Files s
                            where s.Sha = q.Sha))
      bulk collect
      into v_Matrix
      from Href_Person_Document_Files q
     where q.Company_Id = r_Data.Company_Id
       and q.Document_Id = r_Data.Document_Id;
  
    Result.Put('files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Status_New(p Hashmap) is
  begin
    Href_Api.Person_Document_Status_New(i_Company_Id  => Ui.Company_Id,
                                        i_Document_Id => p.r_Number('document_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Status_Approved(p Hashmap) is
  begin
    Href_Api.Person_Document_Status_Approved(i_Company_Id  => Ui.Company_Id,
                                             i_Document_Id => p.r_Number('document_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Status_Rejected(p Hashmap) is
  begin
    Href_Api.Person_Document_Status_Rejected(i_Company_Id    => Ui.Company_Id,
                                             i_Document_Id   => p.r_Number('document_id'),
                                             i_Rejected_Note => p.o_Varchar2('rejected_note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Document(p Hashmap) is
    v_Document_Id number := p.r_Number('document_id');
    v_Person_Id   number;
  begin
    v_Person_Id := z_Href_Person_Documents.Lock_Load(i_Company_Id => Ui.Company_Id, i_Document_Id => v_Document_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Document_Delete(i_Company_Id => Ui.Company_Id, i_Document_Id => v_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Download_Files(p Hashmap) return Fazo_File is
    r_Doc       Href_Person_Documents%rowtype;
    v_File_Shas Array_Varchar2;
  begin
    r_Doc := z_Href_Person_Documents.Load(i_Company_Id  => Ui.Company_Id, --
                                          i_Document_Id => p.r_Number('document_id'));
  
    Uit_Href.Assert_Access_To_Employee(r_Doc.Person_Id);
  
    select w.Sha
      bulk collect
      into v_File_Shas
      from Href_Person_Document_Files w
     where w.Company_Id = r_Doc.Company_Id
       and w.Document_Id = r_Doc.Document_Id;
  
    return Ui_Kernel.Download_Files(i_Shas            => v_File_Shas, --
                                    i_Attachment_Name => t('person documents, document_type=$1',
                                                           z_Href_Document_Types.Load(i_Company_Id => Ui.Company_Id, --
                                                           i_Doc_Type_Id => r_Doc.Doc_Type_Id).Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Document_Types
       set Company_Id  = null,
           Doc_Type_Id = null,
           name        = null,
           State       = null,
           Pcode       = null;
  end;

end Ui_Vhr112;
/
