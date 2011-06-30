-- login.sql
-- Don Seiler, don@seiler.us

-- To use, place login.sql in directory specified by SQLPATH env var.

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

-- Quiet while we're working
set feedback off

-- Use /tmp as location for edit file
-- Use _date in name to avoid collisions
-- XXX Security risk, can we put this into eg $SQLPATH/.tmp/ ?
alter session set nls_date_format='yyyymmddhh24miss';
set editfile /tmp/tmpsp.&&_date

-- Use this date format by default
alter session set nls_date_format='yyyy/mm/dd hh24:mi:ss';

-- Noisy part is done
set feedback on

--
-- Spooling
--

-- Print elapsed time for each statement
set timing on

-- Trim trailing whitespace when spooling
set trimspool on

-- Echo SQL statements to spool file
set echo on
