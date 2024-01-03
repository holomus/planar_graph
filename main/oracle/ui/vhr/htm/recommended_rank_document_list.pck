create or replace package Ui_Vhr549 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Set_Training(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Training(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr549;
/
create or replace package body Ui_Vhr549 is
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
    return b.Translate('UI-VHR549:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select * 
                  from htm_recommended_rank_documents q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    if not Ui.Grant_Has('list_status_new') then
      v_Query := v_Query || ' and q.status <> :status_new';
      v_Params.Put('status_new', Htm_Pref.c_Document_Status_New);
    end if;
  
    if not Ui.Grant_Has('list_status_set_training') then
      v_Query := v_Query || ' and q.status <> :status_set_training';
      v_Params.Put('status_set_training', Htm_Pref.c_Document_Status_Set_Training);
    end if;
  
    if not Ui.Grant_Has('list_status_training') then
      v_Query := v_Query || ' and q.status <> :status_training';
      v_Params.Put('status_training', Htm_Pref.c_Document_Status_Training);
    end if;
  
    if not Ui.Grant_Has('list_status_waiting') then
      v_Query := v_Query || ' and q.status <> :status_waiting';
      v_Params.Put('status_waiting', Htm_Pref.c_Document_Status_Waiting);
    end if;
  
    if not Ui.Grant_Has('list_status_approved') then
      v_Query := v_Query || ' and q.status <> :status_approved';
      v_Params.Put('status_approved', Htm_Pref.c_Document_Status_Approved);
    end if;
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query ||
                 ' and not exists (select 1
                              from htm_recommended_rank_staffs w
                             where w.company_id = :company_id
                               and w.filial_id = :filial_id
                               and w.document_id = q.document_id
                               and hpd_util.get_closest_org_unit_id(i_company_id => w.company_id,
                                                                    i_filial_id  => w.filial_id,
                                                                    i_staff_id   => w.staff_id,
                                                                    i_period     => q.document_date) not member of :division_ids)';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('document_id', 'division_id', 'created_by', 'modified_by', 'journal_id');
    q.Varchar2_Field('document_number', 'note', 'status');
    q.Date_Field('document_date', 'created_on', 'modified_on');
  
    v_Matrix := Htm_Util.Document_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Map_Field('journal_number',
                'select w.journal_number
                   from hpd_journals w
                  where w.company_id = :company_id
                    and w.filial_id = :filial_id
                    and w.journal_id = $journal_id');
  
    q.Multi_Number_Field('employee_ids',
                         'select rs.document_id,
                                 (select s.employee_id
                                    from href_staffs s
                                   where s.company_id = :company_id
                                     and s.filial_id = :filial_id
                                     and s.staff_id = rs.staff_id) as employee_id
                            from htm_recommended_rank_staffs rs
                           where rs.company_id = :company_id 
                             and rs.filial_id = :filial_id',
                         '@document_id=$document_id',
                         'employee_id');
  
    q.Refer_Field('employee_names',
                  'employee_ids',
                  'select *
                     from mr_natural_persons mrp 
                    where mrp.company_id = :company_id',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1
                             from href_staffs s
                            where s.company_id = w.company_id
                              and s.filial_id = :filial_id
                              and s.employee_id = w.person_id
                              and s.state = ''A'')');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('status_new',
                        Htm_Pref.c_Document_Status_New,
                        'status_set_training',
                        Htm_Pref.c_Document_Status_Set_Training,
                        'status_training',
                        Htm_Pref.c_Document_Status_Training,
                        'status_waiting',
                        Htm_Pref.c_Document_Status_Waiting,
                        'status_approved',
                        Htm_Pref.c_Document_Status_Approved);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Htm_Api.Recommended_Rank_Document_Status_New(i_Company_Id  => v_Company_Id,
                                                   i_Filial_Id   => v_Filial_Id,
                                                   i_Document_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Set_Training(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Htm_Api.Recommended_Rank_Document_Status_Set_Training(i_Company_Id  => v_Company_Id,
                                                            i_Filial_Id   => v_Filial_Id,
                                                            i_Document_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Training(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Htm_Api.Recommended_Rank_Document_Status_Training(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Document_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Waiting(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Htm_Api.Recommended_Rank_Document_Status_Waiting(i_Company_Id  => v_Company_Id,
                                                       i_Filial_Id   => v_Filial_Id,
                                                       i_Document_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Approved(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Htm_Api.Recommended_Rank_Document_Status_Approved(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Document_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Document_Ids Array_Number := Fazo.Sort(p.r_Array_Number('document_id'));
  begin
    for i in 1 .. v_Document_Ids.Count
    loop
      Htm_Api.Recommended_Rank_Document_Delete(i_Company_Id  => v_Company_Id,
                                               i_Filial_Id   => v_Filial_Id,
                                               i_Document_Id => v_Document_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Recommended_Rank(i_Document_Id number) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Order_No   number := 1;
  
    v_Old_Wage     number;
    v_New_Wage     number;
    v_Old_Wage_Sum number := 0;
    v_New_Wage_Sum number := 0;
  
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    a          b_Table := b_Report.New_Table();
  
    --------------------------------------------------
    Procedure Print_Info is
      v_Colspan number := 5;
    begin
      a.Current_Style('root bold');
      a.New_Row;
      a.New_Row;
      a.Data(t('document date: $1{document_date}', r_Document.Document_Date),
             i_Colspan => v_Colspan);
      a.New_Row;
      a.Data(t('document number: $1{document_number}', r_Document.Document_Number),
             i_Colspan => v_Colspan);
    
      if r_Document.Division_Id is not null then
        a.New_Row;
        a.Data(t('division name: $1{division_name}',
                 z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, --
                 i_Filial_Id => v_Filial_Id, --
                 i_Division_Id => r_Document.Division_Id).Name),
               i_Colspan => v_Colspan);
      end if;
    
      a.New_Row;
      a.Data(t('note: $1{note}', r_Document.Note), i_Colspan => v_Colspan);
      a.New_Row;
      a.Data(t('document status: $1{document_status}',
               Htm_Util.t_Document_Status(r_Document.Status)),
             i_Colspan => v_Colspan);
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
      v_Matrix Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('order_no'), 50),
                                                  Array_Varchar2(t('division name'), 250),
                                                  Array_Varchar2(t('job name'), 250),
                                                  Array_Varchar2(t('staff name'), 250),
                                                  Array_Varchar2(t('from rank'), 250),
                                                  Array_Varchar2(t('old wage'), 250),
                                                  Array_Varchar2(t('to rank'), 250),
                                                  Array_Varchar2(t('new wage'), 250),
                                                  Array_Varchar2(t('change date'), 250),
                                                  Array_Varchar2(t('note'), 250),
                                                  Array_Varchar2(t('increment status'), 50));
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      for i in 1 .. v_Matrix.Count
      loop
        a.Data(v_Matrix(i) (1));
        a.Column_Width(i, v_Matrix(i) (2));
      end loop;
    end;
  
    ----------------------------------------------------------------------------------------------------
    Procedure Print_Footer is
    begin
      a.Current_Style('footer');
      a.New_Row;
    
      a.Data(t('total:'), i_Colspan => 5, i_Style_Name => 'footer right');
      a.Data(v_Old_Wage_Sum, 'footer number');
      a.Add_Data(1);
      a.Data(v_New_Wage_Sum, 'footer number');
      a.Add_Data(3);
    end;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Load(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Document_Id => i_Document_Id);
  
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
    -- body
    a.Current_Style('body_centralized');
  
    for r in (select (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = r_Document.Company_Id
                         and Np.Person_Id = q.Employee_Id) Staff_Name,
                     (select d.Name
                        from Mhr_Divisions d
                       where d.Company_Id = r_Document.Company_Id
                         and d.Filial_Id = r_Document.Filial_Id
                         and d.Division_Id = w.Division_Id) Division_Name,
                     (select j.Name
                        from Mhr_Jobs j
                       where j.Company_Id = r_Document.Company_Id
                         and j.Filial_Id = r_Document.Filial_Id
                         and j.Job_Id = w.Job_Id) Job_Name,
                     Hr.Robot_Id,
                     Hr.Contractual_Wage,
                     Hr.Wage_Scale_Id,
                     (select Mr.Name
                        from Mhr_Ranks Mr
                       where Mr.Company_Id = r_Document.Company_Id
                         and Mr.Filial_Id = r_Document.Filial_Id
                         and Mr.Rank_Id = Ts.From_Rank_Id) From_Rank_Name,
                     (select Mr.Name
                        from Mhr_Ranks Mr
                       where Mr.Company_Id = r_Document.Company_Id
                         and Mr.Filial_Id = r_Document.Filial_Id
                         and Mr.Rank_Id = Ts.To_Rank_Id) To_Rank_Name,
                     Ts.New_Change_Date,
                     Ts.Staff_Id,
                     Ts.From_Rank_Id,
                     Ts.To_Rank_Id,
                     Ts.Increment_Status,
                     Ts.Note
                from Htm_Recommended_Rank_Staffs Ts
                join Href_Staffs q
                  on q.Company_Id = r_Document.Company_Id
                 and q.Filial_Id = r_Document.Filial_Id
                 and q.Staff_Id = Ts.Staff_Id
                join Mrf_Robots w
                  on w.Company_Id = r_Document.Company_Id
                 and w.Filial_Id = r_Document.Filial_Id
                 and w.Robot_Id = Ts.Robot_Id
                join Hrm_Robots Hr
                  on Hr.Company_Id = r_Document.Company_Id
                 and Hr.Filial_Id = r_Document.Filial_Id
                 and Hr.Robot_Id = Ts.Robot_Id
               where Ts.Company_Id = r_Document.Company_Id
                 and Ts.Filial_Id = r_Document.Filial_Id
                 and Ts.Document_Id = r_Document.Document_Id)
    loop
      a.New_Row;
      a.Data(to_char(v_Order_No));
    
      v_Order_No := v_Order_No + 1;
    
      v_Old_Wage := Hrm_Util.Get_Robot_Wage(i_Company_Id       => r_Document.Company_Id,
                                            i_Filial_Id        => r_Document.Filial_Id,
                                            i_Robot_Id         => r.Robot_Id,
                                            i_Contractual_Wage => r.Contractual_Wage,
                                            i_Wage_Scale_Id    => r.Wage_Scale_Id,
                                            i_Rank_Id          => r.From_Rank_Id);
    
      v_New_Wage := Hrm_Util.Get_Robot_Wage(i_Company_Id       => r_Document.Company_Id,
                                            i_Filial_Id        => r_Document.Filial_Id,
                                            i_Robot_Id         => r.Robot_Id,
                                            i_Contractual_Wage => r.Contractual_Wage,
                                            i_Wage_Scale_Id    => r.Wage_Scale_Id,
                                            i_Rank_Id          => r.To_Rank_Id);
    
      a.Data(r.Division_Name);
      a.Data(r.Job_Name);
      a.Data(r.Staff_Name);
      a.Data(r.From_Rank_Name);
      a.Data(v_Old_Wage, 'body number');
      a.Data(r.To_Rank_Name);
      a.Data(v_New_Wage, 'body number');
      a.Data(r.New_Change_Date);
      a.Data(r.Note);
    
      if r.Increment_Status = Htm_Pref.c_Increment_Status_Success then
        a.Data(Htm_Util.t_Increment_Status(r.Increment_Status), 'success');
      elsif r.Increment_Status = Htm_Pref.c_Increment_Status_Failure then
        a.Data(Htm_Util.t_Increment_Status(r.Increment_Status), 'danger');
      else
        a.Data(Htm_Util.t_Increment_Status(r.Increment_Status));
      end if;
    
      v_Old_Wage_Sum := v_Old_Wage_Sum + v_Old_Wage;
      v_New_Wage_Sum := v_New_Wage_Sum + v_New_Wage;
    end loop;
  
    Print_Footer;
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name, --
                       p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'), --
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
    -- success
    b_Report.New_Style(i_Style_Name        => 'success',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#bfefed');
    -- danger
    b_Report.New_Style(i_Style_Name        => 'danger',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#fccdd2');
  
    Run_Recommended_Rank(p.r_Number('document_id'));
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htm_Recommended_Rank_Documents
       set Company_Id      = null,
           Filial_Id       = null,
           Document_Id     = null,
           Document_Number = null,
           Document_Date   = null,
           Division_Id     = null,
           Note            = null,
           Status          = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
  
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
  
    update Hpd_Journals
       set Company_Id     = null,
           Filial_Id      = null,
           Journal_Id     = null,
           Journal_Number = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  
    update Htm_Recommended_Rank_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Document_Id = null,
           Staff_Id    = null;
  
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Employee_Id = null,
           State       = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
  end;

end Ui_Vhr549;
/
