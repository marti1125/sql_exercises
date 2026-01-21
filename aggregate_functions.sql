SELECT
  count(*) as total_transactions,
  sum(quantity) as total_books,
  round(avg(price), 2) as avg_price,
  sum(price * quantity) as total_revenue
FROM book_sale


select
  c.name as category_name,
  count(*) as book_count,
  sum(b.in_stock) as total_stock,
  round(avg(b.price),2) as avg_price
from book b
inner join category c
on b.category_id = c.id
group by c.name
order by book_count desc;


select
  a.name as author_name,
  count(b.author_id) as book_count,
  case 
    when count(b.author_id) >= 3 then 'Prolific Author'
    when count(b.author_id) = 2 then 'Established Author' 
    else 'New Author'
  end as author_tier
from book b
inner join author a
on b.author_id = a.id
group by a.name
order by book_count desc;



select
  a.name as author_name,
  count(b.author_id) as book_count,
  round(avg(b.price),2) as avg_price,
  sum(b.pages) as total_pages
from book b
inner join author a
on b.author_id = a.id
group by a.name
order by book_count desc;


select 
  sale_date,
  count(sale_date) as transactions,
  sum(quantity) as books_sold,
  sum(price * quantity) as daily_revenue
from daily_sale
group by sale_date;



select
  p.name as publisher_name,
  count(b.publisher_id) as book_count,
  sum(b.stock_level) as total_stock,
  round(avg(b.price),2) as avg_price,
  count(case 
    when b.stock_level = 0 then 1 end
  ) as out_of_stock
from book b 
inner join publisher p
on b.publisher_id = p.id
group by p.name, p.id
order by book_count desc;


select
  p.name as publisher_name,
  count(b.publisher_id) as book_count,
  round(avg(b.price),2) as avg_price,
  sum(b.stock_level) as total_stock  
from book b 
inner join publisher p
on b.publisher_id = p.id
group by p.name
having  
  count(b.publisher_id) > 1
  and 
  round(avg(b.price),2) > 35
  and
  sum(b.stock_level) > 30
order by avg_price desc;



select
  a.name as author_name,
  count(b.author_id) as book_count,
  round(avg(b.price),2) as avg_price,
  round(avg(b.rating),2) as avg_rating
from book b
inner join author a
on b.author_id = a.id
group by a.name
having
  count(b.author_id) >= 2
  and
  round(avg(b.price),2) > 40
  and
  round(avg(b.rating),2) > 4.5
order by avg_rating desc;



select
  b.category,
  count(*) as total_sales,
  sum(s.quantity) as total_quantity,
  sum(s.quantity * s.unit_price) as total_revenue,
  round(avg(s.unit_price),2) as avg_price,
  max(s.quantity) as max_quantity
from sale s
inner join book b
on s.book_id = b.id
group by b.category
having sum(s.quantity * s.unit_price) > 50
order by total_revenue desc;



select
  m.name as manager_name,
  count(distinct e.id) as team_size,
  sum(s.amount) as total_team_sales,
  round(sum(s.amount) / count(distinct e.id), 2) as avg_sale_per_member
from employee m
inner join employee e
on e.manager_id = m.id
left join sale s
on s.employee_id = e.id
group by m.name
order by total_team_sales desc;
