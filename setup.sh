#!/bin/bash

dropdb udiddit
mkdir -p "./data"
wget -O "./data/bad-db.sql" https://video.udacity-data.com/topher/2020/February/5e548a9f_bad-db/bad-db.sql
createdb udiddit
psql -d udiddit -f "./data/bad-db.sql"
psql -d udiddit -f "./scripts/create.sql"
psql -d udiddit -f "./scripts/migrate.sql"
