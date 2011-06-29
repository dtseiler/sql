-- login.sql
-- Don Seiler, don@seiler.us

-- Convert tabs to spaces
set tab off

-- Do not show variable substition
set verify off

-- Do not truncate long
set long 999999 longchunksize 999999

-- Display full numbers up to 15 chars
set numwidth 15

-- Display PL/SQL output
set serveroutput on size unlimited

-- Display the time in the command prompt
set time on

--
-- Editing
--
define _editor=vi
set editfile /tmp/tmpsqlplus.sql

--
-- Spooling
--

-- Print elapsed time for each statement
set timing on

-- Trim trailing whitespace when spooling
set trimspool off

-- Echo SQL statements to spool file
set echo on
