-- Check if any installed extensions have upgrades that need to be run
--   via ALTER EXTENSION ... UPDATE TO '...';
-- Many thanks to Doug Hunley (@hunleyd) for this one

select * 
from pg_available_extensions 
where installed_version is not null 
    and installed_version <> default_version;
