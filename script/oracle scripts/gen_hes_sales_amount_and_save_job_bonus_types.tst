PL/SQL Developer Test script 3.0
95
declare
  v_Company_Id number := 0;
  v_Filial_Id  number := 1900;

  v_Percent_Begin number := 0.1;
  v_Percent_End   number := 5;
  v_Round         number := 2;

  v_Sale_Begin_Date   date := to_date('01.03.2023', 'dd.mm.yyyy');
  v_Days              number := 30;
  v_Sale_Amount_Begin number := 1000000;
  v_Sale_Amount_End   number := 5000000;

  --------------------------------------------------
  Procedure Save_Job_Bonus_Types is
    v_Bonus_Types Matrix_Varchar2 := Hrm_Util.Bonus_Types;
  begin
    for Job in (select q.Job_Id
                  from Mhr_Jobs q
                 where q.Company_Id = v_Company_Id
                   and q.Filial_Id = v_Filial_Id)
    loop
      for i in 1 .. v_Bonus_Types(1).Count
      loop
        z_Hrm_Job_Bonus_Types.Insert_Try(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => v_Filial_Id,
                                         i_Job_Id     => Job.Job_Id,
                                         i_Bonus_Type => v_Bonus_Types(1) (i),
                                         i_Percentage => Round(Dbms_Random.Value(v_Percent_Begin,
                                                                                 v_Percent_End),
                                                               v_Round));
      end loop;
    end loop;
  end;

  --------------------------------------------------
  Procedure Save_Person_Sales_Amount is
    v_Division_Codes Array_Varchar2;
    v_Division_Cnt   number;
  begin
    select q.Code
      bulk collect
      into v_Division_Codes
      from Mhr_Divisions q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and Regexp_Like(q.Code, '^[[:digit:]]+$');
  
    v_Division_Cnt := v_Division_Codes.Count;
  
    for r in (select (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = v_Company_Id
                         and Np.Person_Id = s.Employee_Id) as name
                from Href_Staffs s
               where s.Company_Id = v_Company_Id
                 and s.Filial_Id = v_Filial_Id
                 and s.State = 'A'
                 and s.Hiring_Date <= v_Sale_Begin_Date
                 and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Sale_Begin_Date + v_Days)
               group by s.Employee_Id)
    loop
      for i in 0 .. v_Days - 1
      loop
        insert into Hes_Billz_Consolidated_Sales
          (Company_Id,
           Filial_Id,
           Sale_Id,
           Billz_Office_Id,
           Billz_Seller_Name,
           Sale_Date,
           Sale_Amount)
        values
          (v_Company_Id,
           v_Filial_Id,
           Hes_Billz_Consolidated_Sales_Sq.Nextval,
           v_Division_Codes(Href_Util.Random_Integer(1, v_Division_Cnt)),
           r.Name,
           v_Sale_Begin_Date + i,
           Href_Util.Random_Integer(v_Sale_Amount_Begin, v_Sale_Amount_End));
      end loop;
    end loop;
  end;
begin
  Biruni_Route.Context_Begin;
  Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                       i_Filial_Id    => v_Filial_Id,
                       i_User_Id      => Md_Pref.User_Admin(v_Company_Id),
                       i_Project_Code => Verifix.Project_Code);

  -- Save_Job_Bonus_Types;
  Save_Person_Sales_Amount;

  Biruni_Route.Context_End;
end;
0
0
