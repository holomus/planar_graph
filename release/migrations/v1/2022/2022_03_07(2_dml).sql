prompt migr from 07.03.2022
prompt DML

----------------------------------------------------------------------------------------------------
prompt adding data to htt_pin_locks
----------------------------------------------------------------------------------------------------
insert into Htt_Pin_Locks
  (Company_Id)
  select Company_Id
    from Md_Companies;
commit;

----------------------------------------------------------------------------------------------------
update Htt_Devices q
   set q.Use_Settings = 'Y';
commit;

---------------------------------------------------------------------------------------------------- 
declare
  v_Filial_Head number;
  v_User_System number;
begin
  for Cmp in (select q.Company_Id
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
    v_User_System := Md_Pref.User_System(Cmp.Company_Id);
  
    for Fil in (select p.Filial_Id
                  from Md_Filials p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id <> v_Filial_Head
                   and p.State = 'A')
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => v_User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      Biruni_Route.Context_Begin();
      for Tsht in (select t.Company_Id, t.Filial_Id, t.Timesheet_Id
                     from Htt_Timesheets t
                    where t.Company_Id = Cmp.Company_Id
                      and t.Filial_Id = Fil.Filial_Id
                      and not exists (select *
                             from Htt_Timesheet_Locks Tl
                            where Tl.Company_Id = t.Company_Id
                              and Tl.Filial_Id = t.Filial_Id
                              and Tl.Staff_Id = t.Staff_Id
                              and Tl.Timesheet_Date = t.Timesheet_Date)
                      and exists (select *
                             from Htt_Timesheet_Facts Tf
                            where Tf.Company_Id = t.Company_Id
                              and Tf.Filial_Id = t.Filial_Id
                              and Tf.Timesheet_Id = t.Timesheet_Id
                              and mod(Tf.Fact_Value, 60) between 1 and 59))
      loop
        Htt_Core.Make_Dirty_Timesheet(i_Company_Id   => Tsht.Company_Id,
                                      i_Filial_Id    => Tsht.Filial_Id,
                                      i_Timesheet_Id => Tsht.Timesheet_Id);
      end loop;
      Biruni_Route.Context_End();
    
      commit;
    end loop;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
declare
  v_Person_Ids Array_Number;
  v_Pin        number;
begin
  for Cmp in (select *
                from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(Cmp.Company_Id),
                         i_User_Id      => Md_Pref.User_System(Cmp.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    select Np.Person_Id
      bulk collect
      into v_Person_Ids
      from Href_Person_Details Np
      left join Htt_Persons Pi
        on Pi.Company_Id = Np.Company_Id
       and Pi.Person_Id = Np.Person_Id
     where Np.Company_Id = Cmp.Company_Id
       and Pi.Pin is null;
  
    for i in 1 .. v_Person_Ids.Count
    loop
      v_Pin := Htt_Core.Next_Pin(Cmp.Company_Id);
    
      update Htt_Persons q
         set q.Pin = v_Pin
       where q.Company_Id = Cmp.Company_Id
         and q.Person_Id = v_Person_Ids(i);
    end loop;
  end loop;

  commit;
end;
/
