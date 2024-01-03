create or replace package Hr5_Migr_Mr is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Regions(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Mr;
/
create or replace package body Hr5_Migr_Mr is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Regions(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
    v_Total number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Regions', 'started Migr_Regions');
    Hr5_Migr_Util.Init(i_Company_Id => i_Company_Id, i_With_Filial => false);
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Mr_Regions q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Mr_Region
               and Uk.Old_Id = q.Region_Id);
  
    for r in (select q.*,
                     (select r.Region_Id
                        from Md_Regions r
                       where r.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and r.Code = q.Code
                         and Rownum = 1) as New_Id,
                     Rownum
                from (select q.*,
                             (select r.Code
                                from Md_Regions r
                               where Lower(r.Name) = Lower(q.Name)
                                 and Rownum = 1) as Code
                        from Hr5_Mr_Regions q
                       where not exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Mr_Region
                                 and Uk.Old_Id = q.Region_Id)) q)
    loop
      Dbms_Application_Info.Set_Module('Migr_Regions',
                                       'migrated ' || (r.Rownum - 1) || ' Region(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        if r.New_Id is null then
          b.Raise_Error('Migr_Regions: new id not found for $1 region, region_id=$2',
                        r.Name,
                        r.Region_Id);
        end if;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Mr_Region,
                                i_Old_Id     => r.Region_Id,
                                i_New_Id     => r.New_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Mr_Regions',
                                 i_Key_Id        => r.Region_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Hr5_Migr_Util.Clear;
    Dbms_Application_Info.Set_Module('Migr_Regions', 'finished Migr_Regions');
  end;

end Hr5_Migr_Mr;
/
