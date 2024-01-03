set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Filial_Head  number := Md_Pref.Filial_Head(Md_Pref.c_Company_Head);
  --------------------------------------------------
  Procedure Driver
  (
    i_Name          varchar2,
    i_Measure_Pcode varchar2,
    i_Pcode         varchar2
  ) is
    v_Driver_Id  number;
    v_Measure_Id number;
  begin
    begin
      select Driver_Id
        into v_Driver_Id
        from Hsc_Drivers
       where Company_Id = v_Company_Head
         and Filial_Id = v_Filial_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Driver_Id := Hsc_Next.Driver_Id;
    end;
  
    select Measure_Id
      into v_Measure_Id
      from Mr_Measures
     where Company_Id = v_Company_Head
       and Product_Kind = Mr_Pref.c_Pk_Inventory
       and Pcode = i_Measure_Pcode;
  
    z_Hsc_Drivers.Save_One(i_Company_Id => v_Company_Head,
                           i_Filial_Id  => v_Filial_Head,
                           i_Driver_Id  => v_Driver_Id,
                           i_Name       => i_Name,
                           i_Measure_Id => v_Measure_Id,
                           i_State      => 'A',
                           i_Pcode      => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => i_Table_Name,
                                                    i_Column_Set  => i_Column_Set,
                                                    i_Extra_Where => i_Extra_Where);
  end;
begin
  Ui_Auth.Logon_As_System(v_Company_Head);

  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Drivers ====');
  Driver('Константа', 'ANOR:2', 'VHR:1');
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HSC_DRIVERS', 'NAME');
  commit;
end;
/
