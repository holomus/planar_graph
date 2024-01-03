create or replace package Ui_Vhr481 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Arraylist);
end Ui_Vhr481;
/
create or replace package body Ui_Vhr481 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    v_Ids    Array_Number;
    result   Hashmap := Hashmap;
  begin
    select Array_Varchar2(q.Job_Id, q.Name), q.Job_Id
      bulk collect
      into v_Matrix, v_Ids
      from Mhr_Jobs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.State = 'A'
     order by Lower(q.Name);
  
    Result.Put('jobs', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Job_Id, q.Bonus_Type, q.Percentage)
      bulk collect
      into v_Matrix
      from Hrm_Job_Bonus_Types q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Job_Id in (select *
                          from table(v_Ids));
  
    Result.Put('job_bonus_types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('bonus_types', Fazo.Zip_Matrix_Transposed(Hrm_Util.Bonus_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Arraylist) is
    v_Job            Hashmap;
    v_Job_Bonus_Type Hrm_Pref.Job_Bonus_Type_Rt;
  begin
    for i in 1 .. p.Count
    loop
      v_Job := Treat(p.r_Hashmap(i) as Hashmap);
    
      Hrm_Util.Job_Bonus_Type_New(o_Job_Bonus_Type => v_Job_Bonus_Type,
                                  i_Company_Id     => Ui.Company_Id,
                                  i_Filial_Id      => Ui.Filial_Id,
                                  i_Job_Id         => v_Job.r_Number('job_id'),
                                  i_Bonus_Types    => v_Job.r_Array_Varchar2('bonus_types'),
                                  i_Percentages    => v_Job.r_Array_Number('percentages'));
    
      Hrm_Api.Save_Job_Bonus_Type(v_Job_Bonus_Type);
    end loop;
  end;

end Ui_Vhr481;
/
