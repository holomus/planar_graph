prompt migr 29.10.2021
----------------------------------------------------------------------------------------------------
create table htt_location_types(
  company_id                      number(20)         not null,
  location_type_id                number(20)         not null,
  name                            varchar2(100 char) not null,
  color                           varchar2(100),
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_location_types_pk primary key (company_id, location_type_id) using index tablespace GWS_INDEX,
  constraint htt_location_types_u1 unique (location_type_id) using index tablespace GWS_INDEX,
  constraint htt_location_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_location_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_location_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_location_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index htt_locations_types_u2 on htt_location_types(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index htt_location_types_i1 on htt_location_types(company_id, created_by) tablespace GWS_INDEX;
create index htt_location_types_i2 on htt_location_types(company_id, modified_by) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create sequence htt_location_types_sq;

---------------------------------------------------------------------------------------------------- 
alter table htt_locations add location_type_id number(20);

drop index htt_locations_i1;
drop index htt_locations_i2;
drop index htt_locations_i3;
drop index htt_locations_i4;

alter table htt_locations drop constraint htt_locations_f1;
alter table htt_locations drop constraint htt_locations_f2;
alter table htt_locations drop constraint htt_locations_f3;
alter table htt_locations drop constraint htt_locations_f4;

alter table htt_locations add constraint htt_locations_f1 foreign key (company_id, location_type_id) references htt_location_types(company_id, location_type_id);
alter table htt_locations add constraint htt_locations_f2 foreign key (timezone_code) references md_timezones(timezone_code);
alter table htt_locations add constraint htt_locations_f3 foreign key (company_id, region_id) references md_regions(company_id, region_id);
alter table htt_locations add constraint htt_locations_f4 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table htt_locations add constraint htt_locations_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id);

create index htt_locations_i1 on htt_locations(company_id, location_type_id) tablespace GWS_INDEX;
create index htt_locations_i2 on htt_locations(timezone_code) tablespace GWS_INDEX;
create index htt_locations_i3 on htt_locations(company_id, region_id) tablespace GWS_INDEX;
create index htt_locations_i4 on htt_locations(company_id, created_by) tablespace GWS_INDEX;
create index htt_locations_i5 on htt_locations(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
declare
  v_Person     Htt_Pref.Person_Rt;
  v_Photo_Shas Array_Varchar2;
begin
  Biruni_Route.Context_Begin;

  for Cmp in (select *
                from Md_Companies
               where Md_Util.Any_Project(Company_Id) is not null
                 and State = 'A')
  loop
    Ui_Auth.Logon_As_System(Cmp.Company_Id);
  
    for r in (select Np.Company_Id, --
                     Np.Person_Id,
                     Pi.Pin,
                     Pi.Pin_Code,
                     Pi.Rfid_Code
                from Href_Person_Details Np
                left join Htt_Persons Pi
                  on Pi.Company_Id = Np.Company_Id
                 and Pi.Person_Id = Np.Person_Id
               where Np.Company_Id = Cmp.Company_Id
                 and Pi.Qr_Code is null)
    loop
      select Photo_Sha
        bulk collect
        into v_Photo_Shas
        from Htt_Person_Photos q
       where q.Company_Id = r.Company_Id
         and q.Person_Id = r.Person_Id;
    
      Htt_Util.Person_New(o_Person     => v_Person,
                          i_Company_Id => r.Company_Id,
                          i_Person_Id  => r.Person_Id,
                          i_Pin        => r.Pin,
                          i_Pin_Code   => r.Pin_Code,
                          i_Rfid_Code  => r.Rfid_Code,
                          i_Qr_Code    => Htt_Util.Qr_Code_Gen(r.Person_Id),
                          i_Photos     => v_Photo_Shas);
    
      Htt_Api.Person_Save(v_Person);
    end loop;
  end loop;

  Biruni_Route.Context_End;
  commit;
end;
/

---------------------------------------------------------------------------------------------------- 
declare
begin
  Ui_Auth.Logon_As_System(Md_Pref.c_Company_Head);

  Ker_Core.Head_Template_Save(i_Form     => Hpr_Pref.c_Easy_Report_Form_Timebook,
                              i_Name     => 'Табель',
                              i_Order_No => 1,
                              i_Pcode    => 'vhr:hpr:1');
  commit;
end;
/

----------------------------------------------------------------------------------------------------
alter table hpr_book_operations add autofilled varchar2(1);
alter table hpr_book_operations add constraint hpr_book_operations_c3 check (autofilled in ('Y', 'N'));

---------------------------------------------------------------------------------------------------- 
update Hpr_Book_Operations
   set Autofilled = 'Y';

commit;

----------------------------------------------------------------------------------------------------
alter table hpr_book_operations modify autofilled not null;
