create or replace package Ui_Vhr224 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
end Ui_Vhr224;
/
create or replace package body Ui_Vhr224 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select * from htt_terminal_models');
  
    q.Number_Field('model_id');
    q.Varchar2_Field('name',
                     'photo_sha',
                     'support_face_recognation',
                     'support_fprint',
                     'support_rfid_card',
                     'support_qr_code',
                     'state');
  
    q.Option_Field('support_face_recognation_name',
                   'support_face_recognation',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('support_fprint_name',
                   'support_fprint',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('support_rfid_card_name',
                   'support_rfid_card',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Terminal_Models
       set Model_Id                 = null,
           name                     = null,
           Photo_Sha                = null,
           Support_Face_Recognation = null,
           Support_Fprint           = null,
           Support_Rfid_Card        = null,
           State                    = null;
  end;

end Ui_Vhr224;
/
