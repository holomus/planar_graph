create or replace package Ui_Vhr243 is
  ----------------------------------------------------------------------------------------------------  
  Procedure Template;
  ---------------------------------------------------------------------------------------------------- 
  Function Model return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Setting(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Import_File(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Import_Data(p Hashmap);
end Ui_Vhr243;
/
create or replace package body Ui_Vhr243 is
  ----------------------------------------------------------------------------------------------------  
  type Question_Rt is record(
    Question_Name varchar2(2000 char),
    Code          varchar2(50 char),
    Writing_Hint  varchar2(500 char),
    Answer_Type   varchar2(25 char),
    Right_Options Array_Number,
    Type_Binds    Array_Varchar2,
    Options       Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  type Column_Rt is record(
    Key         varchar2(1000),
    name        varchar2(100),
    Order_No    number,
    Is_Required varchar2(1));
  type Column_Nt is table of Column_Rt;
  ----------------------------------------------------------------------------------------------------
  -- template global variables
  ----------------------------------------------------------------------------------------------------
  g_Starting_Row    number;
  g_Option_Count    number;
  g_Default_Columns Column_Nt;
  g_Error_Messages  Arraylist;
  g_Errors          Arraylist;
  g_Question_Groups Matrix_Varchar2;
  g_Question        Question_Rt;
  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR243:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR243:COLUMN_ITEMS';
  c_Pc_Option_Count constant varchar2(50) := 'UI-VHR243:OPTION_COUNT';

  c_Question_Name   constant varchar2(50) := 'question_name';
  c_Right_Option_No constant varchar2(50) := 'right_option_no';
  c_Answer_Type     constant varchar2(50) := 'answer_type';
  c_Writing_Hint    constant varchar2(50) := 'writing_hint';
  c_Code            constant varchar2(50) := 'code';

  c_Group  constant varchar2(50) := 'group';
  c_Option constant varchar2(50) := 'option';

  c_Qg_Id_Index         constant number := 1;
  c_Qg_Required_Index   constant number := 2;
  c_Qg_Name_Index       constant number := 3;
  c_Qg_Type_Count_Index constant number := 4;

  c_Source_Table_First_Row constant number := 1;
  c_Source_Table_Last_Row  constant number := 102;
  ----------------------------------------------------------------------------------------------------
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
    return b.Translate('UI-VHR243:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Default_Columns is
    v_Column  Column_Rt;
    v_Setting Hashmap := Nvl(Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id,
                                                         i_Code       => c_Pc_Column_Items)),
                             Hashmap());
    -------------------------------------------------- 
    Procedure Push
    (
      i_Key         varchar2,
      i_Column_Name varchar2,
      i_Is_Required varchar2
    ) is
    begin
      v_Column.Key         := i_Key;
      v_Column.Name        := i_Column_Name;
      v_Column.Order_No    := v_Column.Order_No + 1;
      v_Column.Is_Required := i_Is_Required;
    
      g_Default_Columns.Extend;
      g_Default_Columns(v_Column.Order_No) := v_Column;
    end;
  begin
    g_Default_Columns := Column_Nt();
    v_Column.Order_No := 0;
  
    Push(c_Question_Name, t('question_name'), 'Y');
  
    for k in 1 .. g_Option_Count
    loop
      Push(c_Option || k, t('option$1', k), Md_Util.Decode(k, 1, 'Y', 2, 'Y', 'N'));
    end loop;
  
    Push(c_Writing_Hint, t('writing_hint'), 'N');
    Push(c_Right_Option_No, t('right_option_no'), 'Y');
    Push(c_Answer_Type, t('answer_type'), 'Y');
  
    for g in 1 .. g_Question_Groups.Count
    loop
      Push(c_Group || g,
           g_Question_Groups(g) (c_Qg_Name_Index),
           g_Question_Groups(g) (c_Qg_Required_Index));
    end loop;
  
    Push(c_Code, t('code'), 'N');
  
    if v_Setting.Count > 0 then
      for i in 1 .. g_Default_Columns.Count
      loop
        v_Column := g_Default_Columns(i);
      
        v_Column.Order_No := v_Setting.o_Number(v_Column.Key);
      
        g_Default_Columns(i) := v_Column;
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Column_Order_Number(i_Key varchar2) return varchar2 is
  begin
    for i in 1 .. g_Default_Columns.Count
    loop
      if g_Default_Columns(i).Key = i_Key then
        return g_Default_Columns(i).Order_No;
      end if;
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Columns_All return Matrix_Varchar2 is
    v_Column Column_Rt;
    result   Matrix_Varchar2 := Matrix_Varchar2();
  begin
    for i in 1 .. g_Default_Columns.Count
    loop
      v_Column := g_Default_Columns(i);
    
      Fazo.Push(result,
                Array_Varchar2(v_Column.Key, v_Column.Name, v_Column.Order_No, v_Column.Is_Required));
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Starting_Row return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pc_Starting_Row),
               2);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap) is
    v_Keys           Array_Varchar2 := p.r_Array_Varchar2('keys');
    v_Column_Numbers Array_Varchar2 := p.r_Array_Varchar2('column_numbers');
    v_Option_Count   number := p.r_Number('option_count');
    v_Setting        Hashmap := Hashmap();
  begin
    if not v_Option_Count between 2 and 10 then
      b.Raise_Error(t('question_import: option count must be between 2 and 10, option_count $1',
                      v_Option_Count));
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Starting_Row,
                           i_Value      => p.o_Number('starting_row'));
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Option_Count,
                           i_Value      => v_Option_Count);
  
    for i in 1 .. v_Keys.Count
    loop
      v_Setting.Put(v_Keys(i), v_Column_Numbers(i));
    end loop;
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Column_Items,
                           i_Value      => v_Setting.Json);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    select Array_Varchar2(q.Question_Group_Id,
                          q.Is_Required,
                          q.Name,
                          (select count(*)
                             from Hln_Question_Types Qt
                            where Qt.Company_Id = q.Company_Id
                              and Qt.Filial_Id = q.Filial_Id
                              and Qt.Question_Group_Id = q.Question_Group_Id))
      bulk collect
      into g_Question_Groups
      from Hln_Question_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.State = 'A'
       and exists (select 1
              from Hln_Question_Types Qt
             where Qt.Company_Id = q.Company_Id
               and Qt.Filial_Id = q.Filial_Id
               and Qt.Question_Group_Id = q.Question_Group_Id)
     order by q.Order_No, q.Pcode, Lower(q.Name)
     fetch first 5 Rows only;
  
    g_Option_Count := to_number(Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Code       => c_Pc_Option_Count),
                                    
                                    4));
    g_Starting_Row := Starting_Row;
    g_Errors       := Arraylist();
  
    Set_Default_Columns;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Set_Global_Variables;
  
    Result.Put('references',
               Fazo.Zip_Map('answer_type_single',
                            Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Single),
                            'answer_type_multiple',
                            Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Multiple),
                            'answer_type_writing',
                            Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Writing)));
  
    Result.Put('starting_row', Starting_Row);
    Result.Put('question_groups', Fazo.Zip_Matrix(g_Question_Groups));
    Result.Put('option_count', g_Option_Count);
    Result.Put('items', Fazo.Zip_Matrix(Columns_All));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table return b_Table is
    v_Table     b_Table;
    v_Aux_Table b_Table;
  begin
    v_Table := b_Report.New_Table;
    v_Table.New_Row;
  
    -- group columns 
    for g in 1 .. g_Question_Groups.Count
    loop
      v_Aux_Table := b_Report.New_Table;
      v_Aux_Table.New_Row;
    
      for t in (select Qt.Name
                  from Hln_Question_Types Qt
                 where Qt.Company_Id = Ui.Company_Id
                   and Qt.Filial_Id = Ui.Filial_Id
                   and Qt.Question_Group_Id = g_Question_Groups(g) (c_Qg_Id_Index)
                 order by Qt.Order_No, Qt.Name)
      loop
        v_Aux_Table.Data(t.Name);
        v_Aux_Table.New_Row;
      end loop;
    
      v_Table.Data(v_Aux_Table);
    end loop;
  
    -- answer type
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    v_Aux_Table.Data(Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Single));
    v_Aux_Table.New_Row;
    v_Aux_Table.Data(Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Multiple));
    v_Aux_Table.New_Row;
    v_Aux_Table.Data(Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Writing));
    v_Aux_Table.New_Row;
  
    v_Table.Data(v_Aux_Table);
  
    return v_Table;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    v_Main_Table   b_Table;
    v_Source_Table b_Table;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Source_Name  varchar2(10) := 'data';
    v_Column_Order number;
    v_Begin_Index  number;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null
    ) is
      v_Column_Order number := Column_Order_Number(i_Column_Key);
    begin
      if v_Column_Order is null then
        v_Left_Matrix.Extend;
        v_Left_Matrix(v_Left_Matrix.Count) := Array_Varchar2(i_Column_Data, i_Column_Width);
      else
        if v_Column_Order > v_Begin_Index then
          for i in v_Begin_Index + 1 .. v_Column_Order
          loop
            v_Data_Matrix.Extend;
            v_Data_Matrix(v_Data_Matrix.Count) := Array_Varchar2(null, null);
          end loop;
        
          v_Begin_Index := v_Column_Order;
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        else
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        end if;
      end if;
    end;
  
    --------------------------------------------------                   
    Procedure Push_Left_Data is
    begin
      for i in 1 .. v_Left_Matrix.Count
      loop
        v_Data_Matrix.Extend;
        v_Data_Matrix(v_Data_Matrix.Count) := v_Left_Matrix(i);
      end loop;
    end;
  begin
    Set_Global_Variables;
  
    v_Data_Matrix := Matrix_Varchar2();
    v_Left_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    v_Source_Table := Source_Table;
    v_Main_Table   := b_Report.New_Table;
  
    v_Main_Table.Current_Style('header');
    v_Main_Table.New_Row;
  
    Set_Column(c_Question_Name, t('question_name'), 300);
  
    for k in 1 .. g_Option_Count
    loop
      Set_Column(c_Option || k, t('option$1', k), 200);
    end loop;
  
    Set_Column(c_Writing_Hint, t('writing_hint'), 300);
    Set_Column(c_Right_Option_No, t('right_option_no'), 50);
    Set_Column(c_Answer_Type, t('answer_type'), 150);
    Set_Column(c_Code, t('code'), 100);
  
    for g in 1 .. g_Question_Groups.Count
    loop
      v_Column_Order := Column_Order_Number(c_Group || g);
    
      Set_Column(c_Group || g, g_Question_Groups(g) (c_Qg_Name_Index), 100);
    
      if v_Column_Order is not null then
        v_Main_Table.Column_Data_Source(i_Column_Index  => v_Column_Order,
                                        i_First_Row     => c_Source_Table_First_Row,
                                        i_Last_Row      => c_Source_Table_Last_Row,
                                        i_Source_Sheet  => v_Source_Name,
                                        i_Source_Column => g,
                                        i_Source_Count  => g_Question_Groups(g)
                                                           (c_Qg_Type_Count_Index));
      end if;
    end loop;
  
    v_Column_Order := Column_Order_Number(c_Answer_Type);
  
    if v_Column_Order is not null then
      v_Main_Table.Column_Data_Source(i_Column_Index  => v_Column_Order,
                                      i_First_Row     => c_Source_Table_First_Row,
                                      i_Last_Row      => c_Source_Table_Last_Row,
                                      i_Source_Sheet  => v_Source_Name,
                                      i_Source_Column => g_Question_Groups.Count + 1,
                                      i_Source_Count  => 3);
    end if;
  
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      v_Main_Table.Column_Width(i, v_Data_Matrix(i) (2));
      v_Main_Table.Data(v_Data_Matrix(i) (1));
    end loop;
  
    b_Report.Add_Sheet(t('questions'), v_Main_Table);
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Question_Name(i_Question_Name varchar2) is
  begin
    g_Question.Question_Name := i_Question_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with question name $2{question_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Question_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Option(i_Option_Name varchar2) is
  begin
    g_Question.Options.Extend;
    g_Question.Options(g_Question.Options.Count) := i_Option_Name;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Right_Option_No(i_Right_Option_No varchar2) is
    v_Numbers      varchar2(11);
    v_Array_Number Array_Number := Array_Number();
    v_Delimeter    varchar2(1) := ',';
  begin
    if i_Right_Option_No is null then
      g_Question.Right_Options := Array_Number();
    
      return;
    end if;
  
    v_Numbers      := Regexp_Replace(i_Right_Option_No, '[^0-9]', v_Delimeter);
    v_Array_Number := Fazo.To_Array_Number(Fazo.Split(v_Numbers, v_Delimeter));
  
    select Column_Value
      bulk collect
      into g_Question.Right_Options
      from table(v_Array_Number)
     where Column_Value is not null
     order by Column_Value;
  
    if g_Question.Right_Options(g_Question.Right_Options.Last) > g_Option_Count or
       g_Question.Right_Options(g_Question.Right_Options.Last) < 1 then
      g_Error_Messages.Push(t('question_import: right option no must be number and between 1 and $1, $2{right_option_no}',
                              g_Option_Count,
                              i_Right_Option_No));
    end if;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with right option no $2{right_option_no}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Right_Option_No));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Writing_Hint(i_Writing_Hint varchar2) is
  begin
    g_Question.Writing_Hint := i_Writing_Hint;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with writing hint $2{writing_hint}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Writing_Hint));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Type_Bind(i_Type_Name varchar2) is
  begin
    g_Question.Type_Binds.Extend;
    g_Question.Type_Binds(g_Question.Type_Binds.Count) := i_Type_Name;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Answer_Type(i_Answer_Type varchar2) is
  begin
    g_Question.Answer_Type := i_Answer_Type;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with answer type $2{answer_type}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Answer_Type));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Code(i_Code varchar2) is
  begin
    g_Question.Code := i_Code;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with code $2{code}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Row
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    v_Column_Number number;
  
    --------------------------------------------------                   
    Function Cell_Value(i_Column_Name varchar2) return varchar2 is
    begin
      v_Column_Number := Column_Order_Number(i_Column_Name);
    
      if v_Column_Number is not null then
        return i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
      end if;
    
      return null;
    end;
  begin
    Set_Question_Name(Cell_Value(c_Question_Name));
    Set_Writing_Hint(Cell_Value(c_Writing_Hint));
    Set_Right_Option_No(Cell_Value(c_Right_Option_No));
    Set_Code(Cell_Value(c_Code));
  
    g_Question.Options := Array_Varchar2();
  
    for i in 1 .. g_Option_Count
    loop
      Set_Option(Cell_Value(c_Option || i));
    end loop;
  
    Set_Answer_Type(Cell_Value(c_Answer_Type));
  
    g_Question.Type_Binds := Array_Varchar2();
  
    for g in 1 .. g_Question_Groups.Count
    loop
      Set_Type_Bind(Cell_Value(c_Group || g));
    end loop;
  
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Question_To_Array return Array_Varchar2 is
    v_Question Array_Varchar2 := Array_Varchar2();
  
    -------------------------------------------------- 
    Procedure Push(i_Data varchar2) is
    begin
      Fazo.Push(v_Question, i_Data);
    end;
  begin
    Push(g_Question.Question_Name);
  
    for i in 1 .. g_Option_Count
    loop
      Push(g_Question.Options(i));
    end loop;
  
    Push(g_Question.Writing_Hint);
    Push(Fazo.Gather(g_Question.Right_Options, ','));
    Push(g_Question.Answer_Type);
  
    for g in 1 .. g_Question_Groups.Count
    loop
      Push(g_Question.Type_Binds(g));
    end loop;
  
    Push(g_Question.Code);
  
    return v_Question;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Error_Messages.Count = 0 then
      o_Items.Extend;
      o_Items(o_Items.Count) := Question_To_Array;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Error(i_Row_Index number) is
    v_Error Hashmap;
  begin
    if g_Error_Messages.Count > 0 then
      v_Error := Hashmap();
    
      v_Error.Put('row_id', i_Row_Index);
      v_Error.Put('items', g_Error_Messages);
    
      g_Errors.Push(v_Error);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap is
    v_Sheets Arraylist;
    v_Sheet  Excel_Sheet;
    v_Items  Matrix_Varchar2 := Matrix_Varchar2();
    result   Hashmap := Hashmap();
  begin
    v_Sheets := p.r_Arraylist('template');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Question       := null;
      g_Error_Messages := Arraylist();
    
      Parse_Row(v_Sheet, i);
      Push_Row(v_Items);
    
      Push_Error(i);
    end loop;
  
    Result.Put('items', Fazo.Zip_Matrix(v_Items));
    Result.Put('errors', g_Errors);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Question_Add(p Hashmap) is
    v_Question      Hln_Pref.Question_Rt;
    v_Right_Options Array_Number := Nvl(p.o_Array_Number('right_options'), Array_Number());
    v_Is_Correct    varchar2(1);
    v_Answer_Type   varchar2(50 char);
    v_Option_Val    varchar2(300 char);
    v_Answer_Types  Matrix_Varchar2 := Hln_Util.Answer_Types;
  begin
    Hln_Util.Question_New(o_Question     => v_Question,
                          i_Company_Id   => Ui.Company_Id,
                          i_Filial_Id    => Ui.Filial_Id,
                          i_Question_Id  => Hln_Next.Question_Id,
                          i_Name         => p.r_Varchar2('question_name'),
                          i_Answer_Type  => null,
                          i_Code         => p.o_Varchar2('code'),
                          i_State        => 'A',
                          i_Writing_Hint => null,
                          i_Files        => Array_Varchar2());
  
    v_Answer_Type := p.r_Varchar2('answer_type');
  
    v_Question.Answer_Type := case v_Answer_Type
                                when Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Single) then
                                 Hln_Pref.c_Answer_Type_Single --
                                when Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Multiple) then
                                 Hln_Pref.c_Answer_Type_Multiple --
                                when Hln_Util.t_Answer_Type(Hln_Pref.c_Answer_Type_Writing) then
                                 Hln_Pref.c_Answer_Type_Writing --
                                else
                                 null --
                              end;
  
    if v_Question.Answer_Type is null then
      b.Raise_Error(t('question_import: answer type {answer_type $1} must be in ($2, $3, $4)',
                      v_Answer_Type,
                      v_Answer_Types(2) (1),
                      v_Answer_Types(2) (2),
                      v_Answer_Types(2) (3)));
    elsif v_Answer_Type = Hln_Pref.c_Answer_Type_Writing then
      v_Question.Writing_Hint := p.o_Varchar2('writing_hint');
    end if;
  
    if v_Answer_Type <> Hln_Pref.c_Answer_Type_Writing then
      for i in 1 .. g_Option_Count
      loop
        v_Option_Val := p.o_Varchar2(c_Option || i);
      
        exit when v_Option_Val is null;
      
        if Fazo.Contains(v_Right_Options, i) then
          v_Is_Correct := 'Y';
        else
          v_Is_Correct := 'N';
        end if;
      
        Hln_Util.Question_Add_Option(p_Question           => v_Question,
                                     i_Question_Option_Id => Hln_Next.Question_Option_Id,
                                     i_Name               => v_Option_Val,
                                     i_File_Sha           => null,
                                     i_Is_Correct         => v_Is_Correct,
                                     i_Order_No           => i);
      end loop;
    end if;
  
    for i in 1 .. g_Question_Groups.Count
    loop
      continue when g_Question_Groups(i)(c_Qg_Required_Index) = 'N' and p.o_Varchar2(c_Group || i) is null;
    
      Hln_Util.Question_Add_Group_Bind(p_Question          => v_Question,
                                       i_Question_Group_Id => g_Question_Groups(i) (1),
                                       i_Question_Type_Id  => Hln_Util.Question_Type_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                                                                i_Filial_Id  => Ui.Filial_Id,
                                                                                                i_Name       => p.r_Varchar2(c_Group || i)));
    end loop;
  
    Hln_Api.Question_Save(v_Question);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      Question_Add(Treat(v_List.r_Hashmap(i) as Hashmap));
    end loop;
  end;

end Ui_Vhr243;
/
