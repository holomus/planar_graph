prompt adding position booking
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update hpd_page_robots 
   set is_booked = 'N';
   
insert into Hrm_Register_Rank_Indicators
  (Company_Id, Filial_Id, Register_Id, Rank_Id, Indicator_Id, Indicator_Value, Coefficient)
  select q.Company_Id,
         q.Filial_Id,
         q.Register_Id,
         q.Rank_Id,
         (select w.Indicator_Id
            from Href_Indicators w
           where w.Company_Id = q.Company_Id
             and w.Pcode = 'VHR:1') as Indicator_Id,
         q.Wage,
         q.Coefficient
    from Hrm_Register_Ranks q;
    
insert into hpr_wage_sheet_divisions
  (company_id, filial_id, sheet_id, division_id)
  select w.company_id, w.filial_id, w.sheet_id, w.division_id
    from hpr_wage_sheets w
   where w.division_id is not null;    

update hpr_books 
   set modified_id = biruni_modified_sq.nextval;
commit;
