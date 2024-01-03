PL/SQL Developer Test script 3.0
52
declare
  v_Company_Id number := 0;
  v_Filial_Id  number := 109;

  v_Division_Ids Array_Number;

  -------------------------------------------------- 
  Procedure Make_Parent
  (
    i_Start  number,
    i_End    number,
    i_Parent number
  ) is
    v_Mid number := Floor((i_Start + i_End) / 2);
  begin
    if i_End <= i_Start then
      return;
    end if;
  
    if i_Parent is not null then
      for i in i_Start .. i_End
      loop
        Mhr_Core.Division_Set_Parent(i_Company_Id    => v_Company_Id,
                                     i_Filial_Id     => v_Filial_Id,
                                     i_Division_Id   => v_Division_Ids(i),
                                     i_Old_Parent_Id => null,
                                     i_New_Parent_Id => i_Parent);
      end loop;
    end if;
  
    Make_Parent(i_Start, v_Mid - 1, v_Division_Ids(v_Mid));
    Make_Parent(v_Mid + 1, i_End, v_Division_Ids(v_Mid));
  end;
begin
  Biruni_Route.Context_Begin;
  Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                       i_Filial_Id    => v_Filial_Id,
                       i_User_Id      => Md_Pref.User_Admin(v_Company_Id),
                       i_Project_Code => Verifix.Project_Code);

  select p.Division_Id
    bulk collect
    into v_Division_Ids
    from Mhr_Divisions p
   where p.Company_Id = 0
     and p.Filial_Id = 109
     and p.Parent_Id is null;

  Make_Parent(1, v_Division_Ids.Count, null);

  Biruni_Route.Context_End;
end;
0
0
