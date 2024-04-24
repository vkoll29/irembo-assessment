# irembo-assessment
In the interest of time, this is my final submission for this assessment. 

The file sales_job.sql contains all the Flink SQL commands that I ran in order to set up the source and sink tables. Unfortunately, I faced a couple of challenges especially with
getting the postgres-cdc connector to work properly. On my own, I will continue working on this project to fully implement the
real-time ETL pipeline. However, in recognizing how gracious you have been with your time, I am submitting this as my final 
solution. Please let me know if you need any clarification or have additional feedback.


### Notes
 * I initially implemented the source tables manually through the script defined in helper/populate_tables.py.
 * I am currently implementing the flink job that sinks data from Postgres CDC logs into the sink tables in clickhouse. This
   will make the tables dynamic and updated in real-time as data changes in
 * You will notice that I have to infrastructure definition directories. I started by spinning up a compute instance on Azure
   ut then migrated to using Docker containers for everything including the jobmanager and taskmanagers.


### FLink jobmanager container additional configs
* Download postgres-cdc connector: wget https://repo1.maven.org/maven2/com/ververica/flink-sql-connector-postgres-cdc/3.0.1/flink-sql-connector-postgres-cdc-3.0.1.jar
* DOwnload jdbc connector: wget https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc/3.1.2-1.18/flink-connector-jdbc-3.1.2-1.18.jar
* Get postgresjdbc wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar
* Get clickhouse driver: wget https://repo1.maven.org/maven2/com/clickhouse/clickhouse-jdbc/0.6.0/clickhouse-jdbc-0.6.0.jar
* Get flink-sql-clickhouse connector: wget https://repo1.maven.org/maven2/name/nkonev/flink/flink-sql-connector-clickhouse/1.17.1-9/flink-sql-connector-clickhouse-1.17.1-9.jar

[//]: # (* Download jdbc driver bundle: https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-jdbc-driver-bundle/1.19.0/flink-sql-jdbc-driver-bundle-1.19.0.jar)




