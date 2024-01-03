prompt migr from 28.10.2022 (2.dml)

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
    v_Journal_Type_Id number;
  begin
    begin
      select Journal_Type_Id
        into v_Journal_Type_Id
        from Hpd_Journal_Types
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => i_Company_Id,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => i_Name,
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  for Cmp in (select c.Company_Id,
                     (select Ci.Filial_Head
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as Filial_Head,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System
                from Md_Companies c)
  loop
    Journal_Type(Cmp.Company_Id,
                 'Изменение графика работы',
                 11,
                 Hpd_Pref.c_Pcode_Journal_Type_Schedule_Multiple);
  
    Journal_Type(Cmp.Company_Id,
                 'Изменение оплаты труда списком',
                 8,
                 Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Journal_Type_Update
  (
    i_Pcode    varchar2,
    i_Order_No number
  ) is
  begin
    update Hpd_Journal_Types j
       set j.Order_No = i_Order_No
     where j.Pcode = i_Pcode;
  end;
begin
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Rank_Change, 9);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change, 10);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Limit_Change, 12);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave, 13);
  Journal_Type_Update(Hpd_pref.c_Pcode_Journal_Type_Business_Trip, 14);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Vacation, 15);
  Journal_Type_Update(Hpd_Pref.c_Pcode_Journal_Type_Overtime, 16);

  commit;
end;
/

update htt_request_kinds q
   set q.carryover_policy = 'Z'
 where q.annually_limited = 'Y';
commit;

----------------------------------------------------------------------------------------------------
update Htt_Requests p
   set p.Accrual_Kind = 'P'
 where exists (select 1
          from Htt_Request_Kinds q
         where q.Company_Id = p.Company_Id
           and q.Request_Kind_Id = p.Request_Kind_Id);
commit;

exec Htt_Core.Gen_Request_Kind_Accruals;
