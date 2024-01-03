create or replace package Ui_Vhr211 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Del(p Hashmap);
end Ui_Vhr211;
/
create or replace package body Ui_Vhr211 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('group_name',
                        z_Hln_Question_Groups.Load(i_Company_Id => Ui.Company_Id, --
                        i_Filial_Id => Ui.Filial_Id, --
                        i_Question_Group_Id => p.r_Number('question_group_id')).Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_question_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'question_group_id',
                                 p.r_Number('question_group_id')),
                    true);
  
    q.Number_Field('question_type_id', 'order_no', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'code', 'state', 'pcode');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k
                    where k.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k 
                    where k.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Question_Type_Ids Array_Number := Fazo.Sort(p.r_Array_Number('question_type_id'));
  begin
    for i in 1 .. v_Question_Type_Ids.Count
    loop
      Hln_Api.Question_Type_Delete(i_Company_Id       => Ui.Company_Id,
                                   i_Filial_Id        => Ui.Filial_Id,
                                   i_Question_Type_Id => v_Question_Type_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Question_Types
       set Company_Id        = null,
           Filial_Id         = null,
           Question_Group_Id = null,
           Question_Type_Id  = null,
           name              = null,
           Code              = null,
           Order_No          = null,
           State             = null,
           Pcode             = null,
           Created_On        = null,
           Created_By        = null,
           Modified_On       = null,
           Modified_By       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr211;
/
