create or replace package Ui_Vhr657 is
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr657;
/
create or replace package body Ui_Vhr657 is
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
  begin
    Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                              i_User_Id         => v_User_Id,
                                                                                              i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Hiring_Journal_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                i_User_Id         => v_User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Hiring_Journal_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    r_Setting Hrm_Settings%rowtype;
    result    Hashmap := Hashmap();
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor));
    Result.Put('custom_fte_id', Href_Pref.c_Custom_Fte_Id);
    Result.Put_All(z_Hrm_Settings.To_Map(r_Setting,
                                         z.Position_Enable,
                                         z.Parttime_Enable,
                                         z.Rank_Enable,
                                         z.Wage_Scale_Enable,
                                         z.Advanced_Org_Structure));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hirings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Page_Ids        Array_Number;
    v_Full_Page_Ids   Array_Number;
    v_Matrix          Matrix_Varchar2;
    v_Custom_Fte_Name varchar2(32767) := Href_Util.t_Custom_Fte_Name;
    result            Hashmap := Hashmap();
  begin
    select Array_Varchar2(Hir.Page_Id,
                           Hir.Hiring_Date,
                           Hir.Dismissal_Date,
                           Hir.Employment_Source_Name,
                           Hir.Staff_Number,
                           Hir.Employee_Name,
                           Hir.Robot_Name,
                           Hir.Schedule_Name,
                           case
                             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
                              Hir.Currency_Name
                             else
                              null
                           end,
                           Hir.Contractual_Wage,
                           Hir.Division_Name,
                           Hir.Org_Unit_Name,
                           Hir.Job_Name,
                           Hir.Rank_Name,
                           Hir.Fte_Name,
                           case
                             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
                              Hir.Wage_Scale_Name
                             else
                              null
                           end,
                           Hir.Contract_Number,
                           Hir.Contract_Kind_Name,
                           Hir.Access_To_Add_Item_Name,
                           Hir.Note,
                           Hir.Access_To_Hidden_Salary_Job),
           case
             when Hir.Access_To_Hidden_Salary_Job = 'Y' then
              Hir.Page_Id
             else
              null
           end,
           Hir.Page_Id
      bulk collect
      into v_Matrix, v_Page_Ids, v_Full_Page_Ids
      from (select q.Page_Id,
                   w.Hiring_Date,
                   w.Dismissal_Date,
                   (select k.Name
                      from Href_Employment_Sources k
                     where k.Company_Id = q.Company_Id
                       and k.Source_Id = w.Employment_Source_Id) as Employment_Source_Name,
                   (select s.Staff_Number
                      from Href_Staffs s
                     where s.Company_Id = q.Company_Id
                       and s.Filial_Id = q.Filial_Id
                       and s.Staff_Id = q.Staff_Id) as Staff_Number,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = q.Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   t.Name as Robot_Name,
                   (select k.Name
                      from Htt_Schedules k
                     where k.Company_Id = s.Company_Id
                       and k.Filial_Id = s.Filial_Id
                       and k.Schedule_Id = s.Schedule_Id) as Schedule_Name,
                   (select Cr.Name
                      from Mk_Currencies Cr
                     where Cr.Company_Id = Pc.Company_Id
                       and Cr.Currency_Id = Pc.Currency_Id) as Currency_Name,
                   (select k.Contractual_Wage
                      from Hrm_Robots k
                     where k.Company_Id = m.Company_Id
                       and k.Filial_Id = m.Filial_Id
                       and k.Robot_Id = m.Robot_Id) as Contractual_Wage,
                   (select Div.Name
                      from Mhr_Divisions Div
                     where Div.Company_Id = t.Company_Id
                       and Div.Filial_Id = t.Filial_Id
                       and Div.Division_Id = t.Division_Id) as Division_Name,
                   (select k.Name
                      from Mhr_Jobs k
                     where k.Company_Id = t.Company_Id
                       and k.Filial_Id = t.Filial_Id
                       and k.Job_Id = t.Job_Id) as Job_Name,
                   case
                      when t.Division_Id = Hr.Org_Unit_Id then
                       null
                      else
                       (select Div.Name
                          from Mhr_Divisions Div
                         where Div.Company_Id = Hr.Company_Id
                           and Div.Filial_Id = Hr.Filial_Id
                           and Div.Division_Id = Hr.Org_Unit_Id)
                    end as Org_Unit_Name,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = m.Company_Id
                       and k.Filial_Id = m.Filial_Id
                       and k.Rank_Id = Nvl(m.Rank_Id, Hr.Rank_Id)) as Rank_Name,
                   Nvl((select Hf.Name
                         from Href_Ftes Hf
                        where Hf.Company_Id = m.Company_Id
                          and Hf.Fte_Id = m.Fte_Id),
                       v_Custom_Fte_Name) as Fte_Name,
                   (select k.Name
                      from Hrm_Wage_Scales k
                     where k.Company_Id = Hr.Company_Id
                       and k.Filial_Id = Hr.Filial_Id
                       and k.Wage_Scale_Id = Hr.Wage_Scale_Id) as Wage_Scale_Name,
                   c.Contract_Number,
                   Hpd_Util.t_Cv_Contract_Kind(c.Contract_Kind) as Contract_Kind_Name,
                   case
                      when c.Access_To_Add_Item = 'Y' then
                       Ui.t_Yes
                      else
                       Ui.t_No
                    end as Access_To_Add_Item_Name,
                   c.Note,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => t.Job_Id,
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary_Job
              from Hpd_Journal_Pages q
              join Hpd_Hirings w
                on w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Page_Id = q.Page_Id
              join Hpd_Cv_Contracts c
                on c.Company_Id = q.Company_Id
               and c.Filial_Id = q.Filial_Id
               and c.Page_Id = q.Page_Id
              left join Hpd_Page_Robots m
                on m.Company_Id = q.Company_Id
               and m.Filial_Id = q.Filial_Id
               and m.Page_Id = q.Page_Id
              left join Hpd_Page_Schedules s
                on s.Company_Id = q.Company_Id
               and s.Filial_Id = q.Filial_Id
               and s.Page_Id = q.Page_Id
              left join Hpd_Page_Currencies Pc
                on Pc.Company_Id = q.Company_Id
               and Pc.Filial_Id = q.Filial_Id
               and Pc.Page_Id = q.Page_Id
              left join Mrf_Robots t
                on t.Company_Id = m.Company_Id
               and t.Filial_Id = m.Filial_Id
               and t.Robot_Id = m.Robot_Id
              left join Hrm_Robots Hr
                on Hr.Company_Id = m.Company_Id
               and Hr.Filial_Id = m.Filial_Id
               and Hr.Robot_Id = m.Robot_Id
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Journal_Id = i_Journal_Id) Hir;
  
    Result.Put('hirings', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id, q.Oper_Type_Id, w.Name, w.Operation_Kind)
      bulk collect
      into v_Matrix
      from Hpd_Page_Oper_Types q
      join Mpr_Oper_Types w
        on w.Company_Id = q.Company_Id
       and w.Oper_Type_Id = q.Oper_Type_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id,
                          q.Oper_Type_Id,
                          w.Indicator_Id,
                          w.Name,
                          (select w.Indicator_Value
                             from Hpd_Page_Indicators w
                            where w.Company_Id = i_Company_Id
                              and w.Filial_Id = i_Filial_Id
                              and w.Page_Id = q.Page_Id
                              and w.Indicator_Id = q.Indicator_Id))
      bulk collect
      into v_Matrix
      from Hpd_Oper_Type_Indicators q
      join Href_Indicators w
        on w.Company_Id = i_Company_Id
       and w.Indicator_Id = q.Indicator_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null)
     order by w.Name;
  
    Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(c.Page_Id, q.Contract_Item_Id, q.Name, q.Quantity, q.Amount)
      bulk collect
      into v_Matrix
      from Hpd_Cv_Contracts c
      join Hpd_Cv_Contract_Items q
        on q.Company_Id = c.Company_Id
       and q.Filial_Id = c.Filial_Id
       and q.Contract_Id = c.Contract_Id
     where c.Company_Id = i_Company_Id
       and c.Filial_Id = i_Filial_Id
       and c.Page_Id in (select *
                           from table(v_Full_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('contract_services', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(c.Page_Id,
                          q.File_Sha,
                          (select s.File_Name
                             from Biruni_Files s
                            where s.Sha = q.File_Sha),
                          q.Note)
      bulk collect
      into v_Matrix
      from Hpd_Cv_Contracts c
      join Hpd_Cv_Contract_Files q
        on q.Company_Id = c.Company_Id
       and q.Filial_Id = c.Filial_Id
       and q.Contract_Id = c.Contract_Id
     where c.Company_Id = i_Company_Id
       and c.Filial_Id = i_Filial_Id
       and c.Page_Id in (select *
                           from table(v_Full_Page_Ids)
                          where Column_Value is not null);
  
    Result.Put('contract_files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    result    Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Uit_Hpd.Access_To_Journal_Sign_Document(r_Journal.Journal_Id) then
      for r in (select q.Staff_Id
                  from Hpd_Journal_Pages q
                 where q.Company_Id = r_Journal.Company_Id
                   and q.Filial_Id = r_Journal.Filial_Id
                   and q.Journal_Id = r_Journal.Journal_Id)
      loop
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
      end loop;
    end if;
  
    if not Hpd_Util.Is_Contractor_Journal(i_Company_Id      => Ui.Company_Id,
                                          i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
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
  
    Result.Put_All(Get_Hirings(i_Company_Id => r_Journal.Company_Id,
                               i_Filial_Id  => r_Journal.Filial_Id,
                               i_Journal_Id => r_Journal.Journal_Id));
    Result.Put('references', References);
  
    return result;
  end;

end Ui_Vhr657;
/
