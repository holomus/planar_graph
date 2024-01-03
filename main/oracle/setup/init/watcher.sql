prompt verifix watcher
declare
  Procedure Watcher
  (
    a varchar2,
    b varchar2,
    c varchar2
  ) is
  begin
    z_Biruni_Watchers.Insert_One(i_Watching_Expr => a, i_Watcher_Procedure => b, i_Order_No => c);
  end;
begin
  delete Biruni_Watchers t
   where Regexp_Like(t.Watcher_Procedure, '^(href|hlic|htt|hzk|hrm|hpr|hpd|hper|hrec|hsc)_watcher\.');
  delete Biruni_Watchers t
   where Regexp_Like(t.Watcher_Procedure, '^(hzk)_api\.');

-- order starts from 2, md_watcher standing in 1
  Watcher('md_global.w_new_company_id', 'href_watcher.on_company_add', 2);
  Watcher('md_global.w_new_company_id', 'htt_watcher.on_company_add', 3);
  Watcher('md_global.w_new_company_id', 'hpr_watcher.on_company_add', 4);
  Watcher('md_global.w_new_company_id', 'hpd_watcher.on_company_add', 5);
  Watcher('md_global.w_new_company_id', 'hper_watcher.on_company_add', 6);
  Watcher('md_global.w_new_company_id', 'hrec_watcher.on_company_add', 7);
  Watcher('htt_global.w_person', 'hzk_api.person_sync', 1);
  Watcher('md_global.w_new_filial', 'htt_watcher.on_filial_add', 1);
  Watcher('mrf_global.w_old_robot', 'hrm_watcher.on_robot_save', 1);
  Watcher('mrf_global.w_new_division_manager', 'hrm_watcher.on_manager_change', 1);
  Watcher('kl_global.w_new_license', 'hlic_watcher.on_license_create', 1);
  Watcher('md_global.w_new_filial', 'hsc_watcher.on_filial_add', 1);
  Watcher('mhr_global.w_division', 'hrm_watcher.on_division_change', 1);
  
  commit;
end;
/
