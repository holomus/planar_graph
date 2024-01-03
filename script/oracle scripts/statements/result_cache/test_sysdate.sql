create or replace Function Invoice_Date return varchar2 Result_Cache authid definer is
  l_Date varchar2(50);
begin
  l_Date := to_char(sysdate, 'dd.mm.yyyy hh24:mi:ss');
  return l_Date;
end;
/

declare
begin
  dbms_output.put_line(Invoice_Date);
end;
/
declare
begin
  dbms_session.sleep(5);
  dbms_output.put_line(Invoice_Date);
end;
/
