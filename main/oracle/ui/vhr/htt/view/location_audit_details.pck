create or replace package Ui_Vhr414 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr414;
/
create or replace package body Ui_Vhr414 is
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
    return b.Translate('UI-VHR414:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Locations
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Context_Id  number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Locations%rowtype;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    v_Diff_Columns Array_Varchar2;

    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select q.*
                from x_Htt_Locations q
               where q.t_Company_Id = i_Company_Id
                 and q.Location_Id = i_Location_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Htt_Locations t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Location_Id = r.Location_Id
                     and t.t_Context_Id <> i_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;

        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      else
        r_Last := null;
      end if;

      v_Diff_Columns := z_x_Htt_Locations.Difference(r, r_Last);

      Get_Difference(z.Name, t('name'), r_Last.Name, r.Name);
      Get_Difference(z.Location_Type_Id,
                     t('location type name'),
                     z_Htt_Location_Types.Take(i_Company_Id => i_Company_Id, i_Location_Type_Id => r_Last.Location_Type_Id).Name,
                     z_Htt_Location_Types.Take(i_Company_Id => i_Company_Id, i_Location_Type_Id => r.Location_Type_Id).Name);
      Get_Difference(z.Timezone_Code,
                     t('timezone code'),
                     z_Md_Timezones.Take(i_Timezone_Code => r_Last.Timezone_Code).Name_Ru,
                     z_Md_Timezones.Take(i_Timezone_Code => r.Timezone_Code).Name_Ru);
      Get_Difference(z.Region_Id,
                     t('region name'),
                     z_Md_Regions.Take(i_Company_Id => i_Company_Id, i_Region_Id => r_Last.Region_Id).Name,
                     z_Md_Regions.Take(i_Company_Id => i_Company_Id, i_Region_Id => r.Region_Id).Name);
      Get_Difference(z.Address, t('address'), r_Last.Address, r.Address);
      Get_Difference(z.Latlng, t('latlng'), r_Last.Latlng, r.Latlng);
      Get_Difference(z.Accuracy, t('accuracy'), r_Last.Accuracy, r.Accuracy);
      Get_Difference(z.Bssids, t('bssids'), r_Last.Bssids, r.Bssids);
      Get_Difference(z.Code, t('code'), r_Last.Code, r.Code);
      Get_Difference(z.Prohibited,
                     t('prohibited'),
                     Md_Util.Decode(r_Last.Prohibited, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                     Md_Util.Decode(r.Prohibited, 'Y', Ui.t_Yes, 'N', Ui.t_No));
      Get_Difference(z.State,
                     t('state'),
                     Md_Util.Decode(r_Last.State, 'A', Ui.t_Active, 'P', Ui.t_Passive),
                     Md_Util.Decode(r.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Locations
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Context_Id  number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Location_Persons%rowtype;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    v_Diff_Columns Array_Varchar2;

    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select q.*
                from x_Htt_Location_Persons q
               where q.t_Company_Id = i_Company_Id
                 and q.Location_Id = i_Location_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Htt_Location_Persons t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.Location_Id = r.Location_Id
                     and t.t_Context_Id <> i_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;

        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      else
        r_Last := null;
      end if;

      v_Diff_Columns := z_x_Htt_Location_Persons.Difference(r, r_Last);

      Get_Difference(z.Person_Id,
                     t('person name'),
                     z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => r_Last.Person_Id).Name,
                     z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => r.Person_Id).Name);
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Company_Id  number := Ui.Company_Id;
    v_Location_Id number := p.r_Number('location_id');
    v_Context_Id  number := p.r_Number('context_id');
    v_Type        varchar2(40) := p.r_Varchar2('type');
    v_Matrix      Matrix_Varchar2;
    result        Hashmap := Hashmap();
  begin
    Result.Put('name',
               z_Htt_Locations.Take(i_Company_Id => v_Company_Id, i_Location_Id => v_Location_Id).Name);

    if v_Type = 'audit' then
      v_Matrix := Locations(i_Company_Id  => v_Company_Id,
                            i_Location_Id => v_Location_Id,
                            i_Context_Id  => v_Context_Id);
    else
      v_Matrix := Person_Locations(i_Company_Id  => v_Company_Id,
                                   i_Location_Id => v_Location_Id,
                                   i_Context_Id  => v_Context_Id);
    end if;

    Result.Put('data', Fazo.Zip_Matrix(v_Matrix));

    return result;
  end;

end Ui_Vhr414;
/
