prompt htm recommended changes
----------------------------------------------------------------------------------------------------
update htm_recommended_rank_documents t
   set t.status =
       (select case q.posted
                 when 'Y' then
                  'A'
                 else
                  'N'
               end
          from htm_recommended_rank_documents q
         where q.company_id = t.company_id
           and q.filial_id = t.filial_id
           and q.document_id = t.document_id);

commit;
