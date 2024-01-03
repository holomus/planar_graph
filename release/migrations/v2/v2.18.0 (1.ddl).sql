prompt adding BSSID
----------------------------------------------------------------------------------------------------
alter table htt_locations    add bssids varchar2(2000 char);
alter table htt_tracks       add bssid  varchar2(100);
alter table htt_trash_tracks add bssid  varchar2(100);

comment on column htt_tracks.bssid is 'BSSID. If device can not find location, then send bssid';
comment on column htt_locations.bssids is 'BSSID stands for Basic Service Set Identifier, and it’s  wireless router that is used to connect to the WiFi';

----------------------------------------------------------------------------------------------------
prompt adding extra phone
---------------------------------------------------------------------------------------------------- 
alter table Href_Person_Details add extra_phone varchar2(100 char);

----------------------------------------------------------------------------------------------------
prompt adding notification settings
----------------------------------------------------------------------------------------------------
alter table Hrm_Settings add notification_enable varchar2(1);
