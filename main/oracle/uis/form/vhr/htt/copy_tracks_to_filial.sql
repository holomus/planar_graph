set define off
prompt PATH /vhr/htt/copy_tracks_to_filial
begin
uis.route('/vhr/htt/copy_tracks_to_filial$copy_tracks','Ui_Vhr498.Copy_Tracks','JO',null,'A',null,null,null,null);
uis.route('/vhr/htt/copy_tracks_to_filial:load_data','Ui_Vhr498.Load_Data','JO','JA','A',null,null,null,null);
uis.route('/vhr/htt/copy_tracks_to_filial:model','Ui_Vhr498.Model',null,'JO','A','Y',null,null,null);

uis.path('/vhr/htt/copy_tracks_to_filial','vhr498');
uis.form('/vhr/htt/copy_tracks_to_filial','/vhr/htt/copy_tracks_to_filial','F','A','F','H','M','N',null,null);



uis.action('/vhr/htt/copy_tracks_to_filial','copy_tracks','F',null,null,'A');
uis.action('/vhr/htt/copy_tracks_to_filial','select_employee','F','/vhr/href/employee/employee_list','D','O');


uis.ready('/vhr/htt/copy_tracks_to_filial','.copy_tracks.model.select_employee.');

commit;
end;
/
