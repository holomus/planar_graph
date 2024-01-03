set define off
declare
--------------------------------------------------
procedure form(a varchar2, b varchar2) is begin
z_md_license_forms.insert_one(i_license_code => a, i_form => b);
end;
begin

delete md_license_forms t
where exists (select 1 from md_licenses f where f.license_code = t.license_code and f.project_code = 'vhr');

commit;
end;
/
