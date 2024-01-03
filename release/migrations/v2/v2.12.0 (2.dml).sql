prompt migr from 28.11.2022
----------------------------------------------------------------------------------------------------
declare
  v_Forms Array_Varchar2 := Array_Varchar2('/vhr/href/employee/employee_list',
                                           '/vhr/href/employee/employee_add',
                                           '/vhr/href/employee/employee_edit',
                                           '/vhr/href/employee/employee');

  v_Form_Actions Matrix_Varchar2 := Matrix_Varchar2();
  v_Actions      Array_Varchar2;

  --------------------------------------------------
  Procedure Role_Form_Action_Grant
  (
    i_Company_Id number,
    i_Role_Id    number,
    i_Form       varchar2,
    i_Action_Key varchar2
  ) is
    r_Form          Md_Forms%rowtype := z_Md_Forms.Load(i_Form);
    r_Form_Action   Md_Form_Actions%rowtype;
    v_Filial_Access varchar2(10);
    v_Can_Save      boolean;
  begin
    for r in (select *
                from Md_User_Roles t
               where t.Company_Id = i_Company_Id
                 and t.Role_Id = i_Role_Id)
    loop
      v_Can_Save := true;
      if Md_Pref.Filial_Head(i_Company_Id) = r.Filial_Id then
        v_Filial_Access := 'H';
      else
        v_Filial_Access := 'F';
      end if;
    
      if i_Action_Key = Md_Pref.Form_Sign then
        if r_Form.Filial_Access in ('A', v_Filial_Access) then
          v_Can_Save := true;
        
          for q in (select *
                      from Md_Form_Actions a
                     where a.Open_Form = i_Form
                       and a.Filial_Access in ('A', v_Filial_Access))
          loop
            z_Md_Gen_User_Form_Actions.Save_One(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => r.Filial_Id,
                                                i_User_Id    => r.User_Id,
                                                i_Form       => q.Form,
                                                i_Action_Key => q.Action_Key,
                                                i_Touched    => 'Y');
          end loop;
        end if;
      else
        r_Form_Action := z_Md_Form_Actions.Take(i_Form => i_Form, i_Action_Key => i_Action_Key);
        if r_Form_Action.Filial_Access in ('A', v_Filial_Access) then
          v_Can_Save := true;
        end if;
      end if;
    
      if v_Can_Save then
        z_Md_Gen_User_Form_Actions.Save_One(i_Company_Id => r.Company_Id,
                                            i_Filial_Id  => r.Filial_Id,
                                            i_User_Id    => r.User_Id,
                                            i_Form       => i_Form,
                                            i_Action_Key => i_Action_Key,
                                            i_Touched    => 'Y');
      end if;
    end loop;
  end;

  --------------------------------------------------
  Procedure Company_Fix(i_Company_Id number) is
    r_Role    Md_Roles%rowtype;
    v_Role_Id number := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                        i_Pcode      => Href_Pref.c_Pcode_Role_Hr);
  begin
    if v_Role_Id is null then
      return;
    end if;
  
    r_Role := z_Md_Roles.Load(i_Company_Id => i_Company_Id, i_Role_Id => v_Role_Id);
  
    for i in 1 .. v_Forms.Count
    loop
      v_Actions := v_Form_Actions(i);
    
      for j in 1 .. v_Actions.Count
      loop
        z_Md_Role_Form_Actions.Insert_Try(i_Company_Id => i_Company_Id,
                                          i_Role_Id    => v_Role_Id,
                                          i_Form       => v_Forms(i),
                                          i_Action_Key => v_Actions(j));
      
        if r_Role.State = 'A' then
          Role_Form_Action_Grant(i_Company_Id => i_Company_Id,
                                 i_Role_Id    => v_Role_Id,
                                 i_Form       => v_Forms(i),
                                 i_Action_Key => v_Actions(j));
        end if;
      end loop;
    end loop;
  end;
begin
  for i in 1 .. v_Forms.Count
  loop
    select q.Action_Key
      bulk collect
      into v_Actions
      from Md_Form_Actions q
     where q.Form = v_Forms(i);
  
    Fazo.Push(v_Actions, '*');
    Fazo.Push(v_Form_Actions, v_Actions);
  end loop;

  Biruni_Route.Context_Begin;

  for r in (select c.Company_Id,
                   (select i.Filial_Head
                      from Md_Company_Infos i
                     where i.Company_Id = c.Company_Id) Filial_Head,
                   (select i.User_System
                      from Md_Company_Infos i
                     where i.Company_Id = c.Company_Id) User_System
              from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Company_Fix(r.Company_Id);
  end loop;

  Biruni_Route.Context_End;
  commit;
end;
/
