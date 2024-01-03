prompt migr from 06.04.2022
----------------------------------------------------------------------------------------------------
-- time kinds
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id    number;
  v_Turnout_Id    number;
  v_Rest_Id       number;
  v_Meeting_Id    number;
  v_Holiday_Id    number;
  v_Nonworking_Id number;

begin
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    v_Turnout_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
    v_Rest_Id       := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Rest);
    v_Meeting_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Meeting);
    v_Holiday_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Holiday);
    v_Nonworking_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Nonworking);
  
    update Htt_Time_Kinds Tk
       set Tk.Parent_Id = v_Turnout_Id
     where Tk.Company_Id = v_Company_Id
       and Tk.Parent_Id = v_Meeting_Id;
  
    update Htt_Time_Kinds Tk
       set Tk.Parent_Id = v_Rest_Id
     where Tk.Company_Id = v_Company_Id
       and Tk.Parent_Id in (v_Holiday_Id, v_Nonworking_Id);
  
    for r in (select distinct Tf.Filial_Id, Tf.Timebook_Id, Tf.Staff_Id
                from Hpr_Timebook_Facts Tf
               where Tf.Company_Id = v_Company_Id
                 and Tf.Time_Kind_Id in (v_Meeting_Id, v_Holiday_Id, v_Nonworking_Id))
    loop
      Hpr_Core.Regen_Timebook_Facts(i_Company_Id  => v_Company_Id,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Timebook_Id => r.Timebook_Id,
                                    i_Staff_Id    => r.Staff_Id);
    end loop;
  
    commit;
  end loop;
end;
/
