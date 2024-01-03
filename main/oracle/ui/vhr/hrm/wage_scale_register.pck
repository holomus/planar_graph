create or replace package Ui_Vhr256 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Indicators return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Wage_Scales return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap);
end Ui_Vhr256;
/
create or replace package body Ui_Vhr256 is
  ----------------------------------------------------------------------------------------------------
  Function Round_Model(i_Round_Model varchar2 := null) return Hashmap is
    v_Round_Model varchar2(30) := Nvl(i_Round_Model, Mkr_Util.Default_Round_Model);
    result        Hashmap := Hashmap;
  begin
    Result.Put('round_types', Fazo.Zip_Matrix(Mkr_Util.Round_Model_Types));
    Result.Put('round_values', Fazo.Zip_Matrix(Mkr_Util.Round_Model_Values));
  
    Result.Put('round_type', Substr(v_Round_Model, Length(v_Round_Model), 1));
    Result.Put('round_value', Substr(v_Round_Model, 1, Length(v_Round_Model) - 1));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_ranks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('rank_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Indicators return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select w.* 
                       from href_indicators w
                      where w.company_id = :company_id
                        and w.state = ''A''
                        and w.indicator_id <> :wage_indicator_id
                        and w.used = :used_constant',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'wage_indicator_id',
                                 Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                        i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage),
                                 'used_constant',
                                 Href_Pref.c_Indicator_Used_Constantly));
  
    q.Number_Field('indicator_id');
    q.Varchar2_Field('name', 'short_name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Wage_Scales return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrm_wage_scales',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('wage_scale_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Rank_Indicators(i_Register_Id number) return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Rank_Id,
                          q.Indicator_Id,
                          (select w.Name
                             from Href_Indicators w
                            where w.Company_Id = q.Company_Id
                              and w.Indicator_Id = q.Indicator_Id),
                          q.Indicator_Value,
                          q.Coefficient)
      bulk collect
      into v_Matrix
      from Hrm_Register_Rank_Indicators q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Register_Id = i_Register_Id;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(i_Register_Id number) return Matrix_Varchar2 is
    v_Wage_Indicator_Id number := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    v_Matrix            Matrix_Varchar2;
  begin
    select Array_Varchar2(r.Indicator_Id, r.Name)
      bulk collect
      into v_Matrix
      from (select distinct q.Indicator_Id,
                            (select w.Name
                               from Href_Indicators w
                              where w.Company_Id = q.Company_Id
                                and w.Indicator_Id = q.Indicator_Id) as name
              from Hrm_Register_Rank_Indicators q
             where q.Company_Id = Ui.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Register_Id = i_Register_Id
               and q.Indicator_Id <> v_Wage_Indicator_Id) r;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Ranks(i_Register_Id number) return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Rank_Id,
                          (select w.Name
                             from Mhr_Ranks w
                            where w.Company_Id = q.Company_Id
                              and w.Filial_Id = q.Filial_Id
                              and w.Rank_Id = q.Rank_Id))
      bulk collect
      into v_Matrix
      from Hrm_Register_Ranks q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Register_Id = i_Register_Id
     order by q.Order_No;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    r_Indicator Href_Indicators%rowtype := z_Href_Indicators.Load(i_Company_Id   => Ui.Company_Id,
                                                                  i_Indicator_Id => Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                                                                           i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
    result      Hashmap := Hashmap();
  begin
    Result.Put_All(Round_Model);
    Result.Put('register_date', Trunc(sysdate));
    Result.Put('wage_indicator_id', r_Indicator.Indicator_Id);
    Result.Put('wage_indicator_name', r_Indicator.Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Indicator Href_Indicators%rowtype := z_Href_Indicators.Load(i_Company_Id   => Ui.Company_Id,
                                                                  i_Indicator_Id => Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                                                                           i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage));
    r_Data      Hrm_Wage_Scale_Registers%rowtype;
    result      Hashmap;
  begin
    r_Data := z_Hrm_Wage_Scale_Registers.Load(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Register_Id => p.r_Number('register_id'));
  
    result := z_Hrm_Wage_Scale_Registers.To_Map(r_Data,
                                                z.Register_Id,
                                                z.Register_Date,
                                                z.Register_Number,
                                                z.Wage_Scale_Id,
                                                z.Base_Wage,
                                                z.Valid_From,
                                                z.Posted,
                                                z.Note);
  
    Result.Put_All(Round_Model(r_Data.Round_Model));
    Result.Put('ranks', Fazo.Zip_Matrix(Get_Ranks(r_Data.Register_Id)));
    Result.Put('rank_indicators', Fazo.Zip_Matrix(Get_Rank_Indicators(r_Data.Register_Id)));
    Result.Put('indicators', Fazo.Zip_Matrix(Get_Indicators(r_Data.Register_Id)));
    Result.Put('wage_scale_name',
               z_Hrm_Wage_Scales.Load(i_Company_Id => r_Data.Company_Id, --
               i_Filial_Id => r_Data.Filial_Id, --
               i_Wage_Scale_Id => r_Data.Wage_Scale_Id).Name);
  
    Result.Put('wage_indicator_id', r_Indicator.Indicator_Id);
    Result.Put('wage_indicator_name', r_Indicator.Name);
    
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p             Hashmap,
    i_Register_Id number
  ) is
    p_Register   Hrm_Pref.Wage_Scale_Register_Rt;
    p_Ranks      Hrm_Pref.Register_Ranks_Nt := Hrm_Pref.Register_Ranks_Nt();
    p_Rank       Hrm_Pref.Register_Ranks_Rt;
    p_Indicators Hrm_Pref.Regiser_Rank_Indicator_Nt;
    p_Indicator  Hrm_Pref.Register_Rank_Indicator_Rt;
    v_Ranks      Arraylist := p.r_Arraylist('ranks');
    v_Indicators Arraylist;
    v_Indicator  Hashmap;
    v_Rank       Hashmap;
  begin
    Hrm_Util.Wage_Scale_Register_New(o_Register        => p_Register,
                                     i_Company_Id      => Ui.Company_Id,
                                     i_Filial_Id       => Ui.Filial_Id,
                                     i_Register_Id     => i_Register_Id,
                                     i_Register_Date   => p.r_Date('register_date'),
                                     i_Register_Number => p.o_Varchar2('register_number'),
                                     i_Wage_Scale_Id   => p.r_Number('wage_scale_id'),
                                     i_With_Base_Wage  => p.r_Varchar2('with_base_wage'),
                                     i_Round_Model     => p.o_Varchar2('round_model'),
                                     i_Base_Wage       => p.o_Varchar2('base_wage'),
                                     i_Valid_From      => p.r_Date('valid_from'),
                                     i_Note            => p.o_Varchar2('note'));
  
    p_Ranks.Extend(v_Ranks.Count);
  
    for i in 1 .. v_Ranks.Count
    loop
      v_Rank         := Treat(v_Ranks.r_Hashmap(i) as Hashmap);
      p_Rank.Rank_Id := v_Rank.r_Number('rank_id');
    
      v_Indicators := v_Rank.r_Arraylist('indicators');
      p_Indicators := Hrm_Pref.Regiser_Rank_Indicator_Nt();
      p_Indicators.Extend(v_Indicators.Count);
    
      for j in 1 .. v_Indicators.Count
      loop
        v_Indicator                 := Treat(v_Indicators.r_Hashmap(j) as Hashmap);
        p_Indicator.Indicator_Id    := v_Indicator.r_Number('indicator_id');
        p_Indicator.Indicator_Value := v_Indicator.r_Number('indicator_value');
        p_Indicator.Coefficient     := v_Indicator.o_Number('coefficient');
      
        p_Indicators(j) := p_Indicator;
      end loop;
    
      p_Rank.Indicators := p_Indicators;
    
      p_Ranks(i) := p_Rank;
    end loop;
  
    p_Register.Ranks := p_Ranks;
  
    Hrm_Api.Wage_Scale_Register_Save(p_Register);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hrm_Api.Wage_Scale_Register_Post(i_Company_Id  => p_Register.Company_Id,
                                       i_Filial_Id   => p_Register.Filial_Id,
                                       i_Register_Id => p_Register.Register_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(p, Hrm_Next.Register_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Register Hrm_Wage_Scale_Registers%rowtype;
  begin
    r_Register := z_Hrm_Wage_Scale_Registers.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                                       i_Filial_Id   => Ui.Filial_Id,
                                                       i_Register_Id => p.r_Number('register_id'));
  
    if r_Register.Posted = 'Y' then
      Hrm_Api.Wage_Scale_Register_Unpost(i_Company_Id  => r_Register.Company_Id,
                                         i_Filial_Id   => r_Register.Filial_Id,
                                         i_Register_Id => r_Register.Register_Id);
    end if;
  
    save(p, r_Register.Register_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null,
           Order_No   = null;
    update Href_Indicators
       set Company_Id   = null,
           Indicator_Id = null,
           name         = null,
           Short_Name   = null,
           State        = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null,
           State         = null;
  end;

end Ui_Vhr256;
/
