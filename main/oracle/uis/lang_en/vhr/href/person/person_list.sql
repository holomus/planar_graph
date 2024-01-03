prompt PATH TRANSLATE /vhr/href/person/person_list
begin
uis.lang_en('#a:/vhr/href/person/person_list$add','Create');
uis.lang_en('#a:/vhr/href/person/person_list$change_state','Reset status');
uis.lang_en('#a:/vhr/href/person/person_list$delete','Delete');
uis.lang_en('#a:/vhr/href/person/person_list$detach','Detach');
uis.lang_en('#a:/vhr/href/person/person_list$edit','Edit');
uis.lang_en('#a:/vhr/href/person/person_list$open_attach','Attach');
uis.lang_en('#a:/vhr/href/person/person_list+attach$attach','Attach');
uis.lang_en('#a:/vhr/href/person/person_list+attach_employee$attach','Attach');
uis.lang_en('#f:/vhr/href/person/person_list','Natural Persons');
uis.lang_en('#f:/vhr/href/person/person_list+attach','Natural Persons / Attachment');
uis.lang_en('#f:/vhr/href/person/person_list+attach_employee','Natural Person / Attach');
uis.lang_en('ui-vhr14:cannot change state of person not attached to filial, person_id=$1','You cannot change the status of natural person that not attached to organization. Natural Person ID = $1');
commit;
end;
/
