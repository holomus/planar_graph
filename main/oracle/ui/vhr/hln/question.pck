create or replace package Ui_Vhr213 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Question_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr213;
/
create or replace package body Ui_Vhr213 is
  ----------------------------------------------------------------------------------------------------
  Function References(i_Question_Id number := null) return Hashmap is
    v_Matrix Matrix_Varchar2 := Matrix_Varchar2();
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Question_Group_Id, q.Name, q.Is_Required, q.Order_No, q.State)
      bulk collect
      into v_Matrix
      from Hln_Question_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and (q.State = 'A' or exists
            (select 1
               from Hln_Question_Group_Binds w
              where w.Company_Id = q.Company_Id
                and w.Filial_Id = q.Filial_Id
                and w.Question_Id = i_Question_Id
                and w.Question_Group_Id = q.Question_Group_Id))
     order by q.State, q.Order_No;
  
    Result.Put('question_groups', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('answer_types', Fazo.Zip_Matrix_Transposed(Hln_Util.Answer_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Question_Types(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_question_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'question_group_id',
                                 p.r_Number('question_group_id'),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('question_type_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('answer_type', Hln_Pref.c_Answer_Type_Single);
    Result.Put('state', 'A');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Question Hln_Questions%rowtype;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap;
  begin
    r_Question := z_Hln_Questions.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Question_Id => p.r_Number('question_id'));
  
    result := z_Hln_Questions.To_Map(r_Question,
                                     z.Question_Id,
                                     z.Name,
                                     z.Answer_Type,
                                     z.Code,
                                     z.State,
                                     z.Writing_Hint);
  
    select Array_Varchar2(q.Question_Option_Id,
                          q.Name,
                          q.File_Sha,
                          (select w.File_Name
                             from Biruni_Files w
                            where w.Sha = q.File_Sha),
                          q.Question_Id,
                          q.Is_Correct,
                          q.Order_No)
      bulk collect
      into v_Matrix
      from Hln_Question_Options q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Question_Id = r_Question.Question_Id
     order by q.Order_No;
  
    Result.Put('options', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.File_Sha,
                          (select w.File_Name
                             from Biruni_Files w
                            where w.Sha = q.File_Sha))
      bulk collect
      into v_Matrix
      from Hln_Question_Files q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Question_Id = r_Question.Question_Id
     order by q.Order_No;
  
    Result.Put('photos', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(y.Question_Group_Id,
                          y.Question_Type_Id,
                          (select w.Name
                             from Hln_Question_Types w
                            where w.Company_Id = y.Company_Id
                              and w.Filial_Id = y.Filial_Id
                              and w.Question_Group_Id = y.Question_Group_Id
                              and w.Question_Type_Id = y.Question_Type_Id))
      bulk collect
      into v_Matrix
      from Hln_Question_Group_Binds y
     where y.Company_Id = Ui.Company_Id
       and y.Filial_Id = Ui.Filial_Id
       and y.Question_Id = r_Question.Question_Id;
  
    Result.Put('question_types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('references', References(r_Question.Question_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p             Hashmap,
    i_Question_Id number
  ) return Hashmap is
    v_Arraylist Arraylist;
    v_Data      Hashmap;
    v_Option_Id number;
    v_Question  Hln_Pref.Question_Rt;
  begin
    Hln_Util.Question_New(o_Question     => v_Question,
                          i_Company_Id   => Ui.Company_Id,
                          i_Filial_Id    => Ui.Filial_Id,
                          i_Question_Id  => i_Question_Id,
                          i_Name         => p.r_Varchar2('name'),
                          i_Answer_Type  => p.r_Varchar2('answer_type'),
                          i_Code         => p.o_Varchar2('code'),
                          i_State        => p.r_Varchar2('state'),
                          i_Writing_Hint => p.o_Varchar2('writing_hint'),
                          i_Files        => p.o_Array_Varchar2('photos'));
  
    v_Arraylist := Nvl(p.o_Arraylist('question_groups'), Arraylist());
  
    for i in 1 .. v_Arraylist.Count
    loop
      v_Data := Treat(v_Arraylist.o_Hashmap(i) as Hashmap);
    
      Hln_Util.Question_Add_Group_Bind(p_Question          => v_Question,
                                       i_Question_Group_Id => v_Data.o_Number('question_group_id'),
                                       i_Question_Type_Id  => v_Data.o_Number('question_type_id'));
    end loop;
  
    v_Arraylist := Nvl(p.o_Arraylist('options'), Arraylist());
  
    for i in 1 .. v_Arraylist.Count
    loop
      v_Data      := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      v_Option_Id := v_Data.o_Number('question_option_id');
    
      if v_Option_Id is null then
        v_Option_Id := Hln_Next.Question_Option_Id;
      end if;
    
      Hln_Util.Question_Add_Option(p_Question           => v_Question,
                                   i_Question_Option_Id => v_Option_Id,
                                   i_Name               => v_Data.r_Varchar2('name'),
                                   i_File_Sha           => v_Data.o_Varchar2('photo_sha'),
                                   i_Is_Correct         => v_Data.r_Varchar2('is_correct'),
                                   i_Order_No           => v_Data.r_Number('order_no'));
    end loop;
  
    Hln_Api.Question_Save(v_Question);
  
    return Fazo.Zip_Map('question_id', i_Question_Id, 'name', v_Question.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hln_Next.Question_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Question_Id number := p.r_Number('question_id');
  begin
    z_Hln_Questions.Lock_Only(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Question_Id => v_Question_Id);
  
    return save(p, v_Question_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Question_Types
       set Company_Id        = null,
           Filial_Id         = null,
           Question_Group_Id = null,
           Question_Type_Id  = null,
           name              = null;
  end;

end Ui_Vhr213;
/
