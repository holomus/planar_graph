update Kl_License_Holders q
   set q.Licensed = 'N'
 where q.Company_Id = 260;

update Kl_License_Balances q
   set q.Available_Amount = 0,
       q.Used_Amount      = 0,
       q.Required_Amount =
       (select count(1)
          from Kl_License_Holders w
         where w.Company_Id = q.Company_Id
           and w.Hold_Date = q.Balance_Date
           and w.License_Code = q.License_Code)
 where q.Company_Id = 260;

delete kl_license_codes q where q.company_id = 260;
delete kl_licenses q where q.company_id = 260;
