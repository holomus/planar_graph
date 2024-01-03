create or replace package Ui_Vhr603 is
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Filial return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr603;
/
create or replace package body Ui_Vhr603 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr603:settings';

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
    return b.Translate('UI-VHR603:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate)));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Filial return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_filials', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('filial_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Report
  (
    i_Filial_Ids     Array_Number,
    i_Date_Filter_On varchar2,
    i_Begin_Date     date,
    i_End_Date       date
  ) is
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Count   number := i_Filial_Ids.Count;
    v_Order_No       number := 1;
    v_Transactions   Matrix_Varchar2;
    v_Current_Date   date := Trunc(sysdate);
    v_Dismissal_Date date;
    a                b_Table := b_Report.New_Table();
  
    --------------------------------------------------
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Filial     boolean := Nvl(v_Settings.o_Varchar2('filial'), 'Y') = 'Y';
    v_Show_Manager    boolean := Nvl(v_Settings.o_Varchar2('manager'), 'Y') = 'Y';
    v_Show_Robot      boolean := Nvl(v_Settings.o_Varchar2('robot'), 'Y') = 'Y';
    v_Show_Job        boolean := Nvl(v_Settings.o_Varchar2('job'), 'Y') = 'Y';
    v_Show_Main_Phone boolean := Nvl(v_Settings.o_Varchar2('main_phone'), 'Y') = 'Y';
    v_Show_Status     boolean := Nvl(v_Settings.o_Varchar2('status'), 'Y') = 'Y';
  
    -------------------------------------------------- 
    Procedure Print_Info is
      v_Limit   number := 5;
      v_Colspan number := 5;
      t_Other   varchar2(20) := t('... others');
      v_Names   Array_Varchar2 := Array_Varchar2();
    begin
      a.New_Row;
    
      if v_Filial_Count > 0 then
        a.New_Row;
      
        v_Limit := Least(v_Limit, v_Filial_Count);
        v_Names := Array_Varchar2();
        v_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Names(i) := z_Md_Filials.Load(i_Company_Id => v_Company_Id, i_Filial_Id => i_Filial_Ids(i)).Name;
        end loop;
      
        if v_Filial_Count > v_Limit then
          Fazo.Push(v_Names, t_Other);
        end if;
      
        a.Data(t('filails: $1{filials_names}', Fazo.Gather(v_Names, ',')), i_Colspan => v_Colspan);
      end if;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Header is
      v_Colspan number;
      v_Matrix  Matrix_Varchar2 := Matrix_Varchar2();
    begin
      Fazo.Push(v_Matrix, Array_Varchar2(t('order no'), 100, 1));
    
      if v_Show_Filial then
        Fazo.Push(v_Matrix, Array_Varchar2(t('filial id'), 100, 1));
        Fazo.Push(v_Matrix, Array_Varchar2(t('filial name'), 250, 1));
      end if;
    
      if v_Show_Manager then
        Fazo.Push(v_Matrix, Array_Varchar2(t('manger id'), 100, 1));
        Fazo.Push(v_Matrix, Array_Varchar2(t('manager name'), 250, 1));
      end if;
    
      Fazo.Push(v_Matrix, Array_Varchar2(t('user id'), 100, 1));
      Fazo.Push(v_Matrix, Array_Varchar2(t('user name'), 250, 1));
    
      if v_Show_Robot then
        Fazo.Push(v_Matrix, Array_Varchar2(t('robot id'), 100, 1));
        Fazo.Push(v_Matrix, Array_Varchar2(t('robot name'), 250, 1));
      end if;
    
      if v_Show_Job then
        Fazo.Push(v_Matrix, Array_Varchar2(t('job name'), 250, 1));
      end if;
    
      if v_Show_Main_Phone then
        Fazo.Push(v_Matrix, Array_Varchar2(t('main phone'), 250, 1));
      end if;
    
      Fazo.Push(v_Matrix, Array_Varchar2(t('npin'), 250, 1));
    
      if v_Show_Status then
        Fazo.Push(v_Matrix, Array_Varchar2(t('status'), 250, 1));
      end if;
    
      Fazo.Push(v_Matrix, Array_Varchar2(t('history'), 300, 2));
    
      --
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      for i in 1 .. v_Matrix.Count
      loop
        v_Colspan := v_Matrix(i) (3);
        a.Data(i_Val => v_Matrix(i) (1), i_Colspan => v_Colspan);
        a.Column_Width(i, v_Matrix(i) (2));
      end loop;
    end;
  
    --------------------------------------------------
    Function Cache_Staff_Transactions
    (
      i_Filial_Id number,
      i_Staff_Id  number
    ) return Matrix_Varchar2 is
      v_Matrix Matrix_Varchar2;
    begin
      select Array_Varchar2(Mix.Begin_Date,
                            Hpd_Util.t_Journal_Type(Uit_Hpd.Get_Journal_Type(j.Journal_Type_Id)))
        bulk collect
        into v_Matrix
        from (select Tr.Company_Id, Tr.Filial_Id, Tr.Begin_Date, Tr.Order_No, Tr.Journal_Id
                from Hpd_Transactions Tr
               where Tr.Company_Id = v_Company_Id
                 and Tr.Filial_Id = i_Filial_Id
                 and Tr.Staff_Id = i_Staff_Id
                 and Tr.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
              union
              select Dt.Company_Id,
                     Dt.Filial_Id,
                     Dt.Dismissal_Date - 1 Begin_Date,
                     null Order_No,
                     Dt.Journal_Id
                from Hpd_Dismissal_Transactions Dt
                join Hpd_Dismissals p
                  on p.Company_Id = Dt.Company_Id
                 and p.Filial_Id = Dt.Filial_Id
                 and p.Page_Id = Dt.Page_Id
               where Dt.Company_Id = v_Company_Id
                 and Dt.Filial_Id = i_Filial_Id
                 and Dt.Staff_Id = i_Staff_Id) Mix
        join Hpd_Journals j
          on j.Company_Id = Mix.Company_Id
         and j.Filial_Id = Mix.Filial_Id
         and j.Journal_Id = Mix.Journal_Id
       order by Mix.Begin_Date;
    
      return v_Matrix;
    end;
  begin
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
    if i_Date_Filter_On = 'Y' then
      v_Current_Date   := i_End_Date;
      v_Dismissal_Date := i_Begin_Date;
    end if;
  
    -- body  
    for r in (select Qr.*,
                     (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = v_Company_Id
                         and Np.Person_Id = Qr.Manager_Id) Manager_Name
                from (select q.Filial_Id,
                             q.Name Filial_Name,
                             (select Rb.Person_Id
                                from Mrf_Robots Rb
                               where Rb.Company_Id = q.Company_Id
                                 and Rb.Filial_Id = q.Filial_Id
                                 and Rb.Robot_Id =
                                     (select case
                                               when Dm.Manager_Id <> s.Robot_Id then
                                                Dm.Manager_Id
                                               else
                                                (select Md.Manager_Id
                                                   from Mhr_Parent_Divisions Pd
                                                   join Mrf_Division_Managers Md
                                                     on Md.Company_Id = Pd.Company_Id
                                                    and Md.Filial_Id = Pd.Filial_Id
                                                    and Md.Division_Id = Pd.Parent_Id
                                                  where Pd.Company_Id = Dm.Company_Id
                                                    and Pd.Filial_Id = Dm.Filial_Id
                                                    and Pd.Division_Id = Dm.Division_Id
                                                    and Pd.Lvl = 1)
                                             end
                                        from Mrf_Division_Managers Dm
                                       where Dm.Company_Id = q.Company_Id
                                         and Dm.Filial_Id = q.Filial_Id
                                         and Dm.Division_Id = m.Org_Unit_Id)) Manager_Id,
                             s.Employee_Id,
                             s.Staff_Id,
                             (select Np.Name
                                from Mr_Natural_Persons Np
                               where Np.Company_Id = s.Company_Id
                                 and Np.Person_Id = s.Employee_Id) Employee_Name,
                             m.Robot_Id,
                             (select Rb.Name
                                from Mrf_Robots Rb
                               where Rb.Company_Id = m.Company_Id
                                 and Rb.Filial_Id = m.Filial_Id
                                 and Rb.Robot_Id = m.Robot_Id) Robot_Name,
                             (select j.Name
                                from Mhr_Jobs j
                               where j.Company_Id = s.Company_Id
                                 and j.Filial_Id = s.Filial_Id
                                 and j.Job_Id = s.Job_Id) Job_Name,
                             (select Mpd.Main_Phone
                                from Mr_Person_Details Mpd
                               where Mpd.Company_Id = s.Company_Id
                                 and Mpd.Person_Id = s.Employee_Id) Main_Phone,
                             (select Pd.Npin
                                from Href_Person_Details Pd
                               where Pd.Company_Id = s.Company_Id
                                 and Pd.Person_Id = s.Employee_Id) Npin,
                             Href_Util.t_Staff_Status(Uit_Href.Get_Staff_Status(s.Hiring_Date,
                                                                                s.Dismissal_Date,
                                                                                v_Current_Date)) as Status_Name
                        from Href_Staffs s
                        join Md_Filials q
                          on q.Company_Id = s.Company_Id
                         and q.Filial_Id = s.Filial_Id
                        join Hrm_Robots m
                          on m.Company_Id = s.Company_Id
                         and m.Filial_Id = s.Filial_Id
                         and m.Robot_Id = s.Robot_Id
                       where s.Company_Id = v_Company_Id
                         and (v_Filial_Count = 0 or q.Filial_Id member of i_Filial_Ids)
                         and s.State = 'A'
                         and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                         and s.Hiring_Date <= v_Current_Date
                         and (i_Date_Filter_On = 'Y' and
                             (s.Dismissal_Date is null or s.Dismissal_Date >= v_Dismissal_Date) or
                             i_Date_Filter_On = 'N')
                       order by Lower(q.Name)) Qr)
    loop
      v_Transactions := Cache_Staff_Transactions(i_Filial_Id => r.Filial_Id,
                                                 i_Staff_Id  => r.Staff_Id);
    
      if mod(v_Order_No, 2) = 0 then
        a.Current_Style('hover');
      else
        a.Current_Style('body_centralized');
      end if;
    
      a.New_Row;
      a.Data(i_Val => v_Order_No, i_Rowspan => v_Transactions.Count);
    
      v_Order_No := v_Order_No + 1;
    
      if v_Show_Filial then
        a.Data(i_Val => r.Filial_Id, i_Rowspan => v_Transactions.Count);
        a.Data(i_Val => r.Filial_Name, i_Rowspan => v_Transactions.Count);
      end if;
    
      if v_Show_Manager then
        a.Data(i_Val => r.Manager_Id, i_Rowspan => v_Transactions.Count);
        a.Data(i_Val => r.Manager_Name, i_Rowspan => v_Transactions.Count);
      end if;
    
      a.Data(i_Val => r.Employee_Id, i_Rowspan => v_Transactions.Count);
      a.Data(i_Val => r.Employee_Name, i_Rowspan => v_Transactions.Count);
    
      if v_Show_Robot then
        a.Data(i_Val => r.Robot_Id, i_Rowspan => v_Transactions.Count);
        a.Data(i_Val => r.Robot_Name, i_Rowspan => v_Transactions.Count);
      end if;
    
      if v_Show_Job then
        a.Data(i_Val => r.Job_Name, i_Rowspan => v_Transactions.Count);
      end if;
    
      if v_Show_Main_Phone then
        a.Data(i_Val => r.Main_Phone, i_Rowspan => v_Transactions.Count);
      end if;
    
      a.Data(i_Val => r.Npin, i_Rowspan => v_Transactions.Count);
    
      if v_Show_Status then
        a.Data(i_Val => r.Status_Name, i_Rowspan => v_Transactions.Count);
      end if;
    
      for Tr in 1 .. v_Transactions.Count
      loop
        for Mt in 1 .. v_Transactions(Tr).Count
        loop
          a.Data(v_Transactions(Tr) (Mt));
        end loop;
      
        if Tr < v_Transactions.Count then
          a.New_Row;
        end if;
      end loop;
    end loop;
  
    b_Report.Add_Sheet(i_Name => t('employees with ids'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Filial_Ids     Array_Number := Nvl(p.o_Array_Number('filial_ids'), Array_Number());
    v_Date_Filter_On varchar2(1) := Nvl(p.o_Varchar2('date_filter_on'), 'N');
    v_Begin_Date     date := p.r_Date('begin_date');
    v_End_Date       date := p.r_Date('end_date');
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    -- hover
    b_Report.New_Style(i_Style_Name        => 'hover',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#d7d7d7',
                       i_Font_Bold         => false);
  
    Run_Report(i_Filial_Ids     => v_Filial_Ids,
               i_Date_Filter_On => v_Date_Filter_On,
               i_Begin_Date     => v_Begin_Date,
               i_End_Date       => v_End_Date);
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  
  begin
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
  end;
end Ui_Vhr603;
/
