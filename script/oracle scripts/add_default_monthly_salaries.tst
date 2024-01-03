PL/SQL Developer Test script 3.0
54
-- Created on 8/30/2022 by ADHAM 
declare
  v_Company_Id number := 100;

  v_Journal    Hpd_Pref.Wage_Change_Journal_Rt;
  v_Oper_Types Href_Pref.Oper_Type_Nt;
  v_Indicators Href_Pref.Indicator_Nt;

  v_Indicator Href_Pref.Indicator_Rt;
  v_Oper_Type Href_Pref.Oper_Type_Rt;

  v_Wage_Id number;
begin
  Ui_Auth.Logon_As_System(100);

  v_Wage_Id := Href_Util.Indicator_Id(i_Company_Id => v_Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);

  v_Indicator.Indicator_Id    := v_Wage_Id;
  v_Indicator.Indicator_Value := 0;

  v_Indicators := Href_Pref.Indicator_Nt(v_Indicator);

  v_Oper_Type.Indicator_Ids := Array_Number(v_Wage_Id);
  v_Oper_Type.Oper_Type_Id  := Mpr_Util.Oper_Type_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly);

  v_Oper_Types := Href_Pref.Oper_Type_Nt(v_Oper_Type);

  for r in (select *
              from Href_Staffs q
             where q.Company_Id = v_Company_Id)
  loop
    Hpd_Util.Wage_Change_Journal_New(o_Journal      => v_Journal,
                                     i_Company_Id   => r.Company_Id,
                                     i_Filial_Id    => r.Filial_Id,
                                     i_Journal_Id   => Hpd_Next.Journal_Id,
                                     i_Journal_Date => r.Hiring_Date,
                                     i_Journal_Name => null);
  
    Hpd_Util.Journal_Add_Wage_Change(p_Journal     => v_Journal,
                                     i_Page_Id     => Hpd_Next.Page_Id,
                                     i_Staff_Id    => r.Staff_Id,
                                     i_Change_Date => r.Hiring_Date,
                                     i_Indicators  => v_Indicators,
                                     i_Oper_Types  => v_Oper_Types);
  
    Hpd_Api.Wage_Change_Journal_Save(v_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                         i_Filial_Id  => v_Journal.Filial_Id,
                         i_Journal_Id => v_Journal.Journal_Id);
  end loop;
end;
0
0
