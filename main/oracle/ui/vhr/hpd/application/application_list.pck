create or replace package Ui_Vhr534 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Approved(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_In_Progress(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Completed(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Canceled(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(i_Applications Arraylist);
end Ui_Vhr534;
/
create or replace package body Ui_Vhr534 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Param  Hashmap;
    v_Query  varchar2(4000);
    v_Matrix Matrix_Varchar2;
  begin
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'hiring_type_id',
                            Hpd_Util.Application_Type_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Hpd_Pref.c_Pcode_Application_Type_Hiring),
                            'transfer_type_id',
                            Hpd_Util.Application_Type_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Hpd_Pref.c_Pcode_Application_Type_Transfer),
                            'dismissal_type_id',
                            Hpd_Util.Application_Type_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Hpd_Pref.c_Pcode_Application_Type_Dismissal),
                            'create_robot_type_id',
                            Hpd_Util.Application_Type_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Hpd_Pref.c_Pcode_Application_Type_Create_Robot));
  
    v_Query := 'select q.*,
                       case 
                         when q.application_type_id = :hiring_type_id then 
                           (select hr.hiring_date
                              from hpd_application_hirings hr
                             where hr.company_id = q.company_id
                               and hr.filial_id  = q.filial_id
                               and hr.application_id = q.application_id)
                         when q.application_type_id = :dismissal_type_id then
                           (select ds.dismissal_date
                              from hpd_application_dismissals ds
                             where ds.company_id = q.company_id
                               and ds.filial_id = q.filial_id
                               and ds.application_id = q.application_id)
                         when q.application_type_id = :transfer_type_id then
                           (select tr.transfer_begin
                              from hpd_application_transfers tr
                             where tr.company_id = q.company_id
                               and tr.filial_id = q.filial_id
                               and tr.application_id = q.application_id)
                         when q.application_type_id = :create_robot_type_id then 
                           (select cr.opened_date
                              from hpd_application_create_robots cr
                             where cr.company_id = q.company_id
                               and cr.filial_id = q.filial_id
                               and cr.application_id = q.application_id)
                         else null
                       end as trans_date
                  from hpd_applications q
                 where q.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Param.Put('filial_id', Ui.Filial_Id);
      v_Query := v_Query || ' and q.filial_id = :filial_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('filial_id',
                   'application_id',
                   'application_type_id',
                   'created_by',
                   'modified_by');
  
    q.Varchar2_Field('application_number', 'status');
    q.Date_Field('application_date', 'trans_date', 'created_on', 'modified_on');
  
    v_Matrix := Hpd_Util.Application_Statuses();
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('application_type_name',
                  'application_type_id',
                  'hpd_application_types',
                  'application_type_id',
                  'name',
                  'select *
                     from hpd_application_types s
                    where s.company_id = :company_id');
  
    q.Map_Field('pcode',
                'select q.pcode 
                   from hpd_application_types q 
                  where q.company_id = :company_id
                    and q.application_type_id = $application_type_id');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Multi_Number_Field('employee_ids',
                         'select q.application_id, q.employee_id
                              from hpd_application_hirings q
                             where q.company_id = :company_id
                            union
                            select w.application_id, href_util.get_employee_id(w.company_id, w.filial_id, w.staff_id)
                              from hpd_application_dismissals w
                             where w.company_id = :company_id
                            union
                            select t.application_id, href_util.get_employee_id(t.company_id, t.filial_id, t.staff_id)
                              from hpd_application_transfers t
                             where t.company_id = :company_id',
                         '@application_id = $application_id',
                         'employee_id');
  
    q.Refer_Field('employee_names',
                  'employee_ids',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select * 
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1 
                             from mhr_employees q
                            where q.company_id = :company_id
                              and q.filial_id = :filial_id
                              and q.employee_id = w.person_id)');
  
    if Ui.Is_Filial_Head then
      q.Refer_Field('filial_name',
                    'filial_id',
                    'md_filials',
                    'filial_id',
                    'name',
                    'select *
                       from md_filials t
                      where t.company_id = :company_id');
    else
      q.Map_Field('filial_name', 'null');
      q.Grid_Column_Label('filial_name', '');
    end if;
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Actions       Array_Varchar2;
    v_Filial_Grants Hashmap := Hashmap;
    result          Hashmap;
  begin
    result := Fazo.Zip_Map('application_status_new',
                           Hpd_Pref.c_Application_Status_New,
                           'application_status_waiting',
                           Hpd_Pref.c_Application_Status_Waiting,
                           'application_status_approved',
                           Hpd_Pref.c_Application_Status_Approved,
                           'application_status_in_progress',
                           Hpd_Pref.c_Application_Status_In_Progress,
                           'application_status_completed',
                           Hpd_Pref.c_Application_Status_Completed,
                           'application_status_canceled',
                           Hpd_Pref.c_Application_Status_Canceled);
  
    Result.Put('pcode_create_robot', Hpd_Pref.c_Pcode_Application_Type_Create_Robot);
    Result.Put('pcode_hiring', Hpd_Pref.c_Pcode_Application_Type_Hiring);
    Result.Put('pcode_transfer', Hpd_Pref.c_Pcode_Application_Type_Transfer);
    Result.Put('pcode_transfer_multiple', Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple);
    Result.Put('pcode_dismissal', Hpd_Pref.c_Pcode_Application_Type_Dismissal);
  
    if Ui.Is_Filial_Head then
      -- application form URIs
      Result.Put('uri_create_robot_edit', Hpd_Pref.c_Uri_Application_Part || 'create_robot+edit');
      Result.Put('uri_create_robot_view', Hpd_Pref.c_Uri_Application_Part || 'create_robot_view');
      Result.Put('uri_hiring_edit', Hpd_Pref.c_Uri_Application_Part || 'hiring+edit');
      Result.Put('uri_hiring_view', Hpd_Pref.c_Uri_Application_Part || 'hiring_view');
      Result.Put('uri_transfer_edit', Hpd_Pref.c_Uri_Application_Part || 'transfer+edit');
      Result.Put('uri_transfer_multiple_edit',
                 Hpd_Pref.c_Uri_Application_Part || 'transfer_multiple+edit');
      Result.Put('uri_transfer_view', Hpd_Pref.c_Uri_Application_Part || 'transfer_view');
      Result.Put('uri_dismissal_edit', Hpd_Pref.c_Uri_Application_Part || 'dismissal+edit');
      Result.Put('uri_dismissal_view', Hpd_Pref.c_Uri_Application_Part || 'dismissal_view');
    
      -- check grants
      v_Actions := Array_Varchar2(Hpd_Pref.c_App_Grant_Part_Create_Robot ||
                                  Hpd_Pref.c_App_Form_Action_Edit,
                                  Hpd_Pref.c_App_Grant_Part_Create_Robot ||
                                  Hpd_Pref.c_App_Form_Action_View,
                                  Hpd_Pref.c_App_Grant_Part_Hiring ||
                                  Hpd_Pref.c_App_Form_Action_Edit,
                                  Hpd_Pref.c_App_Grant_Part_Hiring ||
                                  Hpd_Pref.c_App_Form_Action_View,
                                  Hpd_Pref.c_App_Grant_Part_Transfer ||
                                  Hpd_Pref.c_App_Form_Action_Edit,
                                  Hpd_Pref.c_App_Grant_Part_Transfer ||
                                  Hpd_Pref.c_App_Form_Action_View,
                                  Hpd_Pref.c_App_Grant_Part_Dismissal ||
                                  Hpd_Pref.c_App_Form_Action_Edit,
                                  Hpd_Pref.c_App_Grant_Part_Dismissal ||
                                  Hpd_Pref.c_App_Form_Action_View);
    
      for r in (select t.Filial_Id,
                       (select cast(collect(Column_Value) as Array_Varchar2)
                          from table(v_Actions)
                         where Uit_Hpd.Application_Grant_Has(i_Grant     => Column_Value,
                                                             i_Filial_Id => t.Filial_Id) = 'Y') Actions
                  from Md_Filials t
                 where t.Company_Id = Ui.Company_Id
                   and t.State = 'A')
      loop
        v_Filial_Grants.Put(r.Filial_Id, r.Actions);
      end loop;
    
      Result.Put('filial_grants', v_Filial_Grants);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Application_Type_Id, q.Name, q.Pcode)
      bulk collect
      into v_Matrix
      from Hpd_Application_Types q
     where q.Company_Id = Ui.Company_Id
     order by q.Order_No;
  
    Result.Put('application_types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Grant
  (
    i_Application_Id number,
    i_Grant          varchar2
  ) is
    v_Application_Type_Id number;
    v_Grant               varchar2(50);
  begin
    v_Application_Type_Id := z_Hpd_Applications.Load(i_Company_Id => Ui.Company_Id, --
                             i_Filial_Id => Ui.Filial_Id, i_Application_Id => i_Application_Id).Application_Type_Id;
  
    v_Grant := Hpd_Util.Application_Grant_Part(i_Company_Id          => Ui.Company_Id,
                                               i_Application_Type_Id => v_Application_Type_Id);
  
    Uit_Hpd.Application_Assert_Grant(v_Grant || i_Grant);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap) is
    v_Application_Id number := p.r_Number('application_id');
  begin
    Assert_Grant(v_Application_Id, Hpd_Pref.c_App_Grantee_Applicant);
  
    Hpd_Api.Application_Status_New(i_Company_Id     => Ui.Company_Id,
                                   i_Filial_Id      => Ui.Filial_Id,
                                   i_Application_Id => v_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Waiting(p Hashmap) is
    r_Application Hpd_Applications%rowtype;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => Ui.Company_Id,
                                                  i_Filial_Id      => Ui.Filial_Id,
                                                  i_Application_Id => p.r_Number('application_id'));
    case r_Application.Status
      when Hpd_Pref.c_Application_Status_New then
        Assert_Grant(r_Application.Application_Id, Hpd_Pref.c_App_Grantee_Applicant);
      else
        Assert_Grant(r_Application.Application_Id, Hpd_Pref.c_App_Grantee_Manager);
    end case;
  
    Hpd_Api.Application_Status_Waiting(i_Company_Id     => r_Application.Company_Id,
                                       i_Filial_Id      => r_Application.Filial_Id,
                                       i_Application_Id => r_Application.Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Approved(p Hashmap) is
    r_Application Hpd_Applications%rowtype;
  begin
    r_Application := z_Hpd_Applications.Lock_Load(i_Company_Id     => Ui.Company_Id,
                                                  i_Filial_Id      => Ui.Filial_Id,
                                                  i_Application_Id => p.r_Number('application_id'));
    case r_Application.Status
      when Hpd_Pref.c_Application_Status_Waiting then
        Assert_Grant(r_Application.Application_Id, Hpd_Pref.c_App_Grantee_Manager);
      else
        Assert_Grant(r_Application.Application_Id, Hpd_Pref.c_App_Grantee_Hr);
    end case;
  
    Hpd_Api.Application_Status_Approved(i_Company_Id     => r_Application.Company_Id,
                                        i_Filial_Id      => r_Application.Filial_Id,
                                        i_Application_Id => r_Application.Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_In_Progress(p Hashmap) is
    v_Application_Id number := p.r_Number('application_id');
  begin
    Assert_Grant(v_Application_Id, Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_In_Progress(i_Company_Id     => Ui.Company_Id,
                                           i_Filial_Id      => Ui.Filial_Id,
                                           i_Application_Id => v_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Completed(p Hashmap) is
    v_Application_Id number := p.r_Number('application_id');
  begin
    Assert_Grant(v_Application_Id, Hpd_Pref.c_App_Grantee_Hr);
  
    Hpd_Api.Application_Status_Completed(i_Company_Id     => Ui.Company_Id,
                                         i_Filial_Id      => Ui.Filial_Id,
                                         i_Application_Id => v_Application_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Canceled(p Hashmap) is
    v_Application_Id number := p.r_Number('application_id');
  begin
    Assert_Grant(v_Application_Id, Hpd_Pref.c_App_Grantee_Manager);
  
    Hpd_Api.Application_Status_Canceled(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Application_Id => v_Application_Id,
                                        i_Closing_Note   => p.o_Varchar2('closing_note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(i_Applications Arraylist) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number;
    v_Application Hashmap;
  begin
    if not Ui.Is_Filial_Head then
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    for i in 1 .. i_Applications.Count
    loop
      v_Application := Treat(i_Applications.r_Hashmap(i) as Hashmap);
    
      Hpd_Api.Application_Delete(i_Company_Id     => v_Company_Id,
                                 i_Filial_Id      => Coalesce(v_Filial_Id,
                                                              v_Application.r_Number('filial_id')),
                                 i_Application_Id => v_Application.r_Number('application_id'));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Applications
       set Company_Id          = null,
           Filial_Id           = null,
           Application_Id      = null,
           Application_Type_Id = null,
           Application_Number  = null,
           Application_Date    = null,
           Status              = null,
           Created_By          = null,
           Created_On          = null,
           Modified_By         = null,
           Modified_On         = null;
    update Hpd_Application_Hirings
       set Company_Id     = null,
           Filial_Id      = null,
           Application_Id = null,
           Employee_Id    = null,
           Hiring_Date    = null;
    update Hpd_Application_Dismissals
       set Company_Id     = null,
           Filial_Id      = null,
           Application_Id = null,
           Staff_Id       = null,
           Dismissal_Date = null;
    update Hpd_Application_Transfers
       set Company_Id     = null,
           Filial_Id      = null,
           Application_Id = null,
           Staff_Id       = null,
           Transfer_Begin = null;
    update Hpd_Application_Create_Robots
       set Company_Id     = null,
           Filial_Id      = null,
           Application_Id = null,
           Opened_Date    = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Hpd_Application_Types
       set Company_Id          = null,
           Application_Type_Id = null,
           name                = null,
           Order_No            = null,
           Pcode               = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr534;
/
