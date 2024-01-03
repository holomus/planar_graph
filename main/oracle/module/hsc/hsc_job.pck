create or replace package Hsc_Job is
  ----------------------------------------------------------------------------------------------------
  Procedure Ftp_File_Load_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Ftp_File_Load_Response_Procedure(i_Input Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Weekly_Predict_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Monthly_Predict_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Quarterly_Predict_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Yearly_Predict_Request_Procedure(o_Output out Array_Varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Object_Facts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Predict_Type varchar2,
    o_Facts        out Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Object_Facts
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Data       Array_Varchar2
  );
end Hsc_Job;
/
create or replace package body Hsc_Job is
  ---------------------------------------------------------------------------------------------------- 
  c_Xlsx_File_Extension constant varchar2(5) := '.xlsx';
  ---------------------------------------------------------------------------------------------------- 
  c_Train_Begin constant date := to_date('01.01.2016', 'dd.mm.yyyy');

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Error_Log
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Error_Log  varchar2
  ) is
    pragma autonomous_transaction;
  begin
    z_Hsc_Job_Error_Log.Save_One(i_Log_Id     => Hsc_Job_Error_Log_Sq.Nextval,
                                 i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Error_Log  => i_Error_Log);
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Last_Ftp_Date
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Last_Fact_Date date
  ) is
    r_Settings Hsc_Server_Settings%rowtype;
  begin
    if i_Last_Fact_Date is null then
      return;
    end if;
  
    r_Settings := z_Hsc_Server_Settings.Load(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id);
  
    if r_Settings.Last_Ftp_File_Date is null or r_Settings.Last_Ftp_File_Date < i_Last_Fact_Date then
      z_Hsc_Server_Settings.Update_One(i_Company_Id         => i_Company_Id,
                                       i_Filial_Id          => i_Filial_Id,
                                       i_Last_Ftp_File_Date => Option_Date(i_Last_Fact_Date));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Ftp_File_Load_Request_Procedure(o_Output out Array_Varchar2) is
    v_Filenames Array_Varchar2;
  
    v_Last_Ftp_File_Date date;
    v_Current_Date       date := Trunc(sysdate);
    v_Max_Ftp_Load_Date  date := v_Current_Date - 40;
  
    v_Detail_Map  Hashmap;
    v_Data_Map    Hashmap;
    v_Filial_Data Hashmap := Hashmap;
    result        Arraylist := Arraylist;
    Writer        Stream := Stream;
  begin
    for Cmp in (select *
                  from Md_Companies t
                 where t.State = 'A'
                   and exists (select 1
                          from Hsc_Server_Settings St
                         where St.Company_Id = t.Company_Id))
    loop
      for f in (select St.Company_Id,
                       St.Filial_Id,
                       St.Ftp_Server_Url,
                       St.Ftp_Username,
                       St.Ftp_Password,
                       St.Predict_Server_Url,
                       St.Last_Ftp_File_Date
                  from Md_Filials w
                  join Hsc_Server_Settings St
                    on St.Company_Id = w.Company_Id
                   and St.Filial_Id = w.Filial_Id
                 where w.Company_Id = Cmp.Company_Id
                   and w.State = 'A')
      loop
        v_Data_Map    := Hashmap;
        v_Filial_Data := Hashmap;
      
        v_Detail_Map := Fazo.Zip_Map('server_url',
                                     f.Ftp_Server_Url,
                                     'username',
                                     f.Ftp_Username,
                                     'password',
                                     f.Ftp_Password,
                                     'company_id',
                                     f.Company_Id,
                                     'filial_id',
                                     f.Filial_Id);
      
        v_Last_Ftp_File_Date := Nvl(Greatest(f.Last_Ftp_File_Date + 1, v_Max_Ftp_Load_Date),
                                    v_Max_Ftp_Load_Date);
      
        v_Filenames := Array_Varchar2();
      
        while v_Last_Ftp_File_Date <= v_Current_Date
        loop
          Fazo.Push(v_Filenames,
                    to_char(v_Last_Ftp_File_Date, 'yyyy-mm-dd') || c_Xlsx_File_Extension);
        
          v_Last_Ftp_File_Date := v_Last_Ftp_File_Date + 1;
        end loop;
      
        v_Data_Map.Put('filenames', v_Filenames);
      
        v_Filial_Data.Put('detail', v_Detail_Map);
        v_Filial_Data.Put('request_data', v_Data_Map);
      
        Result.Push(v_Filial_Data);
      end loop;
    end loop;
  
    Result.Print_Json(Writer);
  
    o_Output := Writer.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Ftp_File_Load_Response_Procedure(i_Input Array_Varchar2) is
    v_Input       Glist := Glist(Json_Array_t.Parse(Fazo.Make_Clob(i_Input)));
    v_Result_Data Gmap := Gmap;
    v_Review_Data Gmap := Gmap;
    v_Files       Glist;
  
    v_Excel_File   Array_Varchar2;
    v_Excel_Sheets Arraylist;
  
    v_Data Hashmap;
  
    v_Errors_Data Hashmap;
    v_Errors      Arraylist;
  
    v_Company_Id number;
    v_Filial_Id  number;
  begin
    for i in 1 .. v_Input.Count
    loop
      Dbms_Session.Reset_Package;
    
      Biruni_Route.Context_Begin;
    
      begin
        v_Result_Data.Val := v_Input.r_Gmap(i);
      
        v_Review_Data := v_Result_Data.r_Gmap('review_data');
        v_Files       := v_Result_Data.r_Glist('files');
      
        v_Company_Id := v_Review_Data.r_Varchar2('company_id');
        v_Filial_Id  := v_Review_Data.r_Varchar2('filial_id');
      
        Ui_Context.Init(i_User_Id      => Md_Pref.User_System(v_Company_Id),
                        i_Project_Code => Verifix.Project_Code,
                        i_Filial_Id    => v_Filial_Id);
      
        v_Data := Hashmap();
      
        for j in 1 .. v_Files.Count
        loop
          v_Excel_File := v_Files.r_Array_Varchar2(j);
        
          v_Excel_Sheets := Fazo.Parse_Array(v_Excel_File);
        
          v_Data.Put('import_file', v_Excel_Sheets);
        
          v_Errors_Data := Hsc_Facts.Import_File(i_Company_Id => v_Company_Id,
                                                 i_Filial_Id  => v_Filial_Id,
                                                 i_Data       => v_Data);
        
          v_Errors := v_Errors_Data.r_Arraylist('errors');
        
          Save_Error_Log(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Error_Log  => v_Errors.Json);
        
          Update_Last_Ftp_Date(i_Company_Id     => v_Company_Id,
                               i_Filial_Id      => v_Filial_Id,
                               i_Last_Fact_Date => v_Errors_Data.o_Date('max_fact_date'));
        end loop;
      exception
        when others then
          Save_Error_Log(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Error_Log  => Dbms_Utility.Format_Error_Stack || ' ' ||
                                         Dbms_Utility.Format_Error_Backtrace);
      end;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Predict_Request_Procedure
  (
    o_Output       out Array_Varchar2,
    i_Predict_Type varchar2
  ) is
    v_Object_Ids Array_Number;
  
    v_Detail_Map  Hashmap;
    v_Filial_Data Hashmap := Hashmap;
    result        Arraylist := Arraylist;
    Writer        Stream := Stream;
  begin
    for f in (select t.*, w.Filial_Id, St.Predict_Server_Url
                from Md_Companies t
                join Md_Filials w
                  on w.Company_Id = t.Company_Id
                 and w.State = 'A'
                join Hsc_Server_Settings St
                  on St.Company_Id = w.Company_Id
                 and St.Filial_Id = w.Filial_Id
               where t.State = 'A'
                 and exists (select 1
                        from Hsc_Objects p
                       where p.Company_Id = w.Company_Id
                         and p.Filial_Id = w.Filial_Id)
                 and not exists (select 1
                        from Hsc_Driver_Facts Df
                       where Df.Company_Id = w.Company_Id
                         and Df.Filial_Id = w.Filial_Id
                         and Df.Fact_Type = i_Predict_Type
                         and Df.Fact_Date > Trunc(sysdate)))
    loop
      v_Filial_Data := Fazo.Zip_Map('company_id',
                                    f.Company_Id,
                                    'filial_id',
                                    f.Filial_Id,
                                    'predict_type',
                                    i_Predict_Type);
    
      v_Detail_Map := Fazo.Zip_Map('host_url',
                                   Nvl(f.Predict_Server_Url, Hsc_Pref.c_Predict_Server_Url),
                                   'method',
                                   Hsc_Pref.c_Default_Http_Method,
                                   'api_uri',
                                   Hsc_Pref.c_Predict_Api_Uri);
    
      select q.Object_Id
        bulk collect
        into v_Object_Ids
        from Hsc_Objects q
       where q.Company_Id = f.Company_Id
         and q.Filial_Id = f.Filial_Id
         and exists (select 1
                from Mhr_Divisions p
               where p.Company_Id = q.Company_Id
                 and p.Filial_Id = q.Filial_Id
                 and p.Division_Id = q.Object_Id);
    
      v_Filial_Data.Put('detail', v_Detail_Map);
      v_Filial_Data.Put('object_ids', v_Object_Ids);
    
      Result.Push(v_Filial_Data);
    end loop;
  
    Result.Print_Json(Writer);
  
    o_Output := Writer.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Weekly_Predict_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Predict_Request_Procedure(o_Output       => o_Output,
                              i_Predict_Type => Hsc_Pref.c_Fact_Type_Weekly_Predict);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Monthly_Predict_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Predict_Request_Procedure(o_Output       => o_Output,
                              i_Predict_Type => Hsc_Pref.c_Fact_Type_Montly_Predict);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Quarterly_Predict_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Predict_Request_Procedure(o_Output       => o_Output,
                              i_Predict_Type => Hsc_Pref.c_Fact_Type_Quarterly_Predict);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Yearly_Predict_Request_Procedure(o_Output out Array_Varchar2) is
  begin
    Predict_Request_Procedure(o_Output       => o_Output,
                              i_Predict_Type => Hsc_Pref.c_Fact_Type_Yearly_Predict);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Object_Facts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Object_Id    number,
    i_Predict_Type varchar2,
    o_Facts        out Array_Varchar2
  ) is
    v_Train_End     date;
    v_Predict_Begin date;
    v_Predict_End   date;
  
    v_Category   Gmap;
    v_Categories Glist := Glist();
  
    v_Data Gmap := Gmap();
  begin
    v_Train_End := case i_Predict_Type
                     when Hsc_Pref.c_Fact_Type_Weekly_Predict then
                      Trunc(sysdate, 'iw')
                     when Hsc_Pref.c_Fact_Type_Montly_Predict then
                      Trunc(sysdate, 'mon')
                     when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
                      Trunc(sysdate, 'q')
                     else
                      Trunc(sysdate, 'year')
                   end;
  
    v_Train_End := v_Train_End - 1;
  
    v_Predict_Begin := v_Train_End + 1;
    v_Predict_End   := case i_Predict_Type
                         when Hsc_Pref.c_Fact_Type_Weekly_Predict then
                          v_Predict_Begin + 7
                         when Hsc_Pref.c_Fact_Type_Montly_Predict then
                          Last_Day(v_Predict_Begin)
                         when Hsc_Pref.c_Fact_Type_Quarterly_Predict then
                          Htt_Util.Quarter_Last_Day(v_Predict_Begin)
                         else
                          Htt_Util.Year_Last_Day(v_Predict_Begin)
                       end;
  
    for r in (select Df.Area_Id,
                     Df.Driver_Id,
                     Json_Arrayagg(Json_Object('fact_date' value to_char(Df.Fact_Date, 'yyyy-mm-dd'),
                                               'fact_value' value Df.Fact_Value) returning clob) Facts
                from Hsc_Driver_Facts Df
               where Df.Company_Id = i_Company_Id
                 and Df.Filial_Id = i_Filial_Id
                 and Df.Object_Id = i_Object_Id
                 and Df.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
                 and Df.Fact_Date between c_Train_Begin and v_Train_End
                 and not exists (select 1
                        from Hsc_Driver_Facts f
                       where f.Company_Id = Df.Company_Id
                         and f.Filial_Id = Df.Filial_Id
                         and f.Fact_Type = i_Predict_Type
                         and f.Area_Id = Df.Area_Id
                         and f.Driver_Id = Df.Driver_Id
                         and f.Fact_Date > Trunc(sysdate))
               group by Df.Area_Id, Df.Driver_Id)
    loop
      v_Category := Gmap();
    
      v_Category.Put('area_id', r.Area_Id);
      v_Category.Put('driver_id', r.Driver_Id);
      v_Category.Val.Put('facts', r.Facts);
    
      v_Categories.Push(v_Category.Val);
    end loop;
  
    v_Data.Put('categories', v_Categories);
    v_Data.Put('predict_begin', to_char(v_Predict_Begin, 'yyyy-mm-dd'));
    v_Data.Put('predict_end', to_char(v_Predict_End, 'yyyy-mm-dd'));
    v_Data.Put('predict_type', i_Predict_Type);
  
    o_Facts := Fazo.Read_Clob(v_Data.Val.To_Clob());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Object_Facts
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Data       Array_Varchar2
  ) is
    v_Data   Hashmap;
    v_Errors Arraylist;
    v_Error  Hashmap;
  begin
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(i_Company_Id);
    v_Data := Hsc_Facts.Predict_Facts_Response(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Object_Id  => i_Object_Id,
                                               i_Data       => i_Data);
  
    v_Errors := v_Data.r_Arraylist('errors');
  
    for i in 1 .. v_Errors.Count
    loop
      v_Error := Treat(v_Errors.r_Hashmap(i) as Hashmap);
    
      Save_Error_Log(i_Company_Id => i_Company_Id,
                     i_Filial_Id  => i_Filial_Id,
                     i_Error_Log  => v_Error.Json);
    end loop;
  
    Biruni_Route.Context_End;
  end;

end Hsc_Job;
/
