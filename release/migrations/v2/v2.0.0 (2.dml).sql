prompt migr from 04.07.2022 2.dml
----------------------------------------------------------------------------------------------------
prompt update division managers
----------------------------------------------------------------------------------------------------
insert into hrm_division_managers
  (company_id, filial_id, division_id, employee_id)
  select dm.company_id, dm.filial_id, dm.division_id, r.person_id
    from mrf_division_managers dm
    join mrf_robots r
      on r.company_id = dm.company_id
     and r.filial_id = dm.filial_id
     and r.robot_id = dm.manager_id
     and exists (select 1
            from mhr_employees e
           where e.company_id = r.company_id
             and e.filial_id = r.filial_id
             and e.employee_id = r.person_id);

insert into hrm_robot_divisions
  (company_id, filial_id, robot_id, division_id, access_type)
  select s.company_id, s.filial_id, s.manager_id, s.division_id, 'S'
    from mrf_division_managers s
   where exists (select *
            from hrm_robots r
           where r.company_id = s.company_id
             and r.filial_id = s.filial_id
             and r.robot_id = s.manager_id);
commit;

----------------------------------------------------------------------------------------------------
prompt update hrm_settings
----------------------------------------------------------------------------------------------------
update hrm_settings 
   set autogen_staff_number = 'N';
commit;

----------------------------------------------------------------------------------------------------
prompt update staff_number if it is not unique
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select q.Company_Id,
                   q.Filial_Id,
                   q.Staff_Number,
                   (select min(s.Staff_Id)
                      from Href_Staffs s
                     where s.Company_Id = q.Company_Id
                       and s.Filial_Id = q.Filial_Id
                       and s.Staff_Number = q.Staff_Number) as First_Staff_Id
              from Href_Staffs q
             group by q.Company_Id, q.Filial_Id, q.Staff_Number
            having count(*) > 1)
  loop
    update Href_Staffs s
       set s.Staff_Number = s.Staff_Number || '(' || s.Staff_Id || ')'
     where s.Company_Id = r.Company_Id
       and s.Filial_Id = r.Filial_Id
       and s.Staff_Number = r.Staff_Number
       and s.Staff_Id <> r.First_Staff_Id;
  
    commit;
  end loop;
end;
/
