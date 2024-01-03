prompt Migr from 03.2021 2nd week
----------------------------------------------------------------------------------------------------
prompt sequence changes
----------------------------------------------------------------------------------------------------
drop sequence hpr_operations_sq;
drop sequence hpr_documents_sq;
drop sequence hpr_doc_operations_sq;

create sequence hpr_oper_groups_sq;
create sequence hpr_book_types_sq;

----------------------------------------------------------------------------------------------------
prompt hpr_settings data to mpr_settings
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Hpr_Settings)
  loop
    insert into Mpr_Settings
      (Company_Id,
       Filial_Id,
       Income_Tax_Exists,
       Income_Tax_Rate,
       Pension_Payment_Exists,
       Pension_Payment_Rate,
       Social_Payment_Exists,
       Social_Payment_Rate)
    values
      (r.Company_Id,
       r.Filial_Id,
       Nvl2(r.Income_Tax_Rate, 'Y', 'N'),
       r.Income_Tax_Rate,
       Nvl2(r.Pension_Payment_Rate, 'Y', 'N'),
       r.Pension_Payment_Rate,
       Nvl2(r.Social_Payment_Rate, 'Y', 'N'),
       r.Social_Payment_Rate);
  end loop;
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt changes in hpr_indicators
----------------------------------------------------------------------------------------------------
alter table hpr_oper_indicators drop constraint hpr_oper_indicators_f2;
alter table hpd_hire_indicators drop constraint hpd_hire_indicators_f2;
alter table hpd_trans_indicators drop constraint hpd_trans_indicators_f2;
alter table hrm_pos_indicators drop constraint hrm_pos_indicators_f2;
alter table hpr_doc_operation_indicators drop constraint hpr_doc_operation_indicators_f2;
alter table hrm_staff_indicators drop constraint hrm_staff_indicators_f2;

drop index hpr_oper_indicators_i1;
drop index hpd_hire_indicators_i1;
drop index hpd_trans_indicators_i1;
drop index hrm_pos_indicators_i1;
drop index hpr_doc_operation_indicators_i1;
drop index hrm_staff_indicators_i1;

---------------------------------------------------------------------------------------------------- 
declare
  r_Ind Hpr_Indicators%rowtype;
begin
  for r_Ind in (select q.Company_Id, q.Pcode, max(q.Indicator_Id) Indicator_Id
                  from Hpr_Indicators q
                 group by q.Company_Id, q.Pcode)
  loop
    for r in (select *
                from Hpr_Indicators q
               where q.Company_Id = r_Ind.Company_Id
                 and q.Pcode = r_Ind.Pcode
                 and q.Indicator_Id <> r_Ind.Indicator_Id)
    loop
      update Hpr_Oper_Indicators q
         set q.Indicator_Id = r_Ind.Indicator_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Indicator_Id = r.Indicator_Id;
    
      update Hpr_Doc_Operation_Indicators q
         set q.Indicator_Id = r_Ind.Indicator_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Indicator_Id = r.Indicator_Id;
    
      update Hpd_Hire_Indicators q
         set q.Indicator_Id = r_Ind.Indicator_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Indicator_Id = r.Indicator_Id;
    
      update Hpd_Trans_Indicators q
         set q.Indicator_Id = r_Ind.Indicator_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Indicator_Id = r.Indicator_Id;
    
      update Hrm_Pos_Indicators q
         set q.Indicator_Id = r_Ind.Indicator_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Indicator_Id = r.Indicator_Id;
    
      update Hrm_Staff_Indicators q
         set q.Indicator_Id = r_Ind.Indicator_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Indicator_Id = r.Indicator_Id;
    end loop;
  
    delete from Hpr_Indicators q
     where q.Company_Id = r_Ind.Company_Id
       and q.Pcode = r_Ind.Pcode
       and q.Indicator_Id <> r_Ind.Indicator_Id;
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
alter table hpr_indicators drop constraint hpr_indicators_pk;
alter table hpr_indicators drop column filial_id;
alter table hpr_indicators add constraint hpr_indicators_pk primary key (company_id, indicator_id) using index tablespace GWS_INDEX;

create unique index hpr_indicators_u2 on hpr_indicators(company_id, lower(identifier)) tablespace GWS_INDEX;
create unique index hpr_indicators_u3 on hpr_indicators(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;
create index hpr_indicators_i3 on hpr_indicators(company_id, pcode) tablespace GWS_INDEX;

alter table hpr_oper_indicators add constraint hpr_oper_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id);
alter table hpd_hire_indicators add constraint hpd_hire_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id);
alter table hpd_trans_indicators add constraint hpd_trans_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id);
alter table hrm_pos_indicators add constraint hrm_pos_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id);
alter table hpr_doc_operation_indicators add constraint hpr_doc_operation_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id);
alter table hrm_staff_indicators add constraint hrm_staff_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id);

create index hpr_oper_indicators_i1 on hpr_oper_indicators(company_id, indicator_id) tablespace GWS_DATA;
create index hpd_hire_indicators_i1 on hpd_hire_indicators(company_id, indicator_id) tablespace GWS_DATA;
create index hpd_trans_indicators_i1 on hpd_trans_indicators(company_id, indicator_id) tablespace GWS_DATA;
create index hrm_pos_indicators_i1 on hrm_pos_indicators(company_id, indicator_id) tablespace GWS_DATA;
create index hpr_doc_operation_indicators_i1 on hpr_doc_operation_indicators(company_id, indicator_id) tablespace GWS_DATA;
create index hrm_staff_indicators_i1 on hrm_staff_indicators(company_id, indicator_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt new tables
----------------------------------------------------------------------------------------------------
create table hpr_oper_groups(
  company_id                      number(20)         not null,
  oper_group_id                   number(20)         not null,
  operation_kind                  varchar2(1)        not null,
  name                            varchar2(100 char) not null,
  estimation_type                 varchar2(1)        not null,
  estimation_formula              varchar2(300 char),
  pcode                           varchar2(20)       not null,
  constraint hpr_oper_groups_pk primary key (company_id, oper_group_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_groups_u1 unique (oper_group_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_groups_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint hpr_oper_groups_c2 check (operation_kind in ('A', 'D')),
  constraint hpr_oper_groups_c3 check (estimation_type in ('C', 'F', 'E')),
  constraint hpr_oper_groups_c4 check (decode(estimation_type, 'F', 1, 0) = nvl2(estimation_formula, 1, 0))
) tablespace GWS_DATA;

comment on column hpr_oper_groups.operation_kind is '(A)ccrual, (D)eduction';
comment on column hpr_oper_groups.estimation_type is 'The result is: (C)alculated, calculated by the (F)ormula, (E)ntered as a fixed amount';

create index hpr_oper_groups_i1 on hpr_oper_groups(company_id, pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_oper_type_templates(
  template_id                     number(20) not null,
  oper_type_id                    number(20) not null,
  oper_group_id                   number(20) not null,
  estimation_type                 varchar2(1),
  estimation_formula              varchar2(300 char),
  constraint hpr_oper_type_templates_pk primary key (template_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_type_templates_f1 foreign key (template_id, oper_type_id) references mpr_oper_type_templates(template_id, oper_type_id) on delete cascade
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table hpr_oper_types(
  company_id                      number(20) not null,
  oper_type_id                    number(20) not null,
  oper_group_id                   number(20) not null,
  estimation_type                 varchar2(1),
  estimation_formula              varchar2(300 char),
  constraint hpr_oper_types_pk primary key (company_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_types_f1 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id) on delete cascade,
  constraint hpr_oper_types_f2 foreign key (company_id, oper_group_id) references hpr_oper_groups(company_id, oper_group_id),
  constraint hpr_oper_types_c1 check (estimation_type in ('C', 'F', 'E')),
  constraint hpr_oper_types_c2 check (decode(estimation_type, 'F', 1, 0) = nvl2(estimation_formula, 1, 0))
) tablespace GWS_DATA;

comment on column hpr_oper_types.estimation_type is 'The result is: (C)alculated, calculated by the (F)ormula, (E)ntered as a fixed amount';

create index hpr_oper_types_i1 on hpr_oper_types(company_id, oper_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_oper_type_indicators(
  company_id                      number(20)        not null,
  oper_type_id                    number(20)        not null,
  indicator_id                    number(20)        not null,
  identifier                      varchar2(50 char) not null,
  constraint hpr_oper_type_indicators_pk primary key (company_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpr_oper_type_indicators_f1 foreign key (company_id, oper_type_id) references hpr_oper_types(company_id, oper_type_id) on delete cascade,
  constraint hpr_oper_type_indicators_f2 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpr_oper_type_indicators_i1 on hpr_oper_type_indicators(company_id, indicator_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------              
create table hpr_book_types(
  company_id                      number(20)   not null,
  book_type_id                    number(20)   not null,
  name                            varchar2(20) not null,
  pcode                           varchar2(20) not null,
  constraint hpr_book_types_pk primary key (company_id, book_type_id) using index tablespace GWS_INDEX,
  constraint hpr_book_types_u1 unique (book_type_id) using index tablespace GWS_INDEX,
  constraint hpr_book_types_c1 check (decode(trim(name), name, 1, 0) = 1)
) tablespace GWS_DATA;

create index hpr_book_types_i1 on hpr_book_types(company_id, pcode) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------     
create table hpr_book_type_binds(
  company_id                      number(20) not null,
  book_type_id                    number(20) not null,
  oper_group_id                   number(20) not null,
  constraint hpr_book_type_binds_pk primary key (company_id, book_type_id, oper_group_id) using index tablespace GWS_INDEX,
  constraint hpr_book_type_binds_f1 foreign key (company_id, book_type_id) references hpr_book_types(company_id, book_type_id) on delete cascade,
  constraint hpr_book_type_binds_f2 foreign key (company_id, oper_group_id) references hpr_oper_groups(company_id, oper_group_id)
) tablespace GWS_DATA;

create index hpr_book_type_binds_i1 on hpr_book_type_binds(company_id, oper_group_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------              
create table hpr_books(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  book_id                         number(20) not null,
  book_type_id                    number(20) not null,
  constraint hpr_books_pk primary key (company_id, filial_id, book_id) using index tablespace GWS_INDEX,
  constraint hpr_books_f1 foreign key (company_id, filial_id, book_id) references mpr_books(company_id, filial_id, book_id) on delete cascade,
  constraint hpr_books_f2 foreign key (company_id, book_type_id) references hpr_book_types(company_id, book_type_id)
) tablespace GWS_DATA;

create index hpr_books_i1 on hpr_books(company_id, book_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_book_oper_indicators(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  book_id                         number(20)   not null,
  operation_id                    number(20)   not null,
  indicator_id                    number(20)   not null,
  indicator_value                 number(20,6) not null,
  constraint hpr_book_oper_indicators_pk primary key (company_id, filial_id, book_id, operation_id, indicator_id) using index tablespace GWS_INDEX,
  constraint hpr_book_oper_indicators_f1 foreign key (company_id, filial_id, book_id) references hpr_books(company_id, filial_id, book_id) on delete cascade,
  constraint hpr_book_oper_indicators_f2 foreign key (company_id, filial_id, book_id, operation_id) references mpr_book_operations(company_id, filial_id, book_id, operation_id) on delete cascade,
  constraint hpr_book_oper_indicators_f3 foreign key (company_id, indicator_id) references hpr_indicators(company_id, indicator_id)
) tablespace GWS_DATA;

create index hpr_book_oper_indicators_i1 on hpr_book_oper_indicators(company_id, indicator_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt operation changed to oper_type tables
----------------------------------------------------------------------------------------------------
create table hpd_hire_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  hiring_id                       number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hpd_hire_oper_types_pk primary key (company_id, filial_id, hiring_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpd_hire_oper_types_f1 foreign key (company_id, filial_id, hiring_id) references hpd_hirings(company_id, filial_id, hiring_id) on delete cascade,
  constraint hpd_hire_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hpd_hire_oper_types_i1 on hpd_hire_oper_types(company_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpd_trans_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  transfer_id                     number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hpd_trans_oper_types_pk primary key (company_id, filial_id, transfer_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_oper_types_f1 foreign key (company_id, filial_id, transfer_id) references hpd_transfers(company_id, filial_id, transfer_id) on delete cascade,
  constraint hpd_trans_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hpd_trans_oper_types_i1 on hpd_trans_oper_types(company_id, filial_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_pos_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  position_id                     number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hrm_pos_oper_types_pk primary key (company_id, filial_id, position_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hrm_pos_oper_types_f1 foreign key (company_id, filial_id, position_id) references hrm_positions(company_id, filial_id, position_id) on delete cascade,
  constraint hrm_pos_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hrm_pos_oper_types_i1 on hrm_pos_oper_types(company_id, filial_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hrm_staff_oper_types(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_position_id               number(20) not null,
  oper_type_id                    number(20) not null,
  constraint hrm_staff_oper_types_pk primary key (company_id, filial_id, staff_position_id, oper_type_id) using index tablespace GWS_INDEX,
  constraint hrm_staff_oper_types_f1 foreign key (company_id, filial_id, staff_position_id) references hrm_staff_positions(company_id, filial_id, staff_position_id) on delete cascade,
  constraint hrm_staff_oper_types_f2 foreign key (company_id, oper_type_id) references mpr_oper_types(company_id, oper_type_id)
) tablespace GWS_DATA;

create index hrm_staff_oper_types_i1 on hrm_staff_oper_types(company_id, filial_id, oper_type_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table hpd_hire_indicators drop constraint hpd_hire_indicators_pk;
alter table hpd_trans_indicators drop constraint hpd_trans_indicators_pk;
alter table hrm_pos_indicators drop constraint hrm_pos_indicators_pk;
alter table hrm_staff_indicators drop constraint hrm_staff_indicators_pk;

alter table hpd_hire_indicators drop constraint hpd_hire_indicators_f1;
alter table hpd_trans_indicators drop constraint hpd_trans_indicators_f1;
alter table hrm_pos_indicators drop constraint hrm_pos_indicators_f1;
alter table hrm_staff_indicators drop constraint hrm_staff_indicators_f1;

----------------------------------------------------------------------------------------------------
declare
  v_Oper_Group             Fazo.Number_Id_Aat;
  v_Oper_Type              Fazo.Number_Id_Aat;
  v_Book_Type_Id           number;
  v_Book_Id                number;
  v_Book_Oper_Id           number;
  v_Accrued_Amount         number;
  v_Deducted_Amount        number;
  v_Income_Tax_Amount      number;
  v_Pension_Payment_Amount number;
  v_Social_Payment_Amount  number;
begin
  for r in (select *
              from Md_Companies q
             where q.State = 'A')
  loop
    if Md_Util.Any_Project(r.Company_Id) is null then
      if r.Company_Id = Md_Pref.Company_Head then
        insert into Hpr_Oper_Groups
          (Company_Id,
           Oper_Group_Id,
           Operation_Kind,
           name,
           Estimation_Type,
           Estimation_Formula,
           Pcode)
        values
          (r.Company_Id,
           Hpr_Oper_Groups_Sq.Nextval,
           'A',
           'Повременная оплата труда и надбавки',
           'F',
           'Оклад * ДоляНеполногоРабочегоВремени * ВремяВДнях / НормаДней',
           'VHR:1');
      
        insert into Hpr_Book_Types
          (Company_Id, Book_Type_Id, name, Pcode)
        values
          (r.Company_Id,
           Hpr_Book_Types_Sq.Nextval,
           'Начисление оклада и взносов',
           'VHR:1');
      end if;
    
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    -- hpr_oper_groups
    for r_Type in (select *
                     from Hpr_Operation_Types)
    loop
      v_Oper_Group(r_Type.Operation_Type) := Hpr_Oper_Groups_Sq.Nextval;
    
      insert into Hpr_Oper_Groups
        (Company_Id,
         Oper_Group_Id,
         Operation_Kind,
         name,
         Estimation_Type,
         Estimation_Formula,
         Pcode)
      values
        (r.Company_Id,
         v_Oper_Group(r_Type.Operation_Type),
         r_Type.Operation_Kind,
         r_Type.Name,
         r_Type.Estimation_Type,
         r_Type.Estimation_Formula,
         'VHR:1');
    end loop;
  
    -- mpr_oper_types
    for r_Operation in (select *
                          from Hpr_Operations q
                         where q.Company_Id = r.Company_Id
                         order by q.Filial_Id, q.Operation_Id)
    loop
      v_Oper_Type(r_Operation.Operation_Id) := Mpr_Oper_Types_Sq.Nextval;
    
      insert into Mpr_Oper_Types
        (Company_Id,
         Oper_Type_Id,
         Operation_Kind,
         name,
         Short_Name,
         Accounting_Type,
         Corr_Coa_Id,
         Corr_Ref_Set,
         Income_Tax_Exists,
         Pension_Payment_Exists,
         Social_Payment_Exists,
         Note,
         State,
         Code,
         Created_By,
         Created_On,
         Modified_By,
         Modified_On)
      values
        (r_Operation.Company_Id,
         v_Oper_Type(r_Operation.Operation_Id),
         r_Operation.Operation_Kind,
         r_Operation.Name,
         r_Operation.Short_Name,
         r_Operation.Accounting_Type,
         r_Operation.Corr_Coa_Id,
         r_Operation.Corr_Ref_Set,
         r_Operation.Income_Tax_Exists,
         r_Operation.Pension_Payment_Exists,
         r_Operation.Social_Payment_Exists,
         r_Operation.Note,
         r_Operation.State,
         r_Operation.Code,
         r_Operation.Created_By,
         r_Operation.Created_On,
         r_Operation.Modified_By,
         r_Operation.Modified_On);
    
      insert into Hpr_Oper_Types
        (Company_Id, Oper_Type_Id, Oper_Group_Id, Estimation_Type, Estimation_Formula)
      values
        (r_Operation.Company_Id,
         v_Oper_Type(r_Operation.Operation_Id),
         v_Oper_Group(r_Operation.Operation_Type),
         r_Operation.Estimation_Type,
         r_Operation.Estimation_Formula);
    
      for r_Ind in (select *
                      from Hpr_Oper_Indicators q
                     where q.Company_Id = r_Operation.Company_Id
                       and q.Filial_Id = r_Operation.Filial_Id
                       and q.Operation_Id = r_Operation.Operation_Id)
      loop
        insert into Hpr_Oper_Type_Indicators
          (Company_Id, Oper_Type_Id, Indicator_Id, Identifier)
        values
          (r_Ind.Company_Id,
           v_Oper_Type(r_Operation.Operation_Id),
           r_Ind.Indicator_Id,
           r_Ind.Identifier);
      end loop;
    end loop;
  
    -- hpd_hire_oper_types
    delete from Hpd_Hire_Indicators q
     where q.Company_Id = r.Company_Id
       and not exists (select 1
              from Hpd_Hire_Operations w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Hiring_Id = q.Hiring_Id
               and w.Operation_Id = q.Operation_Id);
  
    for r_Hire in (select *
                     from Hpd_Hire_Operations q
                    where q.Company_Id = r.Company_Id)
    loop
      insert into Hpd_Hire_Oper_Types
        (Company_Id, Filial_Id, Hiring_Id, Oper_Type_Id)
      values
        (r_Hire.Company_Id, r_Hire.Filial_Id, r_Hire.Hiring_Id, v_Oper_Type(r_Hire.Operation_Id));
    
      update Hpd_Hire_Indicators s
         set s.Oper_Type_Id = v_Oper_Type(r_Hire.Operation_Id)
       where s.Company_Id = r_Hire.Company_Id
         and s.Filial_Id = r_Hire.Filial_Id
         and s.Hiring_Id = r_Hire.Hiring_Id
         and s.Oper_Type_Id = r_Hire.Operation_Id;
    end loop;
  
    -- hpd_trans_oper_types
    delete from Hpd_Trans_Indicators q
     where q.Company_Id = r.Company_Id
       and not exists (select 1
              from Hpd_Trans_Operations w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Transfer_Id = q.Transfer_Id
               and w.Operation_Id = q.Operation_Id);
  
    for r_Trans in (select *
                      from Hpd_Trans_Operations q
                     where q.Company_Id = r.Company_Id)
    loop
      insert into Hpd_Trans_Oper_Types
        (Company_Id, Filial_Id, Transfer_Id, Oper_Type_Id)
      values
        (r_Trans.Company_Id,
         r_Trans.Filial_Id,
         r_Trans.Transfer_Id,
         v_Oper_Type(r_Trans.Operation_Id));
    
      update Hpd_Trans_Indicators s
         set s.Oper_Type_Id = v_Oper_Type(r_Trans.Operation_Id)
       where s.Company_Id = r_Trans.Company_Id
         and s.Filial_Id = r_Trans.Filial_Id
         and s.Transfer_Id = r_Trans.Transfer_Id
         and s.Oper_Type_Id = r_Trans.Operation_Id;
    end loop;
  
    -- hrm_pos_oper_types
    delete from Hrm_Pos_Indicators q
     where q.Company_Id = r.Company_Id
       and not exists (select 1
              from Hrm_Pos_Operations w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Position_Id = q.Position_Id
               and w.Operation_Id = q.Operation_Id);
  
    for r_Pos in (select *
                    from Hrm_Pos_Operations q
                   where q.Company_Id = r.Company_Id)
    loop
      insert into Hrm_Pos_Oper_Types
        (Company_Id, Filial_Id, Position_Id, Oper_Type_Id)
      values
        (r_Pos.Company_Id, r_Pos.Filial_Id, r_Pos.Position_Id, v_Oper_Type(r_Pos.Operation_Id));
    
      update Hrm_Pos_Indicators s
         set s.Oper_Type_Id = v_Oper_Type(r_Pos.Operation_Id)
       where s.Company_Id = r_Pos.Company_Id
         and s.Filial_Id = r_Pos.Filial_Id
         and s.Position_Id = r_Pos.Position_Id
         and s.Oper_Type_Id = r_Pos.Operation_Id;
    end loop;
  
    -- hrm_staff_oper_types
    delete from Hrm_Staff_Indicators q
     where q.Company_Id = r.Company_Id
       and not exists (select 1
              from Hrm_Staff_Operations w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Staff_Position_Id = q.Staff_Position_Id
               and w.Operation_Id = q.Operation_Id);
  
    for r_Staff in (select *
                      from Hrm_Staff_Operations q
                     where q.Company_Id = r.Company_Id)
    loop
      insert into Hrm_Staff_Oper_Types
        (Company_Id, Filial_Id, Staff_Position_Id, Oper_Type_Id)
      values
        (r_Staff.Company_Id,
         r_Staff.Filial_Id,
         r_Staff.Staff_Position_Id,
         v_Oper_Type(r_Staff.Operation_Id));
    
      update Hrm_Staff_Indicators s
         set s.Oper_Type_Id = v_Oper_Type(r_Staff.Operation_Id)
       where s.Company_Id = r_Staff.Company_Id
         and s.Filial_Id = r_Staff.Filial_Id
         and s.Staff_Position_Id = r_Staff.Staff_Position_Id
         and s.Oper_Type_Id = r_Staff.Operation_Id;
    end loop;
  
    -- hpr_book_types
    v_Book_Type_Id := Hpr_Book_Types_Sq.Nextval;
  
    insert into Hpr_Book_Types
      (Company_Id, Book_Type_Id, name, Pcode)
    values
      (r.Company_Id,
       v_Book_Type_Id,
       'Начисление оклада и взносов',
       'VHR:1');
  
    -- books
    for r_Doc in (select *
                    from Hpr_Documents q
                   where q.Company_Id = r.Company_Id)
    loop
      v_Book_Id := Mpr_Books_Sq.Nextval;
    
      select sum(Decode(w.Operation_Kind, 'A', q.Amount, 0)),
             sum(Decode(w.Operation_Kind, 'D', q.Amount, 0)),
             sum(Nvl(q.Income_Tax_Amount, 0)),
             sum(Nvl(q.Pension_Payment_Amount, 0)),
             sum(Nvl(q.Social_Payment_Amount, 0))
        into v_Accrued_Amount,
             v_Deducted_Amount,
             v_Income_Tax_Amount,
             v_Pension_Payment_Amount,
             v_Social_Payment_Amount
        from Hpr_Doc_Operations q
        join Hpr_Operations w
          on w.Company_Id = q.Company_Id
         and w.Operation_Id = q.Operation_Id
       where q.Company_Id = r_Doc.Company_Id
         and q.Filial_Id = r_Doc.Filial_Id
         and q.Document_Id = r_Doc.Document_Id;
    
      insert into Mpr_Books
        (Company_Id,
         Filial_Id,
         Book_Id,
         Book_Number,
         Book_Date,
         Book_Name,
         month,
         Division_Id,
         Currency_Id,
         Posted,
         Barcode,
         Note,
         c_Accrued_Amount,
         c_Accrued_Amount_Base,
         c_Deducted_Amount,
         c_Deducted_Amount_Base,
         c_Income_Tax_Amount,
         c_Pension_Payment_Amount,
         c_Social_Payment_Amount,
         Created_By,
         Created_On,
         Modified_By,
         Modified_On)
      values
        (r_Doc.Company_Id,
         r_Doc.Filial_Id,
         v_Book_Id,
         r_Doc.Document_Number,
         r_Doc.Document_Date,
         r_Doc.Document_Name,
         r_Doc.Month,
         r_Doc.Division_Id,
         Mk_Pref.Base_Currency(i_Company_Id => r_Doc.Company_Id, i_Filial_Id => r_Doc.Filial_Id),
         r_Doc.Posted,
         r_Doc.Barcode,
         r_Doc.Note,
         r_Doc.c_Accrued_Amount,
         r_Doc.c_Accrued_Amount,
         r_Doc.c_Deducted_Amount,
         r_Doc.c_Deducted_Amount,
         Nvl(v_Income_Tax_Amount, 0),
         Nvl(v_Pension_Payment_Amount, 0),
         Nvl(v_Social_Payment_Amount, 0),
         r_Doc.Created_By,
         r_Doc.Created_On,
         r_Doc.Modified_By,
         r_Doc.Modified_On);
    
      insert into Hpr_Books
        (Company_Id, Filial_Id, Book_Id, Book_Type_Id)
      values
        (r_Doc.Company_Id, r_Doc.Filial_Id, v_Book_Id, v_Book_Type_Id);
    
      -- book operations
      for r_Doc_Oper in (select *
                           from Hpr_Doc_Operations q
                          where q.Company_Id = r_Doc.Company_Id
                            and q.Filial_Id = r_Doc.Filial_Id
                            and q.Document_Id = r_Doc.Document_Id)
      loop
        v_Book_Oper_Id := Mpr_Book_Operations_Sq.Nextval;
      
        insert into Mpr_Book_Operations
          (Company_Id,
           Filial_Id,
           Book_Id,
           Operation_Id,
           Employee_Id,
           Oper_Type_Id,
           Amount,
           Amount_Base,
           Net_Amount,
           Income_Tax_Amount,
           Pension_Payment_Amount,
           Social_Payment_Amount)
        values
          (r_Doc_Oper.Company_Id,
           r_Doc_Oper.Filial_Id,
           v_Book_Id,
           v_Book_Oper_Id,
           r_Doc_Oper.Employee_Id,
           v_Oper_Type(r_Doc_Oper.Operation_Id),
           r_Doc_Oper.Amount,
           r_Doc_Oper.Amount,
           r_Doc_Oper.Net_Amount,
           r_Doc_Oper.Income_Tax_Amount,
           r_Doc_Oper.Pension_Payment_Amount,
           r_Doc_Oper.Social_Payment_Amount);
      
        -- book oper indicatoras
        for r_Doc_Ind in (select *
                            from Hpr_Doc_Operation_Indicators q
                           where q.Company_Id = r_Doc_Oper.Company_Id
                             and q.Filial_Id = r_Doc_Oper.Filial_Id
                             and q.Doc_Operation_Id = r_Doc_Oper.Doc_Operation_Id)
        loop
          insert into Hpr_Book_Oper_Indicators
            (Company_Id, Filial_Id, Book_Id, Operation_Id, Indicator_Id, Indicator_Value)
          values
            (r_Doc_Ind.Company_Id,
             r_Doc_Ind.Filial_Id,
             v_Book_Id,
             v_Book_Oper_Id,
             r_Doc_Ind.Indicator_Id,
             r_Doc_Ind.Indicator_Value);
        end loop;
      end loop;
    end loop;
  
    v_Oper_Group := Fazo.Number_Id_Aat();
    v_Oper_Type  := Fazo.Number_Id_Aat();
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
alter table hpd_hire_indicators rename column operation_id to oper_type_id;
alter table hpd_trans_indicators rename column operation_id to oper_type_id;
alter table hrm_pos_indicators rename column operation_id to oper_type_id;
alter table hrm_staff_indicators rename column operation_id to oper_type_id;

alter table hpd_hire_indicators add constraint hpd_hire_indicators_pk primary key (company_id, filial_id, hiring_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX;
alter table hpd_trans_indicators add constraint hpd_trans_indicators_pk primary key (company_id, filial_id, transfer_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX;
alter table hrm_pos_indicators add constraint hrm_pos_indicators_pk primary key (company_id, filial_id, position_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX;
alter table hrm_staff_indicators add constraint hrm_staff_indicators_pk primary key (company_id, filial_id, staff_position_id, oper_type_id, indicator_id) using index tablespace GWS_INDEX;

alter table hpd_hire_indicators add constraint hpd_hire_indicators_f1 foreign key (company_id, filial_id, hiring_id, oper_type_id) references hpd_hire_oper_types(company_id, filial_id, hiring_id, oper_type_id) on delete cascade;
alter table hpd_trans_indicators add constraint hpd_trans_indicators_f1 foreign key (company_id, filial_id, transfer_id, oper_type_id) references hpd_trans_oper_types(company_id, filial_id, transfer_id, oper_type_id) on delete cascade;
alter table hrm_pos_indicators add constraint hrm_pos_indicators_f1 foreign key (company_id, filial_id, position_id, oper_type_id) references hrm_pos_oper_types(company_id, filial_id, position_id, oper_type_id) on delete cascade;
alter table hrm_staff_indicators add constraint hrm_staff_indicators_f1 foreign key (company_id, filial_id, staff_position_id, oper_type_id) references hrm_staff_oper_types(company_id, filial_id, staff_position_id, oper_type_id) on delete cascade;

----------------------------------------------------------------------------------------------------
drop table hpr_settings;
drop table hpr_doc_operation_indicators;
drop table hpr_doc_operations;
drop table hpr_documents;
drop table hpd_hire_operations;
drop table hpd_trans_operations;
drop table hrm_pos_operations;
drop table hrm_staff_operations;
drop table hpr_oper_indicators;
drop table hpr_operations;
drop table hpr_operation_types;

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

alter table hzk_device_persons drop column person_role;

----------------------------------------------------------------------------------------------------
alter table htt_schedule_dates rename column break_enable to break_enabled;
alter table htt_schedule_dates rename column begin_break_time to break_begin_time;
alter table htt_schedule_dates rename column end_break_time to break_end_time;
alter table htt_schedule_dates rename column fulltime to full_time;
alter table htt_schedule_dates rename column plantime to plan_time;
alter table htt_schedule_dates rename column begin_shift_time to shift_begin_time;
alter table htt_schedule_dates rename column end_shift_time to shift_end_time;

alter table htt_schedule_pattern_days rename column break_enable to break_enabled;
alter table htt_schedule_pattern_days rename column begin_break_time to break_begin_time;
alter table htt_schedule_pattern_days rename column end_break_time to break_end_time;
alter table htt_schedule_pattern_days rename column plantime to plan_time;

----------------------------------------------------------------------------------------------------
create sequence htt_timesheets_sq;
----------------------------------------------------------------------------------------------------
create table htt_timesheets(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  timesheet_date                  date        not null,
  staff_id                        number(20)  not null,
  employee_id                     number(20)  not null,
  day_kind                        varchar2(1) not null,
  shift_begin_date                date,
  shift_end_date                  date,
  begin_time                      date,
  end_time                        date,
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  plan_time                       number(4)    not null,
  full_time                       number(4)    not null,
  in_time                         number(4)    not null,
  free_time                       number(4)    not null,
  fact_time                       as (in_time + free_time),
  late_time                       number(4)    not null,
  lack_time                       number(4)    not null,
  early_time                      number(4)    not null,
  input_time                      date,
  output_time                     date,
  constraint htt_timesheets_pk primary key (company_id, filial_id, timesheet_id) using index tablespace SMARTUP_INDEX,
  constraint htt_timesheets_u1 unique (timesheet_id) using index tablespace SMARTUP_INDEX,
  constraint htt_timesheets_u2 unique (company_id, filial_id, staff_id, timesheet_date) using index tablespace SMARTUP_INDEX,
  constraint htt_timesheets_f1 foreign key (company_id, filial_id, staff_id) references hrm_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_timesheets_c1 check (day_kind in ('W', 'R')),
  constraint htt_timesheets_c2 check (break_enabled in ('Y', 'N')),
  constraint htt_timesheets_c3 check (day_kind = 'R' or begin_time is not null and end_time is not null),
  constraint htt_timesheets_c4 check (day_kind = 'W' or full_time = 0),
  constraint htt_timesheets_c5 check (break_enabled = 'N' or break_begin_time is not null and break_end_time is not null),
  constraint htt_timesheets_c6 check (break_enabled = 'N' or day_kind = 'W'),
  constraint htt_timesheets_c7 check (plan_time >= in_time),
  constraint htt_timesheets_c8 check (in_time >= 0 and free_time >= 0 and late_time >= 0 and lack_time >= 0 and early_time >= 0),
  constraint htt_timesheets_c9 check (plan_time <= 1440)
) tablespace GWS_DATA;

comment on column htt_timesheets.day_kind is '(W)ork, (R)est';
comment on column htt_timesheets.break_enabled is '(Y)es, (N)o';
comment on column htt_timesheets.input_time is 'cached field from tracks';
comment on column htt_timesheets.output_time is 'cached field from tracks';

----------------------------------------------------------------------------------------------------
create table htt_timesheet_helpers(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  interval_date                   date        not null,
  timesheet_id                    number(20)  not null,
  day_kind                        varchar2(1) not null,
  shift_begin_date                date,
  shift_end_date                  date,
  constraint htt_timesheet_helpers_pk primary key (company_id, filial_id, staff_id, interval_date, timesheet_id) using index tablespace SMARTUP_INDEX,
  constraint htt_timesheet_helpers_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade
) tablespace SMARTUP_DATA;

create index htt_timesheet_helpers_i1 on htt_timesheet_helpers(company_id, filial_id, timesheet_id) tablespace SMARTUP_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  track_id                        number(20)  not null,
  track_datetime                  date        not null,
  track_type                      varchar2(1) not null,
  constraint htt_timesheet_tracks_pk primary key (company_id, filial_id, timesheet_id, track_id) using index tablespace SMARTUP_INDEX,
  constraint htt_timesheet_tracks_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_tracks_f2 foreign key (company_id, filial_id, track_id) references htt_tracks(company_id, filial_id, track_id)
) tablespace SMARTUP_DATA;

create index htt_timesheet_tracks_i1 on htt_timesheet_tracks(company_id, filial_id, track_id) tablespace SMARTUP_INDEX;

----------------------------------------------------------------------------------------------------
create global temporary table htt_dirty_timesheets(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  constraint htt_dirty_timesheets_pk primary key (company_id, filial_id, timesheet_id),
  constraint htt_dirty_timesheets_c1 check (timesheet_id is null) deferrable initially deferred
) on commit preserve rows;

prompt in hpr_timesheet_employees add staff_id and rename employee to staff
----------------------------------------------------------------------------------------------------
alter table hpr_timesheet_employees add staff_id number(20);

alter table hpr_timesheet_employees rename to hpr_timesheet_staffs;
alter table hpr_timesheet_dates drop constraint hpr_timesheet_dates_f1;
alter table hpr_timesheet_staffs drop constraint hpr_timesheet_employees_u1;
alter table hpr_timesheet_staffs drop constraint hpr_timesheet_employees_u2;
alter table hpr_timesheet_staffs drop constraint hpr_timesheet_employees_f1;
alter table hpr_timesheet_staffs drop constraint hpr_timesheet_employees_f2;
drop index hpr_timesheet_employees_i1;

alter table hpr_timesheet_staffs rename constraint hpr_timesheet_employees_pk to hpr_timesheet_staffs_pk;
alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_u1 unique (employee_unit_id) using index tablespace GWS_INDEX;
alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_u2 unique (company_id, filial_id, timesheet_id, staff_id) using index tablespace GWS_INDEX;
alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_f1 foreign key (company_id, filial_id, timesheet_id) references hpr_timesheets(company_id, filial_id, timesheet_id) on delete cascade;
alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_f2 foreign key (company_id, filial_id, staff_id) references hrm_staffs(company_id, filial_id, staff_id);
alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_f3 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id);
create index hpr_timesheet_staffs_i1 on hpr_timesheet_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpr_timesheet_staffs_i2 on hpr_timesheet_staffs(company_id, filial_id, employee_id) tablespace GWS_INDEX;

declare
begin
  for w in (select *
              from Md_Companies
             where State = 'A')
  loop
    if Md_Util.Any_Project(w.Company_Id) is null then
      continue;
    end if;
  
    Ui_Auth.Logon_As_System(w.Company_Id);
  
    for r in (select *
                from Mhr_Employees
               where Company_Id = w.Company_Id)
    loop
      insert into Hrm_Staffs
        (Company_Id,
         Filial_Id,
         Staff_Id,
         Staff_Number,
         Employee_Id,
         Status,
         Hiring_Date,
         Dismissal_Date,
         Created_By,
         Created_On,
         Modified_By,
         Modified_On)
      values
        (r.Company_Id,
         r.Filial_Id,
         Hrm_Next.Staff_Id,
         r.Employee_Number,
         r.Employee_Id,
         'U',
         null,
         null,
         r.Created_By,
         r.Created_On,
         r.Modified_By,
         r.Modified_On);
    end loop;
  
    update Hpr_Timesheet_Staffs q
       set q.Staff_Id =
           (select t.Staff_Id
              from Hrm_Staffs t
             where t.Company_Id = q.Company_Id
               and t.Filial_Id = q.Filial_Id
               and t.Employee_Id = q.Employee_Id)
     where q.Company_Id = w.Company_Id;
  end loop;
  
  commit;
end;
/

alter table hpr_timesheet_staffs modify staff_id not null;
----------------------------------------------------------------------------------------------------             
alter table hpr_timesheet_dates drop constraint hpr_timesheet_dates_f1;
alter table hpr_timesheet_staffs rename column employee_unit_id to staff_unit_id ;
alter table hpr_timesheet_dates rename column employee_unit_id to staff_unit_id;

alter table hpr_timesheet_staffs drop constraint hpr_timesheet_staffs_pk;
alter table hpr_timesheet_staffs drop constraint hpr_timesheet_staffs_u1;

alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_pk primary key (company_id, staff_unit_id) using index tablespace GWS_INDEX;
alter table hpr_timesheet_staffs add constraint hpr_timesheet_staffs_u1 unique (staff_unit_id) using index tablespace GWS_INDEX;
alter table hpr_timesheet_dates add constraint hpr_timesheet_dates_f1 foreign key (company_id, staff_unit_id) references hpr_timesheet_staffs(company_id, staff_unit_id) on delete cascade;

drop index hpr_timesheet_dates_i1;
create index hpr_timesheet_dates_i1 on hpr_timesheet_dates(company_id, staff_unit_id) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------          
prompt in hpd_contacts hpd_document_staffs_cache hpd_hirings hpd_transfers hpd_dismissals tables add staff_id
---------------------------------------------------------------------------------------------------- 
alter table hpd_contracts add staff_id number;

alter table hpd_contracts drop constraint hpd_contracts_f1;
alter table hpd_contracts drop constraint hpd_contracts_f2;
alter table hpd_contracts drop constraint hpd_contracts_f3;
alter table hpd_contracts drop constraint hpd_contracts_f4;
alter table hpd_contracts drop constraint hpd_contracts_f5;

alter table hpd_contracts add constraint hpd_contracts_f1 foreign key (company_id, filial_id, staff_id) references hrm_staffs(company_id, filial_id, staff_id);
alter table hpd_contracts add constraint hpd_contracts_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id);
alter table hpd_contracts add constraint hpd_contracts_f3 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id);
alter table hpd_contracts add constraint hpd_contracts_f4 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table hpd_contracts add constraint hpd_contracts_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id);

drop index hpd_contracts_i1;
drop index hpd_contracts_i2;
drop index hpd_contracts_i3;
drop index hpd_contracts_i4;

create index hpd_contracts_i1 on hpd_contracts(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_contracts_i2 on hpd_contracts(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_contracts_i3 on hpd_contracts(company_id, filial_id, fixed_term_base_id) tablespace GWS_INDEX;
create index hpd_contracts_i4 on hpd_contracts(company_id, created_by) tablespace GWS_INDEX;
create index hpd_contracts_i5 on hpd_contracts(company_id, modified_by) tablespace GWS_INDEX;

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
  
    update Hpd_Contracts t
       set t.Staff_Id =
           (select d.Staff_Id
              from Hrm_Staffs d
             where d.Company_Id = t.Company_Id
               and d.Filial_Id = t.Filial_Id
               and d.Employee_Id = t.Employee_Id)
     where t.Company_Id = r.Company_Id;
  end loop;
  commit
end;

alter table hpd_contracts modify staff_id not null;
---------------------------------------------------------------------------------------------------- 
alter table hpd_document_employees_cache rename to hpd_document_staffs_cache;
alter table hpd_document_staffs_cache add filial_id number;
alter table hpd_document_staffs_cache add staff_id number;
alter table hpd_document_staffs_cache drop constraint hpd_document_employees_cache_pk;

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
  
    update Hpd_Document_Staffs_Cache t
       set t.Filial_Id =
           (select d.Filial_Id
              from Hpd_Documents d
             where d.Company_Id = t.Company_Id
               and d.Document_Id = t.Document_Id)
     where t.Company_Id = r.Company_Id;
  
    update Hpd_Document_Staffs_Cache t
       set t.Staff_Id =
           (select d.Staff_Id
              from Hrm_Staffs d
             where d.Company_Id = t.Company_Id
               and d.Filial_Id = t.Filial_Id
               and d.Employee_Id = t.Employee_Id)
     where t.Company_Id = r.Company_Id;
  end loop;
  
  commit
end;

alter table hpd_document_staffs_cache add constraint hpd_document_staffs_cache_f1 foreign key (company_id, filial_id, document_id) references hpd_documents(company_id, filial_id, document_id) on delete cascade;
create index hpd_document_staffs_cache_i1 on hpd_document_staffs_cache(company_id, filial_id, employee_id) tablespace GWS_INDEX;

alter table hpd_document_staffs_cache modify filial_id not null;
alter table hpd_document_staffs_cache modify staff_id not null;
alter table hpd_document_staffs_cache add constraint hpd_document_staffs_cache_pk primary key (company_id, filial_id, document_id, staff_id) using index tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------       
alter table hpd_hirings add staff_id number;
alter table hpd_hirings drop constraint hpd_hirings_f1;
alter table hpd_hirings drop constraint hpd_hirings_f2;
alter table hpd_hirings drop constraint hpd_hirings_f3;
alter table hpd_hirings drop constraint hpd_hirings_f4;
alter table hpd_hirings drop constraint hpd_hirings_f5;
alter table hpd_hirings drop constraint hpd_hirings_f6;
alter table hpd_hirings drop constraint hpd_hirings_f7;
alter table hpd_hirings drop constraint hpd_hirings_f8;
alter table hpd_hirings drop constraint hpd_hirings_f9;

alter table hpd_hirings add constraint hpd_hirings_f1 foreign key (company_id, filial_id, document_id) references hpd_documents(company_id, filial_id, document_id);
alter table hpd_hirings add constraint hpd_hirings_f2 foreign key (company_id, filial_id, staff_id) references hrm_staffs(company_id, filial_id, staff_id);
alter table hpd_hirings add constraint hpd_hirings_f3 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id);
alter table hpd_hirings add constraint hpd_hirings_f4 foreign key (company_id, filial_id, position_id) references hrm_positions(company_id, filial_id, position_id);
alter table hpd_hirings add constraint hpd_hirings_f5 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id);
alter table hpd_hirings add constraint hpd_hirings_f6 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id);
alter table hpd_hirings add constraint hpd_hirings_f7 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id);
alter table hpd_hirings add constraint hpd_hirings_f8 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id);
alter table hpd_hirings add constraint hpd_hirings_f9 foreign key (company_id, labor_function_id) references href_labor_functions(company_id, labor_function_id);
alter table hpd_hirings add constraint hpd_hirings_f10 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id;

drop index hpd_hirings_i1;
drop index hpd_hirings_i2;
drop index hpd_hirings_i3;
drop index hpd_hirings_i4;
drop index hpd_hirings_i5;
drop index hpd_hirings_i6;
drop index hpd_hirings_i7;
drop index hpd_hirings_i8;
drop index hpd_hirings_i9;

create index hpd_hirings_i1 on hpd_hirings(company_id, filial_id, document_id) tablespace GWS_INDEX;
create index hpd_hirings_i2 on hpd_hirings(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_hirings_i3 on hpd_hirings(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_hirings_i4 on hpd_hirings(company_id, filial_id, position_id) tablespace GWS_INDEX;
create index hpd_hirings_i5 on hpd_hirings(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_hirings_i6 on hpd_hirings(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpd_hirings_i7 on hpd_hirings(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hpd_hirings_i8 on hpd_hirings(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpd_hirings_i9 on hpd_hirings(company_id, labor_function_id) tablespace GWS_INDEX;
create index hpd_hirings_i10 on hpd_hirings(company_id, fixed_term_base_id) tablespace GWS_INDEX;

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
  
    update Hpd_Hirings t
       set t.Staff_Id =
           (select d.Staff_Id
              from Hrm_Staffs d
             where d.Company_Id = t.Company_Id
               and d.Filial_Id = t.Filial_Id
               and d.Employee_Id = t.Employee_Id)
     where t.Company_Id = r.Company_Id;
  end loop;
  
  commit
end;

alter table hpd_hirings modify staff_id not null;
----------------------------------------------------------------------------------------------------           
alter table hpd_transfers add staff_id number;

alter table hpd_transfers drop constraint hpd_transfers_f1;
alter table hpd_transfers drop constraint hpd_transfers_f2;
alter table hpd_transfers drop constraint hpd_transfers_f3;
alter table hpd_transfers drop constraint hpd_transfers_f4;
alter table hpd_transfers drop constraint hpd_transfers_f5;
alter table hpd_transfers drop constraint hpd_transfers_f6;
alter table hpd_transfers drop constraint hpd_transfers_f7;
alter table hpd_transfers drop constraint hpd_transfers_f8;
alter table hpd_transfers drop constraint hpd_transfers_f9;

alter table hpd_transfers add constraint hpd_transfers_f1 foreign key (company_id, filial_id, document_id) references hpd_documents(company_id, filial_id, document_id);
alter table hpd_transfers add constraint hpd_transfers_f2 foreign key (company_id, filial_id, staff_id) references hrm_staffs(company_id, filial_id, staff_id);
alter table hpd_transfers add constraint hpd_transfers_f3 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id);
alter table hpd_transfers add constraint hpd_transfers_f4 foreign key (company_id, filial_id, position_id) references hrm_positions(company_id, filial_id, position_id);
alter table hpd_transfers add constraint hpd_transfers_f5 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id);
alter table hpd_transfers add constraint hpd_transfers_f6 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id);
alter table hpd_transfers add constraint hpd_transfers_f7 foreign key (company_id, filial_id, rank_id) references mhr_ranks(company_id, filial_id, rank_id);
alter table hpd_transfers add constraint hpd_transfers_f8 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id);
alter table hpd_transfers add constraint hpd_transfers_f9 foreign key (company_id, labor_function_id) references href_labor_functions(company_id, labor_function_id);
alter table hpd_transfers add constraint hpd_transfers_f10 foreign key (company_id, fixed_term_base_id) references href_fixed_term_bases(company_id, fixed_term_base_id);

drop index hpd_transfers_i1;
drop index hpd_transfers_i2;
drop index hpd_transfers_i3;
drop index hpd_transfers_i4;
drop index hpd_transfers_i5;
drop index hpd_transfers_i6;
drop index hpd_transfers_i7;
drop index hpd_transfers_i8;
drop index hpd_transfers_i9;

create index hpd_transfers_i1 on hpd_transfers(company_id, filial_id, document_id) tablespace GWS_INDEX;
create index hpd_transfers_i2 on hpd_transfers(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_transfers_i3 on hpd_transfers(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_transfers_i4 on hpd_transfers(company_id, filial_id, position_id) tablespace GWS_INDEX;
create index hpd_transfers_i5 on hpd_transfers(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpd_transfers_i6 on hpd_transfers(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpd_transfers_i7 on hpd_transfers(company_id, filial_id, rank_id) tablespace GWS_INDEX;
create index hpd_transfers_i8 on hpd_transfers(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpd_transfers_i9 on hpd_transfers(company_id, labor_function_id) tablespace GWS_INDEX;
create index hpd_transfers_i10 on hpd_transfers(company_id, fixed_term_base_id) tablespace GWS_INDEX;

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
  
    update Hpd_Transfers t
       set t.Staff_Id =
           (select d.Staff_Id
              from Hrm_Staffs d
             where d.Company_Id = t.Company_Id
               and d.Filial_Id = t.Filial_Id
               and d.Employee_Id = t.Employee_Id)
     where t.Company_Id = r.Company_Id;
  end loop;
  
  commit
end;

alter table hpd_transfers modify staff_id not null;
----------------------------------------------------------------------------------------------------    
alter table hpd_dismissals add staff_id number;

alter table hpd_dismissals drop constraint hpd_dismissals_f2;
alter table hpd_dismissals drop constraint hpd_dismissals_f3;

alter table hpd_dismissals add constraint hpd_dismissals_f2 foreign key (company_id, filial_id, staff_id) references hrm_staffs(company_id, filial_id, staff_id);
alter table hpd_dismissals add constraint hpd_dismissals_f3 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, empoyee_id);
alter table hpd_dismissals add constraint hpd_dismissals_f4 foreign key (company_id, dismissal_reason_id) references href_dismissal_reasons(company_id, dismissa_reason_id);

drop index hpd_dismissals_i2;
drop index hpd_dismissals_i3;
create index hpd_dismissals_i2 on hpd_dismissals(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index hpd_dismissals_i3 on hpd_dismissals(company_id, filial_id, employee_id) tablespace GWS_INDEX;
create index hpd_dismissals_i4 on hpd_dismissals(company_id, dismissal_reason_id) tablespace GWS_INDEX;

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
  
    update Hpd_Dismissals t
       set t.Staff_Id =
           (select d.Staff_Id
              from Hrm_Staffs d
             where d.Company_Id = t.Company_Id
               and d.Filial_Id = t.Filial_Id
               and d.Employee_Id = t.Employee_Id)
     where t.Company_Id = r.Company_Id;
  end loop;
  
  commit
end;

alter table hpd_dismissals modify staff_id not null;
