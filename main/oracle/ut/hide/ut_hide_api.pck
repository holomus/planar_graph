create or replace package Ut_Hide_Api is
  --%suite(hide_util)
  --%suitepath(vhr.hide.hide_util)

  --%test(Divide by zero)
  --%throws(b.error_n)
  Procedure Dividing_By_Zero;

  --%test(Incorrect placement of parentheses)
  --%throws(b.error_n)
  Procedure Missing_Parenthesis;

  --%test(Exceeding the maximum number of recursion steps)
  --%throws(b.error_n)
  Procedure Exceeding_Recursion_Steps;

  --%test(Not enough variables)
  --%throws(b.error_n)
  Procedure Not_Enough_Variables;

  --%test(Enough variables)
  Procedure Enough_Variables;

  --%test(Getting global variable)
  Procedure Getting_Global_Variable;

  --%test(Absence of variable)
  Procedure Absence_Of_Variable;

  --%test(Absence of arithmetic operation)
  Procedure Absence_Of_Arithmetic_Operation;

  --%test(Bulk testcase)
  Procedure Bulk_Testcase;
end Ut_Hide_Api;
/
create or replace package body Ut_Hide_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Dividing_By_Zero is
    v_Expression varchar2(500) := '(1 + (1 + (1 + 1))) / (1 - 1)';
    v_Result     number;
  begin
    v_Result := Hide_Util.Expression_Execute(i_Expression => v_Expression);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Missing_Parenthesis is
    v_Expression varchar2(500) := '(((1 + 1) + 1)';
    v_Result     number;
  begin
    v_Result := Hide_Util.Expression_Execute(i_Expression => v_Expression);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Exceeding_Recursion_Steps is
    v_Step_Cnt   number := Hide_Pref.c_Max_Recursion_Step_Count + 1;
    v_Expression varchar2(500) := '';
    v_Result     number;
  begin
    for i in 1 .. v_Step_Cnt
    loop
      v_Expression := v_Expression || '(';
    end loop;
  
    v_Expression := v_Expression || '1 + 1';
  
    for i in 1 .. v_Step_Cnt
    loop
      v_Expression := v_Expression || ')';
    end loop;
  
    v_Result := Hide_Util.Expression_Execute(i_Expression => v_Expression);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Not_Enough_Variables is
    v_Expression       varchar2(500) := 'a + b * (a + c) + d';
    v_Global_Variables Hide_Pref.Global_Variable_Nt := Hide_Pref.Global_Variable_Nt();
    result             number;
  
    v_Variable_Matrix Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2('a', 1),
                                                         Array_Varchar2('b', 2),
                                                         Array_Varchar2('c', 3));
  begin
    for i in 1 .. v_Variable_Matrix.Count
    loop
      Hide_Util.Add_Global_Variable_Value(o_Global_Variable_Value => v_Global_Variables,
                                          i_Name                  => v_Variable_Matrix(i) (1),
                                          i_Value                 => to_number(v_Variable_Matrix(i) (2)));
    end loop;
  
    result := Hide_Util.Expression_Execute(i_Expression       => v_Expression,
                                           i_Global_Variables => v_Global_Variables);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Enough_Variables is
    v_Successful       boolean;
    v_Expression       varchar2(500) := 'a + b * (a + c)';
    v_Global_Variables Hide_Pref.Global_Variable_Nt := Hide_Pref.Global_Variable_Nt();
    result             number;
  
    v_Variable_Matrix Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2('a', 1),
                                                         Array_Varchar2('b', 2),
                                                         Array_Varchar2('c', 3));
  begin
    for i in 1 .. v_Variable_Matrix.Count
    loop
      Hide_Util.Add_Global_Variable_Value(o_Global_Variable_Value => v_Global_Variables,
                                          i_Name                  => v_Variable_Matrix(i) (1),
                                          i_Value                 => to_number(v_Variable_Matrix(i) (2)));
    end loop;
  
    result := Hide_Util.Expression_Execute(i_Expression       => v_Expression,
                                           i_Global_Variables => v_Global_Variables);
  
    v_Successful := result = 9;
  
    Ut.Expect(v_Successful).To_Be_True();
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Getting_Global_Variable is
    v_Expression      varchar2(500) := 'a + b * (c + (d - (a - (e + b + (a + c)))))';
    v_Answer          Array_Varchar2 := Array_Varchar2('a', 'b', 'c', 'd', 'e');
    v_Global_Variable Array_Varchar2 := Hide_Util.Get_Global_Variables(v_Expression);
    v_Successful      boolean := true;
  begin
    v_Global_Variable := Fazo.Sort(v_Global_Variable);
  
    if v_Global_Variable.Count <> v_Answer.Count then
      v_Successful := false;
    else
      for i in 1 .. v_Answer.Count
      loop
        if v_Answer(i) <> v_Global_Variable(i) then
          v_Successful := false;
          exit;
        end if;
      end loop;
    end if;
  
    Ut.Expect(v_Successful).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Absence_Of_Variable is
    v_Successful boolean := true;
    result       number;
  
    -------------------------------------------------- 
    Function Excute_Expression(i_Expression varchar2) return boolean is
    begin
      result := Hide_Util.Expression_Execute(i_Expression);
      return false;
    exception
      when others then
        return true;
    end;
  begin
    v_Successful := v_Successful and Excute_Expression('a + (b + )');
    v_Successful := v_Successful and Excute_Expression('a + (b + d) + ');
    v_Successful := v_Successful and Excute_Expression('(b + d /) + c - 12');
    v_Successful := v_Successful and Excute_Expression('(b + + d) + c - 12');
  
    Ut.Expect(v_Successful).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Absence_Of_Arithmetic_Operation is
    -------------------- 
    v_Successful boolean := true;
    result       number;
  
    -------------------------------------------------- 
    Function Excute_Expression(i_Expression varchar2) return boolean is
    begin
      result := Hide_Util.Expression_Execute(i_Expression);
      return false;
    exception
      when others then
        return true;
    end;
  begin
    v_Successful := v_Successful and Excute_Expression('a + (b + c d)');
    v_Successful := v_Successful and Excute_Expression('a + (b + c) d');
    v_Successful := v_Successful and Excute_Expression('a + d (b + d)');
    v_Successful := v_Successful and Excute_Expression('a + (b + d) + (x + 1) (y + 1)');
    v_Successful := v_Successful and Excute_Expression('* b + c + 1');
  
    Ut.Expect(v_Successful).To_Be_True();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Bulk_Testcase is
    v_Testcase Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2('10 + 7 + 3 - 9 + 4 * 3 + 9', '32'),
                                                  Array_Varchar2('(2 + 6) * 9 / 4 / 2 * 11 - (2 + 1) * (9 - 7 + (1 + (4 - (1 + 4)))) + 12',
                                                                 '105'),
                                                  Array_Varchar2('(14 - 21) * 2 + 32 - 90', '-72'),
                                                  Array_Varchar2('((1 + 2) * (7 + (12 + (4 - (11 + (1 + (6 - 3)))))) - 12) / 2 - 12 / (4 - 6) / (1 - (6 - 24 / 6))',
                                                                 '0'),
                                                  Array_Varchar2('6.8 + 1.2 * (1 - 4)', '3,2'),
                                                  Array_Varchar2(' 4   /     9      +      1      /     9    +    1 / 9   + 1',
                                                                 '1,666667'),
                                                  Array_Varchar2('((1 + 1) * (3 + 5) + 4 * (12 -  7 * (4 - 8))) + 4 * (11 + (8 * (12 - 7)) + 34) - 54 / 12 / (1 / 12)',
                                                                 '462'),
                                                  Array_Varchar2('(((((((((((((((((((((1 + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1) + 1',
                                                                 '23'),
                                                  Array_Varchar2('(1 + 1) * (2 + 3) / (3 + 4) * (5 + 6) / (6 + 7) * (7 + 8) / (8 + 9) * (9 + 10) / (10 + 11) * (11 + 12) + 1',
                                                                 '23,195032'),
                                                  Array_Varchar2('1 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 + 0914',
                                                                 '915'),
                                                  Array_Varchar2('-2 * (-2  + (-2 + 1))', '6'),
                                                  Array_Varchar2('- 2 + 8 * (2 + 3) / 2 / (1 + 1) / 5 * (8 + (4 - (1 + 1) * 2 / 2))+ 12',
                                                                 '30'),
                                                  Array_Varchar2('((2 + 3) * 4) / (5 - 1) + 6 * (8 - 3) / 2 - (3 * 2 + 7) * (4 / (2 + 1))',
                                                                 '2,666667'));
  
    -------------------- 
    v_Result     number;
    v_Successful boolean := true;
    v_Expression Hide_Pref.Expression_Rt;
  begin
  
    for i in 1 .. v_Testcase.Count
    loop
      v_Result := Hide_Util.Expression_Execute(i_Expression => v_Testcase(i) (1));
    
      if not (v_Result || '') = v_Testcase(i) (2) then
        v_Successful := false;
        exit;
      end if;
    end loop;
  
    Ut.Expect(v_Successful).To_Be_True();
  end;
end Ut_Hide_Api;
/
