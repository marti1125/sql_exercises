WITH RECURSIVE category_tree AS (
    -- Base case: Start with root categories
    SELECT
        id,
        name,
        parent_id,
        1 as level,
        name as path
    FROM category
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive case: Join with child categories
    SELECT
        c.id,
        c.name,
        c.parent_id,
        t.level + 1,
        CAST(CONCAT(t.path, ' > ', c.name) AS VARCHAR(255)) as path
    FROM category c
    INNER JOIN category_tree t ON t.id = c.parent_id
)
SELECT
    name as category,
    path as full_path
FROM category_tree
ORDER BY path;




select
  title,
  category,
  price,
  round(price-(select avg(price) from book), 2) as above_average
from book
where price > (select avg(price) from book)
order by price desc;



select
  category,
  title,
  published_date,
  price
from book
where published_date in (select max(published_date) from book group by category)



with cte_category_avg as (
  select
    category,
    round(avg(stock),1) as cat_avg
  from book
  group by category
)
select b.title, b.category, b.stock, c.cat_avg as category_avg from book b
inner join cte_category_avg c
on b.category = c.category
where b.stock < c.cat_avg;



with cte_percentage_sales as (
  select
  title,
  sales_count,
   ROUND(
      sales_count * 100.0 / SUM(sales_count) OVER (),
      1
    ) AS per
  from book
)
select b.title, b.sales_count, c.per as sales_percentage from book b
inner join cte_percentage_sales c
on b.title = c.title
order by c.sales_count desc;


WITH sales_total AS (
    SELECT SUM(sales_count) as total_sales
    FROM book
)
SELECT
    title,
    sales_count,
    ROUND(
        (CAST(sales_count AS DECIMAL) / total_sales * 100),
        1
    ) as sales_percentage
FROM book
CROSS JOIN sales_total
ORDER BY sales_count DESC;



select
  book_id,
  sum(quantity)
from sale
where sale_date >= '2025-01-01'
group by book_id
limit 3;



with cte_total_sold as (
  select
    book_id,
    sum(quantity) as total_sold
  from sale
  group by book_id
  order by sum(quantity) desc
  limit 3
), cte_new_customer as (
  select
    id
  from customer
  where joined_date > '2025-01-01'
)
select b.title, s.total_sold, count(distinct a.customer_id) as new_customer_count
from cte_total_sold s
inner join book b on s.book_id = b.id
inner join sale a on a.book_id = s.book_id
inner join cte_new_customer c on c.id = a.customer_id
group by b.title, s.total_sold
order by s.total_sold desc;




WITH RECURSIVE dates AS (
    -- Base case: Start with start of month
    SELECT CAST('2025-02-01' AS DATE) as month_day

    UNION ALL

    -- Recursive case: Add one day to previous date
    SELECT month_day + 1
    FROM dates
    WHERE month_day < DATE '2025-02-10' -- stop condition
)
SELECT * FROM dates;



WITH RECURSIVE date_range AS (
    SELECT CAST('2025-01-01' AS DATE) as month_day
    UNION ALL
    SELECT month_day + 1
    FROM date_range
    WHERE month_day < DATE '2025-01-15'
)
select 
  month_day as date, 
  count(s.id) as sale_count, 
  coalesce (sum(amount), 0.00) as total_amount 
from date_range c
left join sale s on s.sale_date = c.month_day
group by month_day
