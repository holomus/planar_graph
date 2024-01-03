create or replace package Htm_Next is
  ----------------------------------------------------------------------------------------------------
  Function Experience_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Recommended_Rank_Document_Id return number;
end Htm_Next;
/
create or replace package body Htm_Next is
  ----------------------------------------------------------------------------------------------------
  Function Experience_Id return number is
  begin
    return Htm_Experiences_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Recommended_Rank_Document_Id return number is
  begin
    return Htm_Recommended_Rank_Documents_Sq.Nextval;
  end;

end Htm_Next;
/
