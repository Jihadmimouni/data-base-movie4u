#creating connection to salplus using system()
import os
import shutil
import subprocess
shutil.copy2("data base architect/fonctions 1.sql","./f1.sql")
shutil.copy2("data base architect/data base.sql","./db.sql")
shutil.copy2("data base architect/fonctions 2.sql","./f2.sql")

def run_sqlplus(sqlplus_script):

    """
    Run a sql command or group of commands against
    a database using sqlplus.
    """

    p = subprocess.Popen(['sqlplus','/nolog'],stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    (stdout,stderr) = p.communicate(sqlplus_script.encode('utf-8'))
    stdout_lines = stdout.decode('utf-8').split("\n")

    return stdout_lines

script="""
    connect {user}/{password}@localhost:1521/XE as sysdba
    @"{path1}"
    connect movie4u/test1234@localhost:1521/XE
    @"{path2}"
    @"{path3}"
    exit
"""

output = run_sqlplus(script.format(user=input("give the username : "),password=input("give the password : "),path1=os.path.abspath("f1.sql"),path2=os.path.abspath("db.sql"),path3=os.path.abspath("f2.sql")))
os.remove("f1.sql")
os.remove("db.sql")
os.remove("f2.sql")
try:
    os.remove("log.txt")
except:
    pass
for line in output:
    print(line)
    with open("log.txt","a") as f:
        f.write(str(line))

