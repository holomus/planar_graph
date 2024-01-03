create or replace package Ui_Vhr568 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr568;
/
create or replace package body Ui_Vhr568 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_reject_reasons',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('reject_reason_id', 'order_no', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'state', 'code');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id        number := Ui.Company_Id;
    v_Reject_Reason_Ids Array_Number := Fazo.Sort(p.r_Array_Number('reject_reason_id'));
  begin
    for i in 1 .. v_Reject_Reason_Ids.Count
    loop
      Hrec_Api.Reject_Reason_Delete(i_Company_Id       => v_Company_Id,
                                    i_Reject_Reason_Id => v_Reject_Reason_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hrec_Reject_Reasons
       set Company_Id       = null,
           Reject_Reason_Id = null,
           name             = null,
           State            = null,
           Order_No         = null,
           Code             = null,
           Created_By       = null,
           Created_On       = null,
           Modified_By      = null,
           Modified_On      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr568;
/
