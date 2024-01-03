set define off;
prompt ==== **start Verifix ** ====
@@setup\verifix.pck;
prompt ==== ** HREF ** ====
@@module\href\href_next.pck;
@@module\href\href_pref.pck;
@@module\href\href_error.pck;
@@module\href\href_util.pck;
@@module\href\href_core.pck;
@@module\href\href_api.pck;
@@module\href\href_watcher.pck;
@@module\href\href_audit.pck;
prompt ==== ** HES ** ====
@@module\hes\hes_next.pck;
@@module\hes\hes_pref.pck;
@@module\hes\hes_error.pck;
@@module\hes\hes_util.pck;
@@module\hes\hes_core.pck;
@@module\hes\hes_api.pck;
prompt ==== ** HLIC ** ====
@@module\hlic\hlic_next.pck;
@@module\hlic\hlic_pref.pck;
@@module\hlic\hlic_error.pck;
@@module\hlic\hlic_util.pck;
@@module\hlic\hlic_core.pck;
@@module\hlic\hlic_watcher.pck;
prompt ==== ** HAC ** ====
@@module\hac\hac_next.pck;
@@module\hac\hac_pref.pck;
@@module\hac\hac_error.pck;
@@module\hac\hac_util.pck;
@@module\hac\hac_core.pck;
@@module\hac\hac_api.pck;
@@module\hac\hac_job.pck;
prompt ==== ** HTT ** ====
@@module\htt\htt_next.pck;
@@module\htt\htt_pref.pck;
@@module\htt\htt_error.pck;
@@module\htt\htt_geo_util.pck;
@@module\htt\htt_util.pck;
@@module\htt\htt_core.pck;
@@module\htt\htt_api.pck;
@@module\htt\htt_watcher.pck;
@@module\htt\htt_global.spc;
@@module\htt\htt_audit.pck;
@@module\htt\htt_job.pck;
prompt ==== ** HZK ** ====
@@module\hzk\hzk_next.pck;
@@module\hzk\hzk_pref.pck;
@@module\hzk\hzk_error.pck;
@@module\hzk\hzk_util.pck;
@@module\hzk\hzk_external.pck;
@@module\hzk\hzk_api.pck;
prompt ==== ** HRM ** ====
@@module\hrm\hrm_next.pck;
@@module\hrm\hrm_pref.pck;
@@module\hrm\hrm_error.pck;
@@module\hrm\hrm_util.pck;
@@module\hrm\hrm_core.pck;
@@module\hrm\hrm_api.pck;
@@module\hrm\hrm_watcher.pck;
@@module\hrm\hrm_audit.pck;
prompt ==== ** HPD ** ====
@@module\hpd\hpd_next.pck;
@@module\hpd\hpd_pref.pck;
@@module\hpd\hpd_error.pck;
@@module\hpd\hpd_util.pck;
@@module\hpd\hpd_core.pck;
@@module\hpd\hpd_api.pck;
@@module\hpd\hpd_watcher.pck;
@@module\hpd\hpd_audit.pck;
prompt ==== ** HPER ** ====
@@module\hper\hper_next.pck;
@@module\hper\hper_pref.pck;
@@module\hper\hper_error.pck;
@@module\hper\hper_util.pck;
@@module\hper\hper_core.pck;
@@module\hper\hper_api.pck;
@@module\hper\hper_watcher.pck;
@@module\hper\hper_audit.pck;
prompt ==== ** HIDE ** ====
@@module\hide\hide_pref.pck;
@@module\hide\hide_error.pck;
@@module\hide\hide_util.pck;
prompt ==== ** HPR ** ====
@@module\hpr\hpr_next.pck;
@@module\hpr\hpr_pref.pck;
@@module\hpr\hpr_error.pck;
@@module\hpr\hpr_util.pck;
@@module\hpr\hpr_core.pck;
@@module\hpr\hpr_api.pck;
@@module\hpr\hpr_audit.pck;
@@module\hpr\hpr_watcher.pck;
prompt ==== ** HISL ** ====
@@module\hisl\hisl_next.pck;
@@module\hisl\hisl_pref.pck;
@@module\hisl\hisl_util.pck;
@@module\hisl\hisl_api.pck;
prompt ==== ** HLN ** ====
@@module\hln\hln_next.pck;
@@module\hln\hln_pref.pck;
@@module\hln\hln_error.pck;
@@module\hln\hln_util.pck;
@@module\hln\hln_core.pck;
@@module\hln\hln_api.pck;
@@module\hln\hln_audit.pck;
prompt ==== ** HSC ** ====
@@module\hsc\hsc_next.pck;
@@module\hsc\hsc_pref.pck;
@@module\hsc\hsc_error.pck;
@@module\hsc\hsc_util.pck;
@@module\hsc\hsc_core.pck;
@@module\hsc\hsc_api.pck;
@@module\hsc\hsc_watcher.pck;
@@module\hsc\hsc_facts.pck;
@@module\hsc\hsc_job.pck;
prompt ==== ** HTM ** ====
@@module\htm\htm_next.pck;
@@module\htm\htm_pref.pck;
@@module\htm\htm_error.pck;
@@module\htm\htm_util.pck;
@@module\htm\htm_core.pck;
@@module\htm\htm_api.pck;
prompt ==== ** HREC ** ====
@@module\hrec\hrec_next.pck;
@@module\hrec\hrec_pref.pck;
@@module\hrec\hrec_error.pck;
@@module\hrec\hrec_util.pck;
@@module\hrec\hrec_api.pck;
@@module\hrec\hrec_watcher.pck;
prompt ==== ** HFACE ** ====
@@module\hface\hface_next.pck;
@@module\hface\hface_pref.pck;
@@module\hface\hface_error.pck;
@@module\hface\hface_util.pck;
@@module\hface\hface_core.pck;
@@module\hface\hface_api.pck;

exec Fazo_Schema.Fazo_z.Compile_Invalid_Objects;

prompt ==== VIEWS ====
@@module\hac\setup\hac_view.sql;

prompt ==== PROJECT ====
@@setup\init\job.sql;
@@setup\init\license.sql;
@@setup\init\project.sql;
@@setup\init\view.sql;
@@setup\init\watcher.sql;
@@setup\init\table_info.sql;
@@setup\init\audit_info.sql;
@@setup\hcr_timeuuid.fnc;
@@setup\role_settings.sql;
-- Temporary commentary, because md_core.gen_user_access runs in that script. This function execution time is very long time
-- @@setup\spread_role_settings.sql;
prompt ==== UIT ====
@@uit\uit_href.pck;
@@uit\uit_hes.pck;
@@uit\uit_hlic.pck;
@@uit\uit_htt.sql;
@@uit\uit_htt.pck;
@@uit\uit_hrm.pck;
@@uit\uit_hpd.pck;
@@uit\uit_hln.pck;
@@uit\uit_hpr.pck;
@@uit\uit_htm.pck;
@@uit\uit_hrec.pck;
@@uit\uit_hface.pck;
@@uit\uit_hac.pck;

-- todo REFACTORING, temporary solution for mobile settings
prompt ==== HES setting =====
@@module\hes\setup\hes_setting.sql;
prompt ==== HSC setting =====
@@module\hsc\setup\hsc_setting.sql;

@@start_ui.sql;
@@start_uis.sql;

-- Temporary Solution OLD Timepad supported form attached modules
exec uis.module_form('vhr','pro','/vx/es/timepad');
exec uis.module_form('vhr','start','/vx/es/timepad');
commit;

exec Fazo_Schema.Fazo_z.Compile_Invalid_Objects;
