-- login.sql
-- Don Seiler, don@seiler.us

-- To use, place login.sql in directory specified by SQLPATH env var.

-- Use this date format by default
alter session set nls_date_format='yyyy/mm/dd hh24:mi:ss';

-- Better safe than sorry
set autocommit off

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

-- Use vi as editor (must be in PATH)
define _editor=vi

-- Use /tmp as location for edit file
-- XXX Increases chances of collisions with multiple users
--     * can we randomize file name with something like PID?
set editfile /tmp/tmpsqlplus.sql

--
-- Spooling
--

-- Print elapsed time for each statement
set timing on

-- Trim trailing whitespace when spooling
set trimspool on

-- Echo SQL statements to spool file
set echo on
