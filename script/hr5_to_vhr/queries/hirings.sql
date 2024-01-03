prompt hirings

set define on;
define Company_id=100;
define Filial_id=109;

select Jp.Journal_Id,
       Rb_Ass.Assignment_Id,
       (select Np.Name
          from Mr_Natural_Persons Np
         where Np.Company_Id = Jp.Company_Id
           and Np.Person_Id = Jp.Employee_Id) Employee_Name,
       (select k.Name
          from Mrf_Robots k
         where k.Company_Id = Pr.Company_Id
           and k.Filial_Id = Pr.Filial_Id
           and k.Robot_Id = Pr.Robot_Id) Robot_Name,
       Hr.Page_Id,
       Hr.Staff_Id,
       Jp.Employee_Id,
       Hr.Hiring_Date,
       Rb_Ass.Date_Begin Old_Hiring_Date,
       Pr.Robot_Id,
       p.Old_Id Migrated_Old_Robot_Id,
       Rb_Ass.Robot_Id Actual_Old_Robot_Id
  from Hpd_Hirings Hr
  join Hpd_Journal_Pages Jp
    on Jp.Company_Id = Hr.Company_Id
   and Jp.Filial_Id = Hr.Filial_Id
   and Jp.Page_Id = Hr.Page_Id
  join Hpd_Page_Robots Pr
    on Pr.Company_Id = Hr.Company_Id
   and Pr.Filial_Id = Hr.Filial_Id
   and Pr.Page_Id = Hr.Page_Id
  join Hr5_Migr_Keys_Store_Two p
    on p.Company_Id = Pr.Company_Id
   and p.Filial_Id = Pr.Filial_Id
   and p.Key_Name = 'robot'
   and p.New_Id = Pr.Robot_Id
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
 where Hr.Company_Id = &Company_Id
   and Hr.Filial_Id = &Filial_Id
   and (Hr.Hiring_Date <> Rb_Ass.Date_Begin or Rb_Ass.Robot_Id <> p.Old_Id or
       Rb_Ass.Staff_Id <> t.Old_Id);

rollback;
