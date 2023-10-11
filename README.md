# Lab4.1

ID:bb0460aee23e 
docker-compose up -d
docker cp dbcreate.sql bb0460aee23e:/home/oracle
docker cp dbdrop.sql bb0460aee23e:/home/oracle
docker cp dbload.sql bb0460aee23e:/home/oracle
docker cp solution3.sql bb0460aee23e:/home/oracle
docker cp solution2.sql bb0460aee23e:/home/oracle
docker cp solution1.sql bb0460aee23e:/home/oracle
docker ps -a
ls -la ->list the file name
docker exec -it bb0460aee23e  bash
sqlplus / as sysdba
@dbcreate.sql
@dbdrop.sql
@solution1.sql
@solution2.sql
docker cp bb0460aee23e:/home/oracle/solution1.lst ./
docker cp bb0460aee23e:/home/oracle/solution2.lst ./