-- Week 3: Advanced SQL
--         Examples of Bills


-- 85: Show ID and name of all female (‘F’) customers who have 
--     an unpaid bill larger than the balance plus 
--     overdraft allowance on one of their accounts.
select distinct P.PID, P.pName
from People P
	join Accounts A on P.PID = A.PID
	join Bills B on P.PID = B.PID
where P.pGender = 'F'
  and not B.bIsPaid
  and B.bAmount > A.aBalance + A.aOver;

-- 86: Show ID and name of all male (‘M’) customers who 
--     have an unpaid bill that is larger than their total balance 
--     (not including overdraft allowance), along with the ID of the bill.
select distinct P.PID, P.pName, B.BID, B.bAmount, sum(A.aBalance)
from People P
	join Accounts A on P.PID = A.PID
	join Bills B on P.PID = B.PID
where P.pGender = 'M'
  and not B.bIsPaid
group by P.PID, P.pName, B.BID, B.bAmount
having B.bAmount > sum(A.aBalance)
order by P.PID, B.BID;

-- 88: Show ID and name of people that are taller than 1.75 
--     or have an account with a negative balance
select P.PID, P.pName
from People P
where P.pHeight > 1.75
union
select P.PID, P.pName
from People P join Accounts A on P.PID = A.PID
where A.aBalance < 0;

-- Using ORDER BY to get ID order
select P.PID, P.pName
from (
	select P.PID, P.pName
	from People P
	where P.pHeight > 1.75
	union
	select P.PID, P.pName
	from People P join Accounts A on P.PID = A.PID
	where A.aBalance < 0) P
order by P.PID;

-- 89: Show all people that are taller than 1.75 or 
--     have an account with a negative balance
-- Using ... OR ... IN ... 
select P.PID, P.pName
from People P
where P.pHeight > 1.75
or P.PID in (
	select P.PID
	from People P join Accounts A on P.PID = A.PID
	where A.aBalance < 0
);

-- 90: Show ID and name of people who are female and 
--     hold an account record with amount > 10000
select P.PID, P.pName
from People P
where P.pGender = 'F'
intersect
select P.PID, P.pName
from People P
	join Accounts A on P.PID = A.PID
	join AccountRecords R on R.AID = A.AID
where R.rAmount > 10000;

-- 91: Show ID and name of all people who are female and 
--     hold an account record with amount > 10000
-- Using ... AND ... IN ... 
select P.PID, P.pName
from People P
where P.pGender = 'F'
and P.PID in (
	select P.PID
	from People P
		join Accounts A on P.PID = A.PID
		join AccountRecords R on R.AID = A.AID
	where R.rAmount > 10000
);

-- 92: Show ID and name of people with a name starting with B 
--     but who have no unpaid bills
select P.PID, P.pName
from People P
where P.pName like 'B%'
except
select P.PID, P.pName
from People P join Bills B on P.PID = B.PID
where not B.bIsPaid;

-- 93: Show ID and name of people with a name starting with B 
--     but who have no unpaid bills
-- Using ... AND ... NOT IN ... 
select P.PID, P.pName
from People P
where P.pName like 'B%'
  and P.PID not in (
	select P.PID
	from People P
		join Bills B on P.PID = B.PID
	where not B.bIsPaid );

