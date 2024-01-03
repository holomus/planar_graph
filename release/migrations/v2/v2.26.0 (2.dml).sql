prompt updating report preference codes
----------------------------------------------------------------------------------------------------
update md_user_settings q
   set q.setting_code = q.setting_code || ':settings'
 where q.setting_code in ('ui_vhr499', -- oracle/ui/vhr/rep/hpr/sales_bonus_and_book.pck
                          'ui_vhr322', -- oracle/ui/vhr/rep/hpr/wage_report.pck
                          'ui_vhr459', -- oracle/ui/vhr/rep/hrm/division_timesheet.pck
                          'ui_vhr555', -- oracle/ui/vhr/rep/hsc/staff_calc.pck
                          'ui_vhr304', -- oracle/ui/vhr/rep/htt/division_attendance.pck
                          'ui_vhr475', -- oracle/ui/vhr/rep/htt/mark_details.pck
                          'ui_vhr101', -- oracle/ui/vhr/rep/htt/timesheet.pck, NEXT -- oracle/ui/vhr/rep/htt/timesheet_with_transfers.pck
                          'ui_vhr468'); 
commit;

---------------------------------------------------------------------------------------------------- 
prompt add oper type 
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id       number;
  v_Oper_Group_Id    number;
  v_Oper_Type_Ids    Array_Number;
  r_Oper_Type        Hpr_Pref.Oper_Type_Rt;
  v_Pcode_Oper_Group varchar2(10) := Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline;

  --------------------------------------------------
  Function Oper_Group_Id return number is
    result number;
  begin
    select q.Oper_Group_Id
      into result
      from Hpr_Oper_Groups q
     where q.Company_Id = v_Company_Id
       and q.Pcode = v_Pcode_Oper_Group;

    return result;
  exception
    when No_Data_Found then
      return null;
  end;
begin
  for Cmp in (select *
                from Md_Companies)
  loop
    v_Company_Id := Cmp.Company_Id;

    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);

    v_Oper_Group_Id := Oper_Group_Id;

    continue when v_Oper_Group_Id is null;

    for r in (select *
                from Hpr_Oper_Types q
               where q.Company_Id = v_Company_Id
                 and q.Oper_Group_Id = v_Oper_Group_Id
                 and q.estimation_type = hpr_pref.c_Estimation_Type_Formula)
    loop
      r_Oper_Type.Oper_Type := z_Mpr_Oper_Types.Load(i_Company_Id   => v_Company_Id,
                                                     i_Oper_Type_Id => r.Oper_Type_Id);

      r_Oper_Type.Oper_Group_Id      := v_Oper_Group_Id;
      r_Oper_Type.Estimation_Type    := r.Estimation_Type;
      r_Oper_Type.Estimation_Formula := r.Estimation_Formula;

      Hpr_Api.Oper_Type_Save(r_Oper_Type);
    end loop;

    commit;
  end loop;
end;
/
