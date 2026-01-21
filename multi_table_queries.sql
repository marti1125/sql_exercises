select c.id , c.name, c.email from customer as c
left join sale as s
on c.id = s.customer_id
where s.customer_id is null

select 
  c.name as customer_name,
  to_char(s.order_date, 'Month YYYY') as order_date, 
  s.total_amount 
from sale as s
inner join customer as c
on s.customer_id = c.id
order by s.order_date desc
limit 3


select 
  c.name as customer_name,
  s.total_amount as order_amount,
  to_char(s.order_date, 'Month DD, YYYY') as order_date
from sale as s
inner join customer as c
on s.customer_id = c.id
where s.total_amount >= 500
order by s.total_amount desc



select 
  c.id,
  c.name,
  b.title,
  to_char(s.order_date, 'Month DD, YYYY') as purchase_date
from sale as s
inner join customer as c
on s.customer_id = c.id
inner join book as b
on s.book_id = b.id
where b.author = 'Harper Lee'


select 
  c.name, 
  c.email, 
  COALESCE(r.name, '- None -') AS referred_by
from customer c
left join customer r on c.referred_by = r.id



select 
  c.name as customer_name,
  b.title as common_book,
  s2.order_date as purchase_date
from sale as s
inner join sale s2
  on s.book_id = s2.book_id
  and s.customer_id = 1
  and s2.customer_id != 1  
inner join customer as c
on s2.customer_id = c.id
inner join book as b
on s.book_id = b.id
order by c.name, b.title



select 
  b1.title as title_1,
  b2.title as title_2,
  b1.price
from book b1
inner join book b2
on b1.price = b2.price
and b2.title < b1.title


select author from fiction_book
INTERSECT
select author from non_fiction_book;



select id, title, price, 'Fiction' as section from fiction_book
  where price > 20
UNION
select id, title, price, 'Non-Fiction' as section from non_fiction_book
  where price > 20
UNION
select id, title, price, 'Summer Read' as section from summer_read
  where price > 20;


select title from tech_book
EXCEPT
select title from trending_book;
