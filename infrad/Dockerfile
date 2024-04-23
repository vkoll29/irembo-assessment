# Use a base image with Maven pre-installed
FROM maven:3.8.4-openjdk-11 AS builder

# Set the working directory in the container
WORKDIR /app

# Download Flink source code
RUN git clone https://github.com/apache/flink.git .

# Build Flink
RUN mvn clean install -DskipTests

# Switch to a lighter-weight image for the runtime environment
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled Flink JAR from the builder stage
COPY --from=builder /app/flink-dist/target/flink--bin/flink-/ /app

# Expose Flink ports
EXPOSE 6123 8081

# Start Flink
CMD ["bin/start-cluster.sh"]