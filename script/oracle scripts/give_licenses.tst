PL/SQL Developer Test script 3.0
26
-- Created on 30.08.2022 by SANJAR 
declare
  -- Local variables here
  v_Company_Id number := 102;

  v_Begin_Date date := Trunc(sysdate, 'mon') - 40;
  v_End_Date   date := Last_Day(Trunc(sysdate)) + 40;

  v_Lic_Cnt  number := 15;
  v_Lic_Hash varchar2(64) := Kauth_Util.Gen_Auth_Code(i_Company_Id   => v_Company_Id,
                                                      i_Auth_Code_Id => Kl_Next.License_Id);
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  Biruni_Route.Context_Begin;
  Kl_Api.License_Create(i_Company_Id    => v_Company_Id,
                        i_License_Code  => Hlic_Pref.c_License_Code_Hrm_Base,
                        i_Begin_Date    => v_Begin_Date,
                        i_End_Date      => v_End_Date,
                        i_Quant         => v_Lic_Cnt,
                        i_Hashcode      => v_Lic_Hash,
                        i_Serial_Number => null,
                        i_Note          => 'VERIFIX HAND CREATED');
  Biruni_Route.Context_End;
  commit;
end;
0
0
