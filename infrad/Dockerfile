# Use Flink base image for version 1.18.1
FROM apache/flink:1.18.1

# Set working directory
WORKDIR /opt/flink

# Download postgres-cdc connector
RUN wget https://repo1.maven.org/maven2/com/ververica/flink-sql-connector-postgres-cdc/3.0.1/flink-sql-connector-postgres-cdc-3.0.1.jar -O ./lib/flink-sql-connector-postgres-cdc-3.0.1.jar

# Download jdbc connector
RUN wget https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc/3.1.2-1.18/flink-connector-jdbc-3.1.2-1.18.jar -O ./lib/flink-connector-jdbc-3.1.2-1.18.jar

# Download postgres jdbc driver
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar -O ./lib/postgresql-42.7.2.jar
