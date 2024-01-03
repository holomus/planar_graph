create or replace package Ui_Vhr550 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs(P1 Json_Object_t) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(P1 Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Add(P1 Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(P1 Json_Object_t) return Json_Object_t;
end Ui_Vhr550;
/
create or replace package body Ui_Vhr550 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs(P1 Json_Object_t) return Json_Array_t is
    p Gmap := Gmap;
  begin
    p.Val := P1;
  
    return Uit_Htm.Load_Recommended_Rank_Staffs(i_Document_Id   => p.o_Number('document_id'),
                                                i_Document_Date => p.r_Date('document_date'),
                                                i_Division_Id   => p.o_Number('division_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Division_Id number := null) return Gmap is
    v_List   Glist := Glist;
    v_Matrix Matrix_Varchar2 := Uit_Hrm.Divisions(i_Division_Id);
    result   Gmap := Gmap;
  begin
    for i in 1 .. v_Matrix.Count
    loop
      v_List.Push(v_Matrix(i));
    end loop;
  
    Result.Put('divisions', v_List);
  
    Result.Put('status_new', Htm_Pref.c_Document_Status_New);
    Result.Put('status_set_training', Htm_Pref.c_Document_Status_Set_Training);
    Result.Put('status_waiting', Htm_Pref.c_Document_Status_Waiting);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Json_Object_t is
    result Gmap := Gmap;
  begin
    Result.Put('document_date', Trunc(sysdate));
    Result.Put('references', References);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(P1 Json_Object_t) return Json_Object_t is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    v_Staffs   Glist := Glist;
    result     Gmap := Gmap;
    p          Gmap := Gmap;
  begin
    p.Val := P1;
  
    r_Document := z_Htm_Recommended_Rank_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Status <> Htm_Pref.c_Document_Status_New then
      Htm_Error.Raise_003(r_Document.Document_Number);
    end if;
  
    Result.Put('document_id', r_Document.Document_Id);
    Result.Put('document_number', r_Document.Document_Number);
    Result.Put('document_date', r_Document.Document_Date);
    Result.Put('division_id', r_Document.Division_Id);
    Result.Put('note', r_Document.Note);
  
    for r in (select Array_Varchar2(Ts.Staff_Id,
                                    q.Staff_Number,
                                    (select Np.Name
                                       from Mr_Natural_Persons Np
                                      where Np.Company_Id = r_Document.Company_Id
                                        and Np.Person_Id = q.Employee_Id),
                                    Ts.Robot_Id,
                                    w.Name,
                                    Ts.From_Rank_Id,
                                    (select Mr.Name
                                       from Mhr_Ranks Mr
                                      where Mr.Company_Id = r_Document.Company_Id
                                        and Mr.Filial_Id = r_Document.Filial_Id
                                        and Mr.Rank_Id = Ts.From_Rank_Id),
                                    Ts.Last_Change_Date,
                                    Ts.To_Rank_Id,
                                    (select Mr.Name
                                       from Mhr_Ranks Mr
                                      where Mr.Company_Id = r_Document.Company_Id
                                        and Mr.Filial_Id = r_Document.Filial_Id
                                        and Mr.Rank_Id = Ts.To_Rank_Id),
                                    Ts.New_Change_Date,
                                    Ts.Period,
                                    Ts.Nearest,
                                    Ts.Old_Penalty_Period,
                                    (select d.Name
                                       from Mhr_Divisions d
                                      where d.Company_Id = r_Document.Company_Id
                                        and d.Filial_Id = r_Document.Filial_Id
                                        and d.Division_Id = w.Division_Id),
                                    (select j.Name
                                       from Mhr_Jobs j
                                      where j.Company_Id = r_Document.Company_Id
                                        and j.Filial_Id = r_Document.Filial_Id
                                        and j.Job_Id = w.Job_Id),
                                    (select Jr.Experience_Id
                                       from Htm_Experience_Job_Ranks Jr
                                      where Jr.Company_Id = r_Document.Company_Id
                                        and Jr.Filial_Id = r_Document.Filial_Id
                                        and Jr.Job_Id = w.Job_Id
                                        and Jr.From_Rank_Id = Ts.From_Rank_Id),
                                    Ts.Attempt_No,
                                    Ts.Note) as Val
                from Htm_Recommended_Rank_Staffs Ts
                join Href_Staffs q
                  on q.Company_Id = r_Document.Company_Id
                 and q.Filial_Id = r_Document.Filial_Id
                 and q.Staff_Id = Ts.Staff_Id
                join Mrf_Robots w
                  on w.Company_Id = r_Document.Company_Id
                 and w.Filial_Id = r_Document.Filial_Id
                 and w.Robot_Id = Ts.Robot_Id
               where Ts.Company_Id = r_Document.Company_Id
                 and Ts.Filial_Id = r_Document.Filial_Id
                 and Ts.Document_Id = r_Document.Document_Id)
    loop
      v_Staffs.Push(r.Val);
    end loop;
  
    Result.Put('staffs', v_Staffs);
    Result.Put('references', References(r_Document.Division_Id));
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Document_Id number,
    P1            Json_Object_t
  ) return Json_Object_t is
    v_Document Htm_Pref.Recommended_Rank_Document_Rt;
    v_Staffs   Glist;
    v_Staff    Gmap;
    result     Gmap := Gmap;
    p          Gmap := Gmap;
  begin
    p.Val := P1;
  
    Htm_Util.Recommended_Rank_Document_New(o_Document        => v_Document,
                                           i_Company_Id      => Ui.Company_Id,
                                           i_Filial_Id       => Ui.Filial_Id,
                                           i_Document_Id     => i_Document_Id,
                                           i_Document_Number => p.o_Varchar2('document_number'),
                                           i_Document_Date   => p.r_Date('document_date'),
                                           i_Division_Id     => p.o_Number('division_id'),
                                           i_Note            => p.o_Varchar2('note'));
  
    v_Staffs := p.r_Glist('staffs');
  
    for i in 1 .. v_Staffs.Count
    loop
      v_Staff := Gmap(v_Staffs.r_Gmap(i));
    
      Htm_Util.Recommended_Rank_Document_Add_Staff(p_Document           => v_Document,
                                                   i_Staff_Id           => v_Staff.r_Number('staff_id'),
                                                   i_Robot_Id           => v_Staff.r_Number('robot_id'),
                                                   i_From_Rank_Id       => v_Staff.r_Number('from_rank_id'),
                                                   i_Last_Change_Date   => v_Staff.r_Date('last_change_date'),
                                                   i_To_Rank_Id         => v_Staff.r_Number('to_rank_id'),
                                                   i_New_Change_Date    => v_Staff.r_Date('new_change_date'),
                                                   i_Attempt_No         => v_Staff.r_Number('attempt_no'),
                                                   i_Experience_Id      => v_Staff.r_Number('experience_id'),
                                                   i_Period             => v_Staff.r_Number('period'),
                                                   i_Nearest            => v_Staff.r_Number('nearest'),
                                                   i_Old_Penalty_Period => v_Staff.o_Number('old_penalty_period'),
                                                   i_Note               => v_Staff.o_Varchar2('note'));
    end loop;
  
    Htm_Api.Recommended_Rank_Document_Save(v_Document);
  
    if p.o_Varchar2('set_training') = 'Y' then
      Htm_Api.Recommended_Rank_Document_Status_Set_Training(i_Company_Id  => v_Document.Company_Id,
                                                            i_Filial_Id   => v_Document.Filial_Id,
                                                            i_Document_Id => v_Document.Document_Id);
    end if;
  
    Result.Put('document_id', v_Document.Document_Id);
    Result.Put('document_number',
               z_Htm_Recommended_Rank_Documents.Load(i_Company_Id => v_Document.Company_Id, --
               i_Filial_Id => v_Document.Filial_Id, --
               i_Document_Id => v_Document.Document_Id).Document_Number);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(P1 Json_Object_t) return Json_Object_t is
  begin
    return save(Htm_Next.Recommended_Rank_Document_Id, P1);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(P1 Json_Object_t) return Json_Object_t is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                                             i_Filial_Id   => Ui.Filial_Id,
                                                             i_Document_Id => P1.Get_Number('document_id'));
    return save(r_Document.Document_Id, P1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit_Statuses(P1 Json_Object_t) is
    v_Staffs     Htm_Pref.Recommended_Rank_Status_Nt := Htm_Pref.Recommended_Rank_Status_Nt();
    v_Indicators Href_Pref.Indicator_Nt;
  
    v_Staffs_List Glist;
    v_Staff_Map   Gmap;
  
    v_Indicators_List Glist;
    v_Indicator_Map   Gmap;
  
    p Gmap := Gmap;
  begin
    p.Val := P1;
  
    v_Staffs_List := p.r_Glist('staffs');
  
    for i in 1 .. v_Staffs_List.Count
    loop
      v_Staff_Map := Gmap(v_Staffs_List.r_Gmap(i));
    
      v_Indicators_List := v_Staff_Map.r_Glist('indicators');
      v_Indicators      := Href_Pref.Indicator_Nt();
    
      for j in 1 .. v_Indicators_List.Count
      loop
        v_Indicator_Map := Gmap(v_Indicators_List.r_Gmap(j));
      
        Href_Util.Indicator_Add(p_Indicators      => v_Indicators,
                                i_Indicator_Id    => v_Indicator_Map.r_Number('indicator_id'),
                                i_Indicator_Value => v_Indicator_Map.r_Number('indicator_value'));
      end loop;
    
      Htm_Util.Recommended_Rank_Add_Staff_Status(p_Staffs           => v_Staffs,
                                                 i_Staff_Id         => v_Staff_Map.r_Number('staff_id'),
                                                 i_Increment_Status => v_Staff_Map.r_Varchar2('incremenet_status'),
                                                 i_Indicators       => v_Indicators);
    end loop;
  
    Htm_Api.Recommended_Rank_Document_Update_Status(i_Company_Id  => Ui.Company_Id,
                                                    i_Filial_Id   => Ui.Filial_Id,
                                                    i_Document_Id => p.r_Number('document_id'),
                                                    i_Staffs      => v_Staffs);
  end;

end Ui_Vhr550;
/
