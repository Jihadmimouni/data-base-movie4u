#creating connection to salplus using system()
import os
import shutil
shutil.copy2("data base architect/fonctions 1.sql","./f1")
shutil.copy2("data base architect/data base.sql","./db")
shutil.copy2("data base architect/fonctions 2.sql","./f2")
os.system("sqlplus SYSTEM/1234@localhost:1521/XE as sysdba @f1")
os.system("sqlplus movie4u/test1234@localhost:1521/XE @db")
os.system("sqlplus movie4u/test1234@localhost:1521/XE @f2")