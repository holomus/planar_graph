create or replace package Hsc_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Filial_Add(i_Filial Md_Global.Filial_Rt);
end Hsc_Watcher;
/
create or replace package body Hsc_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Filial_Add(i_Filial Md_Global.Filial_Rt) is
    v_Company_Head number := Md_Pref.c_Company_Head;
    v_Pc_Like      varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query        varchar2(4000);
    v_Lang_Code    Md_Companies.Lang_Code%type := z_Md_Companies.Load(i_Filial.Company_Id).Lang_Code;
    r_Driver       Hsc_Drivers%rowtype;
  begin
    -- driver
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hsc_Drivers,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hsc_Drivers t
               where t.Company_Id = v_Company_Head
                 and t.Filial_Id = Md_Pref.Filial_Head(v_Company_Head)
                 and t.Pcode like v_Pc_Like)
    loop
      r_Driver            := r;
      r_Driver.Company_Id := i_Filial.Company_Id;
      r_Driver.Filial_Id  := i_Filial.Filial_Id;
      r_Driver.Driver_Id  := Hsc_Next.Driver_Id;
    
      select t.Measure_Id
        into r_Driver.Measure_Id
        from Mr_Measures t
       where t.Company_Id = r_Driver.Company_Id
         and t.Pcode = (select s.Pcode
                          from Mr_Measures s
                         where s.Company_Id = r.Company_Id
                           and s.Measure_Id = r.Measure_Id);
    
      execute immediate v_Query
        using in r_Driver, out r_Driver;
    
      z_Hsc_Drivers.Save_Row(r_Driver);
    end loop;
  end;

end Hsc_Watcher;
/
