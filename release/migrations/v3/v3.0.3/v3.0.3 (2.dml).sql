prompt add company_id to olx data mapping tables
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
update hrec_olx_job_categories
   set company_id = 0;
   
insert into hrec_olx_job_categories
  (company_id, category_code, name)
  (select w.company_id, q.category_code, q.name
     from hrec_olx_job_categories q
     join md_companies w
       on w.company_id <> q.company_id
      and (exists (select 1
                     from hrec_olx_published_vacancy_attributes r
                    where r.company_id = w.company_id) or exists
           (select 1
              from hrec_olx_integration_regions r
             where r.company_id = w.company_id))
      and q.company_id = 0);
      
----------------------------------------------------------------------------------------------------       
update hrec_olx_attributes
   set company_id = 0;
   
   
insert into hrec_olx_attributes
  (company_id,
   category_code,
   attribute_code,
   label,
   validation_type,
   is_require,
   is_number,
   min_value,
   max_value,
   is_allow_multiple_values)
  (select w.company_id,
          q.category_code,
          q.attribute_code,
          q.label,
          q.validation_type,
          q.is_require,
          q.is_number,
          q.min_value,
          q.max_value,
          q.is_allow_multiple_values
     from hrec_olx_attributes q
     join md_companies w
       on w.company_id <> q.company_id
      and (exists (select 1
                     from hrec_olx_published_vacancy_attributes r
                    where r.company_id = w.company_id) or exists
           (select 1
              from hrec_olx_integration_regions r
             where r.company_id = w.company_id))
      and q.company_id = 0);
      
----------------------------------------------------------------------------------------------------
update hrec_olx_attribute_values
   set Company_Id = 0;
   
insert into Hrec_Olx_Attribute_Values
  (Company_Id, Category_Code, Attribute_Code, Code, Label)
  (select w.Company_Id, q.Category_Code, q.Attribute_Code, q.Code, q.Label
     from Hrec_Olx_Attribute_Values q
     join Md_Companies w
       on w.Company_Id <> q.Company_Id
      and (exists (select 1
                     from hrec_olx_published_vacancy_attributes r
                    where r.company_id = w.company_id) or exists
           (select 1
              from hrec_olx_integration_regions r
             where r.company_id = w.company_id))
      and q.Company_Id = 0);

---------------------------------------------------------------------------------------------------- 
update hrec_olx_regions
   set Company_Id = 0;       
   
insert into Hrec_Olx_Regions
  (Company_Id, Region_Code, name)
  (select w.Company_Id, q.Region_Code, q.Name
     from Hrec_Olx_Regions q
     join Md_Companies w
       on w.Company_Id <> q.Company_Id
      and (exists (select 1
                     from hrec_olx_published_vacancy_attributes r
                    where r.company_id = w.company_id) or exists
           (select 1
              from hrec_olx_integration_regions r
             where r.company_id = w.company_id))
      and q.Company_Id = 0);
      
----------------------------------------------------------------------------------------------------
update hrec_olx_cities
   set Company_Id = 0;
   
insert into Hrec_Olx_Cities
  (Company_Id, City_Code, Region_Code, name)
  (select w.Company_Id, q.City_Code, q.Region_Code, q.Name
     from Hrec_Olx_Cities q
     join Md_Companies w
       on w.Company_Id <> q.Company_Id
      and (exists (select 1
                     from hrec_olx_published_vacancy_attributes r
                    where r.company_id = w.company_id) or exists
           (select 1
              from hrec_olx_integration_regions r
             where r.company_id = w.company_id))
      and q.Company_Id = 0);
      
----------------------------------------------------------------------------------------------------
update hrec_olx_districts
   set Company_Id = 0;
   
insert into Hrec_Olx_Districts
  (Company_Id, District_Code, City_Code, name)
  (select w.Company_Id, q.District_Code, q.City_Code, q.Name
     from Hrec_Olx_Districts q
     join Md_Companies w
       on w.Company_Id <> q.Company_Id
      and (exists (select 1
                     from hrec_olx_published_vacancy_attributes r
                    where r.company_id = w.company_id) or exists
           (select 1
              from hrec_olx_integration_regions r
             where r.company_id = w.company_id))
      and q.Company_Id = 0);
      
----------------------------------------------------------------------------------------------------
commit;      
