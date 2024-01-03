create or replace package Ui_Vhr244 is
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
end Ui_Vhr244;
/
create or replace package body Ui_Vhr244 is
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
    q.Varchar2_Field('name');
  
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
    r_Attestation    Hln_Attestations%rowtype;
    v_Attestation_Id number := p.r_Number('attestation_id');
    v_Matrix         Matrix_Varchar2;
    result           Hashmap;
  begin
    r_Attestation := z_Hln_Attestations.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Attestation_Id => v_Attestation_Id);
  
    result := z_Hln_Attestations.To_Map(r_Attestation,
                                        z.Attestation_Id,
                                        z.Name,
                                        z.Attestation_Number,
                                        z.Attestation_Date,
                                        z.Examiner_Id,
                                        z.Note);
  
    Result.Put('begin_time_period_begin',
               to_char(r_Attestation.Begin_Time_Period_Begin, Href_Pref.c_Time_Format_Minute));
    Result.Put('begin_time_period_end',
               to_char(r_Attestation.Begin_Time_Period_End, Href_Pref.c_Time_Format_Minute));
    Result.Put('examiner_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Attestation.Company_Id, --
               i_Person_Id => r_Attestation.Examiner_Id).Name);
  
    select Array_Varchar2(t.Testing_Id,
                          t.Person_Id,
                          (select n.Name
                             from Mr_Natural_Persons n
                            where n.Company_Id = t.Company_Id
                              and n.Person_Id = t.Person_Id),
                          t.Exam_Id,
                          (select e.Name
                             from Hln_Exams e
                            where e.Company_Id = t.Company_Id
                              and e.Filial_Id = t.Filial_Id
                              and e.Exam_Id = t.Exam_Id))
      bulk collect
      into v_Matrix
      from Hln_Testings t
     where t.Company_Id = r_Attestation.Company_Id
       and t.Filial_Id = r_Attestation.Filial_Id
       and exists (select 1
              from Hln_Attestation_Testings At
             where At.Company_Id = t.Company_Id
               and At.Filial_Id = t.Filial_Id
               and At.Attestation_Id = r_Attestation.Attestation_Id
               and At.Testing_Id = t.Testing_Id);
  
    Result.Put('testings', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('is_period',
               Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p                Hashmap,
    i_Attestation_Id number
  ) is
    v_Attestation Hln_Pref.Attestation_Rt;
    v_Testing_Id  number;
    v_Data        Hashmap;
    v_Arraylist   Arraylist;
  begin
    Hln_Util.Attestation_New(o_Attestation             => v_Attestation,
                             i_Company_Id              => Ui.Company_Id,
                             i_Filial_Id               => Ui.Filial_Id,
                             i_Attestation_Id          => i_Attestation_Id,
                             i_Attestation_Number      => p.o_Varchar2('attestation_number'),
                             i_Name                    => p.o_Varchar2('name'),
                             i_Attestation_Date        => p.r_Date('attestation_date'),
                             i_Begin_Time_Period_Begin => null,
                             i_Begin_Time_Period_End   => null,
                             i_Examiner_Id             => p.r_Number('examiner_id'),
                             i_Note                    => p.o_Varchar2('note'));
  
    v_Attestation.Begin_Time_Period_Begin := v_Attestation.Attestation_Date +
                                             Numtodsinterval(p.o_Number('begin_time_period_begin'),
                                                             'minute');
    v_Attestation.Begin_Time_Period_End   := v_Attestation.Attestation_Date +
                                             Numtodsinterval(p.o_Number('begin_time_period_end'),
                                                             'minute');
  
    v_Arraylist := Nvl(p.o_Arraylist('testings'), Arraylist());
  
    for i in 1 .. v_Arraylist.Count
    loop
      v_Data       := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      v_Testing_Id := v_Data.o_Number('testing_id');
    
      if v_Testing_Id is null then
        v_Testing_Id := Hln_Next.Testing_Id;
      end if;
    
      Hln_Util.Attestation_Add_Testing(p_Attestation => v_Attestation,
                                       i_Testing_Id  => v_Testing_Id,
                                       i_Person_Id   => v_Data.r_Number('person_id'),
                                       i_Exam_Id     => v_Data.r_Number('exam_id'));
    end loop;
  
    Hln_Api.Attestation_Save(i_Attestation => v_Attestation, i_User_Id => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Add(p Hashmap) is
  begin
    save(p, Hln_Next.Attestation_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap) is
    v_Attestation_Id number := p.r_Number('attestation_id');
  begin
    z_Hln_Attestations.Lock_Only(i_Company_Id     => Ui.Company_Id,
                                 i_Filial_Id      => Ui.Filial_Id,
                                 i_Attestation_Id => v_Attestation_Id);
  
    save(p, v_Attestation_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Hln_Exams
       set Company_Id = null,
           Filial_Id  = null,
           Exam_Id    = null,
           name       = null,
           State      = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
  end;

end Ui_Vhr244;
/
