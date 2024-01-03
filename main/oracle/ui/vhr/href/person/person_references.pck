create or replace package Ui_Vhr42 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Reference_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Save_Reference(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Reference(p Hashmap);
end Ui_Vhr42;
/
create or replace package body Ui_Vhr42 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    select Array_Varchar2(q.Person_Reference_Id,
                          q.Reference_Type_Id,
                          (select w.Name
                             from Href_Reference_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Reference_Type_Id = q.Reference_Type_Id),
                          q.Ref_Number,
                          q.Ref_Date,
                          q.Start_Date,
                          q.End_Date,
                          q.Name)
      bulk collect
      into v_Matrix
      from Href_Person_References q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('person_references', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Reference_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_reference_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('reference_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Reference(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Href_Person_References%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_References.Exist_Lock(i_Company_Id          => Ui.Company_Id,
                                               i_Person_Reference_Id => p.o_Number('person_reference_id'),
                                               o_Row                 => r_Data) then
      r_Data.Company_Id          := Ui.Company_Id;
      r_Data.Person_Reference_Id := Href_Next.Person_Reference_Id;
    end if;
  
    z_Href_Person_References.To_Row(r_Data,
                                    p,
                                    z.Reference_Type_Id,
                                    z.Ref_Number,
                                    z.Ref_Date,
                                    z.Start_Date,
                                    z.End_Date,
                                    z.Name);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Reference_Save(r_Data);
  
    return z_Href_Person_References.To_Map(r_Data, z.Person_Reference_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Reference(p Hashmap) is
    v_Person_Reference_Id number := p.r_Number('person_reference_id');
    v_Person_Id           number;
  begin
    v_Person_Id := z_Href_Person_References.Lock_Load(i_Company_Id => Ui.Company_Id, i_Person_Reference_Id => v_Person_Reference_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Reference_Delete(i_Company_Id          => Ui.Company_Id,
                                     i_Person_Reference_Id => v_Person_Reference_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Reference_Types
       set Company_Id        = null,
           Reference_Type_Id = null,
           name              = null,
           State             = null;
  end;

end Ui_Vhr42;
/
