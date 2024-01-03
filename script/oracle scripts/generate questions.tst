PL/SQL Developer Test script 3.0
67
declare
  c_Company_Id number := 0;
  c_Filial_Id  number := 840;

  c_Questions_Count number := 1000;

  v_Question Hln_Pref.Question_Rt;
  v_Type_Ids Array_Number;
begin
  Ui_Auth.Logon_As_System(c_Company_Id);

  for i in 1 .. c_Questions_Count
  loop
    Hln_Util.Question_New(o_Question     => v_Question,
                          i_Company_Id   => c_Company_Id,
                          i_Filial_Id    => c_Filial_Id,
                          i_Question_Id  => Hln_Next.Question_Id,
                          i_Name         => 'Question template',
                          i_Answer_Type  => Hln_Pref.c_Answer_Type_Single,
                          i_Code         => null,
                          i_State        => 'A',
                          i_Writing_Hint => null,
                          i_Files        => Array_Varchar2());
  
    v_Question.Name := v_Question.Name || '(' || v_Question.Question_Id || ')';
  
    for r in (select *
                from Hln_Question_Groups Qg
               where Qg.Company_Id = c_Company_Id
                 and Qg.State = 'A')
    loop
      select Qr.Question_Type_Id
        bulk collect
        into v_Type_Ids
        from (select Qt.*
                from Hln_Question_Types Qt
               where Qt.Company_Id = c_Company_Id
                 and Qt.Question_Group_Id = r.Question_Group_Id
               order by Dbms_Random.Value) Qr
       where Rownum = 1;
    
      for i in 1 .. v_Type_Ids.Count
      loop
        Hln_Util.Question_Add_Group_Bind(p_Question          => v_Question,
                                         i_Question_Group_Id => r.Question_Group_Id,
                                         i_Question_Type_Id  => v_Type_Ids(i));
      end loop;
    end loop;
  
    Hln_Util.Question_Add_Option(p_Question           => v_Question,
                                 i_Question_Option_Id => Hln_Next.Question_Option_Id,
                                 i_Name               => 'Option-1',
                                 i_File_Sha           => null,
                                 i_Is_Correct         => 'Y',
                                 i_Order_No           => 1);
  
    Hln_Util.Question_Add_Option(p_Question           => v_Question,
                                 i_Question_Option_Id => Hln_Next.Question_Option_Id,
                                 i_Name               => 'Option-2',
                                 i_File_Sha           => null,
                                 i_Is_Correct         => 'N',
                                 i_Order_No           => 2);
  
    Hln_Api.Question_Save(v_Question);
  end loop;
  commit;
end;
0
0
