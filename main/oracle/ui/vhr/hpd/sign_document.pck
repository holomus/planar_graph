create or replace package Ui_Vhr654 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Sign(p Hashmap);
end Ui_Vhr654;
/
create or replace package body Ui_Vhr654 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Document    Mdf_Sign_Documents%rowtype;
    r_Process     Mdf_Sign_Processes%rowtype;
    v_Company_Id  number := Ui.Company_Id;
    v_Document_Id number := p.r_Number('document_id');
    v_Matrix      Matrix_Varchar2;
    result        Hashmap;
  begin
    r_Document := z_Mdf_Sign_Documents.Load(i_Company_Id  => v_Company_Id,
                                            i_Document_Id => v_Document_Id);
  
    if r_Document.Filial_Id <> Ui.Filial_Id then
      b.Raise_Unauthorized;
    end if;
  
    r_Process := z_Mdf_Sign_Processes.Load(i_Company_Id => r_Document.Company_Id,
                                           i_Process_Id => r_Document.Process_Id);
  
    if r_Process.Project_Code <> Ui.Project_Code then
      b.Raise_Unauthorized;
    end if;
  
    result := z_Mdf_Sign_Documents.To_Map(r_Document, --
                                          z.Document_Id,
                                          z.Sign_Kind,
                                          z.Status);
  
    Result.Put('status_name', Mdf_Pref.t_Document_Status(r_Document.Status));
  
    select Array_Varchar2(q.Level_No,
                          q.Sign_Kind,
                          q.c_State,
                          Mdf_Pref.t_Sign_State(q.c_State),
                          q.c_Sign_Min_Count,
                          q.c_Group_Count,
                          q.c_Approved_Group_Count)
      bulk collect
      into v_Matrix
      from Mdf_Sign_Document_Levels q
     where q.Company_Id = r_Document.Company_Id
       and q.Document_Id = r_Document.Document_Id
     order by q.Level_No;
  
    Result.Put('levels', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Level_No,
                          q.Group_No,
                          q.Sign_Min_Count,
                          q.c_State,
                          Mdf_Pref.t_Sign_State(q.c_State),
                          q.c_Sign_Available,
                          q.c_Person_Count,
                          q.c_Approved_Person_Count,
                          q.c_Cancelled_Person_Count)
      bulk collect
      into v_Matrix
      from Mdf_Sign_Document_Groups q
     where q.Company_Id = r_Document.Company_Id
       and q.Document_Id = r_Document.Document_Id
     order by q.Group_No;
  
    Result.Put('groups', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Level_No,
                          q.Group_No,
                          q.Person_Id,
                          (select w.Name
                             from Md_Persons w
                            where w.Person_Id = q.Person_Id),
                          q.State,
                          Mdf_Pref.t_Sign_State(q.State),
                          q.Note)
      bulk collect
      into v_Matrix
      from Mdf_Sign_Document_Persons q
     where q.Company_Id = r_Document.Company_Id
       and q.Document_Id = r_Document.Document_Id
     order by q.Order_No;
  
    Result.Put('persons', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('user_id', Ui.User_Id);
    Result.Put('person_tin',
               z_Mr_Person_Details.Take(i_Company_Id => Ui.Company_Id, i_Person_Id => Ui.User_Id).Tin);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sign(p Hashmap) is
    r_Document Mdf_Sign_Documents%rowtype;
    r_Process  Mdf_Sign_Processes%rowtype;
  begin
    r_Document := z_Mdf_Sign_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                            i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Filial_Id <> Ui.Filial_Id then
      b.Raise_Unauthorized;
    end if;
  
    r_Process := z_Mdf_Sign_Processes.Load(i_Company_Id => r_Document.Company_Id,
                                           i_Process_Id => r_Document.Process_Id);
  
    if r_Process.Project_Code <> Ui.Project_Code then
      b.Raise_Unauthorized;
    end if;
  
    Mdf_Api.Document_Sign(i_Company_Id  => r_Document.Company_Id,
                          i_Document_Id => r_Document.Document_Id,
                          i_Level_No    => p.r_Number('level_no'),
                          i_Group_No    => p.r_Number('group_no'),
                          i_Person_Id   => Ui.User_Id,
                          i_State       => p.r_Varchar2('state'),
                          i_Note        => p.o_Varchar2('note'));
  end;

end Ui_Vhr654;
/
