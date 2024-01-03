create or replace package Ui_Vhr567 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
end Ui_Vhr567;
/
create or replace package body Ui_Vhr567 is
  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('pcode_stage_todo', Hrec_Pref.c_Pcode_Stage_Todo);
    Result.Put('pcode_stage_accepted', Hrec_Pref.c_Pcode_Stage_Accepted);
    Result.Put('pcode_stage_rejected', Hrec_Pref.c_Pcode_Stage_Rejected);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Stages Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Stage_Id, t.Name, t.State, t.Order_No, t.Code, t.Pcode)
      bulk collect
      into v_Stages
      from Hrec_Stages t
     where t.Company_Id = Ui.Company_Id
     order by t.Order_No;
  
    Result.Put('stages', Fazo.Zip_Matrix(v_Stages));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Stage     Hrec_Stages%rowtype;
    v_Stage_Ids Array_Number := Array_Number();
    v_List      Arraylist := p.r_Arraylist('stages');
    v_Data      Hashmap;
  begin
    v_Stage_Ids.Extend(v_List.Count);
  
    for i in 1 .. v_List.Count
    loop
      v_Data := Treat(v_List.r_Hashmap(i) as Hashmap);
    
      r_Stage.Company_Id := Ui.Company_Id;
      r_Stage.Stage_Id   := Coalesce(v_Data.o_Number('stage_id'), Hrec_Next.Stage_Id);
      r_Stage.Name       := v_Data.r_Varchar2('name');
      r_Stage.State      := v_Data.r_Varchar2('state');
      r_Stage.Order_No   := v_Data.r_Number('order_no');
      r_Stage.Code       := v_Data.o_Varchar2('code');
    
      Hrec_Api.Stage_Save(r_Stage);
    
      v_Stage_Ids(i) := r_Stage.Stage_Id;
    end loop;
  
    for r in (select t.Stage_Id
                from Hrec_Stages t
               where t.Company_Id = Ui.Company_Id
                 and t.Stage_Id not member of v_Stage_Ids)
    loop
      Hrec_Api.Stage_Delete(i_Company_Id => Ui.Company_Id, i_Stage_Id => r.Stage_Id);
    end loop;
  end;

end Ui_Vhr567;
/
