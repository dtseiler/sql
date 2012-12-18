--
-- tbs_free.sql
--
-- Measure free space in all tablespaces, taking autoextensible datafiles into account
--
select a.tablespace_name
        , round(a.b_allocated/1024/1024/1024, 2) total_gb
        , round((b.b_free+a.b_unallocated)/1024/1024/1024,2) free_gb
        , round(((b.b_free+a.b_unallocated)/a.b_allocated)*100, 2) free_pct
from (
        select tablespace_name
                , sum(b_allocated) b_allocated
                , sum(b_unallocated) b_unallocated
        from (
                select tablespace_name, bytes b_allocated, 0 b_unallocated
                from dba_data_files
                where autoextensible='NO'
                union all
                select tablespace_name, maxbytes b_allocated, maxbytes-bytes b_unallocated
                from dba_data_files
                where autoextensible='YES'
        )
        group by tablespace_name
) a, (
        select tablespace_name, sum(bytes) b_free
        from dba_free_space
        group by tablespace_name
) b
where a.tablespace_name=b.tablespace_name(+)
order by a.tablespace_name;
