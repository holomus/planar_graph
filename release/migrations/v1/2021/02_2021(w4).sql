prompt Migr from 02.2021 4nd week

----------------------------------------------------------------------------------------------------
create table htt_device_admins(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  device_id                       number(20) not null,
  person_id                       number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_device_admins_pk primary key (company_id, filial_id, device_id, person_id) using index tablespace GWS_INDEX,
  constraint htt_device_admins_f1 foreign key (company_id, filial_id, device_id) references htt_devices(company_id, filial_id, device_id) on delete cascade,
  constraint htt_device_admins_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_device_admins_f3 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index htt_device_admins_i1 on htt_device_admins(company_id, person_id) tablespace GWS_INDEX;
create index htt_device_admins_i2 on htt_device_admins(company_id, created_by) tablespace GWS_INDEX;

declare
begin
  for r in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
    
    for r_Per in (select *
                    from Hzk_Device_Persons q
                   where q.Company_Id = r.Company_Id
                     and q.Person_Role = Hzk_Pref.c_Pr_Admin)
    loop
      insert into Htt_Device_Admins
        (Company_Id, Filial_Id, Device_Id, Person_Id, Created_By, Created_On)
      values
        (r_Per.Company_Id,
         r_Per.Filial_Id,
         r_Per.Device_Id,
         r_Per.Person_Id,
         Ui.User_Id,
         Current_Timestamp);
    end loop;
  end loop;

  commit;
end;
/

alter table hzk_device_persons drop column person_role;
