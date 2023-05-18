FROM postgres:14

COPY initdb/ /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/requirements_schema.sql
