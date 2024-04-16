create_container = "$ docker run --name irm-pg -e POSTGRES_PASSWORD=Test1234! -d postgres"
create_db = "$ docker exec -it irm-pg psql -U postgres -c \"CREATE DATABASE irembo;\""