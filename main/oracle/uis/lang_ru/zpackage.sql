set define off
prompt ZPACKAGE TRANSLATE
begin
uis.lang_ru('#z:htt_persons dup val on index company_id=$1 person_id=$2','ИД физического лица = $2 уже существует. Введите другой ИД физического лица!');
uis.lang_ru('#z:htt_persons dup_val_on_index company_id=$1 pin=$2 pin=$3','Физическое лицо с ПИН = $2 уже существует. Введите другой ПИН!');
uis.lang_ru('#z:htt_persons dup_val_on_index company_id=$1 pin_code=$2 pin_code=$3','Физическое лицо с ПИН-кодом = $2 уже существует. Введите другой ПИН-код!');
uis.lang_ru('#z:htt_persons dup_val_on_index company_id=$1 qr_code=$2 qr_code=$3','Физическое лицо с QR-кодом = $2 уже существует. Введите другой QR-код!');
uis.lang_ru('#z:htt_persons dup_val_on_index company_id=$1 rfid_code=$2 rfid_code=$3','Физическое лицо с RFID-кодом = $2 уже существует. Введите другой RFID-код!');
commit;
end;
/
