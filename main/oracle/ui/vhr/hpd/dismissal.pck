create or replace package Ui_Vhr52 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Employment_Sources return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Multiple_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Arraylist;
end Ui_Vhr52;
/
create or replace package body Ui_Vhr52 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Employment_Sources return Fazo_Query is
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A');
  
    v_Params.Put('kinds',
                 Array_Varchar2(Href_Pref.c_Employment_Source_Kind_Dismissal,
                                Href_Pref.c_Employment_Source_Kind_Both));
  
    q := Fazo_Query('select *
                       from href_employment_sources q
                      where q.company_id = :company_id
                        and q.kind member of :kinds
                        and q.state = :state',
                    v_Params);
  
    q.Number_Field('source_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
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
    q.Varchar2_Field('staff_number', 'state', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Reasons return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Href_Util.Dismissal_Reasons_Type;
    q        Fazo_Query;
  begin
    q := Fazo_Query('href_dismissal_reasons', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('dismissal_reason_id');
    q.Varchar2_Field('name', 'reason_type');
  
    q.Option_Field('reason_type_name', 'reason_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
  begin
    return Fazo.Zip_Map('journal_type_id',
                        Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                        'user_id',
                        Ui.User_Id,
                        'et_contractor',
                        Hpd_Pref.c_Employment_Type_Contractor,
                        'access_all_employee',
                        Uit_Href.User_Access_All_Employees);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => Ui.Company_Id,
                                         i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_type_id',
                           v_Journal_Type_Id,
                           'journal_date',
                           Trunc(sysdate),
                           'dismissal_date',
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
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    r_Page                 Hpd_Journal_Pages%rowtype;
    r_Dismissal            Hpd_Dismissals%rowtype;
    r_Dismissal_Reason     Href_Dismissal_Reasons%rowtype;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    v_Page_Id              number;
    result                 Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => Ui.Company_Id,
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
                                    z.Journal_Name,
                                    z.Posted);
  
    select q.Page_Id
      into v_Page_Id
      from Hpd_Journal_Pages q
     where q.Company_Id = r_Journal.Company_Id
       and q.Filial_Id = r_Journal.Filial_Id
       and q.Journal_Id = r_Journal.Journal_Id;
  
    r_Page := z_Hpd_Journal_Pages.Load(i_Company_Id => r_Journal.Company_Id,
                                       i_Filial_Id  => r_Journal.Filial_Id,
                                       i_Page_Id    => v_Page_Id);
  
    Result.Put_All(z_Hpd_Journal_Pages.To_Map(r_Page, z.Page_Id, z.Employee_Id, z.Staff_Id));
  
    r_Dismissal := z_Hpd_Dismissals.Load(i_Company_Id => r_Journal.Company_Id,
                                         i_Filial_Id  => r_Journal.Filial_Id,
                                         i_Page_Id    => v_Page_Id);
  
    Result.Put_All(z_Hpd_Dismissals.To_Map(r_Dismissal,
                                           z.Page_Id,
                                           z.Staff_Id,
                                           z.Dismissal_Date,
                                           z.Dismissal_Reason_Id,
                                           z.Employment_Source_Id,
                                           z.Based_On_Doc,
                                           z.Note));
  
    r_Dismissal_Reason := z_Href_Dismissal_Reasons.Take(i_Company_Id          => r_Dismissal.Company_Id,
                                                        i_Dismissal_Reason_Id => r_Dismissal.Dismissal_Reason_Id);
  
    Result.Put('staff_name',
               z_Md_Persons.Load(i_Company_Id => r_Dismissal.Company_Id, i_Person_Id => r_Page.Employee_Id).Name);
    Result.Put('staff_number',
               z_Href_Staffs.Load(i_Company_Id => r_Dismissal.Company_Id, i_Filial_Id => r_Dismissal.Filial_Id, i_Staff_Id => r_Page.Staff_Id).Staff_Number);
    Result.Put('dismissal_reason_name', r_Dismissal_Reason.Name);
    Result.Put('dismissal_reason_type', r_Dismissal_Reason.Reason_Type);
    Result.Put('employment_source_name',
               z_Href_Employment_Sources.Take(i_Company_Id => r_Dismissal.Company_Id, i_Source_Id => r_Dismissal.Employment_Source_Id).Name);
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Multiple_Model(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Matrix  Matrix_Varchar2;
    result    Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => Ui.Company_Id,
                                         i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
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
                                    z.Journal_Name,
                                    z.Posted);
  
    select Array_Varchar2(w.Page_Id,
                          w.Dismissal_Date,
                          q.Staff_Id,
                          (select k.Name
                             from Mr_Natural_Persons k
                            where k.Company_Id = q.Company_Id
                              and k.Person_Id = q.Employee_Id),
                          w.Dismissal_Reason_Id,
                          Dr.Name,
                          Dr.Reason_Type,
                          w.Employment_Source_Id,
                          (select k.Name
                             from Href_Employment_Sources k
                            where k.Company_Id = w.Company_Id
                              and k.Source_Id = w.Employment_Source_Id),
                          w.Based_On_Doc,
                          w.Note)
      bulk collect
      into v_Matrix
      from Hpd_Journal_Pages q
      join Hpd_Dismissals w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Page_Id = q.Page_Id
      left join Href_Dismissal_Reasons Dr
        on Dr.Company_Id = w.Company_Id
       and Dr.Dismissal_Reason_Id = w.Dismissal_Reason_Id
     where q.Company_Id = r_Journal.Company_Id
       and q.Filial_Id = r_Journal.Filial_Id
       and q.Journal_Id = r_Journal.Journal_Id;
  
    Result.Put('dismissals', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Journal_Id number,
    p            Hashmap,
    i_Repost     boolean := false,
    i_Exists     boolean := false
  ) return Hashmap is
    p_Journal            Hpd_Pref.Dismissal_Journal_Rt;
    v_Dismissals         Arraylist := p.r_Arraylist('dismissal');
    v_Dismissal          Hashmap;
    v_Page_Id            number;
    v_Staff_Id           number;
    v_Notification_Title varchar2(500);
    v_Posted             varchar2(1) := p.r_Varchar2('posted');
    v_User_Id            number := Ui.User_Id;
    result               Hashmap;
  begin
    Hpd_Util.Dismissal_Journal_New(o_Journal         => p_Journal,
                                   i_Company_Id      => Ui.Company_Id,
                                   i_Filial_Id       => Ui.Filial_Id,
                                   i_Journal_Id      => i_Journal_Id,
                                   i_Journal_Type_Id => p.r_Number('journal_type_id'),
                                   i_Journal_Number  => p.o_Varchar2('journal_number'),
                                   i_Journal_Date    => p.r_Date('journal_date'),
                                   i_Journal_Name    => p.o_Varchar2('journal_name'),
                                   i_Lang_Code       => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Dismissals.Count
    loop
      v_Dismissal := Treat(v_Dismissals.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Dismissal.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Page_Id := v_Dismissal.o_Number('page_id');
    
      if v_Page_Id is null then
        v_Page_Id := Hpd_Next.Page_Id;
      end if;
    
      Hpd_Util.Journal_Add_Dismissal(p_Journal              => p_Journal,
                                     i_Page_Id              => v_Page_Id,
                                     i_Staff_Id             => v_Staff_Id,
                                     i_Dismissal_Date       => v_Dismissal.o_Date('dismissal_date'),
                                     i_Dismissal_Reason_Id  => v_Dismissal.o_Number('dismissal_reason_id'),
                                     i_Employment_Source_Id => v_Dismissal.o_Number('employment_source_id'),
                                     i_Based_On_Doc         => v_Dismissal.o_Varchar2('based_on_doc'),
                                     i_Note                 => v_Dismissal.o_Varchar2('note'));
    end loop;
  
    -- notification title should make before saving journal
    if i_Exists = false and v_Posted = 'N' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Save(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    elsif i_Repost = false and v_Posted = 'Y' then
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => p_Journal.Company_Id,
                                                                         i_User_Id         => v_User_Id,
                                                                         i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    else
      v_Notification_Title := Hpd_Util.t_Notification_Title_Journal_Update(i_Company_Id      => p_Journal.Company_Id,
                                                                           i_User_Id         => v_User_Id,
                                                                           i_Journal_Type_Id => p_Journal.Journal_Type_Id);
    end if;
  
    Hpd_Api.Dismissal_Journal_Save(p_Journal);
  
    if v_Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  
    -- notification send after saving journal
    Href_Core.Send_Notification(i_Company_Id    => p_Journal.Company_Id,
                                i_Filial_Id     => p_Journal.Filial_Id,
                                i_Title         => v_Notification_Title,
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  
    result := Fazo.Zip_Map('journal_id', --
                           i_Journal_Id,
                           'journal_name',
                           p_Journal.Journal_Name);
  
    if v_Posted = 'Y' then
      Result.Put('cos_requests',
                 Hisl_Util.Journal_Requests(i_Company_Id => p_Journal.Company_Id,
                                            i_Filial_Id  => p_Journal.Filial_Id,
                                            i_Journal_Id => p_Journal.Journal_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap) is
  begin
    Hisl_Api.Process_Response(i_Company_Id    => Ui.Company_Id,
                              i_Filial_Id     => Ui.Filial_Id,
                              i_Status        => p.r_Varchar2('status'),
                              i_Url           => p.r_Varchar2('url'),
                              i_Request_Body  => p.r_Varchar2('request_body'),
                              i_Response_Body => p.r_Varchar2('response_body'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpd_Next.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Repost  boolean;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    v_Repost := r_Journal.Posted = 'Y' and p.r_Varchar2('posted') = 'Y';
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => v_Repost);
    end if;
  
    return save(r_Journal.Journal_Id, p, v_Repost, true);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Arraylist is
    v_Arraylist  Arraylist := p.r_Arraylist('data');
    v_Item       Hashmap;
    v_Data       Hashmap;
    v_Staff_Id   number;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    result       Arraylist := Arraylist();
  begin
    for i in 1 .. v_Arraylist.Count
    loop
      v_Data := Hashmap();
    
      v_Item     := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      v_Staff_Id := v_Item.r_Number('staff_id');
    
      v_Data.Put('staff_id', v_Staff_Id);
      v_Data.Put_All(Uit_Href.Get_Influences(i_Employee_Id         => Href_Util.Get_Employee_Id(i_Company_Id => v_Company_Id,
                                                                                                i_Filial_Id  => v_Filial_Id,
                                                                                                i_Staff_Id   => v_Staff_Id),
                                             i_Dismissal_Reason_Id => v_Item.o_Number('dismissal_reason_id')));
    
      Result.Push(v_Data);
    end loop;
  
    return result;
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
           Employment_Type = null,
           Employee_Id     = null,
           Division_Id     = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null,
           Reason_Type         = null;
  end;

end Ui_Vhr52;
/
