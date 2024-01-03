create or replace package Href_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number);
end Href_Watcher;
/
create or replace package body Href_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number) is
    v_Company_Head    number := Md_Pref.c_Company_Head;
    v_Pcode_Like      varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query           varchar2(4000);
    v_Lang_Code       varchar2(5) := z_Md_Companies.Load(i_Company_Id).Lang_Code;
    r_Document_Types  Href_Document_Types%rowtype;
    r_Indicator       Href_Indicators%rowtype;
    r_Indicator_Group Href_Indicator_Groups%rowtype;
    r_Fte             Href_Ftes%rowtype;
  begin
    -- add default document types
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Href_Document_Types,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Href_Document_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Doc_Type_Id)
    loop
      r_Document_Types             := r;
      r_Document_Types.Company_Id  := i_Company_Id;
      r_Document_Types.Doc_Type_Id := Href_Next.Document_Type_Id;
    
      execute immediate v_Query
        using in r_Document_Types, out r_Document_Types;
    
      z_Href_Document_Types.Save_Row(r_Document_Types);
    end loop;
  
    -- add default indicator groups
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Href_Indicator_Groups,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Href_Indicator_Groups t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Indicator_Group_Id)
    loop
      r_Indicator_Group                    := r;
      r_Indicator_Group.Company_Id         := i_Company_Id;
      r_Indicator_Group.Indicator_Group_Id := Href_Next.Indicator_Group_Id;
    
      execute immediate v_Query
        using in r_Indicator_Group, out r_Indicator_Group;
    
      z_Href_Indicator_Groups.Save_Row(r_Indicator_Group);
    end loop;
  
    -- add default indicators
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Href_Indicators,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Href_Indicators t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Indicator_Id)
    loop
      r_Indicator              := r;
      r_Indicator.Company_Id   := i_Company_Id;
      r_Indicator.Indicator_Id := Href_Next.Indicator_Id;
    
      r_Indicator_Group := z_Href_Indicator_Groups.Load(i_Company_Id         => v_Company_Head,
                                                        i_Indicator_Group_Id => r_Indicator.Indicator_Group_Id);
    
      r_Indicator.Indicator_Group_Id := Href_Util.Indicator_Group_Id(i_Company_Id => i_Company_Id,
                                                                     i_Pcode      => r_Indicator_Group.Pcode);
    
      execute immediate v_Query
        using in r_Indicator, out r_Indicator;
    
      z_Href_Indicators.Save_Row(r_Indicator);
    end loop;
  
    -- add default fte types
    v_Query := Md_Util.Translate_Rows_Statement(i_Table => Zt.Href_Ftes, i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Href_Ftes t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Order_No)
    loop
      r_Fte            := r;
      r_Fte.Company_Id := i_Company_Id;
      r_Fte.Fte_Id     := Href_Next.Fte_Id;
    
      execute immediate v_Query
        using in r_Fte, out r_Fte;
    
      z_Href_Ftes.Save_Row(r_Fte);
    end loop;
  
    -- add default user for timepad
    Href_Api.Create_Timepad_User(i_Company_Id);
  end;

end Href_Watcher;
/
