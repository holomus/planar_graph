set define off
prompt PATH /vhr/api/v1/core/track
begin
uis.route('/vhr/api/v1/core/track$list','Ui_Vhr348.List_Tracks','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/core/track','vhr348');
uis.form('/vhr/api/v1/core/track','/vhr/api/v1/core/track','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/track','list','F',null,null,'A');


uis.ready('/vhr/api/v1/core/track','.list.model.');

commit;
end;
/
