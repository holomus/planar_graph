create or replace package Hzk_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Fprints_New
  (
    o_Person_Fprints out Hzk_Pref.Person_Fprints_Rt,
    i_Company_Id     number,
    i_Person_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Fprints_Add_Fprint
  (
    p_Person_Fprints in out nocopy Hzk_Pref.Person_Fprints_Rt,
    i_Finger_No      number,
    i_Tmp            varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Function t_Command_State(i_Command_State varchar2) return varchar2;
  Function Command_States return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function t_Hand_Side(i_Hand_Side varchar2) return varchar2;
  Function Hand_Sides return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function t_Finger(i_Finger_No varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Attlog_Error_Status(i_Attlog_Error_Status varchar2) return varchar2;
  Function Attlog_Error_Status return Matrix_Varchar2;
end Hzk_Util;
/
create or replace package body Hzk_Util is
  ----------------------------------------------------------------------------------------------------  
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HZK:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Fprints_New
  (
    o_Person_Fprints out Hzk_Pref.Person_Fprints_Rt,
    i_Company_Id     number,
    i_Person_Id      number
  ) is
  begin
    o_Person_Fprints.Company_Id := i_Company_Id;
    o_Person_Fprints.Person_Id  := i_Person_Id;
  
    o_Person_Fprints.Fprints := Hzk_Pref.Fprint_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Fprints_Add_Fprint
  (
    p_Person_Fprints in out nocopy Hzk_Pref.Person_Fprints_Rt,
    i_Finger_No      number,
    i_Tmp            varchar2
  ) is
    v_Fprint Hzk_Pref.Fprint_Rt;
  begin
    v_Fprint.Finger_No := i_Finger_No;
    v_Fprint.Tmp       := i_Tmp;
  
    p_Person_Fprints.Fprints.Extend;
    p_Person_Fprints.Fprints(p_Person_Fprints.Fprints.Count) := v_Fprint;
  end;

  ----------------------------------------------------------------------------------------------------  
  -- command state
  ----------------------------------------------------------------------------------------------------  
  Function t_Cs_New return varchar2 is
  begin
    return t('command_state:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cs_Sent return varchar2 is
  begin
    return t('command_state:sent');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cs_Complete return varchar2 is
  begin
    return t('command_state:complete');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Command_State(i_Command_State varchar2) return varchar2 is
  begin
    return --
    case i_Command_State --
    when Hzk_Pref.c_Cs_New then t_Cs_New --
    when Hzk_Pref.c_Cs_Sent then t_Cs_Sent --
    when Hzk_Pref.c_Cs_Complete then t_Cs_Complete --
    end;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Command_States return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hzk_Pref.c_Cs_New,
                                          Hzk_Pref.c_Cs_Sent,
                                          Hzk_Pref.c_Cs_Complete),
                           Array_Varchar2(t_Cs_New, -- 
                                          t_Cs_Sent, --
                                          t_Cs_Complete));
  end;

  ----------------------------------------------------------------------------------------------------  
  -- hand side
  ----------------------------------------------------------------------------------------------------  
  Function t_Hand_Side_Left return varchar2 is
  begin
    return t('hand_side: left');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Hand_Side_Right return varchar2 is
  begin
    return t('hand_side: right');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Hand_Side(i_Hand_Side varchar2) return varchar2 is
  begin
    return --
    case i_Hand_Side --
    when Hzk_Pref.c_Hand_Side_Left then t_Hand_Side_Left --
    when Hzk_Pref.c_Hand_Side_Right then t_Hand_Side_Right --
    end;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Hand_Sides return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hzk_Pref.c_Hand_Side_Left, Hzk_Pref.c_Hand_Side_Right),
                           Array_Varchar2(t_Hand_Side_Left, -- 
                                          t_Hand_Side_Right));
  end;

  ----------------------------------------------------------------------------------------------------
  -- finger
  ----------------------------------------------------------------------------------------------------
  Function t_Finger_No_0 return varchar2 is
  begin
    return t('finger: little finger');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Finger_No_1 return varchar2 is
  begin
    return t('finger: ring finger');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Finger_No_2 return varchar2 is
  begin
    return t('finger: middle finger');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Finger_No_3 return varchar2 is
  begin
    return t('finger: index finger');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Finger_No_4 return varchar2 is
  begin
    return t('finger: thumb');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Finger(i_Finger_No varchar2) return varchar2 is
  begin
    return --
    case i_Finger_No --
    when 0 then t_Finger_No_0 --
    when 1 then t_Finger_No_1 --
    when 2 then t_Finger_No_2 --
    when 3 then t_Finger_No_3 --
    when 4 then t_Finger_No_4 --
    when 5 then t_Finger_No_4 --
    when 6 then t_Finger_No_3 --
    when 7 then t_Finger_No_2 --
    when 8 then t_Finger_No_1 --
    when 9 then t_Finger_No_0 --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attlog_Error_Status_New return varchar2 is
  begin
    return t('attlog_error_status: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attlog_Error_Status_Done return varchar2 is
  begin
    return t('attlog_error_status: done');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attlog_Error_Status(i_Attlog_Error_Status varchar2) return varchar2 is
  begin
    return --
    case i_Attlog_Error_Status --
    when Hzk_Pref.c_Attlog_Error_Status_New then t_Attlog_Error_Status_New --
    when Hzk_Pref.c_Attlog_Error_Status_Done then t_Attlog_Error_Status_Done --
    end;
  end;
  
  ---------------------------------------------------------------------------------------------------- 
  Function Attlog_Error_Status return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hzk_Pref.c_Attlog_Error_Status_New,
                                          Hzk_Pref.c_Attlog_Error_Status_Done),
                           Array_Varchar2(t_Attlog_Error_Status_New, -- 
                                          t_Attlog_Error_Status_Done));
  end;

end Hzk_Util;
/
