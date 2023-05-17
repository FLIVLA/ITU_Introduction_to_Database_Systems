drop table if exists B;
create table B (x int, y int);
insert into B values (1, 2);

-- User 1: Sees the Phantom
begin;

-- To achieve isolation, run this:
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

select min(y) from B where x = 1;

-- Run the transaction below in a different client (tab)
-- See the file 10-phantom-user2.sql
--   begin;
--   insert into B values (1, 1);
--   commit;

-- Then repeat the read
select min(y) from B where x = 1;
commit;
