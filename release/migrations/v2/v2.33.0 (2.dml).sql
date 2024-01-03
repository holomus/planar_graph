prompt migrating book operations
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    update Mpr_Book_Operations q
       set q.Note =
           (select w.Note
              from Hpr_Book_Operations w
             where w.Company_Id = q.Company_Id
               and q.Book_Id = w.Book_Id
               and q.Operation_Id = w.Operation_Id
               and q.Note is not null)
     where q.Company_Id = r.Company_Id;
  
    commit;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding multiple application transfers
----------------------------------------------------------------------------------------------------
update Hpd_Application_Transfers
   set Application_Unit_Id = hpd_application_units_sq.Nextval;
commit;

----------------------------------------------------------------------------------------------------
prompt adding division manager_status
----------------------------------------------------------------------------------------------------
update Hrm_Divisions q
   set q.Manager_Status = case
                            when q.Is_Department = 'N' and not exists
                             (select 1
                                    from Mrf_Division_Managers Dm
                                   where Dm.Company_Id = q.Company_Id
                                     and Dm.Filial_Id = q.Filial_Id
                                     and Dm.Division_Id = q.Division_Id) then
                             'A'
                            else
                             'M'
                          end;
commit;

----------------------------------------------------------------------------------------------------
insert into Mrf_Division_Managers
  (Company_Id, Filial_Id, Division_Id, Manager_Id)
  select d.Company_Id, d.Filial_Id, d.Division_Id, Dm.Manager_Id
    from Hrm_Divisions d
    join Mhr_Parent_Divisions Pd
      on Pd.Company_Id = d.Company_Id
     and Pd.Filial_Id = d.Filial_Id
     and Pd.Division_Id = d.Division_Id
     and Pd.Lvl = (select min(p.Lvl)
                     from Mhr_Parent_Divisions p
                     join Hrm_Divisions q
                       on q.Company_Id = p.Company_Id
                      and q.Filial_Id = p.Filial_Id
                      and q.Division_Id = p.Parent_Id
                    where p.Company_Id = d.Company_Id
                      and p.Filial_Id = d.Filial_Id
                      and p.Division_Id = d.Division_Id
                      and q.Manager_Status = 'M')
    join Mrf_Division_Managers Dm
      on Dm.Company_Id = Pd.Company_Id
     and Dm.Filial_Id = Pd.Filial_Id
     and Dm.Division_Id = Pd.Parent_Id
   where d.Manager_Status = 'A';
commit;

---------------------------------------------------------------------------------------------------- 
insert into Hrm_Division_Managers
  (Company_Id, Filial_Id, Division_Id, Employee_Id)
  select q.Company_Id, q.Filial_Id, q.Division_Id, Rb.Person_Id
    from Mrf_Division_Managers q
    join Mrf_Robots Rb
      on Rb.Company_Id = q.Company_Id
     and Rb.Filial_Id = q.Filial_Id
     and Rb.Robot_Id = q.Manager_Id
    left join Hrm_Settings St
      on St.Company_Id = q.Company_Id
     and St.Filial_Id = q.Filial_Id
   where (St.Position_Enable = 'N' or St.Position_Enable is null)
     and Rb.Person_Id is not null
     and not exists (select 1
            from Hrm_Division_Managers p
           where p.Company_Id = q.Company_Id
             and p.Filial_Id = q.Filial_Id
             and p.Division_Id = q.Division_Id);
commit;
