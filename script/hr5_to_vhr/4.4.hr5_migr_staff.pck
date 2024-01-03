create or replace package Hr5_Migr_Staff is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Staff;
/
create or replace package body Hr5_Migr_Staff is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staffs is
    v_Total     number;
    v_Id        number;
    v_Region_Id number;
    v_Note      Mr_Person_Details.Note%type;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staffs', 'started Migr_Staffs');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staffs q
     where exists (select 1
              from Hr5_Migr_Keys_Store_One Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Ks.Old_Id = q.Staff_Id
               and not exists (select 1
                      from Href_Person_Details Pd
                     where Pd.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and Pd.Person_Id = Ks.New_Id));
  
    for r in (select q.*,
                     case
                        when exists (select 1
                                from Hr5_Mrf_Persons f
                               where f.Person_Id = q.Staff_Id) then
                         'Y'
                        else
                         'N'
                      end as Attached_To_Filial,
                     Rownum
                from Hr5_Hr_Staffs q
               where exists
               (select 1
                        from Hr5_Migr_Keys_Store_One Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Ks.Old_Id = q.Staff_Id
                         and not exists (select 1
                                from Href_Person_Details Pd
                               where Pd.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Pd.Person_Id = Ks.New_Id)))
    loop
      Dbms_Application_Info.Set_Module('Migr_Staffs',
                                       'inserted ' || (r.Rownum - 1) || ' Staff(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        if r.Address_Region_Id is not null then
          v_Region_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Mr_Region,
                                                  i_Old_Id     => r.Address_Region_Id);
        
          if v_Region_Id is null then
            b.Raise_Error('Migr_Staffs: new region id not found, old_region_id=$1, staff_id=$2',
                          r.Address_Region_Id,
                          r.Staff_Id);
          end if;
        else
          v_Region_Id := null;
        end if;
      
        v_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                         i_Old_Id     => r.Staff_Id);
      
        v_Note := '';
      
        if r.Citizenship_Country_Id is not null then
          v_Note := v_Note || 'Citizenship Country: ' || --
                    z_Md_Regions.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                    i_Region_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, i_Key_Name => Hr5_Migr_Pref.c_Mr_Region, i_Old_Id => r.Citizenship_Country_Id)).Name --
                    || Chr(10);
        end if;
      
        if r.Citizenship_Begin_Date is not null then
          v_Note := v_Note || 'Citizenship Begin: ' ||
                    to_char(r.Citizenship_Begin_Date, 'dd.mm.yyyy') || Chr(10);
        end if;
      
        if r.Birthplace_Country_Id is not null then
          v_Note := v_Note || 'Birthplace Country: ' || --
                    z_Md_Regions.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                    i_Region_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, i_Key_Name => Hr5_Migr_Pref.c_Mr_Region, i_Old_Id => r.Birthplace_Country_Id)).Name --
                    || Chr(10);
        end if;
      
        if r.Birthplace_Adress is not null then
          v_Note := v_Note || 'Birthplace Address: ' || r.Birthplace_Adress || Chr(10);
        end if;
      
        if r.Address_Zip_Code is not null then
          v_Note := v_Note || 'Address Zip Code: ' || r.Address_Zip_Code;
        end if;
      
        if r.Marriage_Condition_Id is not null then
          v_Note := v_Note || 'Marriage Condition: ' || --
                    z_Href_Marital_Statuses.Load(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                    i_Marital_Status_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id, --
                    i_Key_Name => Hr5_Migr_Pref.c_Ref_Marriage_Cond, --
                    i_Old_Id => r.Marriage_Condition_Id)).Name --
                    || Chr(10);
        end if;
      
        if r.Marriage_Condition_Date is not null then
          v_Note := v_Note || 'Marriage Condition Date: ' ||
                    to_char(r.Marriage_Condition_Date, 'dd.mm.yyyy');
        end if;
      
        z_Mr_Person_Details.Update_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                       i_Person_Id  => v_Id,
                                       i_Tin        => Option_Varchar2(Lower(r.Inn)),
                                       i_Address    => Option_Varchar2(r.Address_Registration),
                                       i_Region_Id  => Option_Number(v_Region_Id),
                                       i_Note       => Option_Varchar2(v_Note));
      
        if r.Attached_To_Filial = 'Y' then
          z_Mrf_Persons.Save_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                 i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                 i_Person_Id  => v_Id,
                                 i_State      => 'A');
        end if;
      
        z_Href_Person_Details.Insert_One(i_Company_Id           => Hr5_Migr_Pref.g_Company_Id,
                                         i_Person_Id            => v_Id,
                                         i_Iapa                 => r.Inps,
                                         i_Npin                 => null,
                                         i_Key_Person           => 'N',
                                         i_Access_All_Employees => 'N',
                                         i_Access_Hidden_Salary => 'N');
      
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staffs',
                                 i_Key_Id        => r.Staff_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staffs', 'finished Migr_Staffs');
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Employees is
    v_Total number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Employees', 'started Migr_Employees');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staffs q
     where exists (select 1
              from Hr5_Migr_Keys_Store_One Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Ks.Old_Id = q.Staff_Id
               and not exists (select 1
                      from Mhr_Employees e
                     where e.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and e.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                       and e.Employee_Id = Ks.New_Id))
       and exists (select 1
              from Hr5_Hr_Robot_Assignments a
             where a.Staff_Id = q.Staff_Id);
  
    for r in (select q.Staff_Id, q.Staff_Number, Ks.New_Id, Rownum
                from Hr5_Hr_Staffs q
                join Hr5_Migr_Keys_Store_One Ks
                  on Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                 and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                 and Ks.Old_Id = q.Staff_Id
                 and not exists (select 1
                        from Mhr_Employees e
                       where e.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and e.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and e.Employee_Id = Ks.New_Id)
               where exists (select 1
                        from Hr5_Hr_Robot_Assignments a
                       where a.Staff_Id = q.Staff_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Employees',
                                       'inserted ' || (r.Rownum - 1) || ' Employee(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        z_Mhr_Employees.Insert_One(i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Employee_Id     => r.New_Id,
                                   i_Employee_Number => r.Staff_Number,
                                   i_State           => 'A');
      
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staffs employee',
                                 i_Key_Id        => r.Staff_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Employees', 'finished Migr_Employees');
  end;

  ----------------------------------------------------------------------------------------------------             
  Procedure Migr_Candidates is
    v_Total          number;
    v_Id             number;
    v_Person_Type_Id number;
    v_Dummy          varchar2(1);
  begin
    Dbms_Application_Info.Set_Module('Migr_Candidates', 'started Migr_Candidates');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staffs k
      join Hr5_Mr_Natural_Persons t
        on t.Person_Id = k.Staff_Id
     where k.Position = 'C'
       and exists (select 1
              from Hr5_Mrf_Persons w
             where w.Person_Id = t.Person_Id)
       and not exists (select 1
              from Hr5_Migr_Keys_Store_Two Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Staff_Candidate
               and Ks.Old_Id = k.Staff_Id);
  
    for r in (select k.Staff_Id,
                     k.Date_Begin,
                     case
                        when exists (select 1
                                from Hr5_Hr_Robot_Assignments q
                               where q.State = 'D'
                                 and q.Doc_Type = 'M'
                                 and q.Staff_Id = k.Staff_Id) then
                         'F'
                        else
                         'N'
                      end as Candidate_Kind,
                     Rownum
                from Hr5_Hr_Staffs k
                join Hr5_Mr_Natural_Persons t
                  on t.Person_Id = k.Staff_Id
               where k.Position = 'C'
                 and exists (select 1
                        from Hr5_Mrf_Persons w
                       where w.Person_Id = t.Person_Id)
                 and not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Staff_Candidate
                         and Uk.Old_Id = k.Staff_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Candidates',
                                       'inserted ' || (r.Rownum - 1) || ' candidate(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                         i_Old_Id     => r.Staff_Id);
      
        z_Href_Candidates.Insert_One(i_Company_Id       => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id        => Hr5_Migr_Pref.g_Filial_Id,
                                     i_Candidate_Id     => v_Id,
                                     i_Candidate_Kind   => r.Candidate_Kind,
                                     i_Source_Id        => null,
                                     i_Wage_Expectation => null,
                                     i_Cv_Sha           => null,
                                     i_Note             => null);
      
        update Href_Candidates q
           set q.Created_On = r.Date_Begin
         where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
           and q.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
           and q.Company_Id = v_Id;
      
        for Job in (select *
                      from Hr5_Hr_Staff_Posts s
                     where s.Staff_Id = r.Staff_Id)
        loop
          z_Href_Candidate_Jobs.Insert_One(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id    => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Candidate_Id => v_Id,
                                           i_Job_Id       => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                      i_Key_Name   => Hr5_Migr_Pref.c_Ref_Post,
                                                                                      i_Old_Id     => Job.Post_Id,
                                                                                      i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id));
        end loop;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Staff_Candidate,
                                i_Old_Id     => r.Staff_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Href_Candidates',
                                 i_Key_Id        => r.Staff_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- insert new person category type, there is 4 types(A,B,C,XXX) on Makro
    -- 'XXX' is wanting type that default types not includes it
    begin
      select 'x'
        into v_Dummy
        from Mr_Person_Types t
       where t.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and t.Name = 'XXX';
    
    exception
      when No_Data_Found then
        z_Mr_Person_Types.Insert_One(i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                     i_Person_Type_Id  => Mr_Next.Person_Type_Id,
                                     i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(Hr5_Migr_Pref.g_Company_Id),
                                     i_Name            => 'XXX',
                                     i_Order_No        => 1,
                                     i_State           => 'A',
                                     i_Code            => null,
                                     i_Pcode           => null);
      
        commit;
    end;
  
    for type in (select *
                   from Hr5_Mr_Person_Type_Binds Tb
                   left join Hr5_Mr_Person_Types t
                     on Tb.Person_Type_Id = t.Person_Type_Id
                    and Tb.Person_Group_Id = t.Person_Group_Id
                  where Tb.Person_Group_Id = (select g.Person_Group_Id
                                                from Hr5_Mr_Person_Groups g
                                               where g.Pcode = 'anor:g2')
                    and not exists (select 1
                           from Hr5_Migr_Used_Keys Uk
                          where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                            and Uk.Key_Name = Hr5_Migr_Pref.c_Staff_Type_Bind
                            and Uk.Old_Id = Tb.Person_Id))
    loop
      begin
        savepoint Try_Catch;
      
        v_Person_Type_Id := Hr5_Migr_Util.Get_Person_Type_Id(i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                                             i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(Hr5_Migr_Pref.g_Company_Id),
                                                             i_Name            => Type.Name);
      
        z_Mr_Person_Type_Binds.Insert_One(i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                          i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(Hr5_Migr_Pref.g_Company_Id),
                                          i_Person_Id       => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                        i_Old_Id     => Type.Person_Id),
                                          i_Person_Type_Id  => v_Person_Type_Id);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Staff_Type_Bind,
                                i_Old_Id     => Type.Person_Id,
                                i_New_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                         i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                         i_Old_Id     => Type.Person_Id));
      
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Mr_Person_Type_Binds',
                                 i_Key_Id        => Type.Person_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Candidates', 'finished Migr_Candidates');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Pins is
    v_Total       number;
    v_Employee_Id number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Pins', 'started Migr_Staff_Pins');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staffs q
     where exists (select 1
              from Hr5_Migr_Keys_Store_One Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
               and Ks.Old_Id = q.Staff_Id
               and not exists (select 1
                      from Htt_Persons p
                     where p.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and p.Person_Id = Ks.New_Id
                       and p.Pin is not null));
  
    for r in (select q.Staff_Id, Rownum
                from Hr5_Hr_Staffs q
               where exists (select 1
                        from Hr5_Migr_Keys_Store_One Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Md_Person
                         and Ks.Old_Id = q.Staff_Id
                         and not exists (select 1
                                from Htt_Persons p
                               where p.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and p.Person_Id = Ks.New_Id
                                 and p.Pin is not null)))
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Pins',
                                       'migrated ' || (r.Rownum - 1) || '/' || v_Total || ' pin(s)');
    
      begin
        savepoint Try_Catch;
      
        v_Employee_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                  i_Old_Id     => r.Staff_Id);
      
        if z_Htt_Persons.Exist(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                               i_Person_Id  => v_Employee_Id) then
          z_Htt_Persons.Update_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                   i_Person_Id  => v_Employee_Id,
                                   i_Pin        => Option_Varchar2(r.Staff_Id));
        else
          z_Htt_Persons.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                   i_Person_Id  => v_Employee_Id,
                                   i_Pin        => r.Staff_Id,
                                   i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Employee_Id));
        end if;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staffs pins',
                                 i_Key_Id        => r.Staff_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Pins', 'finished Migr_Staff_Pins');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Documents is
    v_Total       number;
    v_Id          number;
    v_Doc_Type_Id number;
  
    --------------------------------------------------
    Function Next_Code_Number
    (
      i_Doc_Type_Id number,
      i_Code        varchar2
    ) return varchar2 is
      v_Order_No number;
      v_Len      number;
      v_Pos      number;
    begin
      if i_Code is null then
        return null;
      end if;
    
      v_Len := Length(i_Code);
      v_Pos := v_Len + 2;
    
      select Nvl(max(t.Order_No), -1)
        into v_Order_No
        from (select *
                from (select Nvl(Substr(Substr(q.Doc_Series || q.Doc_Number, v_Pos),
                                        1,
                                        Length(Substr(q.Doc_Series || q.Doc_Number, v_Pos)) - 1),
                                 0) as Order_No
                        from Href_Person_Documents q
                       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and q.Doc_Type_Id = i_Doc_Type_Id
                         and Substr(q.Doc_Series || q.Doc_Number, 1, v_Len) = i_Code) t
               where Regexp_Like(t.Order_No, '^[[:digit:]]+$')
               order by t.Order_No) t
       where t.Order_No = Rownum - 1;
    
      v_Order_No := v_Order_No + 1;
    
      if v_Order_No = 0 then
        return null;
      else
        return '(' || v_Order_No || ')';
      end if;
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Documents', 'started Migr_Staff_Documents');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Personal_Documents q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Personal_Document || q.Staff_Id)
               and Uk.Old_Id = q.Order_No);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Personal_Documents q
               where not exists
               (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Personal_Document || q.Staff_Id)
                         and Uk.Old_Id = q.Order_No)
               order by q.Staff_Id, q.Order_No)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Documents',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Staff Document(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id          := Href_Next.Person_Document_Id;
        v_Doc_Type_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Key_Name   => Hr5_Migr_Pref.c_Ref_Personal_Document,
                                                  i_Old_Id     => r.Document_Id);
      
        -- fix uniqueness
        r.Doc_Number := r.Doc_Number ||
                        Next_Code_Number(v_Doc_Type_Id, r.Doc_Series || r.Doc_Number);
      
        z_Href_Person_Documents.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                           i_Document_Id => v_Id,
                                           i_Person_Id   => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                     i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                     i_Old_Id     => r.Staff_Id),
                                           i_Doc_Type_Id => v_Doc_Type_Id,
                                           i_Doc_Series  => r.Doc_Series,
                                           i_Doc_Number  => r.Doc_Number,
                                           i_Issued_By   => r.Issued_By,
                                           i_Issued_Date => r.Issued_Date,
                                           i_Begin_Date  => r.Begin_Date,
                                           i_Expiry_Date => r.Expiry_Date,
                                           i_Is_Valid    => 'Y',
                                           i_Status      => Href_Pref.c_Person_Document_Status_New,
                                           i_Note        => r.Order_No);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => (Hr5_Migr_Pref.c_Staff_Personal_Document ||
                                                r.Staff_Id),
                                i_Old_Id     => r.Order_No,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Personal_Documents',
                                 i_Key_Id        => r.Order_No,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id: ' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Documents', 'finished Migr_Staff_Documents');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Relations is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Relations', 'started Migr_Staff_Relations');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Relationships q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Relationship || q.Staff_Id)
               and Uk.Old_Id = q.Order_No);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Relationships q
               where not exists
               (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Relationship || q.Staff_Id)
                         and Uk.Old_Id = q.Order_No)
               order by q.Staff_Id, q.Order_No)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Relations',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Staff Relationship(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Person_Family_Member_Id;
      
        z_Href_Person_Family_Members.Insert_One(i_Company_Id              => Hr5_Migr_Pref.g_Company_Id,
                                                i_Person_Family_Member_Id => v_Id,
                                                i_Person_Id               => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                                      i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                                      i_Old_Id     => r.Staff_Id),
                                                i_Name                    => r.Full_Name,
                                                i_Relation_Degree_Id      => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                                      i_Key_Name   => Hr5_Migr_Pref.c_Ref_Relationship,
                                                                                                      i_Old_Id     => r.Relationship_Id),
                                                i_Birthday                => r.Birthday,
                                                i_Is_Dependent            => 'N',
                                                i_Is_Private              => 'N');
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => (Hr5_Migr_Pref.c_Staff_Relationship || r.Staff_Id),
                                i_Old_Id     => r.Order_No,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Relationships',
                                 i_Key_Id        => r.Order_No,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id: ' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Relations', 'finished Migr_Staff_Relations');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Educations is
    v_Total number;
    v_Id    number;
    v_Base  Href_Person_Edu_Stages.Base%type;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Educations', 'started Migr_Staff_Educations');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Educations q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Education || q.Staff_Id)
               and Uk.Old_Id = q.Order_No);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Educations q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Education || q.Staff_Id)
                         and Uk.Old_Id = q.Order_No)
               order by q.Staff_Id, q.Order_No)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Relations',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Staff Education(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        begin
          select q.Name || ' '
            into v_Base
            from Hr5_Hr_Ref_Education_Docs q
           where q.Document_Id = r.Educ_Document_Id;
        exception
          when No_Data_Found then
            v_Base := '';
        end;
      
        v_Base := v_Base || r.Doc_Series || r.Doc_Number || ' ' ||
                  to_char(r.Issued_Date, 'dd.mm.yyyy');
      
        v_Id := Href_Next.Person_Edu_Stage_Id;
      
        z_Href_Person_Edu_Stages.Insert_One(i_Company_Id          => Hr5_Migr_Pref.g_Company_Id,
                                            i_Person_Edu_Stage_Id => v_Id,
                                            i_Person_Id           => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                              i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                              i_Old_Id     => r.Staff_Id),
                                            i_Edu_Stage_Id        => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                              i_Key_Name   => Hr5_Migr_Pref.c_Ref_Education_Type,
                                                                                              i_Old_Id     => r.Education_Type_Id),
                                            i_Institution_Id      => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                              i_Key_Name   => Hr5_Migr_Pref.c_Ref_Institution,
                                                                                              i_Old_Id     => r.Institution_Id),
                                            i_Begin_Date          => r.Date_Begin,
                                            i_End_Date            => r.Date_End,
                                            i_Specialty_Id        => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                              i_Key_Name   => Hr5_Migr_Pref.c_Ref_Speciality,
                                                                                              i_Old_Id     => r.Speciality_Id),
                                            i_Qualification       => r.Skill,
                                            i_Course              => null,
                                            i_Hour_Amount         => null,
                                            i_Base                => v_Base);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => (Hr5_Migr_Pref.c_Staff_Education || r.Staff_Id),
                                i_Old_Id     => r.Order_No,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Educations',
                                 i_Key_Id        => r.Order_No,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id: ' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Educations', 'finished Migr_Staff_Educations');
  end;

  /*----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Professions is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Professions', 'started Migr_Staff_Professions');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Professions q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Profession || q.Staff_Id)
               and Uk.Old_Id = q.Order_No);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Professions q
               where not exists
               (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Profession || q.Staff_Id)
                         and Uk.Old_Id = q.Order_No)
               order by q.Staff_Id, q.Order_No)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Professions',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Staff Profession(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Key_Name   => Hr5_Migr_Pref.c_Ref_Profession,
                                         i_Old_Id     => r.Profession_Id);
      
        z_Href_Person_Professions.Insert_Try(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                             i_Person_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                         i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                         i_Old_Id     => r.Staff_Id),
                                             i_Profession_Id => v_Id);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => (Hr5_Migr_Pref.c_Staff_Profession || r.Staff_Id),
                                i_Old_Id     => r.Order_No,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Professions',
                                 i_Key_Id        => r.Order_No,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id: ' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Professions', 'finished Migr_Staff_Professions');
  end;*/

  /*----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Specialities is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Specialities', 'started Migr_Staff_Specialities');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Specialities q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Speciality || q.Staff_Id)
               and Uk.Old_Id = q.Order_No);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Specialities q
               where not exists
               (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Speciality || q.Staff_Id)
                         and Uk.Old_Id = q.Order_No)
               order by q.Staff_Id, q.Order_No)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Specialities',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Staff Speciality(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Person_Specialty_Id;
      
        z_Href_Person_Specialties.Insert_One(i_Company_Id          => Hr5_Migr_Pref.g_Company_Id,
                                             i_Person_Specialty_Id => v_Id,
                                             i_Person_Id           => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                               i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                               i_Old_Id     => r.Staff_Id),
                                             i_Specialty_Id        => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                               i_Key_Name   => Hr5_Migr_Pref.c_Ref_Speciality,
                                                                                               i_Old_Id     => r.Speciality_Id),
                                             i_Awarded_Date        => r.Date_Begin,
                                             i_Expired_Date        => r.Date_End,
                                             i_Base                => null,
                                             i_Doc_Series          => null,
                                             i_Doc_Number          => null,
                                             i_Issued_By           => null);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => (Hr5_Migr_Pref.c_Staff_Speciality || r.Staff_Id),
                                i_Old_Id     => r.Order_No,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Specialities',
                                 i_Key_Id        => r.Order_No,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id: ' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Specialities', 'finished Migr_Staff_Specialities');
  end;*/

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Languages is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Languages', 'started Migr_Staff_Languages');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Languages q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Language || q.Staff_Id)
               and Uk.Old_Id = q.Lang_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Languages q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Language || q.Staff_Id)
                         and Uk.Old_Id = q.Lang_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Languages',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Staff Language(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                         i_Key_Name   => Hr5_Migr_Pref.c_Ref_Language,
                                         i_Old_Id     => r.Lang_Id);
      
        z_Href_Person_Langs.Insert_Try(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                       i_Person_Id     => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                   i_Old_Id     => r.Staff_Id),
                                       i_Lang_Id       => v_Id,
                                       i_Lang_Level_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Ref_Lang_Level,
                                                                                   i_Old_Id     => r.Lang_Level_Id));
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Staff_Language || r.Staff_Id,
                                i_Old_Id     => r.Lang_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Languages',
                                 i_Key_Id        => r.Lang_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id=' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Languages', 'finished Migr_Staff_Languages');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Cards is
    v_Total       number;
    v_Id          number;
    v_Bank_Id     number;
    v_Currency_Id number;
  
    --------------------------------------------------
    Procedure Get_Bank_Id is
      v_Code Mkcs_Banks.Bank_Code%type := '01115';
    begin
      select q.Bank_Id
        into v_Bank_Id
        from Mkcs_Banks q
       where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and q.Bank_Code = v_Code;
    exception
      when No_Data_Found then
        b.Raise_Error('Migr_Staff_Cards: Get_Bank_Id: Bank id not found for bank_code=''01115''');
    end;
  
    --------------------------------------------------
    Procedure Get_Base_Currency_Id is
      v_Pcode Mk_Currencies.Pcode%type := 'ANOR:1';
    begin
      select Currency_Id
        into v_Currency_Id
        from Mk_Currencies
       where Company_Id = Hr5_Migr_Pref.g_Company_Id
         and Pcode = v_Pcode;
    exception
      when No_Data_Found then
        b.Raise_Error('Migr_Staff_Cards: Get_Base_Currency_Id: Base currency id not found for pcode=''ANOR:1''');
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Staff_Cards', 'started Migr_Staff_Cards');
  
    Get_Bank_Id;
    Get_Base_Currency_Id;
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Staff_Cards q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Card || q.Staff_Id)
               and Uk.Old_Id = q.Order_No);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Staff_Cards q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = (Hr5_Migr_Pref.c_Staff_Card || q.Staff_Id)
                         and Uk.Old_Id = q.Order_No)
               order by q.Staff_Id, q.Order_No)
    loop
      Dbms_Application_Info.Set_Module('Migr_Staff_Cards',
                                       'inserted ' || (r.Rownum - 1) || ' Staff Card(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Mkcs_Next.Bank_Account_Id;
      
        z_Mkcs_Bank_Accounts.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                        i_Bank_Account_Id   => v_Id,
                                        i_Bank_Id           => v_Bank_Id,
                                        i_Bank_Account_Code => r.Card_Number,
                                        i_Name              => r.Card_Number,
                                        i_Person_Id         => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                        i_Old_Id     => r.Staff_Id),
                                        i_Is_Main           => r.Main_Card,
                                        i_Currency_Id       => v_Currency_Id,
                                        i_Note              => null,
                                        i_Order_No          => r.Order_No,
                                        i_State             => 'A');
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => (Hr5_Migr_Pref.c_Staff_Card || r.Staff_Id),
                                i_Old_Id     => r.Order_No,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Staff_Cards',
                                 i_Key_Id        => r.Order_No,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace ||
                                                    ' staff_id: ' || r.Staff_Id);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Staff_Cards', 'finished Migr_Staff_Cards');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Staff_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Staffs;
    Migr_Employees;
    Migr_Candidates;
    Migr_Staff_Pins;
    Migr_Staff_Documents;
    Migr_Staff_Relations;
    Migr_Staff_Educations;
    -- Migr_Staff_Professions;
    -- Migr_Staff_Specialities;
    Migr_Staff_Languages;
    Migr_Staff_Cards;
  
    Hr5_Migr_Util.Clear;
  end;

end Hr5_Migr_Staff;
/
