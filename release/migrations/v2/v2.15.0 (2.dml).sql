prompt changing hpd_vacations
----------------------------------------------------------------------------------------------------
declare
begin
  update Hpd_Vacations p
     set p.Time_Kind_Id =
         (select Tk.Time_Kind_Id
            from Htt_Time_Kinds Tk
           where Tk.Company_Id = p.Company_Id
             and Tk.Pcode = Htt_Pref.c_Pcode_Time_Kind_Vacation);
  commit;
end;
/

prompt trimming person names
---------------------------------------------------------------------------------------------------- 
declare
begin
  for Cmp in (select c.Company_Id
                from Md_Companies c
               where c.State = 'A'
                 and exists (select 1
                               from Md_Company_Projects Cp
                              where Cp.Company_Id = c.Company_Id
                                and Cp.Project_Code = Href_Pref.c_Pc_Verifix_Hr))
  loop
    begin
      Ui_Auth.Logon_As_System(Md_Pref.User_System(Cmp.Company_Id));
    
      update Md_Users p
         set p.Name = trim(p.Name)
       where p.Company_Id = Cmp.Company_Id;
    
      commit;
    exception
      when others then
        rollback;
    end;
  end loop;
end;
/
