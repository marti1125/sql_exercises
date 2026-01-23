SELECT
    employee_name,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY employee_name) as total_sales
FROM sale
ORDER BY sale_date, employee_name;


SELECT
    book_title,
    category,
    price,
    ROUND(AVG(price) OVER(), 2) as overall_avg_price
FROM sale;


SELECT
    book_title,
    category,
    price,
    round(AVG(price) OVER(PARTITION BY category),2) as category_avg_price
FROM sale
ORDER BY category, price;


SELECT
    sale_date,
    category,
    price,
    AVG(price) OVER(PARTITION BY category, sale_date) as daily_category_avg
FROM sale
ORDER BY sale_date, category;


SELECT
    category,
    price,
    AVG(price) OVER(PARTITION BY category) as avg_price,
    MIN(price) OVER(PARTITION BY category) as min_price,
    MAX(price) OVER(PARTITION BY category) as max_price,
    COUNT(*) OVER(PARTITION BY sale_date) as total_books_sold
FROM sale
ORDER BY category, price;


SELECT
    category,
    price,
    AVG(price) OVER w_category as avg_price,
    MIN(price) OVER w_category as min_price,
    MAX(price) OVER w_category as max_price,
    COUNT(*) OVER w_sale_date as total_books_sold
FROM
    sale
WINDOW
    w_category AS (PARTITION BY category),
    w_sale_date AS (PARTITION BY sale_date)
ORDER BY
    category, price;


SELECT
    book_title,
    price,
    SUM(price) OVER(order by price) as total_price
FROM sale;


SELECT
    book_title,
    price,
    FIRST_VALUE(book_title) OVER(ORDER BY price) as cheapest_book
FROM sale;


SELECT
    book_title,
    price,
    FIRST_VALUE(book_title) OVER(ORDER BY price DESC) as most_expensive_book
FROM sale;


SELECT
    book_title,
    price,
    FIRST_VALUE(book_title) OVER(ORDER BY price ASC) as cheapest_book,
    FIRST_VALUE(book_title) OVER(ORDER BY price DESC) as most_expensive_book
FROM sale;



SELECT
    category,
    book_title,
    price,
    SUM(price) OVER(
        PARTITION BY category
        ORDER BY price
    ) as category_running_total
FROM sale;


SELECT
    book_title,
    revenue,
    ROW_NUMBER() OVER(ORDER BY revenue DESC) as revenue_rank
FROM sale
ORDER BY revenue_rank;


SELECT
    category,
    book_title,
    revenue,
    ROW_NUMBER() OVER(
        PARTITION BY category
        ORDER BY revenue DESC
    ) as category_rank
FROM sale
ORDER BY category, category_rank;


SELECT
    book_title,
    copies_sold,
    RANK() OVER(ORDER BY copies_sold DESC) as sales_rank
FROM sale
ORDER BY sales_rank;


SELECT
    book_title,
    copies_sold,
    DENSE_RANK() OVER(ORDER BY copies_sold DESC) as dense_rank
FROM sale
ORDER BY dense_rank;


SELECT
    book_title,
    copies_sold,
    ROW_NUMBER() OVER(ORDER BY copies_sold DESC) as row_num,
    RANK() OVER(ORDER BY copies_sold DESC) as rank,
    DENSE_RANK() OVER(ORDER BY copies_sold DESC) as dense_rank
FROM
    sale
ORDER BY
    row_num asc,
    book_title;



SELECT
    sale_date,
    book_title,
    revenue,
    SUM(revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN
            UNBOUNDED PRECEDING AND
            CURRENT ROW
    ) as running_total
FROM sale
ORDER BY sale_date;


SELECT
    sale_date,
    book_title,
    revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN
            2 PRECEDING AND
            CURRENT ROW
    ), 2) as moving_avg
FROM sale
ORDER BY sale_date;


-- Using ROWS
SELECT
    sale_date,
    book_title,
    revenue,
    SUM(revenue) OVER (
        ORDER BY sale_date
        -- Notice: ROWS BETWEEN
        ROWS BETWEEN
            CURRENT ROW AND
            1 FOLLOWING
    ) as next_day_total
FROM sale
ORDER BY sale_date;


-- Using RANGE
SELECT
    sale_date,
    book_title,
    revenue,
    SUM(revenue) OVER (
        ORDER BY sale_date
        -- Notice: RANGE BETWEEN
        RANGE BETWEEN
            CURRENT ROW AND
            INTERVAL '1 day' FOLLOWING
    ) as next_day_total
FROM sale
ORDER BY sale_date;



SELECT
    book_title,
    revenue,
    NTH_VALUE(book_title, 2) OVER(
        ORDER BY revenue DESC
        ROWS BETWEEN
            UNBOUNDED PRECEDING AND
            UNBOUNDED FOLLOWING
    ) as second_most_expensive
FROM sale;


SELECT
    book_title,
    revenue,
    NTH_VALUE(book_title, 2) OVER (
        ORDER BY revenue ASC
        ROWS BETWEEN
            UNBOUNDED PRECEDING AND
            UNBOUNDED FOLLOWING
    ) AS second_cheapest
FROM sale;


-- Exercises

select
  book_title,
  category,
  price,
  round(avg(price) over(partition by category),2) as category_avg
from sale
order by category asc, price desc


select
  title,
  category,
  copies_sold,
  first_value(title) over(partition by category order by copies_sold desc) as category_bestseller,
  nth_value(title, 2) over(
    partition by category order by copies_sold desc
    range between
      unbounded preceding and
      unbounded following
  ) as second_bestseller
from book
order by category asc, copies_sold desc;



select
  a.name as author_name,
  b.title,
  b.category,
  b.copies_sold,
  round(avg(b.copies_sold) over(partition by b.category), 2) as category_avg
from book b
inner join author a
on b.author_id = a.id
order by b.category asc, b.copies_sold desc;


select
  a.name as author_name,
  a.country,
  sum(b.copies_sold) as total_copies,
  rank() over(order by sum(b.copies_sold) desc) as author_rank
from book b
inner join author a
on b.author_id = a.id
group by a.id, a.name, a.country
order by author_rank
limit 3;



select
  title,
  case
    when price < 30 then 'Budget'
    when price <= 40 then 'Standard'
    else 'Premium'
  end as price_tier,
  price,
  copies_sold,
  rank() over(
    partition by case
    when price < 30 then 'Budget'
    when price <= 40 then 'Standard'
    else 'Premium'
    end
    order by copies_sold desc
  )
  as tier_rank
from book



select
  title,
  sale_month,
  copies_sold as current_sales, 
  lag(copies_sold) 
    over(partition by title order by sale_month) as prev_sales,
  copies_sold - lag(copies_sold) 
    over(partition by title order by sale_month) as sales_change,
  round((copies_sold - lag(copies_sold) 
    over(partition by title order by sale_month)) * 100.0 / lag(copies_sold) 
    over(partition by title order by sale_month),1) 
  as pct_change
from sale
order by title asc, sale_month asc



SELECT
  title,
  price,
  copies_sold,
  round(
    avg(copies_sold) OVER (
      ORDER BY price 
      RANGE BETWEEN 5 preceding AND 5 following
    ),0) AS similar_price_avg,
  count(*) over(
     order by price
     RANGE BETWEEN 5 preceding AND 5 following
  ) as books_in_range
FROM
  book
ORDER BY
  price ASC,
  title ASC
