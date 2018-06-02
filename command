load database
    from 'db/development.sqlite3'
    into postgresql:///elgransuspiro_pos_development

with include drop, create tables, create indexes, reset sequences

set work_mem to '16MB', maintenance_work_mem to '512 MB';
