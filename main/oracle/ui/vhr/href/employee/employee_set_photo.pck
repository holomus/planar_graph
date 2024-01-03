create or replace package Ui_Vhr671 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Folders return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Set_Photo(p Hashmap) return Hashmap;
end Ui_Vhr671;
/
create or replace package body Ui_Vhr671 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Folders return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mf_files q
                      where q.company_id = :company_id
                        and q.sha is null
                        and q.owner_id = :user_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'user_id', Ui.User_Id));
  
    q.Number_Field('file_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('templates', Fazo.Zip_Matrix(Href_Util.Set_Photo_Templates));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Find_Person_With_Name
  (
    i_First_Name  varchar2,
    i_Middle_Name varchar2 := null,
    i_Last_Name   varchar2,
    o_Status      out varchar2,
    o_Names       out varchar2
  ) return number is
    v_Person_Id number;
  begin
    select q.Person_Id, q.Name
      into v_Person_Id, o_Names
      from Mr_Natural_Persons q
     where q.Company_Id = Ui.Company_Id
       and q.First_Name = i_First_Name
       and (i_Middle_Name is null or q.Middle_Name = i_Middle_Name)
       and q.Last_Name = i_Last_Name;
  
    o_Status := Href_Pref.c_Pref_Set_Photo_Status_Success;
    return v_Person_Id;
  exception
    when Too_Many_Rows then
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Warning;
    
      select Listagg(q.Name, ', ')
        into o_Names
        from Mr_Natural_Persons q
       where q.Company_Id = Ui.Company_Id
         and q.First_Name = i_First_Name
         and (i_Middle_Name is null or q.Middle_Name = i_Middle_Name)
         and q.Last_Name = i_Last_Name;
    
      return null;
    when No_Data_Found then
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Not_Found;
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Find_Person_With_Name_Id
  (
    i_First_Name  varchar2,
    i_Middle_Name varchar2 := null,
    i_Last_Name   varchar2,
    i_Person_Id   number,
    o_Status      out varchar2,
    o_Name        out varchar2
  ) return number is
    r_Person Mr_Natural_Persons%rowtype;
  begin
    if z_Mr_Natural_Persons.Exist(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => i_Person_Id,
                                  o_Row        => r_Person) then
    
      if r_Person.First_Name = i_First_Name -- 
         and (i_Middle_Name is null or r_Person.Middle_Name = i_Middle_Name) --
         and r_Person.Last_Name = i_Last_Name then
        o_Status := Href_Pref.c_Pref_Set_Photo_Status_Success;
        o_Name   := r_Person.Name;
        return r_Person.Person_Id;
      else
        o_Name   := r_Person.Name;
        o_Status := Href_Pref.c_Pref_Set_Photo_Status_Warning;
        return null;
      end if;
    end if;
  
    select q.Name
      into o_Name
      from Mr_Natural_Persons q
     where q.Company_Id = Ui.Company_Id
       and q.First_Name = i_First_Name
       and (i_Middle_Name is null or q.Middle_Name = i_Middle_Name)
       and q.Last_Name = i_Last_Name;
  
    o_Status := Href_Pref.c_Pref_Set_Photo_Status_Warning;
    return null;
  exception
    when others then
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Not_Found;
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Find_Person_With_Name_Emp_Number
  (
    i_First_Name      varchar2,
    i_Middle_Name     varchar2 := null,
    i_Last_Name       varchar2,
    i_Employee_Number varchar2,
    o_Status          out varchar2,
    o_Name            out varchar2
  ) return number is
    v_Person_Id          number;
    v_Employee_Id        number;
    v_Person_Name        varchar2(1000);
    v_Employee_Name      varchar2(1000);
    v_Take_Person_Name   boolean;
    v_Take_Person_Number boolean;
  
    --------------------------------------------------               
    Function Take_Person_Number return boolean is
    begin
      select q.Employee_Id,
             (select w.Name
                from Mr_Natural_Persons w
               where w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id)
        into v_Employee_Id, v_Employee_Name
        from Mhr_Employees q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Employee_Number = i_Employee_Number;
    
      return true;
    exception
      when others then
        return false;
    end;
  
    --------------------------------------------------               
    Function Take_Person_Name return boolean is
    begin
      select q.Person_Id, q.Name
        into v_Person_Id, v_Person_Name
        from Mr_Natural_Persons q
       where q.Company_Id = Ui.Company_Id
         and q.First_Name = i_First_Name
         and (i_Middle_Name is null or q.Middle_Name = i_Middle_Name)
         and q.Last_Name = i_Last_Name;
    
      return true;
    exception
      when others then
        return false;
    end;
  begin
    v_Take_Person_Name   := Take_Person_Name;
    v_Take_Person_Number := Take_Person_Number;
  
    if v_Take_Person_Name and v_Take_Person_Number and v_Employee_Id = v_Person_Id then
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Success;
      o_Name   := v_Person_Name;
      return v_Person_Id;
    elsif v_Take_Person_Name and not v_Take_Person_Number then
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Warning;
      o_Name   := v_Person_Name;
      return null;
    elsif v_Take_Person_Number and not v_Take_Person_Name then
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Warning;
      o_Name   := v_Employee_Name;
      return null;
    else
      o_Status := Href_Pref.c_Pref_Set_Photo_Status_Not_Found;
      return null;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Set_Photo(p Hashmap) return Hashmap is
    v_Template   varchar2(50) := p.r_Varchar2('template_key');
    v_File_Id    number := p.o_Number('file_id');
    v_Name       Array_Varchar2;
    v_Names      varchar2(4000);
    v_Person_Id  number;
    v_Status     varchar2(1);
    v_Company_Id number := Ui.Company_Id;
    v_Files      Arraylist := Arraylist();
    v_File       Hashmap;
    result       Hashmap := Hashmap();
  
    --------------------------------------------------    
    Function Has_Person_Photo(i_Person_Id number) return boolean is
      v_Dummy number;
    begin
      select 1
        into v_Dummy
        from Htt_Person_Photos q
       where q.Company_Id = v_Company_Id
         and q.Person_Id = i_Person_Id
       fetch first row only;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    for r in (select *
                from Mf_Files q
               where q.Company_Id = v_Company_Id
                 and (v_File_Id is null or v_File_Id = q.Folder_Id)
                 and q.Sha is not null
               order by q.Name)
    loop
      v_Person_Id := null;
      v_Status    := null;
      v_Name      := Array_Varchar2();
      v_File      := Hashmap();
    
      v_File.Put('sha', r.Sha);
      v_File.Put('file_name', r.Name);
    
      if v_Template in (Href_Pref.c_Set_Photo_Template_Fl, Href_Pref.c_Set_Photo_Template_Lf) then
        select Array_Varchar2(trim(Substr(r.Name, 1, Instr(r.Name, ' ', 1, 1) - 1)),
                              trim(Substr(r.Name,
                                          Instr(r.Name, ' ', 1, 1) + 1,
                                          Instr(r.Name, '.', 1, 1) - Instr(r.Name, ' ', 1, 1) - 1)))
          into v_Name
          from Dual;
      elsif v_Template in (Href_Pref.c_Set_Photo_Template_Fl_Id,
                           Href_Pref.c_Set_Photo_Template_Lf_Id,
                           Href_Pref.c_Set_Photo_Template_Fl_Employee_Number,
                           Href_Pref.c_Set_Photo_Template_Lf_Employee_Number) then
        select Array_Varchar2(trim(Substr(r.Name, 1, Instr(r.Name, ' ', 1, 1) - 1)),
                              trim(Substr(r.Name,
                                          Instr(r.Name, ' ', 1, 1) + 1,
                                          Instr(r.Name, '#', 1, 1) - Instr(r.Name, ' ', 1, 1) - 1)),
                              trim(Substr(r.Name,
                                          Instr(r.Name, '#', 1, 1) + 1,
                                          Instr(r.Name, '.', 1, 1) - Instr(r.Name, '#', 1, 1) - 1)))
          into v_Name
          from Dual;
      elsif v_Template in (Href_Pref.c_Set_Photo_Template_Flm, Href_Pref.c_Set_Photo_Template_Lfm) then
        select Array_Varchar2(trim(Substr(r.Name, 1, Instr(r.Name, ' ', 1, 1) - 1)),
                              trim(Substr(r.Name,
                                          Instr(r.Name, ' ', 1, 1) + 1,
                                          Instr(r.Name, ' ', 1, 2) - Instr(r.Name, ' ', 1, 1))),
                              trim(Substr(r.Name,
                                          Instr(r.Name, ' ', 1, 2) + 1,
                                          Instr(r.Name, '.', 1, 1) - Instr(r.Name, ' ', 1, 2) - 1)))
          into v_Name
          from Dual;
      else
        select Array_Varchar2(trim(Substr(r.Name, 1, Instr(r.Name, ' ', 1, 1) - 1)),
                              trim(Substr(r.Name,
                                          Instr(r.Name, ' ', 1, 1) + 1,
                                          Instr(r.Name, ' ', 1, 2) - Instr(r.Name, ' ', 1, 1))),
                              trim(Substr(r.Name,
                                          Instr(r.Name, ' ', 1, 2) + 1,
                                          Instr(r.Name, '#', 1, 1) - Instr(r.Name, ' ', 1, 2) - 1)),
                              trim(Substr(r.Name,
                                          Instr(r.Name, '#', 1, 1) + 1,
                                          Instr(r.Name, '.', 1, 1) - Instr(r.Name, '#', 1, 1) - 1)))
          into v_Name
          from Dual;
      end if;
    
      begin
        case v_Template
          when Href_Pref.c_Set_Photo_Template_Fl then
            v_Person_Id := Find_Person_With_Name(i_First_Name => v_Name(1),
                                                 i_Last_Name  => v_Name(2),
                                                 o_Status     => v_Status,
                                                 o_Names      => v_Names);
          when Href_Pref.c_Set_Photo_Template_Lf then
            v_Person_Id := Find_Person_With_Name(i_Last_Name  => v_Name(1),
                                                 i_First_Name => v_Name(2),
                                                 o_Status     => v_Status,
                                                 o_Names      => v_Names);
          when Href_Pref.c_Set_Photo_Template_Fl_Id then
            v_Person_Id := Find_Person_With_Name_Id(i_First_Name => v_Name(1),
                                                    i_Last_Name  => v_Name(2),
                                                    i_Person_Id  => v_Name(3),
                                                    o_Status     => v_Status,
                                                    o_Name       => v_Names);
          when Href_Pref.c_Set_Photo_Template_Lf_Id then
            v_Person_Id := Find_Person_With_Name_Id(i_Last_Name  => v_Name(1),
                                                    i_First_Name => v_Name(2),
                                                    i_Person_Id  => v_Name(3),
                                                    o_Status     => v_Status,
                                                    o_Name       => v_Names);
          when Href_Pref.c_Set_Photo_Template_Fl_Employee_Number then
            v_Person_Id := Find_Person_With_Name_Emp_Number(i_First_Name      => v_Name(1),
                                                            i_Last_Name       => v_Name(2),
                                                            i_Employee_Number => v_Name(3),
                                                            o_Status          => v_Status,
                                                            o_Name            => v_Names);
          when Href_Pref.c_Set_Photo_Template_Lf_Employee_Number then
            v_Person_Id := Find_Person_With_Name_Emp_Number(i_Last_Name       => v_Name(1),
                                                            i_First_Name      => v_Name(2),
                                                            i_Employee_Number => v_Name(3),
                                                            o_Status          => v_Status,
                                                            o_Name            => v_Names);
          when Href_Pref.c_Set_Photo_Template_Flm then
            v_Person_Id := Find_Person_With_Name(i_First_Name  => v_Name(1),
                                                 i_Last_Name   => v_Name(2),
                                                 i_Middle_Name => v_Name(3),
                                                 o_Status      => v_Status,
                                                 o_Names       => v_Names);
          when Href_Pref.c_Set_Photo_Template_Lfm then
            v_Person_Id := Find_Person_With_Name(i_Last_Name   => v_Name(1),
                                                 i_First_Name  => v_Name(2),
                                                 i_Middle_Name => v_Name(3),
                                                 o_Status      => v_Status,
                                                 o_Names       => v_Names);
          when Href_Pref.c_Set_Photo_Template_Flm_Id then
            v_Person_Id := Find_Person_With_Name_Id(i_First_Name  => v_Name(1),
                                                    i_Last_Name   => v_Name(2),
                                                    i_Middle_Name => v_Name(3),
                                                    i_Person_Id   => v_Name(4),
                                                    o_Status      => v_Status,
                                                    o_Name        => v_Names);
          when Href_Pref.c_Set_Photo_Template_Lfm_Id then
            v_Person_Id := Find_Person_With_Name_Id(i_Last_Name   => v_Name(1),
                                                    i_First_Name  => v_Name(2),
                                                    i_Middle_Name => v_Name(3),
                                                    i_Person_Id   => v_Name(4),
                                                    o_Status      => v_Status,
                                                    o_Name        => v_Names);
          when Href_Pref.c_Set_Photo_Template_Flm_Employee_Number then
            v_Person_Id := Find_Person_With_Name_Emp_Number(i_First_Name      => v_Name(1),
                                                            i_Last_Name       => v_Name(2),
                                                            i_Middle_Name     => v_Name(3),
                                                            i_Employee_Number => v_Name(4),
                                                            o_Status          => v_Status,
                                                            o_Name            => v_Names);
          when Href_Pref.c_Set_Photo_Template_Lfm_Employee_Number then
            v_Person_Id := Find_Person_With_Name_Emp_Number(i_Last_Name       => v_Name(1),
                                                            i_First_Name      => v_Name(2),
                                                            i_Middle_Name     => v_Name(3),
                                                            i_Employee_Number => v_Name(4),
                                                            o_Status          => v_Status,
                                                            o_Name            => v_Names);
        end case;
      
      exception
        when others then
          v_File.Put('status', Href_Pref.c_Pref_Set_Photo_Status_Not_Found);
          v_Files.Push(v_File);
          continue;
      end;
    
      if v_Person_Id is not null then
        if z_Md_Persons.Load(i_Company_Id => v_Company_Id, i_Person_Id => v_Person_Id).Photo_Sha is null then
          Md_Api.Person_Update(i_Company_Id => v_Company_Id,
                               i_Person_Id  => v_Person_Id,
                               i_Photo_Sha  => Option_Varchar2(r.Sha));
        end if;
      
        if not Has_Person_Photo(v_Person_Id) then
          Htt_Api.Person_Save_Photo(i_Company_Id => v_Company_Id,
                                    i_Person_Id  => v_Person_Id,
                                    i_Photo_Sha  => r.Sha,
                                    i_Is_Main    => 'Y');
        end if;
      
        v_File.Put('status', Href_Pref.c_Pref_Set_Photo_Status_Success);
      else
        v_File.Put('status', v_Status);
      end if;
    
      v_File.Put('employee_names', v_Names);
    
      v_Files.Push(v_File);
    end loop;
  
    Result.Put('files', v_Files);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mf_Files
       set Company_Id = null,
           File_Id    = null,
           Sha        = null,
           Owner_Id   = null,
           name       = null,
           Folder_Id  = null;
  end;

end Ui_Vhr671;
/
