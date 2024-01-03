create or replace package Ui_Vhr187 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Time_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Vacation_Payment(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Vacation_Days(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr187;
/
create or replace package body Ui_Vhr187 is
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
  Function Query_Time_Kinds return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from htt_time_kinds tk
                      where tk.company_id = :company_id
                        and nvl(tk.parent_id, tk.time_kind_id) = :vacation_tk_id
                        and tk.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'vacation_tk_id',
                                 Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation),
                                 'state',
                                 'A'));
  
    q.Number_Field('time_kind_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    r_Time_Kind      Htt_Time_Kinds%rowtype;
    v_Vacation_Tk_Id number;
    result           Hashmap;
  begin
    v_Vacation_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => Ui.Company_Id,
                                         i_Time_Kind_Id => v_Vacation_Tk_Id);
  
    result := z_Htt_Time_Kinds.To_Map(r_Time_Kind, --
                                      z.Time_Kind_Id,
                                      z.Name,
                                      i_Time_Kind_Id => 'vacation_tk_id',
                                      i_Name         => 'vacation_tk_name');
  
    Result.Put('user_id', Ui.User_Id);
    Result.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Vacation_Journal(i_Company_Id      => Ui.Company_Id,
                                        i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_date',
                           Trunc(sysdate),
                           'journal_type_id',
                           v_Journal_Type_Id,
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
  Function Get_Vacation_Payment(p Hashmap) return Hashmap is
    v_Staff_Ids        Array_Number := p.r_Array_Number('staff_id');
    v_Begin_Dates      Array_Date := p.r_Array_Date('begin_date');
    v_End_Dates        Array_Date := p.r_Array_Date('end_date');
    v_Amount           number;
    v_Oper_Type_Id     number;
    v_Vacation_Payment Matrix_Varchar2 := Matrix_Varchar2();
    result             Hashmap := Hashmap();
  begin
    v_Oper_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => Ui.Company_Id,
                                            i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Vacation);
  
    v_Vacation_Payment.Extend(v_Staff_Ids.Count);
  
    for j in 1 .. v_Staff_Ids.Count
    loop
      v_Amount := Round(Hpr_Util.Calc_Amount(i_Company_Id   => Ui.Company_Id,
                                             i_Filial_Id    => Ui.Filial_Id,
                                             i_Staff_Id     => v_Staff_Ids(j),
                                             i_Oper_Type_Id => v_Oper_Type_Id,
                                             i_Part_Begin   => v_Begin_Dates(j),
                                             i_Part_End     => v_End_Dates(j)),
                        2);
    
      v_Vacation_Payment(j) := Array_Varchar2(v_Staff_Ids(j), Greatest(v_Amount, 0));
    end loop;
  
    Result.Put('vacation_payment', Fazo.Zip_Matrix(v_Vacation_Payment));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Vacation
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Arraylist is
    v_Vacations Arraylist := Arraylist();
    v_Matrix    Matrix_Varchar2;
    v_Vacation  Hashmap;
  begin
    for r in (select q.Timeoff_Id,
                     q.Staff_Id,
                     (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = q.Company_Id
                         and Np.Person_Id = (select St.Employee_Id
                                               from Href_Staffs St
                                              where St.Company_Id = q.Company_Id
                                                and St.Filial_Id = q.Filial_Id
                                                and St.Staff_Id = q.Staff_Id)) Staff_Name,
                     q.Begin_Date,
                     q.End_Date,
                     w.Time_Kind_Id,
                     (select Tk.Name
                        from Htt_Time_Kinds Tk
                       where Tk.Company_Id = w.Company_Id
                         and Tk.Time_Kind_Id = w.Time_Kind_Id) Time_Kind_Name
                from Hpd_Journal_Timeoffs q
                join Hpd_Vacations w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Timeoff_Id = q.Timeoff_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Journal_Id = i_Journal_Id)
    loop
      v_Vacation := Fazo.Zip_Map('timeoff_id',
                                 r.Timeoff_Id,
                                 'staff_id',
                                 r.Staff_Id,
                                 'staff_name',
                                 r.Staff_Name,
                                 'begin_date',
                                 r.Begin_Date,
                                 'end_date',
                                 r.End_Date,
                                 'time_kind_id',
                                 r.Time_Kind_Id);
    
      v_Vacation.Put('time_kind_name', r.Time_Kind_Name);
    
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
    
      v_Vacation.Put('files', Fazo.Zip_Matrix(v_Matrix));
    
      v_Vacations.Push(v_Vacation);
    end loop;
  
    return v_Vacations;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Vacation_Journal(i_Company_Id      => Ui.Company_Id,
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
  
    Result.Put('vacations',
               Get_Vacation(i_Company_Id => r_Journal.Company_Id,
                            i_Filial_Id  => r_Journal.Filial_Id,
                            i_Journal_Id => r_Journal.Journal_Id));
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Vacation_Days(p Hashmap) return Hashmap is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Staff_Ids     Array_Number := p.r_Array_Number('staff_ids');
    v_Begin_Dates   Array_Date := p.r_Array_Date('begin_dates');
    v_End_Dates     Array_Date := p.r_Array_Date('end_dates');
    v_Vacation_Days number;
    v_Fact_Days     number;
    v_Matrix        Matrix_Varchar2 := Matrix_Varchar2();
    result          Hashmap := Hashmap();
  begin
    for r in 1 .. v_Staff_Ids.Count
    loop
      v_Fact_Days := Htt_Util.Calc_Fact_Locked_Vacation_Days(i_Company_Id => Ui.Company_Id,
                                                             i_Filial_Id  => Ui.Filial_Id,
                                                             i_Staff_Id   => v_Staff_Ids(r),
                                                             i_Begin_Date => v_Begin_Dates(r),
                                                             i_End_Date   => v_End_Dates(r));
    
      v_Vacation_Days := Htt_Util.Calc_Vacation_Days(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Staff_Id   => v_Staff_Ids(r),
                                                     i_Begin_Date => v_Begin_Dates(r),
                                                     i_End_Date   => v_End_Dates(r));
    
      Fazo.Push(v_Matrix,
                Array_Varchar2(Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                                    i_Filial_Id  => v_Filial_Id,
                                                    i_Staff_Id   => v_Staff_Ids(r)),
                               v_Fact_Days,
                               v_Vacation_Days));
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
    p_Journal    Hpd_Pref.Vacation_Journal_Rt;
    v_Vacations  Arraylist := p.r_Arraylist('vacations');
    v_Vacation   Hashmap;
    v_Timeoff_Id number;
    v_Staff_Id   number;
  begin
    Hpd_Util.Vacation_Journal_New(o_Journal         => p_Journal,
                                  i_Company_Id      => Ui.Company_Id,
                                  i_Filial_Id       => Ui.Filial_Id,
                                  i_Journal_Id      => i_Journal_Id,
                                  i_Journal_Type_Id => p.r_Number('journal_type_id'),
                                  i_Journal_Number  => p.o_Varchar2('journal_number'),
                                  i_Journal_Date    => p.r_Date('journal_date'),
                                  i_Journal_Name    => p.o_Varchar2('journal_name'),
                                  i_Lang_Code       => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Vacations.Count
    loop
      v_Vacation := Treat(v_Vacations.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Vacation.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Timeoff_Id := v_Vacation.o_Number('timeoff_id');
    
      if v_Timeoff_Id is null then
        v_Timeoff_Id := Hpd_Next.Timeoff_Id;
      end if;
    
      Hpd_Util.Journal_Add_Vacation(p_Journal      => p_Journal,
                                    i_Timeoff_Id   => v_Timeoff_Id,
                                    i_Staff_Id     => v_Staff_Id,
                                    i_Time_Kind_Id => v_Vacation.o_Number('time_kind_id'),
                                    i_Begin_Date   => v_Vacation.r_Date('begin_date'),
                                    i_End_Date     => v_Vacation.r_Date('end_date'),
                                    i_Shas         => Nvl(v_Vacation.o_Array_Varchar2('shas'),
                                                          Array_Varchar2()));
    end loop;
  
    Hpd_Api.Vacation_Journal_Save(p_Journal);
  
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
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Org_Unit_Id     = null,
           Employee_Id     = null,
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
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           Parent_Id    = null,
           State        = null;
  end;

end Ui_Vhr187;
/
