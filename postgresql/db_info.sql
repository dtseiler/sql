select datname, 
    pg_get_userbyid(datdba) as owner,
    pg_encoding_to_char(encoding) as encoding, 
    datcollate, 
    datctype, 
    pg_database_size(datname)/1024/1024 as size_mb
from pg_database
order by datname;
