create or replace package Ui_Vhr296 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Subordinates(p Hashmap) return Fazo_Query;
end Ui_Vhr296;
/
create or replace package body Ui_Vhr296 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Subordinates(p Hashmap) return Fazo_Query is
    v_Query           varchar2(4000);
    v_Params          Hashmap;
    v_Direct_Employee varchar2(1) := 'N';
    v_Employee_Id     number := p.r_Number('person_id');
    v_Filial_Id       number;
    q                 Fazo_Query;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    else
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    v_Params := Fazo.Zip_Map('employee_id',
                             v_Employee_Id,
                             'company_id',
                             Ui.Company_Id,
                             'filial_id',
                             v_Filial_Id,
                             'curr_date',
                             Trunc(sysdate),
                             'sk_primary',
                             Href_Pref.c_Staff_Kind_Primary);
    v_Params.Put('subordinates',
                 Href_Util.Get_Subordinates(Ui.Company_Id,
                                            v_Filial_Id,
                                            v_Direct_Employee,
                                            v_Employee_Id));
                                            
    v_Query := 'select q.*,
                       (select mp.name
                          from mr_natural_persons mp
                         where mp.company_id = :company_id
                           and mp.person_id = q.employee_id) name,
                       (select m.gender
                          from mr_natural_persons m
                         where m.company_id = :company_id
                           and m.person_id = q.employee_id) gender,
                       (select k.photo_sha
                          from md_persons k
                         where k.company_id = :company_id
                           and k.person_id = q.employee_id) photo_sha
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.employee_id <> :employee_id
                   and q.staff_id member of :subordinates
                   and q.state = ''A''
                   and q.hiring_date <= :curr_date
                   and (q.dismissal_date is null or q.dismissal_date >= :curr_date)
                   and q.staff_kind = :sk_primary';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('name', 'photo_sha', 'gender');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Gender     = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           Photo_Sha  = null;
  end;

end Ui_Vhr296;
/
