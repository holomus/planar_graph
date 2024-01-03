insert into Verifix.Migr_Biruni_Files
  (Sha)
  select q.Sha
    from Md_Company_Files q
   where q.Company_Id = 461
     and not exists (select *
            from Htt_Tracks w
           where w.Photo_Sha = q.Sha
             and w.Track_Date < to_date('01.04.2022'));
