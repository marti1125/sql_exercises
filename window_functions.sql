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


