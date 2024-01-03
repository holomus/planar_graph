set define off
set serveroutput on
declare
  c_Md_Role_Forms      varchar(50) := 'a_forms';
  c_Md_Role_Actions    varchar(50) := 'a_actions';
  c_Md_Revoked_Forms   varchar(50) := 'g_forms';
  c_Md_Revoked_Grids   varchar(50) := 'g_grids';
  c_Md_Revoked_Columns varchar(50) := 'g_columns';

  v_Company_Head_Id number := Md_Pref.c_Company_Head;
  v_Project_Code    varchar(10) := Upper(Verifix.Project_Code || ':%');
  v_Forms           Array_Varchar2;
  v_Actions         Array_Varchar2;
  v_Grids           Array_Varchar2;
  v_Columns         Array_Varchar2;
  v_Cache           Gmap;

  -----------------------------------------
  Procedure Grid_Columns
  (
    i_Company_Id  number,
    i_Role_Id     number,
    i_Form        varchar2,
    i_Grid        varchar2,
    i_Grid_Column varchar2
  ) is
  begin
    z_Md_Role_Revoked_Columns.Insert_One(i_Company_Id  => i_Company_Id,
                                         i_Role_Id     => i_Role_Id,
                                         i_Form        => i_Form,
                                         i_Grid        => i_Grid,
                                         i_Grid_Column => i_Grid_Column);
  end;

  ------------------------------
  Procedure Form_Actions
  (
    i_Company_Id number,
    i_Role_Id    number,
    i_Form       varchar2,
    i_Action_Key varchar2
  ) is
  begin
    z_Md_Role_Form_Actions.Insert_One(i_Company_Id => i_Company_Id,
                                      i_Role_Id    => i_Role_Id,
                                      i_Form       => i_Form,
                                      i_Action_Key => i_Action_Key);
  end;

  ------------------------------
  Procedure Projects
  (
    i_Company_Id   number,
    i_Role_Id      number,
    i_Project_Code varchar2
  ) is
  begin
    z_Md_Role_Projects.Insert_Try(i_Company_Id   => i_Company_Id,
                                  i_Role_Id      => i_Role_Id,
                                  i_Project_Code => i_Project_Code);
  end;

  ------------------------------
  Procedure Dirty_Role
  (
    i_Company_Id number,
    i_Role_Id    number
  ) is
  begin
    insert into Md_Dirty_Roles
    values
      (i_Company_Id, i_Role_Id);
  end;

begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head_Id);

  v_Cache := Gmap();
  for r in (select q.Company_Id, q.Pcode, q.Role_Id
              from Md_Roles q
             where q.Company_Id = v_Company_Head_Id
               and Upper(q.Pcode) like v_Project_Code)
  loop
    select q.Form, q.Action_Key
      bulk collect
      into v_Forms, v_Actions
      from Md_Role_Form_Actions q
      left join (select w.Form, w.Action_Key, w.Company_Id, q.Pcode, q.Role_Id
                   from Md_Role_Form_Actions w
                   join Md_Roles q
                     on q.Role_Id = w.Role_Id
                    and q.Company_Id = w.Company_Id
                  where w.Company_Id <> v_Company_Head_Id) w
        on w.Pcode = r.Pcode
       and w.Form = q.Form
     where q.Company_Id = r.Company_Id
       and q.Role_Id = r.Role_Id
       and w.Pcode is null;
  
    v_Cache.Put(r.Pcode || ':' || c_Md_Role_Forms, v_Forms);
    v_Cache.Put(r.Pcode || ':' || c_Md_Role_Actions, v_Actions);
  
    select q.Form, q.Grid, q.Grid_Column
      bulk collect
      into v_Forms, v_Grids, v_Columns
      from Md_Role_Revoked_Columns q
      left join (select g.Form, g.Grid, g.Grid_Column, h.Pcode, g.Role_Id
                   from Md_Role_Revoked_Columns g
                   join Md_Roles h
                     on h.Company_Id = g.Company_Id
                    and h.Role_Id = g.Role_Id
                  where g.Company_Id <> r.Company_Id) w
        on w.Pcode = r.Pcode
       and w.Form = q.Form
     where q.Company_Id = r.Company_Id
       and q.Role_Id = r.Role_Id
       and w.Pcode is null;
  
    v_Cache.Put(r.Pcode || ':' || c_Md_Revoked_Forms, v_Forms);
    v_Cache.Put(r.Pcode || ':' || c_Md_Revoked_Grids, v_Grids);
    v_Cache.Put(r.Pcode || ':' || c_Md_Revoked_Columns, v_Actions);
  end loop;

  for r in (select q.Company_Id
              from Md_Companies q
             where q.Company_Id <> v_Company_Head_Id)
  loop
    Ui_Auth.Logon_As_System(i_Company_Id => r.Company_Id);
  
    for c in (select w.Pcode, w.Role_Id
                from Md_Roles w
               where w.Company_Id = r.Company_Id
                 and Upper(w.Pcode) like v_Project_Code)
    loop
      v_Forms   := v_Cache.r_Array_Varchar2(c.Pcode || ':' || c_Md_Role_Forms);
      v_Actions := v_Cache.r_Array_Varchar2(c.Pcode || ':' || c_Md_Role_Actions);
      for d in 1 .. v_Forms.Count
      loop
        Form_Actions(r.Company_Id, c.Role_Id, v_Forms(d), v_Actions(d));
      end loop;
    
      v_Forms   := v_Cache.r_Array_Varchar2(c.Pcode || ':' || c_Md_Revoked_Forms);
      v_Grids   := v_Cache.r_Array_Varchar2(c.Pcode || ':' || c_Md_Revoked_Grids);
      v_Columns := v_Cache.r_Array_Varchar2(c.Pcode || ':' || c_Md_Revoked_Columns);
      for d in 1 .. v_Forms.Count
      loop
        Grid_Columns(r.Company_Id, c.Role_Id, v_Forms(d), v_Grids(d), v_Columns(d));
      end loop;
    
      Projects(r.Company_Id, c.Role_Id, Verifix.Project_Code);
      Dirty_Role(r.Company_Id, c.Role_Id);
    end loop;
  end loop;
  Md_Core.Gen_User_Access();
  commit;
end;
/
