create or replace package Htt_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Location_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Time_Kind_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Time_Kind_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Track_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Track_Stop(i_Company_Id number);
end Htt_Audit;
/
create or replace package body Htt_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_REQUESTS',
                           i_Column_List => 'REQUEST_ID,REQUEST_KIND_ID,BEGIN_TIME,END_TIME,REQUEST_TYPE,MANAGER_NOTE,NOTE,STATUS,BARCODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_REQUESTS_I1',
                              i_Table_Name  => 'HTT_REQUESTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,REQUEST_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Request_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_REQUESTS');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Change_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_PLAN_CHANGES',
                           i_Column_List => 'CHANGE_ID,CHANGE_KIND,NOTE,STATUS,MANAGER_NOTE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_PLAN_CHANGES_I1',
                              i_Table_Name  => 'HTT_PLAN_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,CHANGE_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_CHANGE_DAYS',
                           i_Column_List => 'CHANGE_ID,CHANGE_DATE,SWAPPED_DATE,DAY_KIND,BEGIN_TIME,END_TIME,BREAK_ENABLED,BREAK_BEGIN_TIME,BREAK_END_TIME,PLAN_TIME,STAFF_ID',
                           i_Parent_Name => 'HTT_PLAN_CHANGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_CHANGE_DAYS_I1',
                              i_Table_Name  => 'HTT_CHANGE_DAYS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,CHANGE_ID,CHANGE_DATE,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_CHANGE_DAYS_I2',
                              i_Table_Name  => 'HTT_CHANGE_DAYS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,CHANGE_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Change_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_PLAN_CHANGES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_CHANGE_DAYS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_LOCATION_TYPES',
                           i_Column_List => 'LOCATION_TYPE_ID,NAME,COLOR,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_LOCATION_TYPES_I1',
                              i_Table_Name  => 'HTT_LOCATION_TYPES',
                              i_Column_List => 'T_COMPANY_ID,LOCATION_TYPE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Type_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_LOCATION_TYPES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_LOCATIONS',
                           i_Column_List => 'LOCATION_ID,NAME,LOCATION_TYPE_ID,TIMEZONE_CODE,REGION_ID,ADDRESS,LATLNG,ACCURACY,BSSIDS,PROHIBITED,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_LOCATIONS_I1',
                              i_Table_Name  => 'HTT_LOCATIONS',
                              i_Column_List => 'T_COMPANY_ID,LOCATION_ID,T_CONTEXT_ID');
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_LOCATION_POLYGON_VERTICES',
                           i_Column_List => 'LOCATION_ID,ORDER_NO,LATLNG',
                           i_Parent_Name => 'HTT_LOCATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_LOCATION_POLYGON_VERTICES_I1',
                              i_Table_Name  => 'HTT_LOCATION_POLYGON_VERTICES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,LOCATION_ID,T_CONTEXT_ID');
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_LOCATION_PERSONS',
                           i_Column_List => 'LOCATION_ID,PERSON_ID,ATTACH_TYPE',
                           i_Parent_Name => 'HTT_LOCATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_LOCATION_PERSONS_I1',
                              i_Table_Name  => 'HTT_LOCATION_PERSONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,LOCATION_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Location_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_LOCATIONS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HTT_LOCATION_POLYGON_VERTICES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_LOCATION_PERSONS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Time_Kind_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_TIME_KINDS',
                           i_Column_List => 'TIME_KIND_ID,NAME,LETTER_CODE,DIGITAL_CODE,PARENT_ID,PLAN_LOAD,BG_COLOR,COLOR,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_TIME_KINDS_I1',
                              i_Table_Name  => 'HTT_TIME_KINDS',
                              i_Column_List => 'T_COMPANY_ID,TIME_KIND_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Time_Kind_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_TIME_KINDS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_REQUEST_KINDS',
                           i_Column_List => 'REQUEST_KIND_ID,NAME,TIME_KIND_ID,ANNUALLY_LIMITED,DAY_COUNT_TYPE,ANNUAL_DAY_LIMIT,USER_PERMITTED,ALLOW_UNUSED_TIME,REQUEST_RESTRICTION_DAYS,CARRYOVER_POLICY,CARRYOVER_CAP_DAYS,CARRYOVER_EXPIRES_DAYS,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_REQUEST_KINDS_I1',
                              i_Table_Name  => 'HTT_REQUEST_KINDS',
                              i_Column_List => 'T_COMPANY_ID,REQUEST_KIND_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Kind_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_REQUEST_KINDS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HTT_TRACKS',
                           i_Column_List => 'TRACK_ID,TRACK_DATE,TRACK_TIME,TRACK_DATETIME,PERSON_ID,TRACK_TYPE,MARK_TYPE,DEVICE_ID,LOCATION_ID,LATLNG,ACCURACY,PHOTO_SHA,BSSID,NOTE,ORIGINAL_TYPE,IS_VALID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HTT_TRACKS_I1',
                              i_Table_Name  => 'HTT_TRACKS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,TRACK_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Track_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HTT_TRACKS');
  end;

end Htt_Audit;
/
