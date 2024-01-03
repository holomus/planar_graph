PL/SQL Developer Test script 3.0
53
declare
  v_Filial_No  number := 1;
  v_Filial_Cnt number;
  v_Begin_Date date := to_date('25.02.2023', 'dd.mm.yyyy');
begin

  while v_Begin_Date <= Trunc(sysdate) + 2
  loop
    :Begin_Date := v_Begin_Date;
  
    Dbms_Application_Info.Set_Module('regen timesheets', v_Begin_Date);
  
    for r in (select *
                from Md_Companies q
               where q.State = 'A')
    loop
      :Company_Id := r.Company_Id;
      for Fil in (select *
                    from Md_Filials Fl
                   where Fl.Company_Id = r.Company_Id
                     and Fl.State = 'A')
      loop
        :Filial_Id := Fil.Filial_Id;
      
        insert into Htt_Dirty_Timesheets
          (Company_Id, Filial_Id, Timesheet_Id, Locked)
          select p.Company_Id, p.Filial_Id, p.Timesheet_Id, 'N'
            from Htt_Timesheets p
           where p.Company_Id = Fil.Company_Id
             and p.Filial_Id = Fil.Filial_Id
             and p.Timesheet_Date = v_Begin_Date
             and not exists (select *
                    from Htt_Timesheet_Locks Tl
                   where Tl.Company_Id = p.Company_Id
                     and Tl.Filial_Id = p.Filial_Id
                     and Tl.Staff_Id = p.Staff_Id
                     and Tl.Timesheet_Date = p.Timesheet_Date);
      
        Htt_Core.Gen_Timesheet_Facts;
      
        delete Htt_Dirty_Timesheets;
      end loop;
    end loop;
    v_Begin_Date := v_Begin_Date + 1;
    commit;
  end loop;
  :Commited := 'commit';
exception
  when others then
    rollback;
    :Rollbacked := 'rolled' || sqlerrm;
  
end;
0
0
