create or replace package Uit_Htm is
  ----------------------------------------------------------------------------------------------------
  Function Load_Recommended_Rank_Staffs
  (
    i_Document_Id   number,
    i_Document_Date date,
    i_Division_Id   number
  ) return Json_Array_t;
end Uit_Htm;
/
create or replace package body Uit_Htm is
  ----------------------------------------------------------------------------------------------------
  Function Take_Penalty_Period
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Trans_Id   number,
    i_Staff_Id   number
  ) return number is
    result number;
  begin
    select St.Penalty_Period
      into result
      from Hpd_Transactions q
      join Htm_Recommended_Rank_Documents p
        on p.Company_Id = q.Company_Id
       and p.Filial_Id = q.Filial_Id
       and p.Journal_Id = q.Journal_Id
       and p.Status = Htm_Pref.c_Document_Status_Approved
      join Htm_Recommended_Rank_Staffs St
        on St.Company_Id = p.Company_Id
       and St.Filial_Id = p.Filial_Id
       and St.Document_Id = p.Document_Id
       and St.Staff_Id = i_Staff_Id
       and St.Increment_Status = Htm_Pref.c_Increment_Status_Success
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Trans_Id = i_Trans_Id
       and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank
       and Rownum = 1;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Recommended_Rank_Staffs
  (
    i_Document_Id   number,
    i_Document_Date date,
    i_Division_Id   number
  ) return Json_Array_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Period             date;
    v_Rank_Id            number;
    v_Experience_Id      number;
    v_Rank_Trans_Id      number;
    v_Temp_Job_Id        number;
    v_Temp_Rank_Id       number;
    v_Temp_Experience_Id number;
    r_Robot              Mrf_Robots%rowtype;
    v_Exist_After        varchar2(1);
  
    v_Tr_Trans_Id number;
    v_Tr_Action   varchar2(1);
    v_Tr_Period   date;
  
    r_Attempt              Htm_Experience_Period_Attempts%rowtype;
    r_Job_Rank             Htm_Experience_Job_Ranks%rowtype;
    v_Journal_Id           number;
    v_Division_Ids         Array_Number;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
  
    v_Attempt_No       number;
    v_Penalty_Period   number;
    v_Last_Failed_Date date;
  
    result Glist := Glist;
  begin
    v_Journal_Id := z_Htm_Recommended_Rank_Documents.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Document_Id => i_Document_Id).Journal_Id;
  
    if v_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    for r in (select s.Staff_Id,
                     s.Staff_Number,
                     (select Mp.Name
                        from Mr_Natural_Persons Mp
                       where Mp.Company_Id = v_Company_Id
                         and Mp.Person_Id = s.Employee_Id) as name
                from Href_Staffs s
               where s.Company_Id = v_Company_Id
                 and s.Filial_Id = v_Filial_Id
                 and s.Hiring_Date <= i_Document_Date
                 and (s.Dismissal_Date is null or s.Dismissal_Date >= i_Document_Date)
                 and s.State = 'A')
    loop
      continue when v_Access_All_Employees = 'N' and Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => v_Company_Id,
                                                                                      i_Filial_Id  => v_Filial_Id,
                                                                                      i_Staff_Id   => r.Staff_Id,
                                                                                      i_Period     => i_Document_Date) not member of v_Division_Ids;
      r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Filial_Id,
                                            i_Staff_Id   => r.Staff_Id,
                                            i_Period     => i_Document_Date);
    
      continue when i_Division_Id is not null and r_Robot.Division_Id <> i_Division_Id;
    
      -- agar dokument yaratilayotgan vaqtdan keyin yani kelajakda biror rank o'zgarishi bo'lsa bu holda ham
      -- recom rank dokument ishlatib bo'lmaydi
      begin
        select 'Y'
          into v_Exist_After
          from Hpd_Agreements q
         where q.Company_Id = v_Company_Id
           and q.Filial_Id = v_Filial_Id
           and q.Staff_Id = r.Staff_Id
           and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Rank
           and q.Period > i_Document_Date
           and Rownum = 1;
      exception
        when No_Data_Found then
          v_Exist_After := 'N';
      end;
    
      continue when v_Exist_After = 'Y';
    
      v_Period             := null;
      v_Rank_Id            := null;
      v_Experience_Id      := null;
      v_Rank_Trans_Id      := null;
      v_Temp_Job_Id        := null;
      v_Temp_Rank_Id       := null;
      v_Temp_Experience_Id := null;
    
      for Pr in (select q.Period
                   from Hpd_Agreements q
                  where q.Company_Id = v_Company_Id
                    and q.Filial_Id = v_Filial_Id
                    and q.Staff_Id = r.Staff_Id
                    and q.Trans_Type in
                        (Hpd_Pref.c_Transaction_Type_Robot, Hpd_Pref.c_Transaction_Type_Rank)
                    and q.Period <= i_Document_Date
                  group by q.Period
                  order by q.Period desc)
      loop
        Hpd_Util.Closest_Trans_Info(i_Company_Id       => v_Company_Id,
                                    i_Filial_Id        => v_Filial_Id,
                                    i_Staff_Id         => r.Staff_Id,
                                    i_Trans_Type       => Hpd_Pref.c_Transaction_Type_Rank,
                                    i_Period           => Pr.Period,
                                    i_Except_Jounal_Id => v_Journal_Id,
                                    o_Trans_Id         => v_Tr_Trans_Id,
                                    o_Action           => v_Tr_Action,
                                    o_Period           => v_Tr_Period);
      
        if v_Tr_Action = Hpd_Pref.c_Transaction_Action_Continue and v_Tr_Trans_Id is not null then
          v_Temp_Rank_Id := z_Hpd_Trans_Ranks.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Trans_Id => v_Tr_Trans_Id).Rank_Id;
        end if;
      
        v_Temp_Job_Id := Hpd_Util.Get_Closest_Job_Id(i_Company_Id => v_Company_Id,
                                                     i_Filial_Id  => v_Filial_Id,
                                                     i_Staff_Id   => r.Staff_Id,
                                                     i_Period     => Pr.Period);
      
        begin
          select q.Experience_Id
            into v_Temp_Experience_Id
            from Htm_Experience_Jobs q
           where q.Company_Id = v_Company_Id
             and q.Filial_Id = v_Filial_Id
             and q.Job_Id = v_Temp_Job_Id;
        exception
          when No_Data_Found then
            v_Temp_Experience_Id := null;
        end;
      
        if v_Rank_Id is null then
          -- agar rank dokument ochilgan vaqtgacha o'rnatilinmagan bo'lsa, recom dok ishlamaydi!
          if v_Temp_Rank_Id is null then
            exit;
          end if;
        
          v_Period        := Pr.Period;
          v_Rank_Id       := v_Temp_Rank_Id;
          v_Experience_Id := v_Temp_Experience_Id;
          v_Rank_Trans_Id := v_Tr_Trans_Id;
        elsif Fazo.Equal(v_Rank_Id, v_Temp_Rank_Id) and
              Fazo.Equal(v_Experience_Id, v_Temp_Experience_Id) then
          v_Period := Pr.Period;
        else
          exit;
        end if;
      end loop;
    
      r_Job_Rank := z_Htm_Experience_Job_Ranks.Take(i_Company_Id   => v_Company_Id,
                                                    i_Filial_Id    => v_Filial_Id,
                                                    i_Job_Id       => r_Robot.Job_Id,
                                                    i_From_Rank_Id => v_Rank_Id);
    
      select count(*), max(q.New_Change_Date)
        into v_Attempt_No, v_Last_Failed_Date
        from Htm_Recommended_Rank_Staffs q
        join Htm_Recommended_Rank_Documents p
          on p.Company_Id = v_Company_Id
         and p.Filial_Id = v_Filial_Id
         and p.Document_Id = q.Document_Id
         and p.Status = Htm_Pref.c_Document_Status_Approved
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.Staff_Id = r.Staff_Id
         and q.From_Rank_Id = r_Job_Rank.From_Rank_Id
         and q.To_Rank_Id = r_Job_Rank.To_Rank_Id
         and q.Increment_Status = Htm_Pref.c_Increment_Status_Failure
         and q.New_Change_Date between v_Period and i_Document_Date;
    
      v_Attempt_No := Nvl(v_Attempt_No, 0) + 1;
    
      if v_Attempt_No > 1 then
        v_Period := v_Last_Failed_Date;
      end if;
    
      r_Attempt := z_Htm_Experience_Period_Attempts.Take(i_Company_Id    => v_Company_Id,
                                                         i_Filial_Id     => v_Filial_Id,
                                                         i_Experience_Id => r_Job_Rank.Experience_Id,
                                                         i_From_Rank_Id  => r_Job_Rank.From_Rank_Id,
                                                         i_Attempt_No    => v_Attempt_No);
    
      v_Penalty_Period := Nvl(Take_Penalty_Period(i_Company_Id => v_Company_Id,
                                                  i_Filial_Id  => v_Filial_Id,
                                                  i_Trans_Id   => v_Rank_Trans_Id,
                                                  i_Staff_Id   => r.Staff_Id),
                              0);
    
      continue when r_Attempt.Company_Id is null or(i_Document_Date - v_Period) < r_Attempt.Period - r_Attempt.Nearest + v_Penalty_Period;
    
      Result.Push(Array_Varchar2(r.Staff_Id,
                                 r.Staff_Number,
                                 r.Name,
                                 r_Robot.Robot_Id,
                                 r_Robot.Name,
                                 r_Job_Rank.From_Rank_Id,
                                 z_Mhr_Ranks.Load       (i_Company_Id => r_Job_Rank.Company_Id, --
                                         i_Filial_Id => r_Job_Rank.Filial_Id, --
                                         i_Rank_Id => r_Job_Rank.From_Rank_Id).Name,
                                 v_Period,
                                 r_Job_Rank.To_Rank_Id,
                                 z_Mhr_Ranks.Load       (i_Company_Id => r_Job_Rank.Company_Id, --
                                         i_Filial_Id => r_Job_Rank.Filial_Id, --
                                         i_Rank_Id => r_Job_Rank.To_Rank_Id).Name,
                                 i_Document_Date,
                                 r_Attempt.Period,
                                 r_Attempt.Nearest,
                                 v_Penalty_Period,
                                 z_Mhr_Divisions.Load   (i_Company_Id => r_Robot.Company_Id, --
                                     i_Filial_Id => r_Robot.Filial_Id, --
                                     i_Division_Id => r_Robot.Division_Id).Name,
                                 z_Mhr_Jobs.Load        (i_Company_Id => r_Robot.Company_Id, --
                                          i_Filial_Id => r_Robot.Filial_Id, --
                                          i_Job_Id => r_Robot.Job_Id).Name,
                                 r_Attempt.Experience_Id,
                                 r_Attempt.Attempt_No,
                                 '')); -- Note
    end loop;
  
    return Result.Val;
  end;

end Uit_Htm;
/
