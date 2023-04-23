alter session set "_ORACLE_SCRIPT"=true;  
create user movie4u identified by test1234;
grant all privileges to movie4u;
grant create SESSION to movie4u;