create or replace package Ui_Vhr651 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Employees return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Journal_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr651;
/
create or replace package body Ui_Vhr651 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Employees return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.employee_id,
                            (select w.name
                               from md_persons w
                              where w.company_id = q.company_id
                                and w.person_id = q.employee_id) as name,
                            st.hiring_date,
                            st.dismissal_date
                       from mhr_employees q
                       join href_staffs st
                         on st.company_id = q.company_id
                        and st.filial_id = q.filial_id
                        and st.employee_id = q.employee_id
                        and st.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = :state
                        and exists (select 1 
                               from md_users us
                              where us.company_id = q.company_id
                                and us.user_id = q.employee_id
                                and us.state = :state)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('name');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Journal_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select * 
                       from hpd_journal_types q
                      where q.company_id = :company_id 
                        and not exists (select 1 
                                   from hpd_sign_templates st
                                  where st.company_id = :company_id
                                    and st.filial_id = :filial_id
                                    and st.journal_type_id = q.journal_type_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('journal_type_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References return Hashmap is
    v_Name varchar2(100);
  begin
    v_Name := z_Mdf_Sign_Processes.Load(i_Company_Id => Ui.Company_Id, --
              i_Process_Id => Hpd_Util.Sign_Process_Id_By_Pcode(i_Company_Id => Ui.Company_Id, i_Pcode => Hpd_Pref.c_Pcode_Journal_Sign_Processes)).Name;
  
    return Fazo.Zip_Map('process_name', v_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap := Fazo.Zip_Map('sign_kind', Mdf_Pref.c_Sk_Sequential, 'state', 'A');
  begin
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Template   Mdf_Sign_Templates%rowtype;
    r_v_Template Hpd_Sign_Templates%rowtype;
    v_Martrix    Matrix_Varchar2;
    result       Hashmap;
  begin
    r_Template := z_Mdf_Sign_Templates.Load(i_Company_Id  => Ui.Company_Id,
                                            i_Template_Id => p.r_Number('template_id'));
  
    r_v_Template := z_Hpd_Sign_Templates.Load(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Template_Id => r_Template.Template_Id);
  
    result := z_Mdf_Sign_Templates.To_Map(r_Template,
                                          z.Template_Id,
                                          z.Sign_Kind,
                                          z.Process_Id,
                                          z.State,
                                          z.Note);
  
    Result.Put('journal_type_id', r_v_Template.Journal_Type_Id);
    Result.Put('journal_type_name',
               z_Hpd_Journal_Types.Load(i_Company_Id => Ui.Company_Id, i_Journal_Type_Id => r_v_Template.Journal_Type_Id).Name);
    Result.Put('process_name',
               z_Mdf_Sign_Processes.Load(i_Company_Id => r_Template.Company_Id, i_Process_Id => r_Template.Process_Id).Name);
  
    Result.Put_All(References);
  
    select Array_Varchar2(q.Level_No, q.Sign_Kind)
      bulk collect
      into v_Martrix
      from Mdf_Sign_Template_Levels q
     where q.Company_Id = r_Template.Company_Id
       and q.Template_Id = r_Template.Template_Id
     order by q.Level_No;
  
    Result.Put('levels', Fazo.Zip_Matrix(v_Martrix));
  
    select Array_Varchar2(q.Level_No, q.Group_No, q.Sign_Min_Count)
      bulk collect
      into v_Martrix
      from Mdf_Sign_Template_Groups q
     where q.Company_Id = r_Template.Company_Id
       and q.Template_Id = r_Template.Template_Id
     order by q.Group_No;
  
    Result.Put('groups', Fazo.Zip_Matrix(v_Martrix));
  
    select Array_Varchar2(q.Level_No,
                          q.Group_No,
                          q.User_Id,
                          (select k.Name
                             from Md_Persons k
                            where k.Company_Id = q.Company_Id
                              and k.Person_Id = q.User_Id))
      bulk collect
      into v_Martrix
      from Mdf_Sign_Template_Users q
     where q.Company_Id = r_Template.Company_Id
       and q.Template_Id = r_Template.Template_Id
     order by q.Order_No;
  
    Result.Put('employees', Fazo.Zip_Matrix(v_Martrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Template_Id number,
    p             Hashmap
  ) is
    v_Template      Mdf_Pref.Sign_Rt;
    v_Sign_Template Hpd_Pref.Sign_Template_Rt;
    v_Levels        Arraylist := p.r_Arraylist('levels');
    v_Groups        Arraylist;
    v_Group         Hashmap;
    v_Level         Hashmap;
  begin
    Mdf_Util.New_Sign(o_Sign       => v_Template,
                      i_Company_Id => Ui.Company_Id,
                      i_Sign_Id    => i_Template_Id,
                      i_Filial_Id  => Ui.Filial_Id,
                      i_Sign_Kind  => p.r_Varchar2('sign_kind'),
                      i_Note       => p.o_Varchar2('note'),
                      i_Process_Id => Hpd_Util.Sign_Process_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Sign_Processes),
                      i_State      => p.r_Varchar2('state'));
  
    for i in 1 .. v_Levels.Count
    loop
      v_Level := Treat(v_Levels.r_Hashmap(i) as Hashmap);
    
      Mdf_Util.Sign_Add_Level(p_Sign => v_Template, i_Sign_Kind => v_Level.r_Varchar2('sign_kind'));
    
      v_Groups := v_Level.r_Arraylist('groups');
      for j in 1 .. v_Groups.Count
      loop
        v_Group := Treat(v_Groups.r_Hashmap(j) as Hashmap);
      
        Mdf_Util.Sign_Add_Group(p_Level          => v_Template.Levels(i),
                                i_Sign_Min_Count => v_Group.r_Number('sign_min_count'),
                                i_Signer_Ids     => v_Group.r_Array_Number('employee_ids'));
      end loop;
    end loop;
  
    v_Sign_Template.Journal_Type_Id := p.r_Number('journal_type_id');
    v_Sign_Template.Template        := v_Template;
  
    Hpd_Api.Sign_Template_Save(v_Sign_Template);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Mdf_Next.Template_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
  begin
    save(p.r_Number('template_id'), p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mkcs_Cashflow_Reasons
       set Company_Id         = null,
           Cashflow_Reason_Id = null,
           Filial_Id          = null,
           name               = null,
           State              = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Employee_Id = null,
           State       = null;
    update Hpd_Journal_Types
       set Company_Id      = null,
           Journal_Type_Id = null,
           name            = null,
           Order_No        = null;
  end;

end Ui_Vhr651;
/
