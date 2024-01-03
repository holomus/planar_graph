prompt ranks

set define on;
define Company_id=100;
define Filial_id=109;

select Qr.Journal_Id,
       Qr.Robot_Id Old_Robot_Id,
       Qr.Rank_Id Old_Rank_Id,
       Qr.Page_Id,
       Qr.Change_Date,
       Qr.Changed_Date Old_Change_Date,
       Qr.Employee_Id,
       (select Np.Name
          from Mr_Natural_Persons Np
         where Np.Company_Id = &Company_Id
           and Np.Person_Id = Qr.Employee_Id) Employee_Name,
       Qr.New_Rank_Id Migrated_New_Rank_Id,
       Qr.Journal_Rank_Id Actual_New_Rank_Id
  from (select q.*,
               (select Ra.Assignment_Id
                  from Hr5_Hr_Robot_Assignments Ra
                 where Ra.Robot_Id = q.Robot_Id
                   and q.Changed_Date between Ra.Date_Begin and Ra.Date_End_Nvl) as Assignment_Id,
               Jp.Journal_Id,
               Jp.Page_Id,
               Jp.Employee_Id,
               Rc.Change_Date,
               Rc.Rank_Id Journal_Rank_Id,
               p.New_Id New_Rank_Id
          from Hr5_Hr_Register_Ranks q
          join Hr5_Migr_Keys_Store_Two Uk
            on Uk.Company_Id = &Company_Id
           and Uk.Filial_Id = &Filial_Id
           and Uk.Key_Name =
               'rank_change' || ':' || q.Robot_Id || ':' || to_char(q.Changed_Date, 'yyyymmdd')
           and Uk.Old_Id = q.Rank_Id
          join Hr5_Migr_Keys_Store_Two p
            on p.Company_Id = Uk.Company_Id
           and p.Filial_Id = Uk.Filial_Id
           and p.Key_Name = 'ref_rank'
           and p.Old_Id = q.Rank_Id
          join Hpd_Journals Jr
            on Jr.Company_Id = Uk.Company_Id
           and Jr.Filial_Id = Uk.Filial_Id
           and Jr.Journal_Id = Uk.New_Id
          join Hpd_Journal_Pages Jp
            on Jp.Company_Id = Jr.Company_Id
           and Jp.Filial_Id = Jr.Filial_Id
           and Jp.Journal_Id = Jr.Journal_Id
          join Hpd_Rank_Changes Rc
            on Rc.Company_Id = Jp.Company_Id
           and Rc.Filial_Id = Jp.Filial_Id
           and Rc.Page_Id = Jp.Page_Id) Qr
  join Hr5_Hr_Robot_Assignments Ass
    on Ass.Assignment_Id = Qr.Assignment_Id
  join Hr5_Migr_Keys_Store_One t
    on t.Company_Id = &Company_Id
   and t.Key_Name = 'md_person'
   and t.Old_Id = Ass.Staff_Id
 where Qr.Changed_Date <> Qr.Change_Date
    or Qr.Journal_Rank_Id <> Qr.New_Rank_Id
    or t.New_Id <> Qr.Employee_Id;

rollback;
