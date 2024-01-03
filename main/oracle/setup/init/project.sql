declare
  r_Service Biruni_Messaging_Service_Setting%rowtype;
begin
  z_Md_Projects.Save_One(i_Project_Code             => Verifix.Project_Code,
                         i_Path_Prefix_Set          => 'vhr',
                         i_Module_Prefix_Set        => 'href,hes,hlic,htt,hzk,hrm,hpd,hper,hpr,hisl,hln,hsc,htm,hac,hrec,hface,hide',
                         i_Visible                  => 'Y',
                         i_Fcm_Authorization_Key    => 'AAAAcHX2Jzc:APA91bEpajdLsbVXLbHXDXx1-5Qoex20AKU5FJ1zpWjJkrmlmFYkYlOv2axG3veeFExylBGBWkfXofnekGkBoi0Ohwp0-yXn-wK84NC-rxNVr_rTX0-fzJXnOJLaZ0VkTEWA6j11_LNt',
                         i_Smsfly_Url               => 'https://api.smsfly.uz/send',
                         i_Smsfly_Authorization_Key => '0572c2e6-0734-11ed-a71e-0242ac120002',
                         i_Intro_Form               => '/vhr/intro/dashboard',
                         i_Subscription_End_Form    => '/vhr/hlic/no_license',
                         i_Parent_Code              => Mr_Pref.c_Pc_Anor,
                         i_Check_Subscription       => 'Y',
                         i_Version                  => Verifix.Version);
  commit;

  -- Messaging service reconfigure
  r_Service      := z_Biruni_Messaging_Service_Setting.Take('U');
  r_Service.Code := 'U';

  if r_Service.Sms_Service_Url is null then
    r_Service.Sms_Service_Url      := 'https://api.smsfly.uz/send';
    r_Service.Sms_Service_Auth_Key := '0572c2e6-0734-11ed-a71e-0242ac120002';
  
    z_Biruni_Messaging_Service_Setting.Save_Row(r_Service);
  end if;

  commit;
end;
/
