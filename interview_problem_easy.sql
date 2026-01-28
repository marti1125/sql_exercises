-- Major Cities
select city_name from World
where area > 3000 or population > 5000000

-- Not boring movies
select * from Cinema
where description <> 'boring'
and id % 2 = 1
order by rating desc

-- Triangle Judgement
select x,y,z,
case
  when 
    x + y > z
    and x + z > y
    and y + z > x
  then 'Yes'
  else 'No'
  end as triangle
from
Triangle

-- Biggest Single Number
select max(num) as num from MyNumbers
where num not in (select num from MyNumbers group by num having count(num) > 1)

-- Product Sales Analysis I
select p.product_name, s.year, s.price
from Sales as s
inner join Product as p
on p.product_id = s.product_id
order by s.year

-- Product Sales Analysis II
select s.product_id, sum(s.quantity) as total_quantity
from Sales as s
inner join Product as p
on s.product_id = p.product_id
group by s.product_id

-- Game Play Analysis I
select player_id, min(event_date) as first_login
from Activity
group by player_id

-- Game Play Analysis II
select distinct (player_id), FIRST_VALUE(device_id) OVER (
                    PARTITION BY player_id
                    ORDER BY event_date
                ) AS device_id
from Activity

-- Queries Quality and Percentage
select query_name,
round(avg(rating/position), 2) as quality,
round(Sum(IF(rating < 3, 1, 0)) / Count(*) * 100, 2) as poor_query_percentage
from Queries
group by query_name

-- Average Selling Price
select 
  p.product_id, 
  ifnull(round(sum(p.price * u.units) / sum(u.units), 2), 0) as average_price 
from Prices p
left join UnitsSold u
  on p.product_id = u.product_id
  and u.purchase_date between p.start_date and p.end_date
group by product_id;
