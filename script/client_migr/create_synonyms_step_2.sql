prompt newuser operations
set define on;
set serveroutput on;
undefine dumpuser
define dumpuser=&dumpuser

exec dbms_output.enable(null);

prompt create synonyms
exec &dumpuser..create_synonyms(user, '&dumpuser');
