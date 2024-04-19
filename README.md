# irembo-assessment
Contains my solution for Irembo SDE test

### Notes
 * I initially implemented the source tables manually through the script defined in helper/populate_tables.py.
 * I am currently implementing the flink job that sinks data from Postgres CDC logs into the sink tables in clickhouse. This
   will make the tables dynamic and updated in real-time as data changes in
 * You will notice that I have to infrastructure definition directories. I started by spinning up a compute instance on Azure
   ut then migrated to using Docker containers for everything including the jobmanager and taskmanagers.
 * 