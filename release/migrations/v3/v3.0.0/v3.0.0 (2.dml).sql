prompt add current training subject infos 
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------            
insert into Hln_Training_Person_Subjects
  (Company_Id, Filial_Id, Training_Id, Person_Id, Subject_Id, Passed)
  select q.Company_Id, q.Filial_Id, q.Training_Id, w.Person_Id, q.Subject_Id, w.Passed
    from Hln_Training_Current_Subjects q
    join Hln_Training_Persons w
      on w.Company_Id = q.Company_Id
     and w.Filial_Id = q.Filial_Id
     and w.Training_Id = q.Training_Id;
commit;

----------------------------------------------------------------------------------------------------
prompt adding experience attempts
----------------------------------------------------------------------------------------------------
insert into Htm_Experience_Period_Attempts
  (Company_Id,
   Filial_Id,
   Experience_Id,
   From_Rank_Id,
   Attempt_No,
   Period,
   Nearest,
   Penalty_Period,
   Exam_Id,
   Success_Score,
   Ignore_Score,
   Recommend_Failure)
  select q.Company_Id,
         q.Filial_Id,
         q.Experience_Id,
         q.From_Rank_Id,
         1,
         q.Period,
         q.Nearest,
         null,
         null,
         null,
         null,
         null
    from Htm_Experience_Periods q;
    
update htm_recommended_rank_staffs q
   set q.increment_status = 'S'
 where q.increment_permit = 'Y';
 
update htm_recommended_rank_staffs q
   set q.increment_status = 'I'
 where q.increment_permit = 'N';
commit;

----------------------------------------------------------------------------------------------------
prompt new indicator groups
----------------------------------------------------------------------------------------------------
insert into Href_Indicator_Groups
  (Company_Id, Indicator_Group_Id, name, Pcode)
  select q.Company_Id,
         Href_Indicator_Groups_Sq.Nextval,
         'Показатели расчета зарплаты',
         'VHR:1'
    from Md_Companies q;

insert into Href_Indicator_Groups
  (Company_Id, Indicator_Group_Id, name, Pcode)
  select q.Company_Id,
         Href_Indicator_Groups_Sq.Nextval,
         'Показатели расчета опыта',
         'VHR:2'
    from Md_Companies q;
    
update Href_Indicators q
   set q.Indicator_Group_Id =
       (select p.Indicator_Group_Id
          from Href_Indicator_Groups p
         where p.Company_Id = q.Company_Id
           and p.Pcode = 'VHR:1');
commit;
