create or replace package Kl_Demo is

end Kl_Demo;
/
create or replace package body Kl_Demo is
  ----------------------------------------------------------------------------------------------------
  Procedure Install_License
  (
    i_Company_Id   number,
    i_License_Code varchar2,
    i_License_Date date
  ) is
    r_License Kl_License_Dates%rowtype;
    v_Count   number;
  begin
    r_License := z_Kl_License_Dates.Lock_Load(i_Company_Id   => i_Company_Id,
                                              i_License_Code => i_License_Code,
                                              i_License_Date => i_License_Date);
  
    v_Count := Least(r_License.Avail_Quant - r_License.Used_Quant, r_License.Required_Quant);
  
    if v_Count = 0 then
      return;
    end if;
  
    update Kl_License_Persons q
       set q.Licensed = 'Y'
     where q.Company_Id = i_Company_Id
       and q.License_Code = i_License_Code
       and q.License_Date = i_License_Date
       and q.Licensed = 'N'
       and Rownum <= v_Count;
  
    r_License.Required_Quant := r_License.Required_Quant - v_Count;
    r_License.Used_Quant     := r_License.Used_Quant + v_Count;
  
    z_Kl_License_Dates.Save_Row(r_License);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Evaluate_License_By_Period
  (
    i_Company_Id   number,
    i_License_Date date
  ) is
    v_Ctrl_Code varchar2(50);
    v_Count     number;
    r_License   Kl_License_Dates%rowtype;
  begin
    for r in (select *
                from Md_Licenses q
               where q.Kind = Md_Pref.c_Lk_Grant
               order by q.License_Code)
    loop
      r_License := z_Kl_License_Dates.Lock_Load(i_Company_Id   => i_Company_Id,
                                                i_License_Code => r.License_Code,
                                                i_License_Date => i_License_Date);
    
      insert into Kl_License_Persons
        (Company_Id, License_Code, License_Date, Person_Id, Licensed)
        select q.Company_Id, q.License_Code, i_License_Date, q.Person_Id, 'N'
          from Kl_License_Ownerships q
         where q.Company_Id = i_Company_Id
           and q.Ctrl_Code = v_Ctrl_Code
           and q.License_Code = r.License_Code
           and exists (select 1
                  from Md_Users w
                 where w.Company_Id = i_Company_Id
                   and w.User_Id = q.Person_Id
                   and w.State = 'A')
           and not exists (select 1
                  from Kl_License_Persons e
                 where e.Company_Id = i_Company_Id
                   and e.License_Code = q.License_Code
                   and e.License_Date = i_License_Date
                   and e.Person_Id = q.Person_Id);
    
      v_Count := Nvl(sql%rowcount, 0);
    
      continue when v_Count = 0;
    
      r_License.Required_Quant := r_License.Required_Quant + v_Count;
    
      z_Kl_License_Dates.Save_Row(r_License);
    
      Install_License(i_Company_Id   => i_Company_Id,
                      i_License_Code => r.License_Code,
                      i_License_Date => i_License_Date);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen is
  begin
    null;
  end;

end Kl_Demo;
/
