set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  --------------------------------------------------
  Procedure Task_Group
  (
    i_Task_Group_Id number,
    i_Name          varchar2,
    i_State         varchar2,
    i_Pcode         varchar2
  ) is
  begin
    z_Ms_Task_Groups.Save_One(i_Company_Id    => v_Company_Head,
                              i_Task_Group_Id => i_Task_Group_Id,
                              i_Name          => i_Name,
                              i_State         => i_State,
                              i_Pcode         => i_Pcode);
  end;

begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Task groups ====');
  Task_Group(Ms_Next.Task_Group_Id, 'План', 'A', Hper_Pref.c_Pcode_Task_Group_Plan);

  commit;
end;
/
