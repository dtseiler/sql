-- login.sql
-- Don Seiler, don@seiler.us

-- To use, place login.sql in directory specified by SQLPATH env var.

--
-- References & Inspirations
--

-- Tim Hall: http://www.oracle-base.com/dba/Script.php?category=miscellaneous&file=login.sql
-- Laurent Schneider: http://laurentschneider.com/wordpress/2005/06/loginsql.html
-- SET http://download.oracle.com/docs/cd/E11882_01/server.112/e16604/ch_twelve040.htm#SQPUG060
-- DEFINE http://download.oracle.com/docs/cd/E11882_01/server.112/e16604/ch_twelve017.htm#SQPUG037

--
-- General Settings
--

-- Quiet while we're working
set feedback off
set termout off

-- Set prompt to user@connection
set sqlprompt "_user'@'_connect_identifier > "

-- Some common column resizes
column file_name format a60
column member format a41
column tablespace_name format a20
column db_link format a20
column host format a20


-- Better safe than sorry
set autocommit off

-- Convert tabs to spaces
set tab off

-- Do not show variable substition
set verify off

-- Remove trailing blanks in display
set trimout on

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


-- Use /tmp as location for editfile and _date in name to avoid collisions
-- XXX Security risk, can we put this into eg $SQLPATH/.tmp/ ?
--     * No because SQLPATH can be a semicolon delimited list, eg $PATH
alter session set nls_date_format='yyyymmddhh24miss';
set editfile /tmp/tmpsp.&&_date

-- Use this date format by default
alter session set nls_date_format='yyyy/mm/dd hh24:mi:ss';
alter session set nls_timestamp_format='yyyy/mm/dd hh24:mi:ss.ff'; 

--
-- Spooling
--

-- Print elapsed time for each statement
set timing on

-- Trim trailing whitespace when spooling
set trimspool on

-- Noisy part is done
set termout on
set feedback on

-- Echo SQL statements to spool file
set echo on
