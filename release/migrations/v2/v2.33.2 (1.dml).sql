prompt gen htt person for all employees
----------------------------------------------------------------------------------------------------
declare
  v_Htt_Person Htt_Pref.Person_Rt;
begin
  for r in (select k.*
              from Md_Companies k
             where exists (select 1
                      from Mhr_Employees q
                     where q.Company_Id = k.Company_Id
                       and not exists (select 1
                              from Htt_Persons Pp
                             where Pp.Company_Id = q.Company_Id
                               and Pp.Person_Id = q.Employee_Id)))
  loop
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    for Emp in (select Np.*
                  from Mr_Natural_Persons Np
                 where Np.Company_Id = r.Company_Id
                   and exists (select *
                          from Mhr_Employees Ep
                         where Ep.Company_Id = Np.Company_Id
                           and Ep.Employee_Id = Np.Person_Id)
                   and not exists (select 1
                          from Htt_Persons Pp
                         where Pp.Company_Id = Np.Company_Id
                           and Pp.Person_Id = Np.Person_Id))
    loop
      Htt_Util.Person_New(o_Person     => v_Htt_Person,
                          i_Company_Id => Emp.Company_Id,
                          i_Person_Id  => Emp.Person_Id,
                          i_Pin        => null,
                          i_Pin_Code   => null,
                          i_Rfid_Code  => null,
                          i_Qr_Code    => Htt_Util.Qr_Code_Gen(Emp.Person_Id));
    
      if Htt_Util.Pin_Autogenerate(Emp.Company_Id) = 'Y' then
        v_Htt_Person.Pin := Htt_Core.Next_Pin(Emp.Company_Id);
      end if;
    
      Htt_Api.Person_Save(v_Htt_Person);
    end loop;
  
    Biruni_Route.Context_End;
  end loop;

  commit;
end;
/
