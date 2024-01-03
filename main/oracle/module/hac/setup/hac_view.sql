prompt Verifix Access Control management systems integrations views
----------------------------------------------------------------------------------------------------
create or replace view hac_dahua_servers_view as
select q.server_id,
       q.host_url,
       q.name,
       q.order_no,
       p.username,
       p.password
  from Hac_Servers q
  join Hac_Dss_Servers p
    on p.Server_Id = q.Server_Id;
    
create or replace view hac_hikcentral_servers_view as
select q.server_id,
       q.host_url,
       q.name,
       q.order_no,
       p.partner_key,
       p.partner_secret
  from Hac_Servers q
  join Hac_Hik_Servers p
    on p.Server_Id = q.Server_Id;
