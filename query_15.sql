--customer retention: it refers to a company's ability to turn customers into repeat buyers and prevent them from switching to a competitor.
--for each day, find the number of retention (with respect to previous day) for this company.

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;


--select * from transactions


with cte as (
select *, 
lag(order_date, 1) over(partition by cust_id order by order_date) as lag_date
from transactions)
, month_diffs as (
select *, 
case when (month(order_date) - month(lag_date)) = 1 then 1 else 0 end as month_diff
from cte)
, is_there_lag as (
select *, 
count(lag_date) over(partition by month(order_date)) as num_retention
from month_diffs)

select month(order_date) as month, max(num_retention) as number_of_retention
from is_there_lag
where (month_diff = 0 and num_retention = 0) or (month_diff = 1 and num_retention != 0)
group by month(order_date)