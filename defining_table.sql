create table book_inventory(
  id integer primary key,
  isbn varchar(13) not null unique,
  title varchar(200) not null,
  author varchar(100) not null,
  price decimal(10,2) not null check (price > 0),
  pages integer check (pages > 0),
  in_stock boolean not null default true,
  publish_year integer not null,
  last_updated timestamp not null default current_timestamp
);

create table events(
  id integer primary key,
  title varchar(100) not null,
  start_time timestamp not null,
  end_time timestamp not null,
  created_at timestamp not null default current_timestamp
);

ALTER TABLE events
ADD CONSTRAINT ck_start_time CHECK (start_time >= now());

ALTER TABLE events
ADD CONSTRAINT ck_start_end_time CHECK (end_time > start_time);


select 
  book_title, 
  to_char(sale_date, 'Month DD, YYYY') as sale_date, 
  quantity,
  extract(quarter from sale_date) as sale_quarter,
  amount
from sales
WHERE
  sale_date BETWEEN '2024-05-16' and '2024-12-18'
  and quantity > 1
order by sale_date, amount desc;


alter table products
drop column description;

alter table products
add column category varchar(50) not null;

alter table products
alter column price type decimal(12,2);

alter table products
drop constraint chk_stock;

alter table products
add constraint unq_product_name unique(product_name);

truncate table products;
