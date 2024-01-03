set define off
prompt PATH /vhr/hac/problem_tracks_list
begin
uis.route('/vhr/hac/problem_tracks_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/problem_tracks_list:table','Ui_Vhr636.Query_Tracks',null,'Q','A',null,null,null,null);

uis.path('/vhr/hac/problem_tracks_list','vhr636');
uis.form('/vhr/hac/problem_tracks_list','/vhr/hac/problem_tracks_list','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/hac/problem_tracks_list','.model.');

commit;
end;
/
