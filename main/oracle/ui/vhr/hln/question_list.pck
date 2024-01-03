create or replace package Ui_Vhr212 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr212;
/
create or replace package body Ui_Vhr212 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Group_Ids   Array_Number;
    v_Group_Names Array_Varchar2;
    v_Query       varchar2(4000);
    v_Params      Hashmap;
    v_Matrix      Matrix_Varchar2;
    q             Fazo_Query;
  begin
    select t.Question_Group_Id, t.Name
      bulk collect
      into v_Group_Ids, v_Group_Names
      from Hln_Question_Groups t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.State = 'A'
     order by t.Order_No;
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select t.*,
                       (select count(*)
                          from hln_question_options op
                         where op.company_id = t.company_id
                           and op.filial_id = t.filial_id
                           and op.question_id = t.question_id) as answers_count,
                         case
                           when exists (select 1
                                   from hln_question_options op
                                  where op.company_id = t.company_id
                                    and op.filial_id = t.filial_id
                                    and op.question_id = t.question_id
                                    and op.file_sha is not null) or 
                                exists (select 1
                                   from hln_question_files qf
                                  where qf.company_id = t.company_id
                                    and qf.filial_id = t.filial_id
                                    and qf.question_id = t.question_id) then
                            ''Y''
                           else
                            ''N'' 
                         end as has_file';
  
    for i in 1 .. 5
    loop
      if i > v_Group_Ids.Count then
        v_Query := v_Query || ',null group_id' || i;
      else
        v_Params.Put('group_id' || i, v_Group_Ids(i));
      end if;
    end loop;
  
    v_Query := v_Query || ' from hln_questions t
                           where t.company_id = :company_id
                             and t.filial_id = :filial_id';
  
    q := Fazo_Query(v_Query, v_Params);
  
    for i in 1 .. 5
    loop
      if i <= v_Group_Ids.Count then
        q.Multi_Number_Field('group_id' || i,
                             '(select *
                                 from hln_question_group_binds hq
                                where hq.company_id = :company_id
                                  and hq.filial_id = :filial_id
                                  and hq.question_group_id = :group_id' || i || ')',
                             '@question_id=$question_id',
                             'question_type_id');
      
        q.Refer_Field('group_name' || i,
                      'group_id' || i,
                      'hln_question_types',
                      'question_type_id',
                      'name',
                      '(select * 
                          from hln_question_types y 
                         where y.company_id = :company_id
                           and y.filial_id = :filial_id
                           and y.question_group_id = :group_id' || i || ')');
      
        q.Grid_Column_Label('group_name' || i, v_Group_Names(i));
      else
        q.Number_Field('group_id' || i);
        q.Map_Field('group_name' || i, 'null');
        q.Grid_Column_Label('group_name' || i, '');
      end if;
    end loop;
  
    q.Number_Field('question_id', 'answers_count', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'answer_type', 'code', 'state', 'writing_hint', 'has_file');
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
  
    v_Matrix := Hln_Util.Answer_Types;
  
    q.Option_Field('answer_type_name', 'answer_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Question_Ids Array_Number := Fazo.Sort(p.r_Array_Number('question_id'));
  begin
    for i in 1 .. v_Question_Ids.Count
    loop
      Hln_Api.Question_Delete(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Question_Id => v_Question_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Questions
       set Company_Id   = null,
           Filial_Id    = null,
           Question_Id  = null,
           name         = null,
           Answer_Type  = null,
           Code         = null,
           State        = null,
           Writing_Hint = null,
           Created_On   = null,
           Created_By   = null,
           Modified_On  = null,
           Modified_By  = null;
    update Hln_Question_Group_Binds
       set Company_Id        = null,
           Filial_Id         = null,
           Question_Id       = null,
           Question_Group_Id = null,
           Question_Type_Id  = null;
    update Hln_Question_Types
       set Company_Id        = null,
           Filial_Id         = null,
           Question_Group_Id = null,
           Question_Type_Id  = null,
           name              = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Hln_Question_Options
       set Company_Id  = null,
           Filial_Id   = null,
           Question_Id = null,
           File_Sha    = null;
    update Hln_Question_Files
       set Company_Id  = null,
           Filial_Id   = null,
           Question_Id = null;
  end;

end Ui_Vhr212;
/
