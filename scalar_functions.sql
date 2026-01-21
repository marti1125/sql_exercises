select 
  concat(initcap(first_name), ' ', initcap(last_name)) as full_name,
  lower(email) as email,
  coalesce(regexp_replace(phone, '[^0-9]', '', 'g'),  'No phone') as phone
from customer
order by id asc;



select
  name,
  (extract(year from age(current_date, join_date))*12) 
    + extract(month from age('2025-01-15', join_date))  as months,
  case
    when age(current_date, join_date) < interval '6 months' then 'Bronze'
    when age(current_date, join_date) < interval '12 months' then 'Silver'
    when age(current_date, join_date) < interval '24 months' then 'Gold'
    else 'Platinum'
  end as tier
from member
order by months desc



select
  category,
  case
    when rating >= 4.5 then 'Outstanding'
    when rating >= 4.0 then 'Good'
    when rating >= 3.5 then 'Average'
    else 'Poor'
  end as rating_group,
  count(*) as book_count
from book
group by category,
  case
    when rating >= 4.5 then 'Outstanding'
    when rating >= 4.0 then 'Good'
    when rating >= 3.5 then 'Average'
    else 'Poor'
  end
order by category asc, rating_group desc;



select
  title,
  case
    when page_count > 400 then 'Long'
    when page_count between 300 and 400 then 'Medium'
    else 'Short'
  end as length_category,
  case
    when copies_in_stock > 7 then 'High'
    when copies_in_stock between 3 and 7 then 'Medium'
    else 'Low'
  end as stock_status,
  case
    when monthly_rentals > 12 then 'High Demand'
    when monthly_rentals between 6 and 12 then 'Medium Demand'
    else 'Low Demand'
  end as popularity
from book
order by monthly_rentals desc;



select
  to_char(date_trunc('month', sale_date), 'Month YYYY') as month,
  sum(total_amount) as total_sales,
  case
    when sum(total_amount) > 500 then 'Excellent'
    when sum(total_amount) between 200 and 500 then 'Good'
    else 'Needs Improvement'
  end as performance
from book_sale
group by date_trunc('month', sale_date)
order by date_trunc('month', sale_date) asc;
