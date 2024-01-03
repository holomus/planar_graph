create or replace package Hide_Pref is
  ----------------------------------------------------------------------------------------------------
  type Element_Rt is record(
    Element_Name       varchar2(200),
    Element_Type       varchar2(1),
    Element_Precedence number);
  type Element_Nt is table of Element_Rt;

  ----------------------------------------------------------------------------------------------------
  type Global_Variable_Rt is record(
    name  varchar(200),
    value number);
  type Global_Variable_Nt is table of Global_Variable_Rt;

  ----------------------------------------------------------------------------------------------------
  type Expression_Rt is record(
    Syntax_Is_Valid            boolean,
    Expression_Elements        Element_Nt,
    Expression_Bracket_Indexes Array_Number,
    Global_Variable            Array_Varchar2);

  ---------------------------------------------------------------------------------------------------- 
  -- element type
  ----------------------------------------------------------------------------------------------------
  c_Element_Type_Arithmetic_Operator constant varchar2(1) := 'A';
  c_Element_Type_Bracket             constant varchar2(1) := 'B';
  c_Element_Type_Variable            constant varchar2(1) := 'V';
  ----------------------------------------------------------------------------------------------------
  c_Max_Recursion_Step_Count constant number := 25;

end Hide_Pref;
/
create or replace package body Hide_Pref is
end Hide_Pref;
/
