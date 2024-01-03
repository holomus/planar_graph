prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
prompt fix hpr_charges data
---------------------------------------------------------------------------------------------------- 
declare
  v_Robot_Id    number;
  v_Filial_Head number;
begin
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
  
    for Fl in (select *
                 from Md_Filials q
                where q.Company_Id = Cmp.Company_Id
                  and q.Filial_Id <> v_Filial_Head
                  and q.State = 'A')
    loop
      for Ch in (select q.Company_Id, q.Filial_Id, q.Charge_Id, q.Begin_Date, w.Staff_Id
                   from Hpr_Charges q
                   join Hpd_Lock_Intervals w
                     on w.Company_Id = q.Company_Id
                    and w.Filial_Id = q.Filial_Id
                    and w.Interval_Id = q.Interval_Id
                  where q.Company_Id = Fl.Company_Id
                    and q.Filial_Id = Fl.Filial_Id)
      loop
        v_Robot_Id := Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => Ch.Company_Id,
                                                    i_Filial_Id  => Ch.Filial_Id,
                                                    i_Staff_Id   => Ch.Staff_Id,
                                                    i_Period     => Ch.Begin_Date);
      
        update Hpr_Charges q
           set q.Robot_Id = v_Robot_Id
         where q.Company_Id = Ch.Company_Id
           and q.Filial_Id = Ch.Filial_Id
           and q.Charge_Id = Ch.Charge_Id;
      end loop;
    
      commit;
    end loop;
  end loop;
end;
/
