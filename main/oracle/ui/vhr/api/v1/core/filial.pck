create or replace package Ui_Vhr658 is
  ----------------------------------------------------------------------------------------------------
  Function Filial_Info return Json_Object_t;
end Ui_Vhr658;
/
create or replace package body Ui_Vhr658 is
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
    return b.Translate('UI-VHR658:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Filial_Info return Json_Object_t is
    r_Legal_Person Mr_Legal_Persons%rowtype;
    r_Person       Md_Persons%rowtype;
    r_Details      Mr_Person_Details%rowtype;
  
    v_Region_Name varchar2(400 char);
  
    result Gmap := Gmap();
  begin
    r_Legal_Person := z_Mr_Legal_Persons.Take(i_Company_Id => Ui.Company_Id,
                                              i_Person_Id  => Ui.Filial_Id);
    r_Person       := z_Md_Persons.Take(i_Company_Id => Ui.Company_Id, --
                                        i_Person_Id  => Ui.Filial_Id);
    r_Details      := z_Mr_Person_Details.Take(i_Company_Id => Ui.Company_Id, --
                                               i_Person_Id  => Ui.Filial_Id);
  
    v_Region_Name := z_Md_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => r_Details.Region_Id).Name;
  
    Result.Put('filial_name', r_Legal_Person.Name);
    Result.Put('photo_sha', r_Person.Photo_Sha);
    Result.Put('email',
               case when r_Person.Email is not null then t('email: $1', r_Person.Email) else null end);
    Result.Put('main_phone',
               case when r_Details.Main_Phone is not null then
               t('main_phone: $1', r_Details.Main_Phone) else null end);
    Result.Put('web', r_Details.Web);
    Result.Put('telegram', r_Details.Telegram);
    Result.Put('address',
               case when r_Details.Address is not null then t('address: $1', r_Details.Address) else null end);
    Result.Put('address_guide',
               case when r_Details.Address_Guide is not null then
               t('address_guide: $1', r_Details.Address_Guide) else null end);
    Result.Put('note',
               case when r_Details.Note is not null then t('description: $1', r_Details.Note) else null end);
    Result.Put('region_name',
               case when v_Region_Name is not null then t('region: $1', v_Region_Name) else null end);
  
    return Result.Val;
  end;

end Ui_Vhr658;
/
