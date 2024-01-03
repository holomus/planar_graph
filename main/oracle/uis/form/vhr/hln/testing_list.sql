set define off
prompt PATH /vhr/hln/testing_list
begin
uis.route('/vhr/hln/testing_list+control$add_time','Ui_Vhr223.Add_Time','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$continue','Ui_Vhr223.Continue','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$finish','Ui_Vhr223.Finish','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$pause','Ui_Vhr223.Pause','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$return_checking','Ui_Vhr223.Return_Checking','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$return_execute','Ui_Vhr223.Return_Execute','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$set_begin_time','Ui_Vhr223.Set_Begin_Time','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$set_new','Ui_Vhr223.Set_New','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$start','Ui_Vhr223.To_Start','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control$stop','Ui_Vhr223.Stop','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+control:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/testing_list+control:table','Ui_Vhr223.Query_Control','M','Q','A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$add_time','Ui_Vhr223.Add_Time','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$continue','Ui_Vhr223.Continue','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$delete','Ui_Vhr223.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$finish','Ui_Vhr223.Finish','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$pause','Ui_Vhr223.Pause','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$return_checking','Ui_Vhr223.Return_Checking','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$return_execute','Ui_Vhr223.Return_Execute','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$set_begin_time','Ui_Vhr223.Set_Begin_Time','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$set_new','Ui_Vhr223.Set_New','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr$stop','Ui_Vhr223.Stop','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing_list+hr:model','Ui_Vhr223.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/testing_list+hr:table','Ui_Vhr223.Query_Hr',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing_list+user:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/testing_list+user:table','Ui_Vhr223.Query_User',null,'Q','A',null,null,null,null);

uis.path('/vhr/hln/testing_list','vhr223');
uis.form('/vhr/hln/testing_list+control','/vhr/hln/testing_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hln/testing_list+hr','/vhr/hln/testing_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hln/testing_list+user','/vhr/hln/testing_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/testing_list+control','add_time','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','check','F','/vhr/hln/check_answers','S','O');
uis.action('/vhr/hln/testing_list+control','continue','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','finish','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','pause','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','return_checking','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','return_execute','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','set_begin_time','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','set_new','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','start','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','stop','F',null,null,'A');
uis.action('/vhr/hln/testing_list+control','view','F','/vhr/hln/testing_view','S','O');
uis.action('/vhr/hln/testing_list+hr','add','F','/vhr/hln/testing+add','S','O');
uis.action('/vhr/hln/testing_list+hr','add_time','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','all_access','F',null,null,'G');
uis.action('/vhr/hln/testing_list+hr','check','F','/vhr/hln/check_answers','S','O');
uis.action('/vhr/hln/testing_list+hr','continue','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','delete','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','edit','F','/vhr/hln/testing+edit','S','O');
uis.action('/vhr/hln/testing_list+hr','finish','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','pause','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','return_checking','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','return_execute','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','set_begin_time','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','set_new','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','stop','F',null,null,'A');
uis.action('/vhr/hln/testing_list+hr','view','F','/vhr/hln/testing_view','S','O');
uis.action('/vhr/hln/testing_list+user','enter','F','/vhr/hln/pass_testing','S','O');
uis.action('/vhr/hln/testing_list+user','view','F','/vhr/hln/testing_view','S','O');


uis.ready('/vhr/hln/testing_list+control','.add_time.check.continue.finish.model.pause.return_checking.return_execute.set_begin_time.set_new.start.stop.view.');
uis.ready('/vhr/hln/testing_list+hr','.add.add_time.all_access.check.continue.delete.edit.finish.model.pause.return_checking.return_execute.set_begin_time.set_new.stop.view.');
uis.ready('/vhr/hln/testing_list+user','.enter.model.view.');

commit;
end;
/
