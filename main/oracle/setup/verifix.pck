create or replace package Verifix is
  ----------------------------------------------------------------------------------------------------
  Function Version return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Project_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Href_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hes_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hlic_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Htt_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hzk_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hrm_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hpd_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hln_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hper_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hpr_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hac_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Htm_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hrec_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hsc_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hface_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Hide_Error_Code return varchar2 deterministic;
  ----------------------------------------------------------------------------------------------------
  Function Uit_Error_Code return varchar2 deterministic;
end Verifix;
/
create or replace package body Verifix is
  ----------------------------------------------------------------------------------------------------
  Function Version return varchar2 deterministic is
  begin
    return '3.1.9';
  end;
  ----------------------------------------------------------------------------------------------------
  Function Project_Code return varchar2 deterministic is
  begin
    return 'vhr';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Href_Error_Code return varchar2 deterministic is
  begin
    return 'A05-01';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hes_Error_Code return varchar2 deterministic is
  begin
    return 'A05-02';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hlic_Error_Code return varchar2 deterministic is
  begin
    return 'A05-03';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Htt_Error_Code return varchar2 deterministic is
  begin
    return 'A05-04';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hzk_Error_Code return varchar2 deterministic is
  begin
    return 'A05-05';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hrm_Error_Code return varchar2 deterministic is
  begin
    return 'A05-06';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hpd_Error_Code return varchar2 deterministic is
  begin
    return 'A05-07';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hln_Error_Code return varchar2 deterministic is
  begin
    return 'A05-08';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hper_Error_Code return varchar2 deterministic is
  begin
    return 'A05-09';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hpr_Error_Code return varchar2 deterministic is
  begin
    return 'A05-10';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hac_Error_Code return varchar2 deterministic is
  begin
    return 'A05-11';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Htm_Error_Code return varchar2 deterministic is
  begin
    return 'A05-12';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hrec_Error_Code return varchar2 deterministic is
  begin
    return 'A05-13';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hsc_Error_Code return varchar2 deterministic is
  begin
    return 'A05-14';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hface_Error_Code return varchar2 deterministic is
  begin
    return 'A05-15';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hide_Error_Code return varchar2 deterministic is
  begin
    return 'A05-16';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Uit_Error_Code return varchar2 deterministic is
  begin
    return 'A05-99';
  end;

end Verifix;
/
