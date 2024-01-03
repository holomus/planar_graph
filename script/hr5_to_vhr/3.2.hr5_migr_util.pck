create or replace package Hr5_Migr_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Init
  (
    i_Company_Id  number := Md_Pref.c_Migr_Company_Id,
    i_With_Filial boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Clear;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number,
    i_Filial_Id  number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Type_Id
  (
    i_Company_Id      number,
    i_Person_Group_Id number,
    i_Name            varchar2
  ) return number;
end Hr5_Migr_Util;
/
create or replace package body Hr5_Migr_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Init
  (
    i_Company_Id  number := Md_Pref.c_Migr_Company_Id,
    i_With_Filial boolean := true
  ) is
    v_Filial_Id number;
  begin
    if not Hr5_Migr_Pref.g_Inited or not Fazo.Equal(i_Company_Id, Hr5_Migr_Pref.g_Company_Id) then
      Hr5_Migr_Pref.g_Inited     := true;
      Hr5_Migr_Pref.g_Company_Id := i_Company_Id;
    
      select Ci.Filial_Head, Ci.User_System
        into Hr5_Migr_Pref.g_Filial_Head, Hr5_Migr_Pref.g_User_System
        from Md_Company_Infos Ci
       where Ci.Company_Id = Hr5_Migr_Pref.g_Company_Id;
    
      if i_With_Filial then
        begin
          select f.Filial_Id
            into Hr5_Migr_Pref.g_Filial_Id
            from Md_Filials f
           where f.Company_Id = Hr5_Migr_Pref.g_Company_Id
             and f.Filial_Id <> Hr5_Migr_Pref.g_Filial_Head
             and f.State = 'A'
             and Rownum = 1;
        exception
          when No_Data_Found then
            b.Raise_Error('first run Hr5_Migr_Md.Migr_Filials if filial exists in hr5 data, else create new filial');
        end;
      
        v_Filial_Id := Hr5_Migr_Pref.g_Filial_Id;
      
        begin
          select q.Old_Id
            into Hr5_Migr_Pref.g_Old_Filial_Id
            from Hr5_Migr_Keys_Store_One q
           where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
             and q.Key_Name = Hr5_Migr_Pref.c_Md_Filial
             and q.New_Id = Hr5_Migr_Pref.g_Filial_Id;
        exception
          when No_Data_Found then
            Hr5_Migr_Pref.g_Old_Filial_Id := null;
        end;
      else
        Hr5_Migr_Pref.g_Filial_Id     := null;
        Hr5_Migr_Pref.g_Old_Filial_Id := null;
        v_Filial_Id                   := Hr5_Migr_Pref.g_Filial_Head;
      end if;
    
      Biruni_Route.Clear_Globals;
      Ui_Context.Init(i_User_Id      => Hr5_Migr_Pref.g_User_System,
                      i_Project_Code => Href_Pref.c_Pc_Verifix_Hr,
                      i_Filial_Id    => v_Filial_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear is
  begin
    if Hr5_Migr_Pref.g_Inited then
      Hr5_Migr_Pref.g_Inited        := false;
      Hr5_Migr_Pref.g_Company_Id    := null;
      Hr5_Migr_Pref.g_Filial_Head   := null;
      Hr5_Migr_Pref.g_User_System   := null;
      Hr5_Migr_Pref.g_Filial_Id     := null;
      Hr5_Migr_Pref.g_Old_Filial_Id := null;
    end if;
  end;
  ----------------------------------------------------------------------------------------------------  
  Function Get_New_Id
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number
  ) return number is
    result number;
  begin
    return Hr5_Migr_Pref.g_Hr5_Migr_Keys_Store_One(i_Key_Name || ':' || i_Old_Id);
  exception
    when No_Data_Found then
      begin
        select New_Id
          into result
          from Hr5_Migr_Keys_Store_One So
         where So.Company_Id = i_Company_Id
           and So.Key_Name = i_Key_Name
           and So.Old_Id = i_Old_Id;
      
        Hr5_Migr_Pref.g_Hr5_Migr_Keys_Store_One(i_Key_Name || ':' || i_Old_Id) := result;
      
        return result;
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_New_Id
  (
    i_Company_Id number,
    i_Key_Name   varchar2,
    i_Old_Id     number,
    i_Filial_Id  number
  ) return number is
    result number;
  begin
    return Hr5_Migr_Pref.g_Hr5_Migr_Keys_Store_Two(i_Key_Name || ':' || i_Old_Id || ',' ||
                                                   'filial_id:' || i_Filial_Id);
  exception
    when No_Data_Found then
      begin
        select New_Id
          into result
          from Hr5_Migr_Keys_Store_Two St
         where St.Company_Id = i_Company_Id
           and St.Key_Name = i_Key_Name
           and St.Old_Id = i_Old_Id
           and St.Filial_Id = i_Filial_Id;
      
        Hr5_Migr_Pref.g_Hr5_Migr_Keys_Store_Two(i_Key_Name || ':' || i_Old_Id || ',' || 'filial_id:' || i_Filial_Id) := result;
      
        return result;
      exception
        when No_Data_Found then
          return null;
      end;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Person_Type_Id
  (
    i_Company_Id      number,
    i_Person_Group_Id number,
    i_Name            varchar2
  ) return number is
    v_Id number;
  begin
    select t.Person_Type_Id
      into v_Id
      from Mr_Person_Types t
     where t.Company_Id = i_Company_Id
       and t.Person_Group_Id = i_Person_Group_Id
       and t.Name = i_Name
       and Rownum = 1;
  
    return v_Id;
  exception
    when No_Data_Found then
      return null;
  end;

end Hr5_Migr_Util;
/
