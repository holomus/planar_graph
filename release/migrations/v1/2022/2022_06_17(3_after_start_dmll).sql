prompt migr from 17.06.2022 after start dml
----------------------------------------------------------------------------------------------------
prompt adding 'limit change' journal type
---------------------------------------------------------------------------------------------------- 
declare
  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    r_Journal_Type Hpd_Journal_Types%rowtype;
  begin
    begin
      select *
        into r_Journal_Type
        from Hpd_Journal_Types
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Journal_Type.Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => i_Company_Id,
                                 i_Journal_Type_Id => r_Journal_Type.Journal_Type_Id,
                                 i_Name            => Nvl(r_Journal_Type.Name, i_Name),
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  for Cmp in (select *
                from Md_Companies q)
  loop
    Journal_Type(Cmp.Company_Id,
                 'Изменение количества отпускных дней',
                 10,
                 Hpd_Pref.c_Pcode_Journal_Type_Limit_Change);
    Journal_Type(Cmp.Company_Id,
                 'Больничный лист',
                 11,
                 Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
    Journal_Type(Cmp.Company_Id,
                 'Командировка',
                 12,
                 Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
    Journal_Type(Cmp.Company_Id, 'Отпуск', 13, Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt location add persons working attached divisions
----------------------------------------------------------------------------------------------------
declare
  v_date date := trunc(sysdate);
begin
  for c in (select *
              from Md_Companies Com
             where Com.State = 'A'
               and (exists (select 1
                      from Md_Company_Projects p
                     where p.Company_Id = Com.Company_Id
                       and p.Project_Code = Href_Pref.c_Pc_Verifix_Hr) or
                    Com.Company_Id = Md_Pref.c_Company_Head))
  loop 
    Biruni_Route.Context_Begin;    
    Ui_Context.Init_Migr(i_Company_Id   => c.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(c.Company_Id),
                         i_User_Id      => Md_Pref.User_System(c.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
                         
    for f in (select *
                from Md_Filials Fil
               where Fil.Company_Id = c.Company_Id
                 and Fil.State = 'A')
    loop
      for r in (select q.Company_Id, q.Filial_Id, q.Location_Id, w.Employee_Id
                  from Htt_Location_Divisions q
                  join Href_Staffs w
                    on w.Company_Id = q.Company_Id
                   and w.Filial_Id = q.Filial_Id
                   and w.Division_Id = q.Division_Id
                   and w.Hiring_Date <= v_date
                   and (w.Dismissal_Date is null or w.Dismissal_Date > v_date)
                   and w.State = 'A'
                 where q.Company_Id = f.Company_Id
                   and q.Filial_Id = f.Filial_Id
                 group by q.Company_Id, q.Filial_Id, q.Location_Id, w.Employee_Id)
      loop
        Htt_Api.Location_Add_Person(i_Company_Id  => r.company_id,
                                    i_Filial_Id   => r.filial_id,
                                    i_Location_Id => r.location_id,
                                    i_Person_Id   => r.employee_id,
                                    i_Attach_Type => Htt_Pref.c_Attach_Type_Auto);
      end loop;
    end loop;  
    Biruni_Route.Context_End();
    
    commit;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
prompt filial level timepad pref save to company level
----------------------------------------------------------------------------------------------------
declare
  v_Settings Hes_Pref.Timepad_Track_Settings_Rt;
begin
  for Cmp in (select c.Company_Id, c.Filial_Head, c.User_System
                from Md_Company_Infos c
               where exists
               (select 1
                        from Md_Companies q
                       where q.Company_Id = c.Company_Id
                         and q.State = 'A'
                         and exists (select 1
                                from Md_Company_Projects Cp
                               where Cp.Company_Id = q.Company_Id
                                 and Cp.Project_Code = Href_Pref.c_Pc_Verifix_Hr)))
  loop
    Biruni_Route.Context_Begin;
    Ui_Context.Init(i_User_Id      => Cmp.User_System,
                    i_Project_Code => Href_Pref.c_Pc_Verifix_Hr,
                    i_Filial_Id    => Cmp.Filial_Head);
  
    for Fil in (select f.Filial_Id
                  from Md_Filials f
                 where f.Company_Id = Cmp.Company_Id
                   and f.Filial_Id <> Cmp.Filial_Head)
    loop
      v_Settings.Track_Types   := Md_Pref.Load(i_Company_Id => Cmp.Company_Id,
                                               i_Filial_Id  => Fil.Filial_Id,
                                               i_Code       => Hes_Pref.c_Timepad_Track_Types);
      v_Settings.Mark_Types    := Md_Pref.Load(i_Company_Id => Cmp.Company_Id,
                                               i_Filial_Id  => Fil.Filial_Id,
                                               i_Code       => Hes_Pref.c_Timepad_Mark_Types);
      v_Settings.Emotion_Types := Md_Pref.Load(i_Company_Id => Cmp.Company_Id,
                                               i_Filial_Id  => Fil.Filial_Id,
                                               i_Code       => Hes_Pref.c_Timepad_Emotion_Types);
      v_Settings.Lang_Code     := Md_Pref.Load(i_Company_Id => Cmp.Company_Id,
                                               i_Filial_Id  => Fil.Filial_Id,
                                               i_Code       => Hes_Pref.c_Timepad_Lang_Code);
    
      continue when v_Settings.Track_Types is null and v_Settings.Mark_Types is null and v_Settings.Emotion_Types is null and v_Settings.Lang_Code is null;
    
      Hes_Api.Timepad_Track_Settings_Save(i_Company_Id => Cmp.Company_Id, i_Settings => v_Settings);
    end loop;
  
    Biruni_Route.Context_End;
  
    commit;
  end loop;
end;
/


