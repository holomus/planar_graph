create or replace package Ui_Vhr574 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr574;
/
create or replace package body Ui_Vhr574 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Funnels,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Funnels,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    v_Stages Matrix_Varchar2;
    result   Hashmap;
  begin
    result := Fazo.Zip_Map('state', 'A');
  
    select Array_Varchar2(t.Stage_Id,
                           t.Name,
                           t.Pcode,
                           case
                             when t.Pcode is not null then
                              'Y'
                             else
                              'N'
                           end)
      bulk collect
      into v_Stages
      from Hrec_Stages t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Order_No;
  
    Result.Put('stages', Fazo.Zip_Matrix(v_Stages));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Funnel Hrec_Funnels%rowtype;
    v_Stages Matrix_Varchar2;
    result   Hashmap;
  begin
    r_Funnel := z_Hrec_Funnels.Load(i_Company_Id => Ui.Company_Id,
                                    i_Funnel_Id  => p.r_Number('funnel_id'));
  
    result := z_Hrec_Funnels.To_Map(r_Funnel, z.Funnel_Id, z.Name, z.State, z.Code);
  
    select Array_Varchar2(t.Stage_Id,
                           t.Name,
                           t.Pcode,
                           case
                             when exists (select 1
                                     from Hrec_Funnel_Stages q
                                    where q.Company_Id = t.Company_Id
                                      and q.Funnel_Id = r_Funnel.Funnel_Id
                                      and q.Stage_Id = t.Stage_Id) then
                              'Y'
                             else
                              'N'
                           end)
      bulk collect
      into v_Stages
      from Hrec_Stages t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Order_No;
  
    Result.Put('stages', Fazo.Zip_Matrix(v_Stages));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p           Hashmap,
    i_Funnel_Id number
  ) return Hashmap is
    v_Name   Hrec_Funnels.Name%type;
    v_Funnel Hrec_Pref.Funnel_Rt;
  begin
    v_Name := p.r_Varchar2('name');
  
    Hrec_Util.Funnel_New(o_Funnel     => v_Funnel,
                         i_Company_Id => Ui.Company_Id,
                         i_Funnel_Id  => i_Funnel_Id,
                         i_Name       => v_Name,
                         i_State      => p.r_Varchar2('state'),
                         i_Code       => p.o_Varchar2('code'),
                         i_Stage_Ids  => p.r_Array_Number('stage_ids'));
  
    Hrec_Api.Funnel_Save(v_Funnel);
  
    return Fazo.Zip_Map('funnel_id', i_Funnel_Id, 'name', v_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hrec_Next.Funnel_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
  begin
    return save(p, p.r_Number('funnel_id'));
  end;

end Ui_Vhr574;
/
