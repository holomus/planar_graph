prompt migr from 06.07.2022

----------------------------------------------------------------------------------------------------
prompt add 'overtime' journal type for all companies
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    r_Journal_Type Hpd_Journal_Types%rowtype;
  begin
    begin
      select *
        into r_Journal_Type
        from Hpd_Journal_Types
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Journal_Type.Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => i_Company_Id,
                                 i_Journal_Type_Id => r_Journal_Type.Journal_Type_Id,
                                 i_Name            => Nvl(r_Journal_Type.Name, i_Name),
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  for Cmp in (select *
                from Md_Companies q)
  loop
    Journal_Type(Cmp.Company_Id,
                 'Сверхурочная работа',
                 14,
                 Hpd_Pref.c_Pcode_Journal_Type_Overtime);
  end loop;

  commit;
end;
/
----------------------------------------------------------------------------------------------------
prompt update overtime time kinds
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Time_Kind_Update(i_Company_Id number) is
    v_Overtime_Time_Kind_Id number;
    v_Leave_Time_Kind_Id    number;
  begin
    v_Overtime_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  
    v_Leave_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                  i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Leave);
  
    update Htt_Time_Kinds q
       set q.Parent_Id = v_Leave_Time_Kind_Id
     where q.Company_Id = i_Company_Id
       and q.Parent_Id = v_Overtime_Time_Kind_Id;
  
    update Htt_Request_Kinds q
       set q.Time_Kind_Id = v_Leave_Time_Kind_Id
     where q.Company_Id = i_Company_Id
       and q.Time_Kind_Id = v_Overtime_Time_Kind_Id;
  
    update Htt_Time_Kinds q
       set q.Requestable = 'N'
     where q.Company_Id = i_Company_Id
       and q.Time_Kind_Id = v_Overtime_Time_Kind_Id;
  end;
begin
  for Cmp in (select *
                from Md_Companies q)
  loop
    Time_Kind_Update(Cmp.Company_Id);
  end loop;

  commit;
end;
/
