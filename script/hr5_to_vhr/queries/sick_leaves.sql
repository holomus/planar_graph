prompt sick leaves

set define on;
define Company_id=100;
define Filial_id=109;

select q.Doc_Id,
       Jr.Journal_Id,
       (select Np.Name
          from Mr_Natural_Persons Np
         where Np.Company_Id = Tf.Company_Id
           and Np.Person_Id = Tf.Employee_Id) Employee_Name,
       Tf.Timeoff_Id,
       q.Staff_Id Old_Employee_Id,
       Tf.Employee_Id Actual_New_Employee_Id,
       t.New_Id Migrated_New_Employee_Id,
       Tf.Begin_Date,
       q.Date_Begin Old_Begin_Date,
       Tf.End_Date,
       q.Date_End Old_End_Date
  from Hr5_Hr_Leave_Docs q
  join Hr5_Migr_Keys_Store_Two Uk
    on Uk.Company_Id = &Company_Id
   and Uk.Filial_Id = &Filial_Id
   and Uk.Key_Name = 'leave_doc'
   and Uk.Old_Id = q.Doc_Id
  join Hr5_Migr_Keys_Store_One t
    on t.Company_Id = &Company_Id
   and t.Key_Name = 'md_person'
   and t.Old_Id = q.Staff_Id
  join Hpd_Journals Jr
    on Jr.Company_Id = Uk.Company_Id
   and Jr.Filial_Id = Uk.Filial_Id
   and Jr.Journal_Id = Uk.New_Id
  join Hpd_Journal_Timeoffs Tf
    on Tf.Company_Id = Jr.Company_Id
   and Tf.Filial_Id = Jr.Filial_Id
   and Tf.Journal_Id = Jr.Journal_Id
  join Hpd_Sick_Leaves Sl
    on Sl.Company_Id = Tf.Company_Id
   and Sl.Filial_Id = Tf.Filial_Id
   and Sl.Timeoff_Id = Tf.Timeoff_Id
 where q.Doc_Type <> 'F'
   and (t.New_Id <> Tf.Employee_Id or q.Date_Begin <> Tf.Begin_Date or q.Date_End <> Tf.End_Date);

rollback;
