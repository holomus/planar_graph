create or replace package Hide_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Add_Global_Variable_Value
  (
    o_Global_Variable_Value in out nocopy Hide_Pref.Global_Variable_Nt,
    i_Name                  varchar2,
    i_Value                 number
  );
  ------------------------------------------------------------------------------------------------
  Function Parse_Expression(i_Expression varchar2) return Hide_Pref.Expression_Rt;
  ---------------------------------------------------------------------------------------------------- 
  Function Expression_Execute
  (
    i_Expression       varchar2,
    i_Global_Variables Hide_Pref.Global_Variable_Nt := Hide_Pref.Global_Variable_Nt()
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Global_Variables(i_Expression varchar2) return Array_Varchar2;
end Hide_Util;
/
create or replace package body Hide_Util is
  -------------------------------------------------- 
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('hide_UTIL:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  --------------------------------------------------
  Function Is_Number(p_String varchar2) return boolean is
    v_Num number;
  begin
    v_Num := to_number(p_String, '9999999999.99999');
    return true;
  exception
    when Value_Error then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Precedence_Operator(i_Operator varchar) return number is
  begin
    if i_Operator = '+' or i_Operator = '-' then
      return 1;
    elsif i_Operator = '*' or i_Operator = '/' then
      return 2;
    else
      return 0;
    end if;
  end;

  --------------------------------------------------
  Function Is_Operator(i_Identifier varchar2) return boolean is
  begin
    if i_Identifier member of Array_Varchar2('+', '-', '/', '*') then
      return true;
    end if;
  
    return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Element_Add
  (
    i_Elements     in out nocopy Hide_Pref.Element_Nt,
    i_Element_Name varchar2,
    i_Element_Type varchar2
  ) is
    v_Element Hide_Pref.Element_Rt;
  begin
    v_Element.Element_Name := i_Element_Name;
    v_Element.Element_Type := i_Element_Type;
  
    i_Elements.Extend();
    i_Elements(i_Elements.Count) := v_Element;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Global_Variable_Value
  (
    o_Global_Variable_Value in out nocopy Hide_Pref.Global_Variable_Nt,
    i_Name                  varchar2,
    i_Value                 number
  ) is
    v_Variable Hide_Pref.Global_Variable_Rt;
  begin
    v_Variable.Name  := i_Name;
    v_Variable.Value := i_Value;
  
    o_Global_Variable_Value.Extend();
    o_Global_Variable_Value(o_Global_Variable_Value.Count) := v_Variable;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Is_Brackets(i_Element varchar2) return boolean is
  begin
    return i_Element = '(' or i_Element = ')';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Brackets_Index(i_Elements Hide_Pref.Element_Nt) return Array_Number is
    v_Stack           Array_Number := Array_Number();
    v_Bracket_Indexes Array_Number := Array_Number();
    v_Size            number := 0;
  begin
    v_Bracket_Indexes.Extend(i_Elements.Count);
    v_Stack.Extend(i_Elements.Count / 2);
  
    for i in 1 .. i_Elements.Count
    loop
      if i_Elements(i).Element_Name = '(' then
        v_Size := v_Size + 1;
        v_Stack(v_Size) := i;
      elsif i_Elements(i).Element_Name = ')' then
        if v_Size = 0 then
          Hide_Error.Raise_001;
        end if;
      
        v_Bracket_Indexes(v_Stack(v_Size)) := i;
        v_Size := v_Size - 1;
      end if;
    end loop;
  
    if v_Size > 0 then
      Hide_Error.Raise_001;
    end if;
  
    return v_Bracket_Indexes;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Assert_Variable_Enabled(i_Variable_Name varchar2) is
    v_Variable_Parts Array_Varchar2;
  begin
    if Is_Number(i_Variable_Name) then
      return;
    end if;
  
    v_Variable_Parts := Fazo.Split(i_Variable_Name, ' ');
  
    if v_Variable_Parts.Count = 1 then
      return;
    end if;
  
    for i in 2 .. v_Variable_Parts.Count
    loop
      if Nvl(Length(v_Variable_Parts(i)), 0) > 0 then
        Hide_Error.Raise_004(v_Variable_Parts(i));
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Parse_Expression_Elements(i_Expression varchar2) return Hide_Pref.Element_Nt is
    v_Element    varchar2(200);
    v_Char       varchar2(10);
    v_Expression varchar2(500) := i_Expression;
    v_Elements   Hide_Pref.Element_Nt := Hide_Pref.Element_Nt();
  begin
    if i_Expression is null then
      return v_Elements;
    end if;
  
    if Substr(i_Expression, 0, 1) in ('+', '-') then
      v_Expression := '0' || i_Expression;
    end if;
  
    for i in 1 .. Length(v_Expression)
    loop
      v_Char := Substr(v_Expression, i, 1);
    
      if Is_Brackets(v_Char) then
        v_Element := trim(v_Element);
      
        if Nvl(Length(v_Element), 0) > 0 and v_Elements.Count > 0 and v_Elements(v_Elements.Count).Element_Name = ')' then
          Hide_Error.Raise_004(v_Element);
        end if;
      
        if (Nvl(Length(v_Element), 0) > 0 or
           v_Elements.Count > 0 and v_Elements(v_Elements.Count).Element_Name = ')') and
           v_Char = '(' then
          Hide_Error.Raise_004('(');
        end if;
      
        if not (Nvl(Length(v_Element), 0) > 0 or
            v_Elements.Count > 0 and v_Elements(v_Elements.Count).Element_Name = ')') and
           v_Char = ')' then
          Hide_Error.Raise_005(i_Element_Name => ')', i_Is_Before => true);
        end if;
      
        if v_Char = ')' and Nvl(Length(v_Element), 0) > 0 then
          Assert_Variable_Enabled(v_Element);
        
          Element_Add(i_Elements     => v_Elements,
                      i_Element_Name => v_Element,
                      i_Element_Type => Hide_Pref.c_Element_Type_Variable);
        
          v_Element := '';
        end if;
      
        Element_Add(i_Elements     => v_Elements,
                    i_Element_Name => v_Char,
                    i_Element_Type => Hide_Pref.c_Element_Type_Bracket);
      elsif Is_Operator(v_Char) then
        v_Element := trim(v_Element);
      
        if Nvl(Length(v_Element), 0) > 0 and v_Elements.Count > 0 and v_Elements(v_Elements.Count).Element_Name = ')' then
          Hide_Error.Raise_004(v_Element);
        end if;
      
        if Nvl(Length(v_Element), 0) = 0 and
           (v_Elements.Count = 0 or v_Elements(v_Elements.Count).Element_Name <> ')') then
          if not ((v_Elements.Count = 0 or v_Elements(v_Elements.Count).Element_Name = '(') and
              v_Char in ('+', '-')) then
            Hide_Error.Raise_005(i_Element_Name => v_Char, i_Is_Before => true);
          end if;
        else
          if Nvl(Length(v_Element), 0) > 0 then
            Assert_Variable_Enabled(v_Element);
          
            Element_Add(i_Elements     => v_Elements,
                        i_Element_Name => v_Element,
                        i_Element_Type => Hide_Pref.c_Element_Type_Variable);
          end if;
        end if;
      
        Element_Add(i_Elements     => v_Elements,
                    i_Element_Name => v_Char,
                    i_Element_Type => Hide_Pref.c_Element_Type_Arithmetic_Operator);
      
        v_Element := '';
      else
        v_Element := v_Element || v_Char;
      end if;
    end loop;
  
    v_Element := trim(v_Element);
  
    if Nvl(Length(v_Element), 0) > 0 then
      if Nvl(Length(v_Element), 0) > 0 and v_Elements.Count > 0 and v_Elements(v_Elements.Count).Element_Name = ')' then
        Hide_Error.Raise_004(v_Element);
      end if;
    
      Assert_Variable_Enabled(v_Element);
    
      Element_Add(i_Elements     => v_Elements,
                  i_Element_Name => v_Element,
                  i_Element_Type => Hide_Pref.c_Element_Type_Variable);
    end if;
  
    if v_Elements.Count > 0 and v_Elements(v_Elements.Count)
      .Element_Type = Hide_Pref.c_Element_Type_Arithmetic_Operator then
      Hide_Error.Raise_005(i_Element_Name => v_Elements(v_Elements.Count).Element_Name);
    end if;
  
    return v_Elements;
  end;

  --------------------------------------------------
  Function Execute_Operator
  (
    i_First_Argument  number,
    i_Second_Argument number,
    i_Operator        varchar2
  ) return number is
    v_Result number;
  begin
    case i_Operator
      when '+' then
        v_Result := i_First_Argument + i_Second_Argument;
      when '-' then
        v_Result := i_First_Argument - i_Second_Argument;
      when '*' then
        v_Result := i_First_Argument * i_Second_Argument;
      when '/' then
        if i_Second_Argument = 0 then
          Hide_Error.Raise_002;
        else
          v_Result := i_First_Argument / i_Second_Argument;
        end if;
      else
        Hide_Error.Raise_007;
    end case;
  
    return v_Result;
  end;

  ------------------------------------------------------------------------------------------------
  Function Parse_Expression(i_Expression varchar2) return Hide_Pref.Expression_Rt is
    v_Expression          Hide_Pref.Expression_Rt;
    v_Expression_Elements Hide_Pref.Element_Nt;
    v_Global_Variables    Array_Varchar2 := Array_Varchar2();
  begin
    v_Expression_Elements                   := Parse_Expression_Elements(i_Expression);
    v_Expression.Expression_Elements        := v_Expression_Elements;
    v_Expression.Expression_Bracket_Indexes := Get_Brackets_Index(v_Expression.Expression_Elements);
  
    for i in 1 .. v_Expression_Elements.Count
    loop
      if v_Expression_Elements(i).Element_Type = Hide_Pref.c_Element_Type_Variable then
        if not Is_Number(v_Expression_Elements(i).Element_Name) then
          Fazo.Push(v_Global_Variables, v_Expression_Elements(i).Element_Name);
        end if;
      end if;
    end loop;
  
    v_Expression.Global_Variable := set(v_Global_Variables);
    v_Expression.Syntax_Is_Valid := true;
  
    return v_Expression;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Expression_Execute
  (
    i_Expression       varchar2,
    i_Global_Variables Hide_Pref.Global_Variable_Nt := Hide_Pref.Global_Variable_Nt()
  ) return number is
    v_Expression      Hide_Pref.Expression_Rt := Parse_Expression(i_Expression);
    v_Elements        Hide_Pref.Element_Nt := v_Expression.Expression_Elements;
    v_Bracket_Indexes Array_Number := v_Expression.Expression_Bracket_Indexes;
    v_Element_Values  Fazo.Number_Code_Aat;
  
    --------------------------------------------------
    Function Get_Element_Value(i_Element_Name varchar2) return number is
    begin
      if Is_Number(i_Element_Name) then
        return to_number(i_Element_Name, '9999999999.999999');
      end if;
    
      if not v_Element_Values.Exists(i_Element_Name) then
        b.Raise_Error('|' || i_Element_Name || '|');
      end if;
    
      return v_Element_Values(i_Element_Name);
    end;
  
    -------------------------------------------------- 
    Function Calc_Expression
    (
      i_Begin    number,
      i_End      number,
      i_Step_Cnt number := Hide_Pref.c_Max_Recursion_Step_Count
    ) return number;
  
    --------------------------------------------------
    Function Calculat_Same_Precedence
    (
      i_Begin    number,
      i_End      number,
      i_Step_Cnt number
    ) return number is
      v_Second_Argument number;
      v_Numerator       number := 1;
      v_Denominator     number := 1;
      v_Index           number;
      Is_Numerator      boolean := false;
    begin
      if i_Step_Cnt <= 0 then
        Hide_Error.Raise_003;
      end if;
    
      if i_Begin = i_End then
        return Get_Element_Value(v_Elements(i_Begin).Element_Name);
      end if;
    
      if Is_Brackets(v_Elements(i_Begin).Element_Name) then
        v_Numerator := Calc_Expression(i_Begin    => i_Begin + 1,
                                       i_End      => v_Bracket_Indexes(i_Begin) - 1,
                                       i_Step_Cnt => i_Step_Cnt - 1);
      
        v_Index := v_Bracket_Indexes(i_Begin) + 1;
      else
        v_Numerator := Get_Element_Value(v_Elements(i_Begin).Element_Name);
        v_Index     := i_Begin + 1;
      end if;
    
      while v_Index < i_End
      loop
        Is_Numerator := v_Elements(v_Index).Element_Name = '*';
      
        if Is_Brackets(v_Elements(v_Index + 1).Element_Name) then
        
          v_Second_Argument := Calc_Expression(i_Begin    => v_Index + 2,
                                               i_End      => v_Bracket_Indexes(v_Index + 1) - 1,
                                               i_Step_Cnt => i_Step_Cnt - 1);
        
          v_Index := v_Bracket_Indexes(v_Index + 1) + 1;
        else
          v_Second_Argument := Get_Element_Value(v_Elements(v_Index + 1).Element_Name);
          v_Index           := v_Index + 2;
        end if;
      
        if Is_Numerator then
          v_Numerator := v_Numerator * v_Second_Argument;
        else
          v_Denominator := v_Denominator * v_Second_Argument;
        end if;
      end loop;
    
      return Execute_Operator(i_First_Argument  => v_Numerator,
                              i_Second_Argument => v_Denominator,
                              i_Operator        => '/');
    end;
  
    --------------------------------------------------
    Function Parse_Next_Value
    (
      i_Begin    number,
      i_End      number,
      i_Index    in out number,
      i_Step_Cnt number
    ) return number is
      v_Parser number := i_Begin;
    begin
      while v_Parser <= i_End
      loop
        if Is_Brackets(v_Elements(v_Parser).Element_Name) then
          v_Parser := v_Bracket_Indexes(v_Parser) + 1;
        elsif v_Elements(v_Parser).Element_Type = Hide_Pref.c_Element_Type_Arithmetic_Operator then
          if Get_Precedence_Operator(v_Elements(v_Parser).Element_Name) = 1 then
            exit;
          else
            v_Parser := v_Parser + 1;
          end if;
        else
          v_Parser := v_Parser + 1;
        end if;
      end loop;
    
      i_Index := Least(v_Parser, i_End);
    
      return Calculat_Same_Precedence(i_Begin    => i_Begin,
                                      i_End      => v_Parser - 1,
                                      i_Step_Cnt => i_Step_Cnt);
    end;
  
    -------------------------------------------------- 
    Function Calc_Expression
    (
      i_Begin    number,
      i_End      number,
      i_Step_Cnt number := Hide_Pref.c_Max_Recursion_Step_Count
    ) return number is
      v_Summa           number := 0;
      v_Second_Argument number;
      v_Index           number := i_Begin;
      v_Is_Positive     boolean;
    begin
      if i_Step_Cnt <= 0 then
        Hide_Error.Raise_003;
      end if;
    
      if v_Elements(v_Index).Element_Name not in ('+', '-') then
        v_Summa := Parse_Next_Value(i_Begin    => v_Index,
                                    i_End      => i_End,
                                    i_Index    => v_Index,
                                    i_Step_Cnt => i_Step_Cnt);
      end if;
    
      while v_Index < i_End
      loop
        v_Is_Positive     := v_Elements(v_Index).Element_Name = '+';
        v_Second_Argument := Parse_Next_Value(i_Begin    => v_Index + 1,
                                              i_End      => i_End,
                                              i_Index    => v_Index,
                                              i_Step_Cnt => i_Step_Cnt);
      
        if v_Is_Positive then
          v_Summa := v_Summa + v_Second_Argument;
        else
          v_Summa := v_Summa - v_Second_Argument;
        end if;
      end loop;
    
      return v_Summa;
    end;
  begin
    for i in 1 .. i_Global_Variables.Count
    loop
      v_Element_Values(i_Global_Variables(i).Name) := i_Global_Variables(i).Value;
    end loop;
  
    for i in 1 .. v_Expression.Global_Variable.Count
    loop
      if not v_Element_Values.Exists(v_Expression.Global_Variable(i)) then
        Hide_Error.Raise_006(v_Expression.Global_Variable(i));
      end if;
    end loop;
  
    return Round(Calc_Expression(i_Begin => 1, i_End => v_Elements.Count), 6);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Global_Variables(i_Expression varchar2) return Array_Varchar2 is
  begin
    return Parse_Expression(i_Expression).Global_Variable;
  end;

end Hide_Util;
/
