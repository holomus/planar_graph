prompt add default value for new setting
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
insert into Md_User_Settings
  (Company_Id,
   User_Id,
   Filial_Id,
   Setting_Code,
   Setting_Value,
   Created_By,
   Created_On,
   Modified_By,
   Modified_On)
  (select q.Company_Id,
          q.User_Id,
          q.Filial_Id,
          'hes:staff:allow_gallery',
          q.Setting_Value,
          q.Created_By,
          q.Created_On,
          q.Modified_By,
          q.Modified_On
     from Md_User_Settings q
    where q.Setting_Code = 'hes:staff:face_register');

insert into Md_Preferences
  (Company_Id, Filial_Id, Pref_Code, Pref_Value, Created_By, Created_On, Modified_By, Modified_On)
  (select q.Company_Id,
          q.Filial_Id,
          'hes:staff:allow_gallery',
          q.Pref_Value,
          q.Created_By,
          q.Created_On,
          q.Modified_By,
          q.Modified_On
     from Md_Preferences q
    where q.Pref_Code = 'hes:staff:face_register');

commit;
