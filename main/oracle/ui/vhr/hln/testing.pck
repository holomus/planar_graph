create or replace package Ui_Vhr225 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Exams return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr225;
/
create or replace package body Ui_Vhr225 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mr_natural_persons q
                      where q.company_id = :company_id
                        and q.state = ''A''
                        and exists (select 1 
                               from mrf_persons f
                              where f.company_id = q.company_id
                                and f.filial_id = :filial_id
                                and f.person_id = q.person_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Exams return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_exams',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('exam_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('is_period',
                        Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => Ui.Company_Id,
                                                                    i_Filial_Id  => Ui.Filial_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Testing Hln_Testings%rowtype;
    result    Hashmap;
  begin
    r_Testing := z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Testing_Id => p.r_Number('testing_id'));
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_New then
      b.Raise_Unauthorized;
    end if;
  
    result := z_Hln_Testings.To_Map(r_Testing,
                                    z.Testing_Id,
                                    z.Exam_Id,
                                    z.Person_Id,
                                    z.Examiner_Id,
                                    z.Testing_Number,
                                    z.Testing_Date,
                                    z.Note);
  
    Result.Put('begin_time_period_begin',
               to_char(r_Testing.Begin_Time_Period_Begin, Href_Pref.c_Time_Format_Minute));
    Result.Put('begin_time_period_end',
               to_char(r_Testing.Begin_Time_Period_End, Href_Pref.c_Time_Format_Minute));
    Result.Put('person_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Testing.Company_Id, --
               i_Person_Id => r_Testing.Person_Id).Name);
    Result.Put('examiner_name',
               z_Mr_Natural_Persons.Take(i_Company_Id => r_Testing.Company_Id, --
               i_Person_Id => r_Testing.Examiner_Id).Name);
    Result.Put('exam_name',
               z_Hln_Exams.Load(i_Company_Id => r_Testing.Company_Id, --
               i_Filial_Id => Ui.Filial_Id, --
               i_Exam_Id => r_Testing.Exam_Id).Name);
    Result.Put('is_period',
               Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p            Hashmap,
    i_Testing_Id number
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    r_Testing := z_Hln_Testings.To_Row(p, --
                                       z.Exam_Id,
                                       z.Person_Id,
                                       z.Examiner_Id,
                                       z.Testing_Number,
                                       z.Testing_Date,
                                       z.Note);
  
    r_Testing.Company_Id              := Ui.Company_Id;
    r_Testing.Filial_Id               := Ui.Filial_Id;
    r_Testing.Testing_Id              := i_Testing_Id;
    r_Testing.Begin_Time_Period_Begin := r_Testing.Testing_Date +
                                         Numtodsinterval(p.o_Number('begin_time_period_begin'),
                                                         'minute');
    r_Testing.Begin_Time_Period_End   := r_Testing.Testing_Date +
                                         Numtodsinterval(p.o_Number('begin_time_period_end'),
                                                         'minute');
  
    Hln_Api.Testing_Save(i_Testing => r_Testing, i_User_Id => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Add(p Hashmap) is
  begin
    save(p, Hln_Next.Testing_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap) is
    v_Testing_Id number := p.r_Number('testing_id');
  begin
    z_Hln_Testings.Lock_Only(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Testing_Id => v_Testing_Id);
  
    save(p, v_Testing_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           State      = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
    update Hln_Exams
       set Company_Id = null,
           Filial_Id  = null,
           Exam_Id    = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr225;
/
