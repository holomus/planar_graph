create or replace package Ui_Vhr607 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(P1 Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
end Ui_Vhr607;
/
create or replace package body Ui_Vhr607 is
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
    return b.Translate('UI-VHR607:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_page_adjustments q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                       and exists (select 1
                              from hpd_journal_pages w
                             where w.company_id = q.t_company_id 
                               and w.filial_id = q.t_filial_id 
                               and w.journal_id = :journal_id
                               and w.page_id = q.page_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'page_id',
                   'person_id',
                   'free_time',
                   'overtime',
                   'turnout_time');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
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
  Function Get_Adjustments
  (
    i_Journal_Id      number,
    i_Posted          varchar2,
    i_Adjustment_Date date
  ) return Glist is
    v_Begin_Date      date;
    v_End_Date        date;
    v_Turnout_Tk      number;
    v_Plan_Time       number;
    v_Intime          number;
    v_Not_Worked_Time number;
    v_Dummy_Days      number;
    v_Adjustment      Glist;
    result            Glist := Glist;
  begin
    v_Begin_Date := Trunc(i_Adjustment_Date, 'mon');
    v_End_Date   := Last_Day(i_Adjustment_Date);
    v_Turnout_Tk := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    for r in (select q.Staff_Id,
                     (select k.Name
                        from Mr_Natural_Persons k
                       where k.Company_Id = q.Company_Id
                         and k.Person_Id = q.Employee_Id) as Staff_Name,
                     a.Kind,
                     a.Free_Time,
                     a.Overtime,
                     a.Turnout_Time,
                     q.Page_Id,
                     t.Begin_Time,
                     t.End_Time,
                     t.Day_Kind,
                     t.Input_Time,
                     t.Output_Time,
                     t.Plan_Time
                from Hpd_Journal_Pages q
                join Hpd_Page_Adjustments a
                  on a.Company_Id = Ui.Company_Id
                 and a.Filial_Id = Ui.Filial_Id
                 and a.Page_Id = q.Page_Id
                left join Htt_Timesheets t
                  on t.Company_Id = q.Company_Id
                 and t.Filial_Id = q.Filial_Id
                 and t.Staff_Id = q.Staff_Id
                 and t.Timesheet_Date = i_Adjustment_Date
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Journal_Id = i_Journal_Id)
    loop
      v_Adjustment := Glist;
    
      v_Adjustment.Push(r.Staff_Id);
      v_Adjustment.Push(r.Staff_Name);
      v_Adjustment.Push(r.Kind);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Intime,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => Ui.Company_Id,
                                    i_Filial_Id    => Ui.Filial_Id,
                                    i_Staff_Id     => r.Staff_Id,
                                    i_Time_Kind_Id => v_Turnout_Tk,
                                    i_Begin_Date   => i_Adjustment_Date,
                                    i_End_Date     => i_Adjustment_Date);
    
      -- plan begin and end time
      case r.Day_Kind
        when Htt_Pref.c_Day_Kind_Work then
          v_Adjustment.Push(to_char(r.Begin_Time, Href_Pref.c_Time_Format_Minute) || '-' ||
                            to_char(r.End_Time, Href_Pref.c_Time_Format_Minute));
        when Htt_Pref.c_Day_Kind_Rest then
          v_Adjustment.Push(t('rest day'));
        when Htt_Pref.c_Day_Kind_Holiday then
          v_Adjustment.Push(t('holiday'));
        when Htt_Pref.c_Day_Kind_Nonworking then
          v_Adjustment.Push(t('nonworking day'));
        else
          v_Adjustment.Push('');
      end case;
      v_Adjustment.Push(Trunc(r.Plan_Time / 60)); -- plan time
    
      -- fact begin and end time
      v_Adjustment.Push(Nvl(to_char(r.Input_Time, Href_Pref.c_Time_Format_Minute), t('no data')) || '-' ||
                        Nvl(to_char(r.Output_Time, Href_Pref.c_Time_Format_Minute), t('no data'))); -- input output time
      v_Adjustment.Push(Trunc(v_Intime / 60)); -- intime
    
      v_Adjustment.Push(r.Free_Time);
      v_Adjustment.Push(r.Overtime);
      v_Adjustment.Push(r.Turnout_Time);
    
      v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => Ui.Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id,
                                                   i_Staff_Id   => r.Staff_Id,
                                                   i_Begin_Date => v_Begin_Date,
                                                   i_End_Date   => v_End_Date);
    
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Intime,
                                    o_Fact_Days    => v_Dummy_Days,
                                    i_Company_Id   => Ui.Company_Id,
                                    i_Filial_Id    => Ui.Filial_Id,
                                    i_Staff_Id     => r.Staff_Id,
                                    i_Time_Kind_Id => v_Turnout_Tk,
                                    i_Begin_Date   => v_Begin_Date,
                                    i_End_Date     => v_End_Date);
    
      v_Not_Worked_Time := Trunc(Greatest(v_Plan_Time - v_Intime, 0) / 60);
    
      if i_Posted = 'Y' then
        v_Not_Worked_Time := v_Not_Worked_Time + r.Turnout_Time;
      end if;
    
      v_Adjustment.Push(v_Not_Worked_Time); -- not worked time
      v_Adjustment.Push(r.Page_Id);
    
      Result.Push(v_Adjustment);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Gmap is
    result Gmap := Gmap;
  begin
    Result.Put('adjustment_kinds', Uit_Href.To_Glist(Hpd_Util.Adjustment_Kinds));
    Result.Put('ak_full', Hpd_Pref.c_Adjustment_Kind_Full);
    Result.Put('ak_incomplete', Hpd_Pref.c_Adjustment_Kind_Incomplete);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(P1 Json_Object_t) return Json_Object_t is
    r_Journal             Hpd_Journals%rowtype;
    r_Timebook_Adjustment Hpd_Journal_Timebook_Adjustments%rowtype;
    p                     Gmap := Gmap;
    result                Gmap := Gmap;
  begin
    p.Val := P1;
  
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Uit_Hpd.Access_To_Journal_Sign_Document(r_Journal.Journal_Id) then
      for r in (select s.Staff_Id
                  from Hpd_Journal_Staffs s
                 where s.Company_Id = r_Journal.Company_Id
                   and s.Filial_Id = r_Journal.Filial_Id
                   and s.Journal_Id = r_Journal.Journal_Id)
      loop
        Uit_Href.Assert_Access_To_Staff(r.Staff_Id);
      end loop;
    end if;
  
    Result.Put('journal_id', r_Journal.Journal_Id);
    Result.Put('journal_number', r_Journal.Journal_Number);
    Result.Put('journal_date', to_char(r_Journal.Journal_Date, Href_Pref.c_Date_Format_Day));
    Result.Put('journal_name', r_Journal.Journal_Name);
    Result.Put('sign_document_id', r_Journal.Sign_Document_Id);
    Result.Put('posted', r_Journal.Posted);
    Result.Put('sign_document_status',
               Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                  i_Document_Id => r_Journal.Sign_Document_Id));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => r_Journal.Created_By).Name);
    Result.Put('created_on', r_Journal.Created_On);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => r_Journal.Modified_By).Name);
    Result.Put('modified_on', r_Journal.Modified_On);
  
    r_Timebook_Adjustment := z_Hpd_Journal_Timebook_Adjustments.Load(i_Company_Id => r_Journal.Company_Id,
                                                                     i_Filial_Id  => r_Journal.Filial_Id,
                                                                     i_Journal_Id => r_Journal.Journal_Id);
  
    Result.Put('division_id', r_Timebook_Adjustment.Division_Id);
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Timebook_Adjustment.Division_Id).Name);
  
    Result.Put('adjustment_date', r_Timebook_Adjustment.Adjustment_Date);
    Result.Put('adjustments',
               Get_Adjustments(i_Journal_Id      => r_Journal.Journal_Id,
                               i_Posted          => r_Journal.Posted,
                               i_Adjustment_Date => r_Timebook_Adjustment.Adjustment_Date));
    Result.Put('references', References);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number;
  begin
    Hpd_Api.Journal_Post(i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Journal_Id => v_Journal_Id).Journal_Type_Id;
  
    Href_Core.Send_Notification(i_Company_Id    => Ui.Company_Id,
                                i_Filial_Id     => Ui.Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => Ui.Company_Id,
                                                                                              i_User_Id         => Ui.User_Id,
                                                                                              i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => Ui.Company_Id,
                                                                             i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number;
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    v_Journal_Type_Id := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Journal_Id => v_Journal_Id).Journal_Type_Id;
  
    Href_Core.Send_Notification(i_Company_Id    => Ui.Company_Id,
                                i_Filial_Id     => Ui.Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => Ui.Company_Id,
                                                                                                i_User_Id         => Ui.User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Util.Journal_View_Uri(i_Company_Id      => Ui.Company_Id,
                                                                             i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Page_Adjustments
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Page_Id               = null,
           Free_Time             = null,
           Overtime              = null,
           Turnout_Time          = null;
    update Hpd_Journal_Pages
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Page_Id    = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr607;
/
