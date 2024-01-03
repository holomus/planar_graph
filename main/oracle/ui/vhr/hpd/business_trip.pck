create or replace package Ui_Vhr180 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Legal_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Business_Trip_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Trip_Days(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr180;
/
create or replace package body Ui_Vhr180 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Legal_Persons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mr_legal_persons',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Business_Trip_Reasons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_business_trip_reasons',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('reason_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select * 
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.state = ''A''';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))
                              and s.employee_id <> :user_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'staff_kind', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Region_Id, q.Name, q.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions q
     where q.Company_Id = Ui.Company_Id
       and q.State = 'A';
  
    Result.Put('user_id', Ui.User_Id);
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
    Result.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Business_Trip));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => Ui.Company_Id,
                                             i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_type_id',
                           v_Journal_Type_Id,
                           'journal_date',
                           Trunc(sysdate),
                           'begin_date',
                           Trunc(sysdate),
                           'end_date',
                           Trunc(sysdate));
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('references', References);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Trips
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Arraylist is
    v_Trips  Arraylist := Arraylist();
    v_Matrix Matrix_Varchar2;
    v_Trip   Hashmap;
  begin
    for r in (select q.Timeoff_Id, --
                     q.Staff_Id,
                     (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = q.Company_Id
                         and Np.Person_Id = (select St.Employee_Id
                                               from Href_Staffs St
                                              where St.Company_Id = q.Company_Id
                                                and St.Filial_Id = q.Filial_Id
                                                and St.Staff_Id = q.Staff_Id)) Staff_Name,
                     w.Person_Id,
                     (select Lp.Name
                        from Mr_Legal_Persons Lp
                       where Lp.Company_Id = w.Company_Id
                         and Lp.Person_Id = w.Person_Id) Person_Name,
                     w.Reason_Id,
                     (select r.Name
                        from Href_Business_Trip_Reasons r
                       where r.Company_Id = w.Company_Id
                         and r.Filial_Id = w.Filial_Id
                         and r.Reason_Id = w.Reason_Id) Reason_Name,
                     q.Begin_Date,
                     q.End_Date,
                     w.Note
                from Hpd_Journal_Timeoffs q
                join Hpd_Business_Trips w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Timeoff_Id = q.Timeoff_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Journal_Id = i_Journal_Id)
    loop
      v_Trip := Fazo.Zip_Map('timeoff_id',
                             r.Timeoff_Id,
                             'staff_id',
                             r.Staff_Id,
                             'staff_name',
                             r.Staff_Name,
                             'person_id',
                             r.Person_Id,
                             'person_name',
                             r.Person_Name,
                             'reason_id',
                             r.Reason_Id);
    
      v_Trip.Put('reason_name', r.Reason_Name);
      v_Trip.Put('begin_date', r.Begin_Date);
      v_Trip.Put('end_date', r.End_Date);
      v_Trip.Put('note', r.Note);
    
      select Array_Varchar2(d.Region_Id,
                            (select t.Name
                               from Md_Regions t
                              where t.Company_Id = d.Company_Id
                                and t.Region_Id = d.Region_Id))
        bulk collect
        into v_Matrix
        from Hpd_Business_Trip_Regions d
       where d.Company_Id = i_Company_Id
         and d.Filial_Id = i_Filial_Id
         and d.Timeoff_Id = r.Timeoff_Id
       order by d.Order_No;
    
      v_Trip.Put('regions', Fazo.Zip_Matrix(v_Matrix));
    
      select Array_Varchar2(q.Sha,
                            (select s.File_Name
                               from Biruni_Files s
                              where s.Sha = q.Sha))
        bulk collect
        into v_Matrix
        from Hpd_Timeoff_Files q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Timeoff_Id = r.Timeoff_Id;
    
      v_Trip.Put('files', Fazo.Zip_Matrix(v_Matrix));
    
      v_Trips.Push(v_Trip);
    end loop;
  
    return v_Trips;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1);
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Business_Trip_Journal(i_Company_Id      => Ui.Company_Id,
                                             i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null then
      Uit_Hpd.Check_Access_To_Edit_Journal(i_Document_Status => v_Sign_Document_Status,
                                           i_Posted          => r_Journal.Posted,
                                           i_Journal_Number  => r_Journal.Journal_Number);
      v_Has_Sign_Document := 'Y';
    end if;
  
    for r in (select s.Staff_Id
                from Hpd_Journal_Staffs s
               where s.Company_Id = r_Journal.Company_Id
                 and s.Filial_Id = r_Journal.Filial_Id
                 and s.Journal_Id = r_Journal.Journal_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
    end loop;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Type_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name);
  
    Result.Put('business_trips',
               Get_Trips(i_Company_Id => r_Journal.Company_Id,
                         i_Filial_Id  => r_Journal.Filial_Id,
                         i_Journal_Id => r_Journal.Journal_Id));
  
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Trip_Days(p Hashmap) return Hashmap is
    v_Staff_Ids   Array_Number := p.r_Array_Number('staff_ids');
    v_Begin_Dates Array_Date := p.r_Array_Date('begin_dates');
    v_End_Dates   Array_Date := p.r_Array_Date('end_dates');
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Fact_Days   number;
    v_Trip_Days   number;
    v_Matrix      Matrix_Varchar2 := Matrix_Varchar2();
    result        Hashmap := Hashmap();
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Fact_Days := Htt_Util.Calc_Locked_Turnout_Days(i_Company_Id => v_Company_Id,
                                                       i_Filial_Id  => v_Filial_Id,
                                                       i_Staff_Id   => v_Staff_Ids(i),
                                                       i_Begin_Date => v_Begin_Dates(i),
                                                       i_End_Date   => v_End_Dates(i));
    
      v_Trip_Days := v_End_Dates(i) - v_Begin_Dates(i) + 1;
    
      Fazo.Push(v_Matrix,
                Array_Varchar2(Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                                    i_Filial_Id  => v_Filial_Id,
                                                    i_Staff_Id   => v_Staff_Ids(i)),
                               v_Fact_Days,
                               v_Trip_Days - v_Fact_Days));
    end loop;
  
    Result.Put('data', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Journal_Id number,
    p            Hashmap
  ) is
    p_Journal    Hpd_Pref.Business_Trip_Journal_Rt;
    v_Trips      Arraylist := p.r_Arraylist('trips');
    v_Trip       Hashmap;
    v_Timeoff_Id number;
    v_Staff_Id   number;
  begin
    Hpd_Util.Business_Trip_Journal_New(o_Journal         => p_Journal,
                                       i_Company_Id      => Ui.Company_Id,
                                       i_Filial_Id       => Ui.Filial_Id,
                                       i_Journal_Id      => i_Journal_Id,
                                       i_Journal_Type_Id => p.r_Number('journal_type_id'),
                                       i_Journal_Number  => p.o_Varchar2('journal_number'),
                                       i_Journal_Date    => p.r_Date('journal_date'),
                                       i_Journal_Name    => p.o_Varchar2('journal_name'),
                                       i_Lang_Code       => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Trips.Count
    loop
      v_Trip := Treat(v_Trips.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Trip.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Timeoff_Id := v_Trip.o_Number('timeoff_id');
    
      if v_Timeoff_Id is null then
        v_Timeoff_Id := Hpd_Next.Timeoff_Id;
      end if;
    
      Hpd_Util.Journal_Add_Business_Trip(p_Journal    => p_Journal,
                                         i_Timeoff_Id => v_Timeoff_Id,
                                         i_Staff_Id   => v_Staff_Id,
                                         i_Region_Ids => v_Trip.r_Array_Number('region_ids'),
                                         i_Person_Id  => v_Trip.o_Number('person_id'),
                                         i_Reason_Id  => v_Trip.r_Number('reason_id'),
                                         i_Begin_Date => v_Trip.r_Date('begin_date'),
                                         i_End_Date   => v_Trip.r_Date('end_date'),
                                         i_Note       => v_Trip.o_Varchar2('note'),
                                         i_Shas       => Nvl(v_Trip.o_Array_Varchar2('shas'),
                                                             Array_Varchar2()));
    end loop;
  
    Hpd_Api.Business_Trip_Journal_Save(p_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Hpd_Next.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id);
    end if;
  
    save(r_Journal.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mr_Legal_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Href_Business_Trip_Reasons
       set Company_Id = null,
           Filial_Id  = null,
           Reason_Id  = null,
           name       = null,
           State      = null;
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Employee_Id     = null,
           Org_Unit_Id     = null,
           Hiring_Date     = null,
           Dismissal_Date  = null,
           Employment_Type = null,
           Division_Id     = null,
           Staff_Kind      = null,
           State           = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr180;
/
