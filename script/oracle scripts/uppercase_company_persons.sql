exec ui_auth.Logon_As_System(600);

update md_persons q 
   set q.name = upper(md_lang.Encode_Ascii(q.name))
 where q.company_id = 600;

update mr_natural_persons q 
   set q.name = upper(md_lang.Encode_Ascii(q.name))
 where q.company_id = 600;

update md_users q 
   set q.name = upper(md_lang.Encode_Ascii(q.name))
 where q.company_id = 600;

commit;
