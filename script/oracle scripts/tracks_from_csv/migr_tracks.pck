create or replace package Migr_Tracks is
  ----------------------------------------------------------------------------------------------------
  Function Plan_Code return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Chain_Code return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Task_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Distribute_Tasks
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Run(i_Task_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan;
end Migr_Tracks;
/
create or replace package body Migr_Tracks is
  ----------------------------------------------------------------------------------------------------
  Function Plan_Code return varchar2 is
  begin
    return 'migr_csv_tracks';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Chain_Code return varchar2 is
  begin
    return 'migr_csv_tracks';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Task_Type_Id return number is
  begin
    return 2;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Distribute_Tasks
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Task_Id number;
  
    v_Task_Employees_Cnt  number := 0;
    v_Employees_Threshold number := 100;
  
    --------------------------------------------------
    Function Task_Insert return number is
      v_Task_Id number;
    begin
      v_Task_Id := Mdw_Tasks_Sq.Nextval;
    
      insert into Mdw_Tasks
        (Task_Id, Plan_Code, Chain_Code, Task_Type_Id, Order_No, Status)
      values
        (v_Task_Id, Plan_Code, Chain_Code, Task_Type_Id, v_Task_Id, 'Q');
    
      return v_Task_Id;
    end;
  
  begin
    v_Task_Id := Task_Insert;
  
    for r in (select Qr.Person_Id
                from (select q.Person_Id
                        from Migr_Csv_Tracks q
                       where not exists (select 1
                                from Migr_Inserted_Tracks Tr
                               where Tr.Track_Id = q.Track_Id)
                       group by q.Person_Id) Qr
               where not exists (select 1
                        from Migr_Employee_Task_Tracks p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Employee_Id = Qr.Person_Id
                         and exists (select 1
                                from Mdw_Tasks Ts
                               where Ts.Task_Id = p.Task_Id
                                 and Ts.Status in ('Q', 'R', 'P')))
                 and exists (select 1
                        from Mhr_Employees t
                       where t.Company_Id = i_Company_Id
                         and t.Filial_Id = i_Filial_Id
                         and t.Employee_Id = Qr.Person_Id))
    loop
      insert into Migr_Employee_Task_Tracks
        (Task_Id, Company_Id, Filial_Id, Employee_Id)
      values
        (v_Task_Id, i_Company_Id, i_Filial_Id, r.Person_Id);
    
      v_Task_Employees_Cnt := v_Task_Employees_Cnt + 1;
    
      if v_Task_Employees_Cnt >= v_Employees_Threshold then
        v_Task_Id            := Task_Insert;
        v_Task_Employees_Cnt := 0;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(i_Task_Id number) is
    v_Cnt number;
  
    r_Track Htt_Tracks%rowtype;
  begin
    select count(*)
      into v_Cnt
      from Migr_Employee_Task_Tracks q
      join Migr_Csv_Tracks t
        on t.Person_Id = q.Employee_Id
     where q.Task_Id = i_Task_Id
       and not exists (select 1
              from Migr_Inserted_Tracks Tr
             where Tr.Track_Id = t.Track_Id);
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Employee_Id,
                     t.Track_Date,
                     t.Full_Name,
                     t.Track_Type,
                     t.Track_Time,
                     t.Track_Id,
                     Rownum Rn
                from Migr_Employee_Task_Tracks q
                join Migr_Csv_Tracks t
                  on t.Person_Id = q.Employee_Id
               where q.Task_Id = i_Task_Id
                 and not exists (select 1
                        from Migr_Inserted_Tracks Tr
                       where Tr.Track_Id = t.Track_Id))
    loop
      Dbms_Application_Info.Set_Module(Module_Name => 'migr_tracks.run',
                                       Action_Name => 'tracks: ' || r.Rn || '/' || v_Cnt);
    
      begin
        savepoint Try_Catch;
      
        Biruni_Route.Context_Begin;
        Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                             i_Filial_Id    => r.Filial_Id,
                             i_User_Id      => Md_Pref.User_System(r.Company_Id),
                             i_Project_Code => 'vhr');
      
        z_Htt_Tracks.Init(p_Row        => r_Track,
                          i_Company_Id => r.Company_Id,
                          i_Filial_Id  => r.Filial_Id,
                          i_Track_Id   => Htt_Next.Track_Id,
                          i_Track_Time => To_Timestamp_Tz(r.Track_Date || ' ' || r.Track_Time ||
                                                          ' +05:00',
                                                          'DD.MM.YYYY HH24:MI:SS TZH:TZM'),
                          i_Person_Id  => r.Employee_Id,
                          i_Track_Type => case r.Track_Type
                                            when 'Приход' then
                                             Htt_Pref.c_Track_Type_Input
                                            when 'Уход' then
                                             Htt_Pref.c_Track_Type_Output
                                            else
                                             Htt_Pref.c_Track_Type_Check
                                          end,
                          i_Mark_Type  => Htt_Pref.c_Mark_Type_Manual,
                          i_Note       => 'Промигрировано с Workly',
                          i_Is_Valid   => 'Y');
      
        Htt_Api.Track_Add(r_Track);
        Biruni_Route.Context_End;
      
        insert into Migr_Inserted_Tracks
          (Track_Id)
        values
          (r.Track_Id);
      
        commit;
      exception
        when others then
          rollback to Try_Catch;
      end;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan is
  begin
    null;
  end;

end Migr_Tracks;
/
