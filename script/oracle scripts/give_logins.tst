PL/SQL Developer Test script 3.0
53
-- Created on 9/26/2022 by ADHAM 
declare
  v_Company_Id number := 680;

  r_User Md_Users%rowtype;

  v_Possible_Logins Array_Varchar2;
begin
  -- Test statements here
  Ui_Auth.Logon_As_System(v_Company_Id);
  Biruni_Route.Context_Begin;

  for r in (select p.*, Np.First_Name, Np.Last_Name
              from Md_Users p
              join Mr_Natural_Persons Np
                on Np.Company_Id = p.Company_Id
               and Np.Person_Id = p.User_Id
             where p.Company_Id = v_Company_Id
               and p.Login is null)
  loop
    z_Md_Users.Init(p_Row                      => r_User,
                    i_Company_Id               => r.Company_Id,
                    i_User_Id                  => r.User_Id,
                    i_Name                     => r.Name,
                    i_Login                    => r.Login,
                    i_Password                 => r.Password,
                    i_State                    => r.State,
                    i_User_Kind                => r.User_Kind,
                    i_Gender                   => r.Gender,
                    i_Manager_Id               => r.Manager_Id,
                    i_Timezone_Code            => r.Timezone_Code,
                    i_Password_Changed_On      => r.Password_Changed_On,
                    i_Password_Change_Required => r.Password_Change_Required,
                    i_Order_No                 => r.Order_No);
  
    v_Possible_Logins := Md_Util.Gen_Login(i_Company_Id => r.Company_Id,
                                           i_First_Name => r.First_Name,
                                           i_Last_Name  => r.Last_Name);
  
    for i in 1 .. v_Possible_Logins.Count
    loop
      v_Possible_Logins(i) := Md_Util.Login_Fixer(v_Possible_Logins(i));
    end loop;
  
    r_User.Login                    := v_Possible_Logins(1);
    r_User.Password                 := Fazo.Hash_Sha1(1);
    r_User.Password_Change_Required := 'Y';
    r_User.Password_Changed_On      := Current_Date;
  
    Md_Api.User_Save(r_User);
  end loop;
  Biruni_Route.Context_End;
end;
0
0
