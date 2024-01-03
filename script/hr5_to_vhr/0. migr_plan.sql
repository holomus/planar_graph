prompt migr plan for smartup5_hr to verifix_hr
version verifix_hr is v2.2.0

Plan:
 1. run create_synonyms scripts
    1.1.create_synonyms.sql script on hr5 (smartup5_hr) schema
    and
    1.2.create_synonyms.sql script on vhr (verifix_hr) schema
    or
    1.3.create_synonyms(for database link).sql on vhr (verifix_hr) schema

    --- do next steps on vhr (verifix_hr) schema

 2. run 2. start_migr.sql
    it will run 2nd, 3rd and 4th steps
 5. create new company and set Md_Pref.c_Migr_Company_id to new_company_id
 6. if needed, change c_Every_Commit_Row in 3.1.hr_migr_pref and run it
 7. before running migr script take into account:
    admin user will not be migrated;
    some data not migrated (reasons given neded parts)

 8. run 8.run_script.tst needed part
 9. after filiel created, create default schedule and set its id to hr5_migr_robot.migr_initial_journals v_schedule_id variable
10. set Md_Pref.c_Migr_Company_id to -1



-------- needed statements
-- select * from Hr5_Migr_Errors;
-- delete from Hr5_Migr_Errors;

-------- notes

----------------------------------------------------------------------------------------------------
-- moving tables data to verifix hr tables data
----------------------------------------------------------------------------------------------------

-- HRCC, PAYROLL modules not migrated

----------------------------- migrated tables --------------------------------------------------

---------------------- md module ------------------------
 1. md_persons                  - md_persons
 2. md_users                    - md_users -- without admin_id, lang_code
 3. mr_natural_persons          - mr_natural_persons -- without legal_person_id
 4. mr_person_details           - mr_person_details -- without facebook, twitter, skype, license_begin_date, license_end_date, license_code, region_id(no data)

---------------------- ref module -------------------------
 1. hr_ref_personal_documents   - href_document_types
 2. hr_ref_education_types      - href_edu_stages
 3. hr_ref_institutions         - href_institutions
 4. hr_ref_specialities         - href_specialties
 6. hr_ref_languages            - href_langs
 7. hr_ref_lang_levels          - href_lang_levels
 8. hr_ref_marriage_conds       - href_marital_statuses
 9. hr_ref_relationships        - href_relation_degrees
10. hr_ref_reasons              - dissmissal_reason -- moved without code, state
11. hr_ref_post_types           - job_group -- without (expense_coa_id expense_ref_set)
12. hr_ref_department_types     - mhr_division_groups -- without order_no -- todo add order_no
37. hr_ref_rewards              - awards -- without place, reward; name 200 char
18. hr_ref_ranks                - mhr_ranks (filial level) -- without affect_wage, state
23. hr_ref_business_reasons     - href_business_trip_reasons (filial level)
25. hr_ref_departments          - mhr_divisions(filial level) -- without begin_date, end_date_nvl, address, square, lat_lng, phone_number, photo_sha, kind, region_id
26. hr_ref_department_groups    - using for parent-child structure on divisions: parent-department_id, child-group_id -- without order_no
27. hr_ref_dept_group_binds     - using for parent-child structure on divisions: parent-group_id, child-department_id
34. hr_ref_posts                - job


--------------------- staff module ------------------------
 1. hr_staffs                   - mr_natural_persons and mhr_employees -- without educ_id by_know_id position civil_contractor date_begin main_card_number main_bank_account_code rf_code
 2. hr_staff_personal_documents - person_documents -- without order_no
 3. hr_staff_relationships      - person_relationships -- without order_no
 4. hr_staff_educations         - href_person_edu_stages -- skill(400), without university_id, educ_document_id, doc_series, doc_number
 7. hr_staff_languages          - href_person_langs (is_native ? - no data)
12. hr_staff_cards              - bank_account (maybe bank needed - only 874 bank id (code - '01115') used)


--------------------- robot module -------------------------
 2. hr_robots                   - (position_type, expense_coa_id, expense_ref_set, condition, parent_id)
 5. hr_robot_dept_responsibles  - division manager
 6. hr_robot_assignments        - journals -- unemploed data ignored -- request qilmoqchimiz balkim
 9. hr_movements                - util data for hr_robot_assignments
21. hr_leave_docs               - sick_leave, vacation --- without free vocation leave - realizatsiya qilmoqchimiz, vocation files o'tmadi
22. hr_doc_files                - hr_leave_docs files -- only sick leave files
33. hr_plan_docs                - htt_schedule_registriesy for robot -- robot plan change by period
34. hr_plan_doc_robots          - htt_registry_units -- robot plan change by period
35. hr_plan_doc_items           - htt_unit_schedule_days-- robot plan change by period


--------------------- learn module -------------------------
 1. hr_learn_testing_answers    - hln_testing_question_options
 4. hr_learn_part_persons       - testing
 5. hr_learn_questions          - hln_questions
 6. hr_learn_question_options   - hln_question_options
 7. hr_learn_trains             - hln_attestations / hln_trainings
 8. hr_learn_train_parts        - each part as attestation
 9. hr_learn_testing_persons    - testing
10. hr_learn_categories         - hln_question_groups / hln_question_types
11. hr_learn_tests              - hln_exams
12. hr_learn_test_questions     - hln_exam_manual_questions
13. hr_learn_part_testings      - testing
14. hr_learn_testings           - hln_testings


--------------------- hrt module -------------------------
 1. hrt_checkpoints             - htt_locations
 2. hrt_checkpoint_departments  - htt_location_divisions
 3. hrt_user_checkpoints        - htt_location_persons (manual)
 5. hrt_tracks                  - htt_tracks
 6. hrt_zktime_devices          - hzk_devices
 7. hrt_zktime_commands         - hzk_commands
 8. hrt_zktime_server_fps       - hzk_person_fprints, hzk_device_fprints
10. hrt_zktime_device_pins      - htt_device_admins
11. hrt_zktime_errors           - hzk_errors
14. hrt_migr_persons            - hzk_migr_persons
16. hrt_attlog_errors           - hzk_attlog_errors

--------------------- cv module -------------------------
 1. hr_cv_contracts             - hpd_cv_contracts
 2. hr_cv_contract_items        - hpd_cv_contract_items
 3. hr_cv_contract_files        - hpd_cv_contract_files
 4. hr_cv_cached_item_names     - href_cached_contract_item_names
 5. hr_cv_facts                 - hpr_cv_contract_facts
 6. hr_cv_fact_items            - hpr_cv_contract_fact_items

----------------------------- not migrated tables --------------------------------------------------

---------------------- ref module -------------------------
 5. hr_ref_professions          - href_professions -- deleted from vhr
13. hr_ref_by_knows             - canditat structura ?
14. hr_ref_educs                - href_edu_stages ?
15. hr_ref_universities         - -- learn ?
16. hr_ref_education_docs       - -- learn ?
17. hr_ref_categories           - -- learn ?
19. hr_ref_appointments         - --- ?
20. hr_ref_divisions            - --- mhr_divisions(filial level) ?
21. hr_ref_timesheet_reasons    - --- ?
22. hr_ref_minimum_wages        - --- ?
24. hr_ref_recom_reasons        - -- todo ?
28. hr_ref_department_users     - manual access to division
29. hr_department_banned_days   - -- todo lock days for division ?
30. hr_ref_area_types           - --- ?
31. hr_ref_dept_area_binds      - --- ?
32. hr_register_dept_types      - --- ?
33. hr_ref_post_groups          - grading system ?
35. hr_post_rank_periods        - grading system ?
36. hr_ref_holidays             - --- calendar maybe ?


--------------------- staff module ------------------------
 5. hr_staff_professions        - href_person_professions -- without order_no -- deleted from vhr
 6. hr_staff_specialities       - href_person_specialties (category, note ?  1- data without category) ? -- deleted from vhr
 8. hr_staff_files              - mr_person_files -- no data
 9. hr_staff_work_places        - --- maybe not needed or hpd_documents ? -- no data
10. hr_staff_departments        -
11. hr_staff_posts              -
13. hr_staff_rewards            - -- no data


--------------------- robot module -------------------------
 1. hr_timesheet_templates      - htt_schedule (move data, other days in year make off day)
 3. hr_robot_wage_users         - ---
 4. hr_robot_group_responsibles - division manager -- no data
 7. hr_job_directions           - ---
 8. hr_job_direction_notes      - ---
10. hr_sheets                   -
11. hr_robot_duties             -
12. hr_timesheets               - htt_timesheets
13. hr_timesheet_tracks         - htt_timesheet_tracks
14. hr_timesheet_reasons        - (maybe request) ---
15. hr_timesheet_incentives     -
16. hr_recom_rank_docs          - ---- grading system ?
17. hr_recom_ranks              - ---- grading system ?
18. hr_register_ranks           -
19. hr_register_position_types  - ---
20. hr_business_trip_docs       - (to_department_id, to_robot_id) ---
23. hr_dc_templates             - --- docflow not needed ?
24. hr_dc_template_signs        - --- docflow not needed ?
25. hr_dc_template_sign_items   - --- docflow not needed ?
26. hr_dc_robot_assignments     -
27. hr_dc_leave_docs            - sick_leave, vacation
28. hr_dc_business_trip_docs    - (to_department_id, saved_wage_rate)
29. hr_dc_movements             - transfer
30. hr_dc_files                 -
31. hr_dc_signatures            - --- docflow not needed ?
32. hr_dc_signature_items       - --- docflow not needed ?
36. hr_robot_replace_docs       - --- no data
37. hr_robot_replace_doc_items  - (swap) --- no data
38. hr_timesheet_adjust_docs    - --- korrektirovka
39. hr_timesheet_adjust_items   - --- korrektirovka


--------------------- learn module -------------------------
 2. hr_learn_part_interviews    -  ---- (empty)
 3. hr_learn_part_files         -  ---- (empty)


--------------------- hrt module -------------------------
 4. hrt_staff_privates          - --- empty
 9. hrt_zktime_server_pins      - not migrated (not found neccessary infos, all person kinds same ('T'))
12. hrt_device_staffs           - --- empty
13. hrt_migr_tracks             - --- empty
15. hrt_migr_fps                - --- empty
