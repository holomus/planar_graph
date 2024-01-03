create or replace package Hr5_Migr_Api is
  ----------------------------------------------------------------------------------------------------  
  Procedure Log_Error
  (
    i_Company_Id    number,
    i_Table_Name    varchar2,
    i_Key_Id        number,
    i_Error_Message varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Job_Log(i_Message varchar2);
  ----------------------------------------------------------------------------------------------------  
  Procedure Insert_Used_Key
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Key_Id     number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Insert_Key
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number,
    i_New_Id     number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Insert_Key
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number,
    i_New_Id     number,
    i_Filial_Id  number
  );
end Hr5_Migr_Api;
/
create or replace package body Hr5_Migr_Api is
  ---------------------------------------------------------------------------------------------------- 
  Procedure Log_Error
  (
    i_Company_Id    number,
    i_Table_Name    varchar2,
    i_Key_Id        number,
    i_Error_Message varchar2
  ) is
  begin
    insert into Hr5_Migr_Errors
      (Company_Id, Table_Name, Key_Id, Error_Message, Error_Date)
    values
      (i_Company_Id, i_Table_Name, i_Key_Id, i_Error_Message, sysdate);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Job_Log(i_Message varchar2) is
    pragma autonomous_transaction;
  begin
    insert into Hr5_Migr_Job_Log
      (Period, Error_Message)
    values
      (sysdate, i_Message);
    commit;
  
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  -- inserting hr5 migr data
  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Used_Key
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Key_Id     number
  ) is
  begin
    insert into Hr5_Migr_Used_Keys
      (Company_Id, Key_Name, Old_Id)
    values
      (i_Company_Id, i_Key_Name, i_Key_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Key
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number,
    i_New_Id     number
  ) is
    v_Dummy number;
  begin
    begin
      select 1
        into v_Dummy
        from Hr5_Migr_Used_Keys Uk
       where Uk.Company_Id = i_Company_Id
         and Uk.Key_Name = i_Key_Name
         and Uk.Old_Id = i_Old_Id;
    
    exception
      when No_Data_Found then
        Insert_Used_Key(i_Company_Id => i_Company_Id,
                        i_Key_Name   => i_Key_Name,
                        i_Key_Id     => i_Old_Id);
    end;
  
    insert into Hr5_Migr_Keys_Store_One
      (Company_Id, Key_Name, Old_Id, New_Id)
    values
      (i_Company_Id, i_Key_Name, i_Old_Id, i_New_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Insert_Key
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number,
    i_New_Id     number,
    i_Filial_Id  number
  ) is
    v_Dummy number;
  begin
    begin
      select 1
        into v_Dummy
        from Hr5_Migr_Used_Keys Uk
       where Uk.Company_Id = i_Company_Id
         and Uk.Key_Name = i_Key_Name
         and Uk.Old_Id = i_Old_Id;
    
    exception
      when No_Data_Found then
        Insert_Used_Key(i_Company_Id => i_Company_Id,
                        i_Key_Name   => i_Key_Name,
                        i_Key_Id     => i_Old_Id);
    end;
  
    insert into Hr5_Migr_Keys_Store_Two
      (Company_Id, Key_Name, Old_Id, Filial_Id, New_Id)
    values
      (i_Company_Id, i_Key_Name, i_Old_Id, i_Filial_Id, i_New_Id);
  end;

end Hr5_Migr_Api;
/
