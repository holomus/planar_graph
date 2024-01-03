create or replace package Ui_Vhr2 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr2;
/
create or replace package body Ui_Vhr2 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_science_branches', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('science_branch_id');
    q.Varchar2_Field('name', 'state', 'code');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id         number := Ui.Company_Id;
    v_Science_Branch_Ids Array_Number := Fazo.Sort(p.r_Array_Number('science_branch_id'));
  begin
    for i in 1 .. v_Science_Branch_Ids.Count
    loop
      Href_Api.Science_Branch_Delete(i_Company_Id        => v_Company_Id,
                                     i_Science_Branch_Id => v_Science_Branch_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Science_Branches
       set Company_Id        = null,
           Science_Branch_Id = null,
           name              = null,
           State             = null,
           Code              = null;
  end;

end Ui_Vhr2;
/
