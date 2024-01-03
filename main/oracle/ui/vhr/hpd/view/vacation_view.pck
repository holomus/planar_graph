create or replace package Ui_Vhr593 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Vacation_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
end Ui_Vhr593;
/
create or replace package body Ui_Vhr593 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Vacation_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_vacations q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and exists (select 1
                              from x_hpd_journal_timeoffs w
                             where w.t_company_id = q.t_company_id
                               and w.t_filial_id = q.t_filial_id 
                               and w.timeoff_id = q.timeoff_id
                               and w.journal_id = :journal_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id', 't_filial_id', 't_user_id', 't_context_id', 'time_kind_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('time_kind_name',
                  'time_kind_id',
                  'htt_time_kinds',
                  'time_kind_id',
                  'name',
                  'select * 
                     from htt_time_kinds q 
                    where q.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Vacation_Payment
  (
    i_Staff_Id   number,
    i_Timeoff_Id number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Posted     varchar2
  ) return number is
    v_Amount       number;
    r_Interval     Hpd_Timeoff_Intervals%rowtype;
    v_Oper_Type_Id number;
  begin
    if i_Posted = 'Y' then
      r_Interval := z_Hpd_Timeoff_Intervals.Load(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Timeoff_Id => i_Timeoff_Id);
    
      select sum(q.Amount)
        into v_Amount
        from Hpr_Charges q
       where q.Company_Id = r_Interval.Company_Id
         and q.Filial_Id = r_Interval.Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Interval_Id = r_Interval.Interval_Id;
    
      return Round(v_Amount, 2);
    end if;
  
    v_Oper_Type_Id := Mpr_Util.Oper_Type_Id(i_Company_Id => Ui.Company_Id,
                                            i_Pcode      => Hpr_Pref.c_Pcode_Oper_Type_Vacation);
  
    return Greatest(Round(Hpr_Util.Calc_Amount(i_Company_Id   => Ui.Company_Id,
                                               i_Filial_Id    => Ui.Filial_Id,
                                               i_Staff_Id     => i_Staff_Id,
                                               i_Oper_Type_Id => v_Oper_Type_Id,
                                               i_Part_Begin   => i_Begin_Date,
                                               i_Part_End     => i_End_Date),
                          2),
                    0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Vacation
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number,
    i_Posted     varchar2
  ) return Arraylist is
    v_Vacations Arraylist := Arraylist();
    v_Matrix    Matrix_Varchar2;
    v_Vacation  Hashmap;
  begin
    for r in (select q.Timeoff_Id,
                     (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = q.Company_Id
                         and Np.Person_Id = (select St.Employee_Id
                                               from Href_Staffs St
                                              where St.Company_Id = q.Company_Id
                                                and St.Filial_Id = q.Filial_Id
                                                and St.Staff_Id = q.Staff_Id)) Staff_Name,
                     q.Staff_Id,
                     q.Begin_Date,
                     q.End_Date,
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
                                 'staff_name',
                                 r.Staff_Name,
                                 'begin_date',
                                 r.Begin_Date,
                                 'end_date',
                                 r.End_Date);
    
      v_Vacation.Put('time_kind_name', r.Time_Kind_Name);
      v_Vacation.Put('vacation_payment',
                     Get_Vacation_Payment(i_Staff_Id   => r.Staff_Id,
                                          i_Timeoff_Id => r.Timeoff_Id,
                                          i_Begin_Date => r.Begin_Date,
                                          i_End_Date   => r.End_Date,
                                          i_Posted     => i_Posted));
    
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
  Function Model(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    result    Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Vacation_Journal(i_Company_Id      => Ui.Company_Id,
                                        i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    if not Uit_Hpd.Access_To_Journal_Sign_Document(r_Journal.Journal_Id) then
      for r in (select s.Staff_Id
                  from Hpd_Journal_Staffs s
                 where s.Company_Id = r_Journal.Company_Id
                   and s.Filial_Id = r_Journal.Filial_Id
                   and s.Journal_Id = r_Journal.Journal_Id)
      loop
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
      end loop;
    end if;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Type_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Sign_Document_Id,
                                    z.Posted,
                                    z.Created_On,
                                    z.Modified_On);
  
    Result.Put('sign_document_status',
               Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                  i_Document_Id => r_Journal.Sign_Document_Id));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Journal.Company_Id, i_User_Id => r_Journal.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Journal.Company_Id, i_User_Id => r_Journal.Modified_By).Name);
  
    Result.Put('vacations',
               Get_Vacation(i_Company_Id => r_Journal.Company_Id,
                            i_Filial_Id  => r_Journal.Filial_Id,
                            i_Journal_Id => r_Journal.Journal_Id,
                            i_Posted     => r_Journal.Posted));
    Result.Put('vacation_journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => r_Journal.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
  begin
    Hpd_Api.Journal_Post(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Journal_Id => p.r_Number('journal_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => p.r_Number('journal_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Vacations
       set t_Company_Id          = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Timeoff_Id            = null,
           Time_Kind_Id          = null;
    update x_Hpd_Journal_Timeoffs
       set t_Company_Id = null,
           t_Filial_Id  = null,
           Journal_Id   = null,
           Timeoff_Id   = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           name         = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr593;
/
