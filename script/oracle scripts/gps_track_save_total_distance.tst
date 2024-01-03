PL/SQL Developer Test script 3.0
37
-- Created on 8/3/2022 by ADHAM 
declare
  v_Total_Distance number;
  v_Company_Id     number := 463;
begin
  for r in (select q.Company_Id, q.Filial_Id
              from Md_Filials q
             where q.Company_Id = v_Company_Id
               and q.Filial_Id <> Md_Pref.Filial_Head(v_Company_Id)
               and q.State = 'A')
  loop
    Ui_Context.Init(i_User_Id      => Md_Pref.User_System(v_Company_Id),
                    i_Filial_Id    => r.Filial_Id,
                    i_Project_Code => Verifix.Project_Code);
  
    for Gt in (select q.Track_Id, q.Person_Id, q.Track_Date
                 from Htt_Gps_Tracks q
                where q.Company_Id = r.Company_Id
                  and q.Filial_Id = r.Filial_Id
                  and q.Calculated = 'N')
    loop
    
      v_Total_Distance := Htt_Util.Calc_Gps_Track_Distance(i_Company_Id => r.Company_Id,
                                                           i_Filial_Id  => r.Filial_Id,
                                                           i_Person_Id  => Gt.Person_Id,
                                                           i_Track_Date => Gt.Track_Date);
    
      z_Htt_Gps_Tracks.Update_One(i_Company_Id     => r.Company_Id,
                                  i_Filial_Id      => r.Filial_Id,
                                  i_Track_Id       => Gt.Track_Id,
                                  i_Total_Distance => Option_Number(v_Total_Distance),
                                  i_Calculated     => Option_Varchar2('Y'));
    
      commit;
    end loop;
  end loop;
end;
0
0
