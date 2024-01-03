create or replace view hlic_unlicensed_employees as
select q.Company_Id, --
       q.Holder_Id  Employee_Id,
       q.Hold_Date  Licensed_Date
  from Kl_License_Holders q
 where q.License_Code = 'VHR:HRM_BASE'
   and q.Licensed = 'N';
