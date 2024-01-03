create public database link erp connect to smartup5x_erp identified by greenwhite using
'(DESCRIPTION = (ADDRESS_LIST = (LOAD_BALANCE=off) (FAILOVER=ON)(ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.1.11)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.1.12)(PORT = 1521)))(CONNECT_DATA = (SERVICE_NAME = sx_stby)))';
