select distinct p.Staff_Number,
                Href_Util.Staff_Name(i_Company_Id => p.Company_Id,
                                     i_Filial_Id  => p.Filial_Id,
                                     i_Staff_Id   => p.Staff_Id) Sname
  from Href_Staffs p
 where p.Company_Id = &New_Company_Id
   and exists (select *
          from Migr_Errors q
         where q.Company_Id = p.Company_Id
           and lower(q.Table_Name) = 'href_staffs'
           and q.Key_Id = p.Staff_Id);
