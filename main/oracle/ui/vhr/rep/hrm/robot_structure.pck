create or replace package Ui_Vhr602 is
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
end Ui_Vhr602;
/
create or replace package body Ui_Vhr602 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Sysdate    date := sysdate;
    v_Matrix     Matrix_Varchar2;
    result       Hashmap;
  begin
    result := Fazo.Zip_Map('filial_name',
                           z_Md_Filials.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id).Name);
  
    with
    --------------------------------------------------
    Divisions as
     (select Md.Division_Id, Md.Name, Md.Parent_Id
        from Mhr_Divisions Md
       where Md.Company_Id = v_Company_Id
         and Md.Filial_Id = v_Filial_Id
         and Md.State = 'A'
       order by Md.Name),
    
    --------------------------------------------------
    Robots as
     (select Hr.Org_Unit_Id, Mr.Job_Id, count(Hr.Robot_Id) Robot_Count
        from Hrm_Robots Hr
        join Mrf_Robots Mr
          on Mr.Company_Id = Hr.Company_Id
         and Mr.Filial_Id = Hr.Filial_Id
         and Mr.Robot_Id = Hr.Robot_Id
         and Mr.State = 'A'
       where Hr.Company_Id = v_Company_Id
         and Hr.Filial_Id = v_Filial_Id
         and Hr.Opened_Date <= v_Sysdate
         and Nvl(Hr.Closed_Date, v_Sysdate) >= v_Sysdate
         and exists (select 1
                from Divisions d
               where d.Division_Id = Hr.Org_Unit_Id)
       group by Hr.Org_Unit_Id, Mr.Job_Id),
    
    --------------------------------------------------
    Tree_Nodes as
     (select to_char(d.Division_Id) Node_Id,
             d.Name,
             d.Parent_Id,
             case
                when (select Hd.Is_Department
                        from Hrm_Divisions Hd
                       where Hd.Company_Id = v_Company_Id
                         and Hd.Filial_Id = v_Filial_Id
                         and Hd.Division_Id = d.Division_Id) = 'N' then
                 'T'
                else
                 'D'
              end Kind,
             null Robot_Count
        from Divisions d
      union all
      select 'R' || r.Job_Id,
             (select Mj.Name
                from Mhr_Jobs Mj
               where Mj.Company_Id = v_Company_Id
                 and Mj.Filial_Id = v_Filial_Id
                 and Mj.Job_Id = r.Job_Id) name,
             r.Org_Unit_Id,
             'R',
             r.Robot_Count
        from Robots r)
    
    --------------------------------------------------
    -- Node Kind: (H)ead, (D)epartment, (T)eam, (R)obot
    --------------------------------------------------
    select Array_Varchar2(n.Node_Id, n.Name, n.Parent_Id, n.Kind, n.Robot_Count)
      bulk collect
      into v_Matrix
      from Tree_Nodes n;
  
    Result.Put('nodes', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

end Ui_Vhr602;
/
