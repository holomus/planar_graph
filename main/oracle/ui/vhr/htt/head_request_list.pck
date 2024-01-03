create or replace package Ui_Vhr627 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Requests return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Director_Requests return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Reset(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Cancel(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Delete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr627;
/
create or replace package body Ui_Vhr627 is
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
    return b.Translate('UI-VHR627:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query(i_Directors boolean := false) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'user_id', Ui.User_Id);
  
    v_Query := 'select q.*,
                       w.employee_id,
                       w.org_unit_id,
                       w.division_id,
                       w.job_id,
                       q.created_on request_date
                  from htt_requests q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                   and w.employee_id <> :user_id';
  
    if i_Directors then
      v_Query := v_Query || --       
                 ' and exists (select 1
                          from mrf_division_managers dv
                         where dv.company_id = w.company_id
                           and dv.filial_id = w.filial_id
                           and dv.manager_id = w.robot_id
                           and exists (select 1 
                                 from mhr_divisions d 
                                where d.company_id = dv.company_id
                                  and d.filial_id = dv.filial_id
                                  and d.division_id = dv.division_id
                                  and d.parent_id is null))                                                      
                 where q.company_id = :company_id';
    
      v_Query := 'select qr.*, :access_level_other access_level 
                    from (' || v_Query || ') qr';
    
      v_Params.Put('access_level_other', Href_Pref.c_User_Access_Level_Other);
    else
      v_Query := v_Query || --
                 ' where q.company_id = :company_id
                     and exists (select 1 
                            from md_user_filials mf 
                           where mf.company_id = :company_id
                             and mf.user_id = :user_id
                             and mf.filial_id = q.filial_id)';
    
      v_Query := Uit_Href.Make_Subordinated_Query(i_Query            => v_Query,
                                                  i_Include_Undirect => false,
                                                  i_Include_Manual   => true,
                                                  i_Is_Filial        => false);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('filial_id',
                   'request_id',
                   'request_kind_id',
                   'staff_id',
                   'division_id',
                   'job_id',
                   'approved_by',
                   'completed_by',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('request_type',
                     'manager_note',
                     'note',
                     'status',
                     'barcode',
                     'access_level',
                     'accrual_kind');
    q.Date_Field('begin_time', 'end_time', 'created_on', 'modified_on', 'request_date');
  
    q.Refer_Field('filial_name',
                  'filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials
                    where company_id = :company_id');
  
    q.Refer_Field('request_kind_name',
                  'request_kind_id',
                  'htt_request_kinds',
                  'request_kind_id',
                  'name',
                  'select *
                     from htt_request_kinds
                    where company_id = :company_id
                      and state = ''A''');
  
    v_Query := 'select q.staff_id,
                         (select p.name
                            from mr_natural_persons p
                           where p.company_id = :company_id
                             and p.person_id = q.employee_id) name,
                         q.employee_id,
                         q.division_id,
                         q.org_unit_id
                    from href_staffs q
                   where q.company_id = :company_id
                     and q.employee_id <> :user_id';
  
    q.Refer_Field('staff_name',
                  'staff_id',
                  'select q.staff_id,
                            (select p.name
                               from mr_natural_persons p
                              where p.company_id = :company_id
                                and p.person_id = q.employee_id) name
                       from href_staffs q
                      where q.company_id = :company_id',
                  'staff_id',
                  'name',
                  Uit_Href.Make_Subordinated_Query(i_Query            => v_Query,
                                                   i_Include_Undirect => false,
                                                   i_Include_Manual   => true));
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false, i_Current_Filial => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query(i_Current_Filial => false));
  
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                       from mhr_jobs d 
                      where d.company_id = :company_id
                        and d.state = ''A''');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('approved_by_name',
                  'approved_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('completed_by_name',
                  'completed_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    v_Matrix := Htt_Util.Request_Types;
    q.Option_Field('request_type_name', 'request_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Request_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Accrual_Kinds;
    q.Option_Field('accrual_kind_name', 'accrual_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('request_time',
                'htt_util.request_time(i_request_type => $request_type,
                                       i_begin_time   => $begin_time,
                                       i_end_time     => $end_time)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Requests return Fazo_Query is
  begin
    return Query;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Director_Requests return Fazo_Query is
  begin
    return Query(true);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Reset(p Hashmap) is
    v_Request    Hashmap;
    v_Company_Id number := Ui.Company_Id;
    v_Requests   Arraylist := p.r_Arraylist('requests');
    r_Request    Htt_Requests%rowtype;
  begin
    for i in 1 .. v_Requests.Count
    loop
      v_Request := Treat(v_Requests.r_Hashmap(i) as Hashmap);
    
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Request.r_Number('filial_id'),
                                            i_Request_Id => v_Request.r_Number('request_id'));
    
      if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Staff_Id   => r_Request.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                        i_Filial_Id => r_Request.Filial_Id,
                                        i_Self      => false,
                                        i_Undirect  => false);
      end if;
    
      Htt_Api.Request_Reset(i_Company_Id => r_Request.Company_Id,
                            i_Filial_Id  => r_Request.Filial_Id,
                            i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap) is
    v_Request      Hashmap;
    v_Company_Id   number := Ui.Company_Id;
    v_Requests     Arraylist := p.r_Arraylist('requests');
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
    r_Request      Htt_Requests%rowtype;
  begin
    for i in 1 .. v_Requests.Count
    loop
      v_Request := Treat(v_Requests.r_Hashmap(i) as Hashmap);
    
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Request.r_Number('filial_id'),
                                            i_Request_Id => v_Request.r_Number('request_id'));
    
      if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Staff_Id   => r_Request.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                        i_Filial_Id => r_Request.Filial_Id,
                                        i_Self      => false,
                                        i_Undirect  => false);
      end if;
    
      Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                              i_Filial_Id    => r_Request.Filial_Id,
                              i_Request_Id   => r_Request.Request_Id,
                              i_Manager_Note => v_Manager_Note,
                              i_User_Id      => Ui.User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap) is
    v_Request      Hashmap;
    v_Company_Id   number := Ui.Company_Id;
    v_Requests     Arraylist := p.r_Arraylist('requests');
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
    r_Request      Htt_Requests%rowtype;
  begin
    for i in 1 .. v_Requests.Count
    loop
      v_Request := Treat(v_Requests.r_Hashmap(i) as Hashmap);
    
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Request.r_Number('filial_id'),
                                            i_Request_Id => v_Request.r_Number('request_id'));
    
      if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Staff_Id   => r_Request.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                        i_Filial_Id => r_Request.Filial_Id,
                                        i_Self      => false,
                                        i_Undirect  => false);
      end if;
    
      Htt_Api.Request_Deny(i_Company_Id   => r_Request.Company_Id,
                           i_Filial_Id    => r_Request.Filial_Id,
                           i_Request_Id   => r_Request.Request_Id,
                           i_Manager_Note => v_Manager_Note);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap) is
    v_Request    Hashmap;
    v_Company_Id number := Ui.Company_Id;
    v_Requests   Arraylist := p.r_Arraylist('requests');
    r_Request    Htt_Requests%rowtype;
  begin
    for i in 1 .. v_Requests.Count
    loop
      v_Request := Treat(v_Requests.r_Hashmap(i) as Hashmap);
    
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Request.r_Number('filial_id'),
                                            i_Request_Id => v_Request.r_Number('request_id'));
    
      if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Staff_Id   => r_Request.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                        i_Filial_Id => r_Request.Filial_Id,
                                        i_Self      => false,
                                        i_Undirect  => false);
      end if;
    
      Htt_Api.Request_Complete(i_Company_Id => r_Request.Company_Id,
                               i_Filial_Id  => r_Request.Filial_Id,
                               i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Cancel(p Hashmap) is
    v_Request    Hashmap;
    v_Company_Id number := Ui.Company_Id;
    v_Requests   Arraylist := p.r_Arraylist('requests');
    r_Request    Htt_Requests%rowtype;
  begin
    for i in 1 .. v_Requests.Count
    loop
      v_Request := Treat(v_Requests.r_Hashmap(i) as Hashmap);
    
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Request.r_Number('filial_id'),
                                            i_Request_Id => v_Request.r_Number('request_id'));
    
      if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Staff_Id   => r_Request.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                        i_Filial_Id => r_Request.Filial_Id,
                                        i_Self      => false,
                                        i_Undirect  => false);
      end if;
    
      Htt_Api.Request_Deny(i_Company_Id => r_Request.Company_Id,
                           i_Filial_Id  => r_Request.Filial_Id,
                           i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete(p Hashmap) is
    v_Request    Hashmap;
    v_Company_Id number := Ui.Company_Id;
    v_Requests   Arraylist := p.r_Arraylist('requests');
    r_Request    Htt_Requests%rowtype;
  begin
    for i in 1 .. v_Requests.Count
    loop
      v_Request := Treat(v_Requests.r_Hashmap(i) as Hashmap);
    
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Request.r_Number('filial_id'),
                                            i_Request_Id => v_Request.r_Number('request_id'));
    
      if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                   i_Filial_Id  => r_Request.Filial_Id,
                                   i_Staff_Id   => r_Request.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                        i_Filial_Id => r_Request.Filial_Id,
                                        i_Undirect  => false);
      end if;
    
      Htt_Api.Request_Delete(i_Company_Id => r_Request.Company_Id,
                             i_Filial_Id  => r_Request.Filial_Id,
                             i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    r_Request      Htt_Requests%rowtype;
    r_Staff        Href_Staffs%rowtype;
    r_Request_Kind Htt_Request_Kinds%rowtype;
    v_Table        b_Table;
  begin
    r_Request := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => p.r_Number('filial_id'),
                                     i_Request_Id => p.r_Number('request_id'));
  
    if not Href_Util.Is_Director(i_Company_Id => r_Request.Company_Id,
                                 i_Filial_Id  => r_Request.Filial_Id,
                                 i_Staff_Id   => r_Request.Staff_Id) then
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id  => r_Request.Staff_Id,
                                      i_Filial_Id => r_Request.Filial_Id);
    end if;
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => r_Request.Company_Id,
                                  i_Filial_Id  => r_Request.Filial_Id,
                                  i_Staff_Id   => r_Request.Staff_Id);
  
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => r_Request.Company_Id,
                                               i_Request_Kind_Id => r_Request.Request_Kind_Id);
  
    b_Report.Open_Book_With_Styles(i_Report_Type => p.r_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    b_Report.New_Style(i_Style_Name        => 'title',
                       i_Parent_Style_Name => 'root',
                       i_Font_Size         => 10,
                       i_Font_Bold         => true,
                       i_Horizontal_Align  => b_Report.a_Right);
  
    b_Report.New_Style(i_Style_Name        => 'content',
                       i_Parent_Style_Name => 'root',
                       i_Font_Size         => 10,
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Border_Bottom     => b_Report.b_Thin);
  
    b_Report.New_Style(i_Style_Name => 'root_10', i_Parent_Style_Name => 'root', i_Font_Size => 10);
  
    v_Table := b_Report.New_Table;
  
    v_Table.Current_Style('root');
  
    v_Table.Column_Width(1, 200);
    v_Table.Column_Width(2, 300);
    v_Table.Column_Width(3, 300);
  
    v_Table.New_Row;
    v_Table.New_Row;
    v_Table.New_Row(30);
    v_Table.Data(Upper(t('request')), 'title center', i_Colspan => 3);
  
    v_Table.New_Row;
    v_Table.New_Row(30);
    v_Table.Data(t('filial'), 'title');
    v_Table.Data(z_Md_Filials.Load(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id).Name,
                 'content',
                 i_Colspan         => 2);
  
    v_Table.New_Row(30);
    v_Table.Data(t('staff'), 'title');
    v_Table.Data(Href_Util.Staff_Name(i_Company_Id => r_Staff.Company_Id,
                                      i_Filial_Id  => r_Staff.Filial_Id,
                                      i_Staff_Id   => r_Staff.Staff_Id),
                 'content',
                 i_Colspan => 2);
  
    v_Table.New_Row(30);
    v_Table.Data(t('job'), 'title');
    v_Table.Data(z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Job_Id => r_Staff.Job_Id).Name,
                 'content',
                 i_Colspan       => 2);
  
    v_Table.New_Row(30);
    v_Table.Data(t('request kind'), 'title');
    v_Table.Data(r_Request_Kind.Name, 'content', i_Colspan => 2);
  
    v_Table.New_Row(30);
    v_Table.Data(t('request time'), 'title');
    v_Table.Data(Htt_Util.Request_Time(i_Request_Type => r_Request.Request_Type,
                                       i_Begin_Time   => r_Request.Begin_Time,
                                       i_End_Time     => r_Request.End_Time),
                 'content',
                 i_Colspan => 2);
  
    v_Table.New_Row;
    v_Table.New_Row(30);
    v_Table.Data(t('created on'), 'title');
    v_Table.Data(to_char(r_Request.Created_On, 'dd.mm.yyyy hh24:mi'), 'content');
  
    v_Table.New_Row(30);
    v_Table.Data(t('created by'), 'title');
    v_Table.Data(z_Md_Persons.Load(i_Company_Id => r_Request.Company_Id, i_Person_Id => r_Request.Created_By).Name,
                 'content');
  
    v_Table.New_Row(30);
    v_Table.Data(t('approved by'), 'title');
    v_Table.Data(z_Md_Persons.Take(i_Company_Id => r_Request.Company_Id, i_Person_Id => r_Request.Approved_By).Name,
                 'content');
  
    v_Table.New_Row(30);
    v_Table.Data(t('manager note'), 'title');
    v_Table.Data(r_Request.Manager_Note, 'content');
  
    v_Table.New_Row(30);
    v_Table.Data(t('completed by'), 'title');
    v_Table.Data(z_Md_Persons.Take(i_Company_Id => r_Request.Company_Id, i_Person_Id => r_Request.Completed_By).Name,
                 'content');
  
    v_Table.New_Row;
    v_Table.New_Row(30);
    v_Table.Data(t('request code'), 'title');
    v_Table.Data(Upper(Regexp_Substr(z_Md_Users.Take(i_Company_Id => r_Request.Company_Id, --
                                     i_User_Id => r_Request.Created_By).Login,
                                     '(\w+)')) || to_char(r_Request.Created_On, 'yyyy') ||
                 Lpad(r_Request.Request_Id, 20, 0),
                 'root_10',
                 i_Colspan => 2);
  
    v_Table.New_Row;
    v_Table.Data;
    v_Table.Barcode(i_Text   => r_Request.Barcode, --              
                    i_Width  => 300,
                    i_Height => 100);
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name, --
                       p_Table => v_Table);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Requests
       set Company_Id      = null,
           Filial_Id       = null,
           Request_Id      = null,
           Request_Kind_Id = null,
           Staff_Id        = null,
           Begin_Time      = null,
           End_Time        = null,
           Request_Type    = null,
           Manager_Note    = null,
           Note            = null,
           Status          = null,
           Barcode         = null,
           Approved_By     = null,
           Completed_By    = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Htt_Request_Kinds
       set Company_Id      = null,
           Request_Kind_Id = null,
           name            = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Org_Unit_Id = null,
           Staff_Id    = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           Parent_Id   = null,
           State       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
  
    Uie.x(Htt_Util.Request_Time(i_Request_Type => null, i_Begin_Time => null, i_End_Time => null));
  end;

end Ui_Vhr627;
/
