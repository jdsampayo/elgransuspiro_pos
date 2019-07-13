# README

## TODO
history
income per day

*inventory
*cost per provider (company)
*shopping list
*** formula de Wilson

# Dump de DB
`pg_dump elgransuspiro_pos_development > elgransuspiro.bak`

# Subir dump
`scp elgransuspiro.bak linode:~/.`

# Restablecer dump
`RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop`
`RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:create`
`psql -Uelgransuspiro  elgransuspiro_pos_production < elgransuspiro.bak`


sudo -u postgres createuser --superuser pepito
ALTER USER pepito WITH PASSWORD 'eldeloscuentos123';

psql -U db_user db_name < dump_name.sql

# Limpiar sidekiq
Sidekiq.redis { |conn| conn.flushdb }

