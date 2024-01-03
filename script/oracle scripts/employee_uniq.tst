PL/SQL Developer Test script 3.0
31
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  for r in (select q.Company_Id,
                   q.Filial_Id,
                   max(to_number(q.Employee_Number)) Mx,
                   (select w.Value
                      from Md_Sequences w
                     where w.Company_Id = q.Company_Id
                       and w.Code = 'MHR_EMPLOYEES:EMPLOYEE_NUMBER'
                       and w.Filial_Id = q.Filial_Id)
              from (select q.*, to_number(q.Employee_Number) Emp_Numb
                      from Mhr_Employees q
                     where Regexp_Like(q.Employee_Number, '^\d*$')) q
             where to_number(q.Emp_Numb) < 15000
             group by q.Company_Id, q.Filial_Id
            having max(to_number(q.Employee_Number)) > (select w.Value
                                                         from Md_Sequences w
                                                        where w.Company_Id = q.Company_Id
                                                          and w.Code =
                                                              'MHR_EMPLOYEES:EMPLOYEE_NUMBER'
                                                          and w.Filial_Id = q.Filial_Id))
  loop
    z_Md_Sequences.Update_One(i_Company_Id => r.Company_Id,
                              i_Filial_Id  => r.Filial_Id,
                              i_Code       => 'MHR_EMPLOYEES:EMPLOYEE_NUMBER',
                              i_Value      => Option_number(r.Mx + 1));
  end loop;
end;
0
0
