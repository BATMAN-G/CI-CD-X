FROM mysql:latest 
# Copy the SQL script into the entrypoint directory  
# MySQL will automatically execute this script on startup 
COPY    ./ init.sql    /docker-entrypoint-initdb.d/
