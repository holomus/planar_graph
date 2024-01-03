set define off
prompt ZPACKAGE TRANSLATE
begin
uis.lang_en('#z:htt_persons dup val on index company_id=$1 person_id=$2','Employee with ID = $2 already exists. Try to enter another one!');
uis.lang_en('#z:htt_persons dup_val_on_index company_id=$1 pin=$2 pin=$3','Employee with PIN = $2 already exists. Try to enter another one!');
uis.lang_en('#z:htt_persons dup_val_on_index company_id=$1 pin_code=$2 pin_code=$3','Employee with PIN-code = $2 already exists. Try to enter another one!');
uis.lang_en('#z:htt_persons dup_val_on_index company_id=$1 qr_code=$2 qr_code=$3','Employee with QR-code= $2 already exists. Try to enter another one!');
uis.lang_en('#z:htt_persons dup_val_on_index company_id=$1 rfid_code=$2 rfid_code=$3','Employee with RFID-code= $2 already exists. Try to enter another one!');
commit;
end;
/
