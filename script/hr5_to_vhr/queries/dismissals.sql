prompt dismissals

set define on;
define Company_id=100;
define Filial_id=109;

select Jp.Journal_Id,
       Rb_Ass.Assignment_Id,
       (select Np.Name
          from Mr_Natural_Persons Np
         where Np.Company_Id = Jp.Company_Id
           and Np.Person_Id = Jp.Employee_Id) Employee_Name,
       Ds.Page_Id,
       Jp.Staff_Id,
       Jp.Employee_Id,
       t.Old_Id Migrated_Old_Employee_Id,
       Rb_Ass.Staff_Id Actual_Old_Employee_Id,
       Ds.Dismissal_Date,
       Rb_Ass.Date_Begin Old_Dismissal_Date
  from Hpd_Dismissals Ds
  join Hpd_Journal_Pages Jp
    on Jp.Company_Id = Ds.Company_Id
   and Jp.Filial_Id = Ds.Filial_Id
   and Jp.Page_Id = Ds.Page_Id
  join Hr5_Migr_Keys_Store_One t
    on t.Company_Id = Jp.Company_Id
   and t.Key_Name = 'md_person'
   and t.New_Id = Jp.Employee_Id
  join Hr5_Migr_Keys_Store_Two Ass
    on Ass.Company_Id = Jp.Company_Id
   and Ass.Filial_Id = Jp.Filial_Id
   and Ass.Key_Name = 'robot_assignment'
   and Ass.New_Id = Jp.Journal_Id
  join Hr5_Hr_Robot_Assignments Rb_Ass
    on Rb_Ass.Assignment_Id = Ass.Old_Id
 where Ds.Company_Id = &Company_Id
   and Ds.Filial_Id = &Filial_Id
   and (Ds.Dismissal_Date <> Rb_Ass.Date_End_Nvl or Rb_Ass.Staff_Id <> t.Old_Id);

rollback;
