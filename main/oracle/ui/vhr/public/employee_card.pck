create or replace package Ui_Vhr452 is
  ----------------------------------------------------------------------------------------------------
  Function Employee_Details(p Hashmap) return Hashmap;
end Ui_Vhr452;
/
create or replace package body Ui_Vhr452 is
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
    return b.Translate('UI-VHR452:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Employee_Details(p Hashmap) return Hashmap is
    r_Filial        Md_Filials%rowtype;
    r_Person        Md_Persons%rowtype;
    r_Nat_Person    Mr_Natural_Persons%rowtype;
    r_Employee      Mhr_Employees%rowtype;
    v_Employee_Code varchar2(64) := p.r_Varchar2('employee_code');
    v_Filial_Id     number := p.r_Number('filial_id');
    v_Person_Id     number;
    result          Hashmap := Hashmap();
  begin
    begin
      select *
        into r_Filial
        from Md_Filials f
       where f.Filial_Id = v_Filial_Id;
    exception
      when No_Data_Found then
        b.Raise_Error(t('filial not found'));
    end;
  
    begin
      select t.Person_Id
        into v_Person_Id
        from Htt_Persons t
       where t.Company_Id = r_Filial.Company_Id
         and t.Qr_Code = v_Employee_Code;
    exception
      when No_Data_Found then
        b.Raise_Error(t('cannot find person by qr code'));
    end;
  
    r_Person     := z_Md_Persons.Load(i_Company_Id => r_Filial.Company_Id,
                                      i_Person_Id  => v_Person_Id);
    r_Nat_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Filial.Company_Id,
                                              i_Person_Id  => v_Person_Id);
    r_Employee   := z_Mhr_Employees.Take(i_Company_Id  => r_Filial.Company_Id,
                                         i_Filial_Id   => r_Filial.Filial_Id,
                                         i_Employee_Id => v_Person_Id);
  
    Result.Put('filial_name', r_Filial.Name);
    Result.Put('name', r_Person.Name);
    Result.Put('photo_sha', r_Person.Photo_Sha);
    Result.Put('mobile_phone', r_Person.Phone);
    Result.Put('email', r_Person.Email);
    Result.Put('birthday', to_char(r_Nat_Person.Birthday, Href_Pref.c_Date_Format_Day));
    Result.Put('gender', r_Nat_Person.Gender);
    Result.Put('pg_female', Md_Pref.Pg_Female);
    Result.Put('address',
               z_Mr_Person_Details.Take(i_Company_Id => r_Person.Company_Id, i_Person_Id => r_Person.Person_Id).Address);
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Employee.Company_Id, --
               i_Filial_Id => r_Employee.Filial_Id, i_Division_Id => r_Employee.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => r_Employee.Company_Id, --
               i_Filial_Id => r_Employee.Filial_Id, i_Job_Id => r_Employee.Job_Id).Name);
  
    return result;
  end;

end Ui_Vhr452;
/
