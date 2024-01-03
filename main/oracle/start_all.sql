set define off;
prompt ==== **start table** ====
prompt ==== ** HREF ** ====
@@module\href\setup\href_table.sql;
@@module\href\setup\href_sequence.sql;
prompt ==== ** HES ** ====
@@module\hes\setup\hes_table.sql;
@@module\hes\setup\hes_sequence.sql;
prompt ==== ** HLIC ** ====
@@module\hlic\setup\hlic_table.sql;
@@module\hlic\setup\hlic_sequence.sql;
prompt ==== ** HAC ** ====
@@module\hac\setup\hac_table.sql;
@@module\hac\setup\hac_sequence.sql;
prompt ==== ** HTT ** ====
@@module\htt\setup\htt_table.sql;
@@module\htt\setup\htt_sequence.sql;
prompt ==== ** HZK ** ====
@@module\hzk\setup\hzk_table.sql;
@@module\hzk\setup\hzk_sequence.sql;
prompt ==== ** HRM ** ====
@@module\hrm\setup\hrm_table.sql;
@@module\hrm\setup\hrm_sequence.sql;
prompt ==== ** HPD ** ====
@@module\hpd\setup\hpd_table.sql;
@@module\hpd\setup\hpd_sequence.sql;
prompt ==== ** HPR ** ====
@@module\hpr\setup\hpr_table.sql;
@@module\hpr\setup\hpr_sequence.sql;
prompt ==== ** HISL ** ====
@@module\hisl\setup\hisl_table.sql;
@@module\hisl\setup\hisl_sequence.sql;
prompt ==== ** HPER ** ====
@@module\hper\setup\hper_table.sql;
@@module\hper\setup\hper_sequence.sql;
prompt ==== ** HLN ** ====
@@module\hln\setup\hln_table.sql;
@@module\hln\setup\hln_sequence.sql;
prompt ==== ** HSC ** ====
@@module\hsc\setup\hsc_table.sql;
@@module\hsc\setup\hsc_sequence.sql;
prompt ==== ** HTM ** ====
@@module\htm\setup\htm_table.sql;
@@module\htm\setup\htm_sequence.sql;
prompt ==== ** HREC ** ====
@@module\hrec\setup\hrec_table.sql;
@@module\hrec\setup\hrec_sequence.sql;
prompt ==== ** HFACE ** ====
@@module\hface\setup\hface_table.sql;
@@module\hface\setup\hface_sequence.sql;
exec fazo_z.run;

@@start.sql

prompt === **start settings** ===
prompt ==== HREF =====
@@module\href\setup\href_setting.sql;
prompt ==== HES =====
@@module\hes\setup\hes_setting.sql;
prompt ==== HAC =====
@@module\hac\setup\hac_setting.sql;
prompt ==== HTT =====
@@module\htt\setup\htt_setting.sql;
prompt ==== ** HZK ** ====
@@module\hzk\setup\hzk_synonym.sql;
prompt ==== HPD =====
@@module\hpd\setup\hpd_setting.sql;
prompt ==== HPR =====
@@module\hpr\setup\hpr_setting.sql;
prompt ==== HPER =====
@@module\hper\setup\hper_setting.sql;
prompt ==== HSC =====
@@module\hsc\setup\hsc_setting.sql;
prompt ==== HREC =====
@@module\hrec\setup\hrec_setting.sql;
prompt ==== role settings ====
@@setup\role_settings.sql;
prompt ==== timepad settings ====
@@setup\timepad_user.sql;
prompt ==== **materialaized view** ====
@@setup\init\materialized_view.sql;
