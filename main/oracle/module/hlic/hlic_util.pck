create or replace package Hlic_Util is
  ----------------------------------------------------------------------------------------------------
  Function Max_License_Generate_Date return date;
end Hlic_Util;
/
create or replace package body Hlic_Util is
  ----------------------------------------------------------------------------------------------------
  Function Max_License_Generate_Date return date is
    v_Date date := Trunc(Current_Date);
  begin
    return v_Date + Hlic_Pref.c_Count_Days_Need_To_Generate;
  end;

end Hlic_Util;
/
