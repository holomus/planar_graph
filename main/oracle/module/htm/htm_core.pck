create or replace package Htm_Core is
  ----------------------------------------------------------------------------------------------------
  -- Experience
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Experience_Job_Rank
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Experience_Job_Rank
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Update_Status
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Staffs      Htm_Pref.Recommended_Rank_Status_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------   
  Procedure Recommended_Rank_Document_Set_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Recommended_Rank_Document_Status_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Waiting
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
end Htm_Core;
/
create or replace package body Htm_Core is
  ----------------------------------------------------------------------------------------------------
  -- Experience
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Experience_Job_Rank
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Job_Id        number
  ) is
  begin
    insert into Htm_Experience_Job_Ranks
      (Company_Id, Filial_Id, Job_Id, From_Rank_Id, To_Rank_Id, Experience_Id)
      select q.Company_Id,
             q.Filial_Id,
             i_Job_Id as Job_Id,
             q.From_Rank_Id,
             q.To_Rank_Id,
             q.Experience_Id
        from Htm_Experience_Periods q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Experience_Id = i_Experience_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Experience_Job_Rank
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number
  ) is
  begin
    delete from Htm_Experience_Job_Ranks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Experience_Id = i_Experience_Id;
  
    for r in (select q.*
                from Htm_Experience_Jobs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Experience_Id = i_Experience_Id)
    loop
      Fix_Experience_Job_Rank(i_Company_Id    => r.Company_Id,
                              i_Filial_Id     => r.Filial_Id,
                              i_Experience_Id => r.Experience_Id,
                              i_Job_Id        => r.Job_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Experience_Job_Rank
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number
  ) is
  begin
    delete from Htm_Experience_Job_Ranks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Job_Id = i_Job_Id;
  
    for r in (select q.*
                from Htm_Experience_Jobs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Job_Id = i_Job_Id)
    loop
      Fix_Experience_Job_Rank(i_Company_Id    => r.Company_Id,
                              i_Filial_Id     => r.Filial_Id,
                              i_Experience_Id => r.Experience_Id,
                              i_Job_Id        => r.Job_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Update_Status
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Staffs      Htm_Pref.Recommended_Rank_Status_Nt
  ) is
    v_Staff           Htm_Pref.Recommended_Rank_Status_Rt;
    v_Indicator       Href_Pref.Indicator_Rt;
    v_Indicator_Value number;
  begin
    for i in 1 .. i_Staffs.Count
    loop
      v_Staff := i_Staffs(i);
    
      if z_Htm_Recommended_Rank_Staffs.Exist(i_Company_Id  => i_Company_Id,
                                             i_Filial_Id   => i_Filial_Id,
                                             i_Document_Id => i_Document_Id,
                                             i_Staff_Id    => v_Staff.Staff_Id) then
        z_Htm_Recommended_Rank_Staffs.Update_One(i_Company_Id       => i_Company_Id,
                                                 i_Filial_Id        => i_Filial_Id,
                                                 i_Document_Id      => i_Document_Id,
                                                 i_Staff_Id         => v_Staff.Staff_Id,
                                                 i_Increment_Status => Option_Varchar2(v_Staff.Increment_Status));
      
        for j in 1 .. v_Staff.Indicators.Count
        loop
          v_Indicator := v_Staff.Indicators(j);
        
          v_Indicator_Value := Round(Greatest(Nvl(v_Indicator.Indicator_Value, 0), 0));
        
          if z_Htm_Recommended_Rank_Staff_Indicators.Exist(i_Company_Id   => i_Company_Id,
                                                           i_Filial_Id    => i_Filial_Id,
                                                           i_Document_Id  => i_Document_Id,
                                                           i_Staff_Id     => v_Staff.Staff_Id,
                                                           i_Indicator_Id => v_Indicator.Indicator_Id) then
            z_Htm_Recommended_Rank_Staff_Indicators.Update_One(i_Company_Id      => i_Company_Id,
                                                               i_Filial_Id       => i_Filial_Id,
                                                               i_Document_Id     => i_Document_Id,
                                                               i_Staff_Id        => v_Staff.Staff_Id,
                                                               i_Indicator_Id    => v_Indicator.Indicator_Id,
                                                               i_Indicator_Value => Option_Number(v_Indicator_Value));
          end if;
        end loop;
      end if;
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Recommended_Rank_Document_Status_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in (Htm_Pref.c_Document_Status_Set_Training) then
      Htm_Error.Raise_005(i_Document_Number  => r_Document.Document_Number,
                          i_Document_Status  => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_New),
                          i_Current_Status   => Htm_Util.t_Document_Status(r_Document.Status),
                          i_Allowed_Statuses => Array_Varchar2(Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Set_Training)));
    end if;
  
    z_Htm_Recommended_Rank_Documents.Update_One(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Document_Id => i_Document_Id,
                                                i_Status      => Option_Varchar2(Htm_Pref.c_Document_Status_New));
  
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Recommended_Rank_Document_Set_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in
       (Htm_Pref.c_Document_Status_New, Htm_Pref.c_Document_Status_Training) then
      Htm_Error.Raise_005(i_Document_Number  => r_Document.Document_Number,
                          i_Document_Status  => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Set_Training),
                          i_Current_Status   => Htm_Util.t_Document_Status(r_Document.Status),
                          i_Allowed_Statuses => Array_Varchar2(Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_New),
                                                               Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Training)));
    end if;
  
    z_Htm_Recommended_Rank_Documents.Update_One(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Document_Id => i_Document_Id,
                                                i_Status      => Option_Varchar2(Htm_Pref.c_Document_Status_Set_Training));
  
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Recommended_Rank_Document_Status_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in
       (Htm_Pref.c_Document_Status_Set_Training, Htm_Pref.c_Document_Status_Waiting) then
      Htm_Error.Raise_005(i_Document_Number  => r_Document.Document_Number,
                          i_Document_Status  => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Training),
                          i_Current_Status   => Htm_Util.t_Document_Status(r_Document.Status),
                          i_Allowed_Statuses => Array_Varchar2(Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Set_Training),
                                                               Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Waiting)));
    end if;
  
    z_Htm_Recommended_Rank_Documents.Update_One(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Document_Id => i_Document_Id,
                                                i_Status      => Option_Varchar2(Htm_Pref.c_Document_Status_Training));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Waiting
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  
    v_Staffs Htm_Pref.Recommended_Rank_Status_Nt;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in
       (Htm_Pref.c_Document_Status_Training, Htm_Pref.c_Document_Status_Approved) then
      Htm_Error.Raise_005(i_Document_Number  => r_Document.Document_Number,
                          i_Document_Status  => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Waiting),
                          i_Current_Status   => Htm_Util.t_Document_Status(r_Document.Status),
                          i_Allowed_Statuses => Array_Varchar2(Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Training),
                                                               Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Approved)));
    end if;
  
    if r_Document.Status = Htm_Pref.c_Document_Status_Approved then
      Hpd_Api.Journal_Unpost(i_Company_Id   => r_Document.Company_Id,
                             i_Filial_Id    => r_Document.Filial_Id,
                             i_Journal_Id   => r_Document.Journal_Id,
                             i_Source_Table => Zt.Htm_Recommended_Rank_Documents.Name,
                             i_Source_Id    => r_Document.Document_Id);
    end if;
  
    if r_Document.Status = Htm_Pref.c_Document_Status_Training then
      v_Staffs := Htm_Util.Recommended_Rank_Document_Calc_Indicators(i_Company_Id        => r_Document.Company_Id,
                                                                     i_Filial_Id         => r_Document.Filial_Id,
                                                                     i_Document_Id       => r_Document.Document_Id,
                                                                     i_Include_Trainings => true);
    
      Recommended_Rank_Document_Update_Status(i_Company_Id  => r_Document.Company_Id,
                                              i_Filial_Id   => r_Document.Filial_Id,
                                              i_Document_Id => r_Document.Document_Id,
                                              i_Staffs      => v_Staffs);
    end if;
  
    z_Htm_Recommended_Rank_Documents.Update_One(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Document_Id => i_Document_Id,
                                                i_Status      => Option_Varchar2(Htm_Pref.c_Document_Status_Waiting),
                                                i_Journal_Id  => Option_Number(null));
  
    if r_Document.Status = Htm_Pref.c_Document_Status_Approved then
      Hpd_Api.Journal_Delete(i_Company_Id   => r_Document.Company_Id,
                             i_Filial_Id    => r_Document.Filial_Id,
                             i_Journal_Id   => r_Document.Journal_Id,
                             i_Source_Table => Zt.Htm_Recommended_Rank_Documents.Name,
                             i_Source_Id    => r_Document.Document_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    v_Journal  Hpd_Pref.Rank_Change_Journal_Rt;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in (Htm_Pref.c_Document_Status_Waiting) then
      Htm_Error.Raise_005(i_Document_Number  => r_Document.Document_Number,
                          i_Document_Status  => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Approved),
                          i_Current_Status   => Htm_Util.t_Document_Status(r_Document.Status),
                          i_Allowed_Statuses => Array_Varchar2(Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Waiting)));
    end if;
  
    Hpd_Util.Rank_Change_Journal_New(o_Journal         => v_Journal,
                                     i_Company_Id      => r_Document.Company_Id,
                                     i_Filial_Id       => r_Document.Filial_Id,
                                     i_Journal_Id      => Coalesce(r_Document.Journal_Id,
                                                                   Hpd_Next.Journal_Id),
                                     i_Journal_Number  => z_Hpd_Journals.Take(i_Company_Id => r_Document.Company_Id, --
                                                          i_Filial_Id => r_Document.Filial_Id, --
                                                          i_Journal_Id => r_Document.Journal_Id).Journal_Number,
                                     i_Journal_Date    => r_Document.Document_Date,
                                     i_Journal_Name    => null,
                                     i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r_Document.Company_Id,
                                                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple),
                                     i_Source_Table    => Zt.Htm_Recommended_Rank_Documents.Name,
                                     i_Source_Id       => r_Document.Document_Id);
  
    for r in (select *
                from Htm_Recommended_Rank_Staffs q
               where q.Company_Id = r_Document.Company_Id
                 and q.Filial_Id = r_Document.Filial_Id
                 and q.Document_Id = r_Document.Document_Id
                 and q.Increment_Status = Htm_Pref.c_Increment_Status_Success)
    loop
      Hpd_Util.Journal_Add_Rank_Change(p_Journal     => v_Journal,
                                       i_Page_Id     => Hpd_Next.Page_Id,
                                       i_Staff_Id    => r.Staff_Id,
                                       i_Change_Date => r.New_Change_Date,
                                       i_Rank_Id     => r.To_Rank_Id);
    end loop;
  
    Hpd_Api.Rank_Change_Journal_Save(v_Journal);
    Hpd_Api.Journal_Post(i_Company_Id   => v_Journal.Company_Id,
                         i_Filial_Id    => v_Journal.Filial_Id,
                         i_Journal_Id   => v_Journal.Journal_Id,
                         i_Source_Table => Zt.Htm_Recommended_Rank_Documents.Name,
                         i_Source_Id    => r_Document.Document_Id);
  
    z_Htm_Recommended_Rank_Documents.Update_One(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Document_Id => i_Document_Id,
                                                i_Status      => Option_Varchar2(Htm_Pref.c_Document_Status_Approved),
                                                i_Journal_Id  => Option_Number(v_Journal.Journal_Id));
  end;

end Htm_Core;
/
