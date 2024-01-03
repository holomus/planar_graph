create or replace package Ui_Vhr40 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Marital_Statuses return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Relation_Degrees return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Save_Family_Member(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_Family_Member(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Save_Marital_Status(p Hashmap) return Hashmap;
end Ui_Vhr40;
/
create or replace package body Ui_Vhr40 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Marital_Statuses(i_Person_Id number) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Person_Marital_Status_Id,
                          q.Marital_Status_Id,
                          (select w.Name
                             from Href_Marital_Statuses w
                            where w.Company_Id = q.Company_Id
                              and w.Marital_Status_Id = q.Marital_Status_Id),
                          q.Start_Date)
      bulk collect
      into v_Matrix
      from Href_Person_Marital_Statuses q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = i_Person_Id;
  
    Result.Put('personal_marital_statuses', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Family_Members(i_Person_Id number) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Person_Family_Member_Id,
                          q.Name,
                          q.Relation_Degree_Id,
                          (select w.Name
                             from Href_Relation_Degrees w
                            where w.Company_Id = q.Company_Id
                              and w.Relation_Degree_Id = q.Relation_Degree_Id),
                          q.Birthday,
                          q.Workplace,
                          q.Is_Dependent,
                          q.Is_Private)
      bulk collect
      into v_Matrix
      from Href_Person_Family_Members q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = i_Person_Id;
  
    Result.Put('personal_family_members', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Result.Put_All(Get_Person_Family_Members(v_Person_Id));
    Result.Put_All(Get_Person_Marital_Statuses(v_Person_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Marital_Statuses return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_marital_statuses',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('marital_status_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Relation_Degrees return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_relation_degrees',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('relation_degree_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Family_Member(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Href_Person_Family_Members%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    if not z_Href_Person_Family_Members.Exist_Lock(i_Company_Id              => Ui.Company_Id,
                                                   i_Person_Family_Member_Id => p.o_Number('person_family_member_id'),
                                                   o_Row                     => r_Data) then
      r_Data.Company_Id              := Ui.Company_Id;
      r_Data.Person_Family_Member_Id := Href_Next.Person_Family_Member_Id;
    end if;
  
    z_Href_Person_Family_Members.To_Row(r_Data,
                                        p,
                                        z.Name,
                                        z.Relation_Degree_Id,
                                        z.Birthday,
                                        z.Workplace,
                                        z.Is_Dependent,
                                        z.Is_Private);
  
    r_Data.Person_Id := v_Person_Id;
  
    Href_Api.Person_Family_Member_Save(r_Data);
  
    return z_Href_Person_Family_Members.To_Map(r_Data, z.Person_Family_Member_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_Family_Member(p Hashmap) is
    v_Person_Family_Member_Id number := p.r_Number('person_family_member_id');
    v_Person_Id               number;
  begin
    v_Person_Id := z_Href_Person_Family_Members.Lock_Load(i_Company_Id => Ui.Company_Id, --
                   i_Person_Family_Member_Id => v_Person_Family_Member_Id).Person_Id;
  
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Href_Api.Person_Family_Member_Delete(i_Company_Id              => Ui.Company_Id,
                                         i_Person_Family_Member_Id => v_Person_Family_Member_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Marital_Status(p Hashmap) return Hashmap is
    v_Array                     Arraylist := p.o_Arraylist('marital_statuses');
    v_Item                      Hashmap := Hashmap();
    v_Person_Id                 number := p.r_Number('person_id');
    v_Person_Marital_Status_Ids Array_Number := Array_Number();
    r_Data                      Href_Person_Marital_Statuses%rowtype;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    v_Person_Marital_Status_Ids.Extend(v_Array.Count);
  
    for i in 1 .. v_Array.Count
    loop
      v_Item := Treat(v_Array.r_Hashmap(i) as Hashmap);
    
      if not z_Href_Person_Marital_Statuses.Exist_Lock(i_Company_Id               => Ui.Company_Id,
                                                       i_Person_Marital_Status_Id => v_Item.o_Number('person_marital_status_id'),
                                                       o_Row                      => r_Data) then
        r_Data.Company_Id               := Ui.Company_Id;
        r_Data.Person_Marital_Status_Id := Href_Next.Person_Marital_Status_Id;
      end if;
    
      r_Data.Marital_Status_Id := v_Item.r_Number('marital_status_id');
      r_Data.Start_Date        := v_Item.r_Date('start_date');
      r_Data.Person_Id         := v_Person_Id;
    
      Href_Api.Person_Marital_Status_Save(r_Data);
    
      v_Person_Marital_Status_Ids(i) := r_Data.Person_Marital_Status_Id;
    end loop;
  
    for r in (select *
                from Href_Person_Marital_Statuses q
               where q.Company_Id = Ui.Company_Id
                 and q.Person_Id = v_Person_Id
                 and q.Person_Marital_Status_Id not member of v_Person_Marital_Status_Ids)
    loop
      Href_Api.Person_Marital_Status_Delete(i_Company_Id               => r.Company_Id,
                                            i_Person_Marital_Status_Id => r.Person_Marital_Status_Id);
    end loop;
  
    return Get_Person_Marital_Statuses(v_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Marital_Statuses
       set Company_Id        = null,
           Marital_Status_Id = null,
           name              = null,
           State             = null;
    update Href_Relation_Degrees
       set Company_Id         = null,
           Relation_Degree_Id = null,
           name               = null,
           State              = null;
  end;

end Ui_Vhr40;
/
