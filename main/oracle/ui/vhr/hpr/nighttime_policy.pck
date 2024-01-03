create or replace package Ui_Vhr648 is
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr648;
/
create or replace package body Ui_Vhr648 is
  ----------------------------------------------------------------------------------------------------  
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put_All(References);
    Result.Put('data', Fazo.Zip_Map('state', 'A'));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    v_Matrix Matrix_Varchar2;
    r_Policy Hpr_Nighttime_Policies%rowtype;
    v_Data   Hashmap;
    result   Hashmap := Hashmap();
  begin
    r_Policy := z_Hpr_Nighttime_Policies.Load(i_Company_Id          => Ui.Company_Id,
                                              i_Filial_Id           => Ui.Filial_Id,
                                              i_Nighttime_Policy_Id => p.r_Number('nighttime_policy_id'));
  
    v_Data := z_Hpr_Nighttime_Policies.To_Map(r_Policy,
                                              z.Nighttime_Policy_Id,
                                              z.Name,
                                              z.Division_Id,
                                              z.State);
  
    v_Data.Put('month', to_char(r_Policy.Month, Href_Pref.c_Date_Format_Month));
    v_Data.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Policy.Company_Id, i_Filial_Id => r_Policy.Filial_Id, i_Division_Id => r_Policy.Division_Id).Name);
  
    select Array_Varchar2(q.Begin_Time, q.End_Time, q.Nighttime_Coef)
      bulk collect
      into v_Matrix
      from Hpr_Nighttime_Rules q
     where q.Company_Id = r_Policy.Company_Id
       and q.Filial_Id = r_Policy.Filial_Id
       and q.Nighttime_Policy_Id = r_Policy.Nighttime_Policy_Id
     order by q.Begin_Time;
  
    v_Data.Put('rules', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('data', v_Data);
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Policy Hpr_Pref.Nighttime_Policy_Rt,
    p        Hashmap
  ) is
    v_Policy Hpr_Pref.Nighttime_Policy_Rt := i_Policy;
    v_Rule   Hashmap;
    v_Rules  Arraylist := Nvl(p.r_Arraylist('rules'), Arraylist());
  begin
    for i in 1 .. v_Rules.Count
    loop
      v_Rule := Treat(v_Rules.r_Hashmap(i) as Hashmap);
    
      Hpr_Util.Nigthtime_Add_Rule(o_Nigthtime_Policy => v_Policy,
                                  i_Begin_Time       => v_Rule.r_Varchar2('begin_time'),
                                  i_End_Time         => v_Rule.r_Varchar2('end_time'),
                                  i_Nighttime_Coef   => v_Rule.r_Varchar2('nighttime_coef'));
    end loop;
  
    Hpr_Api.Nighttime_Policy_Save(v_Policy);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Policy       Hpr_Pref.Nighttime_Policy_Rt;
  begin
    Hpr_Util.Nigthtime_Policy_New(o_Nigthtime_Policy    => v_Policy,
                                  i_Company_Id          => Ui.Company_Id,
                                  i_Filial_Id           => Ui.Filial_Id,
                                  i_Nigthtime_Policy_Id => null,
                                  i_Month               => p.r_Date('month',
                                                                    Href_Pref.c_Date_Format_Month),
                                  i_Name                => p.o_Varchar2('name'),
                                  i_Division_Id         => null,
                                  i_State               => p.r_Varchar2('state'));
  
    if v_Division_Ids.Count > 0 then
      for i in 1 .. v_Division_Ids.Count
      loop
        v_Policy.Nigthttime_Policy_Id := Hpr_Next.Nighttime_Policy_Id;
        v_Policy.Division_Id          := v_Division_Ids(i);
      
        save(v_Policy, p);
      end loop;
    else
      v_Policy.Nigthttime_Policy_Id := Hpr_Next.Nighttime_Policy_Id;
    
      save(v_Policy, p);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    v_Policy Hpr_Pref.Nighttime_Policy_Rt;
  begin
    Hpr_Util.Nigthtime_Policy_New(o_Nigthtime_Policy    => v_Policy,
                                  i_Company_Id          => Ui.Company_Id,
                                  i_Filial_Id           => Ui.Filial_Id,
                                  i_Nigthtime_Policy_Id => p.r_Number('nighttime_policy_id'),
                                  i_Month               => p.r_Date('month',
                                                                    Href_Pref.c_Date_Format_Month),
                                  i_Name                => p.o_Varchar2('name'),
                                  i_Division_Id         => p.o_Number('division_id'),
                                  i_State               => p.r_Varchar2('state'));
  
    save(v_Policy, p);
  end;
end Ui_Vhr648;
/
