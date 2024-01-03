PL/SQL Developer Test script 3.0
75
declare
  v_Begin timestamp;
  v_Diff  interval day to second;
  Ss_Id   number;

  v_Company_Id number := 133;
  v_Filial_Id  number := 504;
  v_Admin      number := Md_Pref.User_Admin(v_Company_Id);
  v_All_Acc    number := 4880;
  v_Resp       number := 4881;

  v_User number := v_Admin;

  v_Data   Hashmap := Hashmap();
  v_Staffs Arraylist := Arraylist();
  v_Staff  Hashmap;
begin
  :Gen    := 'start gen';
  v_Begin := Current_Timestamp;

  for St in (select q.Employee_Id
               from Mhr_Employees q
              where q.Company_Id = v_Company_Id
                and q.Filial_Id = v_Filial_Id)
  loop
    v_Staff := Hashmap();
  
    v_Staff.Put('employee_id', St.Employee_Id);
    v_Staff.Put('is_valid', 'Y');
    v_Staff.Put('skip_inputs', 'N');
    v_Staff.Put('skip_outputs', 'N');
    v_Staff.Put('input_left', 8 * 60 + 55);
    v_Staff.Put('input_right', 9 * 60);
    v_Staff.Put('output_left', 18 * 60);
    v_Staff.Put('output_right', 18 * 60 + 5);
  
    v_Staffs.Push(v_Staff);
  end loop;

  v_Data.Put('generate_kind', 'T');
  v_Data.Put('period_begin', Trunc(sysdate, 'mon'));
  v_Data.Put('period_end', Last_Day(sysdate));
  v_Data.Put('staffs', v_Staffs);

  v_Diff := v_Begin - Current_Timestamp;

  :Diff_Start := Extract(day from v_Diff) || ' ' || Extract(Hour from v_Diff) || ':' ||
                 Extract(Minute from v_Diff) || ':' || Extract(second from v_Diff);
  :Gen        := 'start ui';

  Biruni_Route.Context_Begin;
  Ui_Context.Init(i_User_Id      => v_User,
                  i_Project_Code => Verifix.Project_Code,
                  i_Filial_Id    => v_Filial_Id);

  v_Begin := Current_Timestamp;

  Ui_Vhr232.Generate(v_Data);

  select Sys_Context('userenv', 'sessionid')
    into Ss_Id
    from Dual;

  v_Diff := v_Begin - Current_Timestamp;

  :Ui_Session_Id := Ui.Session_Id;
  :Aud_Id        := Ss_Id;
  :Diff          := Extract(day from v_Diff) || ' ' || Extract(Hour from v_Diff) || ':' ||
                    Extract(Minute from v_Diff) || ':' || Extract(second from v_Diff);

  Biruni_Route.Context_End;

  -- rollback;
  -- commit;
end;
0
0
