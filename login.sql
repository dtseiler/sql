-- login.sql
-- Don Seiler, don@seiler.us

-- Convert tabs to spaces
set tab off

-- Do not show variable substition
set verify off

-- Do not truncate long
set long 999999 longc 999999

-- Display full numbers up to 15 chars
set numwidth 15

--
-- Editing
--
define _editor=vi
set editfile /tmp/tmpsqlplus.sql

--
-- Spooling
--

-- Echo SQL statements to spool file
set echo on

-- Print elapsed time for each statement
set timing on

-- Trim trailing whitespace when spooling
set trimspool off

