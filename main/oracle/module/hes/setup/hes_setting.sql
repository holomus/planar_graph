prompt hes_setting
set define off
set serveroutput on
declare
  v_Project_Code varchar2(10) := Verifix.Project_Code;
  v_Current_Func varchar2(100);

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Translate_Code(i_Translate_Code varchar2) is
  begin
    z_Mt_Translate_Codes.Insert_One(i_Project_Code   => v_Project_Code,
                                    i_Translate_Code => v_Project_Code || ':' || v_Current_Func || ':' ||
                                                        i_Translate_Code);
  end;

  --------------------------------------------------
  Procedure Add_Oauth2_Provider
  (
    i_Provider_Id   number,
    i_Provider_Name varchar2,
    i_Auth_Url      varchar2,
    i_Token_Url     varchar2,
    i_Redirect_Uri  varchar2,
    i_Content_Type  varchar2,
    i_Scope         varchar2
  ) is
  begin
    z_Hes_Oauth2_Providers.Save_One(i_Provider_Id   => i_Provider_Id,
                                    i_Provider_Name => i_Provider_Name,
                                    i_Auth_Url      => i_Auth_Url,
                                    i_Token_Url     => i_Token_Url,
                                    i_Redirect_Uri  => i_Redirect_Uri,
                                    i_Content_Type  => i_Content_Type,
                                    i_Scope         => i_Scope);
  end;

begin
  Dbms_Output.Put_Line('==== OAuth2 providers ====');
  Add_Oauth2_Provider(Hes_Pref.c_Provider_Hh_Id,
                     'hh.uz',
                     'https://hh.ru/oauth/authorize',
                     'https://hh.ru/oauth/token',
                     '/receive/oauth2/hh',
                     'application/x-www-form-urlencoded',
                     '');

  Add_Oauth2_Provider(Hes_Pref.c_Provider_Olx_Id,
                     'olx.uz',
                     'https://www.olx.uz/oauth/authorize/',
                     'https://www.olx.uz/api/open/oauth/token',
                     '/receive/oauth2/olx',
                     'application/json',
                     'v2 read write');

  Dbms_Output.Put_Line('==== Mobile Translate ====');

  -- deleting translate codes
  delete from Mt_Translate_Codes q
   where q.Project_Code = v_Project_Code;

  -- Head
  v_Current_Func := 'head';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('settings');
  Add_Translate_Code('my_day');
  Add_Translate_Code('subordinate');
  Add_Translate_Code('happy_birthday');

  -- Profile
  v_Current_Func := 'profile';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('settings');
  Add_Translate_Code('account_title');
  Add_Translate_Code('security_title');
  Add_Translate_Code('change_account');
  Add_Translate_Code('change_password');
  Add_Translate_Code('remove_password');
  Add_Translate_Code('enter_with_touch_id');
  Add_Translate_Code('set_password');
  Add_Translate_Code('my_kpi');
  Add_Translate_Code('subordinates_kpi');
  Add_Translate_Code('show_direct_subordinates');
  Add_Translate_Code('notify_mark');
  Add_Translate_Code('current_filial');
  Add_Translate_Code('change_filial');
  Add_Translate_Code('account_password');
  Add_Translate_Code('gps_tracks');
  Add_Translate_Code('language');
  Add_Translate_Code('profile');
  Add_Translate_Code('profile_change');
  Add_Translate_Code('serial_number');
  Add_Translate_Code('system_title');
  Add_Translate_Code('version_number');

  -- MyDay
  v_Current_Func := 'my_day';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('timesheet');
  Add_Translate_Code('no_schedule');
  Add_Translate_Code('relax');
  Add_Translate_Code('weekend');
  Add_Translate_Code('work_day');
  Add_Translate_Code('working_day');
  Add_Translate_Code('hourly_schedule');
  Add_Translate_Code('merged_time');

  -- Subordinate
  v_Current_Func := 'subordinate';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('subordinates');
  Add_Translate_Code('show_all');
  Add_Translate_Code('sub_show_all');
  Add_Translate_Code('subordinate_requests');
  Add_Translate_Code('birthday_show_all');
  Add_Translate_Code('birthdays');

  -- DashboardMark
  v_Current_Func := 'dashboard_mark';

  Add_Translate_Code('card_title');
  Add_Translate_Code('check-in');
  Add_Translate_Code('input');
  Add_Translate_Code('output');

  -- MarkBarcode
  v_Current_Func := 'mark_barcode';

  Add_Translate_Code('qr_message');
  Add_Translate_Code('title');
  Add_Translate_Code('close');

  -- Tracking
  v_Current_Func := 'tracking';

  Add_Translate_Code('track_title');
  Add_Translate_Code('track_input');
  Add_Translate_Code('track_output');
  Add_Translate_Code('track_mark');
  Add_Translate_Code('track_not_valid');
  Add_Translate_Code('track_is_empty');
  Add_Translate_Code('track_today');
  Add_Translate_Code('track_at_date');
  Add_Translate_Code('tracking_type');
  Add_Translate_Code('track_time');
  Add_Translate_Code('track_location');
  Add_Translate_Code('track_note');
  Add_Translate_Code('more_tracks');
  Add_Translate_Code('employee_list_title');
  Add_Translate_Code('all_tracks_title');
  Add_Translate_Code('employee_tracks_title');
  Add_Translate_Code('employee_title');
  Add_Translate_Code('filter_title');
  Add_Translate_Code('track_list_is_empty');
  Add_Translate_Code('search_hint');
  Add_Translate_Code('employee_list_is_empty');
  Add_Translate_Code('employee_close_btn');
  Add_Translate_Code('employee_select_btn');
  Add_Translate_Code('check-in');
  Add_Translate_Code('input');
  Add_Translate_Code('output');
  Add_Translate_Code('fix_day');
  Add_Translate_Code('track_potential_output');
  Add_Translate_Code('track_merger');

  -- TrackingList
  v_Current_Func := 'tracking_list';

  Add_Translate_Code('all_tracks_title');
  Add_Translate_Code('employee_tracks_title');
  Add_Translate_Code('track_list_is_empty');
  Add_Translate_Code('back');
  Add_Translate_Code('employee');
  Add_Translate_Code('filter');

  -- Filter
  v_Current_Func := 'track_filter';

  Add_Translate_Code('filter_tracks_title');
  Add_Translate_Code('today');
  Add_Translate_Code('yesterday');
  Add_Translate_Code('last7day');
  Add_Translate_Code('last30day');
  Add_Translate_Code('current_month');
  Add_Translate_Code('last_month');
  Add_Translate_Code('cancel');
  Add_Translate_Code('filter');

  -- MarkFaceBean
  v_Current_Func := 'mark_face_bean';

  Add_Translate_Code('face_not_recognized');
  Add_Translate_Code('face_recognized');
  Add_Translate_Code('unable_generate_emotion');
  Add_Translate_Code('check_emotion_smile');
  Add_Translate_Code('check_emotion_close_left_eye');
  Add_Translate_Code('check_emotion_close_right_eye');

  -- MarkLocation
  v_Current_Func := 'mark_location';

  Add_Translate_Code('touch_id_description');
  Add_Translate_Code('please_wait');
  Add_Translate_Code('location_found');
  Add_Translate_Code('skip');
  Add_Translate_Code('location_not_match');

  -- MarkNote
  v_Current_Func := 'mark_note';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('cancel');
  Add_Translate_Code('send');
  Add_Translate_Code('field_required');
  Add_Translate_Code('track_note');
  Add_Translate_Code('note_hint_message');
  Add_Translate_Code('face');
  Add_Translate_Code('face_found');
  Add_Translate_Code('not_valid');
  Add_Translate_Code('location');
  Add_Translate_Code('location_not_found');
  Add_Translate_Code('location_accuracy');

  -- Camera
  v_Current_Func := 'camera';

  Add_Translate_Code('back');
  Add_Translate_Code('face_recognition');
  Add_Translate_Code('send_note');
  Add_Translate_Code('skip');
  Add_Translate_Code('please_wait');
  Add_Translate_Code('warning');
  Add_Translate_Code('repeat');
  Add_Translate_Code('ok');
  Add_Translate_Code('go_to_setting');
  Add_Translate_Code('location_request_denied_description');
  Add_Translate_Code('location_request_denied_title');
  Add_Translate_Code('camera_request_denied_description');
  Add_Translate_Code('camera_request_denied_title');

  -- Setting
  v_Current_Func := 'setting';

  Add_Translate_Code('please_wait');
  Add_Translate_Code('setting_downloads');
  Add_Translate_Code('load_vector_error');
  Add_Translate_Code('load_vector');
  Add_Translate_Code('account_btn');
  Add_Translate_Code('reload_btn');
  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('back');
  Add_Translate_Code('interface');
  Add_Translate_Code('lang');
  Add_Translate_Code('theme');
  Add_Translate_Code('background');
  Add_Translate_Code('main_page');
  Add_Translate_Code('default_system');
  Add_Translate_Code('light');
  Add_Translate_Code('dark');
  Add_Translate_Code('for_developer');
  Add_Translate_Code('components');
  Add_Translate_Code('notification');
  Add_Translate_Code('others');
  Add_Translate_Code('start_offline');

  -- SettingOptions
  v_Current_Func := 'setting_options';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('back');
  Add_Translate_Code('theme');
  Add_Translate_Code('default_system');
  Add_Translate_Code('light');
  Add_Translate_Code('dark');

  -- NotifyMarkSetting
  v_Current_Func := 'notify_mark_setting';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('enable_text');
  Add_Translate_Code('begin_time_notification');
  Add_Translate_Code('end_time_notification');
  Add_Translate_Code('minute');
  Add_Translate_Code('before');
  Add_Translate_Code('after');
  Add_Translate_Code('btn_close');
  Add_Translate_Code('btn_reset');
  Add_Translate_Code('header_description');
  Add_Translate_Code('header_title');
  Add_Translate_Code('reset');
  Add_Translate_Code('reset_warning_message');
  Add_Translate_Code('reset_warning_title');
  Add_Translate_Code('save');

  -- SubordinateDialog
  v_Current_Func := 'subordinate_dialog';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('list_is_empty');
  Add_Translate_Code('search_hint');
  Add_Translate_Code('btn_close');

  -- TimesheetStatistic
  v_Current_Func := 'timesheet_statistic';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('day_result_title');
  Add_Translate_Code('plan_time');
  Add_Translate_Code('intime');
  Add_Translate_Code('overtime');
  Add_Translate_Code('freetime');
  Add_Translate_Code('not_worked');

  -- TimesheetSchedule
  v_Current_Func := 'timesheet_schedule';

  Add_Translate_Code('schedule');
  Add_Translate_Code('work_day');
  Add_Translate_Code('dinner');
  Add_Translate_Code('leave');
  Add_Translate_Code('leave_full_day');
  Add_Translate_Code('change_swap');
  Add_Translate_Code('change_change');
  Add_Translate_Code('schedule_hourly');

  -- TimesheetTracking
  v_Current_Func := 'timesheet_tracking';

  Add_Translate_Code('more_tracks');
  Add_Translate_Code('list_is_empty');

  -- Timesheet
  v_Current_Func := 'timesheet';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('back_pressed');
  Add_Translate_Code('track_title');
  Add_Translate_Code('schedule');
  Add_Translate_Code('at_work');
  Add_Translate_Code('work_pass');
  Add_Translate_Code('employee_change');
  Add_Translate_Code('has_leave_full_day');
  Add_Translate_Code('weekend');
  Add_Translate_Code('january');
  Add_Translate_Code('february');
  Add_Translate_Code('march');
  Add_Translate_Code('april');
  Add_Translate_Code('may');
  Add_Translate_Code('june');
  Add_Translate_Code('july');
  Add_Translate_Code('august');
  Add_Translate_Code('september');
  Add_Translate_Code('october');
  Add_Translate_Code('november');
  Add_Translate_Code('december');

  -- TimesheetEmployeeInfo
  v_Current_Func := 'timesheet_employee_info';

  Add_Translate_Code('employee_statistic');
  Add_Translate_Code('track_title');
  Add_Translate_Code('show_all');
  Add_Translate_Code('schedule_requests');
  Add_Translate_Code('back');
  Add_Translate_Code('calendar');

  -- AttendanceChart
  v_Current_Func := 'attendance_chart';

  Add_Translate_Code('not_begin');
  Add_Translate_Code('take_leave');
  Add_Translate_Code('late');
  Add_Translate_Code('intime');
  Add_Translate_Code('not_come');
  Add_Translate_Code('free_day');
  Add_Translate_Code('holiday');
  Add_Translate_Code('non_working');
  Add_Translate_Code('not_licensed');
  Add_Translate_Code('no_schedule');
  Add_Translate_Code('no_license');
  Add_Translate_Code('nonworking_day');
  Add_Translate_Code('show_all');
  Add_Translate_Code('unknown');
  Add_Translate_Code('back');
  Add_Translate_Code('list_is_empty');

  -- TodayAttendance
  v_Current_Func := 'today_attendance';

  Add_Translate_Code('more_info');
  Add_Translate_Code('visits');
  Add_Translate_Code('back');
  Add_Translate_Code('sort');
  Add_Translate_Code('sort_full');
  Add_Translate_Code('filter');
  Add_Translate_Code('calendar');
  Add_Translate_Code('close');

  -- TodayAttendanceFilterDialog
  v_Current_Func := 'today_attendance_filter_dialog';

  Add_Translate_Code('close');
  Add_Translate_Code('select');
  Add_Translate_Code('filter');
  Add_Translate_Code('all');
  Add_Translate_Code('not_begin');
  Add_Translate_Code('take_leave');
  Add_Translate_Code('late');
  Add_Translate_Code('intime');
  Add_Translate_Code('not_come');
  Add_Translate_Code('free_day');
  Add_Translate_Code('holiday');
  Add_Translate_Code('non_working');
  Add_Translate_Code('not_licensed');
  Add_Translate_Code('no_schedule');
  Add_Translate_Code('no_license');
  Add_Translate_Code('nonworking_day');
  Add_Translate_Code('show_all');
  Add_Translate_Code('unknown');

  -- TrackWidget
  v_Current_Func := 'track_widget';

  Add_Translate_Code('not_valid');
  Add_Translate_Code('no_location');

  -- TrackInfo
  v_Current_Func := 'track_info';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('tracking_type');
  Add_Translate_Code('track_photo');
  Add_Translate_Code('not_valid');
  Add_Translate_Code('track_time');
  Add_Translate_Code('track_location');
  Add_Translate_Code('location_accuracy');
  Add_Translate_Code('location');
  Add_Translate_Code('track_note');
  Add_Translate_Code('back');

  -- TodayTimesheet
  v_Current_Func := 'today_timesheet';

  Add_Translate_Code('weekend');
  Add_Translate_Code('input');
  Add_Translate_Code('output');
  Add_Translate_Code('work_day');
  Add_Translate_Code('breaks');

  -- TimesheetInOut
  v_Current_Func := 'timesheet_inout';

  Add_Translate_Code('input');
  Add_Translate_Code('output');

  -- RequestList
  v_Current_Func := 'request_list';

  Add_Translate_Code('no_requests');
  Add_Translate_Code('january');
  Add_Translate_Code('february');
  Add_Translate_Code('march');
  Add_Translate_Code('april');
  Add_Translate_Code('may');
  Add_Translate_Code('june');
  Add_Translate_Code('july');
  Add_Translate_Code('august');
  Add_Translate_Code('september');
  Add_Translate_Code('october');
  Add_Translate_Code('november');
  Add_Translate_Code('december');
  Add_Translate_Code('back');
  Add_Translate_Code('toolbar_title');

  -- RequestComponent
  v_Current_Func := 'request_component';

  Add_Translate_Code('requests');
  Add_Translate_Code('show_all');
  Add_Translate_Code('for_today');
  Add_Translate_Code('this_month');
  Add_Translate_Code('swap');
  Add_Translate_Code('change_schedule');
  Add_Translate_Code('leave');

  -- MyRequests
  v_Current_Func := 'my_requests';

  Add_Translate_Code('my_requests');
  Add_Translate_Code('back');

  -- RequestDetails
  v_Current_Func := 'request_details';

  Add_Translate_Code('subordinate_name');
  Add_Translate_Code('leave');
  Add_Translate_Code('leave_type');
  Add_Translate_Code('leave_reason');
  Add_Translate_Code('date');
  Add_Translate_Code('time');
  Add_Translate_Code('change');
  Add_Translate_Code('dates');
  Add_Translate_Code('schedule_change');
  Add_Translate_Code('swap');
  Add_Translate_Code('replaced_day');
  Add_Translate_Code('replacing_day');
  Add_Translate_Code('comment');
  Add_Translate_Code('note');
  Add_Translate_Code('manager_note');
  Add_Translate_Code('request_state');
  Add_Translate_Code('manager_approval');
  Add_Translate_Code('comment_text');
  Add_Translate_Code('approved');
  Add_Translate_Code('denied');
  Add_Translate_Code('waiting');
  Add_Translate_Code('deny');
  Add_Translate_Code('approve');
  Add_Translate_Code('back');
  Add_Translate_Code('edit');
  Add_Translate_Code('delete');
  Add_Translate_Code('reset');
  Add_Translate_Code('free_schedule');
  Add_Translate_Code('lunch');
  Add_Translate_Code('lunch_end');
  Add_Translate_Code('lunch_start');
  Add_Translate_Code('schedule');
  Add_Translate_Code('time_end');
  Add_Translate_Code('time_start');
  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('weekend');
  Add_Translate_Code('work_day');
  Add_Translate_Code('working_hours_number');
  Add_Translate_Code('complete');
  Add_Translate_Code('not');
  Add_Translate_Code('send');
  Add_Translate_Code('specify');
  Add_Translate_Code('work_hours_number');
  Add_Translate_Code('not_specified');
  Add_Translate_Code('remove');
  Add_Translate_Code('accrual_kind');

  -- Swap
  v_Current_Func := 'swap';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('add');
  Add_Translate_Code('comment');
  Add_Translate_Code('comment_text');
  Add_Translate_Code('cancel');
  Add_Translate_Code('send');

  -- SwapItem
  v_Current_Func := 'swap_item';

  Add_Translate_Code('remove');
  Add_Translate_Code('specify');
  Add_Translate_Code('not_specified');
  Add_Translate_Code('replaced_day');
  Add_Translate_Code('replacing_day');

  -- Change
  v_Current_Func := 'change';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('add');
  Add_Translate_Code('cancel');
  Add_Translate_Code('send');
  Add_Translate_Code('comment');
  Add_Translate_Code('comment_text');

  -- ChangeItem
  v_Current_Func := 'change_item';

  Add_Translate_Code('remove');
  Add_Translate_Code('specify');
  Add_Translate_Code('date');
  Add_Translate_Code('not_specified');
  Add_Translate_Code('time_start');
  Add_Translate_Code('time_end');
  Add_Translate_Code('schedule');
  Add_Translate_Code('free_schedule');
  Add_Translate_Code('working_hours_number');
  Add_Translate_Code('lunch');
  Add_Translate_Code('lunch_start');
  Add_Translate_Code('lunch_end');
  Add_Translate_Code('weekend');

  -- Leave
  v_Current_Func := 'requests';

  Add_Translate_Code('leave');
  Add_Translate_Code('leave_type');
  Add_Translate_Code('leave_type_day');
  Add_Translate_Code('leave_type_days');
  Add_Translate_Code('leave_type_hourly');
  Add_Translate_Code('leave_reason');
  Add_Translate_Code('no_choice');
  Add_Translate_Code('date');
  Add_Translate_Code('time');
  Add_Translate_Code('time_start');
  Add_Translate_Code('time_end');
  Add_Translate_Code('change');
  Add_Translate_Code('dates');
  Add_Translate_Code('day_start');
  Add_Translate_Code('day_end');
  Add_Translate_Code('schedule_change');
  Add_Translate_Code('swap');
  Add_Translate_Code('replaced_day');
  Add_Translate_Code('replacing_day');
  Add_Translate_Code('comment');
  Add_Translate_Code('comment_text');
  Add_Translate_Code('request_state');
  Add_Translate_Code('manager_approval');
  Add_Translate_Code('approved');
  Add_Translate_Code('denied');
  Add_Translate_Code('waiting');
  Add_Translate_Code('back');
  Add_Translate_Code('edit');
  Add_Translate_Code('delete');
  Add_Translate_Code('specify');
  Add_Translate_Code('not_specified');
  Add_Translate_Code('cancel');
  Add_Translate_Code('send');
  Add_Translate_Code('lunch');
  Add_Translate_Code('lunch_start');
  Add_Translate_Code('lunch_end');
  Add_Translate_Code('free_schedule');
  Add_Translate_Code('working_hours_number');
  Add_Translate_Code('accrual');
  Add_Translate_Code('used');
  Add_Translate_Code('left');

  -- ProfileScreen
  v_Current_Func := 'profile_screen';

  Add_Translate_Code('profile');
  Add_Translate_Code('leave');
  Add_Translate_Code('back');
  Add_Translate_Code('date_of_birth');
  Add_Translate_Code('gender');
  Add_Translate_Code('manager');
  Add_Translate_Code('contacts');
  Add_Translate_Code('phone_number');
  Add_Translate_Code('email');
  Add_Translate_Code('region');
  Add_Translate_Code('city');
  Add_Translate_Code('residence_address');
  Add_Translate_Code('registration_address');
  Add_Translate_Code('accounts_and_ids');
  Add_Translate_Code('inn');
  Add_Translate_Code('inps');
  Add_Translate_Code('pinfl');
  Add_Translate_Code('personnel_number');
  Add_Translate_Code('exit_account_message');
  Add_Translate_Code('exit_account_no');
  Add_Translate_Code('exit_account_yes');
  Add_Translate_Code('warning');
  Add_Translate_Code('no_info');
  Add_Translate_Code('male');
  Add_Translate_Code('female');
  Add_Translate_Code('copied');
  Add_Translate_Code('gallery');
  Add_Translate_Code('camera');
  Add_Translate_Code('face');
  Add_Translate_Code('face_registered');
  Add_Translate_Code('face_not_registered');
  Add_Translate_Code('no_image_selected');
  Add_Translate_Code('image_source_question');
  Add_Translate_Code('accounts');

  -- FaceRegisteredScreen
  v_Current_Func := 'face_registered_screen';

  Add_Translate_Code('face_registered');
  Add_Translate_Code('finish');
  Add_Translate_Code('camera');
  Add_Translate_Code('capture_face_from_camera');
  Add_Translate_Code('choice_face_into_gallery');
  Add_Translate_Code('face_id_description');
  Add_Translate_Code('face_id_title');
  Add_Translate_Code('gallery');

  -- MyKPIScreen
  v_Current_Func := 'my_kpi';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('calculation_type');
  Add_Translate_Code('weight');
  Add_Translate_Code('calendar');

  -- SubordinatesKpiScreen
  v_Current_Func := 'subordinate_kpi';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('search');
  Add_Translate_Code('calendar');

  -- SubordinateKpiDetailedScreen
  v_Current_Func := 'subordinate_kpi_detailed';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('calculation_type');
  Add_Translate_Code('weight');
  Add_Translate_Code('calendar');

  -- KpiCategory
  v_Current_Func := 'kpi_category';

  Add_Translate_Code('calculation_type');
  Add_Translate_Code('weight');
  Add_Translate_Code('plan_type_m');
  Add_Translate_Code('plan_type_e');
  Add_Translate_Code('status');

  -- KpiPlanDetailedScreen
  v_Current_Func := 'kpi_plan_detailed';

  Add_Translate_Code('added');
  Add_Translate_Code('you');
  Add_Translate_Code('calculation_type');
  Add_Translate_Code('weight');
  Add_Translate_Code('at_time');
  Add_Translate_Code('add');
  Add_Translate_Code('close');
  Add_Translate_Code('edit');
  Add_Translate_Code('delete');
  Add_Translate_Code('yes');
  Add_Translate_Code('no');
  Add_Translate_Code('are_you_sure_delete');

  -- KpiPartAddEditScreen
  v_Current_Func := 'kpi_part_add_edit';

  Add_Translate_Code('accept');
  Add_Translate_Code('fact');
  Add_Translate_Code('comment');
  Add_Translate_Code('add');
  Add_Translate_Code('error_empty_field');

  -- GPSTracking
  v_Current_Func := 'gps_tracking';

  Add_Translate_Code('back');
  Add_Translate_Code('calendar');
  Add_Translate_Code('toolbar_title');

  -- InitSetup
  v_Current_Func := 'init_setup';

  Add_Translate_Code('back');
  Add_Translate_Code('accept');
  Add_Translate_Code('alert_face_id_message');
  Add_Translate_Code('alert_face_id_skip');
  Add_Translate_Code('alert_face_id_title');
  Add_Translate_Code('alert_gps_track_message');
  Add_Translate_Code('alert_gps_track_skip');
  Add_Translate_Code('alert_gps_track_title');
  Add_Translate_Code('finish');
  Add_Translate_Code('finish_description');
  Add_Translate_Code('finish_title');
  Add_Translate_Code('next');
  Add_Translate_Code('skip');
  Add_Translate_Code('start');

  -- Notification
  v_Current_Func := 'notification';

  Add_Translate_Code('back');
  Add_Translate_Code('calendar');
  Add_Translate_Code('coming_and_going');
  Add_Translate_Code('header_description');
  Add_Translate_Code('header_title');
  Add_Translate_Code('hes:nt:calendar_day_change');
  Add_Translate_Code('hes:nt:early_time');
  Add_Translate_Code('hes:nt:late_time');
  Add_Translate_Code('hes:nt:plan_change');
  Add_Translate_Code('hes:nt:plan_change_manager_approval');
  Add_Translate_Code('hes:nt:plan_change_status_change');
  Add_Translate_Code('hes:nt:request');
  Add_Translate_Code('hes:nt:request_change_status');
  Add_Translate_Code('hes:nt:request_manager_approval');
  Add_Translate_Code('plan_change');
  Add_Translate_Code('request');
  Add_Translate_Code('toolbar_title');

  -- Permission
  v_Current_Func := 'permission';

  Add_Translate_Code('enable');
  Add_Translate_Code('go_to_setting');
  Add_Translate_Code('gps_track_functional_limited_message');
  Add_Translate_Code('gps_track_functional_limited_title');
  Add_Translate_Code('location');
  Add_Translate_Code('location_description');
  Add_Translate_Code('location_title');
  Add_Translate_Code('no_thanks');
  Add_Translate_Code('skip');

  -- SubordinateCard
  v_Current_Func := 'subordinate_card';

  Add_Translate_Code('calendar');
  Add_Translate_Code('profile');

  -- SubordinateList
  v_Current_Func := 'subordinate_list';

  Add_Translate_Code('back');
  Add_Translate_Code('btn_close');
  Add_Translate_Code('list_is_empty');
  Add_Translate_Code('search');
  Add_Translate_Code('search_hint');
  Add_Translate_Code('toolbar_title');

  -- TrackingOffline
  v_Current_Func := 'tracking_offline';

  Add_Translate_Code('more_tracks');
  Add_Translate_Code('sync');
  Add_Translate_Code('sync_start');
  Add_Translate_Code('track_title');
  Add_Translate_Code('back');
  Add_Translate_Code('list_is_empty');
  Add_Translate_Code('toolbar_title');

  -- Birthday_List
  v_Current_Func := 'birthday_list';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('birthday_show_all');
  Add_Translate_Code('birthdays');
  Add_Translate_Code('list_is_empty');
  Add_Translate_Code('back');

  -- tracking_offline_list
  v_Current_Func := 'tracking_offline_list';

  Add_Translate_Code('back');
  Add_Translate_Code('list_is_empty');
  Add_Translate_Code('sync');
  Add_Translate_Code('toolbar_title');

  -- Attendance_Subordinate
  v_Current_Func := 'attendance_subordinate';

  Add_Translate_Code('back');

    -- Task list
  v_Current_Func := 'task_list';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('back');
  Add_Translate_Code('search');
  Add_Translate_Code('today');
  Add_Translate_Code('add_task');
  Add_Translate_Code('task_expired_days');
  Add_Translate_Code('expired');
  Add_Translate_Code('no_data_found');
  Add_Translate_Code('hour');
  Add_Translate_Code('day');
  Add_Translate_Code('list_is_empty');

  -- Task list filter
  v_Current_Func := 'task_list_filter';

  Add_Translate_Code('filter');
  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('select_status');
  Add_Translate_Code('apply');
  Add_Translate_Code('close');

  -- Task info
  v_Current_Func := 'task_info';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('back');
  Add_Translate_Code('edit');
  Add_Translate_Code('task_persons');
  Add_Translate_Code('comment');
  Add_Translate_Code('responsible');
  Add_Translate_Code('executor');
  Add_Translate_Code('participant');
  Add_Translate_Code('directory');
  Add_Translate_Code('observer');
  Add_Translate_Code('check_list');
  Add_Translate_Code('done_in');
  Add_Translate_Code('add_comment');
  Add_Translate_Code('btn_save');
  Add_Translate_Code('edit_comment');
  Add_Translate_Code('delete_comment');
  Add_Translate_Code('warning');
  Add_Translate_Code('delete_comment_message');
  Add_Translate_Code('quite_message');
  Add_Translate_Code('no');
  Add_Translate_Code('yes');
  Add_Translate_Code('un_auth_error');
  Add_Translate_Code('task_title_2');
  Add_Translate_Code('start_time');
  Add_Translate_Code('end_time');
  Add_Translate_Code('spent_time');
  Add_Translate_Code('grade');

  -- Task status dialog
  v_Current_Func := 'select_task_status';

  Add_Translate_Code('title');
  Add_Translate_Code('close');

  -- Task edit/create
  v_Current_Func := 'task_edit';

  Add_Translate_Code('toolbar_edit_title');
  Add_Translate_Code('toolbar_create_title');
  Add_Translate_Code('dialog_title_warning');
  Add_Translate_Code('ok');
  Add_Translate_Code('dialog_message_warning');
  Add_Translate_Code('title_bt_apply');
  Add_Translate_Code('task_title');
  Add_Translate_Code('task_add_description');
  Add_Translate_Code('title_status');
  Add_Translate_Code('title_select_status');
  Add_Translate_Code('back');
  Add_Translate_Code('save');
  Add_Translate_Code('create');
  Add_Translate_Code('check_list');
  Add_Translate_Code('task_add_checklist');
  Add_Translate_Code('title_responsible');
  Add_Translate_Code('title_executor');
  Add_Translate_Code('title_participant');
  Add_Translate_Code('title_director');
  Add_Translate_Code('title_observer');
  Add_Translate_Code('start_time');
  Add_Translate_Code('end_time');
  Add_Translate_Code('title_grade');
  Add_Translate_Code('title_spent_time');
  Add_Translate_Code('pick_date');

  -- task person list
  v_Current_Func := 'task_person_list';

  Add_Translate_Code('toolbar_title');
  Add_Translate_Code('list_is_empty');
  Add_Translate_Code('back');
  Add_Translate_Code('apply');
  Add_Translate_Code('search');
  Add_Translate_Code('warning');
  Add_Translate_Code('quite_message');
  Add_Translate_Code('no');
  Add_Translate_Code('yes');

  commit;
end;
/
