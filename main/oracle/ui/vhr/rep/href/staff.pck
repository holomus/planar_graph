create or replace package Ui_Vhr583 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Document_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedule return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr583;
/
create or replace package body Ui_Vhr583 is
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
    return b.Translate('UI-VHR583:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Division_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_division_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('division_group_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.staff_id,
                            (select w.name
                               from mr_natural_persons w
                              where w.company_id = q.company_id
                                and w.person_id = q.employee_id) as name,
                            q.hiring_date,
                            q.dismissal_date
                       from href_staffs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('staff_id');
    q.Varchar2_Field('name', 'state');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Document_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_document_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('doc_type_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_edu_stages',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('edu_stage_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Schedule return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('date', Trunc(sysdate));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Is_Department => 'Y')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Head
  (
    a      in out nocopy b_Table,
    i_Date date
  ) is
    v_Advanced_Org_Structure varchar2(1) := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Advanced_Org_Structure;
    v_Column                 number := 1;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name);
      a.Column_Width(v_Column, i_Column_Width);
      v_Column := v_Column + 1;
    end;
  begin
    a.New_Row;
    a.Data(t('date: $1', i_Date), i_Colspan => 4);
  
    a.Current_Style('header');
  
    a.New_Row;
    Print_Header('#', 75);
    Print_Header(t('name'), 200);
    Print_Header(t('hiring date'), 75);
    Print_Header(t('code'), 75);
    Print_Header(t('division group'), 200);
    Print_Header(t('division'), 200);
  
    if v_Advanced_Org_Structure = 'Y' then
      Print_Header(t('org unit'), 200);
    end if;
  
    Print_Header(t('job name'), 200);
    Print_Header(t('robot name'), 200);
    Print_Header(t('wage'), 100);
    Print_Header(t('rank name'), 200);
    Print_Header(t('gender'), 75);
    Print_Header(t('region'), 150);
    Print_Header(t('iapa'), 75);
    Print_Header(t('npin'), 75);
    Print_Header(t('birthday'), 75);
    Print_Header(t('address'), 200);
    Print_Header(t('phone'), 75);
    Print_Header(t('schedule'), 200);
    Print_Header(t('document seria'), 75);
    Print_Header(t('issued by'), 200);
    Print_Header(t('edu stages'), 300);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Date               date,
    i_Division_Group_Ids Array_Number,
    i_Division_Ids       Array_Number,
    i_Job_Ids            Array_Number,
    i_Staff_Ids          Array_Number,
    i_Edu_Stage_Ids      Array_Number,
    i_Schedule_Ids       Array_Number
  ) is
    v_Company_Id             number := Ui.Company_Id;
    v_Filial_Id              number := Ui.Filial_Id;
    v_Div_Group_Count        number := i_Division_Group_Ids.Count;
    v_Div_Count              number := i_Division_Ids.Count;
    v_Job_Count              number := i_Job_Ids.Count;
    v_Staff_Count            number := i_Staff_Ids.Count;
    v_Edu_Stages_Count       number := i_Edu_Stage_Ids.Count;
    v_Schedule_Count         number := i_Schedule_Ids.Count;
    v_Passport_Type_Id       number := Href_Util.Doc_Type_Id(i_Company_Id => v_Company_Id,
                                                             i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
    v_Advanced_Org_Structure varchar2(1) := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Advanced_Org_Structure;
    v_Max_Row                number;
    v_Access_All_Employees   varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Division_Ids           Array_Number := Array_Number();
    v_Subordinate_Chiefs     Array_Number := Array_Number();
    a                        b_Table := b_Report.New_Table();
    c                        b_Table;
  begin
    if v_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                           i_Direct             => true,
                                                           i_Indirect           => true,
                                                           i_Manual             => true,
                                                           i_Gather_Chiefs      => true);
    end if;
  
    -- print head
    Print_Head(a => a, i_Date => i_Date);
  
    a.Current_Style('body');
  
    -- body
    for r in (select Rownum,
                     Np.Name,
                     St.Hiring_Date,
                     Np.Code,
                     (select Dg.Name
                        from Mhr_Division_Groups Dg
                       where Dg.Company_Id = v_Company_Id
                         and Dg.Division_Group_Id = Dvs.Division_Group_Id) as Division_Group_Name,
                     Dvs.Name as Division_Name,
                     (select Org.Name
                        from Mhr_Divisions Org
                       where Org.Company_Id = St.Company_Id
                         and Org.Filial_Id = St.Filial_Id
                         and Org.Division_Id = St.Org_Unit_Id) Org_Unit_Name,
                     (select w.Name
                        from Mhr_Jobs w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Job_Id = Tr.Job_Id) as Job_Name,
                     Tr.Name as Robot_Name,
                     case
                        when Uit_Hrm.Access_To_Hidden_Salary_Job(Tr.Job_Id) = 'Y' then
                         Hpd_Util.Get_Closest_Wage(i_Company_Id => v_Company_Id,
                                                   i_Filial_Id  => v_Filial_Id,
                                                   i_Staff_Id   => Ag.Staff_Id,
                                                   i_Period     => i_Date)
                        else
                         -1
                      end as Wage,
                     (select w.Name
                        from Mhr_Ranks w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Rank_Id = Tra.Rank_Id) as Rank_Name,
                     Md_Util.t_Person_Gender(Np.Gender) as Gender_Name,
                     (select Reg.Name
                        from Md_Regions Reg
                       where Reg.Company_Id = v_Company_Id
                         and Reg.Region_Id = Md.Region_Id) as Region_Name,
                     Pd.Iapa as Iapa,
                     Pd.Npin as Npin,
                     Np.Birthday as Birthday,
                     Md.Address as Address,
                     (select w.Phone
                        from Md_Persons w
                       where w.Company_Id = v_Company_Id
                         and w.Person_Id = St.Employee_Id) as Phone,
                     (select w.Name
                        from Htt_Schedules w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Schedule_Id = Ag.Schedule_Id) as Schedule_Name,
                     (select w.Doc_Series || ' ' || w.Doc_Number
                        from Href_Person_Documents w
                       where w.Company_Id = v_Company_Id
                         and w.Person_Id = St.Employee_Id
                         and w.Doc_Type_Id = v_Passport_Type_Id
                         and Rownum = 1) as Document_Seria,
                     (select w.Issued_By
                        from Href_Person_Documents w
                       where w.Company_Id = v_Company_Id
                         and w.Person_Id = St.Employee_Id
                         and w.Doc_Type_Id = v_Passport_Type_Id
                         and Rownum = 1) as Issued_By,
                     cast(multiset (select Array_Varchar2(Es.Name, Rin.Name)
                             from Href_Person_Edu_Stages w
                             join Href_Edu_Stages Es
                               on Es.Company_Id = v_Company_Id
                              and Es.Edu_Stage_Id = w.Edu_Stage_Id
                             join Href_Institutions Rin
                               on Rin.Company_Id = v_Company_Id
                              and Rin.Institution_Id = w.Institution_Id
                            where w.Company_Id = v_Company_Id
                              and w.Person_Id = St.Employee_Id) as Matrix_Varchar2) as Edu_Stages
                from Hpd_Agreements_Cache Ag
                join Mrf_Robots Tr
                  on Tr.Company_Id = v_Company_Id
                 and Tr.Filial_Id = v_Filial_Id
                 and Tr.Robot_Id = Ag.Robot_Id
                 and (v_Div_Count = 0 or Tr.Division_Id member of i_Division_Ids)
                 and (v_Job_Count = 0 or Tr.Job_Id member of i_Job_Ids)
                join Mhr_Divisions Dvs
                  on Dvs.Company_Id = v_Company_Id
                 and Dvs.Filial_Id = v_Filial_Id
                 and Dvs.Division_Id = Tr.Division_Id
                 and (v_Div_Group_Count = 0 or Dvs.Division_Group_Id member of i_Division_Group_Ids)
                join Href_Staffs St
                  on St.Company_Id = v_Company_Id
                 and St.Filial_Id = v_Filial_Id
                 and St.Staff_Id = Ag.Staff_Id
                 and (v_Staff_Count = 0 or St.Staff_Id member of i_Staff_Ids)
                 and (v_Edu_Stages_Count = 0 or exists
                      (select 1
                         from Href_Person_Edu_Stages Est
                        where Est.Company_Id = v_Company_Id
                          and Est.Person_Id = St.Employee_Id
                          and Est.Edu_Stage_Id member of i_Edu_Stage_Ids))
                 and (v_Access_All_Employees = 'Y' or St.Org_Unit_Id member of
                      v_Division_Ids or St.Employee_Id member of v_Subordinate_Chiefs)
                join Mr_Natural_Persons Np
                  on Np.Company_Id = v_Company_Id
                 and Np.Person_Id = St.Employee_Id
                left join Href_Person_Details Pd
                  on Pd.Company_Id = v_Company_Id
                 and Pd.Person_Id = St.Employee_Id
                left join Mr_Person_Details Md
                  on Md.Company_Id = v_Company_Id
                 and Md.Person_Id = St.Employee_Id
                left join Hpd_Trans_Ranks Tra
                  on Tra.Company_Id = v_Company_Id
                 and Tra.Filial_Id = v_Filial_Id
                 and Tra.Trans_Id =
                     (select Agg.Trans_Id
                        from Hpd_Agreements Agg
                       where Agg.Company_Id = v_Company_Id
                         and Agg.Filial_Id = v_Filial_Id
                         and Agg.Staff_Id = Ag.Staff_Id
                         and Agg.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank
                         and Agg.Period = (select max(Pl.Period)
                                             from Hpd_Agreements Pl
                                            where Pl.Company_Id = v_Company_Id
                                              and Pl.Filial_Id = v_Filial_Id
                                              and Pl.Staff_Id = Ag.Staff_Id
                                              and Pl.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank
                                              and Pl.Period <= i_Date))
               where Ag.Company_Id = v_Company_Id
                 and Ag.Filial_Id = v_Filial_Id
                 and i_Date between Ag.Begin_Date and Ag.End_Date
                 and (v_Schedule_Count = 0 or Ag.Schedule_Id member of i_Schedule_Ids))
    loop
      v_Max_Row := 1;
      v_Max_Row := Greatest(v_Max_Row, r.Edu_Stages.Count);
    
      a.New_Row;
      a.Data(to_char(r.Rownum)); -- Excel ga dowload qilganda ###### formatda chiqib qolgani uchun to_char ishlatildi
      a.Data(r.Name);
      a.Data(r.Hiring_Date);
      a.Data(r.Code);
      a.Data(r.Division_Group_Name);
      a.Data(r.Division_Name);
    
      if v_Advanced_Org_Structure = 'Y' then
        a.Data(r.Org_Unit_Name);
      end if;
    
      a.Data(r.Job_Name);
      a.Data(r.Robot_Name);
      a.Data(Md_Util.Decode(i_Kind        => r.Wage,
                            i_First_Kind  => -1,
                            i_First_Name  => t('no access'),
                            i_Second_Kind => null,
                            i_Second_Name => null,
                            i_Default     => to_char(r.Wage))); -- Excel ga dowload qilganda ###### formatda chiqib qolgani uchun to_char ishlatildi
      a.Data(r.Rank_Name);
      a.Data(r.Gender_Name);
      a.Data(r.Region_Name);
      a.Data(r.Iapa);
      a.Data(r.Npin);
      a.Data(r.Birthday);
      a.Data(r.Address);
      a.Data(r.Phone);
      a.Data(r.Schedule_Name);
      a.Data(r.Document_Seria);
      a.Data(r.Issued_By);
    
      c := b_Report.New_Table(a);
      for i in 1 .. r.Edu_Stages.Count
      loop
        c.New_Row;
        c.Data(r.Edu_Stages(i) (1));
        c.Data(r.Edu_Stages(i) (2));
      end loop;
    
      if not c.Is_Empty then
        if v_Max_Row > r.Edu_Stages.Count then
          c.New_Row();
          c.Data('', i_Rowspan => v_Max_Row - r.Edu_Stages.Count);
          c.Data('', i_Rowspan => v_Max_Row - r.Edu_Stages.Count);
        end if;
        a.Data(c);
      else
        a.Data;
      end if; -- edu stages
    end loop;
  
    b_Report.Add_Sheet(t('staffs'), a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    Run_All(i_Date               => Nvl(p.o_Date('date'), Trunc(sysdate)),
            i_Division_Group_Ids => Nvl(p.o_Array_Number('division_group_ids'), Array_Number()),
            i_Division_Ids       => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
            i_Job_Ids            => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
            i_Staff_Ids          => Nvl(p.o_Array_Number('staff_ids'), Array_Number()),
            i_Edu_Stage_Ids      => Nvl(p.o_Array_Number('edu_stage_ids'), Array_Number()),
            i_Schedule_Ids       => Nvl(p.o_Array_Number('schedule_ids'), Array_Number()));
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    null; -- TODO
  end;

end Ui_Vhr583;
/
