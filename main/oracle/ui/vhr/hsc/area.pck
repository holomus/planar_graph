create or replace package Ui_Vhr533 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr533;
/
create or replace package body Ui_Vhr533 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Table        => Zt.Hsc_Drivers,
                                  i_Column       => z.Name,
                                  i_Column_Value => p.o_Varchar2('name'),
                                  i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_drivers',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('driver_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data   Hsc_Areas%rowtype;
    v_Matrix Matrix_Varchar2;
    result   Hashmap;
  begin
    r_Data := z_Hsc_Areas.Load(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Area_Id    => p.r_Number('area_id'));
  
    result := z_Hsc_Areas.To_Map(r_Data, z.Area_Id, z.Name, z.State);
  
    select Array_Varchar2(t.Driver_Id,
                          (select s.Name
                             from Hsc_Drivers s
                            where s.Driver_Id = t.Driver_Id))
      bulk collect
      into v_Matrix
      from Hsc_Area_Drivers t
     where t.Company_Id = r_Data.Company_Id
       and t.Filial_Id = r_Data.Filial_Id
       and t.Area_Id = r_Data.Area_Id;
  
    Result.Put('drivers', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Area_Id number,
    p         Hashmap
  ) return Hashmap is
    r_Data       Hsc_Areas%rowtype;
    v_Driver_Ids Array_Number := p.r_Array_Number('driver_ids');
  begin
    r_Data := z_Hsc_Areas.To_Row(p, z.Name, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Area_Id    := i_Area_Id;
  
    Hsc_Api.Area_Save(r_Data);
  
    -- drivers
    for i in 1 .. v_Driver_Ids.Count
    loop
      Hsc_Api.Area_Add_Driver(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Area_Id    => r_Data.Area_Id,
                              i_Driver_Id  => v_Driver_Ids(i));
    end loop;
  
    for r in (select *
                from Hsc_Area_Drivers q
               where q.Company_Id = r_Data.Company_Id
                 and q.Filial_Id = r_Data.Filial_Id
                 and q.Area_Id = r_Data.Area_Id
                 and q.Driver_Id not member of v_Driver_Ids)
    loop
      Hsc_Api.Area_Remove_Driver(i_Company_Id => r.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Area_Id    => r.Area_Id,
                                 i_Driver_Id  => r.Driver_Id);
    end loop;
  
    return z_Hsc_Areas.To_Map(r_Data, z.Area_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hsc_Next.Area_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hsc_Areas%rowtype;
  begin
    r_Data := z_Hsc_Areas.Lock_Load(i_Company_Id => Ui.Company_Id,
                                    i_Filial_Id  => Ui.Filial_Id,
                                    i_Area_Id    => p.r_Number('area_id'));
  
    return save(r_Data.Area_Id, p);
  end;

end Ui_Vhr533;
/
