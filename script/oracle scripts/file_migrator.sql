set autocommit 500;

insert into Biruni_Filespace q
  (Sha, File_Content)
  select w.Sha, w.File_Content
    from Verifix.Migr_Biruni_Filespace w
   where not exists (select 1
            from Biruni_Filespace k
           where k.Sha = w.Sha);

insert into Biruni_Filespace_Controller q
  (Sha)
  select w.Sha
    from Verifix.Migr_Biruni_Files w
   where not exists (select *
            from Biruni_Filespace_Controller k
           where k.Sha = w.Sha);
