prompt migr 08.09.2021
alter table href_person_details add access_all_employees varchar2(1);
alter table href_person_details add constraint href_person_details_c6 check (access_all_employees in ('Y', 'N'));

update href_person_details
   set access_all_employees = 'N';

alter table href_person_details modify access_all_employees not null;

----------------------------------------------------------------------------------------------------
alter table hpr_timebook_schedules drop constraint hpr_timebook_schedules_u2;
alter table hpr_timebook_schedules add constraint hpr_timebook_schedules_u2 unique (company_id, filial_id, staff_unit_id, schedule_id) using index tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
alter table hpr_book_operations add part_begin date;
alter table hpr_book_operations add part_end date;

update Hpr_Book_Operations q
   set q.Part_Begin =
       (select w.Month
          from Mpr_Books w
         where w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and w.Book_Id = q.Book_Id),
       q.Part_End  =
       (select Last_Day(w.Month)
          from Mpr_Books w
         where w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and w.Book_Id = q.Book_Id);
commit;
alter table hpr_book_operations modify part_begin not null;
alter table hpr_book_operations modify part_end not null;
alter table hpr_book_operations add constraint hpr_book_operations_c1 check (part_begin <= part_end);
alter table hpr_book_operations add constraint hpr_book_operations_c2 check (part_begin = trunc(part_begin) and part_end = trunc(part_end));

----------------------------------------------------------------------------------------------------
create table hpr_book_oper_locks(
  company_id                      number(20) not null,  
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  oper_type_id                    number(20) not null,
  part_begin                      date       not null,
  part_end                        date       not null,
  book_id                         number(20) not null,
  operation_id                    number(20) not null,
  constraint hpr_book_oper_locks_pk primary key (company_id, filial_id, staff_id, oper_type_id, part_begin) using index tablespace GWS_INDEX,
  constraint hpr_book_oper_locks_f1 foreign key (company_id, filial_id, book_id) references mpr_books(company_id, filial_id, book_id),
  constraint hpr_book_oper_locks_f2 foreign key (company_id, filial_id, book_id, operation_id) references hpr_book_operations(company_id, filial_id, book_id, operation_id),
  constraint hpr_book_oper_locks_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_book_oper_locks_f4 foreign key (company_id, oper_type_id) references hpr_oper_types(company_id, oper_type_id),
  constraint hpr_book_oper_locks_c1 check (part_begin <= part_end)
) tablespace GWS_DATA;

create index hpr_book_oper_locks_i1 on hpr_book_oper_locks(company_id, filial_id, book_id, operation_id) tablespace GWS_INDEX;
create index hpr_book_oper_locks_i2 on hpr_book_oper_locks(company_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
insert into Hpr_Book_Oper_Locks
  (Company_Id, Filial_Id, Staff_Id, Oper_Type_Id, Part_Begin, Part_End, Book_Id, Operation_Id)
  select q.Company_Id,
         q.Filial_Id,
         k.Staff_Id,
         w.Oper_Type_Id,
         Trunc(q.Month, 'MON'),
         Trunc(Last_Day(q.Month)),
         q.Book_Id,
         w.Operation_Id
    from Mpr_Books q
    join Mpr_Book_Operations w
      on q.Company_Id = w.Company_Id
     and q.Filial_Id = w.Filial_Id
     and q.Book_Id = w.Book_Id
    join Hpr_Book_Operations k
      on w.Company_Id = k.Company_Id
     and w.Filial_Id = k.Filial_Id
     and w.Operation_Id = k.Operation_Id
   where q.Posted = 'Y'; 
   
commit;
