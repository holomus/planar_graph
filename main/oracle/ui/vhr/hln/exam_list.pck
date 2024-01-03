create or replace package Ui_Vhr215 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr215;
/
create or replace package body Ui_Vhr215 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
  begin
    q := Fazo_Query('hln_exams',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('exam_id',
                   'duration',
                   'question_count',
                   'passing_score',
                   'passing_percentage',
                   'created_by',
                   'modified_by');
    q.Date_Field('created_on', 'modified_on');
    q.Varchar2_Field('name',
                     'pick_kind',
                     'state',
                     'randomize_questions',
                     'randomize_options',
                     'for_recruitment');
  
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
  
    v_Matrix := Hln_Util.Pick_Kinds;
  
    q.Option_Field('pick_kind_name', 'pick_kind', v_Matrix(1), v_Matrix(2));
    q.Option_Field('randomize_questions_name',
                   'randomize_questions',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('randomize_options_name',
                   'randomize_options',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('for_recruitment_name',
                   'for_recruitment',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Exam_Ids Array_Number := Fazo.Sort(p.r_Array_Number('exam_id'));
  begin
    for i in 1 .. v_Exam_Ids.Count
    loop
      Hln_Api.Exam_Delete(i_Company_Id => Ui.Company_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Exam_Id    => v_Exam_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hln_Exams
       set Company_Id          = null,
           Filial_Id           = null,
           Exam_Id             = null,
           name                = null,
           Pick_Kind           = null,
           Duration            = null,
           Question_Count      = null,
           Passing_Score       = null,
           Passing_Percentage  = null,
           Randomize_Questions = null,
           Randomize_Options   = null,
           For_Recruitment     = null,
           State               = null,
           Created_On          = null,
           Modified_On         = null,
           Created_By          = null,
           Modified_By         = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr215;
/
