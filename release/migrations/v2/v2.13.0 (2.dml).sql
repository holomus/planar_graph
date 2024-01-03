prompt migr from 07.12.2022 (2.dml)
----------------------------------------------------------------------------------------------------
prompt update all records of staffs
----------------------------------------------------------------------------------------------------
declare
  v_Date      date;
  v_Curr_Date date := Trunc(sysdate);

  --------------------------------------------------
  Function Get_Fte_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id,
                                  i_Period     => i_Period).Fte_Id;
  end;
begin
  for Cmp in (select c.Company_Id,
                     (select C1.User_System
                        from Md_Company_Infos C1
                       where C1.Company_Id = c.Company_Id) as User_System
                from Md_Companies c)
  loop
    for Fil in (select *
                  from Md_Filials q
                 where q.Company_Id = Cmp.Company_Id)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => Cmp.User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for St in (select *
                   from Href_Staffs s
                  where s.Company_Id = Fil.Company_Id
                    and s.Filial_Id = Fil.Filial_Id
                    and s.State = 'A')
      loop
        if St.Hiring_Date <= v_Curr_Date and
           (St.Dismissal_Date is null or St.Dismissal_Date >= v_Curr_Date) then
          v_Date := v_Curr_Date;
        elsif St.Dismissal_Date < v_Curr_Date then
          v_Date := St.Dismissal_Date;
        elsif St.Hiring_Date >= v_Curr_Date then
          v_Date := St.Hiring_Date;
        end if;
      
        z_Href_Staffs.Update_One(i_Company_Id => St.Company_Id,
                                 i_Filial_Id  => St.Filial_Id,
                                 i_Staff_Id   => St.Staff_Id,
                                 i_Fte_Id     => Option_Number(Get_Fte_Id(i_Company_Id => St.Company_Id,
                                                                          i_Filial_Id  => St.Filial_Id,
                                                                          i_Staff_Id   => St.Staff_Id,
                                                                          i_Period     => v_Date)));
      
      end loop;
    end loop;
  end loop;
  commit;
end;
/
