prompt ui_anor557_rank_changes
exec fazo_z.Drop_Object_If_Exists('ui_vhr557_rank_changes');
create global temporary table ui_vhr557_rank_changes(
  staff_id             number(20)         not null,
  robot_id             number(20)         not null,
  change_date          date               not null,
  transfer_end_date    date,
  source_document_name varchar2(120 char) not null,
  employee_name        varchar2(752 char) not null,
  rank_name            varchar2(200 char) not null
);

create index ui_vhr557_rank_changes_i1 on ui_vhr557_rank_changes(staff_id);
