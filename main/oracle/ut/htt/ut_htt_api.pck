create or replace package Ut_Htt_Api is
  --%suite(htt_api)
  --%suitepath(vhr.htt.htt_api)
  --%beforeall(create_filial)
  --%beforeeach(context_begin)
  --%aftereach(biruni_route.context_end)

  --%context(request_save)
  --%beforeall(create_basic_staff, create_request_kind)

  --%context(request_save_positive)

  --%test(try saving previously non-existent new request)
  Procedure Save_New_Request;

  --- request_save saves request with status new regardless if status of
  --- incoming request is different
  --%test(try saving updated request)
  --%beforetest(create_Basic_Request)
  Procedure Save_Updated_Request;

  --%test(try saving new request with positive restriction days)
  --%beforetest(update_request_kind_positive)
  Procedure Save_Request_Not_Exceed_Positive_Restriction_Days;

  --%test(try saving new request with negative restriction days)
  --%beforetest(update_request_kind_negative)
  Procedure Save_Request_Not_Exceed_Negative_Restriction_Days;
  --%endcontext

  --%context(request_save_negative)

  --%test(try saving request with status != new)
  Procedure Save_Approved_Request;

  --%test(try saving request with different staff id)
  --%beforetest(create_basic_request)
  --%throws(b.error_n)
  Procedure Save_Request_With_Different_Staff;

  --%test(try saving request with wrong plan load)
  --%throws(b.error_n)
  Procedure Save_Request_With_Wrong_Time;

  --%test(try saving request with too many days)
  --%throws(b.error_n)    
  Procedure Save_Request_With_Many_Days;

  --%test(try saving request which time of request intersects with another request)
  --%beforetest(create_three_day_request)
  --%throws(b.error_n)
  Procedure Save_Request_Intersection;

  --%test(try saving request too early(exceeding positive restriction days))
  --%beforetest(update_request_kind_positive)
  --%throws(b.error_n)
  Procedure Save_Request_Exceed_Positive_Restriction_Days;

  --%test(try saving request too late(exceeding negative restriction days))
  --%beforetest(update_request_kind_negative)
  --%throws(b.error_n)
  Procedure Save_Request_Exceed_Negative_Restriction_Days;

  --%test(check notify for request)
  Procedure Check_Notify_Request;

  --%test(check notify for plan change)
  Procedure Check_Notify_Plan_Change;

  --%endcontext
  --%endcontext
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Update_Request_Kind_Positive;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Update_Request_Kind_Negative;
  ----------------------------------------------------------------------------------------------------
  Procedure Context_Begin;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Request_Kind;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Staff;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Request;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Three_Day_Request;
  ----------------------------------------------------------------------------------------------------
  Procedure Check_Htt_Requests_Row
  (
    v_Expected_Row    in Htt_Requests%rowtype,
    v_Begin_Time      in date,
    v_End_Time        in date,
    v_Staff_Id        in number,
    v_Request_Kind_Id in number,
    v_Request_Type    in varchar2,
    v_Status          in varchar2
  );

end Ut_Htt_Api;
/
create or replace package body Ut_Htt_Api is
  ---------------------------------------------------------------------------------------------------- 
  g_Filial_Id              number;
  g_Division_Id            number;
  g_Person_Id              number;
  g_Request_Kind           number;
  g_Request_Id             number;
  g_Time_Kind_Id           number;
  g_Staff_Id               number;
  g_Firebase_Service_Class varchar2(100) := 'uz.greenwhite.biruni.service.finalservice.FCMessagingService';
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Location_Division_Staff is
  begin
    g_Person_Id := Ut_Vhr_Util.Create_Employee(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id);
  
    g_Division_Id := Ut_Vhr_Util.Create_Division(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Context_Begin is
  begin
    Ut_Util.Context_Begin(i_Filial_Id => g_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Request_Kind is
  begin
    g_Time_Kind_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Leave);
  
    g_Request_Kind := Htt_Next.Request_Kind_Id;
  
    z_Htt_Request_Kinds.Insert_One(i_Company_Id               => Ui.Company_Id,
                                   i_Request_Kind_Id          => g_Request_Kind,
                                   i_Name                     => 'default',
                                   i_Time_Kind_Id             => g_Time_Kind_Id,
                                   i_Annually_Limited         => 'Y',
                                   i_Day_Count_Type           => Htt_Pref.c_Day_Count_Type_Calendar_Days,
                                   i_Annual_Day_Limit         => 100,
                                   i_User_Permitted           => 'Y',
                                   i_Allow_Unused_Time        => 'Y',
                                   i_Request_Restriction_Days => null,
                                   i_State                    => 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial is
  begin
    Ut_Util.Context_Begin;
    g_Filial_Id := Ut_Vhr_Util.Create_Filial(Ui.Company_Id);
    Biruni_Route.Context_End;
    Context_Begin;
    Biruni_Route.Context_End;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Staff is
  begin
    g_Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_New_Request is
    v_Check_Row    Htt_Requests%rowtype;
    v_Request_Row  Htt_Requests%rowtype;
    v_Begin_Time   date := sysdate - 10;
    v_End_Time     date := sysdate;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Multiple_Days;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    g_Request_Id := Htt_Next.Request_Id;
  
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    Htt_Api.Request_Save(v_Request_Row);
  
    v_Check_Row := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Request_Id => g_Request_Id);
  
    Check_Htt_Requests_Row(v_Expected_Row    => v_Check_Row,
                           v_Begin_Time      => v_Begin_Time,
                           v_End_Time        => v_End_Time,
                           v_Staff_Id        => g_Staff_Id,
                           v_Request_Kind_Id => g_Request_Kind,
                           v_Request_Type    => v_Request_Type,
                           v_Status          => v_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Updated_Request is
    v_Request_Row  Htt_Requests%rowtype;
    v_Check_Row    Htt_Requests%rowtype;
    v_Begin_Time   date := sysdate + 1;
    v_End_Time     date := sysdate + 1;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    v_Request_Row.Note := 'Note';
    Htt_Api.Request_Save(v_Request_Row);
  
    v_Check_Row := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Request_Id => g_Request_Id);
  
    Check_Htt_Requests_Row(v_Expected_Row    => v_Check_Row,
                           v_Begin_Time      => v_Begin_Time,
                           v_End_Time        => v_End_Time,
                           v_Staff_Id        => g_Staff_Id,
                           v_Request_Kind_Id => g_Request_Kind,
                           v_Request_Type    => v_Request_Type,
                           v_Status          => v_Status);
  
    Ut.Expect(v_Check_Row.Note).To_Equal(v_Request_Row.Note);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Approved_Request is
    v_Request_Row  Htt_Requests%rowtype;
    v_Check_Row    Htt_Requests%rowtype;
    v_Begin_Time   date := sysdate;
    v_End_Time     date := sysdate;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_Approved;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    Htt_Api.Request_Save(v_Request_Row);
  
    v_Check_Row := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Request_Id => g_Request_Id);
  
    v_Status := Htt_Pref.c_Request_Status_New;
  
    Check_Htt_Requests_Row(v_Expected_Row    => v_Check_Row,
                           v_Begin_Time      => v_Begin_Time,
                           v_End_Time        => v_End_Time,
                           v_Staff_Id        => g_Staff_Id,
                           v_Request_Kind_Id => g_Request_Kind,
                           v_Request_Type    => v_Request_Type,
                           v_Status          => v_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Request is
    v_Begin_Time   date := sysdate;
    v_End_Time     date := sysdate;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25);
  begin
    g_Request_Id := Htt_Next.Request_Id;
    v_Barcode    := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests, i_Id => g_Request_Id);
  
    z_Htt_Requests.Insert_One(i_Company_Id      => Ui.Company_Id,
                              i_Filial_Id       => Ui.Filial_Id,
                              i_Request_Id      => g_Request_Id,
                              i_Request_Kind_Id => g_Request_Kind,
                              i_Staff_Id        => g_Staff_Id,
                              i_Begin_Time      => v_Begin_Time,
                              i_End_Time        => v_End_Time,
                              i_Request_Type    => v_Request_Type,
                              i_Manager_Note    => '',
                              i_Note            => '',
                              i_Status          => v_Status,
                              i_Barcode         => v_Barcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Request_With_Different_Staff is
    v_Begin_Time   date := sysdate;
    v_End_Time     date := sysdate;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
    v_Staff_Id     number := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                                      i_Filial_Id  => Ui.Filial_Id);
    v_Request_Row  Htt_Requests%rowtype;
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => v_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    Htt_Api.Request_Save(v_Request_Row);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Request_With_Wrong_Time is
    v_Request_Row  Htt_Requests%rowtype;
    v_Begin_Time   date := sysdate - 10;
    v_End_Time     date := sysdate;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    Htt_Api.Request_Save(v_Request_Row);
  
    Ut.Expect(z_Htt_Requests.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Request_Id => g_Request_Id)).To_Be_False();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Request_With_Many_Days is
    v_Request_Row  Htt_Requests%rowtype;
    v_Begin_Time   date := sysdate - 150;
    v_End_Time     date := sysdate + 150;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Multiple_Days;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    Htt_Api.Request_Save(v_Request_Row);
  
    Ut.Expect(z_Htt_Requests.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Request_Id => g_Request_Id)).To_Be_False();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Three_Day_Request is
    v_Begin_Time   date := Trunc(sysdate) - 3;
    v_End_Time     date := Trunc(sysdate) + 1;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Multiple_Days;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_Completed;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    g_Request_Id := Htt_Next.Request_Id;
  
    z_Htt_Requests.Insert_One(i_Company_Id      => Ui.Company_Id,
                              i_Filial_Id       => Ui.Filial_Id,
                              i_Request_Id      => g_Request_Id,
                              i_Request_Kind_Id => g_Request_Kind,
                              i_Staff_Id        => g_Staff_Id,
                              i_Begin_Time      => v_Begin_Time,
                              i_End_Time        => v_End_Time,
                              i_Request_Type    => v_Request_Type,
                              i_Manager_Note    => '',
                              i_Note            => '',
                              i_Status          => v_Status,
                              i_Barcode         => v_Barcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Request_Intersection is
    v_Request_Row  Htt_Requests%rowtype;
    v_Begin_Time   date := Trunc(sysdate) - 2;
    v_End_Time     date := Trunc(sysdate);
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Multiple_Days;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
  begin
    g_Request_Id := Htt_Next.Request_Id;
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
    Htt_Api.Request_Save(v_Request_Row);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Htt_Requests_Row
  (
    v_Expected_Row    in Htt_Requests%rowtype,
    v_Begin_Time      in date,
    v_End_Time        in date,
    v_Staff_Id        in number,
    v_Request_Kind_Id in number,
    v_Request_Type    in varchar2,
    v_Status          in varchar2
  ) is
  begin
    Ut.Expect(v_Expected_Row.Begin_Time).To_Equal(v_Begin_Time);
    Ut.Expect(v_Expected_Row.End_Time).To_Equal(v_End_Time);
    Ut.Expect(v_Expected_Row.Staff_Id).To_Equal(v_Staff_Id);
    Ut.Expect(v_Expected_Row.Request_Kind_Id).To_Equal(v_Request_Kind_Id);
    Ut.Expect(v_Expected_Row.Request_Type).To_Equal(v_Request_Type);
    Ut.Expect(v_Expected_Row.Status).To_Equal(v_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Request_Not_Exceed_Positive_Restriction_Days is
    v_Begin_Time   date := sysdate + 10 + 1;
    v_End_Time     date := sysdate + 10 + 1;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
    v_Request_Row  Htt_Requests%rowtype;
    v_Check_Row    Htt_Requests%rowtype;
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
    Htt_Api.Request_Save(i_Request => v_Request_Row);
    v_Check_Row := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Request_Id => g_Request_Id);
    Check_Htt_Requests_Row(v_Expected_Row    => v_Check_Row,
                           v_Begin_Time      => v_Begin_Time,
                           v_End_Time        => v_End_Time,
                           v_Staff_Id        => g_Staff_Id,
                           v_Request_Kind_Id => g_Request_Kind,
                           v_Request_Type    => v_Request_Type,
                           v_Status          => v_Status);
  
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Request_Exceed_Positive_Restriction_Days is
    v_Begin_Time   date := sysdate + 10 - 1;
    v_End_Time     date := sysdate + 10 - 1;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
    v_Request_Row  Htt_Requests%rowtype;
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
    Htt_Api.Request_Save(i_Request => v_Request_Row);
    Ut.Expect(z_Htt_Requests.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Request_Id => g_Request_Id)).To_Be_False();
  
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Request_Exceed_Negative_Restriction_Days is
    v_Begin_Time   date := sysdate - 10 - 1;
    v_End_Time     date := sysdate - 10 - 1;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
    v_Request_Row  Htt_Requests%rowtype;
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
    Htt_Api.Request_Save(i_Request => v_Request_Row);
    Ut.Expect(z_Htt_Requests.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Request_Id => g_Request_Id)).To_Be_False();
  
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Request_Not_Exceed_Negative_Restriction_Days is
    v_Begin_Time   date := sysdate - 10 + 1;
    v_End_Time     date := sysdate - 10 + 1;
    v_Request_Type varchar2(1) := Htt_Pref.c_Request_Type_Full_Day;
    v_Status       varchar2(1) := Htt_Pref.c_Request_Status_New;
    v_Barcode      varchar2(25) := Md_Core.Gen_Barcode(i_Table => Zt.Htt_Requests,
                                                       i_Id    => g_Request_Id);
    v_Request_Row  Htt_Requests%rowtype;
    v_Check_Row    Htt_Requests%rowtype;
  begin
    z_Htt_Requests.Init(p_Row             => v_Request_Row,
                        i_Company_Id      => Ui.Company_Id,
                        i_Filial_Id       => Ui.Filial_Id,
                        i_Request_Id      => g_Request_Id,
                        i_Request_Kind_Id => g_Request_Kind,
                        i_Staff_Id        => g_Staff_Id,
                        i_Begin_Time      => v_Begin_Time,
                        i_End_Time        => v_End_Time,
                        i_Request_Type    => v_Request_Type,
                        i_Manager_Note    => '',
                        i_Note            => '',
                        i_Status          => v_Status,
                        i_Barcode         => v_Barcode);
  
    Htt_Api.Request_Save(i_Request => v_Request_Row);
  
    v_Check_Row := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Request_Id => g_Request_Id);
    Check_Htt_Requests_Row(v_Expected_Row    => v_Check_Row,
                           v_Begin_Time      => v_Begin_Time,
                           v_End_Time        => v_End_Time,
                           v_Staff_Id        => g_Staff_Id,
                           v_Request_Kind_Id => g_Request_Kind,
                           v_Request_Type    => v_Request_Type,
                           v_Status          => v_Status);
  
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Check_Notify_Request is
    v_Request_Id number;
    v_Array      Arraylist;
    v_Hashmap    Hashmap;
    v_Count      number;
  begin
    v_Request_Id := Ut_Vhr_Util.Create_Request(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Staff_Id   => g_Staff_Id);
  
    Htt_Api.Notify_Staff_Request(i_Company_Id  => Ui.Company_Id,
                                 i_Filial_Id   => Ui.Filial_Id,
                                 i_Request_Id  => v_Request_Id,
                                 i_Notify_Type => Hes_Pref.c_Pref_Nt_Request);
  
    v_Array := Biruni_Service.Get_Final_Services;
  
    for i in 1 .. v_Array.Count
    loop
      v_Hashmap := Treat(v_Array.r_Hashmap(i) as Hashmap);
    
      if v_Hashmap.r_Varchar2('class_name') = g_Firebase_Service_Class then
        v_Count := v_Count + 1;
      end if;
    end loop;
  
    Ut.Expect(v_Array.Count).To_Equal(1);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Notify_Plan_Change is
    v_Change_Id number;
    v_Array     Arraylist;
    v_Hashmap   Hashmap;
    v_Count     number;
  begin
    v_Change_Id := Ut_Vhr_Util.Create_Plan_Change(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id,
                                                  i_Staff_Id   => g_Staff_Id);
  
    Htt_Api.Notify_Staff_Plan_Changes(i_Company_Id  => Ui.Company_Id,
                                      i_Filial_Id   => Ui.Filial_Id,
                                      i_Change_Id   => v_Change_Id,
                                      i_Notify_Type => Hes_Pref.c_Pref_Nt_Plan_Change);
  
    v_Array := Biruni_Service.Get_Final_Services;
  
    for i in 1 .. v_Array.Count
    loop
      v_Hashmap := Treat(v_Array.r_Hashmap(i) as Hashmap);
    
      if v_Hashmap.r_Varchar2('class_name') = g_Firebase_Service_Class then
        v_Count := v_Count + 1;
      end if;
    end loop;
  
    Ut.Expect(v_Count).To_Equal(1);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Update_Request_Kind_Positive is
  begin
    z_Htt_Request_Kinds.Update_One(i_Company_Id               => Ui.Company_Id,
                                   i_Request_Kind_Id          => g_Request_Kind,
                                   i_Request_Restriction_Days => Option_Number(10));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Request_Kind_Negative is
  begin
    z_Htt_Request_Kinds.Update_One(i_Company_Id               => Ui.Company_Id,
                                   i_Request_Kind_Id          => g_Request_Kind,
                                   i_Request_Restriction_Days => Option_Number(-10));
  end;

end Ut_Htt_Api;
/
