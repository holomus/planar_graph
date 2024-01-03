prompt drop constraint from hpd_page_adjustments
----------------------------------------------------------------------------------------------------
alter table hpd_page_adjustments drop constraint hpd_page_adjustments_c5;
alter table hpd_page_adjustments add constraint hpd_page_adjustments_c5 check (kind = 'I' or free_time >= turnout_time);
