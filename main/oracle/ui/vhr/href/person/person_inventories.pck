create or replace package Ui_Vhr467 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Inventory_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Save_Person_Inventory(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Person_Inventory(p Hashmap);
end Ui_Vhr467;
/
create or replace package body Ui_Vhr467 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    v_Matrix    Matrix_Varchar2;
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    select Array_Varchar2(q.Person_Inventory_Id,
                          q.Inventory_Type_Id,
                          (select w.Name
                             from Href_Inventory_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Inventory_Type_Id = q.Inventory_Type_Id),
                          q.Date_Assigned,
                          q.Date_Returned,
                          q.Note)
      bulk collect
      into v_Matrix
      from Href_Person_Inventories q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('inventories', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Inventory_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_inventory_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('inventory_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Person_Inventory(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Href_Person_Inventories%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Inventories.Exist_Lock(i_Company_Id          => Ui.Company_Id,
                                                i_Person_Inventory_Id => p.o_Number('person_inventory_id'),
                                                o_Row                 => r_Data) then
      r_Data.Company_Id          := Ui.Company_Id;
      r_Data.Person_Inventory_Id := Href_Next.Person_Inventory_Id;
    end if;
  
    z_Href_Person_Inventories.To_Row(r_Data,
                                     p,
                                     z.Person_Id,
                                     z.Inventory_Type_Id,
                                     z.Date_Assigned,
                                     z.Date_Returned,
                                     z.Note);
  
    Href_Api.Person_Inventory_Save(r_Data);
  
    return z_Href_Person_Inventories.To_Map(r_Data, z.Person_Inventory_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Person_Inventory(p Hashmap) is
    v_Person_Inventory_Id number := p.r_Number('person_inventory_id');
    v_Person_Id           number;
  begin
    v_Person_Id := z_Href_Person_Inventories.Lock_Load(i_Company_Id => Ui.Company_Id, i_Person_Inventory_Id => v_Person_Inventory_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Inventory_Delete(i_Company_Id          => Ui.Company_Id,
                                     i_Person_Inventory_Id => v_Person_Inventory_Id);
  end;

end Ui_Vhr467;
/
