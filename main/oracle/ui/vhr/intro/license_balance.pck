create or replace package Ui_Vhr274 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Holders(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Day_Stats_Piechart(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Day_Stats_Xychart(p Hashmap) return Arraylist;
end Ui_Vhr274;
/
create or replace package body Ui_Vhr274 is
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
    return b.Translate('UI-VHR274:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_ranks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('rank_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Holders(p Hashmap) return Fazo_Query is
    v_Query        varchar2(32767);
    v_Params       Hashmap := Hashmap();
    v_Division_Ids Array_Varchar2;
    v_Job_Ids      Array_Varchar2;
    v_Rank_Ids     Array_Varchar2;
    v_Matrix       Matrix_Varchar2;
    q              Fazo_Query;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('license_code', Hlic_Pref.c_License_Code_Hrm_Base);
    v_Params.Put('license_date', p.r_Date('date'));
  
    v_Query := 'select w.*, 
                       f.tin,
                       f.cea,
                       f.main_phone,
                       f.web,
                       f.fax,
                       f.telegram,
                       f.post_address,
                       f.address,
                       f.legal_address,
                       f.region_id,
                       g.email,
                       g.photo_sha,
                       m.iapa,
                       m.npin,
                       e.employee_number,
                       e.division_id,
                       e.job_id,
                       e.rank_id,
                       (select s.name
                          from mkcs_bank_accounts s 
                         where s.company_id = :company_id
                           and s.person_id = w.person_id
                           and s.is_main = ''Y'') bank_account_name,
                       (select s.login
                          from md_users s 
                         where s.company_id = :company_id
                           and s.user_id = w.person_id) login,
                       lh.licensed
                  from mr_natural_persons w
                  join md_persons g
                    on g.company_id = :company_id
                   and g.person_id  = w.person_id
                  left join mr_person_details f 
                    on f.company_id = :company_id
                   and f.person_id = w.person_id
                  left join href_person_details m
                    on m.company_id = :company_id
                   and m.person_id = w.person_id
                   join kl_license_holders lh
                     on lh.company_id = :company_id
                    and lh.license_code = :license_code
                    and lh.hold_date = :license_date
                    and lh.holder_id = w.person_id';
  
    if Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' left join mhr_employees e
                     on e.employee_id = null';
    else
      v_Query := v_Query || --
                 ' join mhr_employees e
                     on e.company_id = :company_id
                    and e.filial_id = :filial_id
                    and e.employee_id = w.person_id
                    and e.state = ''A''
                    and exists (select 1 
                           from mrf_persons fp
                          where fp.company_id = :company_id
                            and fp.filial_id = :filial_id
                            and fp.person_id = e.employee_id
                            and fp.state = ''A'')';
    
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Division_Ids := Nvl(p.o_Array_Varchar2('division_id'), Array_Varchar2());
      v_Job_Ids      := Nvl(p.o_Array_Varchar2('job_id'), Array_Varchar2());
      v_Rank_Ids     := Nvl(p.o_Array_Varchar2('rank_id'), Array_Varchar2());
    
      if v_Division_Ids.Count > 0 then
        v_Query := v_Query || --
                   ' and to_char(e.division_id) in (select * from table(:division_ids))';
      
        v_Params.Put('division_ids', v_Division_Ids);
      end if;
    
      if v_Job_Ids.Count > 0 then
        v_Query := v_Query || --
                   ' and to_char(e.job_id) in (select * from table(:job_ids))';
      
        v_Params.Put('job_ids', v_Job_Ids);
      end if;
    
      if v_Rank_Ids.Count > 0 then
        v_Query := v_Query || --
                   ' and to_char(e.rank_id) in (select * from table(:rank_ids))';
      
        v_Params.Put('rank_ids', v_Rank_Ids);
      end if;
    end if;
  
    v_Query := v_Query || ' where w.company_id = :company_id 
                              and w.state = ''A''';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('person_id',
                   'responsible_person_id',
                   'region_id',
                   'division_id',
                   'job_id',
                   'rank_id');
    q.Varchar2_Field('name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'code',
                     'photo_sha',
                     'address',
                     'tin',
                     'cea');
    q.Varchar2_Field('main_phone',
                     'email',
                     'web',
                     'fax',
                     'telegram',
                     'post_address',
                     'bank_account_name',
                     'login',
                     'iapa',
                     'npin');
    q.Varchar2_Field('employee_number', 'licensed');
    q.Date_Field('hiring_date', 'birthday');
  
    v_Matrix := Md_Util.Person_Genders;
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
    q.Option_Field('licensed_name',
                   'licensed',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Query := 'select * 
                  from mr_natural_persons s
                 where s.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                         from mhr_employees f
                        where f.company_id = :company_id
                          and f.filial_id = :filial_id
                          and f.employee_id = s.person_id)';
    end if;
  
    q.Refer_Field('responsible_person_name',
                  'responsible_person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  v_Query);
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select * 
                     from md_regions
                    where company_id = :company_id');
  
    if not Ui.Is_Filial_Head then
      q.Refer_Field('division_name',
                    'division_id',
                    Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                    'division_id',
                    'name',
                    Uit_Hrm.Departments_Query);
      q.Refer_Field('job_name',
                    'job_id',
                    'mhr_jobs',
                    'job_id',
                    'name',
                    'select * 
                       from mhr_jobs s
                      where s.company_id = :company_id
                        and s.filial_id = :filial_id');
      q.Refer_Field('rank_name',
                    'rank_id',
                    'mhr_ranks',
                    'rank_id',
                    'name',
                    'select * 
                       from mhr_ranks s
                      where s.company_id = :company_id
                        and s.filial_id = :filial_id');
    else
      q.Map_Field('division_name', 'null');
      q.Map_Field('job_name', 'null');
      q.Map_Field('rank_name', 'null');
    
      q.Grid_Column_Label('employee_number', '');
      q.Grid_Column_Label('division_name', '');
      q.Grid_Column_Label('job_name', '');
      q.Grid_Column_Label('rank_name', '');
    end if;
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    Result.Put('begin_date', Trunc(sysdate, 'mon'));
    Result.Put('end_date', Last_Day(sysdate));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Day_Stats_Piechart(p Hashmap) return Hashmap is
    v_Date         date := Trunc(p.r_Date('date'));
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Division_Cnt number := v_Division_Ids.Count;
    v_Job_Ids      Array_Number := Nvl(p.o_Array_Number('job_id'), Array_Number());
    v_Job_Cnt      number := v_Job_Ids.Count;
    v_Rank_Ids     Array_Number := Nvl(p.o_Array_Number('rank_id'), Array_Number());
    v_Rank_Cnt     number := v_Rank_Ids.Count;
  
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Filial_Head number := Ui.Filial_Head;
    v_Available   number;
    v_Free        number;
    v_Used        number;
    v_Required    number;
  begin
    select Nvl(Lb.Available_Amount, 0),
           Nvl(Lb.Available_Amount - Lb.Used_Amount, 0),
           count(Decode(Lh.Licensed, 'Y', 1, null)) as Used,
           count(Decode(Lh.Licensed, 'N', 1, null)) as Required
      into v_Available, v_Free, v_Used, v_Required
      from Dual
      left join Kl_License_Balances Lb
        on Lb.Company_Id = v_Company_Id
       and Lb.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
       and Lb.Balance_Date = v_Date
      left join Kl_License_Holders Lh
        on Lh.Company_Id = v_Company_Id
       and Lh.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
       and Lh.Hold_Date = v_Date
       and (v_Filial_Head = v_Filial_Id or exists
            (select 1
               from Mhr_Employees e
              where e.Company_Id = v_Company_Id
                and e.Filial_Id = v_Filial_Id
                and e.Employee_Id = Lh.Holder_Id
                and e.State = 'A'
                and exists (select 1
                       from Mrf_Persons Fp
                      where Fp.Company_Id = v_Company_Id
                        and Fp.Filial_Id = v_Filial_Id
                        and Fp.Person_Id = e.Employee_Id
                        and Fp.State = 'A')
                and (v_Division_Cnt = 0 or
                    e.Division_Id in (select *
                                         from table(v_Division_Ids)))
                and (v_Job_Cnt = 0 or
                    e.Job_Id in (select *
                                    from table(v_Job_Ids)))
                and (v_Rank_Cnt = 0 or
                    e.Rank_Id in (select *
                                     from table(v_Rank_Ids)))))
     group by Lb.Available_Amount, Lb.Used_Amount;
  
    return Fazo.Zip_Map('available_cnt',
                        v_Available,
                        'free_cnt',
                        v_Free,
                        'used_cnt',
                        v_Used,
                        'required_cnt',
                        v_Required);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Day_Stats_Xychart(p Hashmap) return Arraylist is
    v_Begin_Date   date := p.r_Date('begin_date');
    v_End_Date     date := p.r_Date('end_date');
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Division_Cnt number := v_Division_Ids.Count;
    v_Job_Ids      Array_Number := Nvl(p.o_Array_Number('job_id'), Array_Number());
    v_Job_Cnt      number := v_Job_Ids.Count;
    v_Rank_Ids     Array_Number := Nvl(p.o_Array_Number('rank_id'), Array_Number());
    v_Rank_Cnt     number := v_Rank_Ids.Count;
  
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Filial_Head number := Ui.Filial_Head;
    result        Matrix_Varchar2;
  begin
    select Array_Varchar2(Lb.Balance_Date,
                          Lb.Available_Amount,
                          count(Lh.Licensed),
                          count(Decode(Lh.Licensed, 'Y', 1, null)),
                          count(Decode(Lh.Licensed, 'N', 1, null)))
      bulk collect
      into result
      from Kl_License_Balances Lb
      left join Kl_License_Holders Lh
        on Lh.Company_Id = v_Company_Id
       and Lh.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
       and Lh.Hold_Date = Lb.Balance_Date
       and (v_Filial_Head = v_Filial_Id or exists
            (select 1
               from Mhr_Employees e
              where e.Company_Id = v_Company_Id
                and e.Filial_Id = v_Filial_Id
                and e.Employee_Id = Lh.Holder_Id
                and e.State = 'A'
                and exists (select 1
                       from Mrf_Persons Fp
                      where Fp.Company_Id = v_Company_Id
                        and Fp.Filial_Id = v_Filial_Id
                        and Fp.Person_Id = e.Employee_Id
                        and Fp.State = 'A')
                and (v_Division_Cnt = 0 or
                    e.Division_Id in (select *
                                         from table(v_Division_Ids)))
                and (v_Job_Cnt = 0 or
                    e.Job_Id in (select *
                                    from table(v_Job_Ids)))
                and (v_Rank_Cnt = 0 or
                    e.Rank_Id in (select *
                                     from table(v_Rank_Ids)))))
     where Lb.Company_Id = v_Company_Id
       and Lb.License_Code = Hlic_Pref.c_License_Code_Hrm_Base
       and Lb.Balance_Date between v_Begin_Date and v_End_Date
     group by Lb.Balance_Date, Lb.Available_Amount;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Mr_Natural_Persons
       set Company_Id            = null,
           Person_Id             = null,
           name                  = null,
           First_Name            = null,
           Last_Name             = null,
           Middle_Name           = null,
           Gender                = null,
           Birthday              = null,
           Responsible_Person_Id = null,
           State                 = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           Email      = null,
           Photo_Sha  = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Tin           = null,
           Cea           = null,
           Main_Phone    = null,
           Web           = null,
           Fax           = null,
           Telegram      = null,
           Post_Address  = null,
           Address       = null,
           Address_Guide = null,
           Legal_Address = null,
           Region_Id     = null;
    update Mkcs_Bank_Accounts
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Is_Main    = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           Login      = null;
    update Kl_License_Holders
       set Company_Id   = null,
           License_Code = null,
           Hold_Date    = null,
           Holder_Id    = null,
           Licensed     = null;
    update Mhr_Employees
       set Company_Id      = null,
           Filial_Id       = null,
           Employee_Id     = null,
           Employee_Number = null,
           Division_Id     = null,
           Job_Id          = null,
           Rank_Id         = null,
           State           = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null,
           State      = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
  end;

end Ui_Vhr274;
/
