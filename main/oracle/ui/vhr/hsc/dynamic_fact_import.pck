create or replace package Ui_Vhr564 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Setting(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Ftp_File_Responce(p Array_Varchar2) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Ftp_File(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function List_Ftp_Files return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function List_Ftp_Files_Response(i_Filenames varchar2) return varchar2;
end Ui_Vhr564;
/
create or replace package body Ui_Vhr564 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.name
                       from hsc_objects q
                       join mhr_divisions w
                         on w.company_id = q.company_id
                        and w.filial_id = q.filial_id
                        and w.division_id = q.object_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('object_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_areas',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('area_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hsc_drivers q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.pcode is null
                        and q.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('driver_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    v_Starting_Row  number;
    v_Date_Column   number;
    v_Object_Column number;
  
    v_Array Array_Varchar2;
    result  Hashmap := Hashmap();
  begin
    Hsc_Util.Load_Import_Settings(o_Starting_Row  => v_Starting_Row,
                                  o_Date_Column   => v_Date_Column,
                                  o_Object_Column => v_Object_Column,
                                  i_Company_Id    => Ui.Company_Id,
                                  i_Filial_Id     => Ui.Filial_Id);
  
    Result.Put('starting_row', v_Starting_Row);
    Result.Put('date_column', v_Date_Column);
    Result.Put('object_column', v_Object_Column);
  
    -- import infos
    select t.Title
      bulk collect
      into v_Array
      from Hsc_Driver_Fact_Import_Infos t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
     order by t.Column_Index;
  
    Result.Put('column_infos', v_Array);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Setting(p Hashmap) return Hashmap is
    v_Object_Id number := p.r_Number('object_id');
    v_Matrix    Matrix_Varchar2;
    result      Hashmap := Hashmap();
  begin
    select Array_Varchar2(k.Area_Id,
                          (select s.Name
                             from Hsc_Areas s
                            where s.Area_Id = k.Area_Id),
                          k.Driver_Id,
                          (select s.Name
                             from Hsc_Drivers s
                            where s.Driver_Id = k.Driver_Id),
                          k.Column_Indexes)
      bulk collect
      into v_Matrix
      from (select t.Area_Id,
                   t.Driver_Id,
                   Listagg(t.Column_Index, ',') Within group(order by t.Column_Index) Column_Indexes
              from Hsc_Driver_Fact_Import_Settings t
             where t.Company_Id = Ui.Company_Id
               and t.Filial_Id = Ui.Filial_Id
               and t.Object_Id = v_Object_Id
             group by t.Area_Id, t.Driver_Id) k;
  
    Result.Put('column_settings', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap) is
    v_Object_Id          number := p.o_Number('object_id');
    v_Area_Id            number;
    v_Driver_Id          number;
    v_Column_Indexes     Array_Varchar2;
    v_Column_Setting     Hashmap;
    v_Column_Settings    Arraylist := p.o_Arraylist('column_settings');
    v_Column_Infos       Array_Varchar2 := p.r_Array_Varchar2('column_infos');
    v_Column_Infos_Count number;
  begin
    Hsc_Api.Import_Settings_Save(i_Company_Id    => Ui.Company_Id,
                                 i_Filial_Id     => Ui.Filial_Id,
                                 i_Starting_Row  => p.r_Number('starting_row'),
                                 i_Date_Column   => p.r_Number('date_column'),
                                 i_Object_Column => p.r_Number('object_column'));
  
    -- column settings
    if v_Object_Id is not null then
      -- remove old settings
      for r in (select *
                  from Hsc_Driver_Fact_Import_Settings t
                 where t.Company_Id = Ui.Company_Id
                   and t.Filial_Id = Ui.Filial_Id
                   and t.Object_Id = v_Object_Id)
      loop
        z_Hsc_Driver_Fact_Import_Settings.Delete_One(i_Company_Id   => Ui.Company_Id,
                                                     i_Filial_Id    => Ui.Filial_Id,
                                                     i_Object_Id    => v_Object_Id,
                                                     i_Area_Id      => r.Area_Id,
                                                     i_Driver_Id    => r.Driver_Id,
                                                     i_Column_Index => r.Column_Index);
      end loop;
    
      for i in 1 .. v_Column_Settings.Count
      loop
        v_Column_Setting := Treat(v_Column_Settings.r_Hashmap(i) as Hashmap);
      
        v_Area_Id        := v_Column_Setting.r_Number('area_id');
        v_Driver_Id      := v_Column_Setting.r_Number('driver_id');
        v_Column_Indexes := Fazo.Split(Regexp_Replace(v_Column_Setting.r_Varchar2('column_indexes'),
                                                      ' ',
                                                      ''),
                                       
                                       ',');
      
        for j in 1 .. v_Column_Indexes.Count
        loop
          z_Hsc_Driver_Fact_Import_Settings.Insert_One(i_Company_Id   => Ui.Company_Id,
                                                       i_Filial_Id    => Ui.Filial_Id,
                                                       i_Object_Id    => v_Object_Id,
                                                       i_Area_Id      => v_Area_Id,
                                                       i_Driver_Id    => v_Driver_Id,
                                                       i_Column_Index => v_Column_Indexes(j));
        end loop;
      end loop;
    end if;
  
    -- column infos
    v_Column_Infos_Count := v_Column_Infos.Count;
  
    for i in 1 .. v_Column_Infos_Count
    loop
      z_Hsc_Driver_Fact_Import_Infos.Save_One(i_Company_Id   => Ui.Company_Id,
                                              i_Filial_Id    => Ui.Filial_Id,
                                              i_Column_Index => i,
                                              i_Title        => v_Column_Infos(i));
    end loop;
  
    for r in (select *
                from Hsc_Driver_Fact_Import_Infos t
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id = Ui.Filial_Id
                 and t.Column_Index > v_Column_Infos_Count)
    loop
      z_Hsc_Driver_Fact_Import_Infos.Delete_One(i_Company_Id   => Ui.Company_Id,
                                                i_Filial_Id    => Ui.Filial_Id,
                                                i_Column_Index => r.Column_Index);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap is
  begin
    return Hsc_Facts.Import_File(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Data       => p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Ftp_File_Responce(p Array_Varchar2) return Arraylist is
    v_Input Glist := Glist(Json_Array_t.Parse(Fazo.Make_Clob(p)));
  
    v_Excel_File Array_Varchar2;
  
    v_Errors       Hashmap := Hashmap();
    v_Excel_Sheets Arraylist;
  
    v_Data Hashmap := Hashmap();
  
    result Arraylist := Arraylist();
  begin
    for i in 1 .. v_Input.Count
    loop
      v_Excel_File := v_Input.r_Array_Varchar2(i);
    
      v_Excel_Sheets := Fazo.Parse_Array(v_Excel_File);
    
      v_Data.Put('import_file', v_Excel_Sheets);
    
      v_Errors := Hsc_Facts.Import_File(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Data       => v_Data);
    
      Result.Push(v_Errors);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Ftp_File(p Hashmap) return Runtime_Service is
    r_Settings Hsc_Server_Settings%rowtype;
    v_Data     Gmap := Gmap();
  begin
    v_Data.Put('filenames', p.r_Array_Varchar2('filenames'));
  
    r_Settings := z_Hsc_Server_Settings.Take(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
  
    if r_Settings.Ftp_Server_Url is null then
      Hsc_Error.Raise_001;
    end if;
  
    return Hsc_Core.Ftp_File_Load_Service(i_Responce_Procedure => 'ui_vhr564.load_ftp_file_responce',
                                          i_Server_Url         => r_Settings.Ftp_Server_Url,
                                          i_Username           => r_Settings.Ftp_Username,
                                          i_Password           => r_Settings.Ftp_Password,
                                          i_Data               => v_Data,
                                          i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Array_Varchar2,
                                          i_Action_Out         => Biruni_Pref.c_Rs_Action_In_Out_Arraylist);
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Ftp_Files return Runtime_Service is
    r_Settings Hsc_Server_Settings%rowtype;
  begin
    r_Settings := z_Hsc_Server_Settings.Take(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id);
  
    if r_Settings.Ftp_Server_Url is null then
      Hsc_Error.Raise_001;
    end if;
  
    return Hsc_Core.Ftp_File_Load_Service(i_Responce_Procedure => 'Ui_Vhr564.list_ftp_files_response',
                                          i_Server_Url         => r_Settings.Ftp_Server_Url,
                                          i_Username           => r_Settings.Ftp_Username,
                                          i_Password           => r_Settings.Ftp_Password,
                                          i_Action             => Hsc_Pref.c_Ftp_Action_List_Files,
                                          i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Varchar2,
                                          i_Action_Out         => Biruni_Pref.c_Rs_Action_In_Out_Varchar2);
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Ftp_Files_Response(i_Filenames varchar2) return varchar2 is
  begin
    return i_Filenames;
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Ftp_Files_Response(i_Filenames Arraylist) return Arraylist is
  begin
    return i_Filenames;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Objects
       set Company_Id = null,
           Filial_Id  = null,
           Object_Id  = null;
  
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           State       = null;
  
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null,
           State      = null;
  
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr564;
/
