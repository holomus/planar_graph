create or replace package Ui_Vhr72 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr72;
/
create or replace package body Ui_Vhr72 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
  begin
    q := Fazo_Query('htt_time_kinds', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('time_kind_id', 'parent_id', 'timesheet_coef', 'created_by', 'modified_by');
    q.Varchar2_Field('name',
                     'letter_code',
                     'digital_code',
                     'plan_load',
                     'requestable',
                     'bg_color',
                     'color',
                     'state',
                     'pcode');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('parent_name',
                  'parent_id',
                  'htt_time_kinds',
                  'time_kind_id',
                  'name',
                  'select w.* 
                     from htt_time_kinds w 
                    where w.company_id = :company_id
                      and w.pcode is not null');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
  
    v_Matrix := Htt_Util.Plan_Loads;
    q.Option_Field('plan_load_name', 'plan_load', v_Matrix(1), v_Matrix(2));
    q.Option_Field('requestable_name',
                   'requestable',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Time_Kind_Ids Array_Number := p.r_Array_Number('time_kind_id');
  begin
    for i in 1 .. v_Time_Kind_Ids.Count
    loop
      Htt_Api.Time_Kind_Delete(i_Company_Id   => Ui.Company_Id, --
                               i_Time_Kind_Id => v_Time_Kind_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Htt_Time_Kinds
       set Company_Id     = null,
           Time_Kind_Id   = null,
           name           = null,
           Letter_Code    = null,
           Digital_Code   = null,
           Parent_Id      = null,
           Plan_Load      = null,
           Requestable    = null,
           Bg_Color       = null,
           Color          = null,
           Timesheet_Coef = null,
           State          = null,
           Pcode          = null,
           Created_By     = null,
           Created_On     = null,
           Modified_By    = null,
           Modified_On    = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr72;
/
